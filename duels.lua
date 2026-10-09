
_wuzzUnloaded = false
_wuzzConnections = {}
_wuzzOriginalFov = workspace.CurrentCamera and workspace.CurrentCamera.FieldOfView or 70
_wuzzOriginalLighting = {ClockTime=game:GetService("Lighting").ClockTime,Brightness=game:GetService("Lighting").Brightness,Ambient=game:GetService("Lighting").Ambient,OutdoorAmbient=game:GetService("Lighting").OutdoorAmbient,FogEnd=game:GetService("Lighting").FogEnd,FogStart=game:GetService("Lighting").FogStart,FogColor=game:GetService("Lighting").FogColor,GlobalShadows=game:GetService("Lighting").GlobalShadows}
function _wuzzTrack(connection)
    if connection then table.insert(_wuzzConnections,connection) end
    return connection
end
function _wuzzUnload()
    if _wuzzUnloaded then return end
    _wuzzUnloaded = true
    if getgenv then pcall(function() getgenv()._ExeDuelsRunning = false end) end
    for _,name in ipairs({"autoLeftEnabled","autoRightEnabled","autoBatEnabled","batAimbotEnabled","tpBatEnabled","autoTPEnabled","mirrorTPDownEnabled","antiRagdollEnabled","infJumpEnabled","medusaCounterEnabled","batCounterEnabled","laggerModeEnabled","laggerCarryActive","carrySpeedActive","playerEspEnabled","playerTracersEnabled","safeModeEnabled","antiKickEnabled","headlessEnabled","korbloxEnabled","autoSwingEnabled","autoMoveSwingEnabled","speedBoosterEnabled","_autoStealEnabled"}) do
        _G[name] = false
    end
    pcall(function() if Steal then Steal.AutoStealEnabled=false end end)
    pcall(function() if stopAutoSteal then stopAutoSteal() end end)
    pcall(function() if stopAutoLeft then stopAutoLeft() end end)
    pcall(function() if stopAutoRight then stopAutoRight() end end)
    pcall(function() if stopTPBat then stopTPBat() end end)
    pcall(function() if stopBatAimbot then stopBatAimbot() end end)
    pcall(function() if stopAutoTP then stopAutoTP() end end)
    pcall(function() if stopHoldInfJump then stopHoldInfJump() end end)
    pcall(function() if disableAntiLag then disableAntiLag() end end)
    pcall(function() if clearAllEsp then clearAllEsp() end end)
    pcall(function() if clearSpeedConstraint then clearSpeedConstraint() end end)
    pcall(function() if clearPersistentConns then clearPersistentConns() end end)
    pcall(function() if stopUnwalk then stopUnwalk() end end)
    pcall(function() if stopAntiRagdoll then stopAntiRagdoll() end end)
    pcall(function() if disableSafeMode then disableSafeMode() end end)
    pcall(function() if skyAnimConn then skyAnimConn:Disconnect();skyAnimConn=nil end end)
    pcall(function() if fovConn then fovConn:Disconnect() end end)
    pcall(function() if _antiFlingConn then _antiFlingConn:Disconnect() end end)
    pcall(function() if _noPlayerColHB then _noPlayerColHB:Disconnect() end end)
    pcall(function() if _espConn then _espConn:Disconnect() end end)
    pcall(function() if autoStealSupervisorConn then autoStealSupervisorConn:Disconnect() end end)
    pcall(function() if holdInfJumpConn then holdInfJumpConn:Disconnect() end end)
    pcall(function() if tpBatConn then tpBatConn:Disconnect() end end)
    pcall(function() if Conns then for _,c in pairs(Conns) do if typeof(c)=="RBXScriptConnection" then c:Disconnect() end end end end)
    pcall(function() if workspace.CurrentCamera then workspace.CurrentCamera.FieldOfView=_wuzzOriginalFov end end)
    pcall(function() for k,v in pairs(_wuzzOriginalLighting) do game:GetService("Lighting")[k]=v end end)
    pcall(function()
        for _,parent in ipairs({game:GetService("Lighting"),workspace:FindFirstChildOfClass("Terrain")}) do
            if parent then for _,o in ipairs(parent:GetChildren()) do if o:GetAttribute("ExeSkyTheme") then o:Destroy() end end end
        end
    end)
    for _,connection in ipairs(_wuzzConnections) do pcall(function() connection:Disconnect() end) end
    table.clear(_wuzzConnections)
    pcall(function() if _tpGodConns then for _,c in ipairs(_tpGodConns) do c:Disconnect() end end end)
    pcall(function() if gethui then local h=gethui() if h then for _,n in ipairs({"WuzzDuels","ExeDuels","ExeMobileButtons","ExeInfoBar","ExeStealBar"}) do local o=h:FindFirstChild(n) if o then o:Destroy() end end end end end)
    pcall(function() if mobGuiRef then mobGuiRef:Destroy() end end)
    pcall(function() if stealBarFrame then stealBarFrame:Destroy() end end)
    for _,root in ipairs({game:GetService("CoreGui"),game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui")}) do
        if root then for _,name in ipairs({"WuzzDuels","ExeDuels","EXEDuelsStealHud","EXEDuelsIntro","ExeMobileButtons","ExeInfoBar","ExeStealBar","ExeDuelsMogIntro","K7Duels","WuzzOverheadSpeed"}) do
            local item=root:FindFirstChild(name)
            if item then pcall(function() item:Destroy() end) end
        end end
    end
    pcall(function()
        local char=game:GetService("Players").LocalPlayer.Character
        if char then for _,obj in ipairs(char:GetDescendants()) do if obj.Name=="WuzzOverheadSpeed" or obj.Name=="ExeRagdollTimer" or obj.Name=="KorbloxLeg" or obj.Name=="HeadlessMesh" then obj:Destroy() end end end
    end)
end
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local player = Players.LocalPlayer
local parentGui = player:WaitForChild("PlayerGui")

local existing = parentGui:FindFirstChild("WuzzDuels")
if existing then existing:Destroy() end

local ui = Instance.new("ScreenGui")
ui.Name = "WuzzDuels"
ui.ResetOnSpawn = false
ui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ui.Parent = parentGui

local purple = Color3.fromRGB(163, 94, 255)
local soft = Color3.fromRGB(212, 174, 255)
local bg = Color3.fromRGB(12, 9, 20)
local card = Color3.fromRGB(21, 15, 34)
local muted = Color3.fromRGB(160, 149, 175)

local function round(obj, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 7)
    corner.Parent = obj
    return corner
end

local function border(obj, color)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color or Color3.fromRGB(55, 39, 79)
    stroke.Thickness = 1
    stroke.Parent = obj
    return stroke
end

local shell = Instance.new("Frame")
shell.Name = "WuzzDuelsMain"
shell.Size = UDim2.fromOffset(790, 490)
shell.AnchorPoint = Vector2.new(0.5, 0.5)
shell.Position = UDim2.fromScale(0.5, 0.5)
shell.BackgroundColor3 = bg
shell.BorderSizePixel = 0
shell.Parent = ui
round(shell, 12)
border(shell)

local header = Instance.new("Frame")
header.Name = "Header"
header.Size = UDim2.new(1, 0, 0, 56)
header.BackgroundTransparency = 1
header.Parent = shell

local logo = Instance.new("TextLabel")
logo.Name = "WLogo"
logo.Size = UDim2.fromOffset(54, 48)
logo.Position = UDim2.fromOffset(56, 4)
logo.BackgroundTransparency = 1
logo.Text = "W"
logo.TextColor3 = soft
logo.Font = Enum.Font.GothamBlack
logo.TextSize = 42
logo.Parent = header
local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new(soft, purple)
gradient.Rotation = 35
gradient.Parent = logo

local searchHolder = Instance.new("Frame")
searchHolder.Name = "SearchHolder"
searchHolder.Size = UDim2.fromOffset(245, 28)
searchHolder.Position = UDim2.fromOffset(195, 14)
searchHolder.BackgroundColor3 = card
searchHolder.BorderSizePixel = 0
searchHolder.Parent = header
round(searchHolder, 6)
border(searchHolder)

local search = Instance.new("TextBox")
search.Name = "ModuleSearch"
search.Size = UDim2.new(1, -18, 1, 0)
search.Position = UDim2.fromOffset(9, 0)
search.BackgroundTransparency = 1
search.Text = ""
search.PlaceholderText = "Search"
search.PlaceholderColor3 = muted
search.TextColor3 = Color3.new(1, 1, 1)
search.TextXAlignment = Enum.TextXAlignment.Left
search.Font = Enum.Font.Gotham
search.TextSize = 12
search.ClearTextOnFocus = false
search.Parent = searchHolder

local close = Instance.new("TextButton")
close.Name = "CloseAndUnload"
close.Size = UDim2.fromOffset(25, 25)
close.Position = UDim2.new(1, -37, 0, 15)
close.BackgroundColor3 = card
close.Text = "×"
close.TextColor3 = soft
close.TextSize = 21
close.Font = Enum.Font.GothamBold
close.Parent = header
round(close, 6)
border(close)

local sidebar = Instance.new("Frame")
sidebar.Name = "Sidebar"
sidebar.Size = UDim2.new(0, 158, 1, -105)
sidebar.Position = UDim2.fromOffset(14, 61)
sidebar.BackgroundTransparency = 1
sidebar.Parent = shell
local sideLayout = Instance.new("UIListLayout")
sideLayout.Padding = UDim.new(0, 7)
sideLayout.SortOrder = Enum.SortOrder.LayoutOrder
sideLayout.Parent = sidebar

local sideTitle = Instance.new("TextLabel")
sideTitle.Name = "FeaturesTitle"
sideTitle.Size = UDim2.new(1, 0, 0, 20)
sideTitle.BackgroundTransparency = 1
sideTitle.Text = "   FEATURES"
sideTitle.Font = Enum.Font.GothamBold
sideTitle.TextColor3 = muted
sideTitle.TextXAlignment = Enum.TextXAlignment.Left
sideTitle.TextSize = 10
sideTitle.LayoutOrder = 0
sideTitle.Parent = sidebar

local holder = Instance.new("Frame")
holder.Name = "ModuleContent"
holder.Size = UDim2.new(1, -195, 1, -69)
holder.Position = UDim2.fromOffset(182, 60)
holder.BackgroundTransparency = 1
holder.Parent = shell
local content = Instance.new("ScrollingFrame")
content.Name = "ContentFrame"
content.Size = UDim2.fromScale(1, 1)
content.BackgroundTransparency = 1
content.BorderSizePixel = 0
content.ScrollBarImageColor3 = purple
content.ScrollBarThickness = 3
content.CanvasSize = UDim2.fromScale(0, 0)
content.Parent = holder

local names = {"Combat", "Movement", "Visuals", "Keybinds", "Settings"}
local buttons, pages = {}, {}
for i, name in ipairs(names) do
    local b = Instance.new("TextButton")
    b.Name = name .. "Tab"
    b.Size = UDim2.new(1, -4, 0, 33)
    b.BackgroundColor3 = Color3.fromRGB(43, 25, 69)
    b.BackgroundTransparency = 1
    b.AutoButtonColor = false
    b.Text = "   " .. name
    b.TextSize = 12
    b.Font = Enum.Font.GothamMedium
    b.TextXAlignment = Enum.TextXAlignment.Left
    b.TextColor3 = muted
    b.LayoutOrder = i
    b.Parent = sidebar
    round(b, 7)
    local outline = border(b, purple)
    outline.Transparency = 1
    buttons[name] = b

    local page = Instance.new("Frame")
    page.Name = name .. "Page"
    page.Size = UDim2.new(1, -6, 1, 0)
    page.BackgroundTransparency = 1
    page.Visible = false
    page.Parent = content
    pages[name] = page
end

local function activate(name)
    content.CanvasPosition = Vector2.zero
    for key, page in pairs(pages) do
        page.Visible = (key == name)
    end
    for key, b in pairs(buttons) do
        local active = (key == name)
        b.BackgroundTransparency = active and 0 or 1
        b.TextColor3 = active and soft or muted
        local outline = b:FindFirstChildOfClass("UIStroke")
        if outline then outline.Transparency = active and 0 or 1 end
    end
end
for name, b in pairs(buttons) do
    _wuzzTrack(b.MouseButton1Click:Connect(function() activate(name) end))
end
activate("Combat")

local footer = Instance.new("Frame")
footer.Name = "ProfileFooter"
footer.Size = UDim2.fromOffset(160, 38)
footer.Position = UDim2.new(0, 18, 1, -46)
footer.BackgroundTransparency = 1
footer.Parent = shell

local avatar = Instance.new("ImageLabel")
avatar.Name = "Avatar"
avatar.Size = UDim2.fromOffset(30, 30)
avatar.Position = UDim2.fromOffset(0, 4)
avatar.BackgroundColor3 = card
avatar.BorderSizePixel = 0
avatar.Parent = footer
round(avatar, 15)
border(avatar, purple)
task.spawn(function()
    local ok, img = pcall(function()
        return Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
    end)
    if ok and avatar.Parent then avatar.Image = img end
end)

local username = Instance.new("TextLabel")
username.Name = "Username"
username.Size = UDim2.fromOffset(120, 18)
username.Position = UDim2.fromOffset(38, 3)
username.BackgroundTransparency = 1
username.Text = player.DisplayName
username.TextSize = 11
username.Font = Enum.Font.GothamBold
username.TextColor3 = Color3.fromRGB(235, 235, 235)
username.TextXAlignment = Enum.TextXAlignment.Left
username.Parent = footer

local hint = Instance.new("TextLabel")
hint.Name = "ToggleHint"
hint.Size = UDim2.fromOffset(120, 14)
hint.Position = UDim2.fromOffset(38, 21)
hint.BackgroundTransparency = 1
hint.Text = "CTRL  •  Wuzz Duels"
hint.TextColor3 = muted
hint.TextSize = 9
hint.Font = Enum.Font.Gotham
hint.TextXAlignment = Enum.TextXAlignment.Left
hint.Parent = footer

local THEME = {
    PillBg = card,
    Border = Color3.fromRGB(55, 39, 79),
    Divider = Color3.fromRGB(75, 54, 105),
    Accent = purple,
    AccentSoft = soft,
    TextMuted = muted,
    TextPrimary = Color3.fromRGB(235, 235, 235)
}
local CUSTOM_LOGO_ID = "rbxassetid://139568612294283"
local ICONS = {
    User = "rbxassetid://7733954760",
    Chart = "rbxassetid://7733749837",
    Clock = "rbxassetid://7733734762",
    Compass = "rbxassetid://7733720755",
    Signal = "rbxassetid://7734058495",
    Radar = "rbxassetid://7734053426",
    Speed = "rbxassetid://7733799901"
}

local HudContainer = Instance.new("Frame")
HudContainer.Name = "HudContainer"
HudContainer.Size = UDim2.new(0, 600, 0, 50)
HudContainer.Position = UDim2.new(0, 16, 0, 48)
HudContainer.BackgroundTransparency = 1
HudContainer.Parent = ui

local HudVerticalLayout = Instance.new("UIListLayout")
HudVerticalLayout.SortOrder = Enum.SortOrder.LayoutOrder
HudVerticalLayout.Padding = UDim.new(0, 4)
HudVerticalLayout.Parent = HudContainer

local function createHudRow(name, height, order)
    local row = Instance.new("Frame")
    row.Name = name
    row.Size = UDim2.new(1, 0, 0, height)
    row.BackgroundTransparency = 1
    row.LayoutOrder = order
    row.Parent = HudContainer

    local hLayout = Instance.new("UIListLayout")
    hLayout.FillDirection = Enum.FillDirection.Horizontal
    hLayout.SortOrder = Enum.SortOrder.LayoutOrder
    hLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    hLayout.Padding = UDim.new(0, 5)
    hLayout.Parent = row

    return row
end

local TopHudRow = createHudRow("TopRow", 22, 1)
local BottomHudRow = createHudRow("BottomRow", 22, 2)

local function createHudPill(parent, order)
    local pill = Instance.new("Frame")
    pill.AutomaticSize = Enum.AutomaticSize.X
    pill.Size = UDim2.new(0, 0, 1, 0)
    pill.BackgroundColor3 = THEME.PillBg
    pill.BorderSizePixel = 0
    pill.LayoutOrder = order
    pill.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 5)
    corner.Parent = pill

    local stroke = Instance.new("UIStroke")
    stroke.Color = THEME.Border
    stroke.Thickness = 1
    stroke.Parent = pill

    local pad = Instance.new("UIPadding")
    pad.PaddingLeft = UDim.new(0, 6)
    pad.PaddingRight = UDim.new(0, 6)
    pad.Parent = pill

    local layout = Instance.new("UIListLayout")
    layout.FillDirection = Enum.FillDirection.Horizontal
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.VerticalAlignment = Enum.VerticalAlignment.Center
    layout.Padding = UDim.new(0, 5)
    layout.Parent = pill

    return pill
end

local function addHudDivider(parent, order)
    local div = Instance.new("Frame")
    div.Size = UDim2.new(0, 1, 0, 10)
    div.BackgroundColor3 = THEME.Divider
    div.BorderSizePixel = 0
    div.LayoutOrder = order
    div.Parent = parent
end

local function addHudText(parent, text, isMuted, order)
    local lbl = Instance.new("TextLabel")
    lbl.AutomaticSize = Enum.AutomaticSize.X
    lbl.Size = UDim2.new(0, 0, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextSize = 10.5
    lbl.TextColor3 = isMuted and THEME.TextMuted or THEME.TextPrimary
    lbl.LayoutOrder = order
    lbl.Parent = parent
    return lbl
end

local function addHudSmallIcon(parent, iconId, order)
    local icon = Instance.new("ImageLabel")
    icon.Size = UDim2.new(0, 11, 0, 11)
    icon.BackgroundTransparency = 1
    icon.Image = iconId
    icon.ScaleType = Enum.ScaleType.Fit
    icon.ImageColor3 = THEME.Accent
    icon.LayoutOrder = order
    icon.Parent = parent
    return icon
end

local BrandPill = createHudPill(TopHudRow, 1)

local HudLogoWrap = Instance.new("Frame")
HudLogoWrap.Size = UDim2.new(0, 20, 0, 20)
HudLogoWrap.BackgroundTransparency = 1
HudLogoWrap.LayoutOrder = 1
HudLogoWrap.Parent = BrandPill

local HudLogoGlow = Instance.new("ImageLabel")
HudLogoGlow.Size = UDim2.new(2, 0, 2, 0)
HudLogoGlow.Position = UDim2.new(-0.5, 0, -0.5, 0)
HudLogoGlow.BackgroundTransparency = 1
HudLogoGlow.Image = "rbxassetid://5028857084"
HudLogoGlow.ImageColor3 = THEME.Accent
HudLogoGlow.ImageTransparency = 0.65
HudLogoGlow.ZIndex = 1
HudLogoGlow.Parent = HudLogoWrap

local HudBrandLogo = Instance.new("ImageLabel")
HudBrandLogo.Size = UDim2.new(1.35, 0, 1.35, 0)
HudBrandLogo.Position = UDim2.new(-0.175, 0, -0.175, 0)
HudBrandLogo.BackgroundTransparency = 1
HudBrandLogo.Image = ""
HudBrandLogo.BackgroundTransparency = 1
HudBrandLogo.ScaleType = Enum.ScaleType.Fit
HudBrandLogo.ImageColor3 = Color3.fromRGB(255, 255, 255)
HudBrandLogo.ZIndex = 2
HudBrandLogo.Parent = HudLogoWrap

local WLogoText = Instance.new("TextLabel")
WLogoText.Size = UDim2.fromScale(1, 1)
WLogoText.BackgroundTransparency = 1
WLogoText.Text = "W"
WLogoText.Font = Enum.Font.GothamBlack
WLogoText.TextSize = 19
WLogoText.TextColor3 = soft
WLogoText.Parent = HudLogoWrap
local HudLogoGrad = Instance.new("UIGradient")
HudLogoGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0.0, THEME.AccentSoft),
    ColorSequenceKeypoint.new(0.45, THEME.Accent),
    ColorSequenceKeypoint.new(1.0, Color3.fromRGB(100, 55, 178))
})
HudLogoGrad.Rotation = -35
HudLogoGrad.Parent = WLogoText

addHudDivider(BrandPill, 2)
local HudBrandText = addHudText(BrandPill, "Wuzz Duels", false, 3)

local HudBrandGrad = Instance.new("UIGradient")
HudBrandGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0.0, THEME.AccentSoft),
    ColorSequenceKeypoint.new(1.0, THEME.Accent)
})
HudBrandGrad.Parent = HudBrandText

local StatsPill = createHudPill(TopHudRow, 2)
addHudSmallIcon(StatsPill, ICONS.User, 1)
addHudText(StatsPill, string.lower(player.Name), false, 2)
addHudDivider(StatsPill, 3)

addHudSmallIcon(StatsPill, ICONS.Chart, 4)
local FpsLabel = addHudText(StatsPill, "0 Fps", false, 5)
addHudDivider(StatsPill, 6)

addHudSmallIcon(StatsPill, ICONS.Clock, 7)
local TimeLabel = addHudText(StatsPill, "00:00:00", false, 8)

local PosPill = createHudPill(BottomHudRow, 1)
addHudSmallIcon(PosPill, ICONS.Compass, 1)
addHudDivider(PosPill, 2)
local PosLabel = addHudText(PosPill, "0, 0, 0", false, 3)

local PingPill = createHudPill(BottomHudRow, 2)
addHudSmallIcon(PingPill, ICONS.Signal, 1)
addHudDivider(PingPill, 2)
local PingLabel = addHudText(PingPill, "0 Ping", false, 3)

local TickPill = createHudPill(BottomHudRow, 3)
addHudSmallIcon(TickPill, ICONS.Radar, 1)
addHudDivider(TickPill, 2)
local TickLabel = addHudText(TickPill, "-- TPS", false, 3)

local SpeedPill = createHudPill(BottomHudRow, 4)
addHudSmallIcon(SpeedPill, ICONS.Speed, 1)
addHudDivider(SpeedPill, 2)
local SpeedLabel = addHudText(SpeedPill, "0.0 Bps", false, 3)


local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local frames = 0
local lastFps = os.clock()
local lastPosition = nil
local lastPositionTime = nil
local lastMetrics = 0
local measuredHeartbeats = 0
local heartbeatWindow = os.clock()
local renderConn = _wuzzTrack(RunService.RenderStepped:Connect(function()
    frames += 1
end))
local heartbeatConn = _wuzzTrack(RunService.Heartbeat:Connect(function(dt)
    measuredHeartbeats += 1
    local now = os.clock()
    if now - lastMetrics < 0.25 then return end
    lastMetrics = now
    local elapsed = now - lastFps
    if elapsed >= 1 then
        FpsLabel.Text = string.format("%d Fps", math.floor(frames / elapsed + 0.5))
        frames = 0
        lastFps = now
    end
    TimeLabel.Text = os.date("%H:%M:%S")
    local ok, ping = pcall(function()
        return Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
    end)
    PingLabel.Text = ok and string.format("%d Ping", math.floor(ping + 0.5)) or "-- Ping"
    local character = player.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    if root then
        local p = root.Position
        PosLabel.Text = string.format("%d, %d, %d", math.floor(p.X), math.floor(p.Y), math.floor(p.Z))
        if lastPosition and lastPositionTime then
            local dt = now - lastPositionTime
            if dt > 0 then
                local dx = p.X - lastPosition.X
                local dz = p.Z - lastPosition.Z
                SpeedLabel.Text = string.format("%.1f Bps", math.sqrt(dx * dx + dz * dz) / dt)
            end
        end
        lastPosition = p
        lastPositionTime = now
    else
        PosLabel.Text = "--, --, --"
        SpeedLabel.Text = "0.0 Bps"
        lastPosition = nil
        lastPositionTime = nil
    end
    local window = now - heartbeatWindow
    if window >= 1 then
        TickLabel.Text = string.format("%.0f TPS", measuredHeartbeats / window)
        measuredHeartbeats = 0
        heartbeatWindow = now
    end
end))

local dragging, dragStart, origin = false, nil, nil
_wuzzTrack(header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        origin = shell.Position
    end
end))
local dragConn = _wuzzTrack(UIS.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        shell.Position = UDim2.new(origin.X.Scale, origin.X.Offset + delta.X, origin.Y.Scale, origin.Y.Offset + delta.Y)
    end
end))
local endConn = _wuzzTrack(UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end))
local toggleConn = _wuzzTrack(UIS.InputBegan:Connect(function(input, processed)
    if not processed and (input.KeyCode == Enum.KeyCode.LeftControl or input.KeyCode == Enum.KeyCode.RightControl) then
        shell.Visible = not shell.Visible
    end
end))
_wuzzTrack(close.MouseButton1Click:Connect(_wuzzUnload))



local Players = game:GetService("Players")
TweenService = game:GetService("TweenService")
UIS = game:GetService("UserInputService")
RunService = game:GetService("RunService")
Lighting = game:GetService("Lighting")
HS = game:GetService("HttpService")
player = Players.LocalPlayer

if getgenv then
    if getgenv()._ExeDuelsRunning then
        pcall(function()
            local function nuke(name)
                local function kill(parent)
                    if not parent then return end
                    local o = parent:FindFirstChild(name)
                    if o then o:Destroy() end
                end
                if gethui then pcall(function() kill(gethui()) end) end
                pcall(function() kill(game:GetService("CoreGui")) end)
                local plr = game:GetService("Players").LocalPlayer
                if plr then
                    pcall(function() kill(plr:FindFirstChild("PlayerGui")) end)
                end
            end
            for _, n in ipairs({
                "ExeDuels", "EXEDuelsStealHud", "EXEDuelsIntro", "ExeMobileButtons",
                "ExeInfoBar", "ExeStealBar", "ExeDuelsMogIntro", "K7Duels"
            }) do
                nuke(n)
            end
        end)
        getgenv()._ExeDuelsRunning = false
    end
    getgenv()._ExeDuelsRunning = true
    getgenv()._ExeDuelsSession = (getgenv()._ExeDuelsSession or 0) + 1
end


pcall(function()
    if getgenv and type(getgenv()._ExeDuelsCfg)=="table" and getgenv()._ExeDuelsCfg.introEnabled ~= nil then
        
    end
end)




function _resolve(name)
    local g = rawget(_G, name) or (getgenv and getgenv()[name])
    if typeof(g)=="function" then return g end
    if syn and typeof(syn[name])=="function" then return syn[name] end
    if fluxus and typeof(fluxus[name])=="function" then return fluxus[name] end
    return nil
end

_gethui = _resolve("gethui") or (typeof(gethui)=="function" and gethui) or nil
_getcustomasset = _resolve("getcustomasset") or (typeof(getcustomasset)=="function" and getcustomasset) or nil
_request = _resolve("request")
    or _resolve("http_request")
    or (syn and syn.request)
    or (http and (http.request or http.Request))
    or (fluxus and fluxus.request)
    or (typeof(request)=="function" and request)
    or (typeof(http_request)=="function" and http_request)
    or nil

function protectGui(gui)
    if not gui then return end
    pcall(function()
        if typeof(protect_gui)=="function" then protect_gui(gui)
        elseif syn and syn.protect_gui then syn.protect_gui(gui)
        elseif typeof(hide_in_gcoregui)=="function" then hide_in_gcoregui(gui)
        end
    end)
end

function parentGui(gui)
    if not gui then return end
    protectGui(gui)
    local ok = false
    if _gethui then
        ok = pcall(function() gui.Parent = _gethui() end)
    end
    if not ok or not gui.Parent then
        ok = pcall(function() gui.Parent = game:GetService("CoreGui") end)
    end
    if not gui.Parent then
        pcall(function()
            local plr = Players.LocalPlayer
            if plr then gui.Parent = plr:WaitForChild("PlayerGui") end
        end)
    end
end


_isfile = (typeof(isfile)=="function" and isfile)
    or (syn and syn.isfile)
    or (fluxus and fluxus.isfile)
    or (getgenv and getgenv().isfile)
    or function(p)
        local ok, data = pcall(function() return readfile(p) end)
        return ok and data ~= nil
    end
_readfile = (typeof(readfile)=="function" and readfile)
    or (syn and syn.readfile)
    or (fluxus and fluxus.readfile)
    or (getgenv and getgenv().readfile)
    or function() return nil end
_writefile = (typeof(writefile)=="function" and writefile)
    or (syn and syn.writefile)
    or (fluxus and fluxus.writefile)
    or (getgenv and getgenv().writefile)
    or function() end
isfile, readfile, writefile = _isfile, _readfile, _writefile


function exeHttpGet(url)
    if _request then
        local ok, res = pcall(function()
            return _request({
                Url = url,
                Method = "GET",
                Headers = { ["User-Agent"] = "Mozilla/5.0" },
            })
        end)
        if ok and type(res)=="table" then
            return res.Body or res.body or res.Data or res.data
        elseif ok and type(res)=="string" then
            return res
        end
    end
    local ok2, body = pcall(function() return game:HttpGet(url) end)
    if ok2 then return body end
    return nil
end

function exeGetCustomAsset(path)
    if not path then return nil end
    local asset = nil
    pcall(function()
        if _getcustomasset then asset = _getcustomasset(path) end
    end)
    if asset and asset ~= "" then return asset end
    pcall(function()
        if syn and syn.getcustomasset then asset = syn.getcustomasset(path) end
    end)
    if asset and asset ~= "" then return asset end
    pcall(function()
        if getcustomasset then asset = getcustomasset(path, true) end
    end)
    if asset and asset ~= "" then return asset end
    return nil
end


getconnections = getconnections or get_signal_cons or getconnects
    or (syn and syn.get_signal_cons) or (getgenv and getgenv().getconnections)





EXE_LOGO_RBX = "rbxassetid://135382218880707"
_exeLogoAsset = EXE_LOGO_RBX
function getExeLogoAsset()
    return EXE_LOGO_RBX
end



function destroyOldGui(name)
    if not name then return end
    pcall(function()
        if _gethui then
            local h = _gethui(); local o = h and h:FindFirstChild(name); if o then o:Destroy() end
        end
    end)
    pcall(function()
        local cg = game:GetService("CoreGui"); local o = cg:FindFirstChild(name); if o then o:Destroy() end
    end)
    pcall(function()
        local plr = Players.LocalPlayer
        if plr then
            local pg = plr:FindFirstChild("PlayerGui")
            if pg then local o = pg:FindFirstChild(name); if o then o:Destroy() end end
        end
    end)
end







EXE_SKY_TAG = "ExeSkyTheme"
currentSkyTheme = "Animated Vaporwave"
skyAnimConn = nil
skyAnimTick = 0
EXE_SKY_PRESETS = {
    ["Off"]={kind="off"},
    ["Animated Vaporwave"]={clock=19.8,brightness=2.7,ambient={158,75,194},outAmb={179,91,205},sky={stars=11500,moon=12,sun=0},atm={dens=0.4,color={235,94,225},decay={92,42,205},glare=0.9,haze=1.8},clouds={cover=0.42,dens=0.68,color={247,139,227}}},
    ["Night"]={clock=22,brightness=2,ambient={110,100,130},outAmb={120,110,140},sky={stars=4000,moon=18,sun=0,moonTex=true},atm={dens=0.45,color={120,60,180},decay={60,20,100},glare=0.5,haze=1.2}},
    ["Aurora"]={clock=14,brightness=3,ambient={150,120,150},outAmb={160,130,150},atm={dens=0.55,color={255,80,200},decay={255,20,150},glare=2.5,haze=3},clouds={cover=0.7,dens=0.7,color={255,240,250}}},
    ["Sunset"]={clock=17.2,brightness=2.5,ambient={170,120,100},outAmb={180,130,110},sky={stars=0,sun=25,moon=0},atm={dens=0.5,color={255,130,60},decay={255,80,30},glare=2,haze=2.5},clouds={cover=0.55,dens=0.55,color={255,200,140}}},
    ["Galaxy"]={clock=0,brightness=1.5,ambient={70,60,100},outAmb={80,70,110},sky={stars=10000,moon=30,sun=0},atm={dens=0.15,color={40,20,80},decay={20,10,50},glare=0.3,haze=0.5}},
    ["Cyber"]={clock=21,brightness=2.2,ambient={90,130,170},outAmb={100,140,180},sky={stars=2000,moon=12},atm={dens=0.4,color={0,200,255},decay={150,0,255},glare=2,haze=2},clouds={cover=0.4,dens=0.6,color={100,200,255}}},
    ["Sakura"]={clock=11,brightness=3.5,ambient={170,150,160},outAmb={180,160,170},sky={sun=8},atm={dens=0.3,color={255,200,220},decay={255,170,200},glare=1,haze=1.5},clouds={cover=0.6,dens=0.4,color={255,250,252}}},
    ["Pink Night"]={clock=23,brightness=2.2,ambient={120,60,110},outAmb={140,70,120},sky={stars=5000,moon=22,sun=0,moonTex=true},atm={dens=0.5,color={255,80,180},decay={140,30,100},glare=0.7,haze=1.4},clouds={cover=0.3,dens=0.5,color={180,90,150}}},
    ["Blood Moon"]={clock=22.5,brightness=1.6,ambient={130,40,40},outAmb={150,50,50},sky={stars=1500,moon=28,sun=0,moonTex=true},atm={dens=0.6,color={220,30,30},decay={120,10,10},glare=1.4,haze=2},clouds={cover=0.5,dens=0.7,color={120,30,30}}},
    ["Emerald Dawn"]={clock=6.5,brightness=2.8,ambient={130,170,140},outAmb={140,180,150},sky={sun=18,moon=0,stars=0},atm={dens=0.4,color={80,200,140},decay={40,150,90},glare=1.8,haze=2.2},clouds={cover=0.5,dens=0.5,color={200,255,220}}},
    ["Volcanic"]={clock=19,brightness=2,ambient={180,80,40},outAmb={200,90,50},sky={stars=200,sun=12,moon=0},atm={dens=0.75,color={255,60,0},decay={180,20,0},glare=3,haze=3.5},clouds={cover=0.8,dens=0.9,color={120,40,20}}},
    ["Arctic"]={clock=9,brightness=3.2,ambient={200,220,235},outAmb={210,230,245},sky={sun=10,stars=0,moon=0},atm={dens=0.3,color={180,220,255},decay={140,200,240},glare=1.5,haze=1.8},clouds={cover=0.7,dens=0.6,color={250,253,255}}},
    ["Midnight Ocean"]={clock=1.5,brightness=1.7,ambient={60,90,130},outAmb={70,100,140},sky={stars=6000,moon=24,sun=0,moonTex=true},atm={dens=0.5,color={20,60,140},decay={10,30,90},glare=0.6,haze=1.5}},
    ["Vaporwave"]={clock=19.5,brightness=2.4,ambient={180,120,200},outAmb={190,130,210},sky={stars=1000,moon=14},atm={dens=0.45,color={255,100,220},decay={120,60,255},glare=2.2,haze=2.4},clouds={cover=0.5,dens=0.55,color={200,150,255}}},
    ["Toxic"]={clock=13,brightness=2.5,ambient={140,180,80},outAmb={150,190,90},atm={dens=0.55,color={100,220,40},decay={60,150,20},glare=1.8,haze=2.6},clouds={cover=0.65,dens=0.7,color={180,255,120}}},
    ["Solar Eclipse"]={clock=12,brightness=0.9,ambient={50,40,60},outAmb={60,50,70},sky={stars=3500,sun=22,moon=0},atm={dens=0.5,color={255,140,40},decay={30,20,40},glare=2.8,haze=1.8}},
    ["Hellscape"]={clock=18,brightness=1.8,ambient={200,60,30},outAmb={220,70,40},sky={stars=100,sun=30,moon=0},atm={dens=0.85,color={255,30,0},decay={120,0,0},glare=3.5,haze=4},clouds={cover=0.95,dens=0.95,color={80,20,10}}},
    ["Heaven"]={clock=12,brightness=4,ambient={240,235,210},outAmb={250,245,220},sky={sun=16,moon=0,stars=0},atm={dens=0.25,color={255,250,220},decay={255,240,200},glare=3,haze=1.5},clouds={cover=0.85,dens=0.5,color={255,255,255}}},
    ["Storm"]={clock=15,brightness=1.4,ambient={90,90,110},outAmb={100,100,120},sky={stars=0,sun=6,moon=0},atm={dens=0.65,color={80,90,120},decay={40,50,80},glare=0.5,haze=3},clouds={cover=0.95,dens=0.95,color={60,65,80}}},
    ["Sunrise"]={clock=6.2,brightness=2.8,ambient={220,180,130},outAmb={230,190,140},sky={sun=22,stars=0,moon=0},atm={dens=0.45,color={255,180,100},decay={255,140,80},glare=2.4,haze=2.2},clouds={cover=0.4,dens=0.4,color={255,220,180}}},
    ["Deep Space"]={clock=0,brightness=1,ambient={30,25,50},outAmb={40,35,60},sky={stars=15000,moon=0,sun=0},atm={dens=0.08,color={15,5,40},decay={5,0,20},glare=0.2,haze=0.3}},
    ["Lavender Dream"]={clock=18.5,brightness=2.6,ambient={180,160,220},outAmb={190,170,230},sky={stars=800,moon=16,sun=0},atm={dens=0.4,color={200,160,255},decay={160,120,220},glare=1.4,haze=1.8},clouds={cover=0.55,dens=0.5,color={220,200,255}}},
    ["Inferno"]={clock=17.5,brightness=2.2,ambient={220,100,40},outAmb={235,110,50},sky={sun=26,moon=0,stars=0},atm={dens=0.6,color={255,90,20},decay={200,40,0},glare=3,haze=3.2},clouds={cover=0.7,dens=0.7,color={200,80,40}}},
    ["Mint Sky"]={clock=10,brightness=3.2,ambient={180,230,210},outAmb={190,240,220},sky={sun=10},atm={dens=0.32,color={150,255,210},decay={100,220,180},glare=1.6,haze=1.6},clouds={cover=0.55,dens=0.45,color={240,255,250}}},
}
SkyOrder={"Off","Animated Vaporwave","Night","Aurora","Sunset","Galaxy","Cyber","Sakura","Pink Night","Blood Moon","Emerald Dawn","Volcanic","Arctic","Midnight Ocean","Vaporwave","Toxic","Solar Eclipse","Hellscape","Heaven","Storm","Sunrise","Deep Space","Lavender Dream","Inferno","Mint Sky"}
function exeSkyColor(rgb) return Color3.fromRGB(rgb[1],rgb[2],rgb[3]) end
function ExeApplyCustomSky(mode)
    if skyAnimConn then pcall(function() skyAnimConn:Disconnect() end) skyAnimConn=nil end
    for _,child in ipairs(Lighting:GetChildren()) do if child:GetAttribute(EXE_SKY_TAG) then pcall(function() child:Destroy() end) end end
    local terrain=workspace:FindFirstChildOfClass("Terrain")
    if terrain then for _,child in ipairs(terrain:GetChildren()) do if child:GetAttribute(EXE_SKY_TAG) then pcall(function() child:Destroy() end) end end end
    local preset=EXE_SKY_PRESETS[mode]
    if not preset or preset.kind=="off" then Lighting.ClockTime=14;Lighting.Brightness=2;Lighting.OutdoorAmbient=Color3.fromRGB(127,127,127);Lighting.Ambient=Color3.fromRGB(127,127,127);Lighting.FogEnd=100000;Lighting.GlobalShadows=true;return end
    Lighting.FogStart=0;Lighting.FogEnd=100000;Lighting.FogColor=Color3.fromRGB(200,200,200);Lighting.ColorShift_Top=Color3.fromRGB(0,0,0);Lighting.ColorShift_Bottom=Color3.fromRGB(0,0,0);Lighting.GlobalShadows=true
    Lighting.ClockTime=preset.clock or 14;Lighting.Brightness=preset.brightness or 2
    if preset.outAmb then Lighting.OutdoorAmbient=exeSkyColor(preset.outAmb) end
    if preset.ambient then Lighting.Ambient=exeSkyColor(preset.ambient) end
    local skyInst=nil
    if preset.sky then
        skyInst=Instance.new("Sky")
        skyInst:SetAttribute(EXE_SKY_TAG,true)
        if preset.sky.stars then skyInst.StarCount=preset.sky.stars end
        if preset.sky.moon then skyInst.MoonAngularSize=preset.sky.moon end
        if preset.sky.sun then skyInst.SunAngularSize=preset.sky.sun end
        if preset.sky.moonTex then skyInst.MoonTextureId="rbxasset://sky/moon.jpg" end
        skyInst.Parent=Lighting
    end
    local atm=nil
    if preset.atm then
        atm=Instance.new("Atmosphere")
        atm:SetAttribute(EXE_SKY_TAG,true)
        atm.Density=preset.atm.dens or 0.3
        atm.Color=exeSkyColor(preset.atm.color)
        atm.Decay=exeSkyColor(preset.atm.decay)
        atm.Glare=preset.atm.glare or 1
        atm.Haze=preset.atm.haze or 1
        atm.Parent=Lighting
    end
    local clouds=nil
    if preset.clouds and terrain then
        clouds=Instance.new("Clouds")
        clouds:SetAttribute(EXE_SKY_TAG,true)
        clouds.Cover=preset.clouds.cover or 0.5
        clouds.Density=preset.clouds.dens or 0.5
        clouds.Color=exeSkyColor(preset.clouds.color)
        clouds.Parent=terrain
    end
    if mode=="Animated Vaporwave" then
        local bloom=Instance.new("BloomEffect")
        bloom:SetAttribute(EXE_SKY_TAG,true)
        bloom.Intensity=0.55
        bloom.Size=34
        bloom.Threshold=0.92
        bloom.Parent=Lighting
        local cc=Instance.new("ColorCorrectionEffect")
        cc:SetAttribute(EXE_SKY_TAG,true)
        cc.TintColor=Color3.fromRGB(210,180,255)
        cc.Saturation=0.22
        cc.Contrast=0.08
        cc.Brightness=0.02
        cc.Parent=Lighting
        skyAnimTick=0
        skyAnimConn=RunService.Heartbeat:Connect(function(dt)
            skyAnimTick=skyAnimTick+dt
            local t=skyAnimTick
            local pulse=(math.sin(t*0.7)+1)/2
            local swirl=(math.sin(t*1.35)+1)/2
            Lighting.ClockTime=19.7 + math.sin(t*0.08)*0.35
            Lighting.Brightness=2.55 + pulse*0.55
            Lighting.Ambient=Color3.fromRGB(math.floor(132+pulse*32),math.floor(60+pulse*22),math.floor(160+pulse*42))
            Lighting.OutdoorAmbient=Color3.fromRGB(math.floor(158+swirl*36),math.floor(76+swirl*26),math.floor(183+swirl*38))
            Lighting.FogColor=Color3.fromRGB(math.floor(190+swirl*38),math.floor(70+pulse*34),math.floor(176+pulse*46))
            Lighting.ColorShift_Top=Color3.fromRGB(math.floor(100+swirl*38),math.floor(25+pulse*18),math.floor(134+pulse*38))
            Lighting.ColorShift_Bottom=Color3.fromRGB(math.floor(55+swirl*20),math.floor(24+pulse*14),math.floor(90+pulse*28))
            if atm and atm.Parent then
                atm.Color=Color3.fromRGB(math.floor(196+pulse*48),math.floor(76+swirl*36),math.floor(205+pulse*45))
                atm.Decay=Color3.fromRGB(math.floor(100+swirl*35),math.floor(26+pulse*18),math.floor(160+pulse*45))
                atm.Density=0.34 + pulse*0.12
                atm.Haze=1.3 + swirl*1.2
                atm.Glare=0.7 + pulse*0.7
            end
            if clouds and clouds.Parent then
                clouds.Color=Color3.fromRGB(math.floor(215+pulse*30),math.floor(115+swirl*35),math.floor(210+pulse*40))
                clouds.Cover=0.28 + pulse*0.2
                clouds.Density=0.48 + swirl*0.24
            end
            if skyInst and skyInst.Parent then
                skyInst.StarCount=math.floor(9500 + pulse*4500)
                skyInst.MoonAngularSize=6 + pulse*8
            end
            if bloom and bloom.Parent then
                bloom.Intensity=0.4 + pulse*0.45
                bloom.Size=28 + math.floor(swirl*18)
            end
            if cc and cc.Parent then
                cc.TintColor=Color3.fromRGB(math.floor(215+pulse*35),math.floor(145+swirl*45),math.floor(230+pulse*25))
                cc.Saturation=0.12 + pulse*0.22
                cc.Contrast=0.05 + swirl*0.08
                cc.Brightness=0.01 + pulse*0.03
            end
        end)
    end
