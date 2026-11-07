local env = (getgenv and getgenv()) or _G
if env.PurpleTown then pcall(env.PurpleTown.Destroy) end
if env.PurpleHCF then pcall(env.PurpleHCF.Destroy) end
local Players = game:GetService('Players')
local UIS = game:GetService('UserInputService')
local RS = game:GetService('RunService')
local LP = Players.LocalPlayer
local PlayerGui = LP:WaitForChild('PlayerGui')
local GuiService = game:GetService('GuiService')
local HttpService = game:GetService('HttpService')
local upvalues = (debug and debug.getupvalues) or getupvalues
assert(getgc and hookfunction and upvalues, 'PurpleHCF: executor needs getgc, hookfunction and getupvalues')
local function resolveClient(objects)
    local records, cache, unreadable = {}, {}, 0
    local function valuesFor(fn)
        if type(fn) ~= 'function' then return nil end
        if cache[fn] ~= nil then return cache[fn] or nil end
        local ok, values = pcall(upvalues, fn)
        if not ok or type(values) ~= 'table' then cache[fn] = false; unreadable = unreadable + 1; return nil end
        cache[fn] = values
        return values
    end
    local function methods(value, ...)
        if type(value) ~= 'table' then return false end
        for _, key in ipairs({...}) do if type(rawget(value, key)) ~= 'function' then return false end end
        return true
    end
    local function network(value)
        return type(value) == 'table' and rawget(value, 'Attack') ~= nil and rawget(value, 'Throw') ~= nil and rawget(value, 'State') ~= nil
    end
    local function indexOf(values, expected)
        if expected == nil then return nil end
        for index, value in pairs(values) do if value == expected and type(index) == 'number' then return index end end
    end
    for _, fn in pairs(objects) do
        if type(fn) == 'function' then
            local values = valuesFor(fn)
            if values then table.insert(records, {fn = fn, values = values}) end

        end
    end
    local anchors = {}
    for _, record in ipairs(records) do
        local v = record.values
        if methods(v[5], 'selectedItem', 'take', 'swapSlots', 'setOpen') and methods(v[13], 'distanceToBox', 'hitbox', 'eye', 'tick')
            and network(v[16]) and methods(v[23], 'isAlly', 'active', 'frozen') and methods(v[25], 'mouseTurn', 'held') and type(v[19]) == 'table' then
            local score = 0
            if type(v[9]) == 'table' and typeof(rawget(v[9], 'position')) == 'Vector3' then score = score + 8 end
            if type(rawget(v[5], 'items')) == 'table' and next(v[5].items) ~= nil then score = score + 1 end
            if next(v[19]) ~= nil then score = score + 1 end
            if type(getfenv) == 'function' then
                pcall(function()
                    local scriptObject = getfenv(record.fn).script
                    if typeof(scriptObject) == 'Instance' and scriptObject:IsDescendantOf(LP) then score = score + 16 end
                end)
            end
            table.insert(anchors, {record = record, score = score})
        end
    end
    table.sort(anchors, function(a, b) return a.score > b.score end)
    local lastMissing, fallback = 'native attack layout', nil
    for _, anchor in ipairs(anchors) do
        local v = anchor.record.values
        local inventory, physics, match, settings, net = v[5], v[13], v[23], v[25], v[16]
        local resolved = {attack = anchor.record.fn, stateOwner = anchor.record.fn, net = net}
        local helperRecords, helperSeen = {}, {}
        local function followHelper(fn, depth)
            if helperSeen[fn] or #helperRecords >= 2000 then return end
            helperSeen[fn] = true
            local values = valuesFor(fn)
            if not values then return end
            table.insert(helperRecords, {fn = fn, values = values})
            if depth < 3 then
                for _, value in pairs(values) do if type(value) == 'function' then followHelper(value, depth + 1) end end
            end
        end
        for _, record in ipairs(records) do
            if indexOf(record.values, inventory) and indexOf(record.values, net) and (indexOf(record.values, match) or indexOf(record.values, physics)) then followHelper(record.fn, 0) end
        end
        local bowScore = 0
        for _, record in ipairs(helperRecords) do
            local u = record.values
            if indexOf(u, inventory) and indexOf(u, match) and indexOf(u, net) and indexOf(u, v[6]) then
                for _, value in pairs(u) do
                    if type(value) == 'function' then
                        local loose = valuesFor(value)
                        if loose and indexOf(loose, inventory) and indexOf(loose, physics) and indexOf(loose, net) then
                            local throwable, bow = false, false
                            for _, part in pairs(loose) do
                                if methods(part, 'launch', 'bowPower') then throwable = true end
                                if type(part) == 'table' and type(rawget(part, 'fullDrawTicks')) == 'number' and type(rawget(part, 'minPower')) == 'number' then bow = true end
                            end
                            if throwable and bow then
                                local exact = u[1] == v[6] and u[4] == inventory and u[6] == match and u[7] == value and u[8] == net
                                local score = exact and 10 or 1
                                if score > bowScore then
                                    bowScore, resolved.bowUpdate, resolved.looseArrow = score, record.fn, value
                                    resolved.bowStateIndex = exact and 5 or nil
                                end
                            end
                        end
                    end
                end
            end
        end
        if methods(v[8], 'keepSprint') then resolved.keepSprint = rawget(v[8], 'keepSprint') end
        if methods(v[8], 'noSlow') then resolved.noSlow = rawget(v[8], 'noSlow') end
        if methods(v[8], 'active', 'config') then resolved.velocityActive, resolved.velocityConfig = rawget(v[8], 'active'), rawget(v[8], 'config') end
        local cross = valuesFor(v[18])
        if cross and cross[1] == physics and cross[5] == v[19] then resolved.crosshairTarget = v[18] end
        for _, record in ipairs(records) do
            local u = record.values
            if u[1] == v[9] and methods(u[2], 'flying', 'spectating') and methods(u[3], 'active', 'config') and u[4] == nil then
                resolved.velocityHandler = record.fn
                resolved.velocityActive, resolved.velocityConfig = rawget(u[3], 'active'), rawget(u[3], 'config')
            end
            if u[1] == inventory and u[6] == settings and u[17] == match then resolved.readInput = record.fn end
            if u[3] == physics and u[18] == settings and type(u[7]) == 'table' and type(rawget(u[7], 'STUDS_PER_BLOCK')) == 'number' then
                resolved.renderCamera = record.fn
                resolved.freeLook = methods(u[14], 'update', 'perspective', 'seesSelf') and u[14] or nil
            end
            if u[2] == match and u[10] == inventory and u[11] == net and type(u[5]) == 'number' then
                local throw = valuesFor(u[13])
                if throw and throw[4] == inventory and throw[6] == physics and throw[8] == net then
                    resolved.autoHeal, resolved.throwItem = record.fn, u[13]
                    resolved.potionLayout = {mode = 1, busy = 3, bow = 4, cooldown = 5}
                end
            end
            if u[1] == inventory and u[2] == v[6] and methods(u[6], 'quick', 'room') and type(u[5]) == 'function' then resolved.quickMove = record.fn end
            if u[1] == UIS and u[2] == inventory and u[3] == settings and u[8] == v[6] and type(u[5]) == 'function' then resolved.dropHandler, resolved.dropPressed = record.fn, u[5] end
        end
        for _, record in ipairs(helperRecords) do
            local u = record.values
            local config = type(u[7]) == 'table' and rawget(u[7], 'Health')
            if u[2] == match and u[6] == LP and u[10] == inventory and u[11] == net and u[15] == v[6]
                and type(u[5]) == 'number' and type(u[9]) == 'function' and type(u[13]) == 'function'
                and type(config) == 'table' and type(rawget(config, 'max')) == 'number' and u[13] ~= resolved.looseArrow then
                resolved.autoHeal, resolved.throwItem = record.fn, u[13]
                resolved.potionLayout = {mode = 1, busy = 3, bow = 4, cooldown = 5}
                break
            end
        end
        if not resolved.throwItem then
            local bestScore = 0
            local checked = {}
            local function consider(fn)
                if fn == resolved.looseArrow then return end
                if checked[fn] then return end
                checked[fn] = true
                local values = valuesFor(fn)
                if not values or not indexOf(values, inventory) or not indexOf(values, physics) or not indexOf(values, net) then return end
                local score, throwable, arrow = 0, false, false
                for _, value in pairs(values) do
                    if methods(value, 'launch', 'step') or methods(value, 'launch', 'carry', 'spread') then throwable = true; score = score + 8 end
                    if methods(value, 'predict') then score = score + 3 end
                    if type(value) == 'table' and type(rawget(value, 'throwTicks')) == 'number' then score = score + 2 end
                    if type(value) == 'table' and type(rawget(value, 'fullDrawTicks')) == 'number' and type(rawget(value, 'minPower')) == 'number' then arrow = true end
                end
                if throwable and not arrow and score > bestScore then bestScore, resolved.throwItem = score, fn end
            end
            for _, record in ipairs(helperRecords) do
                consider(record.fn)
                if indexOf(record.values, inventory) and indexOf(record.values, net) and indexOf(record.values, match) then
                    for _, value in pairs(record.values) do if type(value) == 'function' then consider(value) end end
                end
            end
        end
        if resolved.throwItem and not resolved.autoHeal then
            local bestScore = 0
            for _, record in ipairs(helperRecords) do
                local u = record.values
                local m, inv, n, t = indexOf(u, match), indexOf(u, inventory), indexOf(u, net), indexOf(u, resolved.throwItem)
                if m and inv and n and t and type(u[m + 3]) == 'number' and (u[m - 1] == nil or type(u[m - 1]) == 'string' or type(u[m - 1]) == 'boolean') then
                    local score = 4 + (n == inv + 1 and 2 or 0) + (t == n + 2 and 2 or 0)
                    for _, value in pairs(u) do if methods(value, 'active', 'config') then score = score + 2 end end
                    if score > bestScore then
                        bestScore, resolved.autoHeal = score, record.fn
                        resolved.potionLayout = {mode = m - 1, busy = m + 1, bow = m + 2, cooldown = m + 3}
                    end
                end
            end
        end
        if not resolved.autoHeal or not resolved.throwItem then
            local diagnostic = {helpers = #helperRecords, autoHeal = resolved.autoHeal ~= nil, throwItem = resolved.throwItem ~= nil, candidates = {}}
            for _, record in ipairs(helperRecords) do
                local u = record.values
                if indexOf(u, inventory) and indexOf(u, net) and #diagnostic.candidates < 6 then
                    local slots = {}
                    for slot, value in pairs(u) do
                        if type(slot) == 'number' then
                            slots[tostring(slot)] = value == inventory and 'Inventory' or value == physics and 'Physics' or value == match and 'Match' or value == net and 'Net' or type(value)
                        end
                    end
                    table.insert(diagnostic.candidates, slots)
                end
            end
            resolved.potionDiagnostic = diagnostic
        end
        if not resolved.velocityHandler and type(getconnections) == 'function' and rawget(net, 'Velocity') then
            pcall(function()
                for _, connection in ipairs(getconnections(net.Velocity.OnClientEvent)) do
                    local fn = connection.Function
                    local values = type(fn) == 'function' and valuesFor(fn)
                    if values and methods(values[3], 'active', 'config') and methods(values[2], 'flying', 'spectating') then
                        resolved.velocityHandler = fn
                        resolved.velocityActive, resolved.velocityConfig = rawget(values[3], 'active'), rawget(values[3], 'config')
                        break
                    end
                end
            end)
        end
        if resolved.renderCamera then
            local result = {functions = resolved, Physics = physics, Others = v[19], Match = match, Inventory = inventory, Settings = settings}
            if resolved.autoHeal and resolved.throwItem then return result end
            fallback = fallback or result
        end
        local missing = {}
        for _, name in ipairs({'renderCamera', 'autoHeal', 'throwItem'}) do if not resolved[name] then table.insert(missing, name) end end
        lastMissing = table.concat(missing, ', ')
    end
    if fallback then return fallback end
    return nil, 'PurpleHCF: incompatible client/executor data: ' .. lastMissing .. ' unavailable (' .. #records .. ' readable closures, ' .. unreadable .. ' unreadable). Function names are not required.'
end
local gcOK, gcObjects = pcall(getgc, true)
if not gcOK or type(gcObjects) ~= 'table' then gcObjects = getgc() end
local bindings, bindingError = resolveClient(gcObjects)
assert(bindings, bindingError)
local functions, Physics, Others, Match, Inventory, Settings = bindings.functions, bindings.Physics, bindings.Others, bindings.Match, bindings.Inventory, bindings.Settings
local FreeLook = functions.freeLook
local prediction, predictionQueue
for _, value in pairs(upvalues(Inventory.take)) do
    if type(value) == 'function' then
        local ok, values = pcall(upvalues, value)
        if ok and values[2] == Inventory and type(values[1]) == 'number' and type(values[3]) == 'table' then prediction, predictionQueue = value, values[3] end
    end
end
local PvP = game:GetService('ReplicatedStorage'):WaitForChild('PvP', 10)
assert(PvP, 'PurpleHCF: PvP package missing')
local Config = require(PvP:WaitForChild('Config', 10))
local Items = require(PvP:WaitForChild('Items', 10))
local Throwable = require(PvP:WaitForChild('Throwable', 10))
local InventoryOps = require(PvP:WaitForChild('InventoryOps', 10))
local scale = Config.STUDS_PER_BLOCK
assert(type(scale) == 'number', 'PurpleHCF: world scale missing')
local HOTBAR, SLOTS = Items.HOTBAR, Items.SLOTS
local ignored = {coolzzstudio = true, ['8zfai'] = true}
local C = {enabled = true, noKnockback = true, bowBoost = false, entityTarget = true, esp = true, combatHud = true, botMode = false, chams = true, quickDrop = true, autoPot = true, refill = true,
    pearlFollow = true, loot = true, noHitSlow = true, wallCheck = true, radius = 180, cps = 12, health = 10, freecamSpeed = 30, knockbackReduction = 100, key = Enum.KeyCode.R, reach = 3.1}
local PANEL_HEIGHT = 620
local CONFIG_FILE = 'purplepvp.json'
local configReader, configWriter, configExists = readfile or env.readfile, writefile or env.writefile, isfile or env.isfile
local configRanges = {knockbackReduction = {0, 100}, freecamSpeed = {5, 150}, radius = {40, 500}, cps = {0, 50}, health = {1, 20}, reach = {.1, 3.1}}
local panel, savedPanelPosition
local combatHud = {bow = {active = false}, freecam = {active = false}, nextRead = 0, tagEnd = 0, sync = {main = 'coolzzstudio', url = 'ws://127.0.0.1:8765', token = 'purple-hcf-5e86b0798a274906b16848635d547ebc', peers = {}, events = {}, queue = {}, serial = 0, nextConnect = 0}}
local configMissing, configWarned, savePending, saveDue = false, false, false, 0
local alive, held, rebinding, target = true, false, false, nil
local windowFocused, bindAwaitRelease, eventDown = true, false, false
local inputState = {blocked = false, dropHeld = false, dropAwaitRelease = false, nextDrop = 0}
local menuOpen, textFocused, nextFocusPoll = false, false, 0
local pendingPearl, observedId, observedPosition
local nextPearl = 0
local nativeTagStates = {}
local connections, hooks, tags, chamObjects = {}, {}, {}, {}
local playerNames, errorTimes, blockedVisuals = {}, {}, {}
local potBusy, nextPot, nextClick, nextRefill = false, 0, 0, 0
local freeYaw, freePitch, wasTracking
local stateValue, nextStatePoll = nil, 0
local restoreFreeLook
local function state()
    local now = os.clock()
    if now >= nextStatePoll then
        stateValue = nil
        for _, value in pairs(upvalues(functions.stateOwner)) do
            if type(value) == 'table' and typeof(rawget(value, 'position')) == 'Vector3' and type(rawget(value, 'yaw')) == 'number' and type(rawget(value, 'pitch')) == 'number' then stateValue = value; break end
        end
        nextStatePoll = now + .025
    end
    return stateValue
end
local function traceError(err)
    local message = tostring(err)
    if debug and debug.traceback then
        local ok, trace = pcall(debug.traceback, message, 2)
        if ok then return trace end
    end
    return message
end
local function report(stage, err)
    local now = os.clock()
    if not errorTimes[stage] or now - errorTimes[stage] >= 10 then errorTimes[stage] = now; warn('PurpleHCF [' .. stage .. ']: ' .. tostring(err)) end
end
local function guard(stage, callback, ...)
    local result = table.pack(xpcall(callback, traceError, ...))
    if not result[1] then report(stage, result[2]) end
    return table.unpack(result, 1, result.n)
end
local function configWarning(message)
    if not configWarned then configWarned = true; warn('PurpleHCF [config]: ' .. tostring(message)) end
end
local function finiteNumber(value)
    return type(value) == 'number' and value == value and value > -math.huge and value < math.huge
end
local function isMouseBinding(binding)
    return binding ~= nil and (binding == Enum.UserInputType.MouseButton1 or binding == Enum.UserInputType.MouseButton2 or binding == Enum.UserInputType.MouseButton3)
end
local function matchesBinding(input, binding)
    if isMouseBinding(binding) then return input.UserInputType == binding end
    return input.KeyCode == binding
end
local function bindingDown(binding)
    if isMouseBinding(binding) then return pcall(UIS.IsMouseButtonPressed, UIS, binding) end
    return pcall(UIS.IsKeyDown, UIS, binding)
end
local function bindingFromName(value)
    if type(value) ~= 'string' then return nil end
    local name = value:gsub('^Enum%.[%w_]+%.', '')
    local mouse = {MouseButton1 = 'MouseButton1', MouseLeftButton = 'MouseButton1', MouseButton2 = 'MouseButton2', MouseRightButton = 'MouseButton2', MouseButton3 = 'MouseButton3', MouseMiddleButton = 'MouseButton3'}
    if mouse[name] then return Enum.UserInputType[mouse[name]] end
    local ok, key = pcall(function() return Enum.KeyCode[name] end)
    if ok and key and key ~= Enum.KeyCode.Unknown and key ~= Enum.KeyCode.RightShift and key ~= Enum.KeyCode.Escape then return key end
end
local function applyConfig(data)
    if type(data) ~= 'table' then return false end
    local settings = type(data.settings) == 'table' and data.settings or data
    for key, current in pairs(C) do
        local value = settings[key]
        if type(current) == 'boolean' and type(value) == 'boolean' then C[key] = value
        elseif configRanges[key] and finiteNumber(value) then
            local range = configRanges[key]
            value = math.clamp(value, range[1], range[2])
            C[key] = key == 'reach' and value or math.floor(value + .5)
        end
    end
    local key = bindingFromName(settings.key)
    if key then C.key = key end
    local position = data.position
    if type(position) == 'table' and finiteNumber(position.xScale) and finiteNumber(position.xOffset) and finiteNumber(position.yScale) and finiteNumber(position.yOffset) then
        local xScale, yScale = math.clamp(position.xScale, 0, 1), math.clamp(position.yScale, 0, 1)
        savedPanelPosition = UDim2.new(xScale, position.xOffset, yScale, position.yOffset)
        local camera = workspace.CurrentCamera
        if camera then
            local view = camera.ViewportSize
            local x, y = xScale * view.X + position.xOffset, yScale * view.Y + position.yOffset
            local clampedX, clampedY = math.clamp(x, 0, math.max(0, view.X - 300)), math.clamp(y, 0, math.max(0, view.Y - PANEL_HEIGHT))
            if x ~= clampedX or y ~= clampedY then savedPanelPosition = UDim2.fromOffset(clampedX, clampedY) end
        end
    end
    local hud = data.combatPosition
    if type(hud) == 'table' and finiteNumber(hud.x) and finiteNumber(hud.y) then
        local camera = workspace.CurrentCamera
        local view = camera and camera.ViewportSize
        combatHud.position = UDim2.fromOffset(math.clamp(hud.x, 0, view and math.max(0, view.X - 180) or 10000), math.clamp(hud.y, 0, view and math.max(0, view.Y - 64) or 10000))
    end
    return true
end
local function loadConfig()
    if type(configReader) ~= 'function' then configWarning('readfile is unavailable; saved settings cannot be loaded'); return false end
    local knownExists = false
    if type(configExists) == 'function' then
        local ok, exists = pcall(configExists, CONFIG_FILE)
        if ok and not exists then configMissing = true; return false end
        knownExists = ok and exists == true
    end
    local ok, content = pcall(configReader, CONFIG_FILE)
    if not ok then
        if knownExists then configWarning('Could not read ' .. CONFIG_FILE .. ': ' .. tostring(content)) else configMissing = true end
        return false
    end
    local decoded, data = pcall(HttpService.JSONDecode, HttpService, content)
    if not decoded or type(data) ~= 'table' then configWarning('Invalid ' .. CONFIG_FILE .. '; using defaults'); return false end
    return applyConfig(data)
end
local function saveConfig()
    if type(configWriter) ~= 'function' then configWarning('writefile is unavailable; settings cannot be saved'); return false end
    local data = {version = 1}
    for key, value in pairs(C) do
        if key == 'key' then data.key = value.Name
        elseif type(value) == 'boolean' or finiteNumber(value) then data[key] = value end
    end
    local position = panel and panel.Position or savedPanelPosition
    if position then data.position = {xScale = position.X.Scale, xOffset = position.X.Offset, yScale = position.Y.Scale, yOffset = position.Y.Offset} end
    local hudPosition = combatHud.frame and combatHud.frame.Position or combatHud.position
    if hudPosition then data.combatPosition = {x = hudPosition.X.Offset, y = hudPosition.Y.Offset} end
    local ok, err = pcall(function() configWriter(CONFIG_FILE, HttpService:JSONEncode(data)) end)
    if not ok then configWarning('Could not save ' .. CONFIG_FILE .. ': ' .. tostring(err)); return false end
    configMissing, configWarned = false, false
    return true
end
local function queueSave()
    saveDue = os.clock() + .25
    if savePending then return end
    savePending = true
    local function flush()
        if not alive then savePending = false; return end
        local remaining = saveDue - os.clock()
        if remaining > .001 then task.delay(remaining, flush)
        else savePending = false; saveConfig() end
    end
    task.delay(.25, flush)
end
loadConfig()
if not functions.autoHeal or not functions.throwItem then
    C.autoPot, C.pearlFollow = false, false
    report('potions', 'Native potion helpers were not verified. Automatic healing and pearl follow are disabled; combat and ESP remain available.')
    if functions.potionDiagnostic then report('potion diagnostic', HttpService:JSONEncode(functions.potionDiagnostic)) end
end
if C.noHitSlow and not functions.keepSprint then C.noHitSlow = false; report('hit slowdown', 'Native sprint-preservation control unavailable') end
local function connect(signal, callback)
    combatHud.sync.ownHandlers = combatHud.sync.ownHandlers or {}
    combatHud.sync.ownHandlers[callback] = true
    local connection = signal:Connect(callback)
    table.insert(connections, connection)
    return connection
end
local function make(class, properties, parent)
    local object = Instance.new(class)
    for k, v in pairs(properties or {}) do object[k] = v end
    object.Parent = parent
    return object
end
local purple = Color3.fromRGB(175, 95, 255)
local pink = Color3.fromRGB(235, 166, 255)
local function round(parent, r) make('UICorner', {CornerRadius = UDim.new(0, r or 10)}, parent) end
local gradients = {}
local function gradient(parent)
    local g = make('UIGradient', {Color = ColorSequence.new({ColorSequenceKeypoint.new(0, purple), ColorSequenceKeypoint.new(.5, pink), ColorSequenceKeypoint.new(1, Color3.fromRGB(103, 45, 227))})}, parent)
    table.insert(gradients, g)
    return g
end
local gui = make('ScreenGui', {Name = 'PurpleHCF', ResetOnSpawn = false, IgnoreGuiInset = true, DisplayOrder = 1000, ZIndexBehavior = Enum.ZIndexBehavior.Sibling})
gui.Parent = PlayerGui
panel = make('Frame', {Position = savedPanelPosition or UDim2.new(0, 24, .5, -PANEL_HEIGHT / 2), Size = UDim2.fromOffset(300, PANEL_HEIGHT), BackgroundColor3 = Color3.fromRGB(19, 13, 30), BackgroundTransparency = .06, Active = true}, gui)
round(panel, 16)
local outline = make('UIStroke', {Thickness = 2, Color = Color3.new(1, 1, 1), Transparency = .12}, panel)
gradient(outline)
local particleLayer = make('Frame', {Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, ClipsDescendants = true}, panel)
round(particleLayer, 16)
local particles = {}
for i = 1, 22 do
    local dot = make('Frame', {Size = UDim2.fromOffset(i % 3 + 1, i % 3 + 1), BackgroundColor3 = purple, BackgroundTransparency = .45, BorderSizePixel = 0}, particleLayer)
    round(dot, 4)
    particles[i] = {dot = dot, x = math.random(), y = math.random(), speed = .025 + math.random() * .05}
end
local function label(text, position, size, parent, fontSize)
    return make('TextLabel', {Text = text, Position = position, Size = size, Font = Enum.Font.GothamMedium, TextSize = fontSize or 13,
        TextColor3 = Color3.fromRGB(225, 215, 238), BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left}, parent)
end
local title = label('PURPLE HCF', UDim2.fromOffset(18, 13), UDim2.fromOffset(225, 30), panel, 23)
title.Active = true
title.Font = Enum.Font.GothamBold
title.TextColor3 = Color3.new(1, 1, 1)
gradient(title)
local close = make('TextButton', {Text = '×', Position = UDim2.fromOffset(262, 14), Size = UDim2.fromOffset(25, 25), BackgroundTransparency = 1, TextColor3 = pink, TextSize = 25}, panel)
combatHud.toggleList = make('ScrollingFrame', {Name = 'Toggles', Position = UDim2.fromOffset(16, 316), Size = UDim2.fromOffset(268, PANEL_HEIGHT - 332), BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 3, ScrollBarImageColor3 = purple, ScrollingDirection = Enum.ScrollingDirection.Y, AutomaticCanvasSize = Enum.AutomaticSize.Y, CanvasSize = UDim2.fromOffset(0, 0)}, panel)
make('UIListLayout', {Padding = UDim.new(0, 3), SortOrder = Enum.SortOrder.LayoutOrder}, combatHud.toggleList)
local function toggle(text, key, y)
    local button = make('TextButton', {Text = '', LayoutOrder = y, Size = UDim2.new(1, -6, 0, 28), BackgroundColor3 = Color3.fromRGB(31, 22, 45), AutoButtonColor = false}, combatHud.toggleList)
    round(button, 7)
    label(text, UDim2.fromOffset(10, 0), UDim2.fromOffset(215, 28), button)
    local badge = label('', UDim2.fromOffset(228, 0), UDim2.fromOffset(35, 28), button, 11)
    local function refresh() badge.Text = C[key] and 'ON' or 'OFF'; badge.TextColor3 = C[key] and pink or Color3.fromRGB(115, 103, 133) end
    refresh()
    connect(button.MouseButton1Click, function()
        if key == 'noHitSlow' and not functions.keepSprint then report('hit slowdown', 'Native sprint-preservation control unavailable'); return end
        if key == 'bowBoost' and not C.bowBoost and not functions.bowUpdate then report('bow', 'Native bow handler is unavailable'); return end
        if key == 'bowBoost' and not C.bowBoost and not functions.noSlow then report('bow speed', 'Native drawing-slowdown control is unavailable in this client version') end
        if key == 'noKnockback' and not C.noKnockback and not functions.velocityHandler and not (functions.velocityActive and functions.velocityConfig) then report('knockback', 'Native velocity controls are unavailable'); return end
        C[key] = not C[key]; refresh(); queueSave()
        if key == 'entityTarget' and not C.entityTarget and target and Others[target] and Others[target].creature then target = nil end
    end)
end
local keyButton = make('TextButton', {Text = C.key.Name, Position = UDim2.fromOffset(16, 60), Size = UDim2.fromOffset(268, 28), BackgroundColor3 = Color3.fromRGB(38, 24, 55), TextColor3 = pink, Font = Enum.Font.GothamMedium, TextSize = 12}, panel)
round(keyButton, 7)
connect(keyButton.Activated, function(input)
    if input and input == inputState.lastBound then return end
    rebinding = not rebinding; held = false; keyButton.Text = rebinding and '…' or C.key.Name
end)
local sliding
local function slider(text, key, min, max, y, suffix)
    local value = label('', UDim2.fromOffset(18, y), UDim2.fromOffset(264, 20), panel, 12)
    local track = make('TextButton', {Text = '', Position = UDim2.fromOffset(18, y + 25), Size = UDim2.fromOffset(264, 7), BackgroundColor3 = Color3.fromRGB(58, 39, 78), AutoButtonColor = false}, panel)
    round(track, 5)
    local fill = make('Frame', {Size = UDim2.fromScale(0, 1), BackgroundColor3 = Color3.new(1, 1, 1), BorderSizePixel = 0}, track)
    round(fill, 5); gradient(fill)
    local knob = make('Frame', {AnchorPoint = Vector2.new(.5, .5), Position = UDim2.fromScale(0, .5), Size = UDim2.fromOffset(13, 13), BackgroundColor3 = pink, BorderSizePixel = 0}, track)
    round(knob, 8)
    local function refresh() local p = (C[key] - min) / (max - min); fill.Size = UDim2.fromScale(p, 1); knob.Position = UDim2.fromScale(p, .5); value.Text = text .. '   ' .. C[key] .. (suffix or '') end
    local function update(x) C[key] = math.floor(min + math.clamp((x - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1) * (max - min) + .5); if key == 'cps' then nextClick = 0 end; refresh(); queueSave() end
    refresh()
    connect(track.InputBegan, function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then sliding = update; update(input.Position.X) end end)
end
slider('FOV', 'radius', 40, 500, 100)
slider('CPS', 'cps', 0, 50, 142)
slider('Pot health', 'health', 1, 20, 184)
slider('Freecam speed', 'freecamSpeed', 5, 150, 226)
slider('Knockback reduction', 'knockbackReduction', 0, 100, 268, '%')
toggle('Bot mode', 'botMode', 1)
toggle('Silent aim', 'enabled', 2)
toggle('Bow boost', 'bowBoost', 3)
toggle('Entity target', 'entityTarget', 4)
toggle('Auto pot', 'autoPot', 5)
toggle('Auto refill', 'refill', 6)
toggle('ESP', 'esp', 7)
toggle('Chams', 'chams', 8)
toggle('Pearl follow', 'pearlFollow', 9)
toggle('Supply loot', 'loot', 10)
toggle('No hit slowdown', 'noHitSlow', 11)
toggle('Wall check', 'wallCheck', 12)
toggle('Quick drop [Q]', 'quickDrop', 13)
toggle('Combat HUD', 'combatHud', 14)
toggle('No knockback', 'noKnockback', 15)
combatHud.frame = make('Frame', {Name = 'CombatTimer', Position = combatHud.position or UDim2.fromOffset(340, 70), Size = UDim2.fromOffset(180, 64), BackgroundColor3 = Color3.fromRGB(19, 13, 30), BackgroundTransparency = .08, Active = true}, gui)
round(combatHud.frame, 10)
gradient(make('UIStroke', {Thickness = 1.5, Color = Color3.new(1, 1, 1)}, combatHud.frame))
combatHud.text = label('COMBAT   0.0s', UDim2.fromOffset(12, 8), UDim2.fromOffset(156, 35), combatHud.frame, 15)
combatHud.text.TextXAlignment = Enum.TextXAlignment.Center
combatHud.text.TextColor3 = pink
combatHud.bar = make('Frame', {Position = UDim2.fromOffset(12, 51), Size = UDim2.fromOffset(0, 3), BackgroundColor3 = purple, BorderSizePixel = 0}, combatHud.frame)
round(combatHud.bar, 2)
connect(combatHud.frame.InputBegan, function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then combatHud.drag = input; combatHud.start = input.Position; combatHud.origin = combatHud.frame.Position end
end)
connect(UIS.InputChanged, function(input)
    if combatHud.drag and (input.UserInputType == Enum.UserInputType.MouseMovement or input == combatHud.drag) then
        local delta = input.Position - combatHud.start
        local view = workspace.CurrentCamera.ViewportSize
        combatHud.frame.Position = UDim2.fromOffset(math.clamp(combatHud.origin.X.Offset + delta.X, 0, math.max(0, view.X - 180)), math.clamp(combatHud.origin.Y.Offset + delta.Y, 0, math.max(0, view.Y - 64)))
    end
end)
function combatHud.mode()
    local owner = functions.autoHeal or functions.stateOwner
    if not owner then return nil end
    local ok, values = pcall(upvalues, owner)
    if not ok or type(values) ~= 'table' then return nil end
    local index = functions.autoHeal and ((functions.potionLayout and functions.potionLayout.mode) or 1) or 12
    return values[index]
end
function combatHud.update(now)
    combatHud.frame.Visible = C.combatHud
    if not C.combatHud then return end
    if now >= combatHud.nextRead then
        combatHud.nextRead = now + .1
        combatHud.tagEnd = 0
        local private = PlayerGui:FindFirstChild('PvPPrivate')
        local raw = private and private:GetAttribute('Hcf') or LP:GetAttribute('Hcf')
        local mode = combatHud.mode()
        if type(mode) == 'string' and mode:sub(1, 4) == 'hcf:' and type(raw) == 'string' and raw ~= '' then
            local ok, data = pcall(HttpService.JSONDecode, HttpService, raw)
            if ok and type(data) == 'table' and finiteNumber(tonumber(data.tagEnd)) then combatHud.tagEnd = tonumber(data.tagEnd) end
        end
    end
    local remaining = math.max(0, combatHud.tagEnd - workspace:GetServerTimeNow())
    combatHud.text.Text = remaining > 0 and string.format('COMBAT   %.1fs', remaining) or 'COMBAT   0.0s'
    combatHud.bar.Size = UDim2.fromOffset(156 * math.clamp(remaining / ((Config.Hcf and Config.Hcf.combatTagSeconds) or 30), 0, 1), 3)
end
local ring = make('Frame', {AnchorPoint = Vector2.new(.5, .5), BackgroundTransparency = 1}, gui)
round(ring, 1000)
local ringGlow = make('UIStroke', {Thickness = 8, Color = purple, Transparency = .87}, ring)
local ringLine = make('Frame', {Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1}, ring)
round(ringLine, 1000)
gradient(make('UIStroke', {Thickness = 2, Color = Color3.new(1, 1, 1)}, ringLine))
local box = make('Frame', {AnchorPoint = Vector2.new(.5, .5), BackgroundTransparency = 1, Visible = false}, gui)
local edges = {}
for _, corner in ipairs({Vector2.new(0, 0), Vector2.new(1, 0), Vector2.new(0, 1), Vector2.new(1, 1)}) do
    for axis = 1, 2 do
        local edge = make('Frame', {AnchorPoint = corner, Position = UDim2.fromScale(corner.X, corner.Y), Size = axis == 1 and UDim2.new(.28, 0, 0, 2) or UDim2.new(0, 2, .28, 0), BorderSizePixel = 0, BackgroundColor3 = Color3.new(1, 1, 1)}, box)
        gradient(edge); table.insert(edges, edge)
    end
end
local dragStart, dragPosition, dragInput
connect(title.InputBegan, function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragStart = input.Position; dragPosition = panel.Position; dragInput = input end
end)
connect(UIS.InputChanged, function(input)
    if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then sliding(input.Position.X) end
    if dragStart and (input.UserInputType == Enum.UserInputType.MouseMovement or input == dragInput) then
        local delta = input.Position - dragStart
        local view = workspace.CurrentCamera.ViewportSize
        panel.Position = UDim2.fromOffset(math.clamp(dragPosition.X.Offset + delta.X, 0, math.max(0, view.X - 300)), math.clamp(dragPosition.Y.Scale * view.Y + dragPosition.Y.Offset + delta.Y, 0, math.max(0, view.Y - PANEL_HEIGHT)))
    end
end)
connect(UIS.InputEnded, function(input)
    if matchesBinding(input, C.key) then held = false; eventDown = false; bindAwaitRelease = false; inputState.blocked = false end
    if input.KeyCode == Enum.KeyCode.Q then inputState.dropHeld = false; inputState.dropAwaitRelease = false; inputState.dropSession = nil end
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then if dragStart then queueSave() end; sliding = nil; dragStart = nil end
end)
local function pointerOnPanel(input)
    if input.Position and combatHud.frame and combatHud.frame.Visible then
        local p, size, point = combatHud.frame.AbsolutePosition, combatHud.frame.AbsoluteSize, input.Position
        if point.X >= p.X and point.X <= p.X + size.X and point.Y >= p.Y and point.Y <= p.Y + size.Y then return true end
    end
    if not panel or not panel.Visible or not input.Position then return false end
    local p, size, point = panel.AbsolutePosition, panel.AbsoluteSize, input.Position
    return point.X >= p.X and point.X <= p.X + size.X and point.Y >= p.Y and point.Y <= p.Y + size.Y
end
connect(UIS.InputBegan, function(input)
    if combatHud.freecam.active then return end
    if not rebinding then inputState.lastBound = nil end
    local ok, focus = pcall(UIS.GetFocusedTextBox, UIS)
    if ok and focus then return end
    if input.KeyCode == Enum.KeyCode.Q then inputState.dropHeld = true end
    if input.KeyCode == Enum.KeyCode.V and not rebinding and windowFocused and not menuOpen and not Inventory.open and not inputState.speed then
        inputState.speed = {stage = 'request', expires = os.clock() + 2}
        if combatHud.sync.emit then combatHud.sync.emit({kind = 'speed'}) end
    end
    if input.UserInputType == Enum.UserInputType.MouseButton3 and not rebinding and not bindAwaitRelease and windowFocused and not menuOpen and not Inventory.open and not inputState.speed and not pointerOnPanel(input) then
        inputState.quickPearl = os.clock() + .5
    end
    local mouse = isMouseBinding(input.UserInputType)
    if rebinding and (mouse or (input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode ~= Enum.KeyCode.Unknown)) then
        if mouse then C.key = input.UserInputType
        elseif input.KeyCode ~= Enum.KeyCode.RightShift and input.KeyCode ~= Enum.KeyCode.Escape then C.key = input.KeyCode end
        inputState.lastBound = input
        rebinding = false; held = false; eventDown = false; bindAwaitRelease = true; keyButton.Text = C.key.Name; queueSave(); return
    end
    if input.KeyCode == Enum.KeyCode.RightShift then panel.Visible = not panel.Visible end
    if not rebinding and not bindAwaitRelease and matchesBinding(input, C.key) then
        inputState.blocked = mouse and pointerOnPanel(input)
        eventDown = not inputState.blocked; held = eventDown
    end
end)
connect(UIS.WindowFocusReleased, function() windowFocused = false; held = false; eventDown = false; sliding = nil; dragStart = nil; inputState.blocked = false; inputState.dropHeld = false; inputState.dropAwaitRelease = true; inputState.dropSession = nil end)
connect(UIS.WindowFocused, function() windowFocused = true end)
pcall(function() connect(GuiService.MenuOpened, function() menuOpen = true end); connect(GuiService.MenuClosed, function() menuOpen = false end) end)
connect(UIS.InputEnded, function(input)
    if combatHud.drag and (input == combatHud.drag or input.UserInputType == Enum.UserInputType.MouseButton1) then combatHud.drag = nil; queueSave() end
end)
connect(UIS.WindowFocusReleased, function() combatHud.drag = nil end)
local function updateHeld()
    if combatHud.sync and combatHud.sync.bot and combatHud.sync.bot() then
        local ok, focus = pcall(UIS.GetFocusedTextBox, UIS)
        textFocused = not ok or focus ~= nil
        local data = combatHud.sync.fresh() and combatHud.sync.remote
        held = data and data.held and not textFocused and not menuOpen and not rebinding or false
        return
    end
    local ok, polled = bindingDown(C.key)
    local down = ok and polled or eventDown
    if ok and not polled then down = false end
    local now = os.clock()
    if now >= nextFocusPoll then
        local focused, value = pcall(UIS.GetFocusedTextBox, UIS)
        textFocused = focused and value ~= nil
        nextFocusPoll = now + .05
    end
    if not down then bindAwaitRelease = false; inputState.blocked = false end
    held = windowFocused and not rebinding and not bindAwaitRelease and not inputState.blocked and down
end
local function updateLock(candidate)
    if not held or not C.enabled then target = nil
    elseif not target then target = candidate end
end
local function username(id, entry)
    if playerNames[id] then return playerNames[id] end
    local p = type(id) == 'number' and id > 0 and Players:GetPlayerByUserId(id)
    local name = p and p.Name or tostring(entry.name or id)
    playerNames[id] = name
    return name
end
local function allowed(id, entry)
    if id == LP.UserId or not entry or not entry.rendered or (entry.health and entry.health <= 0) then return false end
    if entry.creature then return C.entityTarget == true and not entry.invisible end
    if ignored[string.lower(username(id, entry))] then return false end
    if C.botMode and combatHud.sync.peers[id] then return false end
    if Match and Match.active() and Match.isAlly(id) then return false end
    return true
end
local function active()
    return alive and held and C.enabled and target and not Inventory.open and not textFocused and not menuOpen and not (combatHud.freecam and combatHud.freecam.active) and not (combatHud.bow and combatHud.bow.active)
end
local function targetEntry() return target and Others[target] end
local function distance(entry, s)
    if not s or not entry or not entry.rendered then return math.huge end
    return Physics.distanceToBox(Physics.eye(s), Physics.hitbox(entry.rendered, nil, entry.size))
end
local function hitDistance(hit)
    if hit == nil then return math.huge end
    if type(hit) == 'number' then return hit end
    if typeof(hit) == 'RaycastResult' then return hit.Distance / scale end
    return 0
end
local findModel
local fallbackRay = RaycastParams.new()
fallbackRay.FilterType = Enum.RaycastFilterType.Exclude
fallbackRay.IgnoreWater = true
local function worldDistance(origin, direction, world, id)
    local ok, result = pcall(Physics.raycastWorld, origin, direction, world)
    if ok then
        local valid, distanceValue = pcall(hitDistance, result)
        if valid then return distanceValue end
    end
    local ignoredModels = {workspace.CurrentCamera}
    if LP.Character then table.insert(ignoredModels, LP.Character) end
    if id and findModel and Others[id] then
        local model = findModel(Others[id], id)
        if model then table.insert(ignoredModels, model) end
    end
    fallbackRay.FilterDescendantsInstances = ignoredModels
    local success, hit = pcall(workspace.Raycast, workspace, origin * scale, direction * scale, fallbackRay)
    if not success then report('visibility', hit); return 0 end
    local valid, distanceValue = pcall(hitDistance, hit)
    if not valid then report('visibility', distanceValue); return 0 end
    return distanceValue
end
local visibilityCache = {}
local function clearPath(s, entry, id)
    local eye = Physics.eye(s)
    local center = Physics.hitbox(entry.rendered, nil, entry.size)
    local now = os.clock()
    local cached = id and visibilityCache[id]
    if cached and cached.world == s.world and now < cached.expires and (cached.eye - eye).Magnitude < .1 and (cached.center - center).Magnitude < .1 then return cached.visible end
    local direction = center - eye
    local visible = worldDistance(eye, direction, s.world, id) >= direction.Magnitude - .1
    if id then visibilityCache[id] = {world = s.world, eye = eye, center = center, expires = now + .025, visible = visible} end
    return visible
end
local function canTrack(s, entry)
    return s and active() and allowed(target, entry) and (not C.wallCheck or clearPath(s, entry, target))
end
local function orient(s, entry)
    local eye = Physics.eye(s)
    local center = Physics.hitbox(entry.rendered, nil, entry.size)
    local delta = center - eye
    s.yaw = math.atan2(-delta.X, -delta.Z)
    s.pitch = math.clamp(math.atan2(delta.Y, Vector3.new(delta.X, 0, delta.Z).Magnitude), -1.5533, 1.5533)

end
local function install(fn, replacement, optional)
    local original
    local ok, result = pcall(hookfunction, fn, function(...) return replacement(original, ...) end)
    if not ok then
        if optional then return nil, tostring(result) end
        if restoreFreeLook then pcall(restoreFreeLook) end
        for i = #hooks, 1, -1 do pcall(hookfunction, hooks[i][1], hooks[i][2]) end
        for _, connection in ipairs(connections) do connection:Disconnect() end
        gui:Destroy()
        error('PurpleHCF: executor could not install client hooks: ' .. tostring(result))
    end
    original = result
    table.insert(hooks, {fn, original})
    return original
end
if functions.keepSprint then
install(functions.keepSprint, function(original, ...)
    if alive and C.noHitSlow then return true end
    return original(...)
end)
end
if functions.noSlow then
    install(functions.noSlow, function(original, ...)
        if alive and C.bowBoost and functions.bowUpdate and combatHud.bow.wanted and combatHud.bow.wanted() then return true end
        return original(...)
    end)
end
install(Settings.held, function(original, action, ...)
    if combatHud.freecam.active then return false end
    if action == 'use' and combatHud.bow.wanted and functions.bowUpdate and combatHud.bow.isBow() and C.bowBoost and not inputState.speed and combatHud.bow.wanted() then return true end
    if combatHud.sync and combatHud.sync.bot and combatHud.sync.bot() and action == 'use' and not inputState.speed then
        local data = combatHud.sync.fresh() and combatHud.sync.remote
        local item = Inventory.selectedItem()
        return data and data.use and item and item.id == data.item and not Inventory.open and not textFocused and not menuOpen or false
    end
    if alive and action == 'use' and inputState.speed then return inputState.speed.stage == 'drink' and (windowFocused or (combatHud.sync.fresh and combatHud.sync.bot() and combatHud.sync.fresh())) and not Inventory.open and not textFocused and not menuOpen and not rebinding end
    if combatHud.sync and combatHud.sync.bot and combatHud.sync.bot() and action ~= 'use' then
        local data = combatHud.sync.fresh() and combatHud.sync.remote
        return data and not textFocused and not menuOpen and data.actions and data.actions[action] == true or false
    end
    if alive and action == 'use' and C.key == Enum.UserInputType.MouseButton2 and C.enabled and held and not rebinding and not bindAwaitRelease and not Inventory.open and not textFocused and not menuOpen then return false end
    return original(action, ...)
end)
local function captureCamera()
    local look = workspace.CurrentCamera.CFrame.LookVector
    freeYaw = math.atan2(-look.X, -look.Z)
    freePitch = math.asin(math.clamp(look.Y, -1, 1))
end
local managedCamera, previousCamera, previousEase
local originalFreeLookUpdate = FreeLook and FreeLook.update
local freeLookReplacement
local function releaseFreeLook()
    if not managedCamera then return end
    local s = state()
    if s then
        local perspectiveYaw = FreeLook.perspective()
        local difference = ((perspectiveYaw - s.yaw + math.pi) % (math.pi * 2)) - math.pi
        local front = math.abs(difference) > math.pi / 2
        s.yaw = managedCamera.yaw - (front and math.pi or 0)
        s.pitch = front and -managedCamera.pitch or managedCamera.pitch
    end
    if previousCamera then previousCamera.yaw, previousCamera.pitch = managedCamera.yaw, managedCamera.pitch end
    if FreeLook.camera == managedCamera then FreeLook.camera = previousCamera end
    FreeLook.EASE = previousEase
    managedCamera, previousCamera, previousEase = nil, nil, nil
end
local function updateFreeLook(mouseFree)
    local s, entry = state(), targetEntry()
    if not alive or mouseFree or not s or not active() or not allowed(target, entry) then
        releaseFreeLook()
        return originalFreeLookUpdate(mouseFree)
    end
    if not managedCamera then
        captureCamera()
        previousCamera, previousEase = FreeLook.camera, FreeLook.EASE
        managedCamera = {yaw = freeYaw, pitch = freePitch, held = true}
    end
    local _, _, modeDistance = FreeLook.perspective()
    managedCamera.distance = math.max(0, modeDistance or 0)
    managedCamera.room = nil
    managedCamera.out = managedCamera.distance
    managedCamera.held = true
    FreeLook.camera, FreeLook.EASE = managedCamera, 0
    return true
end
restoreFreeLook = function()
    if not FreeLook then return end
    releaseFreeLook()
    if FreeLook.update == freeLookReplacement then FreeLook.update = originalFreeLookUpdate end
end
if FreeLook then
    freeLookReplacement = function(mouseFree)
        local ok, result = guard('free look', updateFreeLook, mouseFree)
        if ok then return result end
        pcall(releaseFreeLook)
        return originalFreeLookUpdate(mouseFree)
    end
    FreeLook.update = freeLookReplacement
end
local function controlInput(s, input)
    if type(input) ~= 'table' then return false end
    if combatHud.freecam and combatHud.freecam.active then
        input.forward, input.strafe, input.jump, input.sneak = 0, 0, false, false
        s.yaw, s.pitch = combatHud.freecam.bodyYaw or s.yaw, combatHud.freecam.bodyPitch or s.pitch
        s.sprinting, s.sprintIntent, s.sneaking = false, false, false
        combatHud.sync.input = {jump = false, sneak = false}
        return false
    end
    local entry = targetEntry()
    if not potBusy and canTrack(s, entry) then
        orient(s, entry)
    end
    if combatHud.sync and combatHud.sync.move then combatHud.sync.move(s, input) end
    return false
end
install(Physics.tick, function(original, s, input, ...)
    if s == state() then controlInput(s, input) end
    return original(s, input, ...)
end)
if not FreeLook then
install(functions.renderCamera, function(original, ...)
    local s = state()
    local tracking = s and active() and allowed(target, targetEntry())
    if tracking and not wasTracking then captureCamera() end
    if tracking and freeYaw then
        local delta = UIS:GetMouseDelta() * Settings.mouseTurn()
        freeYaw = freeYaw - delta.X
        freePitch = math.clamp(freePitch - delta.Y * (Settings.invertMouse and -1 or 1), -1.5533, 1.5533)
    end
    if wasTracking and not tracking and s and freeYaw and not potBusy then s.yaw = freeYaw; s.pitch = freePitch end
    wasTracking = tracking
    if s and tracking then
        local yaw, pitch = s.yaw, s.pitch
        s.yaw, s.pitch = freeYaw, freePitch
        local result = table.pack(pcall(original, ...))
        s.yaw, s.pitch = yaw, pitch
        if not result[1] then error(result[2]) end
        return table.unpack(result, 2, result.n)
    end
    return original(...)
end)
end
if functions.crosshairTarget then
install(functions.crosshairTarget, function(original, ...)
    local entry, s = targetEntry(), state()
    if active() and not potBusy and allowed(target, entry) and s then
        local d = distance(entry, s)
        if d <= C.reach then
            if not C.wallCheck or clearPath(s, entry, target) then return target, d end
        end
        return nil
    end
    local id, d = original(...)
    if id and Others[id] and ignored[string.lower(username(id, Others[id]))] then return nil end
    return id, d
end)
end
findModel = function(entry, id)
    local ok, model = pcall(function()
        local capsule = rawget(entry, 'capsule')
        local object = type(capsule) == 'table' and rawget(capsule, 'model') or capsule
        if typeof(object) == 'Instance' and object:IsA('Model') and object:IsDescendantOf(workspace) then return object end
        local p = type(id) == 'number' and id > 0 and Players:GetPlayerByUserId(id)
        return p and p.Character or nil
    end)
    return ok and model or nil
end
function combatHud.item(value)
    if type(value) == 'table' and type(value.id) == 'string' and Items.defs[value.id] then return value end
    if type(value) ~= 'string' or value == '' or value == '-' then return nil end
    if Items.defs[value] then return {id = value, count = 1} end
    if type(Items.decode) == 'function' then
        local ok, item = pcall(Items.decode, value)
        if ok then return item end
    end
end
function combatHud.gear(entry)
    local pose = entry.pose or entry
    local gear = {combatHud.item(pose.held)}
    local armor = pose.armor
    local materials = {p = 'pumpkin', c = 'chain', r = 'rage', d = 'diamond', g = 'gold', i = 'iron', k = 'dark', m = 'magic', l = 'leather'}
    local pieces = Items.ARMOR_PIECES or {'helmet', 'chestplate', 'leggings', 'boots'}
    local split = {}
    if type(armor) == 'string' then for part in (armor .. ','):gmatch('(.-),') do table.insert(split, part) end end
    for i = 1, 4 do
        local value
        if type(armor) == 'table' then value = armor[(Items.ARMOR or {})[i]] or armor[i] or armor[pieces[i]]
        elseif type(armor) == 'string' then
            local material = #armor == 4 and armor:match('^[lgcidpmkr%-]+$') and materials[armor:sub(i, i)] or (#split == 4 and split[i] or armor)
            if material and material ~= '-' and material ~= '' then value = material end
        end
        local item = combatHud.item(value)
        local id = item and item.id or (type(value) == 'table' and value.id or value)
        if type(id) == 'string' then
            local armorId = id .. '_' .. pieces[i]
            if Items.defs[armorId] then
                local metadata = item and item.m or (type(value) == 'table' and value.m)
                item = {id = armorId, count = 1, m = metadata}
            end
        end
        gear[i + 1] = item
    end
    return gear
end
function combatHud.equipment(tag, entry)
    tag.equipment.Visible = C.esp
    tag.billboard.Size = UDim2.fromOffset(240, C.esp and 64 or 28)
    if not C.esp then return end
    local gear = combatHud.gear(entry)
    for i = 1, 5 do
        local item = gear[i]
        local signature = item and item.id or ''
        local cell = tag.cells[i]
        if not cell then
            local frame = make('Frame', {Position = UDim2.fromOffset((i - 1) * 48, 0), Size = UDim2.fromOffset(46, 32), BackgroundColor3 = Color3.fromRGB(20, 12, 33), BackgroundTransparency = .25}, tag.equipment)
            round(frame, 5)
            local icon = make('Frame', {Position = UDim2.fromOffset(9, 2), Size = UDim2.fromOffset(28, 28), BackgroundTransparency = 1}, frame)
            cell = {frame = frame, icon = icon}
            tag.cells[i] = cell
        end
        cell.frame.Visible = item ~= nil
        if cell.signature ~= signature then
            cell.icon:ClearAllChildren()
            if item and type(Inventory.drawIcon) == 'function' then Inventory.drawIcon(cell.icon, item) end
            cell.signature = signature
        end
    end
end
local function newTag()
    local anchor = make('Part', {Name = 'PurpleHCFTagAnchor', Anchored = true, CanCollide = false, CanTouch = false, CanQuery = false, Transparency = 1, Size = Vector3.new(.05, .05, .05)}, workspace)
    local billboard = make('BillboardGui', {Name = 'PurpleHCFName', Adornee = anchor, Size = UDim2.fromOffset(240, 64), SizeOffset = Vector2.new(0, .5), AlwaysOnTop = true, LightInfluence = 0, MaxDistance = 0, ResetOnSpawn = false}, PlayerGui)
    local frame = make('Frame', {AnchorPoint = Vector2.new(.5, 1), Position = UDim2.fromScale(.5, 1), Size = UDim2.fromOffset(160, 28), BackgroundColor3 = Color3.fromRGB(20, 12, 33), BackgroundTransparency = .14}, billboard)
    round(frame, 8)
    make('UIStroke', {Thickness = 1, Color = purple, Transparency = .35}, frame)
    local name = label('', UDim2.fromOffset(8, 0), UDim2.new(1, -16, 1, 0), frame, 12)
    name.TextXAlignment = Enum.TextXAlignment.Center
    name.Font = Enum.Font.GothamBold
    name.TextTruncate = Enum.TextTruncate.AtEnd
    local equipment = make('Frame', {Position = UDim2.fromOffset(0, 0), Size = UDim2.new(1, 0, 1, -32), BackgroundTransparency = 1}, billboard)
    return {frame = frame, name = name, billboard = billboard, anchor = anchor, equipment = equipment, cells = {}}
end
local function healthPotCount()
    local count, slot = 0, nil
    for i = 1, HOTBAR do
        local item = Inventory.items[i]
        if item and item.id == 'heal' then count = count + (item.count or 1); slot = slot or i end
    end
    return count, slot
end
local function nativeReady()
    if not state() or Inventory.open or textFocused or menuOpen or (not windowFocused and not (combatHud.sync.fresh and combatHud.sync.bot() and combatHud.sync.fresh())) then return false end
    if Match and Match.frozen() then return false end
    if not functions.autoHeal then return false end
    local ok, values = pcall(upvalues, functions.autoHeal)
    if not ok or type(values) ~= 'table' then return false end
    local layout = functions.potionLayout or {mode = 1, busy = 3, bow = 4, cooldown = 5}
    return values[layout.mode] and not values[layout.busy] and not values[layout.bow] and type(values[layout.cooldown]) == 'number' and values[layout.cooldown] <= 0
end
local function sequence()
    if not prediction then return nil end
    return upvalues(prediction)[1]
end
local function acknowledged(seq)
    if not seq or not predictionQueue then return false end
    for _, operation in ipairs(predictionQueue) do if operation.seq == seq then return false end end
    return true
end
local function nativeThrow(kind, slot, aim)
    if type(functions.throwItem) ~= 'function' then return false end
    if not nativeReady() then return false end
    local item = Inventory.items[slot]
    if not item or item.id ~= kind then return false end
    local s = state()
    local yaw, pitch = s.yaw, s.pitch
    local before, oldSequence = item.count or 1, sequence()
    potBusy = true
    if aim and aim.yaw then s.yaw = aim.yaw end
    local ok, err = xpcall(function() functions.throwItem(kind, slot, aim and aim.pitch or pitch) end, traceError)
    s.yaw, s.pitch = yaw, pitch
    potBusy = false
    if not ok then report('native throw', err); return false end
    local current = Inventory.items[slot]
    local used = not current or current.id ~= kind or (current.count or 1) < before
    return used or (oldSequence ~= nil and sequence() > oldSequence)
end
function combatHud.quickPearlStep(now)
    local expires = inputState.quickPearl
    if not expires then return false end
    if now > expires or not windowFocused or textFocused or menuOpen or Inventory.open or rebinding or combatHud.freecam.active or inputState.speed then inputState.quickPearl = nil; return false end
    if potBusy or not nativeReady() then return true end
    inputState.quickPearl = nil
    if Inventory.pearlReadyAt() > workspace:GetServerTimeNow() then return false end
    local slot
    for i = 1, HOTBAR do
        local item = Inventory.items[i]
        if item and item.id == 'pearl' and (item.count or 1) > 0 then slot = i; break end
    end
    if not slot then return false end
    local previous = Inventory.selected
    local ok, used = xpcall(function()
        Inventory.select(slot)
        return nativeThrow('pearl', slot)
    end, traceError)
    local restored, err = pcall(Inventory.select, previous)
    if not restored then report('quick pearl restore', err) end
    if not ok then report('quick pearl', used); return false end
    if used then
        Inventory.startPearlCooldown(workspace:GetServerTimeNow() + Config.Pearl.cooldownSeconds)
        nextPearl = now + Config.TICK
    end
    return used
end
local function autoPotion(now)
    if potBusy or not C.autoPot or now < nextPot or (not windowFocused and not (combatHud.sync.fresh and combatHud.sync.bot() and combatHud.sync.fresh())) or Inventory.open or textFocused or menuOpen then return false end
    local health = LP:GetAttribute('Health')
    local s = state()
    if not s or not health or health <= 0 or health > C.health or health >= ((Config.Health and Config.Health.max) or 20) then return false end
    local _, slot = healthPotCount()
    if not slot or not nativeReady() then return false end
    local used = nativeThrow('heal', slot, {yaw = s.yaw + math.pi, pitch = -1.5533430342749532})
    nextPot = now + (used and math.max(Config.TICK, Config.Potion.throwTicks * Config.TICK) or Config.TICK)
    return used
end
function combatHud.speedStep(now)
    local job = inputState.speed
    if not job then return false end
    local safe = (windowFocused or (combatHud.sync.fresh and combatHud.sync.bot() and combatHud.sync.fresh())) and not Inventory.open and not textFocused and not menuOpen and not rebinding
    local function same(a, b)
        if not a or not b then return a == b end
        return a.id == b.id and (a.count or 1) == (b.count or 1) and (not Items.sameMeta or Items.sameMeta(a.m, b.m))
    end
    if job.stage == 'request' then
        if not safe or now > job.expires then inputState.speed = nil; return false end
        if potBusy or not nativeReady() then return true end
        local slot
        for i = 1, SLOTS do
            local item = Inventory.items[i]
            local def = item and Items.defs[item.id]
            if def and def.drink then
                for _, effect in ipairs(def.effects or {}) do if effect[1] == 'speed' then slot = i; break end end
            end
            if slot then break end
        end
        if not slot then inputState.speed = nil; return false end
        job.source, job.hand, job.original, job.potion = slot, Inventory.selected, Inventory.items[Inventory.selected], Inventory.items[slot]
        job.expires = now + 7
        if slot ~= job.hand then
            local before = sequence()
            Inventory.swapSlots(slot, job.hand)
            local after = sequence()
            job.seq = after ~= before and after or nil
            job.stage = 'swap'
        else job.stage = 'drink' end
    elseif job.stage == 'swap' then
        if same(Inventory.items[job.hand], job.potion) and (job.seq == nil or acknowledged(job.seq)) then job.stage = 'drink'
        elseif now > job.expires then job.stage = 'restore' end
    elseif job.stage == 'drink' then
        if not safe or Inventory.selected ~= job.hand or not same(Inventory.items[job.hand], job.potion) or now > job.expires then job.stage = 'restore' end
    elseif job.stage == 'restore' then
        if job.source == job.hand then inputState.speed = nil; return false end
        if not same(Inventory.items[job.source], job.original) then inputState.speed = nil; return false end
        local hand = Inventory.items[job.hand]
        if hand and not same(hand, job.potion) and hand.id ~= 'bottle' and hand.id ~= 'glass_bottle' then inputState.speed = nil; return false end
        if same(hand, job.original) then inputState.speed = nil; return false end
        Inventory.swapSlots(job.source, job.hand)
        inputState.speed = nil
        return false
    end
    return inputState.speed ~= nil
end
local function pearlAim(s, destination)
    local config = Config.Throwables.pearl
    local drag = config.drag or Config.Potion.drag
    local gravity, speed = config.gravity, config.speed
    local eye = Physics.eye(s)
    local horizontal = destination - eye
    local yaw = math.atan2(-horizontal.X, -horizontal.Z)
    local origin = eye + Vector3.new(math.cos(yaw), 0, -math.sin(yaw)) * Config.Potion.sideOffset - Vector3.new(0, .1, 0)
    local delta = destination - origin
    local function velocity(ticks)
        local travel, drop
        if math.abs(1 - drag) < .000001 then travel = ticks; drop = ticks * (ticks - 1) / 2
        else travel = (1 - drag ^ ticks) / (1 - drag); drop = (ticks - travel) / (1 - drag) end
        return (delta + Vector3.new(0, gravity * drop, 0)) / travel
    end
    local previousTime, previousError = .5, velocity(.5).Magnitude - speed
    for ticks = 1, math.min(Config.Potion.maxLifeTicks or 200, 240) do
        local difference = velocity(ticks).Magnitude - speed
        if previousError * difference <= 0 then
            local low, high, lowError = previousTime, ticks, previousError
            for _ = 1, 16 do
                local middle = (low + high) / 2
                local e = velocity(middle).Magnitude - speed
                if lowError * e <= 0 then high = middle else low = middle; lowError = e end
            end
            local flight = (low + high) / 2
            local v = velocity(flight)
            local pitch = math.atan2(v.Y, Vector3.new(v.X, 0, v.Z).Magnitude) - math.rad(config.pitchOffset or 0)
            local aimYaw = math.atan2(-v.X, -v.Z)
            local position, speedVector = Throwable.launch('pearl', eye, aimYaw, pitch, Vector3.zero)
            local clear = true
            for _ = 1, math.ceil(flight) do
                local nextPosition, nextVelocity = Throwable.step('pearl', position, speedVector)
                local hit = worldDistance(position, nextPosition - position, s.world, target)
                if hit < (nextPosition - position).Magnitude - .01 then
                    if (position - destination).Magnitude > 3 then clear = false end
                    break
                end
                position, speedVector = nextPosition, nextVelocity
            end
            if clear and math.abs(pitch) < 1.55 then return {yaw = aimYaw, pitch = pitch} end
        end
        previousTime, previousError = ticks, difference
    end
end
local function observePearl(now)
    local entry = targetEntry()
    if not held or not C.enabled or not C.pearlFollow or not entry or not allowed(target, entry) then
        pendingPearl, observedId, observedPosition = nil, nil, nil
        return
    end
    if observedId == target and observedPosition and (entry.rendered - observedPosition).Magnitude > 6 then
        local s = state()
        if s and (entry.rendered - s.position).Magnitude > 8 then pendingPearl = {id = target, destination = entry.rendered + Vector3.new(0, .25, 0), expires = now + 2.5} end
    end
    observedId, observedPosition = target, entry.rendered
end
local function followPearl(now)
    if not pendingPearl then return end
    if now > pendingPearl.expires or target ~= pendingPearl.id or not active() or not C.pearlFollow then pendingPearl = nil; return end
    if potBusy or now < nextPearl or Inventory.pearlReadyAt() > workspace:GetServerTimeNow() then return end
    local s = state()
    if not s or (LP:GetAttribute('Health') or 0) <= C.health then return end
    local slot
    for i = 1, HOTBAR do local item = Inventory.items[i]; if item and item.id == 'pearl' then slot = i; break end end
    if not slot then pendingPearl = nil; return end
    local aim = pearlAim(s, pendingPearl.destination)
    if not aim then pendingPearl = nil; return end
    if not nativeReady() then return end
    if nativeThrow('pearl', slot, aim) then
        Inventory.startPearlCooldown(workspace:GetServerTimeNow() + Config.Pearl.cooldownSeconds)
        pendingPearl = nil
        nextPearl = now + Config.Pearl.cooldownSeconds
    else nextPearl = now + Config.TICK end
end
local pendingRefills = {}
local lootPending, lootChestId, lootRetry = {}, nil, {}
local function refill(now)
    if not C.refill or now < nextRefill or potBusy then return end
    local reserved = {}
    for destination, pending in pairs(pendingRefills) do
        local from = Inventory.items[pending.from]
        local to = Inventory.items[destination]
        local changed = from ~= pending.item or (to and to.id == 'heal')
        if acknowledged(pending.seq) or (not pending.seq and changed) then pendingRefills[destination] = nil
        else reserved[pending.from] = true; reserved[destination] = true end
    end
    if next(lootPending) ~= nil then return end
    local empty, sources = {}, {}
    for i = 1, HOTBAR do if not Inventory.items[i] and not reserved[i] then table.insert(empty, i) end end
    for i = HOTBAR + 1, SLOTS do local item = Inventory.items[i]; if item and item.id == 'heal' and not reserved[i] then table.insert(sources, i) end end
    for i = 1, math.min(#empty, #sources, 4) do
        local source, destination = sources[i], empty[i]
        local item, oldSequence = Inventory.items[source], sequence()
        Inventory.swapSlots(source, destination)
        local seq = sequence()
        pendingRefills[destination] = {from = source, item = item, seq = seq ~= oldSequence and seq or nil}
    end
    nextRefill = now
end
local function isSupply(chest)
    if not chest or chest.menu or not chest.size then return false end
    local name = string.lower(tostring(chest.id or '') .. ' ' .. tostring(chest.title or ''))
    return string.find(name, 'supply', 1, true) ~= nil or string.find(name, 'airdrop', 1, true) ~= nil
end
local function lootSupply(now)
    local chest = Inventory.chest
    if not C.loot or not Inventory.open or not isSupply(chest) or potBusy then lootPending, lootChestId, lootRetry = {}, nil, {}; return end
    if not functions.quickMove then report('supply loot', 'Native quick-move function unavailable'); return end
    if lootChestId ~= chest.id then lootPending, lootRetry, lootChestId = {}, {}, chest.id end
    for slot, pending in pairs(lootPending) do
        local item = Inventory.items[slot]
        local changed = not item or item.id ~= pending.id or (item.count or 1) < pending.count
        if acknowledged(pending.seq) or (not pending.seq and changed) then
            lootPending[slot] = nil
            if not changed then lootRetry[slot] = now + .25 end
        end
    end
    local shadow = InventoryOps.clone(Inventory.items)
    for slot, pending in pairs(lootPending) do
        if not pending.predicted and shadow[slot] then InventoryOps.quick(shadow, slot, chest.size, false) end
    end
    local occupied, roomExists, sent = false, false, 0
    local started = os.clock()
    for index = 1, math.min(chest.size, Items.CHEST_MAX) do
        local slot = Items.CHEST + index
        local item = Inventory.items[slot]
        if item then
            occupied = true
            if InventoryOps.room(Inventory.items, item.id, item.m) > 0 then roomExists = true end
            if not lootPending[slot] and now >= (lootRetry[slot] or 0) and InventoryOps.room(shadow, item.id, item.m) > 0 then
                local count, oldSequence = item.count or 1, sequence()
                functions.quickMove(slot)
                local seq, current = sequence(), Inventory.items[slot]
                local changed = not current or current.id ~= item.id or (current.count or 1) < count
                if seq ~= oldSequence or changed then
                    lootPending[slot] = {id = item.id, count = count, seq = seq ~= oldSequence and seq or nil, predicted = changed}
                    InventoryOps.quick(shadow, slot, chest.size, false)
                    sent = sent + 1
                else lootRetry[slot] = now + .25 end
                if sent >= 4 or os.clock() - started >= .002 then break end
            end
        end
    end
    if next(lootPending) == nil and (not occupied or not roomExists) then Inventory.setOpen(false); lootChestId = nil end
end
local function acquireTarget(camera)
    local center, best, score = camera.ViewportSize * .5, nil, math.huge
    local s = state()
    for id, entry in pairs(Others) do
        if allowed(id, entry) then
            local aimPosition = entry.creature and Physics.hitbox(entry.rendered, nil, entry.size) or (entry.rendered + Vector3.new(0, .9, 0))
            local p, onScreen = camera:WorldToViewportPoint(aimPosition * scale)
            if onScreen and p.Z > 0 then
                local errorValue = (Vector2.new(p.X, p.Y) - center).Magnitude
                if errorValue <= C.radius and errorValue < score and (not C.wallCheck or (s and clearPath(s, entry, id))) then best, score = id, errorValue end
            end
        end
    end
    return best
end
function combatHud.bow.isBow()
    local item = Inventory.selectedItem()
    if not item then return false end
    if type(Items.isBow) == 'function' then return Items.isBow(item.id) end
    return (Items.defs[item.id] or {}).bow == true
end
function combatHud.bow.wanted()
    if not alive or not C.bowBoost or not combatHud.bow.isBow() or combatHud.freecam.active or Inventory.open or textFocused or menuOpen or rebinding or inputState.speed or not state() or (Match and Match.frozen()) then return false end
    if combatHud.sync.bot and combatHud.sync.bot() then
        local data = combatHud.sync.fresh() and combatHud.sync.remote
        return data and data.use or false
    end
    if not windowFocused then return false end
    local ok, focus = pcall(UIS.GetFocusedTextBox, UIS)
    if not ok or focus then return false end
    local pressed, down = pcall(UIS.IsMouseButtonPressed, UIS, Enum.UserInputType.MouseButton2)
    return pressed and down
end
function combatHud.bow.drawState()
    for _, owner in pairs({combatHud.bow.original, functions.bowUpdate, functions.stateOwner}) do
        if type(owner) == 'function' then
            local ok, values = pcall(upvalues, owner)
            if ok and type(values) == 'table' then
                local index = owner ~= functions.stateOwner and functions.bowStateIndex
                local scalar = index and values[index]
                if finiteNumber(scalar) and scalar >= 0 then return {slot = Inventory.selected, ticks = scalar} end
                for _, value in pairs(values) do
                    if type(value) == 'table' and rawget(value, 'slot') == Inventory.selected and finiteNumber(rawget(value, 'ticks')) then return value end
                end
            end
        end
    end
end
function combatHud.bow.update(original, using, item, ...)
    local bow = combatHud.bow
    if bow.active and (combatHud.freecam.active or Inventory.open or textFocused or menuOpen or rebinding) then
        bow.active, bow.ticks, bow.slot = false, 0, nil
        return original(true, nil, ...)
    end
    if not bow.wanted() then bow.active, bow.ticks, bow.slot = false, 0, nil; return original(using, item, ...) end
    if bow.slot ~= Inventory.selected then bow.slot, bow.ticks = Inventory.selected, 0 end
    bow.active = true
    local result = table.pack(original(true, item, ...))
    bow.ticks = (bow.ticks or 0) + 1
    local draw = bow.drawState()
    local ticks = math.max(bow.ticks, draw and draw.ticks or 0)
    local power = Throwable.bowPower(ticks)
    if ticks * Config.TICK * 1000 >= 150 and power >= Config.Bow.minPower then
        original(false, item, ...)
        bow.knockbackUntil = os.clock() + .8
        bow.ticks = 0
    end
    return table.unpack(result, 1, result.n)
end
if functions.bowUpdate then
    combatHud.bow.original = install(functions.bowUpdate, function(original, ...) return combatHud.bow.update(original, ...) end)
else
    report('bow', 'Native bow handler was not verified; bow boost is unavailable. Manual bow use is unchanged.')
end
function combatHud.allowBoostKnockback()
    return C.bowBoost and functions.bowUpdate and ((combatHud.bow.wanted and combatHud.bow.wanted()) or os.clock() < (combatHud.bow.knockbackUntil or 0)) or false
end
combatHud.knockback = {receiver = false, scaling = false}
if functions.velocityActive and functions.velocityConfig then
    local first = #hooks
    local activeHook = install(functions.velocityActive, function(original, key, ...)
        if alive and C.noKnockback and key == 'velocity' then return not combatHud.allowBoostKnockback() end
        return original(key, ...)
    end, true)
    local configHook = activeHook and install(functions.velocityConfig, function(original, key, ...)
        if alive and C.noKnockback and key == 'velocity' and not combatHud.allowBoostKnockback() then
            local factor = 1 - math.clamp(C.knockbackReduction or 100, 0, 100) / 100
            return {horizontal = factor, vertical = factor}
        end
        return original(key, ...)
    end, true)
    combatHud.knockback.scaling = activeHook ~= nil and configHook ~= nil
    if not combatHud.knockback.scaling then
        for i = #hooks, first + 1, -1 do
            pcall(hookfunction, hooks[i][1], hooks[i][2])
            table.remove(hooks, i)
        end
        functions.velocityActive, functions.velocityConfig = nil, nil
    end
end
if functions.velocityHandler then
    local receiver = install(functions.velocityHandler, function(original, ...)
        if alive and C.noKnockback and not combatHud.allowBoostKnockback() and not combatHud.knockback.scaling then
            local impulse = ...
            local body = state()
            if body and typeof(impulse) == 'Vector3' and typeof(body.velocity) == 'Vector3' then
                local current = body.velocity
                local factor = 1 - math.clamp(C.knockbackReduction or 100, 0, 100) / 100
                return original(current + (impulse - current) * factor, select(2, ...))
            end
        end
        return original(...)
    end, true)
    combatHud.knockback.receiver = receiver ~= nil
    if not receiver then functions.velocityHandler = nil end
end
if not combatHud.knockback.receiver and not combatHud.knockback.scaling then
    C.noKnockback = false
    report('knockback', 'Native velocity hooks could not be installed; no knockback is unavailable.')
end
function combatHud.knockbackStatus()
    return {enabled = C.noKnockback, receiver = combatHud.knockback.receiver, scaling = combatHud.knockback.scaling, reduction = C.knockbackReduction, bowException = combatHud.allowBoostKnockback()}
end

local function attackTarget(now)
    local s, entry = state(), targetEntry()
    if not active() or not s or not allowed(target, entry) or potBusy or s.blocking or C.cps <= 0 or now < nextClick then return false end
    if Match and Match.frozen() then return false end
    if distance(entry, s) > C.reach or (C.wallCheck and not clearPath(s, entry, target)) then return false end
    orient(s, entry)
    local period = 1 / C.cps
    if now - nextClick > period then nextClick = now end
    nextClick = nextClick + period
    local ok = guard('native attack', functions.attack, target)
    return ok
end
local function quickDropStep(now)
    if combatHud.freecam and combatHud.freecam.active then inputState.dropHeld = false; inputState.dropSession = nil; inputState.dropAwaitRelease = true; return false end
    local polled, down = pcall(UIS.IsKeyDown, UIS, Enum.KeyCode.Q)
    if combatHud.sync and combatHud.sync.bot and combatHud.sync.bot() then down = combatHud.sync.fresh() and combatHud.sync.remote.drop
    elseif not polled then down = inputState.dropHeld end
    if not down then inputState.dropAwaitRelease = false; inputState.dropSession = nil; return false end
    local focusOK, focus = pcall(UIS.GetFocusedTextBox, UIS)
    if not C.quickDrop or (not windowFocused and not (combatHud.sync.fresh and combatHud.sync.bot() and combatHud.sync.fresh())) or not focusOK or focus or textFocused or menuOpen or rebinding or bindAwaitRelease then
        inputState.dropAwaitRelease = true; inputState.dropSession = nil; return false
    end
    if inputState.dropAwaitRelease then return false end
    if not inputState.dropSession then inputState.dropSession = {opened = Inventory.open}; inputState.nextDrop = now + .04 end
    if inputState.dropSession.opened and not Inventory.open then return true end
    if potBusy or now < inputState.nextDrop then return true end
    local slot = Inventory.selected
    if Inventory.open then
        if not functions.dropHandler then return true end
        local values = upvalues(functions.dropHandler)
        if values[2] ~= Inventory or type(values[6]) ~= 'table' or values[7] then return true end
        slot = values[6].slot
    end
    if not finiteNumber(slot) or slot % 1 ~= 0 or slot < 1 or slot > Items.CHEST + Items.CHEST_MAX then return true end
    if not Inventory.open and slot > HOTBAR then return true end
    local item = Inventory.items[slot]
    if not item or not Items.canDrop(item.id) then return true end
    if Inventory.chest and Inventory.chest.menu and slot > Items.CHEST then return true end
    if now - inputState.nextDrop > .04 then inputState.nextDrop = now end
    inputState.nextDrop = inputState.nextDrop + .04
    local leftOK, left = pcall(UIS.IsKeyDown, UIS, Enum.KeyCode.LeftControl)
    local rightOK, right = pcall(UIS.IsKeyDown, UIS, Enum.KeyCode.RightControl)
    local whole = (leftOK and left) or (rightOK and right) or false
    if combatHud.sync.bot and combatHud.sync.bot() then
        local keys = combatHud.sync.mirrorKeys or {}
        whole = keys.LeftControl or keys.RightControl or false
    end
    if functions.dropPressed then functions.dropPressed(slot, whole, 'Q')
    elseif type(Inventory.holdDrop) == 'function' then Inventory.holdDrop(slot) end
    return true
end
function combatHud.sync.bot()
    return C.botMode and LP.Name:lower() ~= combatHud.sync.main
end
function combatHud.sync.fresh()
    local sync = combatHud.sync
    return C.botMode and sync.socket ~= nil and sync.role == 'bot' and sync.remote ~= nil and os.clock() - (sync.received or 0) < .8 and sync.remote.alive
end
function combatHud.sync.close(alreadyClosed)
    local sync = combatHud.sync
    local socket = sync.socket
    sync.socket, sync.remote, sync.role, sync.received = nil, nil, nil, nil
    if sync.releaseKeys then sync.releaseKeys() end
    if sync.closeChat then sync.closeChat() end
    sync.queue, sync.peers, sync.lastEvent, sync.lastSequence = {}, {}, nil, nil
    sync.mainKeys = {}
    for _, connection in ipairs(sync.connections or {}) do pcall(function() connection:Disconnect() end) end
    sync.connections = {}
    if socket and not alreadyClosed then pcall(function() socket:Close() end) end
end
function combatHud.sync.emit(event)
    local sync = combatHud.sync
    if not C.botMode or LP.Name:lower() ~= sync.main then return end
    sync.serial = sync.serial + 1
    event.id, event.expires = sync.serial, os.clock() + 2
    table.insert(sync.events, event)
    if #sync.events > 32 then table.remove(sync.events, 1) end
end
function combatHud.sync.receive(raw)
    local sync = combatHud.sync
    if type(raw) ~= 'string' or #raw > 32768 then return end
    local ok, message = pcall(HttpService.JSONDecode, HttpService, raw)
    if not ok or type(message) ~= 'table' then return end
    if message.type == 'error' then
        report('relay', tostring(message.message or 'Relay rejected a packet'))
    elseif message.type == 'welcome' then
        sync.role, sync.slot = message.role, tonumber(message.slot) or 1
        sync.lastEvent, sync.lastSequence = nil, nil
    elseif message.type == 'stop' then
        if sync.releaseKeys then sync.releaseKeys() end
        if sync.closeChat then sync.closeChat() end
        sync.remote, sync.received, sync.queue = nil, nil, {}
    elseif message.type == 'roster' and type(message.users) == 'table' then
        sync.peers = {}
        for _, id in ipairs(message.users) do sync.peers[id] = true end
    elseif message.type == 'state' and sync.role == 'bot' and finiteNumber(message.seq) and (not sync.lastSequence or message.seq > sync.lastSequence) then
        local data = message.state
        if type(data) ~= 'table' or type(data.position) ~= 'table' or not finiteNumber(data.position[1]) or not finiteNumber(data.position[2]) or not finiteNumber(data.position[3]) or not finiteNumber(data.yaw) or not finiteNumber(data.pitch) then return end
        sync.lastSequence, sync.remote, sync.received = message.seq, data, os.clock()
        if message.stream and message.stream ~= sync.stream then sync.stream, sync.lastEvent, sync.queue = message.stream, nil, {} end
        local previous = sync.lastEvent
        for _, event in ipairs(data.events or {}) do
            if finiteNumber(event.id) then
                if previous and event.id > previous then
                    local copy = {}
                    for key, value in pairs(event) do copy[key] = value end
                    copy.expires = os.clock() + 2.5
                    if (copy.kind == 'reset' or copy.kind == 'chat' or copy.kind == 'key') and sync.immediate then
                        guard('mirrored input', sync.immediate, copy)
                    elseif #sync.queue < 32 then table.insert(sync.queue, copy) end
                end
                sync.lastEvent = math.max(sync.lastEvent or 0, event.id)
            end
        end
        if sync.lastEvent == nil then sync.lastEvent = 0 end
        if sync.chatState then guard('chat mirror', sync.chatState, data.chat) end
        if type(data.settings) == 'table' then
            for _, key in ipairs({'enabled', 'entityTarget', 'noKnockback', 'bowBoost', 'wallCheck', 'autoPot', 'refill', 'pearlFollow', 'noHitSlow'}) do if type(data.settings[key]) == 'boolean' then C[key] = data.settings[key] end end
            for _, key in ipairs({'cps', 'health', 'reach', 'knockbackReduction'}) do
                local range, value = configRanges[key], data.settings[key]
                if range and finiteNumber(value) then C[key] = math.clamp(value, range[1], range[2]) end
            end
        end
    end
end
function combatHud.sync.closeChat()
    local sync = combatHud.sync
    if not sync.chatOwned then return end
    sync.chatOwned = nil
    if sync.nativeChatClose then sync.nativeChatClose()
    elseif sync.chat and sync.chatBox then sync.chat.open = false; sync.chatBox.Visible = false; sync.chatBox:ReleaseFocus(false) end
end
function combatHud.sync.chatSnapshot()
    local sync = combatHud.sync
    if not sync.chat or not sync.chatBox then return nil end
    local text = sync.chatBox.Text
    if #text > 4096 then return nil end
    return {open = not not sync.chat.open, text = text, cursor = sync.chatBox.CursorPosition, selection = sync.chatBox.SelectionStart, clan = not not sync.chat.clanChat}
end
function combatHud.sync.chatState(data)
    local sync = combatHud.sync
    if not sync.bot() or type(data) ~= 'table' or not sync.chat or not sync.chatBox then return end
    if not data.open then sync.closeChat(); return end
    sync.chatOwned = true
    sync.chat.clanChat = data.clan == true
    if not sync.chat.open then sync.chat.openWith('') end
    if type(data.text) == 'string' and #data.text <= 4096 and sync.chatBox.Text ~= data.text then sync.chatBox.Text = data.text end
    if finiteNumber(data.cursor) then sync.chatBox.CursorPosition = math.clamp(data.cursor, -1, #sync.chatBox.Text + 1) end
    if finiteNumber(data.selection) then sync.chatBox.SelectionStart = math.clamp(data.selection, -1, #sync.chatBox.Text + 1) end
end
function combatHud.sync.keyInput(key, down)
    local ok, code = pcall(function() return Enum.KeyCode[key] end)
    if not ok or not code or code == Enum.KeyCode.Unknown then return nil end
    return {KeyCode = code, UserInputType = Enum.UserInputType.Keyboard, UserInputState = down and Enum.UserInputState.Begin or Enum.UserInputState.End, Position = Vector3.zero, Delta = Vector3.zero}
end
function combatHud.sync.dispatchKey(key, down)
    local sync = combatHud.sync
    local input = sync.keyInput(key, down)
    if not input then return end
    sync.mirrorKeys = sync.mirrorKeys or {}
    if not down and not sync.mirrorKeys[key] then return end
    if down and sync.mirrorKeys[key] then return end
    sync.mirrorKeys[key] = down or nil
    if key == 'RightShift' and down then panel.Visible = not panel.Visible; return end
    if key == 'V' or key == 'Q' then return end
    if (Settings.pressed and (Settings.pressed('chat', input) or Settings.pressed('command', input))) then return end
    if type(getconnections) ~= 'function' then
        report('key mirror', 'Executor getconnections is unavailable; held actions, chat and resets still use their native handlers')
        return
    end
    local signal = down and UIS.InputBegan or UIS.InputEnded
    local ok, handlers = pcall(getconnections, signal)
    if not ok then report('key mirror', handlers); return end
    for _, connection in ipairs(handlers) do
        local readable, callback = pcall(function() return connection.Function end)
        if not readable then callback = nil end
        if type(callback) == 'function' and not (sync.ownHandlers and sync.ownHandlers[callback]) then
            local owned = false
            if getfenv then
                pcall(function()
                    local owner = getfenv(callback).script
                    owned = typeof(owner) == 'Instance' and owner:IsDescendantOf(LP)
                end)
            end
            if owned then guard('game key handler', callback, input, false) end
        end
    end
end
function combatHud.sync.releaseKeys()
    local sync = combatHud.sync
    local keys = {}
    for key in pairs(sync.mirrorKeys or {}) do table.insert(keys, key) end
    for _, key in ipairs(keys) do sync.dispatchKey(key, false) end
end
function combatHud.sync.immediate(event)
    local sync = combatHud.sync
    if not sync.bot() then return end
    if event.kind == 'key' then
        if type(event.key) == 'string' and type(event.down) == 'boolean' then sync.dispatchKey(event.key, event.down) end
    elseif event.kind == 'reset' then
        sync.releaseKeys()
        sync.closeChat()
        if sync.resetEvent then sync.resetEvent:Fire()
        elseif sync.net and sync.net.Hcf then sync.net.Hcf:FireServer('reset') end
    elseif event.kind == 'chat' and type(event.text) == 'string' and #event.text <= 4096 then
        if sync.nativeChatSend then
            sync.chat.clanChat = event.clan == true
            sync.nativeChatSend(event.text)
            sync.closeChat()
        else report('chat mirror', 'Native chat sender is unavailable') end
    end
end
function combatHud.sync.bindExtras()
    local sync = combatHud.sync
    if sync.extrasBound then return end
    sync.extrasBound = true
    sync.net = functions.net or (functions.autoHeal and upvalues(functions.autoHeal)[11])
    local records = {}
    local starter = game:GetService('StarterGui')
    local textChat = game:GetService('TextChatService')
    for _, fn in pairs(gcObjects) do
        if type(fn) == 'function' then
            local ok, values = pcall(upvalues, fn)
            if ok and type(values) == 'table' then
                table.insert(records, {fn = fn, v = values})
                if type(values[1]) == 'table' and type(rawget(values[1], 'openWith')) == 'function' and type(rawget(values[1], 'colorize')) == 'function' and type(rawget(values[1], 'add')) == 'function' then
                    pcall(function()
                        if typeof(values[2]) == 'Instance' and values[2]:IsA('TextBox') then sync.chat, sync.chatBox = values[1], values[2] end
                    end)
                end
                if values[1] == starter then
                    pcall(function()
                        if typeof(values[2]) == 'Instance' and values[2]:IsA('BindableEvent') then sync.resetEvent = values[2] end
                    end)
                end
            end
        end
    end
    for _, record in ipairs(records) do
        local v = record.v
        if sync.chat and v[1] == sync.chat then
            if v[3] == sync.net and v[4] == textChat and type(v[5]) == 'function' then sync.nativeChatSend = record.fn end
            if v[2] == sync.chatBox and type(v[4]) == 'number' and type(v[5]) == 'number' and type(v[7]) == 'function' and type(v[8]) == 'function' and type(v[9]) == 'function' then sync.nativeChatClose = record.fn end
        end
    end
    if sync.resetEvent then
        connect(sync.resetEvent.Event, function() if C.botMode and not sync.bot() then sync.emit({kind = 'reset'}) end end)
    else report('reset mirror', 'Native reset button callback is unavailable; bot reset cannot observe this client version') end
    if sync.nativeChatSend then
        install(sync.nativeChatSend, function(original, text, ...)
            local result = table.pack(original(text, ...))
            if C.botMode and not sync.bot() and type(text) == 'string' and #text <= 4096 then sync.emit({kind = 'chat', text = text, clan = sync.chat.clanChat == true}) end
            return table.unpack(result, 1, result.n)
        end)
    else report('chat mirror', 'Native chat sender is unavailable in this client version') end
end
connect(UIS.InputBegan, function(input, processed)
    local sync = combatHud.sync
    if not C.botMode or sync.bot() or processed or combatHud.freecam.active or input.UserInputType ~= Enum.UserInputType.Keyboard then return end
    if UIS:GetFocusedTextBox() then return end
    sync.mainKeys = sync.mainKeys or {}
    local key = input.KeyCode.Name
    if key == 'Unknown' or sync.mainKeys[key] then return end
    sync.mainKeys[key] = true
    sync.emit({kind = 'key', key = key, down = true})
end)
connect(UIS.InputEnded, function(input)
    local sync = combatHud.sync
    if not C.botMode or sync.bot() or input.UserInputType ~= Enum.UserInputType.Keyboard then return end
    local key = input.KeyCode.Name
    if sync.mainKeys and sync.mainKeys[key] then
        sync.mainKeys[key] = nil
        sync.emit({kind = 'key', key = key, down = false})
    end
end)
connect(UIS.WindowFocusReleased, function()
    local sync = combatHud.sync
    if C.botMode and not sync.bot() then
        for key in pairs(sync.mainKeys or {}) do sync.emit({kind = 'key', key = key, down = false}) end
        sync.mainKeys = {}
    end
end)

function combatHud.sync.open()
    local sync = combatHud.sync
    if sync.connecting or sync.socket or os.clock() < sync.nextConnect then return end
    if sync.bindExtras then sync.bindExtras() end
    sync.connecting, sync.nextConnect = true, os.clock() + 3
    task.spawn(function()
        local options = env.WebSocket or WebSocket or env.websocket or websocket or (syn and syn.websocket)
        local connector = options and (options.connect or options.Connect)
        if type(connector) ~= 'function' then sync.connecting = false; report('bot sync', 'Executor WebSocket.connect is unavailable'); return end
        local ok, socket = pcall(connector, sync.url)
        sync.connecting = false
        if not ok then report('bot sync', socket); return end
        if not alive or not C.botMode then pcall(function() socket:Close() end); return end
        sync.socket, sync.connections = socket, {}
        local attached, err = pcall(function()
            table.insert(sync.connections, socket.OnMessage:Connect(function(raw) if sync.socket == socket then guard('bot packet', sync.receive, raw) end end))
            table.insert(sync.connections, socket.OnClose:Connect(function(code, reason)
                if sync.socket ~= socket then return end
                report('bot connection', 'Relay disconnected: ' .. tostring(code or 'no close code') .. ' ' .. tostring(reason or ''))
                sync.nextConnect = os.clock() + 5
                sync.close(true)
            end))
            sync.streamId = sync.streamId or HttpService:GenerateGUID(false)
            socket:Send(HttpService:JSONEncode({type = 'hello', token = sync.token, name = LP.Name, userId = LP.UserId, placeId = game.PlaceId, jobId = game.JobId, stream = sync.streamId}))
        end)
        if not attached then sync.close(); report('bot sync', err) end
    end)
end
function combatHud.sync.step(now)
    local sync = combatHud.sync
    if not C.botMode then
        if sync.socket then sync.close() end
        return
    end
    sync.open()
    if sync.bot() then
        if not sync.fresh() then
            if not sync.remote or os.clock() - (sync.received or 0) >= .8 then
                if sync.releaseKeys then sync.releaseKeys() end
                if sync.closeChat then sync.closeChat() end
            end
            sync.queue = {}; return
        end
        local data = sync.remote
        local first = sync.queue[1]
        if first and first.kind == 'speed' and not inputState.speed then
            table.remove(sync.queue, 1)
            if now <= first.expires then inputState.speed = {stage = 'request', expires = now + 2} end
        end
        if not inputState.speed and not Inventory.open and type(data.item) == 'string' and data.item ~= '' then
            local current = Inventory.selectedItem()
            if not current or current.id ~= data.item then
                for i = 1, HOTBAR do
                    if Inventory.items[i] and Inventory.items[i].id == data.item then Inventory.select(i); break end
                end
            end
        end
        return
    end
    if sync.role ~= 'main' or not sync.socket or now < (sync.nextSend or 0) then return end
    sync.nextSend = now + .1
    local s = state() or sync.lastPose
    if not s then return end
    sync.lastPose = s
    for i = #sync.events, 1, -1 do if now > sync.events[i].expires then table.remove(sync.events, i) end end
    local settings = {}
    for _, key in ipairs({'enabled', 'entityTarget', 'noKnockback', 'bowBoost', 'wallCheck', 'autoPot', 'refill', 'pearlFollow', 'noHitSlow', 'cps', 'health', 'reach', 'knockbackReduction'}) do settings[key] = C[key] end
    local item = Inventory.selectedItem()
    local input = sync.input or {}
    local actions = {}
    for action in pairs(Settings.binds or {}) do
        if type(action) == 'string' then actions[action] = not not Settings.held(action) end
    end
    local chat = sync.chatSnapshot and sync.chatSnapshot() or nil
    local data = {position = {s.position.X, s.position.Y, s.position.Z}, yaw = s.yaw, pitch = s.pitch,
        target = held and C.enabled and not combatHud.freecam.active and not combatHud.bow.active and target or nil, held = not not (held and C.enabled and not combatHud.freecam.active and not combatHud.bow.active), alive = (LP:GetAttribute('Health') or 0) > 0,
        jump = not not input.jump, sneak = not not input.sneak, sprint = not not s.sprinting,
        use = not not (windowFocused and not textFocused and not menuOpen and not Inventory.open and Settings.held('use')),
        drop = not not (inputState.dropHeld and windowFocused and not textFocused and not menuOpen and not Inventory.open),
        item = item and item.id or '', settings = settings, events = sync.events, actions = actions, chat = chat}
    local ok, err = pcall(function() sync.socket:Send(HttpService:JSONEncode({type = 'state', state = data})) end)
    if not ok then sync.close(); report('bot send', err) end
end
function combatHud.sync.move(s, input)
    local sync = combatHud.sync
    if not C.botMode then return end
    if not sync.bot() then sync.input = {jump = input.jump, sneak = input.sneak}; return end
    input.forward, input.strafe, input.jump, input.sneak = 0, 0, false, false
    if not sync.fresh() or Inventory.open or textFocused or menuOpen or inputState.speed or (sync.remote.chat and sync.remote.chat.open) or (Match and Match.frozen()) then s.sprinting, s.sprintIntent = false, false; return end
    local data = sync.remote
    local destination = Vector3.new(data.position[1], data.position[2], data.position[3])
    local fighting = held and C.enabled and target and Others[target]
    if fighting and allowed(target, fighting) then destination = fighting.rendered end
    local angle = ((sync.slot or 1) - 1) * math.pi * 2 / 10
    local radius = fighting and 2 or 2.5
    destination = destination + Vector3.new(math.cos(angle) * radius, 0, math.sin(angle) * radius)
    local delta = Vector3.new(destination.X - s.position.X, 0, destination.Z - s.position.Z)
    local length = delta.Magnitude
    if not fighting then s.yaw, s.pitch = data.yaw, data.pitch end
    if length > .65 then
        local magnitude = math.min(1, (length - .5) / 1.5)
        local x, z = delta.X / length * magnitude, delta.Z / length * magnitude
        input.forward = math.clamp(-math.sin(s.yaw) * x - math.cos(s.yaw) * z, -1, 1)
        input.strafe = math.clamp(math.cos(s.yaw) * x - math.sin(s.yaw) * z, -1, 1)
        input.jump = data.jump or (s.collidedHorizontally and s.onGround) or false
    else input.jump = data.jump end
    input.sneak, input.keys = data.sneak, true
    s.sneaking = data.sneak
    s.sprinting, s.sprintIntent = data.sprint and not data.sneak, data.sprint and not data.sneak
end
function combatHud.sync.actions(now)
    local sync = combatHud.sync
    if not sync.fresh() or not sync.queue[1] or inputState.speed or not state() then return end
    local event = sync.queue[1]
    if now > event.expires then table.remove(sync.queue, 1); return end
    if event.kind ~= 'throw' then return end
    local slot
    for i = 1, HOTBAR do if Inventory.items[i] and Inventory.items[i].id == event.item then slot = i; break end end
    if not slot then table.remove(sync.queue, 1); return end
    if event.item == 'pearl' and Inventory.pearlReadyAt() > workspace:GetServerTimeNow() then return end
    local aim = {yaw = event.yaw, pitch = event.pitch}
    if event.item == 'pearl' and type(event.destination) == 'table' then
        aim = pearlAim(state(), Vector3.new(event.destination[1], event.destination[2], event.destination[3]))
        if not aim then return end
    end
    if nativeThrow(event.item, slot, aim) then
        if event.item == 'pearl' then Inventory.startPearlCooldown(workspace:GetServerTimeNow() + Config.Pearl.cooldownSeconds) end
        table.remove(sync.queue, 1)
    end
end
if functions.throwItem then install(functions.throwItem, function(original, kind, slot, pitch, ...)
    local sync, s = combatHud.sync, state()
    local before = Inventory.items[slot or Inventory.selected]
    local count = before and (before.count or 1)
    local yaw = s and s.yaw
    local result = table.pack(original(kind, slot, pitch, ...))
    local after = Inventory.items[slot or Inventory.selected]
    if C.botMode and not sync.bot() and s and count and (not after or after.id ~= kind or (after.count or 1) < count) then
        local event = {kind = 'throw', item = kind, yaw = yaw, pitch = pitch or s.pitch}
        if kind == 'pearl' and pendingPearl then local p = pendingPearl.destination; event.destination = {p.X, p.Y, p.Z} end
        sync.emit(event)
    end
    return table.unpack(result, 1, result.n)
end)
end

local function combatStep()
    if not alive then return end
    local now = os.clock()
    if combatHud.sync.step then guard('bot sync', combatHud.sync.step, now) end
    guard('input', updateHeld)
    local speedOK, speeding = guard('speed potion', combatHud.speedStep, now)
    if speedOK and speeding then return end
    local pearlOK, pearling = guard('quick pearl', combatHud.quickPearlStep, now)
    if pearlOK and pearling then return end
    local camera = workspace.CurrentCamera
    if combatHud.sync.bot and combatHud.sync.bot() then
        local data = combatHud.sync.fresh() and combatHud.sync.remote
        target = held and C.enabled and data and data.target or nil
        if target and not allowed(target, Others[target]) then target = nil end
    elseif not held or not C.enabled then updateLock(nil)
    elseif not target and camera and not textFocused and not menuOpen then
        local ok, candidate = guard('acquire', acquireTarget, camera)
        if ok then updateLock(candidate) end
    end
    local dropOK, dropping = guard('quick drop', quickDropStep, now)
    dropping = dropOK and dropping
    if not dropping then guard('supply loot', lootSupply, now); guard('refill', refill, now) end
    local healed = false
    local healOK, used = guard('healing', autoPotion, now)
    if healOK then healed = used end
    guard('pearl observation', observePearl, now)
    if not healed and not dropping then
        if combatHud.sync.bot and combatHud.sync.bot() then guard('synced actions', combatHud.sync.actions, now)
        else guard('pearl follow', followPearl, now) end
    end
    if not healed and not dropping then guard('attack', attackTarget, now) end
end
local function destroy()
    if not alive then return end
    if combatHud.clearRefillStation then pcall(combatHud.clearRefillStation) end
    if combatHud.clearSpawnMarker then pcall(combatHud.clearSpawnMarker) end
    if combatHud.freecam.stop then combatHud.freecam.stop() end
    if combatHud.freecam.bound then pcall(RS.UnbindFromRenderStep, RS, 'PurpleHCFFreecam') end
    if combatHud.sync.close then combatHud.sync.close() end
    if combatHud.clearDeath then combatHud.clearDeath() end
    if inputState.speed and inputState.speed.hand then inputState.speed.stage = 'restore'; guard('speed restore', combatHud.speedStep, os.clock()) end
    inputState.speed = nil
    saveConfig()
    alive, held, target = false, false, nil
    if restoreFreeLook then pcall(restoreFreeLook) end
    for _, connection in ipairs(connections) do connection:Disconnect() end
    for i = #hooks, 1, -1 do pcall(hookfunction, hooks[i][1], hooks[i][2]) end
    local s = state()
    if s and wasTracking and freeYaw then s.yaw, s.pitch = freeYaw, freePitch end
    for _, item in pairs(chamObjects) do pcall(function() item:Destroy() end) end
    for _, tag in pairs(tags) do pcall(function() tag.billboard:Destroy(); tag.anchor:Destroy() end) end
    for tag, enabled in pairs(nativeTagStates) do pcall(function() if tag.Parent then tag.Enabled = enabled end end) end
    pcall(function() gui:Destroy() end)
    env.PurpleHCF = nil
end
env.PurpleHCF = {Destroy = destroy, Settings = C, SaveConfig = saveConfig, KnockbackStatus = combatHud.knockbackStatus}
connect(close.MouseButton1Click, destroy)
local function nativeTagFor(entry)
    local ok, tag = pcall(function()
        local capsule = rawget(entry, 'capsule')
        local value = type(capsule) == 'table' and rawget(capsule, 'tag')
        if typeof(value) == 'Instance' and value:IsA('BillboardGui') then return value end
    end)
    return ok and tag or nil
end
local function updatePlayerVisual(id, entry, color, now)
    local tag = tags[id]
    if C.esp and not tag then tag = newTag(); tags[id] = tag end
    local nativeTag = nativeTagFor(entry)
    if tag then
        tag.billboard.Enabled = C.esp and not entry.invisible and not entry.creature and (entry.health == nil or entry.health > 0)
        local name = username(id, entry)
        if tag.name.Text ~= name then
            tag.name.Text = name
            tag.frame.Size = UDim2.fromOffset(math.clamp(#name * 8 + 24, 80, 240), 28)
        end
        tag.name.TextColor3 = string.lower(name) == '8zfai' and Color3.fromRGB(95, 255, 148) or color
        guard('equipment ESP', combatHud.equipment, tag, entry)
        local attached = false
        if nativeTag then
            pcall(function()
                local adornee = nativeTag.Adornee
                if adornee and adornee:IsDescendantOf(workspace) then
                    tag.billboard.Adornee = adornee
                    tag.billboard.StudsOffsetWorldSpace = nativeTag.StudsOffsetWorldSpace
                    attached = true
                end
            end)
        end
        if not attached then
            tag.billboard.Adornee = tag.anchor
            tag.billboard.StudsOffsetWorldSpace = Vector3.zero
            tag.anchor.Position = (entry.rendered + Vector3.new(0, 2.25, 0)) * scale
        end
    end
    if nativeTag then
        pcall(function()
            if C.esp then
                if nativeTagStates[nativeTag] == nil then nativeTagStates[nativeTag] = nativeTag.Enabled end
                nativeTag.Enabled = false
            elseif nativeTagStates[nativeTag] ~= nil then
                nativeTag.Enabled = nativeTagStates[nativeTag]; nativeTagStates[nativeTag] = nil
            end
        end)
    end
    local cham = chamObjects[id]
    if C.chams then
        local model = findModel(entry, id)
        if model then
            if not cham then cham = make('Highlight', {Name = 'PurpleHCFCham', DepthMode = Enum.HighlightDepthMode.AlwaysOnTop}, gui); chamObjects[id] = cham end
            cham.Adornee = model; cham.Enabled = true
            cham.FillColor = color; cham.OutlineColor = pink
            cham.FillTransparency = .55 + .13 * math.sin(now * 2 + (tonumber(id) or 0) % 7)
            cham.OutlineTransparency = .08 + .07 * math.sin(now * 3)
        elseif cham then cham.Enabled = false end
    elseif cham then cham.Enabled = false end
end
local function worldVisualStep(now, color)
    local visible = {}
    for id, entry in pairs(Others) do
        if id ~= LP.UserId and entry.rendered then
            visible[id] = true
            if now >= (blockedVisuals[id] or 0) then
                local ok = guard('player visual', updatePlayerVisual, id, entry, color, now)
                if not ok then blockedVisuals[id] = now + 5 end
            end
        end
    end
    for id, tag in pairs(tags) do
        if not visible[id] then pcall(function() tag.billboard:Destroy(); tag.anchor:Destroy() end); tags[id] = nil; blockedVisuals[id] = nil; playerNames[id] = nil end
    end
    for id, cham in pairs(chamObjects) do if not visible[id] then pcall(function() cham:Destroy() end); chamObjects[id] = nil end end
end
function combatHud.worldMarker(position, text, color, offset)
    local anchor = make('Part', {Name = 'PurpleHCFWorldMarker', Anchored = true, CanCollide = false, CanTouch = false, CanQuery = false, Transparency = 1, Size = Vector3.new(.05, .05, .05), Position = position * scale}, workspace)
    local billboard = make('BillboardGui', {Name = text .. ' ESP', Adornee = anchor, Size = UDim2.fromOffset(180, 44), AlwaysOnTop = true, LightInfluence = 0, MaxDistance = 0, ResetOnSpawn = false, StudsOffsetWorldSpace = Vector3.new(0, offset * scale, 0)}, PlayerGui)
    local frame = make('Frame', {Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.fromRGB(12, 20, 27), BackgroundTransparency = .15}, billboard)
    round(frame, 8)
    make('UIStroke', {Color = color, Thickness = 1.2, Transparency = .1}, frame)
    local name = label(text, UDim2.fromOffset(6, 2), UDim2.new(1, -12, 1, -4), frame, 12)
    name.TextColor3, name.TextXAlignment = color, Enum.TextXAlignment.Center
    return {anchor = anchor, billboard = billboard, name = name, chams = {}}
end
combatHud.refillStation = {tags = {}, locations = {}, nextRead = 0}
function combatHud.refillLocations(layout)
    local result, seen = {}, {}
    if type(layout) ~= 'table' then return result end
    for _, item in pairs(layout) do
        if type(item) == 'table' and type(item.at) == 'table' then
            local k, at = tonumber(item.k), item.at
            local x, y, z = tonumber(at[1] or at.x), tonumber(at[2] or at.y), tonumber(at[3] or at.z)
            if finiteNumber(k) and k >= 0 and k % 1 == 0 and finiteNumber(x) and finiteNumber(y) and finiteNumber(z) and not seen[k] then
                seen[k] = true
                table.insert(result, {key = tostring(k), id = k, position = Vector3.new(x, y, z)})
            end
        end
    end
    return result
end
function combatHud.removeWorldMarker(tag)
    for _, cham in pairs(tag.chams or {}) do pcall(function() cham:Destroy() end) end
    pcall(function() tag.billboard:Destroy(); tag.anchor:Destroy() end)
end
function combatHud.clearRefillStation()
    local station = combatHud.refillStation
    for _, tag in pairs(station.tags) do combatHud.removeWorldMarker(tag) end
    station.tags = {}
end
function combatHud.refillStationTag(position)
    return combatHud.worldMarker(position, 'REFILL STATION', Color3.fromRGB(90, 255, 125), 7.3)
end
function combatHud.stationChams(tag, id)
    local folder = workspace:FindFirstChild('HcfPotStations')
    local root = folder and folder:FindFirstChild('PotStation' .. id)
    local seen = {}
    tag.chams = tag.chams or {}
    if root then
        for _, part in ipairs(root:GetDescendants()) do
            if part:IsA('BasePart') then
                seen[part] = true
                local cham = tag.chams[part]
                if not cham then
                    cham = make('BoxHandleAdornment', {Name = 'RefillStationCham', Adornee = part, AlwaysOnTop = true, ZIndex = 4, Color3 = Color3.fromRGB(90, 255, 125), Transparency = .6}, gui)
                    tag.chams[part] = cham
                end
                cham.Size = part.Size
            end
        end
    end
    for part, cham in pairs(tag.chams) do if not seen[part] then cham:Destroy(); tag.chams[part] = nil end end
end
function combatHud.refillStationStep(now)
    local station = combatHud.refillStation
    local mode = combatHud.mode()
    if type(mode) ~= 'string' or mode:sub(1, 4) ~= 'hcf:' then
        if next(station.tags) then combatHud.clearRefillStation() end
        station.raw, station.locations, station.nextRead = nil, {}, 0
        return
    end
    local refresh = now >= station.nextRead
    if refresh then
        station.nextRead = now + .5
        local raw = PvP:GetAttribute('HcfPotStations')
        if raw ~= station.raw then
            station.raw, station.locations = raw, {}
            if type(raw) == 'string' and raw ~= '' then
                local ok, layout = pcall(HttpService.JSONDecode, HttpService, raw)
                if ok then station.locations = combatHud.refillLocations(layout) end
            end
        end
    end
    local visible, s = {}, state()
    for _, location in ipairs(station.locations) do
        visible[location.key] = true
        local tag = station.tags[location.key]
        if not tag then tag = combatHud.refillStationTag(location.position); station.tags[location.key] = tag end
        tag.anchor.Position = location.position * scale
        if refresh then guard('station cham', combatHud.stationChams, tag, location.id) end
        local distance = s and (s.position - location.position).Magnitude
        tag.name.Text = 'REFILL STATION' .. (distance and ('\n' .. math.floor(distance + .5) .. ' blocks') or '')
    end
    for key, tag in pairs(station.tags) do
        if not visible[key] then combatHud.removeWorldMarker(tag); station.tags[key] = nil end
    end
end
combatHud.spawnMarker = {nextRead = 0}
function combatHud.spawnLocation(safe)
    if type(safe) ~= 'table' or type(safe.low) ~= 'table' or type(safe.high) ~= 'table' then return nil end
    local low, high = safe.low, safe.high
    local x0, x1 = tonumber(low[1] or low.x), tonumber(high[1] or high.x)
    local z0, z1 = tonumber(low[3] or low.z), tonumber(high[3] or high.z)
    local y = tonumber(safe.y or low[2] or low.y)
    if not finiteNumber(x0) or not finiteNumber(x1) or not finiteNumber(z0) or not finiteNumber(z1) or not finiteNumber(y) then return nil end
    return Vector3.new((x0 + x1) / 2, y + 1, (z0 + z1) / 2)
end
function combatHud.clearSpawnMarker()
    local spawn = combatHud.spawnMarker
    if spawn.tag then combatHud.removeWorldMarker(spawn.tag); spawn.tag = nil end
end
function combatHud.spawnMarkerStep(now)
    local spawn = combatHud.spawnMarker
    local mode = combatHud.mode()
    if type(mode) ~= 'string' or mode:sub(1, 4) ~= 'hcf:' then
        combatHud.clearSpawnMarker(); spawn.raw, spawn.position, spawn.nextRead = nil, nil, 0; return
    end
    if now >= spawn.nextRead then
        spawn.nextRead = now + .5
        local raw = PvP:GetAttribute('HcfSafe')
        if raw ~= spawn.raw then
            spawn.raw, spawn.position = raw, nil
            if type(raw) == 'string' and raw ~= '' then
                local ok, safe = pcall(HttpService.JSONDecode, HttpService, raw)
                if ok then spawn.position = combatHud.spawnLocation(safe) end
            end
        end
    end
    if not spawn.position then combatHud.clearSpawnMarker(); return end
    if not spawn.tag then spawn.tag = combatHud.worldMarker(spawn.position, 'SPAWN', Color3.fromRGB(85, 165, 255), 3) end
    spawn.tag.anchor.Position = spawn.position * scale
    local s = state()
    local distance = s and (s.position - spawn.position).Magnitude
    spawn.tag.name.Text = 'SPAWN' .. (distance and ('\n' .. math.floor(distance + .5) .. ' blocks') or '')
end

combatHud.death = {}
function combatHud.clearDeath()
    local death = combatHud.death
    if not death then return end
    for _, key in ipairs({'billboard', 'anchor'}) do
        if death[key] then pcall(function() death[key]:Destroy() end); death[key] = nil end
    end
end
function combatHud.recordDeath()
    local death = combatHud.death
    if not death.lastAlive then return end
    combatHud.clearDeath()
    death.position = death.lastAlive
    local red = Color3.fromRGB(255, 65, 80)
    death.anchor = make('Part', {Name = 'PurpleHCFDeathPoint', Anchored = true, CanCollide = false, CanTouch = false, CanQuery = false, Transparency = 1, Size = Vector3.new(.1, .1, .1), Position = death.position * scale}, workspace)
    death.billboard = make('BillboardGui', {Name = 'PurpleHCFDeathTag', Adornee = death.anchor, Size = UDim2.fromOffset(190, 44), AlwaysOnTop = true, LightInfluence = 0, ResetOnSpawn = false, StudsOffsetWorldSpace = Vector3.new(0, 3, 0)}, PlayerGui)
    local frame = make('Frame', {Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.fromRGB(32, 10, 16), BackgroundTransparency = .15}, death.billboard)
    round(frame, 8)
    make('UIStroke', {Color = red, Thickness = 1.5}, frame)
    death.text = label('LATEST DEATH', UDim2.fromOffset(6, 2), UDim2.new(1, -12, 1, -4), frame, 12)
    death.text.TextColor3 = red
    death.text.TextXAlignment = Enum.TextXAlignment.Center
end
function combatHud.deathHealth()
    local death = combatHud.death
    local health = LP:GetAttribute('Health')
    if not finiteNumber(health) then return end
    if health <= 0 and death.health and death.health > 0 then combatHud.recordDeath() end
    death.health = health
    if health > 0 then
        local s = state()
        if s and typeof(s.position) == 'Vector3' then death.lastAlive = s.position end
    end
end
function combatHud.deathVisual(camera)
    local death = combatHud.death
    if not death.position or not death.text then return end
    local s = state()
    local origin = s and s.position or camera.CFrame.Position / scale
    death.text.Text = 'LATEST DEATH\n' .. math.floor((origin - death.position).Magnitude + .5) .. ' blocks'

end
connect(LP:GetAttributeChangedSignal('Health'), function() guard('death point', combatHud.deathHealth) end)
guard('death point', combatHud.deathHealth)
function combatHud.freecam.stop()
    local fc = combatHud.freecam
    if not fc.active then return end
    fc.active = false
    pcall(function()
        fc.camera.CameraType = fc.cameraType
        fc.camera.CFrame = fc.returnFrame
        fc.camera.Focus = fc.returnFocus
    end)
    pcall(function()
        UIS.MouseBehavior = (not windowFocused or menuOpen or Inventory.open) and Enum.MouseBehavior.Default or fc.mouseBehavior
        UIS.MouseIconEnabled = (not windowFocused or menuOpen or Inventory.open) or fc.mouseIcon
    end)
    fc.camera = nil
end
function combatHud.freecam.begin(camera)
    local fc, s = combatHud.freecam, state()
    local ok, sensitivity = pcall(Settings.mouseTurn)
    fc.sensitivity = ok and type(sensitivity) == 'number' and sensitivity > 0 and sensitivity or .0025
    fc.camera, fc.cameraType = camera, camera.CameraType
    fc.returnFrame, fc.returnFocus = camera.CFrame, camera.Focus
    fc.mouseBehavior, fc.mouseIcon = UIS.MouseBehavior, UIS.MouseIconEnabled
    fc.position = camera.CFrame.Position
    local look = camera.CFrame.LookVector
    fc.yaw, fc.pitch = math.atan2(-look.X, -look.Z), math.asin(math.clamp(look.Y, -1, 1))
    fc.bodyYaw, fc.bodyPitch = s and s.yaw, s and s.pitch
    fc.active = true
    inputState.dropHeld, inputState.dropSession, inputState.dropAwaitRelease = false, nil, true
    camera.CameraType = Enum.CameraType.Scriptable
    UIS.MouseBehavior, UIS.MouseIconEnabled = Enum.MouseBehavior.LockCenter, false
end
function combatHud.freecam.step(dt)
    local fc = combatHud.freecam
    local ok, down = pcall(UIS.IsKeyDown, UIS, Enum.KeyCode.X)
    if not ok or not down then fc.blocked = false; fc.stop(); return end
    local focused, box = pcall(UIS.GetFocusedTextBox, UIS)
    if not alive or not windowFocused or not focused or box or menuOpen or Inventory.open or rebinding or inputState.speed or fc.blocked then fc.stop(); return end
    local camera = workspace.CurrentCamera
    if not camera then fc.stop(); return end
    if fc.active and fc.camera ~= camera then fc.stop() end
    if not fc.active then fc.begin(camera) end
    fc.returnFrame, fc.returnFocus = camera.CFrame, camera.Focus
    camera.CameraType = Enum.CameraType.Scriptable
    UIS.MouseBehavior, UIS.MouseIconEnabled = Enum.MouseBehavior.LockCenter, false
    local delta = UIS:GetMouseDelta()
    fc.yaw = fc.yaw - delta.X * fc.sensitivity
    fc.pitch = math.clamp(fc.pitch - delta.Y * fc.sensitivity * (Settings.invertMouse and -1 or 1), -1.553343, 1.553343)
    local frame = CFrame.new(fc.position) * CFrame.Angles(0, fc.yaw, 0) * CFrame.Angles(fc.pitch, 0, 0)
    local function key(code) local success, value = pcall(UIS.IsKeyDown, UIS, code); return success and value and 1 or 0 end
    local move = frame.LookVector * (key(Enum.KeyCode.W) - key(Enum.KeyCode.S)) + frame.RightVector * (key(Enum.KeyCode.D) - key(Enum.KeyCode.A)) + Vector3.new(0, key(Enum.KeyCode.Space) - math.max(key(Enum.KeyCode.LeftControl), key(Enum.KeyCode.RightControl)), 0)
    local speed = C.freecamSpeed * (key(Enum.KeyCode.LeftShift) > 0 and 2.5 or 1)
    if move.Magnitude > 0 then fc.position = fc.position + move / move.Magnitude * speed * math.clamp(dt, 0, .1) end
    camera.CFrame = CFrame.new(fc.position) * CFrame.Angles(0, fc.yaw, 0) * CFrame.Angles(fc.pitch, 0, 0)
    camera.Focus = CFrame.new(fc.position + camera.CFrame.LookVector * 16)
end
install(Settings.mouseTurn, function(original, ...)
    if combatHud.freecam.active then return 0 end
    return original(...)
end)
if type(Settings.pressed) == 'function' then
    install(Settings.pressed, function(original, ...)
        if combatHud.freecam.active then return false end
        return original(...)
    end)
end
connect(UIS.WindowFocusReleased, function() combatHud.freecam.blocked = true; combatHud.freecam.stop() end)

local nextWorldVisual = 0
local function viewStep(dt)
    if not alive then return end
    local now, camera = os.clock(), workspace.CurrentCamera
    if not camera then return end
    guard('death tag', combatHud.deathVisual, camera)
    local center = camera.ViewportSize * .5
    local color = Color3.fromHSV(.75 + .035 * math.sin(now * 1.7), .62, 1)
    if panel.Visible then
        for _, particle in ipairs(particles) do particle.y = (particle.y - dt * particle.speed) % 1; particle.dot.Position = UDim2.fromScale(particle.x + .018 * math.sin(now + particle.x * 12), particle.y) end
    end
    for _, g in ipairs(gradients) do g.Rotation = now * 50 % 360 end
    ring.Position = UDim2.fromOffset(center.X, center.Y)
    ring.Size = UDim2.fromOffset(C.radius * 2, C.radius * 2)
    ring.Visible = C.enabled
    ringGlow.Color = color; ringGlow.Transparency = .82 + .06 * math.sin(now * 2)
    local tracking = canTrack(state(), targetEntry())
    box.Visible = not not tracking
    if tracking then
        local entry = targetEntry()
        local aimPosition = entry.creature and Physics.hitbox(entry.rendered, nil, entry.size) or (entry.rendered + Vector3.new(0, .9, 0))
        local p, onScreen = camera:WorldToViewportPoint(aimPosition * scale)
        box.Visible = onScreen and p.Z > 0
        if box.Visible then
            local entityHeight = entry.creature and entry.size and tonumber(entry.size.height) or 1.9
            local top = camera:WorldToViewportPoint((entry.rendered + Vector3.new(0, entityHeight or 1.9, 0)) * scale)
            local bottom = camera:WorldToViewportPoint(entry.rendered * scale)
            local height = math.clamp(math.abs(top.Y - bottom.Y), 25, 500)
            box.Position = UDim2.fromOffset(p.X, p.Y)
            box.Size = UDim2.fromOffset(height, height)
            box.Rotation = now * 65 % 360
        end
    end
    if now >= nextWorldVisual then
        nextWorldVisual = now + .05
        guard('world visuals', worldVisualStep, now, color)
        guard('combat HUD', combatHud.update, now)
        guard('refill station ESP', combatHud.refillStationStep, now)
        guard('spawn ESP', combatHud.spawnMarkerStep, now)
    end
end
connect(RS.Heartbeat, function() guard('death point', combatHud.deathHealth); guard('combat update', combatStep) end)
combatHud.freecam.render = function(dt)
    local ok = guard('freecam', combatHud.freecam.step, dt)
    if not ok then pcall(combatHud.freecam.stop); combatHud.freecam.blocked = true end
    guard('interface', viewStep, dt)
end
combatHud.freecam.bound = pcall(RS.BindToRenderStep, RS, 'PurpleHCFFreecam', Enum.RenderPriority.Camera.Value + 2, combatHud.freecam.render)
if not combatHud.freecam.bound then connect(RS.RenderStepped, combatHud.freecam.render) end
if configMissing then saveConfig() end