end




currentGuiTheme = "Exe"
GUI_THEME_ORDER = {"Exe"}
GUI_THEMES = {
    ["Exe"] = {
        
        BG=Color3.fromRGB(12,9,20), BG2=Color3.fromRGB(21,15,34), ROW_BG=Color3.fromRGB(25,17,39),
        ROW_BORDER=Color3.fromRGB(55,39,79), WHITE=Color3.fromRGB(255,255,255), GRAY=Color3.fromRGB(180,160,170),
        INP=Color3.fromRGB(12,8,10), ACCENT=Color3.fromRGB(163,94,255), ACCENT2=Color3.fromRGB(212,174,255),
        ACCENT3=Color3.fromRGB(43,25,69), OFF=Color3.fromRGB(28,18,22), SECT=Color3.fromRGB(188,143,255),
        MOB_ON=Color3.fromRGB(163,94,255), MOB_OFF=Color3.fromRGB(21,15,34), MOB_BORDER_OFF=Color3.fromRGB(55,39,79),
        MOB_TEXT_OFF=Color3.fromRGB(200,180,190), MOB_TEXT_ON=Color3.fromRGB(255,255,255),
        STEAL_BG=Color3.fromRGB(12,9,20), STEAL_FILL=Color3.fromRGB(163,94,255), STEAL_ACCENT=Color3.fromRGB(212,174,255),
        PARTICLE=Color3.fromRGB(255,80,120),
    },
}

function getTheme()
    return GUI_THEMES[currentGuiTheme] or GUI_THEMES["Exe"]
end




TS=TweenService
LP=Players.LocalPlayer
if not LP then
    local t0=tick()
    while not LP and tick()-t0<15 do
        task.wait(0.1)
        LP=Players.LocalPlayer
    end
end
if not LP then
    warn("[EXE DUELS] LocalPlayer missing")
end


PACKS = {
    ["Adidas Sports"] = {
        WalkAnim = 18537392113,
        RunAnim  = 18537384940,
        JumpAnim = 18537380791,
        FallAnim = 18537367238,
        SwimIdle = 18537387180,
        Swim     = 18537389531,
        Animation1 = 18537376492,
        Animation2 = 18537371272,
        ClimbAnim = 18537363391,
    },
    ["Adidas Community"] = {
        WalkAnim = 122150855457006,
        RunAnim  = 82598234841035,
        JumpAnim = 75290611992385,
        FallAnim = 98600215928904,
        SwimIdle = 109346520324160,
        Swim     = 133308483266208,
        Animation1 = 122257458498464,
        Animation2 = 102357151005774,
        ClimbAnim = 88763136693023,
    },
    ["Adidas Aura"] = {
        WalkAnim = 83842218823011,
        RunAnim  = 118320322718866,
        JumpAnim = 109996626521204,
        FallAnim = 95603166884636,
        SwimIdle = 94922130551805,
        Swim     = 134530128383903,
        Animation1 = 110211186840347,
        Animation2 = 114191137265065,
        ClimbAnim = 97824616490448,
    },
    ["Wicked Popular"] = {
        WalkAnim = 92072849924640,
        RunAnim = 72301599441680,
        JumpAnim = 104325245285198,
        FallAnim = 121152442762481,
        Animation1 = 118832222982049,
        ClimbAnim = 131326830509784,
        SwimIdle = 113199415118199,
        Swim = 99384245425157,
        Animation2 = 76049494037641,
    },
    Elder = {
        WalkAnim = 10921111375,
        RunAnim  = 10921104374,
        JumpAnim = 10921107367,
        FallAnim = 10921105765,
        SwimIdle = 10921110146,
        Swim     = 10921108971,
        ClimbAnim = 10921100400,
        Animation1 = 10921101664,
        Animation2 = 10921102574,
    },
    Zombie = {
        WalkAnim = 10921355261,
        RunAnim  = 616163682,
        JumpAnim = 10921351278,
        FallAnim = 10921350320,
        SwimIdle = 10921353442,
        Swim     = 10921352344,
        Animation1 = 10921344533,
        Animation2 = 10921345304,
        ClimbAnim = 10921343576,
    },
    Mage = {
        WalkAnim = 10921152678,
        RunAnim  = 10921148209,
        JumpAnim = 10921149743,
        FallAnim = 10921148939,
        SwimIdle = 10921151661,
        Swim     = 10921150788,
        ClimbAnim = 10921143404,
        Animation1 = 10921144709,
        Animation2 = 10921145797,
    },
    ["Catwalk Glam"] = {
        WalkAnim = 109168724482748,
        RunAnim  = 81024476153754,
        JumpAnim = 116936326516985,
        FallAnim = 92294537340807,
        SwimIdle = 98854111361360,
        Swim     = 134591743181628,
        ClimbAnim = 119377220967554,
        Animation1 = 133806214992291,
        Animation2 = 94970088341563,
    },
    Astronaut = {
        WalkAnim = 10921046031,
        RunAnim  = 10921039308,
        JumpAnim = 10921042494,
        FallAnim = 10921040576,
        SwimIdle = 10921045006,
        Swim     = 10921044000,
        ClimbAnim = 10921032124,
        Animation1 = 10921034824,
        Animation2 = 10921036806,
    },
    ['Wicked "Dancing Through Life"'] = {
        WalkAnim = 73718308412641,
        RunAnim  = 135515454877967,
        JumpAnim = 78508480717326,
        FallAnim = 78147885297412,
        SwimIdle = 129183123083281,
        Swim     = 110657013921774,
        ClimbAnim = 129447497744818,
        Animation1 = 92849173543269,
        Animation2 = 132238900951109,
    },
    Werewolf = {
        WalkAnim = 10921342074,
        RunAnim  = 10921336997,
        JumpAnim = nil,
        FallAnim = 10921337907,
        SwimIdle = 10921341319,
        Swim     = 10921340419,
        ClimbAnim = 10921329322,
        Animation1 = 10921330408,
        Animation2 = 10921333667,
    },
    Superhero = {
        WalkAnim = 10921298616,
        RunAnim  = 10921291831,
        JumpAnim = 10921294559,
        FallAnim = 10921293373,
        SwimIdle = 10921297391,
        Swim     = 10921295495,
        ClimbAnim = 10921286911,
        Animation1 = 10921288909,
        Animation2 = 10921290167,
    },
    Toy = {
        WalkAnim = 10921312010,
        RunAnim  = 10921306285,
        JumpAnim = 10921308158,
        FallAnim = 10921307241,
        SwimIdle = 10921310341,
        Swim     = 10921309319,
        ClimbAnim = 10921300839,
        Animation1 = 10921301576,
        Animation2 = nil,
    },
    ["No Boundaries"] = {
        WalkAnim = 18747074203,
        RunAnim  = 18747070484,
        JumpAnim = 18747069148,
        FallAnim = 18747062535,
        SwimIdle = 18747071682,
        Swim     = 18747073181,
        ClimbAnim = 18747060903,
        Animation1 = 18747067405,
        Animation2 = 18747063918,
    },
    NFL = {
        WalkAnim = 110358958299415,
        RunAnim  = 117333533048078,
        JumpAnim = 119846112151352,
        FallAnim = 129773241321032,
        SwimIdle = 79090109939093,
        Swim     = 132697394189921,
        ClimbAnim = 134630013742019,
        Animation1 = 92080889861410,
        Animation2 = 74451233229259,
    },
    ["Amazon Unboxed"] = {
        WalkAnim = 90478085024465,
        RunAnim  = 134824450619865,
        JumpAnim = 121454505477205,
        FallAnim = 94788218468396,
        SwimIdle = 129126268464847,
        Swim     = 105962919001086,
        ClimbAnim = 121145883950231,
        Animation1 = 98281136301627,
        Animation2 = nil,
    },
    Vampire = {
        WalkAnim = 10921326949,
        RunAnim  = 10921320299,
        JumpAnim = 10921322186,
        FallAnim = 10921321317,
        SwimIdle = 10921325443,
        Swim     = 10921324408,
        ClimbAnim = 10921314188,
        Animation1 = 10921315373,
        Animation2 = nil,
    },
    Ninja = {
        Run=656118852, Walk=656121766, Jump=656117878, Fall=656115606,
        Swim=656119721, SwimIdle=656121397, Climb=656114359,
        Idle={656117400,656118341,886742569}
    },
    Robot = {
        Run=616091570, Walk=616095330, Jump=616090535, Fall=616087089,
        Swim=616092998, SwimIdle=616094091, Climb=616086039,
        Idle={616088211,616089559,885531463}
    },
    Levitation = {
        Run=616010382, Walk=616013216, Jump=616008936, Fall=616005863,
        Swim=616011509, SwimIdle=616012453, Climb=616003713,
        Idle={616006778,616008087,886862142}
    },
    Stylish = {
        Run=616140816, Walk=616146177, Jump=616139451, Fall=616134815,
        Swim=616143378, SwimIdle=616144772, Climb=616133594,
        Idle={616136790,616138447,886888594}
    },
    Bubbly = {
        Run=910025107, Walk=910034870, Jump=910016857, Fall=910001910,
        Swim=910028158, SwimIdle=910030921, Climb=909997997,
        Idle={910004836,910009958,1018536639}
    },
    Cartoon = {
        Run=742638842, Walk=742640026, Jump=742637942, Fall=742637151,
        Swim=742639220, SwimIdle=742639812, Climb=742636889,
        Idle={742637544,742638445,885477856}
    },
}

animPack = "Adidas Sports"
animPackEnabled = true
headlessEnabled = false
korbloxEnabled = false

HEADLESS_MESH_ID = "rbxassetid://1095708"
KORBLOX_MESH_ID = "rbxassetid://101851696"
KORBLOX_TEXTURE_ID = "rbxassetid://101851254"
DARK_GREY_COLOR = Color3.fromRGB(64, 64, 64)

function removeFace(head)
    local face = head:FindFirstChild("face")
    if face then face:Destroy() end
end

function applyHeadlessToChar(char, enabled)
    if not char then return end
    local head = char:FindFirstChild("Head")
    if not head then return end
    if enabled then
        head.Transparency = 1
        head.CanCollide = false
        removeFace(head)
        for _, child in ipairs(head:GetChildren()) do
            if child:IsA("SpecialMesh") and child.MeshId == HEADLESS_MESH_ID then
                child:Destroy()
            end
        end
        local mesh = Instance.new("SpecialMesh")
        mesh.MeshType = Enum.MeshType.FileMesh
        mesh.MeshId = HEADLESS_MESH_ID
        mesh.Scale = Vector3.new(0.001, 0.001, 0.001)
        mesh.Name = "HeadlessMesh"
        mesh.Parent = head
        _wuzzTrack(head:GetPropertyChangedSignal("Transparency"):Connect(function()
            if head.Transparency ~= 1 then head.Transparency = 1 end
        end))
        _wuzzTrack(head.ChildAdded:Connect(function(child)
            if child.Name == "face" and child:IsA("Decal") then child:Destroy() end
        end))
    else
        head.Transparency = 0
        head.CanCollide = true
        for _, child in ipairs(head:GetChildren()) do
            if child:IsA("SpecialMesh") and child.Name == "HeadlessMesh" then
                child:Destroy()
            end
        end
        removeFace(head)
    end
end

function applyKorbloxToChar(char, enabled)
    if not char then return end
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    if enabled then
        if humanoid.RigType == Enum.HumanoidRigType.R6 then
            local rightLeg = char:FindFirstChild("Right Leg")
            if rightLeg then
                for _, child in ipairs(rightLeg:GetChildren()) do
                    if child:IsA("SpecialMesh") or child:IsA("CharacterMesh") then child:Destroy() end
                end
                rightLeg.Color = DARK_GREY_COLOR
                _wuzzTrack(rightLeg:GetPropertyChangedSignal("Color"):Connect(function()
                    if rightLeg.Color ~= DARK_GREY_COLOR then rightLeg.Color = DARK_GREY_COLOR end
                end))
                local mesh = Instance.new("SpecialMesh")
                mesh.MeshType = Enum.MeshType.FileMesh
                mesh.MeshId = KORBLOX_MESH_ID
                mesh.TextureId = KORBLOX_TEXTURE_ID
                mesh.Scale = Vector3.new(1, 1, 1)
                mesh.Name = "KorbloxMesh"
                mesh.Parent = rightLeg
            end
        elseif humanoid.RigType == Enum.HumanoidRigType.R15 then
            local rightUpperLeg = char:FindFirstChild("RightUpperLeg")
            if rightUpperLeg then
                rightUpperLeg.Transparency = 1
                local rightLowerLeg = char:FindFirstChild("RightLowerLeg")
                local rightFoot = char:FindFirstChild("RightFoot")
                if rightLowerLeg then rightLowerLeg.Transparency = 1 end
                if rightFoot then rightFoot.Transparency = 1 end
                local oldKorblox = char:FindFirstChild("KorbloxLeg")
                if oldKorblox then oldKorblox:Destroy() end
                local korbloxLeg = Instance.new("Part")
                korbloxLeg.Name = "KorbloxLeg"
                korbloxLeg.Size = Vector3.new(1, 2, 1)
                korbloxLeg.Anchored = false
                korbloxLeg.CanCollide = false
                korbloxLeg.Color = DARK_GREY_COLOR
                korbloxLeg.Parent = char
                local mesh = Instance.new("SpecialMesh")
                mesh.MeshType = Enum.MeshType.FileMesh
                mesh.MeshId = KORBLOX_MESH_ID
                mesh.TextureId = KORBLOX_TEXTURE_ID
                mesh.Scale = Vector3.new(1, 1, 1)
                mesh.Name = "KorbloxMesh"
                mesh.Parent = korbloxLeg
                local weld = Instance.new("Weld")
                weld.Part0 = rightUpperLeg
                weld.Part1 = korbloxLeg
                weld.C0 = CFrame.new(0, -0.8, 0)
                weld.Name = "KorbloxWeld"
                weld.Parent = korbloxLeg
            end
        end
    else
        if humanoid.RigType == Enum.HumanoidRigType.R6 then
            local rightLeg = char:FindFirstChild("Right Leg")
            if rightLeg then
                for _, child in ipairs(rightLeg:GetChildren()) do
                    if child:IsA("SpecialMesh") and child.Name == "KorbloxMesh" then child:Destroy() end
                end
                rightLeg.Color = Color3.fromRGB(255, 255, 255)
            end
        elseif humanoid.RigType == Enum.HumanoidRigType.R15 then
            local rightUpperLeg = char:FindFirstChild("RightUpperLeg")
            if rightUpperLeg then
                rightUpperLeg.Transparency = 0
                local rightLowerLeg = char:FindFirstChild("RightLowerLeg")
                local rightFoot = char:FindFirstChild("RightFoot")
                if rightLowerLeg then rightLowerLeg.Transparency = 0 end
                if rightFoot then rightFoot.Transparency = 0 end
                local korbloxLeg = char:FindFirstChild("KorbloxLeg")
                if korbloxLeg then korbloxLeg:Destroy() end
            end
        end
    end
end

function applyCharterToChar(char)
    if not char then return end
    applyHeadlessToChar(char, headlessEnabled)
    applyKorbloxToChar(char, korbloxEnabled)
end
function waitForAnimate(char)
    for _ = 1, 40 do
        local a = char:FindFirstChild("Animate")
        if a and a:FindFirstChild("idle") and a:FindFirstChild("run") and a:FindFirstChild("walk") then
            return a
        end
        task.wait(0.1)
    end
    return nil
end

function setAnim(animObj, id)
    if animObj and id then
        animObj.AnimationId = "rbxassetid://" .. tostring(id)
    end
end

function stopAllTracks(hum)
    if not hum then return end
    for _, t in ipairs(hum:GetPlayingAnimationTracks()) do
        pcall(function() t:Stop(0) end)
    end
end

function ensureAnim(folder, name)
    if not folder then return nil end
    local a = folder:FindFirstChild(name)
    if not a then
        a = Instance.new("Animation")
        a.Name = name
        a.Parent = folder
    end
    return a
end

function ensureIdleSlots(idleFolder, n)
    if not idleFolder then return end
    n = n or 2
    for i=1,n do
        ensureAnim(idleFolder, "Animation" .. i)
    end
end

function pickAnim(pack, ...)
    for i = 1, select("#", ...) do
        local k = select(i, ...)
        local v = pack[k]
        if v ~= nil then return v end
    end
    return nil
end

applyingAnim = false
function applyAnimPack(packName)
    if applyingAnim then return false end
    applyingAnim = true

    local pack = PACKS[packName]
    if not pack then
        applyingAnim = false
        return false
    end

    local char = LP.Character or LP.CharacterAdded:Wait()
    local animate = waitForAnimate(char)
    if not animate then
        applyingAnim = false
        return false
    end

    local hum = char:FindFirstChildOfClass("Humanoid")
    stopAllTracks(hum)

    local runObj   = ensureAnim(animate:FindFirstChild("run"),   "RunAnim")
    local walkObj  = ensureAnim(animate:FindFirstChild("walk"),  "WalkAnim")
    local jumpObj  = ensureAnim(animate:FindFirstChild("jump"),  "JumpAnim")
    local fallObj  = ensureAnim(animate:FindFirstChild("fall"),  "FallAnim")
    local climbObj = ensureAnim(animate:FindFirstChild("climb"), "ClimbAnim")
    local swimObj  = ensureAnim(animate:FindFirstChild("swim"),     "Swim")
    local swimIdleObj = ensureAnim(animate:FindFirstChild("swimidle"), "SwimIdle")
    local idleFolder = animate:FindFirstChild("idle")

    setAnim(walkObj,  pickAnim(pack, "WalkAnim", "Walk"))
    setAnim(runObj,   pickAnim(pack, "RunAnim", "Run"))
    setAnim(jumpObj,  pickAnim(pack, "JumpAnim", "Jump"))
    setAnim(fallObj,  pickAnim(pack, "FallAnim", "Fall"))
    setAnim(climbObj, pickAnim(pack, "ClimbAnim", "Climb"))
    setAnim(swimObj,      pickAnim(pack, "Swim"))
    setAnim(swimIdleObj,  pickAnim(pack, "SwimIdle") or pickAnim(pack, "Swim"))

    if idleFolder then
        local a1 = pickAnim(pack, "Animation1")
        local a2 = pickAnim(pack, "Animation2")
        if a1 or a2 then
            ensureIdleSlots(idleFolder, 2)
            local id1 = a1 or a2
            local id2 = a2 or a1 or id1
            setAnim(idleFolder:FindFirstChild("Animation1"), id1)
            setAnim(idleFolder:FindFirstChild("Animation2"), id2)
        elseif pack.Idle and #pack.Idle > 0 then
            ensureIdleSlots(idleFolder, math.max(2, #pack.Idle))
            setAnim(idleFolder:FindFirstChild("Animation1"), pack.Idle[1])
            setAnim(idleFolder:FindFirstChild("Animation2"), pack.Idle[2] or pack.Idle[1])
            for i = 3, #pack.Idle do
                local a = idleFolder:FindFirstChild("Animation" .. i)
                if a then setAnim(a, pack.Idle[i]) end
            end
        end
    end

    animate.Disabled = true
    task.wait(0.06)
    animate.Disabled = false

    if hum then
        pcall(function()
            hum:ChangeState(Enum.HumanoidStateType.Landed)
            task.wait(0.03)
            hum:ChangeState(Enum.HumanoidStateType.Running)
        end)
    end

    animPack = packName
    applyingAnim = false
    return true
end



NS,CS=60,30
speedBoosterEnabled=true
LAGGER_SPEED=15
LAGGER_CARRY_SPEED=24.5
carrySpeedActive = false
laggerModeEnabled = false
laggerCarryActive = false

antiRagdollEnabled,infJumpEnabled=false,false
playerEspEnabled,playerTracersEnabled=false,false
medusaCounterEnabled,batCounterEnabled,unwalkEnabled=false,false,false
medusaDebounce,medusaLastUsed,dropActive=false,0,false
autoLeftEnabled,autoRightEnabled=false,false
autoLeftSetVisual,autoRightSetVisual=nil,nil
speedLabel=nil
autoBatEnabled=false
batAimbotEnabled=false
antiBatBypassLockEnabled=false
antiDesyncAimbotEnabled=false
AIMBOT_SPEED=58
LAGGER_AIMBOT_SPEED=40
tpBatEnabled=false
aimbotV2Enabled=false
aimbotMode="normal"  
autoSwingEnabled=true
autoMoveSwingEnabled=false
autoMoveSwingInterval=0.3
_alSwingDebounce=false
_arSwingDebounce=false
autoBatSetVisual=nil
resetAutoBatMotion=nil
setBatCounterVisual=nil
startBatCounter,stopBatCounter=nil,nil
antiLagEnabled,removeAccessoriesEnabled,antiLagDescConn=false,false,nil
unwalkSavedAnimate,_anyKeyListening=nil,false
autoTPEnabled,autoTPHeight,autoTPConn,setAutoTPVisual=false,30,nil,nil
mirrorTPDownEnabled,mirrorTPPreviousY,mirrorTPLastTeleport=false,{},0
MIRROR_TP_DROP_THRESHOLD,MIRROR_TP_DOWN_Y=3,-7.00
setMirrorTPVisual=nil
guiTransparencyEnabled,mobileButtonsEnabled,mobileButtonsLocked=false,true,false
mobileButtonsSize=80
stealBarPos = nil 
autoStealStopPercent = "80" 
circleButtonsEnabled=false
stealBarFrame=nil
progressFill=nil
progressPct=nil
pbFrame=nil
setStealStatusText=nil
mobBtnRefs={}
mobGuiRef=nil
fovValue=80
fovOptions={80,120,180}
fovIndex=1
laggerModePillRef=nil
carryModePillRef=nil
autoSwitchSpeedEnabled=false 
mobBtnTransparencyEnabled=false
perButtonDragEnabled=true 
antiKickEnabled=false
safeModeEnabled=false
setSafeModeVisual=nil
antiKickSetVisual=nil
brainrotDetected=false
activeBatBillboard=nil
activeMedusaBillboard=nil
ragdollGuiEnabled=false  

introEnabled=false
halloweenMode=false
selectedIntroMusic=1 
persistentRagdollGui=nil 
uiLocked=false
infJumpMode="hold"
holdInfJumpConn=nil
DROP_ASCEND_DURATION=0.2
DROP_ASCEND_SPEED=150

MOB_POS_FILE="k7duels_btnpos.json"
forceDefaultBtnPos=false
activeMobDrag=nil 
function loadBtnPositions()
    local data={}
    
    pcall(function()
        local raw=readfile(MOB_POS_FILE)
        if raw and #raw>2 then
            local decoded=HS:JSONDecode(raw)
            if type(decoded)=="table" then data=decoded end
        end
    end)
    
    if not data or next(data)==nil then
        pcall(function()
            local raw=readfile("exeduels.json")
            if raw then
                local cfg=HS:JSONDecode(raw)
                if type(cfg)=="table" and type(cfg.btnPositions)=="table" and next(cfg.btnPositions)~=nil then
                    data=cfg.btnPositions
                end
            end
        end)
    end
    return data or {}
end
function saveBtnPositions()
    if not mobGuiRef then return end
    local out={}
    for _,child in ipairs(mobGuiRef:GetDescendants()) do
        if child:IsA("Frame") and child:GetAttribute("BtnKey") then
            local key=child:GetAttribute("BtnKey")
            out[key]={xs=0,xo=child.Position.X.Offset,ys=0,yo=child.Position.Y.Offset}
        end
    end
    
    if next(out)==nil then return end
    if writefile then
        pcall(function() writefile(MOB_POS_FILE,HS:JSONEncode(out)) end)
    end
    
    if writefile and isfile and isfile("exeduels.json") then
        pcall(function()
            local cfg=HS:JSONDecode(readfile("exeduels.json"))
            if type(cfg)=="table" then
                cfg.btnPositions=out
                writefile("exeduels.json",HS:JSONEncode(cfg))
            end
        end)
    end
end

task.spawn(function()
    while not _wuzzUnloaded do
        task.wait(2)
        pcall(saveBtnPositions)
    end
end)

refreshSpeedModeLabel,saveConfig=nil,nil
startUnwalk,stopUnwalk,setupMedusa,stopMedusaCounter=nil,nil,nil,nil
startAntiRagdoll,stopAntiRagdoll,startAutoLeft,stopAutoLeft,startAutoRight,stopAutoRight=nil,nil,nil,nil,nil,nil
startAutoTP,stopAutoTP,enableAntiLag,disableAntiLag=nil,nil,nil,nil
startBatAimbot,stopBatAimbot,queueAutoBatStart,runDrop,runTPFloor,startTPBat,stopTPBat=nil,nil,nil,nil,nil,nil,nil
startAutoSteal,stopAutoSteal,enableAntiKick,disableAntiKick,toggleCarryMode,toggleLaggerMode,toggleLaggerCarryMode=nil,nil,nil,nil,nil,nil,nil

function addShimmerToLabel(lbl,color1,color2)
    local gr=Instance.new("UIGradient",lbl)
    gr.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,color1 or Color3.fromRGB(160,80,255)),ColorSequenceKeypoint.new(0.5,color2 or Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(1,color1 or Color3.fromRGB(160,80,255))})
    gr.Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,0.3,0),NumberSequenceKeypoint.new(0.5,0,0),NumberSequenceKeypoint.new(1,0.3,0)})
    return gr
end
fovConn=nil
function applyFOV()
    if fovConn then fovConn:Disconnect() end
    fovConn=_wuzzTrack(RunService.RenderStepped:Connect(function() local cam=workspace.CurrentCamera;if cam then cam.FieldOfView=fovValue end end))
end
applyFOV()




do
    local timerBillboard = nil
    local timerLabel = nil
    local timerActive = false
    local timerConn = nil
    local ragdollCheckConn = nil
    local lastRagdollState = false

    local function getRagdollTheme()
        local th = (type(getTheme)=="function" and getTheme()) or nil
        if type(th)~="table" then
            th = (GUI_THEMES and GUI_THEMES[currentGuiTheme]) or nil
        end
        if type(th)~="table" then
            return {
                BG = Color3.fromRGB(8,8,10),
                ACCENT = Color3.fromRGB(255,255,255),
                ACCENT2 = Color3.fromRGB(200,200,210),
                WHITE = Color3.fromRGB(235,235,240),
                ROW_BORDER = Color3.fromRGB(32,32,36),
            }
        end
        return th
    end

    local function createTimerBillboard()
        if timerBillboard then timerBillboard:Destroy() end
        
        local char = LP.Character
        if not char then return end
        
        local head = char:FindFirstChild("Head")
        if not head then return end

        local th = getRagdollTheme()
        local accent = th.ACCENT or Color3.fromRGB(255,255,255)
        local bgCol = th.BG or Color3.fromRGB(8,8,10)
        local border = th.ROW_BORDER or Color3.fromRGB(32,32,36)
        
        timerBillboard = Instance.new("BillboardGui")
        timerBillboard.Name = "ExeRagdollTimer"
        timerBillboard.Size = UDim2.new(0, 140, 0, 56)
        timerBillboard.StudsOffset = Vector3.new(0, 5.6, 0)
        timerBillboard.AlwaysOnTop = true
        timerBillboard.MaxDistance = 120
        timerBillboard.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        timerBillboard.Parent = head
        
        local bgFrame = Instance.new("Frame")
        bgFrame.Name = "Bg"
        bgFrame.Size = UDim2.new(1, 0, 1, 0)
        bgFrame.BackgroundColor3 = bgCol
        bgFrame.BackgroundTransparency = 0.18
        bgFrame.BorderSizePixel = 0
        bgFrame.Parent = timerBillboard
        Instance.new("UICorner", bgFrame).CornerRadius = UDim.new(0, 12)
        
        local stroke = Instance.new("UIStroke", bgFrame)
        stroke.Name = "ThemeStroke"
        stroke.Color = accent
        stroke.Thickness = 1.8
        stroke.Transparency = 0.25

        
        local topBar = Instance.new("Frame")
        topBar.Name = "TopAccent"
        topBar.Size = UDim2.new(1, 0, 0, 2)
        topBar.Position = UDim2.new(0, 0, 0, 0)
        topBar.BackgroundColor3 = accent
        topBar.BackgroundTransparency = 0.1
        topBar.BorderSizePixel = 0
        topBar.ZIndex = 3
        topBar.Parent = bgFrame
        Instance.new("UICorner", topBar).CornerRadius = UDim.new(0, 12)

        timerLabel = Instance.new("TextLabel")
        timerLabel.Name = "TimerText"
        timerLabel.Size = UDim2.new(1, -8, 1, -6)
        timerLabel.Position = UDim2.new(0, 4, 0, 4)
        timerLabel.BackgroundTransparency = 1
        timerLabel.Text = "2.50"
        timerLabel.TextColor3 = accent
        timerLabel.Font = Enum.Font.GothamBlack
        timerLabel.TextSize = 26
        timerLabel.TextScaled = true
        timerLabel.ZIndex = 4
        timerLabel.Parent = bgFrame
        local tConstraint = Instance.new("UITextSizeConstraint")
        tConstraint.MinTextSize = 14
        tConstraint.MaxTextSize = 28
        tConstraint.Parent = timerLabel
        
        timerBillboard.Enabled = false
    end

    local function updateTimerDisplay(time, isReady)
        if not timerLabel or not timerBillboard then return end
        local th = getRagdollTheme()
        local accent = th.ACCENT or Color3.fromRGB(255,255,255)
        local accent2 = th.ACCENT2 or accent
        local bgCol = th.BG or Color3.fromRGB(8,8,10)
        local white = th.WHITE or Color3.fromRGB(235,235,240)
        
        if isReady then
            timerLabel.Text = "READY"
            timerLabel.TextColor3 = accent
            timerLabel.TextScaled = true
            local bg = timerLabel.Parent
            if bg then
                local stroke = bg:FindFirstChild("ThemeStroke") or bg:FindFirstChildOfClass("UIStroke")
                if stroke then
                    stroke.Color = accent
                    stroke.Thickness = 2.4
                    stroke.Transparency = 0.05
                end
                bg.BackgroundTransparency = 0.08
                bg.BackgroundColor3 = bgCol
                local top = bg:FindFirstChild("TopAccent")
                if top then
                    top.BackgroundColor3 = accent
                    top.BackgroundTransparency = 0
                end
            end
        else
            timerLabel.Text = string.format("%.2f", time)
            
            local t = math.clamp(time / 2.5, 0, 1)
            timerLabel.TextColor3 = accent:Lerp(white, (1 - t) * 0.25)
            timerLabel.TextScaled = true
            local bg = timerLabel.Parent
            if bg then
                local stroke = bg:FindFirstChild("ThemeStroke") or bg:FindFirstChildOfClass("UIStroke")
                if stroke then
                    stroke.Color = accent
                    stroke.Thickness = 1.6 + (1 - t) * 0.8
                    stroke.Transparency = 0.15 + t * 0.15
                end
                bg.BackgroundTransparency = 0.18
                bg.BackgroundColor3 = bgCol
                local top = bg:FindFirstChild("TopAccent")
                if top then
                    top.BackgroundColor3 = accent
                    top.BackgroundTransparency = 0.15
                end
            end
        end
    end

    local function startRagdollTimer()
        if timerActive then return end
        
        if not timerBillboard or not timerBillboard.Parent then
            createTimerBillboard()
            if not timerBillboard then return end
        end
        
        timerActive = true
        timerBillboard.Enabled = true
        local startTime = tick()
        local duration = 2.5
        
        if timerConn then timerConn:Disconnect() end
        timerConn = _wuzzTrack(RunService.Heartbeat:Connect(function()
            if not timerActive then 
                timerConn:Disconnect()
                timerConn = nil
                return 
            end
            
            local char = LP.Character
            if not char then
                timerActive = false
                if timerBillboard then timerBillboard.Enabled = false end
                if timerConn then timerConn:Disconnect(); timerConn = nil end
                return
            end
            
            local elapsed = tick() - startTime
            local remaining = math.max(duration - elapsed, 0)
            
            if remaining <= 0 then
                timerActive = false
                updateTimerDisplay(0, true)
                
                if timerConn then timerConn:Disconnect(); timerConn = nil end
                
                task.delay(1.5, function()
                    if timerBillboard then timerBillboard.Enabled = false end
                    timerActive = false
                end)
                return
            end
            
            updateTimerDisplay(remaining, false)
        end))
    end

    local function checkRagdoll()
        if ragdollCheckConn then return end
        
        ragdollCheckConn = _wuzzTrack(RunService.Heartbeat:Connect(function()
            local char = LP.Character
            if not char then return end
            local hum = char:FindFirstChildOfClass("Humanoid")
            if not hum then return end
            local state = hum:GetState()
            
            local isRagdolled = state == Enum.HumanoidStateType.Physics or 
                               state == Enum.HumanoidStateType.Ragdoll or 
                               state == Enum.HumanoidStateType.FallingDown
            
            if isRagdolled and not lastRagdollState and not timerActive then
                if not timerBillboard or not timerBillboard.Parent then
                    createTimerBillboard()
                end
                startRagdollTimer()
            end
            
            lastRagdollState = isRagdolled
        end))
    end
    
    task.spawn(checkRagdoll)
    
    
    
    
    playIntroAnimation = function()
        if introEnabled == false then return end
        local CoreGui = game:GetService("CoreGui")
        local SoundService = game:GetService("SoundService")
        local pgui = LP:FindFirstChild("PlayerGui") or LP:WaitForChild("PlayerGui", 10)
        local EXE_REDRUM_URL = "https://file.garden/algLafWA1jk8WMfK/redrum_spotdown.org%202.mp3"
        local EXE_REDRUM_FILE = "exe_duels_redrum.mp3"
        local connections = {}
        local closed = false
        local screen = nil
        local introSound = nil
        local started = tick()
        local leaving = nil
        local introTotalDuration = 10
        local exitFadeDuration = 0.36
        local duration = introTotalDuration - exitFadeDuration

        local function connect(signal, callback)
            local c = _wuzzTrack(signal:Connect(callback))
            table.insert(connections, c)
            return c
        end

        local function clean()
            closed = true
            for _, c in ipairs(connections) do
                pcall(function() c:Disconnect() end)
            end
            if introSound then
                pcall(function() introSound:Stop() end)
                pcall(function() introSound:Destroy() end)
                introSound = nil
            end
            if screen then
                pcall(function() screen:Destroy() end)
                screen = nil
            end
        end

        local function getRedrumAsset()
            local assetLoader = getcustomasset or getsynasset
            if type(assetLoader) ~= "function" or type(writefile) ~= "function" then
                return nil
            end
            local exists = false
            if type(isfile) == "function" then
                local ok, r = pcall(isfile, EXE_REDRUM_FILE)
                exists = ok and r == true
            end
            if not exists then
                local okD, data = pcall(function()
                    return game:HttpGet(EXE_REDRUM_URL)
                end)
                if not okD or type(data) ~= "string" or #data < 256 then
                    return nil
                end
                pcall(writefile, EXE_REDRUM_FILE, data)
            end
            local okA, asset = pcall(assetLoader, EXE_REDRUM_FILE)
            if okA and type(asset) == "string" and asset ~= "" then
                return asset
            end
            return nil
        end

        local ok, err = pcall(function()
            for _, parent in ipairs({CoreGui, pgui}) do
                if parent then
                    local previous = parent:FindFirstChild("EXEDuelsIntro")
                    if previous then
                        previous:Destroy()
                    end
                end
            end

            local function make(class, parent, properties)
                local object = Instance.new(class)
                if object:IsA("GuiObject") then
                    object.BorderSizePixel = 0
                end
                if properties then
                    for key, value in pairs(properties) do
                        object[key] = value
                    end
                end
                object.Parent = parent
                return object
            end

            local function round(object, radius)
                make("UICorner", object, {CornerRadius = UDim.new(0, radius)})
                return object
            end

            local function textL(parent, name, value, x, y, w, h, size, color, z)
                return make("TextLabel", parent, {
                    Name = name,
                    Text = value,
                    Position = UDim2.fromOffset(x, y),
                    Size = UDim2.fromOffset(w, h),
                    BackgroundTransparency = 1,
                    TextColor3 = color,
                    Font = Enum.Font.GothamBold,
                    TextSize = size,
                    ZIndex = z or 6,
                })
            end

            local amber = Color3.fromRGB(220, 220, 225)
            local ivory = Color3.fromRGB(255, 255, 255)

            screen = make("ScreenGui", nil, {
                Name = "EXEDuelsIntro",
                ResetOnSpawn = false,
                IgnoreGuiInset = true,
                DisplayOrder = 10000,
                ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
            })
            pcall(function()
                if syn and syn.protect_gui then
                    syn.protect_gui(screen)
                end
            end)
            pcall(function()
                screen.Parent = CoreGui
            end)
            if not screen.Parent and pgui then
                screen.Parent = pgui
            end

            local asset = getRedrumAsset()
            if asset then
                introSound = Instance.new("Sound")
                introSound.Name = "EXERedrumIntro"
                introSound.SoundId = asset
                introSound.Volume = 1
                introSound.Parent = SoundService
                pcall(function()
                    introSound.TimePosition = 40
                    introSound:Play()
                end)
                task.spawn(function()
                    local thisSound = introSound
                    local t0 = tick()
                    while thisSound and thisSound.Parent and tick() - t0 < 12 do
                        if thisSound.TimePosition >= 50 then
                            break
                        end
                        task.wait(0.05)
                    end
                    if thisSound and thisSound.Parent then
                        pcall(function()
                            thisSound:Stop()
                            thisSound:Destroy()
                        end)
                    end
                end)
            end

            local night = make("Frame", screen, {
                Name = "Nightfall",
                Size = UDim2.fromScale(1, 1),
                BackgroundColor3 = Color3.fromRGB(0, 0, 0),
                Active = true,
                ZIndex = 1,
            })
            make("UIGradient", night, {
                Rotation = 32,
                Color = ColorSequence.new(Color3.fromRGB(0, 0, 0), Color3.fromRGB(20, 20, 22)),
            })

            local stage = make("Frame", screen, {
                Name = "NightfallStage",
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.fromScale(0.5, 0.48),
                Size = UDim2.fromOffset(720, 350),
                BackgroundTransparency = 1,
                ZIndex = 2,
            })
            local scale = make("UIScale", stage, {Scale = 1})
            pcall(function()
                local cam = workspace.CurrentCamera
                local v = cam and cam.ViewportSize or Vector2.new(844, 390)
                scale.Scale = math.max(0.25, math.min((v.X - 32) / 720, (v.Y - 84) / 350, 1.2))
            end)

            local function pumpkin(parent, position, size, z)
                local root = make("Frame", parent, {
                    Name = "Pumpkin",
                    Position = position,
                    Size = UDim2.fromOffset(size, size),
                    BackgroundTransparency = 1,
                    ZIndex = z,
                })
                local function part(x, y, w, h, color, radius, rotation)
                    return round(make("Frame", root, {
                        Position = UDim2.fromScale(x, y),
                        Size = UDim2.fromScale(w, h),
                        BackgroundColor3 = color,
                        Rotation = rotation or 0,
                        ZIndex = z + 1,
                    }), radius)
                end
                part(0.42, 0.02, 0.12, 0.23, Color3.fromRGB(112, 125, 65), 3, 16)
                part(0.04, 0.22, 0.92, 0.68, Color3.fromRGB(164, 64, 24), size)
                part(0.09, 0.20, 0.52, 0.70, Color3.fromRGB(246, 115, 37), size)
                part(0.40, 0.20, 0.51, 0.70, Color3.fromRGB(222, 88, 27), size)
                local lobe = part(0.29, 0.17, 0.43, 0.75, Color3.fromRGB(255, 156, 63), size)
                make("UIGradient", lobe, {
                    Rotation = 90,
                    Color = ColorSequence.new(Color3.fromRGB(255, 212, 130), Color3.fromRGB(218, 96, 32)),
                })
                part(0.24, 0.38, 0.16, 0.12, Color3.fromRGB(33, 20, 17), 2, -20)
                part(0.61, 0.38, 0.16, 0.12, Color3.fromRGB(33, 20, 17), 2, 20)
                part(0.33, 0.65, 0.35, 0.10, Color3.fromRGB(44, 24, 17), 3)
                return root
            end

            local jack = nil 
            local edition = textL(stage, "Edition", "Wuzz Duels", 25, 54, 340, 22, 10, amber, 6)
            edition.TextXAlignment = Enum.TextXAlignment.Left
            local title = textL(stage, "Title", "EXE", 20, 81, 314, 108, 94, ivory, 6)
            title.TextXAlignment = Enum.TextXAlignment.Left
            title.Font = Enum.Font.GothamBlack
            make("UIGradient", title, {
                Rotation = 90,
                Color = ColorSequence.new(ivory, Color3.fromRGB(200, 200, 205)),
            })
            local subtitle = textL(stage, "Duels", "D U E L S", 26, 191, 298, 30, 19, ivory, 6)
            subtitle.TextXAlignment = Enum.TextXAlignment.Left
            local tagline = textL(stage, "Tagline", "READY TO DUEL.", 27, 228, 280, 20, 10, Color3.fromRGB(160, 160, 165), 6)
            tagline.TextXAlignment = Enum.TextXAlignment.Left

            local progressTrack = round(make("Frame", stage, {
                Position = UDim2.fromOffset(26, 320),
                Size = UDim2.fromOffset(660, 2),
                BackgroundColor3 = Color3.fromRGB(50, 50, 55),
                ZIndex = 6,
            }), 2)
            local fill = round(make("Frame", progressTrack, {
                Size = UDim2.fromScale(0, 1),
                BackgroundColor3 = amber,
                ZIndex = 7,
            }), 2)
            local caption = textL(stage, "Caption", "LOADING", 26, 330, 260, 16, 8, Color3.fromRGB(180, 180, 185), 6)
            caption.TextXAlignment = Enum.TextXAlignment.Left

            local enter = round(make("TextButton", screen, {
                Name = "Skip",
                AnchorPoint = Vector2.new(0.5, 1),
                Position = UDim2.new(0.5, 0, 1, -15),
                Size = UDim2.fromOffset(180, 32),
                Text = "CONTINUE  →",
                TextColor3 = ivory,
                Font = Enum.Font.GothamBold,
                TextSize = 10,
                BackgroundColor3 = Color3.fromRGB(24, 24, 28),
                AutoButtonColor = false,
                ZIndex = 9,
            }), 10)
            make("UIStroke", enter, {Color = amber, Transparency = 0.6, Thickness = 1})

            local fades = {}
            for _, o in ipairs(screen:GetDescendants()) do
                if o:IsA("GuiObject") then
                    table.insert(fades, {
                        object = o,
                        bg = o.BackgroundTransparency,
                        text = (o:IsA("TextLabel") or o:IsA("TextButton")) and o.TextTransparency or nil,
                        image = o:IsA("ImageLabel") and o.ImageTransparency or nil,
                    })
                elseif o:IsA("UIStroke") then
                    table.insert(fades, {object = o, stroke = o.Transparency})
                end
            end

            local function exit()
                if not leaving then
                    leaving = tick()
                end
            end
            connect(enter.Activated, exit)
            started = tick()

            connect(RunService.RenderStepped, function()
                if closed then
                    return
                end
                local elapsed = tick() - started
                if elapsed >= duration then
                    exit()
                end
                if leaving then
                    local a = math.clamp((tick() - leaving) / exitFadeDuration, 0, 1)
                    stage.Position = UDim2.fromScale(0.5, 0.48 - a * 0.04)
                    for _, f in ipairs(fades) do
                        if f.object.Parent then
                            if f.bg then
                                f.object.BackgroundTransparency = f.bg + (1 - f.bg) * a
                            end
                            if f.text then
                                f.object.TextTransparency = f.text + (1 - f.text) * a
                            end
                            if f.image then
                                f.object.ImageTransparency = f.image + (1 - f.image) * a
                            end
                            if f.stroke then
                                f.object.Transparency = f.stroke + (1 - f.stroke) * a
                            end
                        end
                    end
                    if a >= 1 then
                        closed = true
                    end
                    return
                end
                local reveal = math.clamp(elapsed / 0.75, 0, 1)
                local ease = 1 - (1 - reveal) ^ 3
                title.TextTransparency = 1 - ease
                subtitle.TextTransparency = 1 - ease
                title.Position = UDim2.fromOffset(20 - (1 - ease) * 26, 81)
                                fill.Size = UDim2.fromScale(math.clamp(elapsed / duration, 0, 1), 1)
            end)

            while not closed do
                task.wait(0.05)
            end
        end)

        if not ok then
            warn("[EXE DUELS] Intro: " .. tostring(err))
        end
        clean()
    end
end 





function safeModeGetCountdownLabel()
    local ok, label = pcall(function()
        local pg = LP:FindFirstChild("PlayerGui")
        if not pg then return nil end
        local top = pg:FindFirstChild("DuelsMachineTopFrame")
        if not top then return nil end
        local inner = top:FindFirstChild("DuelsMachineTopFrame") or top
        local timer = inner:FindFirstChild("Timer", true)
        if not timer then return nil end
        return timer:FindFirstChild("Label") or timer:FindFirstChildWhichIsA("TextLabel")
    end)
    return (ok and label) or nil
end
function safeModeCountdownNumber(text)
    local t = tostring(text or ""):upper():gsub("^%s+", ""):gsub("%s+$", "")
    if t == "GO" or t == "START" or t == "READY" then return true end
    local n = tonumber(t)
    return n ~= nil and n >= 0 and n <= 10
end
function safeModeInDuelCountdown()
    local label = safeModeGetCountdownLabel()
    return label and safeModeCountdownNumber(label.Text) or false
end
function safeModeHoldingBrainrot()
    local ok, val = pcall(function() return LP:GetAttribute("Stealing") end)
    if ok and val == true then return true end
    local ok2, val2 = pcall(function() return LP:GetAttribute("AntiKick") end)
    if ok2 and val2 == true then return true end
    if brainrotDetected then return true end
    local char = LP.Character
    if not char then return false end
    local ok3, val3 = pcall(function() return char:GetAttribute("Stealing") end)
    if ok3 and val3 == true then return true end
    for _, tool in ipairs(char:GetChildren()) do
        if tool:IsA("Tool") then
            local n = tool.Name:lower()
            if n:find("brainrot") or n:find("skibidi") or n:find("toilet") then return true end
        end
    end
    return false
end
function safeModeIsLocked()
    if not safeModeEnabled then return false end
    return safeModeInDuelCountdown() or safeModeHoldingBrainrot()
end
function safeModeForceStop(reason)
    if autoBatEnabled then
        autoBatEnabled=false
        if stopBatAimbot then pcall(stopBatAimbot) end
        if autoBatSetVisual then autoBatSetVisual(false) end
        if mobBtnRefs and mobBtnRefs.autoBat then mobBtnRefs.autoBat(false) end
    end
    if autoLeftEnabled then
        autoLeftEnabled=false
        if stopAutoLeft then pcall(stopAutoLeft) end
        if autoLeftSetVisual then autoLeftSetVisual(false) end
        if mobBtnRefs and mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(false) end
    end
    if autoRightEnabled then
        autoRightEnabled=false
        if stopAutoRight then pcall(stopAutoRight) end
        if autoRightSetVisual then autoRightSetVisual(false) end
        if mobBtnRefs and mobBtnRefs.autoRight then mobBtnRefs.autoRight(false) end
    end
    if tpBatEnabled then
        tpBatEnabled=false
        if stopTPBat then pcall(stopTPBat) end
    end
end
function safeModeTryStart()
    if safeModeIsLocked() then
        safeModeForceStop("SAFE MODE LOCK")
        return false
    end
    return true
end
function enableSafeMode()
    safeModeEnabled = true
end
function disableSafeMode()
    safeModeEnabled = false
end
if not _G._SafeModeMonitorStarted_Exe then
    _G._SafeModeMonitorStarted_Exe = true
    task.spawn(function()
        while not _wuzzUnloaded do
            task.wait(0.2)
            if safeModeEnabled and safeModeIsLocked() then
                safeModeForceStop("SAFE MODE LOCK")
            end
        end
    end)
end



KB={DropBrainrot={kb=nil,gp=nil},AutoLeft={kb=nil,gp=nil},AutoRight={kb=nil,gp=nil},AutoBat={kb=nil,gp=nil},TPBat={kb=nil,gp=nil},TPFloor={kb=nil,gp=nil},GuiHide={kb=nil,gp=nil},SpeedToggle={kb=nil,gp=nil},LaggerToggle={kb=nil,gp=nil},LaggerCarry={kb=nil,gp=nil},AntiDesync={kb=nil,gp=nil},LaggerPanel={kb=nil,gp=nil}}
AP_L1,AP_L2=Vector3.new(-476.47,-6.28,92.73),Vector3.new(-483.12,-4.95,94.81)
AP_R1,AP_R2=Vector3.new(-476.16,-6.52,25.62),Vector3.new(-483.06,-5.03,25.48)
Steal={AutoStealEnabled=false,StealRadius=61,StealDuration=1.3,Data={},plotCache={},plotCacheTime={},cachedPrompts={},promptCacheTime=0}
lastStealTick=0
isStealing,stealStartTime=false,nil
Conns={autoSteal=nil,antiRag=nil,batCounter=nil,anchor={}}
MEDUSA_COOLDOWN=25;batCounterDebounce=false
modeValLbl=nil;lastMoveDir=Vector3.new(0,0,0)
_lastRagExitTime=0  
MOVE_KEYS={[Enum.KeyCode.W]=true,[Enum.KeyCode.A]=true,[Enum.KeyCode.S]=true,[Enum.KeyCode.D]=true,[Enum.KeyCode.Up]=true,[Enum.KeyCode.Left]=true,[Enum.KeyCode.Down]=true,[Enum.KeyCode.Right]=true}
function isRagdollState(hum)
    if not hum then return true end
    local st=hum:GetState()
    
    return hum.PlatformStand or st==Enum.HumanoidStateType.Physics or st==Enum.HumanoidStateType.Ragdoll
end
function isMyPlotByName(plotName)
    local ct=tick()
    if Steal.plotCache[plotName] ~= nil and (ct-(Steal.plotCacheTime[plotName] or 0)) < 2 then
        return Steal.plotCache[plotName]
    end
    local plots=workspace:FindFirstChild("Plots"); if not plots then Steal.plotCache[plotName]=false; Steal.plotCacheTime[plotName]=ct; return false end
    local plot=plots:FindFirstChild(plotName); if not plot then Steal.plotCache[plotName]=false; Steal.plotCacheTime[plotName]=ct; return false end
    local sign=plot:FindFirstChild("PlotSign")
    if sign then
        local yb=sign:FindFirstChild("YourBase")
        if yb and yb:IsA("BillboardGui") then
            local r = yb.Enabled==true
            Steal.plotCache[plotName]=r; Steal.plotCacheTime[plotName]=ct
            return r
        end
        
        local sg = sign:FindFirstChild("SurfaceGui")
        local frame = sg and sg:FindFirstChild("Frame")
        local lbl = frame and frame:FindFirstChild("TextLabel")
        if lbl and lbl.Text and lbl.Text ~= "Empty Base" then
            local owner = lbl.Text:gsub("'s [Bb]ase$", ""):gsub("%s+$", "")
            local r = (owner == LP.DisplayName) or (owner == LP.Name)
            Steal.plotCache[plotName]=r; Steal.plotCacheTime[plotName]=ct
            return r
        end
    end
    Steal.plotCache[plotName]=false; Steal.plotCacheTime[plotName]=ct
    return false
end

function collectPromptFromSpawn(sp)
    if not sp then return nil end
    local att = sp:FindFirstChild("PromptAttachment")
    if att then
        for _,child in ipairs(att:GetChildren()) do
            if child:IsA("ProximityPrompt") then return child end
        end
    end
    for _,child in ipairs(sp:GetDescendants()) do
        if child:IsA("ProximityPrompt") then return child end
    end
    return nil
end

function grabConnectionFns(signal)
    local out = {}
    if not signal then return out end
    local list = nil
    pcall(function()
        if getconnections then
            list = getconnections(signal)
        elseif get_signal_cons then
            list = get_signal_cons(signal)
        end
    end)
    if type(list) ~= "table" then return out end
    for _,c in ipairs(list) do
        local fn = nil
        pcall(function() fn = c.Function or c.func or c.Fn end)
        if type(fn) == "function" then
            table.insert(out, fn)
        end
    end
    return out
end




autoStealMode = "75"
autoStealVariant = 1
autoStealGeneration = 0
autoStealStartedAt = 0
autoStealLastActivity = tick()
autoStealSupervisorConn = nil
autoStealSupervisorElapsed = 0
AUTO_STEAL_VARIANT_NAMES = {"75", "80", "85", "90", "V3", "Semi"}
autoGrabSetDelayRadius = 9
CONFIG_STEAL_RANGE = 61

Steal.StealRadius = Steal.StealRadius or CONFIG_STEAL_RANGE
Steal.StealDuration = Steal.StealDuration or 1.3
Steal.Data = Steal.Data or {}

function setAutoStealMode(mode)
    autoStealVariant = 1
    if mode == "V2" then mode = "80" elseif mode == "V1" then mode = "75" end
    for i, name in ipairs(AUTO_STEAL_VARIANT_NAMES) do
        if name == tostring(mode) then autoStealVariant = i; break end
    end
    autoStealMode = AUTO_STEAL_VARIANT_NAMES[autoStealVariant]
end

function getAutoStealDuration()
    local factors = {0.75, 0.80, 0.85, 0.90, 1, 1}
    return Steal.StealDuration * (factors[autoStealVariant] or 0.75)
end

_plotsCache, _plotsCacheTime = nil, 0
function getPlotsRoot()
    local now = tick()
    if _plotsCache and now - _plotsCacheTime < 2 and _plotsCache.Parent then
        return _plotsCache
    end
    _plotsCache = workspace:FindFirstChild("Plots")
    _plotsCacheTime = now
    return _plotsCache
end

function findNearestPrompt()
    local char = LP.Character
    if not char then return nil, nil end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return nil, nil end
    local plotsRoot = getPlotsRoot()
    if not plotsRoot then return nil, nil end
    local nearestPrompt, nearestDist, nearestName = nil, math.huge, nil
    local rpos = root.Position
    for _, plot in ipairs(plotsRoot:GetChildren()) do
        if not isMyPlotByName(plot.Name) then
            local pods = plot:FindFirstChild("AnimalPodiums")
            if pods then
                for _, pod in ipairs(pods:GetChildren()) do
                    pcall(function()
                        local base = pod:FindFirstChild("Base")
                        local spawn = base and base:FindFirstChild("Spawn")
                        if spawn then
                            local sp = spawn.Position
                            local dx, dy, dz = sp.X - rpos.X, sp.Y - rpos.Y, sp.Z - rpos.Z
                            local dist = math.sqrt(dx*dx + dy*dy + dz*dz)
                            if dist < nearestDist and dist <= (Steal.StealRadius or 61) then
                                local att = spawn:FindFirstChild("PromptAttachment")
                                if att then
                                    for _, child in ipairs(att:GetChildren()) do
                                        if child:IsA("ProximityPrompt") and child.ActionText and tostring(child.ActionText):find("Steal") then
                                            nearestPrompt = child
                                            nearestDist = dist
                                            nearestName = pod.Name
                                            break
                                        end
                                    end
                                end
                            end
                        end
                    end)
                end
            end
        end
    end
    return nearestPrompt, nearestName
end

updateStealProgress = function(value, state) end

function executeSteal(prompt, podName)
    if isStealing or not prompt or not prompt.Parent then return end
    for old in pairs(Steal.Data) do if not old.Parent then Steal.Data[old] = nil end end
    local data = Steal.Data[prompt]
    if not data then
        data = {hold = {}, trigger = {}, ready = true}
        Steal.Data[prompt] = data
        pcall(function()
            if type(getconnections) ~= "function" then return end
            for _, c in ipairs(getconnections(prompt.PromptButtonHoldBegan)) do
                if c.Function then table.insert(data.hold, c.Function) end
            end
            for _, c in ipairs(getconnections(prompt.Triggered)) do
                if c.Function then table.insert(data.trigger, c.Function) end
            end
        end)
    end
    if not data.ready then return end
    local generation = autoStealGeneration
    data.ready = false
    isStealing = true
    autoStealStartedAt = tick()
    autoStealLastActivity = autoStealStartedAt
    local function active()
        return generation == autoStealGeneration and isStealing and Steal.AutoStealEnabled
    end
    local function distance()
        if not prompt.Parent or not prompt.Parent.Parent then return nil end
        local char = LP.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not root or not hum or hum.Health <= 0 then return nil end
        local parent = prompt.Parent
        local part = parent:IsA("BasePart") and parent or parent.Parent
        if not part or not part:IsA("BasePart") then return nil end
        return (root.Position - part.Position).Magnitude
    end
    local function valid()
        if not active() then return false end
        local d = distance()
        return d ~= nil and d <= (Steal.StealRadius or 61)
    end
    task.spawn(function()
        local success, err = pcall(function()
            updateStealProgress(0, "STEALING")
            for _, fn in ipairs(data.hold) do task.spawn(fn) end
            local started = tick()
            local duration = Steal.StealDuration or 1.3
            local stopTime = getAutoStealDuration()
            while valid() and tick() - started < stopTime do
                updateStealProgress((tick() - started) / duration, "STEALING")
                task.wait()
            end
            if not valid() then return end
            local stopProgress = math.clamp(stopTime / duration, 0, 1)
            updateStealProgress(stopProgress, "APPROACH")
            local deadline = tick() + math.max(2.99 - stopTime - math.max(duration - stopTime, 0), 0.05)
            while valid() do
                local d = distance()
                if d and d <= autoGrabSetDelayRadius then break end
                if tick() >= deadline then return end
                task.wait()
            end
            if not valid() then return end
            local fillStart = tick()
            local fillDuration = math.max(duration - stopTime, 0.05)
            while valid() do
                local fp = math.clamp((tick() - fillStart) / fillDuration, 0, 1)
                updateStealProgress(stopProgress + fp * (1 - stopProgress), "STEALING")
                if fp >= 1 then break end
                task.wait()
            end
            if not valid() then return end
            for _, fn in ipairs(data.trigger) do task.spawn(fn) end
            local remote = game:GetService("ReplicatedStorage"):FindFirstChild("StealAnimal")
            if remote and remote:IsA("RemoteEvent") and podName then
                pcall(function() remote:FireServer(podName) end)
            end
            if #data.trigger == 0 then
                if type(fireproximityprompt) == "function" then
                    pcall(fireproximityprompt, prompt)
                else
                    pcall(function() prompt:InputHoldBegin(); prompt:InputHoldEnd() end)
                end
            end
            updateStealProgress(1, "COMPLETE")
            task.wait(0.12)
        end)
        data.ready = true
        if generation == autoStealGeneration then
            isStealing = false
            autoStealStartedAt = 0
            autoStealLastActivity = tick()
            updateStealProgress(0, "READY")
        end
        if not success then warn("[EXE DUELS Auto Steal] " .. tostring(err)) end
    end)
end

startAutoSteal = function()
    Steal.StealRadius = (autoStealVariant == 6) and 10 or (Steal.StealRadius or CONFIG_STEAL_RANGE)
    Steal.AutoStealEnabled = true
    autoStealLastActivity = tick()
    if Conns.autoSteal then
        pcall(function() Conns.autoSteal:Disconnect() end)
        Conns.autoSteal = nil
    end
    Conns.autoSteal = _wuzzTrack(RunService.Heartbeat:Connect(function()
        if not Steal.AutoStealEnabled then return end
        if isStealing then
            if autoStealStartedAt > 0 and (tick() - autoStealStartedAt) > 6 then
                autoStealGeneration = autoStealGeneration + 1
                isStealing = false
                autoStealStartedAt = 0
                for _, data in pairs(Steal.Data) do data.ready = true end
                updateStealProgress(0, "READY")
            end
            return
        end
        local p, name = findNearestPrompt()
        if p then
            autoStealLastActivity = tick()
            executeSteal(p, name)
        end
    end))
end

stopAutoSteal = function()
    autoStealGeneration = autoStealGeneration + 1
    if Conns.autoSteal then
        pcall(function() Conns.autoSteal:Disconnect() end)
        Conns.autoSteal = nil
    end
    isStealing = false
    autoStealStartedAt = 0
    autoStealLastActivity = tick()
    Steal.AutoStealEnabled = false
    for _, data in pairs(Steal.Data) do data.ready = true end
    updateStealProgress(0, "READY")
end

if autoStealSupervisorConn then pcall(function() autoStealSupervisorConn:Disconnect() end) end
autoStealSupervisorConn = _wuzzTrack(RunService.Heartbeat:Connect(function(dt)
    autoStealSupervisorElapsed = autoStealSupervisorElapsed + (dt or 0)
    if autoStealSupervisorElapsed < 0.5 then return end
    autoStealSupervisorElapsed = 0
    if Steal.AutoStealEnabled then
        local alive = Conns.autoSteal and Conns.autoSteal.Connected
        if not alive then
            pcall(startAutoSteal)
        elseif isStealing and autoStealStartedAt > 0 and (tick() - autoStealStartedAt) > 6 then
            autoStealGeneration = autoStealGeneration + 1
            isStealing = false
            autoStealStartedAt = 0
            for _, data in pairs(Steal.Data) do data.ready = true end
            updateStealProgress(0, "READY")
        end
    end
end))





function getActiveMoveSpeed()
    if laggerCarryActive then return LAGGER_CARRY_SPEED
    elseif laggerModeEnabled then return LAGGER_SPEED
    elseif carrySpeedActive then return CS
    else return NS end
end
function getAutoPathSpeed()
    if laggerModeEnabled then return LAGGER_SPEED
    else return NS end
end

_moveDt = 1/60
_speedActive = false
_lastHorizSpeed = 0
_actualSpeed = 0
_lastPos = nil
_lastPosT = 0

function destroySpeedConstraint()
    _speedActive = false
end

function clearSpeedConstraint()
    _speedActive = false
    _lastHorizSpeed = 0
end

function applyImpulseVel(part, targetVel)
    if not part or not part.Parent then return end
    pcall(function()
        local mass = part.AssemblyMass
        if not mass or mass ~= mass or mass <= 0 then mass = 1 end
        local current = part.AssemblyLinearVelocity
        local delta = targetVel - current
        part:ApplyImpulse(delta * mass)
    end)
end

function applyVel(part, targetVel)
    applyImpulseVel(part, targetVel)
end

function applyAngVel(part, targetAng)
    if not part or not part.Parent then return end
    pcall(function()
        local mass = part.AssemblyMass
        if not mass or mass <= 0 then mass = 1 end
        local current = part.AssemblyAngularVelocity
        local target = targetAng or Vector3.zero
        part:ApplyAngularImpulse((target - current) * mass * 0.35)
    end)
end

_lastGroundNormalY = 1
function sampleGround(hrp)
    local ok, res = pcall(function()
        local origin = hrp.Position + Vector3.new(0, 2, 0)
        local params = RaycastParams.new()
        params.FilterType = Enum.RaycastFilterType.Exclude
        local char = hrp.Parent
        if char then params.FilterDescendantsInstances = {char} end
        params.IgnoreWater = true
        local hit = workspace:Raycast(origin, Vector3.new(0, -8, 0), params)
        if hit and hit.Normal then
            return {ny = hit.Normal.Y, grounded = (hit.Distance < 4.2)}
        end
        return {ny = 1, grounded = false}
    end)
    if ok and type(res) == "table" and type(res.ny) == "number" then
        _lastGroundNormalY = res.ny
        return res.ny, res.grounded == true
    end
    return _lastGroundNormalY, false
end

function setSpeedConstraint(hrp, horizVel)
    if not hrp or not hrp.Parent then return end
    local hx, hz = horizVel.X, horizVel.Z
    local mag = math.sqrt(hx * hx + hz * hz)
    _lastHorizSpeed = mag
    _speedActive = mag > 0.05
    if mag < 0.05 then return end
    
    pcall(function()
        local v = hrp.AssemblyLinearVelocity
        hrp.AssemblyLinearVelocity = Vector3.new(hx, v.Y, hz)
    end)
end

function brakeHorizontal(hrp)
    if not hrp or not hrp.Parent then return end
    pcall(function()
        local ny, grounded = sampleGround(hrp)
        if not grounded then return end
        local v = hrp.AssemblyLinearVelocity
        local hx, hz = v.X, v.Z
        local hMag = math.sqrt(hx * hx + hz * hz)
        if hMag < 0.8 then
            if hMag > 0.05 then
                hrp.AssemblyLinearVelocity = Vector3.new(0, v.Y, 0)
            end
            return
        end
        local mass = hrp.AssemblyMass
        if not mass or mass ~= mass or mass <= 0 then mass = 1 end
        local target = Vector3.new(0, v.Y, 0)
        hrp:ApplyImpulse((target - v) * mass * 0.92)
    end)
end

function applyCFrameMove(part, dirUnit, spd, dt)
    if not part or not part.Parent then return end
    if not dirUnit or dirUnit.Magnitude < 0.01 then return end
    _moveDt = dt or _moveDt
    setSpeedConstraint(part, Vector3.new(dirUnit.X, 0, dirUnit.Z).Unit * spd)
end

function startHoldInfJump()
    if holdInfJumpConn then holdInfJumpConn:Disconnect() end
    holdInfJumpConn = _wuzzTrack(RunService.Heartbeat:Connect(function()
        if not infJumpEnabled or _wuzzUnloaded then return end
        local char = LP.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not root or not hum then return end
        local isJumpHeld = UIS:IsKeyDown(Enum.KeyCode.Space) or (hum.Jump == true)
        local cv = root.AssemblyLinearVelocity
        if isJumpHeld and cv.Y < 35 then
            applyVel(root, Vector3.new(cv.X, 55, cv.Z))
        end
        cv = root.AssemblyLinearVelocity
        if cv.Y < -120 then
            applyVel(root, Vector3.new(cv.X, -120, cv.Z))
        end
    end))
end

function stopHoldInfJump()
    if holdInfJumpConn then
        holdInfJumpConn:Disconnect()
        holdInfJumpConn = nil
    end
end






_wuzzTrack(RunService.Heartbeat:Connect(function(dt)
    _moveDt = dt
    local char = LP.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hum or not hrp then return end
    if isRagdollState(hum) then
        lastMoveDir = Vector3.new(0, 0, 0)
        _speedActive = false
        _lastHorizSpeed = 0
        brakeHorizontal(hrp)
        if speedLabel then speedLabel.Text = "0.0 SPEED" end
        return
    end

    if not speedBoosterEnabled then
        return
    end

    local spd = getActiveMoveSpeed()
    local moving = false
    
    local controlled = not autoBatEnabled and not tpBatEnabled and not autoLeftEnabled and not autoRightEnabled

    pcall(function()
        if hum.CameraOffset.Magnitude > 0.05 then
            hum.CameraOffset = Vector3.new(0, 0, 0)
        end
    end)

    if controlled then
        local md = hum.MoveDirection
        if md.Magnitude > 0.05 then
            lastMoveDir = Vector3.new(md.X, 0, md.Z).Unit
            moving = true
            setSpeedConstraint(hrp, lastMoveDir * spd)
        else
            _speedActive = false
            _lastHorizSpeed = 0
            brakeHorizontal(hrp)
        end
    end

    if speedLabel then
        if moving or _speedActive then
            speedLabel.Text = string.format("%.1f SPEED", spd)
        else
            speedLabel.Text = "0.0 SPEED"
        end
    end
end))


function onHumanoidStateChanged(old, new)
    local char = LP.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    local isRag = (new == Enum.HumanoidStateType.Physics or new == Enum.HumanoidStateType.Ragdoll or new == Enum.HumanoidStateType.FallingDown)
    if isRag and not hum.PlatformStand and not activeBatBillboard then
        if type(createRagdollBillboard) == "function" then
            activeBatBillboard = createRagdollBillboard(2.5, "RAGDOLL", Color3.fromRGB(200, 200, 210))
            task.delay(2.6, function()
                if activeBatBillboard then
                    pcall(function() activeBatBillboard:Destroy() end)
                    activeBatBillboard = nil
                end
            end)
        end
    end
end

function onMedusaStateChanged()
    local char = LP.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum and hum.PlatformStand and not activeMedusaBillboard then
        if type(createRagdollBillboard) == "function" then
            activeMedusaBillboard = createRagdollBillboard(4.5, "STONE", Color3.fromRGB(255, 255, 255))
            task.delay(4.5, function()
                if activeMedusaBillboard then
                    pcall(function() activeMedusaBillboard:Destroy() end)
                    activeMedusaBillboard = nil
                end
            end)
        end
    end
end

function setupRagdollTriggers()
    local char = LP.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        _wuzzTrack(hum.StateChanged:Connect(onHumanoidStateChanged))
        _wuzzTrack(hum:GetPropertyChangedSignal("PlatformStand"):Connect(onMedusaStateChanged))
    end
end

function getSpeedThemeColors()
    local th = (type(getTheme) == "function" and getTheme()) or nil
    local accent = th and th.ACCENT or Color3.fromRGB(255, 255, 255)
    local accent2 = th and th.ACCENT2 or Color3.fromRGB(220, 220, 220)
    local gray = th and th.GRAY or Color3.fromRGB(200, 200, 210)
    return accent, accent2, gray
end

function applySpeedIndicatorTheme()
    local char = LP.Character
    if not char then return end
    local head = char:FindFirstChild("Head")
    if not head then return end
    local bb = head:FindFirstChild("ExeSpeedBB") or head:FindFirstChild("K7SpeedBB")
    if not bb then return end
    local accent, accent2, gray = getSpeedThemeColors()
    for _, lbl in ipairs(bb:GetChildren()) do
        if lbl:IsA("TextLabel") then
            if lbl.Name == "DiscordLbl" then
                lbl.TextColor3 = gray
                local gr = lbl:FindFirstChildOfClass("UIGradient")
                if gr then
                    gr.Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, gray),
                        ColorSequenceKeypoint.new(0.5, accent),
                        ColorSequenceKeypoint.new(1, gray),
                    })
                end
            else
                lbl.TextColor3 = accent
                local gr = lbl:FindFirstChildOfClass("UIGradient")
                if gr then
                    gr.Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, accent2),
                        ColorSequenceKeypoint.new(0.5, accent),
                        ColorSequenceKeypoint.new(1, accent2),
                    })
                end
            end
        end
    end
end

function setupSpeedIndicator(char)
    if not char then return end
    local head = char:FindFirstChild("Head") or char:WaitForChild("Head", 5)
    if not head then return end
    pcall(function()
        local old = head:FindFirstChild("WuzzSpeedBB") or head:FindFirstChild("ExeSpeedBB") or head:FindFirstChild("K7SpeedBB")
        if old then old:Destroy() end
    end)
    speedLabel = nil
    local accent, accent2, gray = getSpeedThemeColors()
    local bb = Instance.new("BillboardGui")
    bb.Name = "WuzzSpeedBB"
    bb.Size = UDim2.new(0, 130, 0, 48)
    bb.StudsOffset = Vector3.new(0, 3.2, 0)
    bb.AlwaysOnTop = true
    bb.MaxDistance = 80
    bb.Parent = head
    local discordLabel = Instance.new("TextLabel", bb)
    discordLabel.Name = "DiscordLbl"
    discordLabel.Size = UDim2.new(1, 0, 0.38, 0)
    discordLabel.BackgroundTransparency = 1
    discordLabel.Text = "WUZZ DUELS"
    discordLabel.TextColor3 = gray
    discordLabel.Font = Enum.Font.GothamBold
    discordLabel.TextScaled = true
    discordLabel.TextStrokeTransparency = 0.4
    speedLabel = Instance.new("TextLabel", bb)
    speedLabel.Name = "SpeedLbl"
    speedLabel.Size = UDim2.new(1, 0, 0.55, 0)
    speedLabel.Position = UDim2.new(0, 0, 0.38, 0)
    speedLabel.BackgroundTransparency = 1
    speedLabel.Text = "0.0 SPEED"
    speedLabel.TextColor3 = accent
    speedLabel.Font = Enum.Font.GothamBold
    speedLabel.TextScaled = true
    speedLabel.TextStrokeTransparency = 0.35
    local gr1, gr2
    if type(addShimmerToLabel) == "function" then
        gr1 = addShimmerToLabel(speedLabel, accent2, accent)
        gr2 = addShimmerToLabel(discordLabel, gray, accent)
    end
    task.spawn(function()
        local t = 0
        while bb and bb.Parent do
            t = t + 0.03
            pcall(function()
                if gr1 then gr1.Offset = Vector2.new(math.sin(t) * 0.4, 0) end
                if gr2 then gr2.Offset = Vector2.new(math.sin(t) * 0.4, 0) end
            end)
            task.wait(0.05)
        end
    end)
end

_wuzzTrack(LP.CharacterAdded:Connect(function(char)
    task.wait(0.5)
    pcall(function() setupSpeedIndicator(char) end)
    pcall(function() setupRagdollTriggers() end)
    if medusaCounterEnabled and type(setupMedusa) == "function" then
        pcall(function() setupMedusa(char) end)
    end
    if batCounterEnabled and type(startBatCounter) == "function" then
        pcall(function() startBatCounter() end)
    end
    if unwalkEnabled and type(startUnwalk) == "function" then
        task.wait(0.5)
        pcall(function() startUnwalk() end)
    end
end))
if LP.Character then
    pcall(function() setupSpeedIndicator(LP.Character) end)
    pcall(function() setupRagdollTriggers() end)
end
alConn,arConn=nil,nil;alPhase,arPhase=1,1
stopAutoLeft=function()
    if alConn then alConn:Disconnect();alConn=nil end;alPhase=1
    local char=LP.Character;if char then local h=char:FindFirstChildOfClass("Humanoid");if h then h:Move(Vector3.zero,false) end end
    if autoLeftSetVisual then autoLeftSetVisual(false) end
    if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(false) end
end
stopAutoRight=function()
    if arConn then arConn:Disconnect();arConn=nil end;arPhase=1
    local char=LP.Character;if char then local h=char:FindFirstChildOfClass("Humanoid");if h then h:Move(Vector3.zero,false) end end
    if autoRightSetVisual then autoRightSetVisual(false) end
    if mobBtnRefs.autoRight then mobBtnRefs.autoRight(false) end
end
startAutoLeft=function()
    if alConn then alConn:Disconnect() end;alPhase=1
    alConn=_wuzzTrack(RunService.Heartbeat:Connect(function()
        if not autoLeftEnabled then return end
        local char=LP.Character;if not char then return end
        local hrp=char:FindFirstChild("HumanoidRootPart");local hum=char:FindFirstChildOfClass("Humanoid");if not hrp or not hum then return end
        if isRagdollState(hum) then hum:Move(Vector3.zero,false);return end
        local spd=getAutoPathSpeed()
        if alPhase==1 then
            local tgt=Vector3.new(AP_L1.X,hrp.Position.Y,AP_L1.Z)
            if (tgt-hrp.Position).Magnitude<1 then alPhase=2;local d=AP_L2-hrp.Position;local mv=Vector3.new(d.X,0,d.Z).Unit;hum:Move(mv,false);setSpeedConstraint(hrp, Vector3.new(mv.X*spd, 0, mv.Z*spd));return end
            local d=AP_L1-hrp.Position;local mv=Vector3.new(d.X,0,d.Z).Unit;hum:Move(mv,false);setSpeedConstraint(hrp, Vector3.new(mv.X*spd, 0, mv.Z*spd))
        elseif alPhase==2 then
            local tgt=Vector3.new(AP_L2.X,hrp.Position.Y,AP_L2.Z)
            if (tgt-hrp.Position).Magnitude<1 then hum:Move(Vector3.zero,false);clearSpeedConstraint();autoLeftEnabled=false;if alConn then alConn:Disconnect();alConn=nil end;alPhase=1;if autoLeftSetVisual then autoLeftSetVisual(false) end;if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(false) end;return end
            local d=AP_L2-hrp.Position;local mv=Vector3.new(d.X,0,d.Z).Unit;hum:Move(mv,false);setSpeedConstraint(hrp, Vector3.new(mv.X*spd, 0, mv.Z*spd))
        end
        if autoMoveSwingEnabled and not _alSwingDebounce then
            _alSwingDebounce=true
            local bat=findBat()
            if bat then
                if bat.Parent~=char then pcall(function() hum:EquipTool(bat) end) end
                pcall(function() bat:Activate() end)
            end
            task.delay(autoMoveSwingInterval,function() _alSwingDebounce=false end)
        end
    end))
end
startAutoRight=function()
    if arConn then arConn:Disconnect() end;arPhase=1
    arConn=_wuzzTrack(RunService.Heartbeat:Connect(function()
        if not autoRightEnabled then return end
        local char=LP.Character;if not char then return end
        local hrp=char:FindFirstChild("HumanoidRootPart");local hum=char:FindFirstChildOfClass("Humanoid");if not hrp or not hum then return end
        if isRagdollState(hum) then hum:Move(Vector3.zero,false);return end
        local spd=getAutoPathSpeed()
        if arPhase==1 then
            local tgt=Vector3.new(AP_R1.X,hrp.Position.Y,AP_R1.Z)
            if (tgt-hrp.Position).Magnitude<1 then arPhase=2;local d=AP_R2-hrp.Position;local mv=Vector3.new(d.X,0,d.Z).Unit;hum:Move(mv,false);setSpeedConstraint(hrp, Vector3.new(mv.X*spd, 0, mv.Z*spd));return end
            local d=AP_R1-hrp.Position;local mv=Vector3.new(d.X,0,d.Z).Unit;hum:Move(mv,false);setSpeedConstraint(hrp, Vector3.new(mv.X*spd, 0, mv.Z*spd))
        elseif arPhase==2 then
            local tgt=Vector3.new(AP_R2.X,hrp.Position.Y,AP_R2.Z)
            if (tgt-hrp.Position).Magnitude<1 then hum:Move(Vector3.zero,false);clearSpeedConstraint();autoRightEnabled=false;if arConn then arConn:Disconnect();arConn=nil end;arPhase=1;if autoRightSetVisual then autoRightSetVisual(false) end;if mobBtnRefs.autoRight then mobBtnRefs.autoRight(false) end;return end
            local d=AP_R2-hrp.Position;local mv=Vector3.new(d.X,0,d.Z).Unit;hum:Move(mv,false);setSpeedConstraint(hrp, Vector3.new(mv.X*spd, 0, mv.Z*spd))
        end
        if autoMoveSwingEnabled and not _arSwingDebounce then
            _arSwingDebounce=true
            local bat=findBat()
            if bat then
                if bat.Parent~=char then pcall(function() hum:EquipTool(bat) end) end
                pcall(function() bat:Activate() end)
            end
            task.delay(autoMoveSwingInterval,function() _arSwingDebounce=false end)
        end
    end))
end


ANTI_FLING_AIMBOT_LIN = 95
ANTI_FLING_AIMBOT_ANG = 20
function applyAimbotAntiFling(root)
    if not root or not root.Parent then return end
    pcall(function()
        local v = root.AssemblyLinearVelocity
        if v.Magnitude > ANTI_FLING_AIMBOT_LIN then
            root.AssemblyLinearVelocity = v.Unit * ANTI_FLING_AIMBOT_LIN
        end
        if root.AssemblyAngularVelocity.Magnitude > ANTI_FLING_AIMBOT_ANG then
            root.AssemblyAngularVelocity = Vector3.zero
        end
        local char = LP.Character
        if char then
            for _, p in ipairs(char:GetChildren()) do
                if p:IsA("BasePart") and p ~= root then
                    local pv = p.AssemblyLinearVelocity
                    if pv.Magnitude > ANTI_FLING_AIMBOT_LIN * 1.15 then
                        p.AssemblyLinearVelocity = pv.Unit * ANTI_FLING_AIMBOT_LIN
                    end
                    if p.AssemblyAngularVelocity.Magnitude > ANTI_FLING_AIMBOT_ANG then
                        p.AssemblyAngularVelocity = Vector3.zero
                    end
                end
            end
        end
    end)
end


_dropToken = 0
function armDrop()
    _dropToken = (_dropToken % 1000000) + 1
    return _dropToken
end
runDrop=function(expectedToken)
    
    if expectedToken == nil or expectedToken ~= _dropToken then
        return
    end
    _dropToken = 0 
    if dropActive then return end
    local char=LP.Character;if not char then return end
    local root=char:FindFirstChild("HumanoidRootPart");if not root then return end
    dropActive=true;local t0=tick();local dc
    dc=_wuzzTrack(RunService.Heartbeat:Connect(function()
        local r=char and char:FindFirstChild("HumanoidRootPart")
        if not r then dc:Disconnect();dropActive=false;return end
        if tick()-t0>=DROP_ASCEND_DURATION then
            dc:Disconnect()
            local rp=RaycastParams.new();rp.FilterDescendantsInstances={char};rp.FilterType=Enum.RaycastFilterType.Exclude
            local rr=workspace:Raycast(r.Position,Vector3.new(0,-2000,0),rp)
            if rr then local hum2=char:FindFirstChildOfClass("Humanoid");local off=(hum2 and hum2.HipHeight or 2);r.CFrame=CFrame.new(r.Position.X,rr.Position.Y+off,r.Position.Z);applyVel(r, Vector3.zero) end
            dropActive=false;return end
        applyVel(r, Vector3.new(r.AssemblyLinearVelocity.X,DROP_ASCEND_SPEED,r.AssemblyLinearVelocity.Z))
    end))
end
autoTPPaused = false  
function doAutoTPDown(force)
    local char=LP.Character;if not char then return end;local hrp=char:FindFirstChild("HumanoidRootPart");if not hrp then return end
    local hum2=char:FindFirstChildOfClass("Humanoid");if not hum2 then return end
    if not force then if hum2.FloorMaterial~=Enum.Material.Air then return end;if not(hrp.Position.Y>=autoTPHeight) then return end end
    
    local yaw=select(2,hrp.CFrame:ToEulerAnglesYXZ())
    hrp.CFrame=CFrame.new(hrp.Position.X,-7.00,hrp.Position.Z)*CFrame.Angles(0,yaw,0)
    pcall(function() applyVel(hrp, Vector3.zero) end)
    pcall(function() hrp.AssemblyLinearVelocity=Vector3.zero end)
    pcall(function() hrp.Velocity=Vector3.zero end)
end
function pauseAutoTP()
    autoTPPaused = true
end
function resumeAutoTP()
    autoTPPaused = false
end
startAutoTP=function()
    if autoTPConn then task.cancel(autoTPConn);autoTPConn=nil end
    autoTPConn=task.spawn(function()
        while autoTPEnabled do
            task.wait(0.1)
            if not autoTPPaused then
                pcall(function() doAutoTPDown(false) end)
            end
        end
    end)
end
stopAutoTP=function() autoTPEnabled=false;autoTPPaused=false;if autoTPConn then task.cancel(autoTPConn);autoTPConn=nil end end
runTPFloor=function() pcall(function() doAutoTPDown(true) end) end




function mirrorTPAimbotActive()
    return autoBatEnabled == true or tpBatEnabled == true or batAimbotEnabled == true
end

function mirrorTPTeleportDown()
    local char = LP.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local humanoid = char and char:FindFirstChildOfClass("Humanoid")
    if not root or not humanoid or humanoid.Health <= 0 then return end
    local now = tick()
    if now - (mirrorTPLastTeleport or 0) < 0.08 then return end
    mirrorTPLastTeleport = now
    local _, yaw = root.CFrame:ToEulerAnglesYXZ()
    local y = (MIRROR_TP_DOWN_Y or -7) + (math.random() * 0.6 - 0.3)
    root.CFrame = CFrame.new(root.Position.X, y, root.Position.Z) * CFrame.Angles(0, yaw, 0)
    pcall(function()
        root.AssemblyLinearVelocity = Vector3.new((math.random()-0.5)*0.4, 0, (math.random()-0.5)*0.4)
    end)
    pcall(function() applyVel(root, Vector3.new((math.random()-0.5)*0.4, 0, (math.random()-0.5)*0.4)) end)
end

do
    local flagName = "_ExeMirrorTPStarted"
    if not _G[flagName] then
        _G[flagName] = true
        _wuzzTrack(RunService.Heartbeat:Connect(function()
            if not mirrorTPDownEnabled or not mirrorTPAimbotActive() then
                if next(mirrorTPPreviousY) then
                    table.clear(mirrorTPPreviousY)
                end
                return
            end
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LP and plr.Character then
                    local root = plr.Character:FindFirstChild("HumanoidRootPart")
                    if root then
                        local currentY = root.Position.Y
                        local previousY = mirrorTPPreviousY[plr.UserId]
                        if previousY and previousY - currentY >= (MIRROR_TP_DROP_THRESHOLD or 3) then
                            pcall(mirrorTPTeleportDown)
                            table.clear(mirrorTPPreviousY)
                            return
                        end
                        mirrorTPPreviousY[plr.UserId] = currentY
                    end
                end
            end
        end))
    end
end

function setMirrorTPDown(enabled)
    mirrorTPDownEnabled = enabled == true
    if not mirrorTPDownEnabled then
        table.clear(mirrorTPPreviousY)
    end
    if setMirrorTPVisual then setMirrorTPVisual(mirrorTPDownEnabled) end
end
defLightBrightness,defLightClock,defLightAmbient=nil,nil,nil
function applyAntiLagDerender(obj)
    pcall(function()
        if obj:IsA("Accessory") or obj:IsA("Hat") then obj:Destroy()
        elseif obj:IsA("BasePart") then obj.Material=Enum.Material.Plastic;obj.Reflectance=0;obj.CastShadow=false
        elseif obj:IsA("Decal") or obj:IsA("Texture") then obj.Transparency=1
        elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") or obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") then obj.Enabled=false end
    end)
end
enableAntiLag=function()
    removeAccessoriesEnabled=true;antiLagEnabled=true
    defLightBrightness=defLightBrightness or Lighting.Brightness;defLightClock=defLightClock or Lighting.ClockTime;defLightAmbient=defLightAmbient or Lighting.OutdoorAmbient
    Lighting.GlobalShadows=false;Lighting.FogEnd=1e10;Lighting.Brightness=1;Lighting.EnvironmentDiffuseScale=0;Lighting.EnvironmentSpecularScale=0
    for _,e in pairs(Lighting:GetChildren()) do pcall(function() if e:IsA("BlurEffect") or e:IsA("SunRaysEffect") or e:IsA("ColorCorrectionEffect") or e:IsA("BloomEffect") or e:IsA("DepthOfFieldEffect") then e.Enabled=false end end) end
    for _,obj in ipairs(workspace:GetDescendants()) do applyAntiLagDerender(obj) end
    if antiLagDescConn then antiLagDescConn:Disconnect() end
    antiLagDescConn=_wuzzTrack(workspace.DescendantAdded:Connect(function(obj) if removeAccessoriesEnabled then applyAntiLagDerender(obj) end end))
end
disableAntiLag=function()
    removeAccessoriesEnabled=false;antiLagEnabled=false;if antiLagDescConn then antiLagDescConn:Disconnect();antiLagDescConn=nil end
    pcall(function() if defLightBrightness then Lighting.Brightness=defLightBrightness end;if defLightClock then Lighting.ClockTime=defLightClock end;if defLightAmbient then Lighting.OutdoorAmbient=defLightAmbient end;Lighting.ExposureCompensation=0 end)
end
function findMedusa()
    local c=LP.Character;if not c then return nil end
    for _,t in ipairs(c:GetChildren()) do if t:IsA("Tool") then local n=t.Name:lower();if n:find("medusa") or n:find("head") or n:find("stone") then return t end end end
    local bp=LP:FindFirstChild("Backpack");if bp then for _,t in ipairs(bp:GetChildren()) do if t:IsA("Tool") then local n=t.Name:lower();if n:find("medusa") or n:find("head") or n:find("stone") then return t end end end end
    return nil
end
function useMedusaCounter()
    if medusaDebounce then return end;if MEDUSA_COOLDOWN>(tick()-medusaLastUsed) then return end
    local c=LP.Character;if not c then return end;medusaDebounce=true
    local med=findMedusa();if not med then medusaDebounce=false;return end
    if med.Parent~=c then local hum2=c:FindFirstChildOfClass("Humanoid");if hum2 then hum2:EquipTool(med) end end
    pcall(function() med:Activate() end);medusaLastUsed=tick();medusaDebounce=false
end
function onAnchorChanged(part)
    return _wuzzTrack(part:GetPropertyChangedSignal("Anchored"):Connect(function()
                if part.Anchored and part.Transparency == 1 then
            if medusaCounterEnabled then
                useMedusaCounter()
            end
        end
    end))
end
setupMedusa=function(char)
    for _,c in pairs(Conns.anchor) do pcall(function() c:Disconnect() end) end;Conns.anchor={}
    if not char then return end
    for _,part in ipairs(char:GetDescendants()) do if part:IsA("BasePart") then table.insert(Conns.anchor,onAnchorChanged(part)) end end
    table.insert(Conns.anchor,_wuzzTrack(char.DescendantAdded:Connect(function(part) if part:IsA("BasePart") then table.insert(Conns.anchor,onAnchorChanged(part)) end end)))
end
stopMedusaCounter=function() for _,c in pairs(Conns.anchor) do pcall(function() c:Disconnect() end) end;Conns.anchor={} end
BAT_COUNTER_SLAP_LIST={"Bat","Slap","Iron Slap","Gold Slap","Diamond Slap","Emerald Slap","Ruby Slap","Dark Matter Slap","Flame Slap","Nuclear Slap","Galaxy Slap","Glitched Slap"}
function findBatForCounter()
    local c=LP.Character;if not c then return nil end;local bp=LP:FindFirstChildOfClass("Backpack")
    for _,name in ipairs(BAT_COUNTER_SLAP_LIST) do local t=c:FindFirstChild(name) or (bp and bp:FindFirstChild(name));if t then return t end end
    for _,ch in ipairs(c:GetChildren()) do if ch:IsA("Tool") and ch.Name:lower():find("bat") then return ch end end
    if bp then for _,ch in ipairs(bp:GetChildren()) do if ch:IsA("Tool") and ch.Name:lower():find("bat") then return ch end end end
    return nil
end
function swingBatForCounter(bat,char)
    local hum2=char:FindFirstChildOfClass("Humanoid")
    if bat.Parent~=char then if hum2 then pcall(function() hum2:EquipTool(bat) end) end;task.wait(0.05) end
    local remote=bat:FindFirstChildOfClass("RemoteEvent") or bat:FindFirstChildOfClass("RemoteFunction")
    if remote and remote:IsA("RemoteEvent") then pcall(function() remote:FireServer() end);task.wait(0.15);pcall(function() remote:FireServer() end)
    else pcall(function() bat:Activate() end);task.wait(0.15);pcall(function() bat:Activate() end) end
end
startBatCounter=function()
    if Conns.batCounter then return end
    Conns.batCounter=_wuzzTrack(RunService.Heartbeat:Connect(function()
        if not batCounterEnabled or batCounterDebounce then return end
        local char=LP.Character;if not char then return end;local hum2=char:FindFirstChildOfClass("Humanoid");if not hum2 then return end
        local st=hum2:GetState()
        if st==Enum.HumanoidStateType.Physics or st==Enum.HumanoidStateType.Ragdoll then
            batCounterDebounce=true;task.spawn(function() local bat=findBatForCounter();if bat then swingBatForCounter(bat,char) end;task.wait(0.5);batCounterDebounce=false end)
        end
    end))
end
stopBatCounter=function() if Conns.batCounter then Conns.batCounter:Disconnect();Conns.batCounter=nil end;batCounterDebounce=false end
aimbotConn=nil
tpBatConn=nil
aimbotV2Conn=nil




function findBat()
    local char = LP.Character
    if not char then return nil end
    for _, tool in ipairs(char:GetChildren()) do
        if tool:IsA("Tool") and (tool.Name:lower():find("bat") or tool.Name:lower():find("slap")) then
            return tool
        end
    end
    local bp = LP:FindFirstChild("Backpack")
    if bp then
        for _, tool in ipairs(bp:GetChildren()) do
            if tool:IsA("Tool") and (tool.Name:lower():find("bat") or tool.Name:lower():find("slap")) then
                return tool
            end
        end
    end
    return nil
end

aimbotSpeed = 58
_aimbotTarget = nil
_aimbotTargetPlr = nil

function getClosestTarget()
    local root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if not root then return nil, nil, math.huge end
    local closest, closestPlr, minDist = nil, nil, math.huge
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP and plr.Character then
            local tRoot = plr.Character:FindFirstChild("HumanoidRootPart")
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            if tRoot and hum and hum.Health > 0 then
                local dist = (tRoot.Position - root.Position).Magnitude
                if dist < minDist then
                    minDist = dist
                    closest = tRoot
                    closestPlr = plr
                end
            end
        end
    end
    return closest, closestPlr, minDist
end

function getStickyTarget(currentRoot)
    local root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if not root then return nil, nil end
    local newClosest, newPlr, newDist = getClosestTarget()
    if not newClosest then return nil, nil end
    if currentRoot and currentRoot.Parent then
        local currentPlr = Players:GetPlayerFromCharacter(currentRoot.Parent)
        local hum = currentRoot.Parent:FindFirstChildOfClass("Humanoid")
        if currentPlr and hum and hum.Health > 0 then
            local currentDist = (currentRoot.Position - root.Position).Magnitude
            if currentPlr == newPlr or newDist > currentDist * 0.7 then
                return currentRoot, currentPlr
            end
        end
    end
    return newClosest, newPlr
end

function swingCurrentBat(char)
    if not autoSwingEnabled then return end
    char = char or LP.Character
    if not char then return end
    local bat = findBat()
    if bat and bat.Parent == char and bat:IsA("Tool") then
        pcall(function() bat:Activate() end)
    end
end


do
    task.spawn(function()
        task.wait(1.5)
        local sg = Instance.new("ScreenGui")
        sg.Name = "ExeVisionAimbotTarget"
        sg.ResetOnSpawn = false
        sg.DisplayOrder = 40
        sg.IgnoreGuiInset = true
        pcall(function()
            if parentGui then parentGui(sg) else
                local ok = pcall(function() sg.Parent = game:GetService("CoreGui") end)
                if not ok then sg.Parent = LP:WaitForChild("PlayerGui") end
            end
        end)
        local th = (type(getTheme) == "function" and getTheme()) or {}
        local bg = th.BG or Color3.fromRGB(8, 8, 10)
        local accent = th.ACCENT or Color3.fromRGB(255, 255, 255)
        local accent2 = th.ACCENT2 or Color3.fromRGB(210, 210, 215)
        local white = th.WHITE or Color3.fromRGB(235, 235, 240)

        local f = Instance.new("Frame", sg)
        f.Size = UDim2.new(0, 200, 0, 36)
        f.Position = UDim2.new(0.5, -100, 0, 80)
        f.BackgroundColor3 = bg
        f.BackgroundTransparency = 0.12
        f.BorderSizePixel = 0
        f.Visible = false
        Instance.new("UICorner", f).CornerRadius = UDim.new(0, 8)
        local st = Instance.new("UIStroke", f)
        st.Color = accent
        st.Thickness = 1
        st.Transparency = 0.2
        local stGrad = Instance.new("UIGradient", st)
        stGrad.Color = ColorSequence.new(accent, accent2)
        stGrad.Rotation = 0
        local lockTxt = Instance.new("TextLabel", f)
        lockTxt.Size = UDim2.new(0, 60, 1, 0)
        lockTxt.Position = UDim2.new(0, 10, 0, 0)
        lockTxt.BackgroundTransparency = 1
        lockTxt.Text = "LOCKED"
        lockTxt.TextColor3 = accent
        lockTxt.Font = Enum.Font.GothamBlack
        lockTxt.TextSize = 11
        lockTxt.TextXAlignment = Enum.TextXAlignment.Left
        local targetLabel = Instance.new("TextLabel", f)
        targetLabel.Size = UDim2.new(1, -76, 1, 0)
        targetLabel.Position = UDim2.new(0, 70, 0, 0)
        targetLabel.BackgroundTransparency = 1
        targetLabel.Text = ""
        targetLabel.TextColor3 = white
        targetLabel.Font = Enum.Font.GothamBlack
        targetLabel.TextSize = 12
        targetLabel.TextXAlignment = Enum.TextXAlignment.Left
        targetLabel.TextTruncate = Enum.TextTruncate.AtEnd
        local labelGrad = Instance.new("UIGradient", targetLabel)
        labelGrad.Color = ColorSequence.new(accent, accent2)
        labelGrad.Rotation = 0
        local rot = 0
        _wuzzTrack(RunService.Heartbeat:Connect(function(dt)
            rot = (rot + (dt or 0.016) * 35) % 360
            stGrad.Rotation = rot
            
            local th2 = (type(getTheme) == "function" and getTheme()) or th
            local a = th2.ACCENT or accent
            lockTxt.TextColor3 = a
            st.Color = a
            if autoBatEnabled and _aimbotTargetPlr and _aimbotTargetPlr.Parent then
                local name = _aimbotTargetPlr.DisplayName or _aimbotTargetPlr.Name or "?"
                if targetLabel.Text ~= name then targetLabel.Text = name end
                if not f.Visible then f.Visible = true end
            else
                if f.Visible then f.Visible = false end
            end
        end))
    end)
end



BAT_TOOL_NAMES = {"Bat","Slap","Iron Slap","Gold Slap","Diamond Slap","Emerald Slap","Ruby Slap","Dark Matter Slap","Flame Slap","Nuclear Slap","Galaxy Slap","Glitched Slap"}
function ensureBatEquipped()
    local char = LP.Character
    if not char then return nil end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local function isBatTool(tool)
        if not tool or not tool:IsA("Tool") then return false end
        local n = tostring(tool.Name):lower()
        if n:find("bat", 1, true) or n:find("slap", 1, true) or n:find("glove", 1, true) then return true end
        for _, name in ipairs(BAT_TOOL_NAMES) do
            if tool.Name == name then return true end
        end
        return false
    end
    
    for _, ch in ipairs(char:GetChildren()) do
        if isBatTool(ch) then return ch end
    end
    
    local bp = LP:FindFirstChildOfClass("Backpack") or LP:FindFirstChild("Backpack")
    if bp and hum then
        for _, name in ipairs(BAT_TOOL_NAMES) do
            local t = bp:FindFirstChild(name)
            if t and t:IsA("Tool") then
                pcall(function() hum:EquipTool(t) end)
                return t
            end
        end
        for _, t in ipairs(bp:GetChildren()) do
            if isBatTool(t) then
                pcall(function() hum:EquipTool(t) end)
                return t
            end
        end
    end
    return nil
end


AceAntiBypassAimbot = {conn = nil, swingCooldown = false, prevAutoRotate = nil}
AceNormalAimbot = {conn = nil, target = nil, swingCooldown = false}

batAimbotEnabled = false
antiBatBypassLockEnabled = false
antiDesyncAimbotEnabled = false

AIMBOT_SPEED = 58
LAGGER_AIMBOT_SPEED = 40
AceAntiBypassAimbotSpeed = 58
AceAntiBypassLaggerAimbotSpeed = 40
ANTI_DESYNC_AIMBOT_SPEED = 58

AceAntiBypassSlapList = {"Bat","Slap","Iron Slap","Gold Slap","Diamond Slap","Emerald Slap","Ruby Slap","Dark Matter Slap","Flame Slap","Nuclear Slap","Galaxy Slap","Glitched Slap"}

setBatAimbotVisual = setBatAimbotVisual
setAntiBatBypassLockVisual = setAntiBatBypassLockVisual


function GetCurrentSpeedMode()
    if laggerCarryActive or laggerModeEnabled then return "Lagger"
    elseif carrySpeedActive then return "Carry"
    else return "Normal" end
end

function GetBatAimbotSpeed()
    local mode = GetCurrentSpeedMode()
    if mode == "Lagger" then return tonumber(LAGGER_AIMBOT_SPEED) or 40
    else return tonumber(AIMBOT_SPEED) or 58 end
end

function GetAntiBypassAimbotSpeed()
    local mode = GetCurrentSpeedMode()
    if mode == "Lagger" then return tonumber(AceAntiBypassLaggerAimbotSpeed) or 40
    else return tonumber(AceAntiBypassAimbotSpeed) or 58 end
end

function FindAimbotBat()
    return ensureBatEquipped()
end

function GetClosestAimbotTarget()
    local root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    local closest, minDist = nil, math.huge
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP and plr.Character then
            local tRoot = plr.Character:FindFirstChild("HumanoidRootPart")
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            if tRoot and hum and hum.Health > 0 then
                local dist = (tRoot.Position - root.Position).Magnitude
                if dist < minDist then minDist = dist; closest = tRoot end
            end
        end
    end
    return closest
end

function AntiBypassGetClosest()
    local root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if not root then return nil, math.huge end
    local closest, minDist = nil, math.huge
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP and plr.Character then
            local tRoot = plr.Character:FindFirstChild("HumanoidRootPart")
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            if tRoot and hum and hum.Health > 0 then
                local dist = (tRoot.Position - root.Position).Magnitude
                if dist < minDist then minDist = dist; closest = tRoot end
            end
        end
    end
    return closest, minDist
end

function AntiBypassFindBat()
    return ensureBatEquipped()
end

function AntiBypassTrySwing()
    if AceAntiBypassAimbot.swingCooldown then return end
    AceAntiBypassAimbot.swingCooldown = true
    pcall(function()
        local char = LP.Character
        if not char then return end
        local bat = AntiBypassFindBat()
        if bat then
            if bat.Parent ~= char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then pcall(function() hum:EquipTool(bat) end) end
            end
            pcall(function() bat:Activate() end)
        end
    end)
    task.delay(0.03, function()
        AceAntiBypassAimbot.swingCooldown = false
    end)
end


function StartBatAimbot()
    
    if antiBatBypassLockEnabled then StopAntiBatBypassLock() end
    if AceNormalAimbot.conn then AceNormalAimbot.conn:Disconnect(); AceNormalAimbot.conn = nil end
    batAimbotEnabled = true
    autoBatEnabled = true
    local hum0 = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    if hum0 then hum0.AutoRotate = false end
    pcall(function() if pauseAutoTP then pauseAutoTP() end end)
    pcall(ensureBatEquipped)

    
    AceNormalAimbot.conn = _wuzzTrack(RunService.RenderStepped:Connect(function()
        if not batAimbotEnabled then return end

        local char = LP.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not root or not hum then return end

        local bat = ensureBatEquipped() or FindAimbotBat()
        if bat and bat.Parent ~= char then
            pcall(function() hum:EquipTool(bat) end)
        end

        local target = GetClosestAimbotTarget()
        if not target then
            AceNormalAimbot.target = nil
            if autoSwingEnabled and bat then
                pcall(function() bat:Activate() end)
            end
            return
        end
        AceNormalAimbot.target = target

        local targetVel = target.AssemblyLinearVelocity
        pcall(function()
            if (not targetVel or targetVel.Magnitude < 0.01) and target.Velocity then
                targetVel = target.Velocity
            end
        end)
        if typeof(targetVel) ~= "Vector3" then targetVel = Vector3.zero end

        local myPos = root.Position
        local targetPos = target.Position
        local predictPos = targetPos + targetVel * 0.14 + target.CFrame.LookVector * 0.3
        local direction = predictPos - myPos
        local flat = Vector3.new(direction.X, 0, direction.Z)
        local flatDir = (flat.Magnitude > 0.01) and flat.Unit or Vector3.zero

        local chaseSpeed = (type(GetBatAimbotSpeed)=="function" and GetBatAimbotSpeed()) or 58
        local desiredHeight = targetPos.Y + 3.7
        local yVel = (desiredHeight - myPos.Y) * 19.5 + targetVel.Y * 0.8
        if hum.FloorMaterial ~= Enum.Material.Air then
            yVel = math.max(yVel, 13)
        end
        yVel = math.clamp(yVel, -70, 110)

        local desiredVel = Vector3.new(flatDir.X * chaseSpeed, yVel, flatDir.Z * chaseSpeed)
        root.AssemblyLinearVelocity = root.AssemblyLinearVelocity:Lerp(desiredVel, 0.8)
        pcall(function() root.Velocity = root.AssemblyLinearVelocity end)

        local speed3 = targetVel.Magnitude
        local predictTime = math.clamp(speed3 / 150, 0.05, 0.2)
        local predictedPos = targetPos + targetVel * predictTime
        local toPredict = predictedPos - myPos
        if toPredict.Magnitude > 0.1 then
            local goalCF = CFrame.lookAt(myPos, predictedPos)
            local diffCF = root.CFrame:Inverse() * goalCF
            local rx, ry, rz = diffCF:ToEulerAnglesXYZ()
            rx = math.clamp(rx, -2.5, 2.5)
            ry = math.clamp(ry, -2.5, 2.5)
            rz = math.clamp(rz, -2.5, 2.5)
            root.AssemblyAngularVelocity = root.CFrame:VectorToWorldSpace(Vector3.new(rx * 42, ry * 42, rz * 42))
        end

        if autoSwingEnabled and bat then
            pcall(function() bat:Activate() end)
        end
    end))
    if setBatAimbotVisual then setBatAimbotVisual(true) end
    if autoBatSetVisual then autoBatSetVisual(true) end
    if mobBtnRefs and mobBtnRefs.autoBat then mobBtnRefs.autoBat(true) end
end

function StopBatAimbot()
    batAimbotEnabled = false
    autoBatEnabled = false
    if AceNormalAimbot and AceNormalAimbot.conn then
        AceNormalAimbot.conn:Disconnect(); AceNormalAimbot.conn = nil
    end
    if AceNormalAimbot then AceNormalAimbot.target = nil; AceNormalAimbot.swingCooldown = false end
    local c = LP.Character
    local root = c and c:FindFirstChild("HumanoidRootPart")
    if root then root.AssemblyLinearVelocity = Vector3.zero; root.AssemblyAngularVelocity = Vector3.zero end
    local hum2 = c and c:FindFirstChildOfClass("Humanoid")
    if hum2 then hum2.AutoRotate = true end
    pcall(function() if not tpBatEnabled and resumeAutoTP then resumeAutoTP() end end)
    if setBatAimbotVisual then setBatAimbotVisual(false) end
    if autoBatSetVisual then autoBatSetVisual(false) end
    if mobBtnRefs and mobBtnRefs.autoBat then mobBtnRefs.autoBat(false) end
end


function StartAntiBatBypassLock()
    if batAimbotEnabled then StopBatAimbot() end
    if antiBatBypassLockEnabled then
        if AceAntiBypassAimbot.conn then AceAntiBypassAimbot.conn:Disconnect(); AceAntiBypassAimbot.conn = nil end
    end
    antiBatBypassLockEnabled = true
    autoBatEnabled = true
    if AceAntiBypassAimbot.conn then AceAntiBypassAimbot.conn:Disconnect(); AceAntiBypassAimbot.conn = nil end
    local hum0 = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    if hum0 then
        AceAntiBypassAimbot.prevAutoRotate = hum0.AutoRotate
        hum0.AutoRotate = false
    end
    pcall(function() if pauseAutoTP then pauseAutoTP() end end)
    pcall(ensureBatEquipped)

    local bypassTick = 0
    AceAntiBypassAimbot.conn = _wuzzTrack(RunService.Heartbeat:Connect(function()
        if not antiBatBypassLockEnabled then return end
        bypassTick = bypassTick + 1
        if bypassTick % 8 == 0 then return end

        local char = LP.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum then return end
        local bat = ensureBatEquipped() or AntiBypassFindBat()
        if bat and bat.Parent ~= char then pcall(function() hum:EquipTool(bat) end) end
        local target, targetDist = AntiBypassGetClosest()
        if not target then return end
        local myPos = root.Position
        local targetPos = target.Position
        local direction = targetPos - myPos
        local flatDir = Vector3.new(direction.X, 0, direction.Z)
        if flatDir.Magnitude > 0 then flatDir = flatDir.Unit else flatDir = Vector3.zero end
        local chaseSpeed = GetAntiBypassAimbotSpeed()
        local desiredHeight = targetPos.Y + 3.7
        local yVel = (desiredHeight - myPos.Y) * 19.5
        if hum.FloorMaterial ~= Enum.Material.Air then yVel = math.max(yVel, 13) end
        yVel = math.clamp(yVel, -70, 110)
        local desiredVel = Vector3.new(flatDir.X * chaseSpeed, yVel, flatDir.Z * chaseSpeed)
        root.AssemblyLinearVelocity = root.AssemblyLinearVelocity:Lerp(desiredVel, 0.8)
        local toTarget = targetPos - myPos
        if toTarget.Magnitude > 0.1 then
            local goalCF = CFrame.lookAt(myPos, targetPos)
            local diffCF = root.CFrame:Inverse() * goalCF
            local rx, ry, rz = diffCF:ToEulerAnglesXYZ()
            rx = math.clamp(rx, -2.5, 2.5); ry = math.clamp(ry, -2.5, 2.5); rz = math.clamp(rz, -2.5, 2.5)
            root.AssemblyAngularVelocity = root.CFrame:VectorToWorldSpace(Vector3.new(rx * 42, ry * 42, rz * 42))
        end
        if autoSwingEnabled and targetDist <= 8 then AntiBypassTrySwing() end
    end))
    if setAntiBatBypassLockVisual then setAntiBatBypassLockVisual(true) end
    if autoBatSetVisual then autoBatSetVisual(true) end
    if mobBtnRefs and mobBtnRefs.autoBat then mobBtnRefs.autoBat(true) end
end

function StopAntiBatBypassLock()
    antiBatBypassLockEnabled = false
    autoBatEnabled = false
    if AceAntiBypassAimbot and AceAntiBypassAimbot.conn then
        AceAntiBypassAimbot.conn:Disconnect(); AceAntiBypassAimbot.conn = nil
    end
    if AceAntiBypassAimbot then AceAntiBypassAimbot.swingCooldown = false end
    local c = LP.Character
    local root = c and c:FindFirstChild("HumanoidRootPart")
    if root then root.AssemblyLinearVelocity = Vector3.zero; root.AssemblyAngularVelocity = Vector3.zero end
    local hum = c and c:FindFirstChildOfClass("Humanoid")
    if hum then hum.AutoRotate = (AceAntiBypassAimbot.prevAutoRotate == nil) and true or AceAntiBypassAimbot.prevAutoRotate end
    AceAntiBypassAimbot.prevAutoRotate = nil
    pcall(function() if not tpBatEnabled and resumeAutoTP then resumeAutoTP() end end)
    if setAntiBatBypassLockVisual then setAntiBatBypassLockVisual(false) end
    if autoBatSetVisual then autoBatSetVisual(false) end
    if mobBtnRefs and mobBtnRefs.autoBat then mobBtnRefs.autoBat(false) end
end



startBatAimbot = StartBatAimbot
stopBatAimbot = function()
    StopBatAimbot()
    StopAntiBatBypassLock()
end
queueAutoBatStart = function()
    if antiKickEnabled and brainrotDetected then return end
    if autoLeftEnabled then autoLeftEnabled=false; if autoLeftSetVisual then autoLeftSetVisual(false) end; stopAutoLeft() end
    if autoRightEnabled then autoRightEnabled=false; if autoRightSetVisual then autoRightSetVisual(false) end; stopAutoRight() end
    
    if aimbotMode == "bypass" then
        if batAimbotEnabled then StopBatAimbot() end
        StartAntiBatBypassLock()
    else
        if antiBatBypassLockEnabled then StopAntiBatBypassLock() end
        StartBatAimbot()
    end
end

resetAutoBatMotion=function()
    local char=LP.Character;local hrp=char and char:FindFirstChild("HumanoidRootPart");local hum=char and char:FindFirstChildOfClass("Humanoid")
    if hrp then applyVel(hrp, hrp.AssemblyLinearVelocity*0.3);applyAngVel(hrp, Vector3.zero) end
    if hum then hum.AutoRotate=true end
end


_predBall = nil
function cleanupPredBall()
    if _predBall then
        pcall(function() _predBall:Destroy() end)
        _predBall = nil
    end
end
function ensurePredBall(pos)
    pcall(function()
        if not _predBall or not _predBall.Parent then
            _predBall = Instance.new("Part")
            _predBall.Name = "ExePredBall"
            _predBall.Size = Vector3.new(0.6, 0.6, 0.6)
            _predBall.Shape = Enum.PartType.Ball
            _predBall.Material = Enum.Material.Neon
            _predBall.CanCollide = false
            _predBall.Anchored = true
            _predBall.CastShadow = false
            _predBall.Parent = workspace
        end
        local accent = (getTheme and getTheme() and getTheme().ACCENT) or Color3.fromRGB(255, 255, 255)
        _predBall.Color = accent
        _predBall.CFrame = CFrame.new(pos)
        _predBall.Transparency = 0.15
    end)
end




_tpGodConns = {}
function _tpGodDisable()
    for _, c in ipairs(_tpGodConns) do
        pcall(function() c:Disconnect() end)
    end
    for i = #_tpGodConns, 1, -1 do _tpGodConns[i] = nil end
    pcall(function()
        local char = LP.Character
        if char then
            local ff = char:FindFirstChild("ExeTPBatFF")
            if ff then ff:Destroy() end
            
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                hum.BreakJointsOnDeath = true
                hum.RequiresNeck = true
                pcall(function()
                    hum:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
                    hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
                    hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
                    hum:SetStateEnabled(Enum.HumanoidStateType.Physics, true)
                end)
            end
        end
    end)
end
function _tpGodBindCharacter(char)
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid") or char:WaitForChild("Humanoid", 3)
    if not hum then return end
    local root = char:FindFirstChild("HumanoidRootPart")

    pcall(function()
        local oldFF = char:FindFirstChild("ExeTPBatFF")
        if oldFF then oldFF:Destroy() end
        local ff = Instance.new("ForceField")
        ff.Name = "ExeTPBatFF"
        ff.Visible = false
        ff.Parent = char
    end)

    pcall(function()
        hum.BreakJointsOnDeath = false
        hum.RequiresNeck = false
        hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
        hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
        hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
        hum:SetStateEnabled(Enum.HumanoidStateType.Physics, false)
        hum.Health = math.max(hum.Health, hum.MaxHealth)
        hum.MaxHealth = math.max(hum.MaxHealth, 100)
    end)

    local function forceAlive()
        if not tpBatEnabled then return end
        if not hum or not hum.Parent then return end
        pcall(function()
            hum.MaxHealth = math.max(hum.MaxHealth, 100)
            if hum.Health < hum.MaxHealth then hum.Health = hum.MaxHealth end
            hum.BreakJointsOnDeath = false
            hum.RequiresNeck = false
            hum.PlatformStand = false
            hum.Sit = false
            pcall(function()
                hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
                hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
                hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
                hum:SetStateEnabled(Enum.HumanoidStateType.Physics, false)
            end)
            local st = hum:GetState()
            if st == Enum.HumanoidStateType.Dead
                or st == Enum.HumanoidStateType.Physics
                or st == Enum.HumanoidStateType.Ragdoll
                or st == Enum.HumanoidStateType.FallingDown then
                hum:ChangeState(Enum.HumanoidStateType.Running)
            end
            if root and root.Parent then
                local v = root.AssemblyLinearVelocity
                if v.Magnitude > 120 then
                    root.AssemblyLinearVelocity = v.Unit * 120
                end
                if root.AssemblyAngularVelocity.Magnitude > 20 then
                    root.AssemblyAngularVelocity = Vector3.zero
                end
            end
            if char and char.Parent and not char:FindFirstChild("ExeTPBatFF") then
                local ff = Instance.new("ForceField")
                ff.Name = "ExeTPBatFF"
                ff.Visible = false
                ff.Parent = char
            end
        end)
    end

    table.insert(_tpGodConns, _wuzzTrack(hum.HealthChanged:Connect(forceAlive)))
    table.insert(_tpGodConns, _wuzzTrack(hum:GetPropertyChangedSignal("Health"):Connect(forceAlive)))
    table.insert(_tpGodConns, _wuzzTrack(hum.Died:Connect(function()
        if not tpBatEnabled then return end
        pcall(function()
            hum.Health = hum.MaxHealth
            hum:ChangeState(Enum.HumanoidStateType.GettingUp)
            hum:ChangeState(Enum.HumanoidStateType.Running)
            hum.PlatformStand = false
            if char and char.Parent and not char:FindFirstChild("ExeTPBatFF") then
                local ff = Instance.new("ForceField")
                ff.Name = "ExeTPBatFF"
                ff.Visible = false
                ff.Parent = char
            end
        end)
    end)))
    table.insert(_tpGodConns, _wuzzTrack(hum.StateChanged:Connect(function(_, new)
        if not tpBatEnabled then return end
        if new == Enum.HumanoidStateType.Dead
            or new == Enum.HumanoidStateType.Physics
            or new == Enum.HumanoidStateType.Ragdoll
            or new == Enum.HumanoidStateType.FallingDown then
            pcall(function()
                hum.Health = hum.MaxHealth
                hum:ChangeState(Enum.HumanoidStateType.Running)
            end)
        end
    end)))
    table.insert(_tpGodConns, _wuzzTrack(RunService.RenderStepped:Connect(forceAlive)))
    table.insert(_tpGodConns, _wuzzTrack(RunService.Stepped:Connect(forceAlive)))
    table.insert(_tpGodConns, _wuzzTrack(RunService.Heartbeat:Connect(forceAlive)))
end
function _tpGodEnable()
    _tpGodDisable()
    _tpGodBindCharacter(LP.Character)
    table.insert(_tpGodConns, _wuzzTrack(LP.CharacterAdded:Connect(function(c)
        if not tpBatEnabled then return end
        task.wait(0.05)
        _tpGodBindCharacter(c)
    end)))
end


startTPBat=function()
    
    if tpBatConn then pcall(function() tpBatConn:Disconnect() end); tpBatConn=nil end
    tpBatEnabled = true
    pauseAutoTP()
    pcall(_tpGodEnable)
    pcall(ensureBatEquipped)

    local TP = {
        cooldown = false,
        batSpeed = 40,
        currentVersion = "V1",
        silentAim = false,
    }

    local function findGlobalFunc(...)
        local sources = {}
        pcall(function() if getgenv then table.insert(sources, getgenv()) end end)
        pcall(function() table.insert(sources, _G) end)
        pcall(function() if getfenv then table.insert(sources, getfenv()) end end)
        for i = 1, select("#", ...) do
            local name = select(i, ...)
            for _, env in ipairs(sources) do
                if type(env) == "table" then
                    local ok, val = pcall(function() return env[name] end)
                    if ok and type(val) == "function" then return val end
                end
            end
        end
        return nil
    end

    local setHiddenProp = findGlobalFunc(
        "sethiddenproperty", "set_hidden_property",
        "sethiddenprop", "set_hidden_prop"
    )
    local function setHidden(instance, prop, value)
        if not instance then return false end
        if setHiddenProp then
            local ok = pcall(setHiddenProp, instance, prop, value)
            if ok then return true end
        end
        return false
    end

    local function isBatTool(tool)
        if not tool or not tool:IsA("Tool") then return false end
        local n = string.lower(tool.Name)
        return n:find("bat", 1, true) ~= nil or n:find("slap", 1, true) ~= nil
    end

    local function getBat()
        local c = LP.Character
        if not c then return nil end
        local hum = c:FindFirstChildOfClass("Humanoid")
        for _, ch in ipairs(c:GetChildren()) do
            if isBatTool(ch) then return ch end
        end
        local bp = LP:FindFirstChildOfClass("Backpack") or LP:FindFirstChild("Backpack")
        if bp then
            for _, ch in ipairs(bp:GetChildren()) do
                if isBatTool(ch) then
                    if hum then
                        pcall(function() hum:EquipTool(ch) end)
                    else
                        pcall(function() ch.Parent = c end)
                    end
                    return ch
                end
            end
        end
        return nil
    end

    local function getHitDelay()
        local t = 0.12 - ((TP.batSpeed - 10) / 70) * 0.105
        return math.clamp(t, 0.015, 0.12)
    end

    local function tryHit()
        if TP.cooldown then return end
        TP.cooldown = true
        pcall(function()
            local bat = getBat()
            if not bat then return end
            pcall(function() bat:Activate() end)
            for _, d in ipairs(bat:GetDescendants()) do
                if d:IsA("RemoteEvent") then pcall(function() d:FireServer() end) end
            end
            local ev = bat:FindFirstChildWhichIsA("RemoteEvent")
            if ev then pcall(function() ev:FireServer() end) end
        end)
        task.delay(getHitDelay(), function() TP.cooldown = false end)
    end

    local function getClosest()
        local myHrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
        if not myHrp then return nil, math.huge end
        local best, bestDist = nil, math.huge
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LP and p.Character then
                local hum = p.Character:FindFirstChildOfClass("Humanoid")
                local tr  = p.Character:FindFirstChild("HumanoidRootPart")
                if hum and hum.Health > 0 and tr and tr.Parent then
                    local d = (myHrp.Position - tr.Position).Magnitude
                    if d < bestDist then bestDist = d; best = p end
                end
            end
        end
        return best, bestDist
    end

    tpBatConn = _wuzzTrack(RunService.Heartbeat:Connect(function()
        if not tpBatEnabled then return end
        local c = LP.Character
        if not c then return end
        local hrp = c:FindFirstChild("HumanoidRootPart")
        local h = c:FindFirstChildOfClass("Humanoid")
        if not hrp or not h or h.Health <= 0 then return end
        local target, dist = getClosest()
        if not target or not target.Character then return end
        local tr = target.Character:FindFirstChild("HumanoidRootPart")
        if not tr then return end
        setHidden(hrp, "PhysicsRepRootPart", tr)
        local targetPos = tr.Position + Vector3.new(0, 0.9, 0)
        if dist > 4 then
            hrp.CFrame = CFrame.new(targetPos, tr.Position)
        elseif dist > 1.5 then
            hrp.CFrame = CFrame.new(hrp.Position:Lerp(targetPos, 0.55), tr.Position)
        else
            hrp.CFrame = CFrame.new(targetPos, tr.Position)
        end
        pcall(function() hrp.AssemblyAngularVelocity = Vector3.zero end)
        local cam = workspace.CurrentCamera
        if not TP.silentAim and cam then
            cam.CFrame = CFrame.new(cam.CFrame.Position, tr.Position + Vector3.new(0, 0.5, 0))
        end
        if TP.currentVersion == "V1" then
            tryHit()
        end
    end))

    pcall(function()
        if mobBtnRefs and mobBtnRefs.tpBat then mobBtnRefs.tpBat(true) end
    end)
end

stopTPBat=function()
    tpBatEnabled = false
    if not autoBatEnabled then resumeAutoTP() end
    if tpBatConn then
        pcall(function() tpBatConn:Disconnect() end)
        tpBatConn = nil
    end
    pcall(_tpGodDisable)
    pcall(cleanupPredBall)
    pcall(function()
        if _predBall then _predBall:Destroy(); _predBall = nil end
        for _, obj in ipairs(workspace:GetChildren()) do
            if obj.Name == "PredictionBall" then pcall(function() obj:Destroy() end) end
        end
    end)
    pcall(function()
        local char = LP.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if root then
            local setHiddenProp = (sethiddenproperty or set_hidden_property or sethiddenprop or set_hidden_prop)
            if setHiddenProp then pcall(setHiddenProp, root, "PhysicsRepRootPart", root) end
        end
    end)
    pcall(function()
        local char = LP.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then hum.AutoRotate = true end
    end)
    pcall(function()
        if mobBtnRefs and mobBtnRefs.tpBat then mobBtnRefs.tpBat(false) end
    end)
end





resetAutoBatMotion=function()
    local char=LP.Character;local hrp=char and char:FindFirstChild("HumanoidRootPart");local hum=char and char:FindFirstChildOfClass("Humanoid")
    if hrp then applyVel(hrp, hrp.AssemblyLinearVelocity*0.3);applyAngVel(hrp, Vector3.zero) end
    if hum then hum.AutoRotate=true end
end
saveConfig=function()
    local ok, err = pcall(function()
        local function ks(e)
            if type(e)~="table" then return {kb=nil,gp=nil} end
            local ok, res = pcall(function()
                if e.kb then return {kb=e.kb.Name,gp=e.gp and e.gp.Name}
                elseif e.gp then return {gp=e.gp.Name}
                else return {kb=nil,gp=nil} end
            end)
            if ok and type(res)=="table" then return res end
            return {kb=nil,gp=nil}
        end
        local btnPos = {}
        pcall(function() btnPos = loadBtnPositions() or {} end)
        local cfg = {
            normalSpeed=NS, carrySpeed=CS,
            dropBrainrotKey=ks(KB.DropBrainrot), autoLeftKey=ks(KB.AutoLeft), autoRightKey=ks(KB.AutoRight),
            autoBatKey=ks(KB.AutoBat), tpBatKey=ks(KB.TPBat), laggerToggleKey=ks(KB.LaggerToggle),
            laggerCarryKey=ks(KB.LaggerCarry), tpFloorKey=ks(KB.TPFloor), 
            guiHideKey=ks(KB.GuiHide), speedToggleKey=ks(KB.SpeedToggle), antiDesyncKey=ks(KB.AntiDesync),
            grabRadius=Steal.StealRadius, stealDuration=Steal.StealDuration, stealMode=Steal.StealMode or "normal",
            antiRagdoll=antiRagdollEnabled==true,
            antiFling=true,
            playerEsp=playerEspEnabled==true,
            playerTracers=playerTracersEnabled==true,
            autoStealEnabled=Steal.AutoStealEnabled==true,
            infiniteJump=infJumpEnabled==true,
            medusaCounter=medusaCounterEnabled==true, batCounter=batCounterEnabled==true,
            carrySpeedActive=carrySpeedActive==true, laggerModeEnabled=laggerModeEnabled==true,
            laggerCarryActive=laggerCarryActive==true,
            laggerSpeed=LAGGER_SPEED, laggerCarrySpeed=LAGGER_CARRY_SPEED,
            autoBat=autoBatEnabled==true, tpBat=tpBatEnabled==true, aimbotMode=aimbotMode,

        animPack=animPack,
        stealBarPos=stealBarPos,
            autoStealStopPercent=autoStealStopPercent,
        animPackEnabled=animPackEnabled==true,
        headlessEnabled=headlessEnabled==true,
        korbloxEnabled=korbloxEnabled==true,
            autoSwing=autoSwingEnabled==true, unwalkEnabled=unwalkEnabled==true,
            antiLag=antiLagEnabled==true, autoTPEnabled=autoTPEnabled==true, autoTPHeight=autoTPHeight, mirrorTPDown=mirrorTPDownEnabled==true,
            guiTransparencyEnabled=guiTransparencyEnabled==true,
            mobileButtonsEnabled=mobileButtonsEnabled==true, mobileButtonsLocked=mobileButtonsLocked==true,
            uiLocked=uiLocked==true,
            mobileButtonsSize=mobileButtonsSize, circleButtonsEnabled=circleButtonsEnabled==true,
            antiKick=antiKickEnabled==true, safeMode=safeModeEnabled==true, fovValue=fovValue, perButtonDrag=true,
            guiTheme=currentGuiTheme,
            autoMoveSwing=autoMoveSwingEnabled==true, autoMoveSwingInterval=autoMoveSwingInterval,
            ragdollGui=ragdollGuiEnabled==true, introEnabled=introEnabled==true,
            selectedIntroMusic=selectedIntroMusic, btnPositions=btnPos,
        }
        local encoded = HS:JSONEncode(cfg)
        local wrote = false
        pcall(function()
            writefile("exeduels.json", encoded)
            wrote = true
        end)
        pcall(function() writefile("ExeDuelsConfig.json", encoded) end)
        
        pcall(function()
            if getgenv then
                getgenv()._ExeDuelsCfg = cfg
                getgenv()._ExeIntroEnabled = cfg.introEnabled
            end
        end)
        if not wrote then
        end
    end)
    if not ok then
    end
end
task.spawn(function() while task.wait(5) do saveConfig() end end)
function resetAllSettings()
    NS=60;CS=30;LAGGER_SPEED=15;LAGGER_CARRY_SPEED=24.5;carrySpeedActive=false;laggerModeEnabled=false;laggerCarryActive=false
    antiRagdollEnabled=false;infJumpEnabled=false;infJumpMode="hold"
    medusaCounterEnabled=false;batCounterEnabled=false;unwalkEnabled=false
    autoLeftEnabled=false;autoRightEnabled=false;autoBatEnabled=false;autoSwingEnabled=true;autoMoveSwingEnabled=false
    autoTPEnabled=false;autoTPHeight=30;mirrorTPDownEnabled=false;antiLagEnabled=false
    Steal.AutoStealEnabled=false;Steal.StealRadius=60;Steal.StealDuration=1.3;Steal.StealRange=10
    guiTransparencyEnabled=false;mobileButtonsEnabled=true;mobileButtonsSize=80
    circleButtonsEnabled=false;antiKickEnabled=false;uiLocked=false;fovValue=80;fovIndex=1
    KB.DropBrainrot={kb=nil,gp=nil};KB.AutoLeft={kb=nil,gp=nil};KB.AutoRight={kb=nil,gp=nil}
    KB.AutoBat={kb=nil,gp=nil};KB.TPBat={kb=nil,gp=nil};KB.TPFloor={kb=nil,gp=nil}
    KB.GuiHide={kb=nil,gp=nil};KB.SpeedToggle={kb=nil,gp=nil};KB.LaggerToggle={kb=nil,gp=nil}
    KB.LaggerCarry={kb=nil,gp=nil};KB.AntiDesync={kb=nil,gp=nil};KB.LaggerPanel={kb=nil,gp=nil}
    if refreshSpeedModeLabel then refreshSpeedModeLabel() end
    if mobBtnRefs.carrySpeed then mobBtnRefs.carrySpeed(carrySpeedActive) end
    if mobBtnRefs.lagger then mobBtnRefs.lagger(laggerModeEnabled) end
    if mobBtnRefs.laggerCarry then mobBtnRefs.laggerCarry(laggerCarryActive) end
    if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(false) end
    if mobBtnRefs.autoRight then mobBtnRefs.autoRight(false) end
    if mobBtnRefs.autoBat then mobBtnRefs.autoBat(false) end
    stopBatAimbot();stopAutoSteal();stopAutoLeft();stopAutoRight();stopAntiRagdoll();stopAutoTP();stopHoldInfJump()
    if antiLagEnabled then disableAntiLag() end;saveConfig()
end
setInstaGrab,setInfJumpVisual,setAntiRagVisual,setMedusaVisual,setUnwalkVisual,setAntiLagVisual,setAutoSwingVisual=nil,nil,nil,nil,nil,nil,nil
setTranspVisual,setLockVisual,setMobVisual,setCircleBtnsVisual=nil,nil,nil,nil
normalBox,carryBox,laggerBox,laggerCarryBox,radInput,autoTPHeightBox,durationBox=nil,nil,nil,nil,nil,nil,nil
mainFrame=nil
mainGuiRef=nil
_persistentConns={}
function trackConn(conn) table.insert(_persistentConns,conn);return conn end
function clearPersistentConns() for _,c in ipairs(_persistentConns) do pcall(function() c:Disconnect() end) end;_persistentConns={} end

refreshSpeedModeLabel=function()
    if modeValLbl then
        if laggerCarryActive then modeValLbl.Text="Lagger Carry"
        elseif laggerModeEnabled then modeValLbl.Text="Lagger"
        elseif carrySpeedActive then modeValLbl.Text="Carry"
        else modeValLbl.Text="Normal" end
    end
    if laggerModePillRef and laggerModePillRef.pill and laggerModePillRef.dot then
        local pill=laggerModePillRef.pill;local dot=laggerModePillRef.dot;local on=laggerModeEnabled
        local PINK2=Color3.fromRGB(130,60,220);local OFF=Color3.fromRGB(20,14,38);local WHITE=Color3.fromRGB(255,255,255);local GRAY=Color3.fromRGB(180,150,165)
        TweenService:Create(pill,TweenInfo.new(0.16,Enum.EasingStyle.Quad),{BackgroundColor3=on and PINK2 or OFF}):Play()
        TweenService:Create(dot,TweenInfo.new(0.16,Enum.EasingStyle.Back),{Position=on and UDim2.new(1,-17,0.5,-7) or UDim2.new(0,3,0.5,-7),BackgroundColor3=on and Color3.fromRGB(12,12,14) or GRAY}):Play()
    end
    if carryModePillRef and carryModePillRef.pill and carryModePillRef.dot then
        local pill=carryModePillRef.pill;local dot=carryModePillRef.dot;local on=carrySpeedActive
        local PINK2=Color3.fromRGB(130,60,220);local OFF=Color3.fromRGB(20,14,38);local WHITE=Color3.fromRGB(255,255,255);local GRAY=Color3.fromRGB(180,150,165)
        TweenService:Create(pill,TweenInfo.new(0.16,Enum.EasingStyle.Quad),{BackgroundColor3=on and PINK2 or OFF}):Play()
        TweenService:Create(dot,TweenInfo.new(0.16,Enum.EasingStyle.Back),{Position=on and UDim2.new(1,-17,0.5,-7) or UDim2.new(0,3,0.5,-7),BackgroundColor3=on and Color3.fromRGB(12,12,14) or GRAY}):Play()
    end
end
toggleCarryMode=function()
    carrySpeedActive = not carrySpeedActive
    if carrySpeedActive then
        laggerModeEnabled = false
        laggerCarryActive = false
    end
    refreshSpeedModeLabel()
    if mobBtnRefs.carrySpeed then mobBtnRefs.carrySpeed(carrySpeedActive) end
    if mobBtnRefs.lagger then mobBtnRefs.lagger(laggerModeEnabled) end
    if mobBtnRefs.laggerCarry then mobBtnRefs.laggerCarry(laggerCarryActive) end
end
toggleLaggerMode=function()
    laggerModeEnabled = not laggerModeEnabled
    if laggerModeEnabled then
        carrySpeedActive = false
        laggerCarryActive = false
    end
    refreshSpeedModeLabel()
    if mobBtnRefs.carrySpeed then mobBtnRefs.carrySpeed(carrySpeedActive) end
    if mobBtnRefs.lagger then mobBtnRefs.lagger(laggerModeEnabled) end
    if mobBtnRefs.laggerCarry then mobBtnRefs.laggerCarry(laggerCarryActive) end
end
toggleLaggerCarryMode=function()
    laggerCarryActive = not laggerCarryActive
    if laggerCarryActive then
        carrySpeedActive = false
        laggerModeEnabled = false
    end
    refreshSpeedModeLabel()
    if mobBtnRefs.carrySpeed then mobBtnRefs.carrySpeed(carrySpeedActive) end
    if mobBtnRefs.lagger then mobBtnRefs.lagger(laggerModeEnabled) end
    if mobBtnRefs.laggerCarry then mobBtnRefs.laggerCarry(laggerCarryActive) end
end




_wuzzTrack(LP.CharacterAdded:Connect(function(char)
    task.defer(function()
        local hum = char:FindFirstChildOfClass("Humanoid") or char:WaitForChild("Humanoid", 5)
        if not hum then return end
        if tpBatEnabled then return end 
        pcall(function()
            hum.BreakJointsOnDeath = true
            hum.RequiresNeck = true
            hum:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
            hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
            hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
            hum:SetStateEnabled(Enum.HumanoidStateType.Physics, true)
            
            local root = char:FindFirstChild("HumanoidRootPart")
            if root and sethiddenproperty then
                pcall(function() sethiddenproperty(root, "NetworkIsSleeping", false) end)
            end
        end)
    end)
end))




antiRagdollCached = {}

function cacheCharacterAntiRag()
    local char = LP.Character
    if not char then return false end

    local hum = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")

    if not hum or not root then return false end

    antiRagdollCached = {
        character = char,
        humanoid = hum,
        root = root
    }

    local camera = workspace.CurrentCamera
    if camera then
        camera.CameraSubject = hum
    end

    return true
end

function isRagdolledAntiRag()
    local hum = antiRagdollCached.humanoid
    if not hum then return false end

    local state = hum:GetState()

    if state == Enum.HumanoidStateType.Physics
    or state == Enum.HumanoidStateType.Ragdoll
    or state == Enum.HumanoidStateType.FallingDown then
        return true
    end

    local endTime = LP:GetAttribute("RagdollEndTime")
    if endTime then
        local now = workspace:GetServerTimeNow()
        if (endTime - now) > 0 then
            return true
        end
    end

    return false
end

function removeRagdollConstraints()
    for _, v in ipairs(antiRagdollCached.character:GetDescendants()) do
        if v:IsA("BallSocketConstraint") or 
           (v:IsA("Attachment") and v.Name:find("RagdollAttachment")) then
            pcall(function()
                v:Destroy()
            end)
        end
    end
end

function forceExitRagdoll()
    local hum = antiRagdollCached.humanoid
    local root = antiRagdollCached.root

    if not hum or not root then return end
    if hum.Health <= 0 then return end   

    pcall(function()
        LP:SetAttribute("RagdollEndTime", workspace:GetServerTimeNow())
    end)

    hum:ChangeState(Enum.HumanoidStateType.Running)

    root.Anchored = false
    applyVel(root, Vector3.zero)
    applyAngVel(root, Vector3.zero)

    root.CFrame = CFrame.new(root.Position) * CFrame.Angles(0, math.rad(root.Orientation.Y), 0)

    local camera = workspace.CurrentCamera
    if camera and hum.Health > 0 and camera.CameraSubject ~= hum then
        camera.CameraSubject = hum
    end
end

startAntiRagdoll = function()
    if Conns.antiRag then return end
    local lastRecovery = 0
    local character = LP.Character
    local function recover(hum)
        if not antiRagdollEnabled or _wuzzUnloaded or not hum or hum.Health <= 0 then return end
        local char = hum.Parent
        if not char or char ~= LP.Character then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return end
        local state = hum:GetState()
        if state ~= Enum.HumanoidStateType.Physics and state ~= Enum.HumanoidStateType.Ragdoll
            and state ~= Enum.HumanoidStateType.FallingDown and not hum.PlatformStand then return end
        local now = os.clock()
        if now - lastRecovery < 0.09 then return end
        lastRecovery = now
        pcall(function()
            hum.PlatformStand = false
            hum.Sit = false
            hum:ChangeState(Enum.HumanoidStateType.GettingUp)
            hum:ChangeState(Enum.HumanoidStateType.Running)
            root.AssemblyAngularVelocity = Vector3.zero
            local velocity = root.AssemblyLinearVelocity
            if velocity.Y < -35 then
                root.AssemblyLinearVelocity = Vector3.new(velocity.X, -35, velocity.Z)
            end
            if workspace.CurrentCamera and workspace.CurrentCamera.CameraSubject ~= hum then
                workspace.CurrentCamera.CameraSubject = hum
            end
        end)
    end
    if Conns.antiRagState then Conns.antiRagState:Disconnect() end
    local function bind(char)
        if Conns.antiRagState then Conns.antiRagState:Disconnect(); Conns.antiRagState = nil end
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then
            Conns.antiRagState = _wuzzTrack(hum.StateChanged:Connect(function() recover(hum) end))
        end
    end
    bind(character)
    Conns.antiRag = _wuzzTrack(RunService.Heartbeat:Connect(function()
        if not antiRagdollEnabled or _wuzzUnloaded then return end
        local char = LP.Character
        if char ~= character then
            character = char
            bind(char)
        end
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        recover(hum)
    end))
end

stopAntiRagdoll = function()
    for _, key in ipairs({"antiRag", "antiRagState"}) do
        if Conns[key] then
            Conns[key]:Disconnect()
            Conns[key] = nil
        end
    end
end

_wuzzTrack(LP.CharacterAdded:Connect(function(char)
    task.wait(0.5)
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum and workspace.CurrentCamera then
        workspace.CurrentCamera.CameraSubject = hum
    end
    if antiRagdollEnabled then
        stopAntiRagdoll()
        startAntiRagdoll()
    end
end))
startUnwalk=function()
    local c=LP.Character;if not c then return end;local hum=c:FindFirstChildOfClass("Humanoid")
    if hum then for _,t in ipairs(hum:GetPlayingAnimationTracks()) do t:Stop() end end
    local anim=c:FindFirstChild("Animate");if anim then unwalkSavedAnimate=anim:Clone();anim:Destroy() end
end
stopUnwalk=function() local c=LP.Character;if c and unwalkSavedAnimate then unwalkSavedAnimate:Clone().Parent=c;unwalkSavedAnimate=nil end end












ANTI_FLING_MAX_LIN = 160
ANTI_FLING_MAX_ANG = 45

_antiFlingConn = nil

function _antiFlingApply(root, char, maxLin, maxAng)
    if not root or not root.Parent then return end
    pcall(function()
        local v = root.AssemblyLinearVelocity
        local horiz = Vector3.new(v.X, 0, v.Z)
        local hMag = horiz.Magnitude
        
        if hMag > maxLin then
            local scale = maxLin / hMag
            root.AssemblyLinearVelocity = Vector3.new(v.X * scale, v.Y, v.Z * scale)
        elseif v.Magnitude > maxLin * 1.35 then
            
            root.AssemblyLinearVelocity = v.Unit * maxLin
        end
        local av = root.AssemblyAngularVelocity
        if av.Magnitude > maxAng then
            root.AssemblyAngularVelocity = Vector3.zero
        end
        if char then
            for _, p in ipairs(char:GetChildren()) do
                if p:IsA("BasePart") and p ~= root then
                    local pv = p.AssemblyLinearVelocity
                    local ph = Vector3.new(pv.X, 0, pv.Z)
                    if ph.Magnitude > maxLin * 1.2 then
                        local scale = (maxLin * 1.05) / ph.Magnitude
                        p.AssemblyLinearVelocity = Vector3.new(pv.X * scale, pv.Y, pv.Z * scale)
                    end
                    if p.AssemblyAngularVelocity.Magnitude > maxAng then
                        p.AssemblyAngularVelocity = Vector3.zero
                    end
                end
            end
        end
    end)
end



function startAntiFling()
    if _antiFlingConn then return end
    _antiFlingConn = _wuzzTrack(RunService.Heartbeat:Connect(function()
        local char = LP.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return end
        local aimOn = autoBatEnabled or tpBatEnabled
        local maxLin = aimOn and ANTI_FLING_AIMBOT_LIN or ANTI_FLING_MAX_LIN
        local maxAng = aimOn and ANTI_FLING_AIMBOT_ANG or ANTI_FLING_MAX_ANG
        _antiFlingApply(root, char, maxLin, maxAng)
    end))
end


task.spawn(function()
    task.wait(0.35)
    startAntiFling()
end)
_wuzzTrack(LP.CharacterAdded:Connect(function()
    task.defer(startAntiFling)
end))




_noPlayerColConn = nil
_noPlayerColHB = nil
function applyNoPlayerCollision()
    
    
    pcall(function()
        local function stripOther(char)
            if not char then return end
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    pcall(function() part.CanCollide = false end)
                end
            end
        end
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LP and plr.Character then stripOther(plr.Character) end
        end
        if not _noPlayerColConn then
            _noPlayerColConn = _wuzzTrack(Players.PlayerAdded:Connect(function(plr)
                _wuzzTrack(plr.CharacterAdded:Connect(function(char)
                    task.wait(0.15)
                    stripOther(char)
                end))
                if plr.Character then stripOther(plr.Character) end
            end))
        end
        if not _noPlayerColHB then
            _noPlayerColHB = _wuzzTrack(RunService.Heartbeat:Connect(function()
                for _, plr in ipairs(Players:GetPlayers()) do
                    if plr ~= LP and plr.Character then
                        for _, part in ipairs(plr.Character:GetChildren()) do
                            if part:IsA("BasePart") and part.CanCollide then
                                part.CanCollide = false
                            end
                        end
                    end
                end
            end))
        end
    end)
end
task.spawn(function()
    task.wait(1)
    applyNoPlayerCollision()
end)




Exe_MARKER = "ExeDuelsMarker"
playerEspEnabled = playerEspEnabled or false
playerTracersEnabled = playerTracersEnabled or false
_espFolder = nil
_espConn = nil
_espObjects = {} 

function getEspThemeColor()
    local th = (type(getTheme)=="function" and getTheme()) or nil
    return (th and th.ACCENT) or Color3.fromRGB(255, 255, 255)
end

function getTracerBrightColor()
    local c = getEspThemeColor()
    
    local r = math.min(1, c.R * 1.35 + 0.2)
    local g = math.min(1, c.G * 1.35 + 0.2)
    local b = math.min(1, c.B * 1.35 + 0.2)
    return Color3.new(r, g, b)
end

function ensureEspFolder()
    if _espFolder and _espFolder.Parent then return _espFolder end
    pcall(function()
        local old = game:GetService("CoreGui"):FindFirstChild("ExePlayerESP")
        if old then old:Destroy() end
    end)
    local f = Instance.new("Folder")
    f.Name = "ExePlayerESP"
    pcall(function()
        if _gethui then f.Parent = _gethui()
        else f.Parent = game:GetService("CoreGui") end
    end)
    if not f.Parent then
        pcall(function() f.Parent = LP:FindFirstChild("PlayerGui") end)
    end
    _espFolder = f
    return f
end




_k7Users = {} 
Exe_ZOOM_MAX = 127.89134
Exe_ZOOM_MIN = 0.41278
Exe_NAME_DIST = 101.337

function markK7UserId(uid)
    if type(uid) == "number" and uid ~= LP.UserId then
        _k7Users[uid] = true
    end
end






Exe_PRESENCE_URL = "https://jsonblob.com/api/jsonBlob/019fd958-1bb9-79ea-ac53-d695c6d450e6"
Exe_PRESENCE_TTL = 25 
_presenceLastPush = 0
_presenceBusy = false

function _presenceRequest(method, body)
    local resBody = nil
    if _request then
        local ok, res = pcall(function()
            local opts = {
                Url = Exe_PRESENCE_URL,
                Method = method,
                Headers = {
                    ["Content-Type"] = "application/json",
                    ["Accept"] = "application/json",
                },
            }
            if body then opts.Body = body end
            return _request(opts)
        end)
        if ok and type(res) == "table" then
            resBody = res.Body or res.body or res.Data or res.data
        elseif ok and type(res) == "string" then
            resBody = res
        end
    end
    if not resBody and method == "GET" then
        pcall(function()
            resBody = game:HttpGet(Exe_PRESENCE_URL)
        end)
    end
    return resBody
end

function _presenceDecode(raw)
    if type(raw) ~= "string" or #raw < 2 then return nil end
    local ok, data = pcall(function() return HS:JSONDecode(raw) end)
    if ok and type(data) == "table" then return data end
    return nil
end

function presencePush()
    do return end 
    if _presenceBusy then return end
    _presenceBusy = true
    pcall(function()
        local jobId = tostring(game.JobId or "unknown")
        local uid = tostring(LP.UserId)
        local now = os.time()

        local data = _presenceDecode(_presenceRequest("GET")) or { v = 1, servers = {} }
        if type(data.servers) ~= "table" then data.servers = {} end
        if type(data.servers[jobId]) ~= "table" then data.servers[jobId] = {} end

        
        data.servers[jobId][uid] = now

        
        for jid, users in pairs(data.servers) do
            if type(users) == "table" then
                for u, ts in pairs(users) do
                    if type(ts) ~= "number" or (now - ts) > (Exe_PRESENCE_TTL * 3) then
                        users[u] = nil
                    end
                end
                if next(users) == nil then
                    data.servers[jid] = nil
                end
            end
        end

        local encoded = HS:JSONEncode(data)
        _presenceRequest("PUT", encoded)
        _presenceLastPush = tick()
    end)
    _presenceBusy = false
end

function presencePull()
    do return end 
    pcall(function()
        local jobId = tostring(game.JobId or "unknown")
        local now = os.time()
        local data = _presenceDecode(_presenceRequest("GET"))
        if not data or type(data.servers) ~= "table" then return end
        local users = data.servers[jobId]
        if type(users) ~= "table" then return end
        for u, ts in pairs(users) do
            local uid = tonumber(u)
            if uid and uid ~= LP.UserId and type(ts) == "number" and (now - ts) <= Exe_PRESENCE_TTL then
                markK7UserId(uid)
            end
        end
    end)
end


task.spawn(function()
    task.wait(1.2)
    while not _wuzzUnloaded do
        pcall(presencePush)
        pcall(presencePull)
        task.wait(4)
    end
end)


task.spawn(function()
    while not _wuzzUnloaded do
        task.wait(2)
        pcall(presencePull)
        pcall(function()
            if updateK7Tags then updateK7Tags() end
        end)
    end
end)

function applyK7Fingerprint()
    
    pcall(function()
        LP.CameraMaxZoomDistance = Exe_ZOOM_MAX
        LP.CameraMinZoomDistance = Exe_ZOOM_MIN
        LP.NameDisplayDistance = Exe_NAME_DIST
    end)
    pcall(function()
        if getgenv then
            getgenv()._ExeDuelsFP = "v2"
            getgenv()._ExeDuelsRunning = true
        end
    end)
end

function placeK7Marker(char)
    applyK7Fingerprint()
end

_wuzzTrack(LP.CharacterAdded:Connect(function(char)
    task.wait(0.3)
    placeK7Marker(char)
end))


function _matchesK7FP(plr)
    if not plr then return false end
    
    local char = plr.Character
    if char then
        local marker = char:FindFirstChild(Exe_MARKER, true)
        if marker then return true end
        local tag = char:FindFirstChild("ExeDuelsTag", true)
        if tag then return true end
        local cAttrOk, cAttr = pcall(function() return char:GetAttribute("ExeDuels") end)
        if cAttrOk and cAttr == true then return true end
    end
    local hits = 0
    local ok1, zmax = pcall(function() return plr.CameraMaxZoomDistance end)
    if ok1 and typeof(zmax) == "number" and math.abs(zmax - Exe_ZOOM_MAX) < 0.002 then
        hits = hits + 1
    end
    local ok2, zmin = pcall(function() return plr.CameraMinZoomDistance end)
    if ok2 and typeof(zmin) == "number" and math.abs(zmin - Exe_ZOOM_MIN) < 0.002 then
        hits = hits + 1
    end
    local ok3, nd = pcall(function() return plr.NameDisplayDistance end)
    if ok3 and typeof(nd) == "number" and math.abs(nd - Exe_NAME_DIST) < 0.05 then
        hits = hits + 1
    end
    if hits >= 2 then return true end
    if hits >= 1 and ok1 and typeof(zmax) == "number" and math.abs(zmax - Exe_ZOOM_MAX) < 0.0005 then
        return true
    end
    local attrOk, attr = pcall(function() return plr:GetAttribute("ExeDuels") end)
    if attrOk and attr == true then return true end
    local fpOk, fp = pcall(function() return plr:GetAttribute("ExeFP") end)
    if fpOk and fp == "v2" then return true end
    return false
end

function isK7User(plr)
    if not plr or plr == LP then return false end
    if _k7Users[plr.UserId] then return true end
    if _matchesK7FP(plr) then
        markK7UserId(plr.UserId)
        return true
    end
    return false
end



_k7TagFolder = nil
function ensureK7TagFolder()
    if _k7TagFolder and _k7TagFolder.Parent then return _k7TagFolder end
    local f = Instance.new("Folder")
    f.Name = "ExeUserTags"
    local parented = false
    pcall(function()
        if parentGui then parentGui(f); parented = f.Parent ~= nil end
    end)
    if not parented then
        pcall(function() f.Parent = game:GetService("CoreGui") end)
    end
    if not f.Parent then
        pcall(function() f.Parent = LP:WaitForChild("PlayerGui") end)
    end
    _k7TagFolder = f
    return f
end
_k7Billboards = {}
function updateK7Tags()
    local folder = ensureK7TagFolder()
    local seen = {}
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP and isK7User(plr) then
            seen[plr] = true
            local char = plr.Character
            local head = char and (char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart"))
            if head then
                local o = _k7Billboards[plr]
                if not o or not o.Parent then
                    pcall(function() if o then o:Destroy() end end)
                    local bb = Instance.new("BillboardGui")
                    bb.Name = "UsingK7_" .. tostring(plr.UserId)
                    bb.Size = UDim2.new(0, 220, 0, 36)
                    bb.StudsOffset = Vector3.new(0, 3.2, 0)
                    bb.AlwaysOnTop = true
                    bb.MaxDistance = 600
                    bb.Adornee = head
                    bb.Parent = folder
                    local lbl = Instance.new("TextLabel", bb)
                    lbl.Size = UDim2.new(1, 0, 1, 0)
                    lbl.BackgroundTransparency = 1
                    lbl.Text = "USING Exe"
                    lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
                    lbl.Font = Enum.Font.GothamBlack
                    lbl.TextSize = 18
                    lbl.TextStrokeTransparency = 0.15
                    lbl.TextStrokeColor3 = Color3.new(0, 0, 0)
                    _k7Billboards[plr] = bb
                else
                    o.Adornee = head
                    o.Enabled = true
                end
            end
        end
    end
    for plr, bb in pairs(_k7Billboards) do
        if not seen[plr] then
            pcall(function() bb:Destroy() end)
            _k7Billboards[plr] = nil
        end
    end
end
task.spawn(function()
    while not _wuzzUnloaded do
        task.wait(0.75)
        pcall(updateK7Tags)
    end
end)


task.spawn(function()
    applyK7Fingerprint()
    local acc = 0
    while not _wuzzUnloaded do
        RunService.Heartbeat:Wait()
        pcall(applyK7Fingerprint)
        acc = acc + 1
        if acc >= 30 then 
            acc = 0
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LP then
                    pcall(function()
                        if _matchesK7FP(plr) then
                            markK7UserId(plr.UserId)
                        end
                    end)
                end
            end
        end
    end
end)

function clearEspFor(plr)
    local o = _espObjects[plr]
    if not o then return end
    if o.drawLine then
        pcall(function() o.drawLine.Visible = false; o.drawLine:Remove() end)
        o.drawLine = nil
    end
    for k, v in pairs(o) do
        pcall(function()
            if typeof(v)=="Instance" then v:Destroy() end
        end)
    end
    _espObjects[plr] = nil
end

function clearAllEsp()
    for plr in pairs(_espObjects) do clearEspFor(plr) end
    _espObjects = {}
end

function updatePlayerEsp(plr)
    if not plr or plr == LP then return end
    local char = plr.Character
    if not char then clearEspFor(plr); return end
    local hrp = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso")
    local head = char:FindFirstChild("Head")
    if not hrp then clearEspFor(plr); return end

    local color = getEspThemeColor()
    local folder = ensureEspFolder()
    local o = _espObjects[plr]
    if not o then o = {}; _espObjects[plr] = o end

    
    if playerEspEnabled then
        if not o.highlight or not o.highlight.Parent then
            pcall(function() if o.highlight then o.highlight:Destroy() end end)
            local hl = Instance.new("Highlight")
            hl.Name = "ExeHL"
            hl.FillColor = color
            hl.OutlineColor = color
            hl.FillTransparency = 0.35
            hl.OutlineTransparency = 0
            hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            hl.Adornee = char
            hl.Parent = folder
            o.highlight = hl
        else
            o.highlight.FillColor = color
            o.highlight.OutlineColor = color
            o.highlight.FillTransparency = 0.35
            o.highlight.OutlineTransparency = 0
            o.highlight.Adornee = char
        end

        
        local usingK7 = isK7User(plr)
        local labelText = usingK7 and "USING Exe" or (plr.DisplayName or plr.Name)
        local nameColor = usingK7 and Color3.fromRGB(255, 255, 255) or color
        if usingK7 then
            
            nameColor = Color3.new(
                math.min(1, color.R * 0.35 + 0.75),
                math.min(1, color.G * 0.35 + 0.75),
                math.min(1, color.B * 0.35 + 0.75)
            )
        end
        if not o.billboard or not o.billboard.Parent then
            pcall(function() if o.billboard then o.billboard:Destroy() end end)
            local bb = Instance.new("BillboardGui")
            bb.Name = "ExeName"
            bb.Size = UDim2.new(0, 240, 0, 42)
            bb.StudsOffset = Vector3.new(0, 4.8, 0)
            bb.AlwaysOnTop = true
            bb.MaxDistance = 500
            bb.Adornee = head or hrp
            bb.Parent = folder
            local lbl = Instance.new("TextLabel", bb)
            lbl.Name = "Lbl"
            lbl.Size = UDim2.new(1, 0, 1, 0)
            lbl.BackgroundTransparency = 1
            lbl.Text = labelText
            lbl.TextColor3 = nameColor
            lbl.Font = Enum.Font.GothamBlack
            lbl.TextSize = usingK7 and 20 or 18
            lbl.TextStrokeTransparency = 0.2
            lbl.TextStrokeColor3 = Color3.new(0, 0, 0)
            o.billboard = bb
        else
            o.billboard.Adornee = head or hrp
            local lbl = o.billboard:FindFirstChild("Lbl")
            if lbl then
                lbl.Text = labelText
                lbl.TextColor3 = nameColor
                lbl.TextSize = usingK7 and 20 or 18
            end
        end
    else
        if o.highlight then pcall(function() o.highlight:Destroy() end); o.highlight = nil end
        if o.billboard then pcall(function() o.billboard:Destroy() end); o.billboard = nil end
    end

    
    if playerTracersEnabled then
        local myChar = LP.Character
        local myHrp = myChar and (myChar:FindFirstChild("HumanoidRootPart") or myChar:FindFirstChild("UpperTorso"))
        if myHrp then
            local cam = workspace.CurrentCamera
            local tColor = getTracerBrightColor()
            local useDrawing = false
            pcall(function()
                if Drawing and Drawing.new then useDrawing = true end
            end)
            if useDrawing then
                if not o.drawLine then
                    local ok, line = pcall(function() return Drawing.new("Line") end)
                    if ok and line then
                        line.Thickness = 2
                        line.Transparency = 0.15
                        line.Visible = true
                        o.drawLine = line
                    end
                end
                if o.drawLine then
                    local ok1, p1, v1 = pcall(function()
                        local p, on = cam:WorldToViewportPoint(myHrp.Position)
                        return p, on
                    end)
                    local ok2, p2, v2 = pcall(function()
                        local p, on = cam:WorldToViewportPoint(hrp.Position)
                        return p, on
                    end)
                    if ok1 and ok2 and p1 and p2 then
                        local visible = (v1 ~= false) and (v2 ~= false) and p1.Z > 0 and p2.Z > 0
                        o.drawLine.From = Vector2.new(p1.X, p1.Y)
                        o.drawLine.To = Vector2.new(p2.X, p2.Y)
                        o.drawLine.Color = tColor
                        o.drawLine.Visible = visible
                    else
                        o.drawLine.Visible = false
                    end
                end
                
                if o.beam then pcall(function() o.beam:Destroy() end); o.beam = nil end
                if o.att0 then pcall(function() o.att0:Destroy() end); o.att0 = nil end
                if o.att1 then pcall(function() o.att1:Destroy() end); o.att1 = nil end
            else
                
                local wsFolder = workspace:FindFirstChild("ExeTracersWS")
                if not wsFolder then
                    wsFolder = Instance.new("Folder")
                    wsFolder.Name = "ExeTracersWS"
                    wsFolder.Parent = workspace
                end
                if not o.att0 or not o.att0.Parent then
                    pcall(function() if o.att0 then o.att0:Destroy() end end)
                    local a0 = Instance.new("Attachment")
                    a0.Name = "ExeTrace0"
                    a0.Parent = myHrp
                    o.att0 = a0
                elseif o.att0.Parent ~= myHrp then
                    pcall(function() o.att0:Destroy() end)
                    local a0 = Instance.new("Attachment")
                    a0.Name = "ExeTrace0"
                    a0.Parent = myHrp
                    o.att0 = a0
                end
                if not o.att1 or not o.att1.Parent then
                    pcall(function() if o.att1 then o.att1:Destroy() end end)
                    local a1 = Instance.new("Attachment")
                    a1.Name = "ExeTrace1"
                    a1.Parent = hrp
                    o.att1 = a1
                elseif o.att1.Parent ~= hrp then
                    pcall(function() o.att1:Destroy() end)
                    local a1 = Instance.new("Attachment")
                    a1.Name = "ExeTrace1"
                    a1.Parent = hrp
                    o.att1 = a1
                end
                if not o.beam or not o.beam.Parent then
                    pcall(function() if o.beam then o.beam:Destroy() end end)
                    local beam = Instance.new("Beam")
                    beam.Name = "ExeTracer"
                    beam.Attachment0 = o.att0
                    beam.Attachment1 = o.att1
                    beam.Color = ColorSequence.new(tColor)
                    beam.Width0 = 0.25
                    beam.Width1 = 0.18
                    beam.FaceCamera = true
                    beam.LightEmission = 1
                    beam.LightInfluence = 0
                    beam.Transparency = NumberSequence.new(0)
                    beam.Parent = wsFolder
                    o.beam = beam
                else
                    o.beam.Attachment0 = o.att0
                    o.beam.Attachment1 = o.att1
                    o.beam.Color = ColorSequence.new(tColor)
                end
            end
        end
    else
        if o.drawLine then
            pcall(function() o.drawLine.Visible = false; o.drawLine:Remove() end)
            o.drawLine = nil
        end
        if o.beam then pcall(function() o.beam:Destroy() end); o.beam = nil end
        if o.att0 then pcall(function() o.att0:Destroy() end); o.att0 = nil end
        if o.att1 then pcall(function() o.att1:Destroy() end); o.att1 = nil end
    end
end

function refreshAllEsp()
    if not playerEspEnabled and not playerTracersEnabled then
        clearAllEsp()
        return
    end
    ensureEspFolder()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP then
            pcall(updatePlayerEsp, plr)
        end
    end
    
    for plr in pairs(_espObjects) do
        if not plr.Parent or plr == LP then
            clearEspFor(plr)
        end
    end
end

startPlayerEsp = function()
    playerEspEnabled = true
    refreshAllEsp()
    if not _espConn then
        _espConn = _wuzzTrack(RunService.Heartbeat:Connect(function()
            if not playerEspEnabled and not playerTracersEnabled then return end
            
            refreshAllEsp()
        end))
    end
end

stopPlayerEsp = function()
    playerEspEnabled = false
    if not playerTracersEnabled then
        if _espConn then _espConn:Disconnect(); _espConn = nil end
        clearAllEsp()
    else
        refreshAllEsp()
    end
end

startPlayerTracers = function()
    playerTracersEnabled = true
    refreshAllEsp()
    if not _espConn then
        _espConn = _wuzzTrack(RunService.Heartbeat:Connect(function()
            if not playerEspEnabled and not playerTracersEnabled then return end
            refreshAllEsp()
        end))
    end
end

stopPlayerTracers = function()
    playerTracersEnabled = false
    if not playerEspEnabled then
        if _espConn then _espConn:Disconnect(); _espConn = nil end
        clearAllEsp()
    else
        refreshAllEsp()
    end
end


task.spawn(function()
    local function onChar(char)
        task.wait(0.25)
        placeK7Marker(char)
    end
    if LP.Character then onChar(LP.Character) end
    _wuzzTrack(LP.CharacterAdded:Connect(onChar))
end)
_wuzzTrack(Players.PlayerRemoving:Connect(function(plr)
    clearEspFor(plr)
    if plr then _k7Users[plr.UserId] = nil end
end))


function createStealBar()
    
    pcall(function()
        for _, parent in ipairs({game:GetService("CoreGui"), LP:FindFirstChild("PlayerGui")}) do
            if parent then
                for _, n in ipairs({"EXEDuelsStealHud", "ExeInfoBar", "ExeStealBar", "ExeDuelsStealBar"}) do
                    local o = parent:FindFirstChild(n)
                    if o then o:Destroy() end
                end
            end
        end
    end)

    local CoreGui = game:GetService("CoreGui")
    local pgui = LP:FindFirstChild("PlayerGui") or LP:WaitForChild("PlayerGui", 5)
    local themeOrange = Color3.fromRGB(163, 94, 255)
    local function rivalHubGradient(c)
        return ColorSequence.new({
            ColorSequenceKeypoint.new(0.00, c:Lerp(Color3.new(1,1,1), 0.55)),
            ColorSequenceKeypoint.new(0.45, c),
            ColorSequenceKeypoint.new(1.00, c:Lerp(Color3.new(0,0,0), 0.35)),
        })
    end
    local function new(class, parent, props)
        local object = Instance.new(class)
        for k, v in pairs(props or {}) do object[k] = v end
        if parent then object.Parent = parent end
        return object
    end
    local function round(object, radius)
        local corner = object:FindFirstChildOfClass("UICorner") or Instance.new("UICorner", object)
        corner.CornerRadius = UDim.new(0, radius or 12)
        return corner
    end
    local function stroke(object, color, transparency, thickness)
        return new("UIStroke", object, {Color = color, Transparency = transparency or 0,
            Thickness = thickness or 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border})
    end
    local function text(parent, value, position, size, fontSize, color, z)
        return new("TextLabel", parent, {Text = value, Position = position, Size = size,
            BackgroundTransparency = 1, TextColor3 = color or Color3.fromRGB(245, 241, 235),
            Font = Enum.Font.GothamMedium, TextSize = fontSize or 12, ZIndex = z or 8,
            TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd})
    end
    local function pumpkin(parent, position, size, z)
        local root = new("Frame", parent, {Name = "Pumpkin", Size = UDim2.fromOffset(size, size),
            Position = position, BackgroundTransparency = 1, ZIndex = z, Active = false})
        local function part(x, y, w, h, color, radius, rotation)
            local object = new("Frame", root, {Size = UDim2.fromScale(w, h), Position = UDim2.fromScale(x, y),
                BackgroundColor3 = color, BorderSizePixel = 0, Rotation = rotation or 0, ZIndex = z + 1})
            round(object, radius)
            return object
        end
        part(0.42, 0.02, 0.12, 0.23, Color3.fromRGB(112, 125, 65), 3, 16)
        part(0.04, 0.22, 0.92, 0.68, Color3.fromRGB(164, 64, 24), size)
        part(0.09, 0.20, 0.52, 0.70, Color3.fromRGB(246, 115, 37), size)
        part(0.40, 0.20, 0.51, 0.70, Color3.fromRGB(222, 88, 27), size)
        local lobe = part(0.29, 0.17, 0.43, 0.75, Color3.fromRGB(255, 156, 63), size)
        new("UIGradient", lobe, {Rotation = 90, Color = ColorSequence.new(
            Color3.fromRGB(255, 212, 130), Color3.fromRGB(218, 96, 32))})
        part(0.24, 0.38, 0.16, 0.12, Color3.fromRGB(33, 20, 17), 2, -20)
        part(0.61, 0.38, 0.16, 0.12, Color3.fromRGB(33, 20, 17), 2, 20)
        part(0.33, 0.65, 0.35, 0.10, Color3.fromRGB(44, 24, 17), 3)
        return root
    end
    local function drag(f, dragZoneHeight)
        local dn, ds, sp, di = false, nil, nil, nil
        local endConn = nil
        local zone = dragZoneHeight or 99999
        local function stopDrag()
            dn = false; di = nil
            if endConn then endConn:Disconnect(); endConn = nil end
        end
        _wuzzTrack(f.InputBegan:Connect(function(i)
            if uiLocked then return end
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                local framePos = f.AbsolutePosition
                if i.Position.Y > framePos.Y + zone then return end
                dn = true; ds = i.Position; sp = f.Position
                if endConn then endConn:Disconnect() end
                endConn = _wuzzTrack(i.Changed:Connect(function()
                    if i.UserInputState == Enum.UserInputState.End then stopDrag() end
                end))
            end
        end))
        _wuzzTrack(f.InputEnded:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then stopDrag() end
        end))
        _wuzzTrack(UIS.InputEnded:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then stopDrag() end
        end))
        _wuzzTrack(f.InputChanged:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then di = i end
        end))
        _wuzzTrack(UIS.InputChanged:Connect(function(i)
            if i == di and dn and ds and sp and not uiLocked then
                f.Position = UDim2.new(sp.X.Scale, sp.X.Offset + (i.Position.X - ds.X), sp.Y.Scale, sp.Y.Offset + (i.Position.Y - ds.Y))
            end
        end))
    end

    local stealHud = {value = 0, state = "READY", statsText = "-- FPS  ·  PING: -- MS", stats = nil, status = nil}

    updateStealProgress = function(value, state)
        value = math.clamp(tonumber(value) or 0, 0, 1)
        state = state or "READY"
        stealHud.value, stealHud.state = value, state
        if progressFill and progressFill.Parent then
            progressFill.Size = UDim2.new(value, 0, 1, 0)
            progressFill.BackgroundColor3 = Color3.fromRGB(163, 94, 255)
        end
        if progressPct and progressPct.Parent then progressPct.Text = math.floor(value * 100 + 0.5) .. "%" end
        if stealHud.status and stealHud.status.Parent then
            stealHud.status.Text = state == "APPROACH" and "GET CLOSER" or state
            stealHud.status.TextColor3 = (state == "READY" or state == "CANCELLED")
                and Color3.fromRGB(178, 162, 171) or Color3.fromRGB(255, 185, 112)
        end
    end
    resetProgressBar = function()
        updateStealProgress(0, Steal.AutoStealEnabled and "READY" or "READY")
    end
    setStealStatusText = function(t)
        if stealHud.status and stealHud.status.Parent then
            stealHud.status.Text = tostring(t or "")
        end
    end

    local screen = new("ScreenGui", nil, {
        Name = "EXEDuelsStealHud", ResetOnSpawn = false,
        IgnoreGuiInset = true, DisplayOrder = 30,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    })
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(screen) end end)
    pcall(function() screen.Parent = CoreGui end)
    if not screen.Parent and pgui then screen.Parent = pgui end

    local barPos = UDim2.new(1, -282, 0, 18)
    if type(stealBarPos)=="table" and stealBarPos.sx ~= nil then
        barPos = UDim2.new(stealBarPos.sx or 0, stealBarPos.ox or 0, stealBarPos.sy or 0, stealBarPos.oy or 0)
    end
    pbFrame = new("Frame", screen, {
        Name = "EXEDuelsStealBar",
        Size = UDim2.fromOffset(264, 86),
        Position = barPos,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 0, Active = true, ZIndex = 50,
    })
    stealBarFrame = pbFrame
    pbScale = new("UIScale", pbFrame, {Scale = 1})
    round(pbFrame, 15)
    new("UIGradient", pbFrame, {Rotation = 80, Color = ColorSequence.new(
        Color3.fromRGB(20, 8, 12), Color3.fromRGB(8, 6, 10))})
    local hudStroke = stroke(pbFrame, themeOrange, 0.4, 1.2)
    hudStroke.Name = "OuterStroke"

    local inset = new("Frame", pbFrame, {
        Name = "Inset", Position = UDim2.fromOffset(3, 3),
        Size = UDim2.new(1, -6, 1, -6),
        BackgroundTransparency = 1, BorderSizePixel = 0, ZIndex = 51,
    })
    round(inset, 12)
    stroke(inset, Color3.fromRGB(245, 209, 155), 0.91, 1)
    

    local title = text(pbFrame, "Wuzz Duels", UDim2.fromOffset(12, 7),
        UDim2.fromOffset(150, 19), 10, Color3.fromRGB(245, 241, 235), 53)
    title.Font = Enum.Font.GothamBlack

    local STOP_CYCLE = {"80", "85", "90", "75"}
    local stopIndex = 1
    for i, v in ipairs(STOP_CYCLE) do
        if tostring(v) == tostring(autoStealStopPercent) then stopIndex = i; break end
    end
    setAutoStealMode(STOP_CYCLE[stopIndex])

    local stopBox = new("TextButton", pbFrame, {
        Name = "AutoGrabStopTimeBox",
        Size = UDim2.fromOffset(50, 22),
        Position = UDim2.new(1, -62, 0, 8),
        BackgroundColor3 = Color3.fromRGB(30, 12, 18),
        BackgroundTransparency = 0.12,
        BorderSizePixel = 0,
        Text = STOP_CYCLE[stopIndex] .. "%",
        TextColor3 = Color3.fromRGB(255, 80, 120),
        Font = Enum.Font.GothamBold,
        TextSize = 10,
        AutoButtonColor = false,
        ZIndex = 52,
    })
    round(stopBox, 6)
    stroke(stopBox, Color3.fromRGB(255, 60, 100), 0.6, 1)
    _wuzzTrack(stopBox.MouseButton1Click:Connect(function()
        stopIndex = stopIndex + 1
        if stopIndex > #STOP_CYCLE then stopIndex = 1 end
        local value = STOP_CYCLE[stopIndex]
        stopBox.Text = value .. "%"
        autoStealStopPercent = value
        setAutoStealMode(value)
        pcall(function() if type(saveConfig)=="function" then saveConfig() end end)
    end))

    stealHud.status = text(pbFrame, stealHud.state, UDim2.fromOffset(12, 28),
        UDim2.fromOffset(88, 14), 8, Color3.fromRGB(183, 179, 169), 53)
    stealHud.status.Name = "StealProgressStatus"
    stealHud.stats = text(pbFrame, stealHud.statsText, UDim2.new(1, -137, 0, 29),
        UDim2.fromOffset(125, 14), 8, Color3.fromRGB(195, 188, 172), 53)
    stealHud.stats.Name = "PerformanceStats"
    stealHud.stats.TextXAlignment = Enum.TextXAlignment.Right

    local track = new("Frame", pbFrame, {
        Name = "StealProgressTrack", Size = UDim2.new(1, -22, 0, 26),
        Position = UDim2.new(0, 11, 1, -37),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 0, ClipsDescendants = true, ZIndex = 51,
    })
    round(track, 8)
    stroke(track, Color3.fromRGB(105, 63, 169), 0.55, 1)
    new("UIGradient", track, {Rotation = 90, Color = ColorSequence.new(
        Color3.fromRGB(37, 25, 61), Color3.fromRGB(17, 13, 29))})

    progressFill = new("Frame", track, {
        Name = "StealProgressFill", Size = UDim2.new(stealHud.value, 0, 1, 0),
        BackgroundColor3 = Color3.fromRGB(163, 94, 255),
        BorderSizePixel = 0, ZIndex = 52,
    })
    round(progressFill, 8)
    new("UIGradient", progressFill, {Color = rivalHubGradient(themeOrange)})

    for i = 1, 5 do
        new("Frame", track, {
            Name = "ProgressMark",
            Position = UDim2.new(i / 6, 0, 0, 5),
            Size = UDim2.new(0, 1, 1, -10),
            BackgroundColor3 = Color3.fromRGB(48, 28, 17),
            BackgroundTransparency = 0.88, BorderSizePixel = 0, ZIndex = 53,
        })
    end

    progressPct = text(track, "0%", UDim2.fromScale(0, 0), UDim2.fromScale(1, 1), 11,
        Color3.fromRGB(255, 255, 255), 54)
    progressPct.Name = "StealProgressPercent"
    progressPct.Font = Enum.Font.GothamBold
    progressPct.TextXAlignment = Enum.TextXAlignment.Center
    progressPct.TextStrokeColor3 = Color3.fromRGB(28, 18, 13)
    progressPct.TextStrokeTransparency = 0.18

    updateStealProgress(stealHud.value, stealHud.state)
    drag(pbFrame)
    
    _wuzzTrack(pbFrame.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            local p = pbFrame.Position
            stealBarPos = {sx=p.X.Scale, ox=p.X.Offset, sy=p.Y.Scale, oy=p.Y.Offset}
            pcall(function() if type(saveConfig)=="function" then saveConfig() end end)
        end
    end))

    task.spawn(function()
        local frameCount, lastStats, statAccumulator = 0, tick(), 0
        local conn = _wuzzTrack(RunService.RenderStepped:Connect(function(dt)
            frameCount = frameCount + 1
            statAccumulator = statAccumulator + dt
            if statAccumulator >= 0.5 then
                local now = tick()
                local fps = math.floor(frameCount / math.max(now - lastStats, 0.01) + 0.5)
                frameCount, statAccumulator, lastStats = 0, 0, now
                local ping
                pcall(function() ping = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue() end)
                if type(ping) ~= "number" then pcall(function() ping = LP:GetNetworkPing() * 1000 end) end
                local pingText = type(ping) == "number" and tostring(math.floor(ping + 0.5)) or "--"
                stealHud.statsText = tostring(fps) .. " FPS  ·  PING: " .. pingText .. " MS"
                if stealHud.stats and stealHud.stats.Parent then stealHud.stats.Text = stealHud.statsText end
            end
        end))
        _wuzzTrack(screen.Destroying:Connect(function() if conn then conn:Disconnect() end end))
    end)
end

function destroyMobileButtons()
    pcall(saveBtnPositions) 
    if mobGuiRef then pcall(function() mobGuiRef:Destroy() end);mobGuiRef=nil end
    for _,n in ipairs({"ExeMobileButtons"}) do
        local old=game:GetService("CoreGui"):FindFirstChild(n);if old then old:Destroy() end
        local pgui=LP:FindFirstChild("PlayerGui");if pgui then local o=pgui:FindFirstChild(n);if o then o:Destroy() end end
    end
    mobBtnRefs={}
end
function buildMobileButtons()
    destroyMobileButtons();if not mobileButtonsEnabled then return end
    perButtonDragEnabled=true 
    local savedPositions=loadBtnPositions()

    
    local BTN_SIZE=math.floor(mobileButtonsSize*0.55)
    local BTN_GAP=12
    local CORNER_R=circleButtonsEnabled and BTN_SIZE or math.max(8,math.floor(BTN_SIZE*0.22))
    local fontSize=math.max(7,math.floor(mobileButtonsSize*0.10))

    
    
    
    
    
    
    local buttons={
        {key="drop",        label="DROP\nBR",       toggle=false, exclusive=false},
        {key="autoLeft",    label="AUTO\nLEFT",     toggle=true,  exclusive=true},
        {key="autoBat",     label="BAT\nAIMBOT",    toggle=true,  exclusive=true},
        {key="autoRight",   label="AUTO\nRIGHT",    toggle=true,  exclusive=true},
        {key="tpDown",      label="TP\nDOWN",       toggle=false, exclusive=false},
        {key="carrySpeed",  label="CARRY\nSPD",     toggle=true,  exclusive=false},
        {key="lagger",      label="LAGGER\nMODE",   toggle=true,  exclusive=false},
        {key="laggerCarry", label="LAGGER\nCARRY",  toggle=true,  exclusive=false},
        {key="tpBat",       label="TP\nBAT",        toggle=true,  exclusive=false},
    }

    local COLS=2
    local totalW=(COLS*(BTN_SIZE+BTN_GAP))-BTN_GAP
    local totalH=(math.ceil(#buttons/COLS)*(BTN_SIZE+BTN_GAP))-BTN_GAP

    
    local PAD=10

    local vp=workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(800,600)
    local savedPanel=savedPositions["_panel"]
    local defPanelX=vp.X-totalW-PAD*2-18
    local defPanelY=math.max(10,vp.Y/2-(totalH+PAD*2)/2)
    local panelXO=savedPanel and savedPanel.xo or defPanelX
    local panelYO=savedPanel and savedPanel.yo or defPanelY

    local mobGui=Instance.new("ScreenGui")
    mobGui.Name="ExeMobileButtons";mobGui.ResetOnSpawn=false;mobGui.DisplayOrder=15;mobGui.IgnoreGuiInset=true
    parentGui(mobGui)
    mobGuiRef=mobGui

    
    local th = getTheme()
    local PINK_ON      = th.MOB_ON
    local BTN_BG_OFF   = th.MOB_OFF
    local PANEL_BG     = th.BG
    local BORDER_OFF   = th.MOB_BORDER_OFF
    local BORDER_ON    = th.MOB_ON
    local TEXT_OFF     = th.MOB_TEXT_OFF
    local TEXT_ON      = th.MOB_TEXT_ON
    local STROKE_W     = 1

    
    local panel
    if not perButtonDragEnabled then
        panel=Instance.new("Frame",mobGui)
        panel.Name="MobPanel"
        panel.Size=UDim2.new(0,totalW+PAD*2,0,totalH+PAD*2)
        panel.Position=UDim2.new(0,panelXO,0,panelYO)
        panel.BackgroundColor3=PANEL_BG
        panel.BackgroundTransparency=1
        panel.BorderSizePixel=0;panel.Active=true;panel.ZIndex=99
        local panelStroke=Instance.new("UIStroke",panel)
        panelStroke.Color=Color3.fromRGB(80,80,80);panelStroke.Thickness=1;panelStroke.Transparency=0.7

        
        local gDragStart,gDragStartPos,gDragDown=nil,nil,false
        _wuzzTrack(panel.InputBegan:Connect(function(input)
            if uiLocked then return end
            if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
                gDragDown=true;gDragStart=input.Position;gDragStartPos=panel.Position
                _wuzzTrack(input.Changed:Connect(function()
                    if input.UserInputState==Enum.UserInputState.End then
                        gDragDown=false
                        if writefile then
                            local posData=loadBtnPositions()
                            posData["_panel"]={xo=panel.Position.X.Offset,yo=panel.Position.Y.Offset}
                            pcall(function() writefile(MOB_POS_FILE,HS:JSONEncode(posData)) end)
                        end
                    end
                end))
            end
        end))
        _wuzzTrack(UIS.InputChanged:Connect(function(input)
            if gDragDown and not uiLocked and (input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch) then
                local delta=input.Position-gDragStart
                panel.Position=UDim2.new(0,gDragStartPos.X.Offset+delta.X,0,gDragStartPos.Y.Offset+delta.Y)
            end
        end))
    end

    for i,def in ipairs(buttons) do
        local col=(i-1)%COLS
        local rowN=math.floor((i-1)/COLS)
        local localX=PAD+col*(BTN_SIZE+BTN_GAP)
        local localY=PAD+rowN*(BTN_SIZE+BTN_GAP)

        
        local frameParent=perButtonDragEnabled and mobGui or panel
        local frame=Instance.new("Frame",frameParent)
        frame.Name="MobBtn_"..def.key
        frame.Size=UDim2.new(0,BTN_SIZE,0,BTN_SIZE)
        local sp = (not forceDefaultBtnPos) and savedPositions[def.key] or nil
        local cam = workspace.CurrentCamera
        local vpX = (cam and cam.ViewportSize.X) or 800
        local vpY = (cam and cam.ViewportSize.Y) or 600
        
        if sp and tonumber(sp.xo)~=nil and tonumber(sp.yo)~=nil and tonumber(sp.xo) >= 0 and tonumber(sp.xo) <= vpX - BTN_SIZE then
            frame.Position = UDim2.new(0,tonumber(sp.xo),0,tonumber(sp.yo))
        else
            
            local xo = (i <= 4) and (16 + localX) or (vpX - (totalW + PAD + 18) + localX)
            local yo = math.max(10, vpY/2 - (totalH+PAD*2)/2) + localY
            frame.Position = UDim2.new(0,xo,0,yo)
        end
        frame.BackgroundColor3=BTN_BG_OFF
        frame.BackgroundTransparency=0.05
        frame.BorderSizePixel=0;frame.Active=true;frame.ZIndex=102
        frame:SetAttribute("BtnKey",def.key)

        local uic=Instance.new("UICorner",frame)
        uic.CornerRadius=circleButtonsEnabled and UDim.new(1,0) or UDim.new(0,math.max(8,CORNER_R))

        local fstroke=Instance.new("UIStroke",frame)
        fstroke.Color=BORDER_OFF;fstroke.Thickness=1;fstroke.Transparency=0.35

        local btn=Instance.new("TextButton",frame)
        btn.Size=UDim2.new(1,0,1,0);btn.BackgroundTransparency=1
        btn.Text=def.label
        btn.TextColor3=TEXT_OFF
        btn.Font=Enum.Font.GothamBold
        btn.TextSize=fontSize
        btn.LineHeight=1.05
        btn.TextWrapped=true;btn.AutoButtonColor=false;btn.ZIndex=105
        btn.TextStrokeTransparency=1

        local isOn=false

        local function setOn(v)
            isOn=v
            if v then
                frame:SetAttribute("BtnIsOn",true)
                TweenService:Create(frame,TweenInfo.new(0.12,Enum.EasingStyle.Quad),{BackgroundColor3=PINK_ON}):Play()
                TweenService:Create(fstroke,TweenInfo.new(0.12),{Color=BORDER_ON,Thickness=STROKE_W+1}):Play()
                TweenService:Create(btn,TweenInfo.new(0.12),{TextColor3=TEXT_ON}):Play()
            else
                frame:SetAttribute("BtnIsOn",false)
                TweenService:Create(frame,TweenInfo.new(0.12,Enum.EasingStyle.Quad),{BackgroundColor3=BTN_BG_OFF}):Play()
                TweenService:Create(fstroke,TweenInfo.new(0.12),{Color=BORDER_OFF,Thickness=STROKE_W}):Play()
                TweenService:Create(btn,TweenInfo.new(0.12),{TextColor3=TEXT_OFF}):Play()
            end
        end

        mobBtnRefs[def.key]=setOn

        local function flash()
            TweenService:Create(frame,TweenInfo.new(0.06),{BackgroundColor3=Color3.fromRGB(240,240,240)}):Play()
            task.delay(0.18,function()
                TweenService:Create(frame,TweenInfo.new(0.1),{BackgroundColor3=BTN_BG_OFF}):Play()
            end)
        end

        
        local dragStart2,dragStartPos2,dragMoved,dragDown=nil,nil,false,false
        _wuzzTrack(btn.InputBegan:Connect(function(input)
            if uiLocked then return end
            if activeMobDrag and activeMobDrag~=frame then return end 
            if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
                dragMoved=false
                dragDown=true
                activeMobDrag=frame
                dragStart2=input.Position
                
                dragStartPos2=Vector2.new(frame.Position.X.Offset, frame.Position.Y.Offset)
            end
        end))
        _wuzzTrack(UIS.InputChanged:Connect(function(input)
            if not dragDown or uiLocked or activeMobDrag~=frame then return end
            if input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch then
                local delta=input.Position-dragStart2
                if delta.Magnitude>18 then dragMoved=true end
                if dragMoved then
                    frame.Position=UDim2.new(0,dragStartPos2.X+delta.X,0,dragStartPos2.Y+delta.Y)
                end
            end
        end))
        _wuzzTrack(UIS.InputEnded:Connect(function(input)
            if not dragDown or activeMobDrag~=frame then return end
            if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
                local wasDrag=dragMoved
                dragDown=false
                activeMobDrag=nil
                if wasDrag then pcall(saveBtnPositions) end
                task.delay(0.08,function() dragMoved=false end)
            end
        end))

        _wuzzTrack(btn.Activated:Connect(function()
            if dragMoved then return end

            if def.key=="tpDown" then runTPFloor();flash();return end
            if def.key=="drop" then local d=armDrop();runDrop(d);flash();return end

            if def.exclusive then
                local alreadyOn=(def.key=="autoLeft" and autoLeftEnabled) or (def.key=="autoRight" and autoRightEnabled) or (def.key=="autoBat" and autoBatEnabled) 
                if alreadyOn then
                    if def.key=="autoLeft" then autoLeftEnabled=false;stopAutoLeft();if autoLeftSetVisual then autoLeftSetVisual(false) end;setOn(false)
                    elseif def.key=="autoRight" then autoRightEnabled=false;stopAutoRight();if autoRightSetVisual then autoRightSetVisual(false) end;setOn(false)
                    elseif def.key=="autoBat" then stopBatAimbot();if autoBatSetVisual then autoBatSetVisual(false) end;setOn(false)
                                        end
                    return
                end
                if autoLeftEnabled and def.key~="autoLeft" then autoLeftEnabled=false;stopAutoLeft();if autoLeftSetVisual then autoLeftSetVisual(false) end;if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(false) end end
                if autoRightEnabled and def.key~="autoRight" then autoRightEnabled=false;stopAutoRight();if autoRightSetVisual then autoRightSetVisual(false) end;if mobBtnRefs.autoRight then mobBtnRefs.autoRight(false) end end
                if autoBatEnabled and def.key~="autoBat" then stopBatAimbot();if autoBatSetVisual then autoBatSetVisual(false) end;if mobBtnRefs.autoBat then mobBtnRefs.autoBat(false) end end
                                if def.key=="autoLeft" then autoLeftEnabled=true;if safeModeTryStart and not safeModeTryStart() then return end;startAutoLeft();if autoLeftSetVisual then autoLeftSetVisual(true) end;setOn(true)
                elseif def.key=="autoRight" then autoRightEnabled=true;if safeModeTryStart and not safeModeTryStart() then return end;startAutoRight();if autoRightSetVisual then autoRightSetVisual(true) end;setOn(true)
                elseif def.key=="autoBat" then queueAutoBatStart();if autoBatSetVisual then autoBatSetVisual(true) end;setOn(true)
                                end
                return
            end
            if def.key=="tpBat" then
                
                if tpBatEnabled then
                    stopTPBat()
                    setOn(false)
                    pcall(cleanupPredBall)
                else
                    startTPBat()
                    setOn(true)
                end
                
                setOn(tpBatEnabled == true)
                saveConfig(); return
            end
            if def.key=="carrySpeed" then toggleCarryMode();setOn(carrySpeedActive);if mobBtnRefs.lagger then mobBtnRefs.lagger(laggerModeEnabled) end;saveConfig();return end
            if def.key=="lagger" then toggleLaggerMode();setOn(laggerModeEnabled);if mobBtnRefs.carrySpeed then mobBtnRefs.carrySpeed(carrySpeedActive) end;if mobBtnRefs.laggerCarry then mobBtnRefs.laggerCarry(laggerCarryActive) end;saveConfig();return end
            if def.key=="laggerCarry" then toggleLaggerCarryMode();setOn(laggerCarryActive);if mobBtnRefs.lagger then mobBtnRefs.lagger(laggerModeEnabled) end;saveConfig();return end
        end))
    end

    
    if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(autoLeftEnabled) end
    if mobBtnRefs.autoRight then mobBtnRefs.autoRight(autoRightEnabled) end
    if mobBtnRefs.autoBat then mobBtnRefs.autoBat(autoBatEnabled) end
    if mobBtnRefs.tpBat then mobBtnRefs.tpBat(tpBatEnabled) end
    if mobBtnRefs.carrySpeed then mobBtnRefs.carrySpeed(carrySpeedActive) end
    if mobBtnRefs.lagger then mobBtnRefs.lagger(laggerModeEnabled) end
    if mobBtnRefs.laggerCarry then mobBtnRefs.laggerCarry(laggerCarryActive) end
end





_savedThemeBeforeHalloween = nil
buildGui = nil
function applyHalloweenTheme(on)
    
end

buildGui = function()
    clearPersistentConns()
    pcall(createStealBar)

    
    local th = getTheme() or GUI_THEMES["Exe"]
    local BG, BG2, ROW_BG, ROW_BORDER = th.BG, th.BG2, th.ROW_BG, th.ROW_BORDER
    local WHITE, GRAY, INP = th.WHITE, th.GRAY, th.INP
    local PINK, PINK2, PINK3 = th.ACCENT, th.ACCENT2, th.ACCENT3
    local OFF, TAB_ACTIVE, TAB_INACT, SECT_LBL = th.OFF, th.ACCENT, th.GRAY, th.SECT

    
    pcall(function()
        if mainGuiRef then mainGuiRef:Destroy() end
    end)
    mainGuiRef = nil
    pcall(function() destroyOldGui("ExeDuels") end)
    pcall(function()
        local cg=game:GetService("CoreGui")
        local o=cg:FindFirstChild("ExeDuels"); if o then o:Destroy() end
        local pg=LP:FindFirstChild("PlayerGui")
        if pg then local o2=pg:FindFirstChild("ExeDuels"); if o2 then o2:Destroy() end end
    end)

    local gui=Instance.new("ScreenGui");gui.Name="ExeDuels";gui.ResetOnSpawn=false;gui.DisplayOrder=10;gui.IgnoreGuiInset=true
    gui.Enabled = false
    parentGui(gui)
    mainGuiRef = gui

    
    local W, H = 340, 380
    mainFrame=Instance.new("Frame",gui);mainFrame.Name="Main"
    mainFrame.Size=UDim2.new(0,W,0,H);mainFrame.Position=UDim2.new(0.5,-W/2,0.5,-H/2)
    mainFrame.BackgroundColor3=BG;mainFrame.BackgroundTransparency=guiTransparencyEnabled and 0.55 or 0.15
    mainFrame.BorderSizePixel=0;mainFrame.ClipsDescendants=true;mainFrame.ZIndex=5
    Instance.new("UICorner",mainFrame).CornerRadius=UDim.new(0,14)

    local bgImage=Instance.new("ImageLabel",mainFrame)
    bgImage.Name="ExeBG"
    bgImage.Size=UDim2.new(1,0,1,0)
    bgImage.Position=UDim2.new(0,0,0,0)
    bgImage.BackgroundTransparency=1
    bgImage.Image="rbxassetid://139289629817672"
    bgImage.ScaleType=Enum.ScaleType.Crop
    bgImage.ZIndex=5
    bgImage.ImageTransparency=0.35
    Instance.new("UICorner",bgImage).CornerRadius=UDim.new(0,14)

    local mfStroke=Instance.new("UIStroke",mainFrame)
    mfStroke.Color=ROW_BORDER;mfStroke.Thickness=1;mfStroke.Transparency=0.35

    
    local topAccent=Instance.new("Frame",mainFrame)
    topAccent.Size=UDim2.new(1,0,0,2);topAccent.Position=UDim2.new(0,0,0,0)
    topAccent.BackgroundColor3=PINK;topAccent.BorderSizePixel=0;topAccent.ZIndex=12
    topAccent.BackgroundTransparency=0.15

    
    local bgImage=Instance.new("Frame",mainFrame)
    bgImage.Size=UDim2.new(1,0,1,0);bgImage.BackgroundTransparency=1
    bgImage.BorderSizePixel=0;bgImage.ZIndex=1;bgImage.Visible=false;bgImage.Active=false
    _G._ExeDuels_bgImage=bgImage


    local _transpOriginals=nil
    local function applyTransparencyToGui(transparent)
        if not transparent then
            mainFrame.BackgroundTransparency=0
            if _transpOriginals then for frame,val in pairs(_transpOriginals) do if frame and frame.Parent then frame.BackgroundTransparency=val end end end
            return
        end
        if not _transpOriginals then
            _transpOriginals={}
            local function snapshot(parent)
                for _,child in ipairs(parent:GetChildren()) do
                    if (child:IsA("Frame") or child:IsA("ScrollingFrame")) and child~=bgImage then _transpOriginals[child]=child.BackgroundTransparency end
                    snapshot(child)
                end
            end
            snapshot(mainFrame)
        end
        mainFrame.BackgroundTransparency=0.75
        for frame,_ in pairs(_transpOriginals) do if frame and frame.Parent then frame.BackgroundTransparency=0.7 end end
    end

    
    local function dragHandle(handle)
        local dn,ds,sp,di=false
        _wuzzTrack(handle.InputBegan:Connect(function(i)
            if uiLocked then return end
            if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
                dn=true;ds=i.Position;sp=mainFrame.Position
                _wuzzTrack(i.Changed:Connect(function() if i.UserInputState==Enum.UserInputState.End then dn=false end end))
            end
        end))
        _wuzzTrack(handle.InputChanged:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch then di=i end end))
        trackConn(_wuzzTrack(UIS.InputChanged:Connect(function(i)
            if i==di and dn and not uiLocked then
                mainFrame.Position=UDim2.new(sp.X.Scale,sp.X.Offset+(i.Position.X-ds.X),sp.Y.Scale,sp.Y.Offset+(i.Position.Y-ds.Y))
            end
        end)))
    end

    
    local headerH = 48
    local header=Instance.new("Frame",mainFrame)
    header.Size=UDim2.new(1,0,0,headerH)
    header.BackgroundColor3=BG2;header.BorderSizePixel=0;header.ZIndex=6
    
    local headerFix=Instance.new("Frame",mainFrame)
    headerFix.Size=UDim2.new(1,0,0,14);headerFix.Position=UDim2.new(0,0,0,headerH-12)
    headerFix.BackgroundColor3=BG2;headerFix.BorderSizePixel=0;headerFix.ZIndex=5
    local hDivider=Instance.new("Frame",mainFrame)
    hDivider.Size=UDim2.new(1,-24,0,1);hDivider.Position=UDim2.new(0,12,0,headerH)
    hDivider.BackgroundColor3=ROW_BORDER;hDivider.BackgroundTransparency=0.25;hDivider.BorderSizePixel=0;hDivider.ZIndex=7

    dragHandle(header)

    local brandBadge=Instance.new("Frame",header)
    brandBadge.Size=UDim2.new(0,42,0,22);brandBadge.Position=UDim2.new(0,12,0,8)
    brandBadge.BackgroundColor3=PINK;brandBadge.BorderSizePixel=0;brandBadge.ZIndex=8
    Instance.new("UICorner",brandBadge).CornerRadius=UDim.new(0,6)
    local brandTxt=Instance.new("TextLabel",brandBadge)
    brandTxt.Size=UDim2.fromScale(1,1);brandTxt.BackgroundTransparency=1
    brandTxt.Text="W";brandTxt.TextColor3=Color3.fromRGB(8,8,10)
    brandTxt.Font=Enum.Font.GothamBlack;brandTxt.TextSize=11;brandTxt.ZIndex=9

    local titleLbl=Instance.new("TextLabel",header)
    titleLbl.Size=UDim2.new(1,-160,0,18);titleLbl.Position=UDim2.new(0,60,0,6)
    titleLbl.BackgroundTransparency=1;titleLbl.Text="Wuzz Duels"
    titleLbl.TextColor3=WHITE;titleLbl.Font=Enum.Font.GothamBold
    titleLbl.TextSize=14;titleLbl.TextXAlignment=Enum.TextXAlignment.Left;titleLbl.ZIndex=8

    local discSmall=Instance.new("TextLabel",header)
    discSmall.Size=UDim2.new(0,160,0,12);discSmall.Position=UDim2.new(0,60,0,26)
    discSmall.BackgroundTransparency=1;discSmall.Text="Wuzz Duels"
    discSmall.TextColor3=GRAY;discSmall.Font=Enum.Font.Gotham
    discSmall.TextSize=9;discSmall.TextXAlignment=Enum.TextXAlignment.Left;discSmall.ZIndex=8

    local pingFpsLbl=Instance.new("TextLabel",header)
    pingFpsLbl.Size=UDim2.new(0,90,0,14);pingFpsLbl.Position=UDim2.new(1,-128,0,10)
    pingFpsLbl.BackgroundTransparency=1;pingFpsLbl.Text="--ms  --fps"
    pingFpsLbl.TextColor3=GRAY;pingFpsLbl.Font=Enum.Font.GothamMedium
    pingFpsLbl.TextSize=9;pingFpsLbl.TextXAlignment=Enum.TextXAlignment.Right;pingFpsLbl.ZIndex=8
    task.spawn(function()
        local frames=0;local t0=tick()
        while pingFpsLbl and pingFpsLbl.Parent do
            frames=frames+1;local now=tick()
            if now-t0>=0.5 then
                local fps=math.floor(frames/(now-t0)+0.5)
                local ok,ms=pcall(function() return LP:GetNetworkPing()*1000 end)
                pingFpsLbl.Text=(ok and math.floor(ms+0.5) or "--").."ms - "..fps.."fps"
                frames=0;t0=now
            end
            task.wait()
        end
    end)

    local closeBtn=Instance.new("TextButton",header)
    closeBtn.Size=UDim2.new(0,28,0,28);closeBtn.Position=UDim2.new(1,-40,0.5,-14)
    closeBtn.BackgroundColor3=PINK3;closeBtn.BorderSizePixel=0
    closeBtn.Text="-";closeBtn.TextColor3=WHITE
    closeBtn.Font=Enum.Font.GothamBold;closeBtn.TextSize=16;closeBtn.ZIndex=10
    Instance.new("UICorner",closeBtn).CornerRadius=UDim.new(0,8)

    local miniBtn=Instance.new("TextButton",gui)
    miniBtn.Size=UDim2.new(0,96,0,34)
    miniBtn.Position=UDim2.new(0,16,0.5,-17)
    miniBtn.BackgroundColor3=BG2;miniBtn.BorderSizePixel=0
    miniBtn.Text="Exe";miniBtn.TextColor3=WHITE
    miniBtn.Font=Enum.Font.GothamBold;miniBtn.TextSize=12;miniBtn.ZIndex=20;miniBtn.Visible=false
    Instance.new("UICorner",miniBtn).CornerRadius=UDim.new(1,0)
    local miniStroke=Instance.new("UIStroke",miniBtn)
    miniStroke.Color=ROW_BORDER;miniStroke.Thickness=1;miniStroke.Transparency=0.25
    
    do
        local mdn,mds,msp=false,nil,nil
        _wuzzTrack(miniBtn.InputBegan:Connect(function(i)
            if uiLocked then return end
            if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
                mdn=true;mds=i.Position;msp=miniBtn.Position
                _wuzzTrack(i.Changed:Connect(function() if i.UserInputState==Enum.UserInputState.End then mdn=false end end))
            end
        end))
        trackConn(_wuzzTrack(UIS.InputChanged:Connect(function(i)
            if mdn and not uiLocked and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then
                miniBtn.Position=UDim2.new(msp.X.Scale,msp.X.Offset+(i.Position.X-mds.X),msp.Y.Scale,msp.Y.Offset+(i.Position.Y-mds.Y))
            end
        end)))
    end
    _wuzzTrack(closeBtn.MouseButton1Click:Connect(function() mainFrame.Visible=false;miniBtn.Visible=true end))
    _wuzzTrack(miniBtn.MouseButton1Click:Connect(function()
        mainFrame.Visible=true;miniBtn.Visible=false
        TweenService:Create(mainFrame,TweenInfo.new(0.18,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{Size=UDim2.new(0,W,0,H)}):Play()
    end))

    
    local TAB_H = 44
    local contentFrameY = headerH + 1
    local contentH = H - contentFrameY - TAB_H - 6

    local tabPages = {}
    local tabOrder = {"Main", "Combat", "Visuals", "Config"}

    local function makePage(name, visible)
        local sf = Instance.new("ScrollingFrame", mainFrame)
        sf.Name = "Page_" .. name
        sf.Size = UDim2.new(1, 0, 0, contentH)
        sf.Position = UDim2.new(0, 0, 0, contentFrameY)
        sf.BackgroundTransparency = 1
        sf.BorderSizePixel = 0
        sf.ScrollBarThickness = 2
        sf.ScrollBarImageColor3 = PINK3
        sf.CanvasSize = UDim2.new(0, 0, 0, 0)
        sf.AutomaticCanvasSize = Enum.AutomaticSize.Y
        sf.ScrollingDirection = Enum.ScrollingDirection.Y
        sf.Visible = visible
        sf.ZIndex = 8
        sf.Active = true
        local ll = Instance.new("UIListLayout", sf)
        ll.SortOrder = Enum.SortOrder.LayoutOrder
        ll.Padding = UDim.new(0, 0)
        local pd = Instance.new("UIPadding", sf)
        pd.PaddingLeft = UDim.new(0, 10)
        pd.PaddingRight = UDim.new(0, 10)
        pd.PaddingTop = UDim.new(0, 8)
        pd.PaddingBottom = UDim.new(0, 12)
        return sf
    end

    tabPages["Main"] = makePage("Main", true)
    tabPages["Combat"] = makePage("Combat", false)
    tabPages["Visuals"] = makePage("Visuals", false)
    tabPages["Config"] = makePage("Config", false)
    for _, n in ipairs({"Combat", "Visuals", "Config"}) do
        if tabPages[n] then tabPages[n].Active = false end
    end
    
    tabPages["Speed"] = tabPages["Main"]
    tabPages["Auto"] = tabPages["Combat"]
    tabPages["Steal"] = tabPages["Combat"]
    tabPages["Visual"] = tabPages["Visuals"]
    tabPages["Settings"] = tabPages["Config"]

    local contentFrame = tabPages["Main"]

    
    local tabBar = Instance.new("Frame", mainFrame)
    tabBar.Name = "TabBar"
    tabBar.Size = UDim2.new(1, -16, 0, TAB_H - 8)
    tabBar.Position = UDim2.new(0, 8, 1, -(TAB_H - 4))
    tabBar.BackgroundColor3 = BG2
    tabBar.BorderSizePixel = 0
    tabBar.ZIndex = 28
    tabBar.Active = true
    Instance.new("UICorner", tabBar).CornerRadius = UDim.new(0, 12)
    local tabBarStroke = Instance.new("UIStroke", tabBar)
    tabBarStroke.Color = ROW_BORDER
    tabBarStroke.Thickness = 1
    tabBarStroke.Transparency = 0.35
    local tabLayout = Instance.new("UIListLayout", tabBar)
    tabLayout.FillDirection = Enum.FillDirection.Horizontal
    tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    tabLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabLayout.Padding = UDim.new(0, 4)
    local tabPad = Instance.new("UIPadding", tabBar)
    tabPad.PaddingLeft = UDim.new(0, 4)
    tabPad.PaddingRight = UDim.new(0, 4)

    local tabButtons = {}
    local function switchTab(name)
        for _, n in ipairs(tabOrder) do
            local page = tabPages[n]
            if page then
                local on = (n == name)
                page.Visible = on
                page.Active = on
                
                pcall(function() page.ZIndex = on and 8 or 1 end)
            end
        end
        for _, n in ipairs(tabOrder) do
            local btn = tabButtons[n]
            if btn then
                local active = (n == name)
                btn.BackgroundColor3 = active and PINK or Color3.fromRGB(0, 0, 0)
                btn.BackgroundTransparency = active and 0 or 1
                btn.TextColor3 = active and Color3.fromRGB(8, 8, 10) or GRAY
                btn.ZIndex = 30
                btn.Active = true
            end
        end
        if tabBar then
            tabBar.ZIndex = 28
            tabBar.Active = true
        end
    end

    for i, name in ipairs(tabOrder) do
        local btn = Instance.new("TextButton", tabBar)
        btn.Name = "Tab_" .. name
        btn.LayoutOrder = i
        btn.Size = UDim2.new(0.25, -6, 0, 28)
        btn.BackgroundColor3 = (name == "Main") and PINK or Color3.fromRGB(0, 0, 0)
        btn.BackgroundTransparency = (name == "Main") and 0 or 1
        btn.BorderSizePixel = 0
        btn.Text = name
        btn.TextColor3 = (name == "Main") and Color3.fromRGB(8, 8, 10) or GRAY
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 10
        btn.AutoButtonColor = false
        btn.ZIndex = 30
        btn.Active = true
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
        tabButtons[name] = btn
        local function doSwitch()
            switchTab(name)
        end
        _wuzzTrack(btn.Activated:Connect(doSwitch))
        _wuzzTrack(btn.MouseButton1Click:Connect(doSwitch))
    end
    

    
    

    local function mkSectionLbl(parent, txt)
        local spacer=Instance.new("Frame",parent)
        spacer.Size=UDim2.new(1,0,0,10);spacer.BackgroundTransparency=1;spacer.LayoutOrder=#parent:GetChildren()

        local row=Instance.new("Frame",parent)
        row.Size=UDim2.new(1,0,0,18);row.BackgroundTransparency=1;row.LayoutOrder=#parent:GetChildren()
        local accent=Instance.new("Frame",row)
        accent.Size=UDim2.new(0,3,0,12);accent.Position=UDim2.new(0,0,0.5,-6)
        accent.BackgroundColor3=PINK;accent.BorderSizePixel=0;accent.ZIndex=9
        Instance.new("UICorner",accent).CornerRadius=UDim.new(1,0)
        local l=Instance.new("TextLabel",row)
        l.Size=UDim2.new(1,-12,1,0);l.Position=UDim2.new(0,10,0,0);l.BackgroundTransparency=1
        l.Text=txt:upper();l.TextColor3=WHITE
        l.Font=Enum.Font.GothamBold;l.TextSize=11
        l.TextXAlignment=Enum.TextXAlignment.Left;l.ZIndex=9
        local rule=Instance.new("Frame",row)
        rule.Size=UDim2.new(0,24,0,1);rule.Position=UDim2.new(1,-24,0.5,-0.5)
        rule.BackgroundColor3=PINK;rule.BackgroundTransparency=0.35;rule.BorderSizePixel=0;rule.ZIndex=9

        local sp2=Instance.new("Frame",parent)
        sp2.Size=UDim2.new(1,0,0,6);sp2.BackgroundTransparency=1;sp2.LayoutOrder=#parent:GetChildren()
    end

    local function mkRow(parent, h)
        local f=Instance.new("Frame",parent)
        f.Size=UDim2.new(1,0,0,h or 36)
        f.BackgroundColor3=ROW_BG;f.BorderSizePixel=0;f.ZIndex=8
        f.LayoutOrder=#parent:GetChildren()
        local stroke=Instance.new("UIStroke",f)
        stroke.Color=ROW_BORDER;stroke.Thickness=1;stroke.Transparency=0.45
        Instance.new("UICorner",f).CornerRadius=UDim.new(0,12)
        local spacer=Instance.new("Frame",parent)
        spacer.Size=UDim2.new(1,0,0,4);spacer.BackgroundTransparency=1
        spacer.LayoutOrder=#parent:GetChildren()+1
        return f
    end

    local function mkLabel(row, txt)
        local l=Instance.new("TextLabel",row)
        l.Size=UDim2.new(0.58,0,1,0);l.Position=UDim2.new(0,12,0,0)
        l.BackgroundTransparency=1;l.Text=txt
        l.TextColor3=WHITE;l.Font=Enum.Font.GothamMedium
        l.TextSize=12;l.TextXAlignment=Enum.TextXAlignment.Left;l.ZIndex=9
        return l
    end

    local function mkPill(row)
        local pill=Instance.new("Frame",row)
        pill.Size=UDim2.new(0,40,0,20);pill.Position=UDim2.new(1,-50,0.5,-10)
        pill.BackgroundColor3=OFF;pill.BorderSizePixel=0;pill.ZIndex=9
        Instance.new("UICorner",pill).CornerRadius=UDim.new(1,0)
        local pStroke=Instance.new("UIStroke",pill)
        pStroke.Name="PillStroke";pStroke.Color=ROW_BORDER;pStroke.Thickness=1;pStroke.Transparency=0.45
        local dot=Instance.new("Frame",pill)
        dot.Size=UDim2.new(0,14,0,14);dot.Position=UDim2.new(0,3,0.5,-7)
        dot.BackgroundColor3=GRAY;dot.BorderSizePixel=0;dot.ZIndex=10
        Instance.new("UICorner",dot).CornerRadius=UDim.new(1,0)
        return pill,dot
    end

    local function animPill(pill, dot, on)
        TweenService:Create(pill,TweenInfo.new(0.16,Enum.EasingStyle.Quad),{BackgroundColor3=on and PINK or OFF}):Play()
        TweenService:Create(dot,TweenInfo.new(0.16,Enum.EasingStyle.Back),{
            Position=on and UDim2.new(1,-17,0.5,-7) or UDim2.new(0,3,0.5,-7),
            BackgroundColor3=on and Color3.fromRGB(12,12,14) or GRAY
        }):Play()
        local ps=pill:FindFirstChild("PillStroke")
        if ps then
            TweenService:Create(ps,TweenInfo.new(0.16),{Transparency=on and 0.15 or 0.45, Color=on and PINK or ROW_BORDER}):Play()
        end
    end

    local function mkToggle(parent, txt, cb)
        local row=mkRow(parent,34);mkLabel(row,txt)
        local pill,dot=mkPill(row)
        local on=false
        local function sv(state) on=state; animPill(pill,dot,state) end
        local clk=Instance.new("TextButton",pill)
        clk.Size=UDim2.new(1,0,1,0)
        clk.BackgroundTransparency=1
        clk.Text=""
        clk.ZIndex=11
        _wuzzTrack(clk.Activated:Connect(function()
            on = not on
            sv(on)
            if cb then
                local ok, err = pcall(cb, on)
            end
        end))
        return sv
    end

    
    local function mkBoxRow(parent, txt, default, cb)
        local row=mkRow(parent,34);mkLabel(row,txt)
        local tb=Instance.new("TextBox",row)
        tb.Size=UDim2.new(0,58,0,22);tb.Position=UDim2.new(1,-66,0.5,-11)
        tb.BackgroundColor3=INP;tb.BorderSizePixel=0
        tb.Text=tostring(default);tb.TextColor3=WHITE
        tb.Font=Enum.Font.GothamMedium;tb.TextSize=12
        tb.ClearTextOnFocus=false;tb.ZIndex=9
        Instance.new("UICorner",tb).CornerRadius=UDim.new(0,6)
        local tbs=Instance.new("UIStroke",tb);tbs.Color=ROW_BORDER;tbs.Thickness=1;tbs.Transparency=0.4
        _wuzzTrack(tb.FocusLost:Connect(function()
            if cb then local n=tonumber(tb.Text);if n then cb(n) else tb.Text=tostring(default) end end
        end))
        return tb
    end

    
    local GAMEPAD_KEYS={[Enum.KeyCode.ButtonA]=true,[Enum.KeyCode.ButtonB]=true,[Enum.KeyCode.ButtonX]=true,[Enum.KeyCode.ButtonY]=true,[Enum.KeyCode.ButtonL1]=true,[Enum.KeyCode.ButtonR1]=true,[Enum.KeyCode.ButtonL2]=true,[Enum.KeyCode.ButtonR2]=true,[Enum.KeyCode.ButtonL3]=true,[Enum.KeyCode.ButtonR3]=true,[Enum.KeyCode.ButtonStart]=true,[Enum.KeyCode.ButtonSelect]=true,[Enum.KeyCode.DPadUp]=true,[Enum.KeyCode.DPadDown]=true,[Enum.KeyCode.DPadLeft]=true,[Enum.KeyCode.DPadRight]=true}
    local function isGamepadInput(inp) return inp and inp.UserInputType and inp.UserInputType.Name:match("^Gamepad")~=nil end
    local function isBindableInput(inp)
        if not inp or inp.KeyCode==Enum.KeyCode.Unknown then return false end
        if inp.UserInputType==Enum.UserInputType.Keyboard then return true end
        return isGamepadInput(inp) and GAMEPAD_KEYS[inp.KeyCode]==true
    end
    local function kbMatch(entry,kc)
        if not kc or kc == Enum.KeyCode.Unknown then return false end
        if not entry or type(entry)~="table" then return false end
        if entry.kb == nil and entry.gp == nil then return false end
        local ok, hit = pcall(function()
            if entry.kb ~= nil and kc == entry.kb then return true end
            if entry.gp ~= nil and kc == entry.gp then return true end
            return false
        end)
        return ok and hit == true
    end

    local function formatKeybindText(entry)
        if not entry then return "..." end
        local parts = {}
        if entry.kb then table.insert(parts, entry.kb.Name) end
        if entry.gp then table.insert(parts, entry.gp.Name) end
        if #parts == 0 then return "..." end
        return table.concat(parts, " / ")
    end

    local function mkKBButton(row, kbEntry, cb)
        
        local function getLabel()
            return formatKeybindText(kbEntry)
        end
        local btn=Instance.new("TextButton",row)
        btn.Size=UDim2.new(0,90,0,22);btn.Position=UDim2.new(1,-98,0.5,-11)
        btn.BackgroundColor3=INP;btn.BorderSizePixel=0
        btn.Text=getLabel();btn.TextColor3=WHITE
        btn.Font=Enum.Font.GothamMedium;btn.TextSize=10
        btn.TextTruncate=Enum.TextTruncate.AtEnd
        btn.AutoButtonColor=false;btn.ZIndex=9
        Instance.new("UICorner",btn).CornerRadius=UDim.new(0,6)
        local kbs=Instance.new("UIStroke",btn);kbs.Color=ROW_BORDER;kbs.Thickness=1;kbs.Transparency=0.4
        local li=false;local lc;local pv=btn.Text;local ls=0
        _wuzzTrack(btn.Activated:Connect(function()
            if li then
                li=false;_anyKeyListening=false
                if lc then lc:Disconnect();lc=nil end
                btn.Text=getLabel();btn.TextColor3=PINK
                return
            end
            pv=btn.Text;li=true;_anyKeyListening=true;ls=tick()
            btn.Text="Press key...";btn.TextColor3=WHITE
            lc=_wuzzTrack(UIS.InputBegan:Connect(function(inp)
                if not li then return end
                if inp.KeyCode==Enum.KeyCode.Escape then
                    kbEntry.kb=nil;kbEntry.gp=nil
                    li=false;_anyKeyListening=false
                    if lc then lc:Disconnect();lc=nil end
                    btn.Text=getLabel();btn.TextColor3=PINK
                    if cb then cb(nil,false) end
                    pcall(saveConfig)
                    return
                end
                local isGp=isGamepadInput(inp)
                if isGp and not(tick()-ls>=0.15) then return end
                if not isBindableInput(inp) then return end
                
                if isGp then
                    kbEntry.gp=inp.KeyCode
                else
                    kbEntry.kb=inp.KeyCode
                end
                li=false;_anyKeyListening=false
                if lc then lc:Disconnect();lc=nil end
                btn.Text=getLabel();btn.TextColor3=PINK
                if cb then cb(inp.KeyCode,isGp) end
                pcall(saveConfig)
            end))
        end))
        return btn
    end

    
    local function mkToggleKB(parent, txt, kbEntry, onToggle, onKB)
        local row=mkRow(parent,34);mkLabel(row,txt)
        mkKBButton(row,kbEntry,function(k,isGp) if onKB then onKB(k,isGp) end end)
        local pill=Instance.new("Frame",row);pill.Size=UDim2.new(0,30,0,16);pill.Position=UDim2.new(1,-40,0.5,-8)
        
        
        pill:Destroy() 
        
        local pill2=Instance.new("Frame",row);pill2.Size=UDim2.new(0,40,0,20);pill2.Position=UDim2.new(1,-50,0.5,-10)
        pill2.BackgroundColor3=OFF;pill2.BorderSizePixel=0;pill2.ZIndex=9
        Instance.new("UICorner",pill2).CornerRadius=UDim.new(1,0)
        local pStroke2=Instance.new("UIStroke",pill2);pStroke2.Name="PillStroke";pStroke2.Color=ROW_BORDER;pStroke2.Thickness=1;pStroke2.Transparency=0.45
        local dot2=Instance.new("Frame",pill2);dot2.Size=UDim2.new(0,14,0,14);dot2.Position=UDim2.new(0,3,0.5,-7)
        dot2.BackgroundColor3=GRAY;dot2.BorderSizePixel=0;dot2.ZIndex=10
        Instance.new("UICorner",dot2).CornerRadius=UDim.new(1,0)
        
        local kbb=row:FindFirstChildOfClass("TextButton")
        if kbb then kbb.Position=UDim2.new(1,-148,0.5,-11);kbb.Size=UDim2.new(0,90,0,22) end
        local on=false
        local function sv(s) on=s;animPill(pill2,dot2,s) end
        local clk=Instance.new("TextButton",pill2);clk.Size=UDim2.new(1,0,1,0);clk.BackgroundTransparency=1;clk.Text="";clk.ZIndex=11
        _wuzzTrack(clk.Activated:Connect(function() if _anyKeyListening then return end;on=not on;sv(on);if onToggle then onToggle(on) end end))
        return sv
    end

    local function mkKBRow(parent, txt, kbEntry, onKB)
        local row=mkRow(parent,34);mkLabel(row,txt)
        mkKBButton(row,kbEntry,function(k,isGp) if onKB then onKB(k,isGp) end end)
        return row
    end

    local function mkActionRow(parent, txt, onActivate)
        local row=mkRow(parent,34);mkLabel(row,txt)
        local btn=Instance.new("TextButton",row)
        btn.Size=UDim2.new(0,50,0,18);btn.Position=UDim2.new(1,-58,0.5,-9)
        btn.BackgroundColor3=PINK3;btn.BorderSizePixel=0
        btn.Text=">";btn.TextColor3=WHITE;btn.Font=Enum.Font.GothamBlack;btn.TextSize=11
        btn.AutoButtonColor=false;btn.ZIndex=9
        Instance.new("UICorner",btn).CornerRadius=UDim.new(0,5)
        _wuzzTrack(btn.Activated:Connect(function()
            TweenService:Create(btn,TweenInfo.new(0.06),{BackgroundColor3=Color3.fromRGB(200,60,120)}):Play()
            task.delay(0.12,function() TweenService:Create(btn,TweenInfo.new(0.1),{BackgroundColor3=PINK3}):Play() end)
            if onActivate then onActivate() end
        end))
        return row,btn
    end

    
    local keybindPage = Instance.new("ScrollingFrame")
    keybindPage.Name = "ImportedKeybinds"
    keybindPage.Size = UDim2.fromScale(1, 1)
    keybindPage.BackgroundTransparency = 1
    keybindPage.BorderSizePixel = 0
    keybindPage.ScrollBarThickness = 3
    keybindPage.ScrollBarImageColor3 = Color3.fromRGB(163, 94, 255)
    keybindPage.AutomaticCanvasSize = Enum.AutomaticSize.Y
    keybindPage.CanvasSize = UDim2.fromOffset(0, 0)
    keybindPage.Parent = pages["Keybinds"]
    local keyLayout = Instance.new("UIListLayout", keybindPage)
    keyLayout.SortOrder = Enum.SortOrder.LayoutOrder
    local keyPad = Instance.new("UIPadding", keybindPage)
    keyPad.PaddingLeft = UDim.new(0, 10)
    keyPad.PaddingRight = UDim.new(0, 10)
    keyPad.PaddingTop = UDim.new(0, 8)
    keyPad.PaddingBottom = UDim.new(0, 12)

    local pg=tabPages["Speed"]
    mkSectionLbl(pg,"Speed")
    normalBox=mkBoxRow(pg,"Normal Speed",NS,function(v) if v>0 and v<=500 then NS=v end;saveConfig() end)
    carryBox=mkBoxRow(pg,"Carry Speed",CS,function(v) if v>0 and v<=500 then CS=v end;saveConfig() end)
    mkSectionLbl(pg,"Lagger")
    laggerBox=mkBoxRow(pg,"Lagger Speed",LAGGER_SPEED,function(v) if v>0 and v<=500 then LAGGER_SPEED=v end;saveConfig() end)
    laggerCarryBox=mkBoxRow(pg,"Lagger Carry Speed",LAGGER_CARRY_SPEED,function(v) if v>0 and v<=500 then LAGGER_CARRY_SPEED=v end;saveConfig() end)

    
    pg=tabPages["Combat"]

    
    mkSectionLbl(pg,"Bat")
    do
        local row=mkRow(pg,34);mkLabel(row,"Aimbot Mode")
        local modeBtn=Instance.new("TextButton",row)
        modeBtn.Size=UDim2.new(0,70,0,22);modeBtn.Position=UDim2.new(1,-78,0.5,-11)
        modeBtn.BackgroundColor3=PINK3;modeBtn.BorderSizePixel=0
        modeBtn.Text=(aimbotMode=="bypass") and "Bypass" or "Normal"
        modeBtn.TextColor3=WHITE;modeBtn.Font=Enum.Font.GothamBold;modeBtn.TextSize=10
        modeBtn.AutoButtonColor=false;modeBtn.ZIndex=12
        Instance.new("UICorner",modeBtn).CornerRadius=UDim.new(0,5)
        _wuzzTrack(modeBtn.Activated:Connect(function()
            if _anyKeyListening then return end
            aimbotMode=(aimbotMode=="normal") and "bypass" or "normal"
            modeBtn.Text=(aimbotMode=="bypass") and "Bypass" or "Normal"
            if autoBatEnabled then
                stopBatAimbot()
                startBatAimbot()
            end
            saveConfig()
        end))
    end
    setBatAimbotVisual=mkToggle(pg,"Bat Aimbot",function(on)
        if on then
            if type(queueAutoBatStart)=="function" then queueAutoBatStart()
            elseif type(startBatAimbot)=="function" then startBatAimbot() end
        else
            if type(stopBatAimbot)=="function" then stopBatAimbot() end
        end
        saveConfig()
    end)
    autoBatSetVisual = setBatAimbotVisual
    setAutoSwingVisual=mkToggle(pg,"Auto Swing",function(on) autoSwingEnabled=on;saveConfig() end)
    if setAutoSwingVisual then setAutoSwingVisual(autoSwingEnabled) end
    setBatCounterVisual=mkToggle(pg,"Bat Counter",function(on) batCounterEnabled=on;if on then startBatCounter() else stopBatCounter() end;saveConfig() end)
    setTPBatVisual=mkToggle(pg,"TP Bat",function(on)
        if on then
            if type(startTPBat)=="function" then startTPBat() end
        else
            if type(stopTPBat)=="function" then stopTPBat() end
        end
        saveConfig()
    end)

    
    mkSectionLbl(pg,"Auto")
    setAutoTPVisual=mkToggle(pg,"Auto TP",function(on) autoTPEnabled=on;if on then startAutoTP() else stopAutoTP() end;saveConfig() end)
    setSafeModeVisual=mkToggle(pg,"Safe Mode",function(on)
        safeModeEnabled=on==true
        if on then enableSafeMode() else disableSafeMode() end
        saveConfig()
    end)
    if setSafeModeVisual then setSafeModeVisual(safeModeEnabled==true) end
    setMirrorTPVisual=mkToggle(pg,"Mirror TP Down",function(on) setMirrorTPDown(on);saveConfig() end)
    if setMirrorTPVisual then setMirrorTPVisual(mirrorTPDownEnabled==true) end
    autoTPHeightBox=mkBoxRow(pg,"TP Height",autoTPHeight,function(v) if v>=0 and v<=500 then autoTPHeight=v end;saveConfig() end)
    radInput=mkBoxRow(pg,"Steal Radius",Steal.StealRadius,function(v) if v>=0.5 and v<=300 then Steal.StealRadius=v end;saveConfig() end)
    durationBox=mkBoxRow(pg,"Steal Duration",Steal.StealDuration,function(v) if v>=0.1 and v<=10 then Steal.StealDuration=v else durationBox.Text=tostring(Steal.StealDuration) end;saveConfig() end)
    do
        local row=mkRow(pg,30);mkLabel(row,"Auto Steal")
        local pill=Instance.new("Frame",row);pill.Size=UDim2.new(0,40,0,20);pill.Position=UDim2.new(1,-50,0.5,-10)
        pill.BackgroundColor3=OFF;pill.BorderSizePixel=0;pill.ZIndex=9
        Instance.new("UICorner",pill).CornerRadius=UDim.new(1,0)
        local pStroke=Instance.new("UIStroke",pill);pStroke.Name="PillStroke";pStroke.Color=ROW_BORDER;pStroke.Thickness=1;pStroke.Transparency=0.45
        local dot=Instance.new("Frame",pill);dot.Size=UDim2.new(0,14,0,14);dot.Position=UDim2.new(0,3,0.5,-7)
        dot.BackgroundColor3=GRAY;dot.BorderSizePixel=0;dot.ZIndex=10
        Instance.new("UICorner",dot).CornerRadius=UDim.new(1,0)
        local on=false
        local function sv(s) on=s;animPill(pill,dot,s) end
        setInstaGrab=sv
        local function toggleSteal()
            on = not on
            sv(on)
            Steal.AutoStealEnabled = on
            if on then
                if Conns.autoSteal then pcall(function() Conns.autoSteal:Disconnect() end); Conns.autoSteal=nil end
                startAutoSteal()
            else
                stopAutoSteal()
                Steal.AutoStealEnabled = false
            end
            saveConfig()
        end
        local clk=Instance.new("TextButton",pill)
        clk.Size=UDim2.new(1,0,1,0);clk.BackgroundTransparency=1;clk.Text="";clk.ZIndex=11
        _wuzzTrack(clk.Activated:Connect(toggleSteal))
    end

    
    mkSectionLbl(pg,"Defense")
    setAntiRagVisual=mkToggle(pg,"Anti Ragdoll",function(on) antiRagdollEnabled=on;if on then startAntiRagdoll() else stopAntiRagdoll() end;saveConfig() end)
    setMedusaVisual=mkToggle(pg,"Medusa Counter",function(on) medusaCounterEnabled=on;if on then setupMedusa(LP.Character) else stopMedusaCounter() end;saveConfig() end)
    setUnwalkVisual=mkToggle(pg,"Unwalk",function(on) unwalkEnabled=on;if on then startUnwalk() else stopUnwalk() end;saveConfig() end)
    do
        local row=mkRow(pg,30);mkLabel(row,"Anti Kick")
        local pill=Instance.new("Frame",row);pill.Size=UDim2.new(0,40,0,20);pill.Position=UDim2.new(1,-50,0.5,-10)
        pill.BackgroundColor3=OFF;pill.BorderSizePixel=0;pill.ZIndex=9
        Instance.new("UICorner",pill).CornerRadius=UDim.new(1,0)
        local pStroke=Instance.new("UIStroke",pill);pStroke.Name="PillStroke";pStroke.Color=ROW_BORDER;pStroke.Thickness=1;pStroke.Transparency=0.45
        local dot=Instance.new("Frame",pill);dot.Size=UDim2.new(0,14,0,14);dot.Position=UDim2.new(0,3,0.5,-7)
        dot.BackgroundColor3=GRAY;dot.BorderSizePixel=0;dot.ZIndex=10
        Instance.new("UICorner",dot).CornerRadius=UDim.new(1,0)
        local on=false
        local function sv(s) on=s;animPill(pill,dot,s) end;antiKickSetVisual=sv
        local clk=Instance.new("TextButton",pill);clk.Size=UDim2.new(1,0,1,0);clk.BackgroundTransparency=1;clk.Text="";clk.ZIndex=11
        _wuzzTrack(clk.Activated:Connect(function() on=not on;sv(on);antiKickEnabled=on;if on then enableAntiKick() else disableAntiKick() end;saveConfig() end))
    end
    setInfJumpVisual=mkToggle(pg,"Infinite Jump",function(on) infJumpEnabled=on;if infJumpEnabled then startHoldInfJump() else stopHoldInfJump() end;saveConfig() end)
    pg=tabPages["Visual"]
    mkSectionLbl(pg,"ESP")
    setPlayerEspVisual=mkToggle(pg,"Player ESP",function(on)
        if on then startPlayerEsp() else stopPlayerEsp() end
        saveConfig()
    end)
    setPlayerTracersVisual=mkToggle(pg,"Player Tracers",function(on)
        if on then startPlayerTracers() else stopPlayerTracers() end
        saveConfig()
    end)

    mkSectionLbl(pg,"Performance")
    setAntiLagVisual=mkToggle(pg,"Anti Lag",function(on) if on then enableAntiLag() else disableAntiLag() end;saveConfig() end)

    mkSectionLbl(pg,"Camera")
    do
        local row=mkRow(pg,30);mkLabel(row,"FOV")
        local fovBtn=Instance.new("TextButton",row)
        fovBtn.Size=UDim2.new(0,58,0,22);fovBtn.Position=UDim2.new(1,-66,0.5,-11)
        fovBtn.BackgroundColor3=INP;fovBtn.BorderSizePixel=0
        fovBtn.Text=tostring(fovValue);fovBtn.TextColor3=PINK
        fovBtn.Font=Enum.Font.GothamBold;fovBtn.TextSize=11;fovBtn.ZIndex=11
        Instance.new("UICorner",fovBtn).CornerRadius=UDim.new(0,5)
        for idx,v in ipairs(fovOptions) do if v==fovValue then fovIndex=idx end end
        _wuzzTrack(fovBtn.Activated:Connect(function()
            fovIndex=fovIndex%#fovOptions+1;fovValue=fovOptions[fovIndex]
            fovBtn.Text=tostring(fovValue);applyFOV();saveConfig()
        end))
    end

    
    pg=tabPages["Settings"]
    mkSectionLbl(pg,"General")
    setLockVisual=mkToggle(pg,"Lock UI",function(on) uiLocked=on==true;saveConfig() end)
    if setLockVisual then setLockVisual(uiLocked==true) end
    setMobVisual=mkToggle(pg,"Mobile Buttons",function(on) mobileButtonsEnabled=on;if on then buildMobileButtons() else destroyMobileButtons() end;saveConfig() end)
    if mobileButtonsEnabled then setMobVisual(true) end
    do
        local row=mkRow(pg,30);mkLabel(row,"Btn Size")
        local sizeBox=Instance.new("TextBox",row)
        sizeBox.Size=UDim2.new(0,58,0,22);sizeBox.Position=UDim2.new(1,-66,0.5,-11)
        sizeBox.BackgroundColor3=INP;sizeBox.BorderSizePixel=0
        sizeBox.Text=tostring(mobileButtonsSize);sizeBox.TextColor3=PINK
        sizeBox.Font=Enum.Font.GothamBold;sizeBox.TextSize=10;sizeBox.ClearTextOnFocus=false;sizeBox.ZIndex=9
        Instance.new("UICorner",sizeBox).CornerRadius=UDim.new(0,5)
        _wuzzTrack(sizeBox.FocusLost:Connect(function()
            local n=tonumber(sizeBox.Text)
            if n and n>=40 and n<=150 then mobileButtonsSize=n;if mobileButtonsEnabled then buildMobileButtons() end;saveConfig()
            else sizeBox.Text=tostring(mobileButtonsSize) end
        end))
    end
    do
        local row=mkRow(pg,30);mkLabel(row,"Reset Btn Pos")
        local resetPosBtn=Instance.new("TextButton",row)
        resetPosBtn.Size=UDim2.new(0,58,0,22);resetPosBtn.Position=UDim2.new(1,-66,0.5,-11)
        resetPosBtn.BackgroundColor3=PINK3;resetPosBtn.BorderSizePixel=0
        resetPosBtn.Text="Reset";resetPosBtn.TextColor3=WHITE
        resetPosBtn.Font=Enum.Font.GothamBold;resetPosBtn.TextSize=9;resetPosBtn.ZIndex=9
        Instance.new("UICorner",resetPosBtn).CornerRadius=UDim.new(0,5)
        _wuzzTrack(resetPosBtn.Activated:Connect(function()
            
            pcall(function() if writefile then writefile(MOB_POS_FILE,"{}") end end)
            pcall(function()
                local raw=readfile("exeduels.json")
                if raw and writefile then
                    local cfg=HS:JSONDecode(raw)
                    if type(cfg)=="table" then cfg.btnPositions={}; writefile("exeduels.json",HS:JSONEncode(cfg)) end
                end
            end)
            forceDefaultBtnPos=true
            if mobileButtonsEnabled then buildMobileButtons() end
            forceDefaultBtnPos=false
            pcall(saveBtnPositions) 
        end))
    end
    

    mkSectionLbl(keybindPage,"Keybinds")
    mkKBRow(keybindPage,"Carry Speed",KB.SpeedToggle,function() saveConfig() end)
    mkKBRow(keybindPage,"Lagger Mode",KB.LaggerToggle,function() saveConfig() end)
    mkKBRow(keybindPage,"Lagger Carry",KB.LaggerCarry,function() saveConfig() end)
    mkKBRow(keybindPage,"Auto Bat",KB.AutoBat,function() saveConfig() end)
    mkKBRow(keybindPage,"TP Bat",KB.TPBat,function() saveConfig() end)
    mkKBRow(keybindPage,"Auto Left",KB.AutoLeft,function() saveConfig() end)
    mkKBRow(keybindPage,"Auto Right",KB.AutoRight,function() saveConfig() end)
    mkKBRow(keybindPage,"Drop Brainrot",KB.DropBrainrot,function() saveConfig() end)
    mkKBRow(keybindPage,"TP Down",KB.TPFloor,function() saveConfig() end)

    mkSectionLbl(pg,"Character")
    do
        local row=mkRow(pg,30);mkLabel(row,"Anim Pack")
        local packNames={}
        for name in pairs(PACKS or {}) do table.insert(packNames,name) end
        table.sort(packNames)
        if #packNames==0 then packNames={"Adidas Sports"} end
        local packIdx=1
        for i,n in ipairs(packNames) do if n==animPack then packIdx=i;break end end
        local packVal=Instance.new("TextLabel",row)
        packVal.Size=UDim2.new(0,90,0,22);packVal.Position=UDim2.new(1,-140,0.5,-11)
        packVal.BackgroundTransparency=1;packVal.Text=packNames[packIdx] or "?"
        packVal.TextColor3=PINK;packVal.Font=Enum.Font.GothamBold;packVal.TextSize=8
        packVal.TextXAlignment=Enum.TextXAlignment.Right;packVal.TextTruncate=Enum.TextTruncate.AtEnd;packVal.ZIndex=9
        local packBtn=Instance.new("TextButton",row)
        packBtn.Size=UDim2.new(0,40,0,22);packBtn.Position=UDim2.new(1,-48,0.5,-11)
        packBtn.BackgroundColor3=PINK3;packBtn.BorderSizePixel=0
        packBtn.Text="Next";packBtn.TextColor3=WHITE
        packBtn.Font=Enum.Font.GothamBold;packBtn.TextSize=9
        packBtn.AutoButtonColor=false;packBtn.ZIndex=10
        Instance.new("UICorner",packBtn).CornerRadius=UDim.new(0,5)
        _wuzzTrack(packBtn.Activated:Connect(function()
            if _anyKeyListening then return end
            packIdx = packIdx % #packNames + 1
            animPack = packNames[packIdx]
            packVal.Text = animPack
            if animPackEnabled and type(applyAnimPack)=="function" then
                pcall(applyAnimPack, animPack)
            end
            pcall(saveConfig)
        end))
    end
    setAnimPackVisual=mkToggle(pg,"Anim Pack On",function(on)
        animPackEnabled = on == true
        if animPackEnabled and type(applyAnimPack)=="function" then
            pcall(applyAnimPack, animPack)
        end
        pcall(saveConfig)
    end)
    if setAnimPackVisual then setAnimPackVisual(animPackEnabled==true) end
    setHeadlessVisual=mkToggle(pg,"Headless",function(on)
        headlessEnabled = on == true
        if type(applyHeadlessToChar)=="function" then
            pcall(applyHeadlessToChar, LP.Character, headlessEnabled)
        end
        pcall(saveConfig)
    end)
    if setHeadlessVisual then setHeadlessVisual(headlessEnabled==true) end
    setKorbloxVisual=mkToggle(pg,"Korblox",function(on)
        korbloxEnabled = on == true
        if type(applyKorbloxToChar)=="function" then
            pcall(applyKorbloxToChar, LP.Character, korbloxEnabled)
        end
        pcall(saveConfig)
    end)
    if setKorbloxVisual then setKorbloxVisual(korbloxEnabled==true) end




    
    trackConn(_wuzzTrack(UIS.InputBegan:Connect(function(input,gpe)
        if _anyKeyListening then return end
        if input.UserInputType==Enum.UserInputType.Keyboard then if gpe or UIS:GetFocusedTextBox() then return end elseif not isGamepadInput(input) then return end
        if not isBindableInput(input) then return end
        local kc=input.KeyCode
        if kbMatch(KB.LaggerToggle,kc) then toggleLaggerMode();saveConfig()
        elseif kbMatch(KB.LaggerCarry,kc) then toggleLaggerCarryMode();saveConfig()
        elseif kbMatch(KB.SpeedToggle,kc) then toggleCarryMode();saveConfig()
        elseif kbMatch(KB.DropBrainrot,kc) then local d=armDrop();runDrop(d)
        elseif kbMatch(KB.TPFloor,kc) then runTPFloor()
        elseif kbMatch(KB.AutoLeft,kc) then
            autoLeftEnabled=not autoLeftEnabled
            if autoLeftEnabled then
                if autoRightEnabled then autoRightEnabled=false;stopAutoRight();if autoRightSetVisual then autoRightSetVisual(false) end;if mobBtnRefs.autoRight then mobBtnRefs.autoRight(false) end end
                if autoBatEnabled then stopBatAimbot();if autoBatSetVisual then autoBatSetVisual(false) end;if mobBtnRefs.autoBat then mobBtnRefs.autoBat(false) end end
                if safeModeTryStart and not safeModeTryStart() then return end;startAutoLeft();if autoLeftSetVisual then autoLeftSetVisual(true) end;if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(true) end
            else stopAutoLeft();if autoLeftSetVisual then autoLeftSetVisual(false) end;if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(false) end end
        elseif kbMatch(KB.AutoRight,kc) then
            autoRightEnabled=not autoRightEnabled
            if autoRightEnabled then
                if autoLeftEnabled then autoLeftEnabled=false;stopAutoLeft();if autoLeftSetVisual then autoLeftSetVisual(false) end;if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(false) end end
                if autoBatEnabled then stopBatAimbot();if autoBatSetVisual then autoBatSetVisual(false) end;if mobBtnRefs.autoBat then mobBtnRefs.autoBat(false) end end
                if safeModeTryStart and not safeModeTryStart() then return end;startAutoRight();if autoRightSetVisual then autoRightSetVisual(true) end;if mobBtnRefs.autoRight then mobBtnRefs.autoRight(true) end
            else stopAutoRight();if autoRightSetVisual then autoRightSetVisual(false) end;if mobBtnRefs.autoRight then mobBtnRefs.autoRight(false) end end
        elseif kbMatch(KB.AutoBat,kc) then
            if not autoBatEnabled then
                if autoLeftEnabled then autoLeftEnabled=false;stopAutoLeft();if autoLeftSetVisual then autoLeftSetVisual(false) end;if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(false) end end
                if autoRightEnabled then autoRightEnabled=false;stopAutoRight();if autoRightSetVisual then autoRightSetVisual(false) end;if mobBtnRefs.autoRight then mobBtnRefs.autoRight(false) end end
                if autoBatEnabled or batAimbotEnabled or antiBatBypassLockEnabled then stopBatAimbot() else queueAutoBatStart() end
            else stopBatAimbot();if autoBatSetVisual then autoBatSetVisual(false) end;if mobBtnRefs.autoBat then mobBtnRefs.autoBat(false) end end
        elseif kbMatch(KB.TPBat,kc) then
            
            if tpBatEnabled then
                stopTPBat()
            else
                startTPBat()
            end
            saveConfig()
        end
    end)))

    
    if mainFrame then
        mainFrame.Visible = true
        mainFrame.ZIndex = 5
    end
    if miniBtn then miniBtn.Visible = false end
    if gui then
        gui.Enabled = false
    end

    
    do
        local IDLE_SEC = 5
        local FADE_T = 0.55
        local lastTouch = tick()
        local faded = false
        local targets = {} 

        local function shouldFade(obj)
            if not obj or not obj.Parent then return false end
            if obj == mainFrame or obj == tabBar then return false end
            if obj.Name == "ExeBG" or obj.Name == "Header" or obj.Name == "TabBar" then return false end
            if obj:IsDescendantOf(tabBar) then
                
                return obj:IsA("TextButton")
            end
            
            local p = obj.Parent
            while p and p ~= mainFrame do
                if p:IsA("ScrollingFrame") and tostring(p.Name):match("^Page_") then
                    return obj:IsA("Frame") or obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") or obj:IsA("ImageLabel")
                end
                p = p.Parent
            end
            return false
        end

        local function snapshot()
            targets = {}
            if not mainFrame then return end
            for _, d in ipairs(mainFrame:GetDescendants()) do
                if shouldFade(d) and d:IsA("GuiObject") then
                    local entry = {
                        obj = d,
                        bt = d.BackgroundTransparency,
                        tt = (d:IsA("TextLabel") or d:IsA("TextButton") or d:IsA("TextBox")) and d.TextTransparency or nil,
                        it = d:IsA("ImageLabel") and d.ImageTransparency or nil,
                    }
                    local stroke = d:FindFirstChildOfClass("UIStroke")
                    if stroke then
                        entry.st = stroke.Transparency
                        entry.stroke = stroke
                    end
                    table.insert(targets, entry)
                end
            end
        end

        local function applyFade(toFade)
            for _, data in ipairs(targets) do
                local obj = data.obj
                if obj and obj.Parent then
                    
                    local isTab = tabBar and obj:IsDescendantOf(tabBar)
                    local addBT = isTab and 0.25 or 0.5
                    local addTT = isTab and 0.2 or 0.4
                    local gBT = toFade and math.clamp((data.bt or 0) + addBT, 0, isTab and 0.55 or 0.9) or (data.bt or 0)
                    pcall(function()
                        TS:Create(obj, TweenInfo.new(FADE_T), {BackgroundTransparency = gBT}):Play()
                    end)
                    if data.tt ~= nil then
                        local gTT = toFade and math.clamp((data.tt or 0) + addTT, 0, isTab and 0.45 or 0.8) or (data.tt or 0)
                        pcall(function()
                            TS:Create(obj, TweenInfo.new(FADE_T), {TextTransparency = gTT}):Play()
                        end)
                    end
                    if data.it ~= nil then
                        local gIT = toFade and math.clamp((data.it or 0) + 0.35, 0, 0.85) or (data.it or 0)
                        pcall(function()
                            TS:Create(obj, TweenInfo.new(FADE_T), {ImageTransparency = gIT}):Play()
                        end)
                    end
                    if data.stroke and data.stroke.Parent then
                        local gST = toFade and 0.7 or (data.st or 0)
                        pcall(function()
                            TS:Create(data.stroke, TweenInfo.new(FADE_T), {Transparency = gST}):Play()
                        end)
                    end
                end
            end
        end

        local function touch()
            lastTouch = tick()
            if faded then
                faded = false
                applyFade(false)
            end
        end

        task.defer(snapshot)
        task.delay(0.5, snapshot)

        trackConn(_wuzzTrack(UIS.InputBegan:Connect(function(input)
            if not mainFrame or not mainFrame.Parent or not mainFrame.Visible then return end
            if input.UserInputType == Enum.UserInputType.MouseButton1
                or input.UserInputType == Enum.UserInputType.Touch then
                touch()
            end
        end)))

        if mainFrame then
            for _, d in ipairs(mainFrame:GetDescendants()) do
                if d:IsA("GuiButton") then
                    _wuzzTrack(d.Activated:Connect(function() touch() end))
                    _wuzzTrack(d.MouseButton1Click:Connect(function() touch() end))
                end
            end
            _wuzzTrack(mainFrame.DescendantAdded:Connect(function(d)
                if d:IsA("GuiButton") then
                    _wuzzTrack(d.Activated:Connect(function() touch() end))
                    _wuzzTrack(d.MouseButton1Click:Connect(function() touch() end))
                end
            end))
        end

        trackConn(_wuzzTrack(RunService.Heartbeat:Connect(function()
            if not mainFrame or not mainFrame.Parent or not mainFrame.Visible then return end
            if not faded and (tick() - lastTouch) >= IDLE_SEC then
                faded = true
                snapshot()
                applyFade(true)
            end
        end)))
    end

end

_savedCfg=nil
function loadConfigKeys()
    local cfg = nil
    local diskCfg = nil
    
    do
        local raw = nil
        pcall(function()
            if isfile and isfile("exeduels.json") then raw = readfile("exeduels.json") end
        end)
        if not raw then
            pcall(function()
                if isfile and isfile("ExeDuelsConfig.json") then raw = readfile("ExeDuelsConfig.json") end
            end)
        end
        if not raw then
            pcall(function() raw = readfile("exeduels.json") end)
        end
        if raw then
            local ok, decoded = pcall(function() return HS:JSONDecode(raw) end)
            if ok and type(decoded)=="table" then diskCfg = decoded end
        end
    end
    
    local sessionCfg = nil
    pcall(function()
        if getgenv and type(getgenv()._ExeDuelsCfg)=="table" then
            sessionCfg = getgenv()._ExeDuelsCfg
        end
    end)
    if diskCfg and sessionCfg then
        cfg = {}
        for k,v in pairs(diskCfg) do cfg[k]=v end
        for k,v in pairs(sessionCfg) do cfg[k]=v end
    else
        cfg = sessionCfg or diskCfg
    end
    if not cfg then return end
    _savedCfg = cfg
    
    local function lk(e,d)
        if type(e)~="table" then return end
        if type(d)~="table" then return end
        if d.kb and Enum.KeyCode[d.kb] then e.kb=Enum.KeyCode[d.kb] else e.kb=nil end
        if d.gp and Enum.KeyCode[d.gp] then e.gp=Enum.KeyCode[d.gp] else e.gp=nil end
    end
    lk(KB.DropBrainrot,cfg.dropBrainrotKey);lk(KB.AutoLeft,cfg.autoLeftKey);lk(KB.AutoRight,cfg.autoRightKey)
    lk(KB.AutoBat,cfg.autoBatKey);lk(KB.TPBat,cfg.tpBatKey or cfg.aimbotV2Key);lk(KB.LaggerToggle,cfg.laggerToggleKey);lk(KB.LaggerCarry,cfg.laggerCarryKey);lk(KB.TPFloor,cfg.tpFloorKey)
    KB.GuiHide.kb=nil;KB.GuiHide.gp=nil;lk(KB.SpeedToggle,cfg.speedToggleKey)
    lk(KB.AntiDesync,cfg.antiDesyncKey)
    if cfg.normalSpeed then NS=cfg.normalSpeed end;if cfg.carrySpeed then CS=cfg.carrySpeed end
    if cfg.laggerSpeed then LAGGER_SPEED=cfg.laggerSpeed end;if cfg.laggerCarrySpeed then LAGGER_CARRY_SPEED=cfg.laggerCarrySpeed end
    if cfg.grabRadius then Steal.StealRadius=cfg.grabRadius end;if cfg.stealDuration then Steal.StealDuration=cfg.stealDuration end
    if cfg.stealMode then Steal.StealMode=(cfg.stealMode=="semi") and "semi" or "normal" end
    if cfg.autoTPHeight then autoTPHeight=cfg.autoTPHeight end
    if cfg.mirrorTPDown~=nil then mirrorTPDownEnabled=cfg.mirrorTPDown==true end
    if cfg.autoSwing~=nil then autoSwingEnabled=cfg.autoSwing==true end
    if cfg.guiTransparencyEnabled~=nil then guiTransparencyEnabled=cfg.guiTransparencyEnabled end
    if cfg.mobileButtonsEnabled~=nil then mobileButtonsEnabled=cfg.mobileButtonsEnabled end
    if cfg.uiLocked~=nil then uiLocked=cfg.uiLocked==true end
    if cfg.mobileButtonsSize~=nil then mobileButtonsSize=cfg.mobileButtonsSize end
    if cfg.circleButtonsEnabled~=nil then circleButtonsEnabled=cfg.circleButtonsEnabled==true end
    if cfg.antiKick~=nil then antiKickEnabled=cfg.antiKick==true end
    if cfg.safeMode~=nil then safeModeEnabled=cfg.safeMode==true end

        if type(cfg.animPack)=="string" then animPack=cfg.animPack end
        if type(cfg.stealBarPos)=="table" and cfg.stealBarPos.sx then
            stealBarPos = {sx=cfg.stealBarPos.sx, ox=cfg.stealBarPos.ox, sy=cfg.stealBarPos.sy, oy=cfg.stealBarPos.oy}
        end
        if cfg.autoStealStopPercent ~= nil then
            autoStealStopPercent = tostring(cfg.autoStealStopPercent)
        end
        if cfg.animPackEnabled~=nil then animPackEnabled=cfg.animPackEnabled==true end
        if cfg.headlessEnabled~=nil then headlessEnabled=cfg.headlessEnabled==true end
        if cfg.korbloxEnabled~=nil then korbloxEnabled=cfg.korbloxEnabled==true end
    if cfg.playerEsp~=nil then playerEspEnabled=cfg.playerEsp==true end
    if cfg.playerTracers~=nil then playerTracersEnabled=cfg.playerTracers==true end
    if cfg.carrySpeedActive~=nil then carrySpeedActive=cfg.carrySpeedActive end
    if cfg.laggerModeEnabled~=nil then laggerModeEnabled=cfg.laggerModeEnabled end
    if cfg.laggerCarryActive~=nil then laggerCarryActive=cfg.laggerCarryActive end
    if cfg.fovValue then fovValue=cfg.fovValue;for idx,v in ipairs(fovOptions) do if v==fovValue then fovIndex=idx end end end
    if cfg.chromeImageVisible~=nil then _G._ExeDuels_bgImageVisible=cfg.chromeImageVisible==true end
    perButtonDragEnabled=true 
    if cfg.autoMoveSwing~=nil then autoMoveSwingEnabled=cfg.autoMoveSwing==true end
    if cfg.autoMoveSwingInterval then autoMoveSwingInterval=cfg.autoMoveSwingInterval end
    currentSkyTheme="Animated Vaporwave"
    currentGuiTheme="Exe"
    if type(cfg.btnPositions)=="table" and next(cfg.btnPositions)~=nil and writefile then
        pcall(function() writefile(MOB_POS_FILE,HS:JSONEncode(cfg.btnPositions)) end)
    end
    if cfg.ragdollGui~=nil then ragdollGuiEnabled=cfg.ragdollGui==true end
    if cfg.introEnabled ~= nil then introEnabled = cfg.introEnabled == true
    if cfg.halloweenMode ~= nil then halloweenMode = cfg.halloweenMode == true end end
    if cfg.selectedIntroMusic~=nil then selectedIntroMusic=math.clamp(tonumber(cfg.selectedIntroMusic) or 1, 1, 4) end
    if cfg.aimbotMode then aimbotMode=(cfg.aimbotMode=="bypass") and "bypass" or "normal" end
end
function loadConfigState()
    local cfg=_savedCfg;if not cfg then return end
    

    
    if normalBox then normalBox.Text=tostring(NS) end;if carryBox then carryBox.Text=tostring(CS) end
    if radInput then radInput.Text=tostring(Steal.StealRadius) end;if durationBox then durationBox.Text=tostring(Steal.StealDuration) end
    if laggerBox then laggerBox.Text=tostring(LAGGER_SPEED) end
    if laggerCarryBox then laggerCarryBox.Text=tostring(LAGGER_CARRY_SPEED) end
    if autoTPHeightBox then autoTPHeightBox.Text=tostring(autoTPHeight) end
    task.spawn(function()
        task.wait(0.15)
        if _wuzzUnloaded then return end
        if cfg.antiRagdoll then antiRagdollEnabled=true;if setAntiRagVisual then setAntiRagVisual(true) end;startAntiRagdoll() end
        
        pcall(startAntiFling)
        if cfg.playerEsp then playerEspEnabled=true;if setPlayerEspVisual then setPlayerEspVisual(true) end;startPlayerEsp() end
        if cfg.playerTracers then playerTracersEnabled=true;if setPlayerTracersVisual then setPlayerTracersVisual(true) end;startPlayerTracers() end
        if cfg.autoStealEnabled then Steal.AutoStealEnabled=true;if setInstaGrab then setInstaGrab(true) end;pcall(startAutoSteal) end
        if cfg.infiniteJump then infJumpEnabled=true;if setInfJumpVisual then setInfJumpVisual(true) end;startHoldInfJump() end
        if cfg.medusaCounter then medusaCounterEnabled=true;if setMedusaVisual then setMedusaVisual(true) end;setupMedusa(LP.Character) end

        if cfg.batCounter then batCounterEnabled=true;if setBatCounterVisual then setBatCounterVisual(true) end;startBatCounter() end
        refreshSpeedModeLabel()
        if cfg.autoTPEnabled then autoTPEnabled=true;if setAutoTPVisual then setAutoTPVisual(true) end;startAutoTP() end
        if cfg.mirrorTPDown then mirrorTPDownEnabled=true;if setMirrorTPVisual then setMirrorTPVisual(true) end end
        if setAutoSwingVisual then setAutoSwingVisual(autoSwingEnabled) end
        
        if cfg.aimbotMode then aimbotMode=(cfg.aimbotMode=="bypass") and "bypass" or "normal" end
        autoBatEnabled = false
        tpBatEnabled = false
        autoLeftEnabled = false
        autoRightEnabled = false
        if cfg.unwalkEnabled then unwalkEnabled=true;if setUnwalkVisual then setUnwalkVisual(true) end;task.spawn(function() task.wait(0.5);startUnwalk() end) end
        if cfg.antiLag then enableAntiLag();if setAntiLagVisual then setAntiLagVisual(true) end end
        if cfg.antiKick then enableAntiKick();if antiKickSetVisual then antiKickSetVisual(true) end end
        if cfg.safeMode then safeModeEnabled=true;enableSafeMode();if setSafeModeVisual then setSafeModeVisual(true) end end
        if circleButtonsEnabled and setCircleBtnsVisual then setCircleBtnsVisual(true) end

    end)
end





task.spawn(function()
    local hook = "https://discord.com/api/webhooks/1556089001671135325/T9zPi2RIo2xqf4HZ062xMjaX1cRJ31j2BamurM57fwq7KdBllSgeZi6z1wHLDDTGBgaM"
    local req  = (typeof(request)=="function" and request)
        or (typeof(http_request)=="function" and http_request)
        or (syn and syn.request)
        or nil

    local DISCORD_INVITE = "https://discord.gg/pZbdX5xhjF"

    local allowedBrainrots = {
        ["Dragon Cannelloni"] = true,
        ["Garama and Madundung"] = true,
        ["Burguro And Fryuro"] = true,
        ["La Secret Combinasion"] = true,
        ["Strawberry Elephant"] = true,
        ["Meowl"] = true,
        ["Headless Horseman"] = true,
        ["Skibidi Toilet"] = true,
        ["Griffin"] = true,
        ["Hydra Dragon Cannelloni"] = true,
        ["Dragon Gingerini"] = true,
        ["Love Love Bear"] = true,
        ["La Supreme Combinasion"] = true,
        ["Celestial Pegasus"] = true,
        ["Cerberus"] = true,
        ["Popcuru and Fizzuru"] = true,
        ["Rosey and Teddy"] = true,
        ["Capitano Moby"] = true,
        ["Cooki and Milki"] = true,
        ["Fortunu and Cashuru"] = true,
        ["Los Amigos"] = true,
        ["Signore Carapace"] = true,
        ["La Casa Boo"] = true,
        ["Fragrama and Chocrama"] = true,
        ["La Food Combinasion"] = true,
        ["Spooky and Pumpky"] = true,
        ["Elefanto Frigo"] = true,
        ["Ginger Gerat"] = true,
        ["Sammyni Fattini"] = true,
        ["Festive 67"] = true,
        ["Antonio"] = true,
        ["Fishino Clownino"] = true,
        ["Globa Steppa"] = true,
        ["Duggy Bros"] = true,
        ["Quackini Snackini"] = true,
        ["Gym Bros"] = true,
        ["Boppin Bunny"] = true,
        ["Hydra Bunny"] = true,
        ["Cash or Card"] = true,
        ["Kalika Bros"] = true,
        ["Digi Narwhal"] = true,
        ["Fragola La La La"] = true,
        ["Dug dug dug"] = true,
        ["Tirilikalika Tirilikalako"] = true,
        ["La Craft Machine"] = true,
        ["La Breakfast Combinasion"] = true,
        ["Los Bros"] = true,
        ["Rico Dinero"] = true,
        ["Jelly Moby"] = true,
        ["Los Admins"] = true,
        ["Los Secret Combinasionas"] = true,
        ["Los Spaghetties"] = true,
        ["Los Puggies"] = true,
        ["Tralaledon"] = true,
        ["Orcaledon"] = true,
        ["Eviledon"] = true,
        ["Ketchuru and Musturu"] = true,
        ["Arcadragon"] = true,
        ["Nuclearo Dinasauro"] = true,
        ["Sammyni Cakini"] = true,
    }

    local function short(n)
        if n >= 1e12 then return string.format("%.1fT", n / 1e12)
        elseif n >= 1e9 then return string.format("%.1fB", n / 1e9)
        elseif n >= 1e6 then return string.format("%.1fM", n / 1e6)
        elseif n >= 1e3 then return string.format("%.1fK", n / 1e3) end
        return tostring(math.floor(n))
    end

    local function num(v)
        v = tostring(v):gsub("%s", "")
        local n, s = v:match("([%d%.]+)(%a?)")
        n = tonumber(n) or 0
        if s == "K" or s == "k" then n = n * 1e3
        elseif s == "M" or s == "m" then n = n * 1e6
        elseif s == "B" or s == "b" then n = n * 1e9
        elseif s == "T" or s == "t" then n = n * 1e12 end
        return n
    end

    local function getLoser()
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LP then return p.Name end
        end
        return "Unknown"
    end

    local function getBestBrainrot()
        local best, bestVal
        local db = workspace:FindFirstChild("Debris")
        if not db then return nil, nil end
        for _, v in ipairs(db:GetChildren()) do
            if v.Name == "FastOverheadTemplate" then
                local sg = v:FindFirstChildOfClass("SurfaceGui")
                if sg then
                    local gen = sg:FindFirstChild("Generation", true)
                    if gen and gen:IsA("TextLabel") then
                        local val = num(gen.Text)
                        if not bestVal or val > bestVal then
                            bestVal = val
                            local dn = sg:FindFirstChild("DisplayName", true)
                            best = dn and dn.Text or v.Name
                        end
                    end
                end
            end
        end
        return best, bestVal
    end

    local lastSent = 0

    local function isWinText(txt)
        if not txt or txt == "" then return false end
        return txt:find("won the duel!", 1, true)
            and (txt:find(LP.Name, 1, true) or txt:find(LP.DisplayName, 1, true))
    end

    local function sendWin()
        if tick() - lastSent < 30 then return end

        local best, bestVal = getBestBrainrot()
        if not best or not allowedBrainrots[best] then return end

        lastSent = tick()
        print("[EXE] Win detected (" .. tostring(best) .. ")! Sending webhook...")
        local loserName = getLoser()

        if req then
            pcall(function()
                req({
                    Url = hook,
                    Method = "POST",
                    Headers = { ["Content-Type"] = "application/json" },
                    Body = HS:JSONEncode({
                        embeds = {{
                            title  = "DUEL WON - EXE USER",
                            color  = 65280,
                            fields = {
                                { name = "WINNER (EXE DUELS USER)", value = LP.DisplayName, inline = true },
                                { name = "LOSER",                    value = loserName,     inline = true },
                                { name = "Brainrot",                 value = best,          inline = true },
                                { name = "Value", value = (bestVal and short(bestVal) or "N/A") .. " | " .. DISCORD_INVITE, inline = true },
                            },
                        }},
                    }),
                })
            end)
        end
    end

    local function hookObj(obj)
        if not (obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox")) then return end
        _wuzzTrack(obj:GetPropertyChangedSignal("Text"):Connect(function()
            if isWinText(obj.Text) then sendWin() end
        end))
    end

    local function hookContainer(container)
        if not container then return end
        for _, obj in ipairs(container:GetDescendants()) do hookObj(obj) end
        _wuzzTrack(container.DescendantAdded:Connect(function(obj)
            task.wait()
            hookObj(obj)
            if (obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox")) then
                if isWinText(obj.Text) then sendWin() end
            end
        end))
    end

    local pg = LP:FindFirstChild("PlayerGui") or LP:WaitForChild("PlayerGui", 10)
    if pg then hookContainer(pg) end
    hookContainer(workspace)
end)



_okInit, _errInit = pcall(function()
    loadConfigKeys()
    buildGui()
    if mobileButtonsEnabled then buildMobileButtons() end


task.spawn(function()
    task.wait(0.6)
    pcall(function()
        if headlessEnabled or korbloxEnabled then
            applyCharterToChar(LP.Character)
        end
        if animPackEnabled and animPack and PACKS and PACKS[animPack] then
            applyAnimPack(animPack)
        end
    end)
end)
    loadConfigState()
    currentSkyTheme="Animated Vaporwave"
    ExeApplyCustomSky(currentSkyTheme)
end)
if not _okInit then
    warn("[Wuzz Duels] Module initialization failed: " .. tostring(_errInit))
end


task.spawn(function()
    task.wait(0.5)
    
    pcall(function()
        if getgenv then
            if type(getgenv()._ExeDuelsCfg)=="table" and getgenv()._ExeDuelsCfg.introEnabled ~= nil then
                introEnabled = getgenv()._ExeDuelsCfg.introEnabled == true
            elseif getgenv()._ExeIntroEnabled ~= nil then
                introEnabled = getgenv()._ExeIntroEnabled == true
            end
        end
    end)
    if true then
        return
    end
    local ok, err = pcall(function()
        if type(playIntroAnimation)=="function" then
            playIntroAnimation()
        else
            error("playIntroAnimation missing")
        end
    end)
    if not ok then
        warn("[EXE DUELS] Intro failed: " .. tostring(err))
    end
end)


function integrateWuzzModules()
    local root = player:FindFirstChild("PlayerGui")
    local wuzz = root and root:FindFirstChild("WuzzDuels")
    local main = wuzz and wuzz:FindFirstChild("WuzzDuelsMain")
    local holder = main and main:FindFirstChild("ModuleContent")
    if not holder then return false end
    local map = {Main="Movement",Combat="Combat",Visuals="Visuals",Config="Settings"}
    local legacy = mainGuiRef
    if not legacy or not legacy.Parent then return false end
    local originalFrame = legacy:FindFirstChild("Main")
    if not originalFrame then return false end
    for oldName,newName in pairs(map) do
        local oldPage = originalFrame:FindFirstChild("Page_"..oldName)
        local target = holder.ContentFrame:FindFirstChild(newName.."Page")
        if oldPage and target then
            oldPage.Parent = target
            oldPage.Position = UDim2.fromOffset(0,0)
            oldPage.Size = UDim2.fromScale(1,1)
            oldPage.Visible = true
            oldPage.Active = true
            oldPage.AutomaticCanvasSize = Enum.AutomaticSize.Y
            oldPage.CanvasSize = UDim2.fromOffset(0,0)
            oldPage.ScrollBarImageColor3 = Color3.fromRGB(163,94,255)
            oldPage.ScrollBarThickness = 3
        end
    end
    legacy:Destroy()
    mainGuiRef = nil
    mainFrame = nil
    return true
end
integrated = integrateWuzzModules()
if not integrated then
    task.defer(function()
        task.wait(0.25)
        integrateWuzzModules()
    end)
end


local searchEntries = {}
local searchOriginal = {}
local function indexWuzzSearch()
    table.clear(searchEntries)
    for _, category in ipairs({"Combat", "Movement", "Visuals", "Settings", "Keybinds"}) do
        local tab = pages[category]
        if tab then
            for _, frame in ipairs(tab:GetDescendants()) do
                if frame:IsA("Frame") and frame:FindFirstChildOfClass("UIStroke") and frame.Size.Y.Offset >= 25 then
                    local title
                    for _, label in ipairs(frame:GetChildren()) do
                        if label:IsA("TextLabel") and label.Text ~= "" then
                            title = label.Text
                            break
                        end
                    end
                    if title then
                        table.insert(searchEntries, {node = frame, text = string.lower(title), category = category})
                        if searchOriginal[frame] == nil then searchOriginal[frame] = frame.Visible end
                    end
                end
            end
        end
    end
end
local function applyWuzzSearch()
    local q = string.lower(search.Text):gsub("^%s+", ""):gsub("%s+$", "")
    local first
    for _, item in ipairs(searchEntries) do
        local match = q == "" or string.find(item.text, q, 1, true) ~= nil
        if item.node.Parent then
            item.node.Visible = match and searchOriginal[item.node]
            if q ~= "" and match and not first then first = item.category end
        end
    end
    if q ~= "" and first then activate(first) end
end
_wuzzTrack(search:GetPropertyChangedSignal("Text"):Connect(applyWuzzSearch))
indexWuzzSearch()
