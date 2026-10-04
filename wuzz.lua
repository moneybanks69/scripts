local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local TeleportService = game:GetService("TeleportService")
local TweenService = game:GetService("TweenService")
local TextChatService = game:GetService("TextChatService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ProximityPromptService = game:GetService("ProximityPromptService")
local CollectionService = game:GetService("CollectionService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer
local SAFE_BOOT = true

local CONFIG_FOLDER = "WuzzHub"
local CONFIG_FILE = CONFIG_FOLDER .. "/config.json"
local Config = {Toggles = {}, Sliders = {}, Keybinds = {}, UI = {Scale = 1, Locked = false, Positions = {}}}
local function saveConfig()
    if not writefile then return end
    pcall(function()
        if makefolder then
            local exists = false
            if isfolder then
                local ok, result = pcall(isfolder, CONFIG_FOLDER)
                exists = ok and result == true
            end
            if not exists then
                pcall(makefolder, CONFIG_FOLDER)
            end
        end
        writefile(CONFIG_FILE, HttpService:JSONEncode(Config))
    end)
end
pcall(function()
    if readfile and isfile and isfile(CONFIG_FILE) then
        local loaded = HttpService:JSONDecode(readfile(CONFIG_FILE))
        if type(loaded) == "table" then
            Config.Toggles = type(loaded.Toggles) == "table" and loaded.Toggles or {}
            Config.Sliders = type(loaded.Sliders) == "table" and loaded.Sliders or {}
            Config.Keybinds = type(loaded.Keybinds) == "table" and loaded.Keybinds or {}
            Config.UI = type(loaded.UI) == "table" and loaded.UI or {Scale = 1, Locked = false, Positions = {}}
        end
    end
end)
if Config.Toggles["Instant Steal"] == nil and Config.Toggles["Auto Grab"] ~= nil then
    Config.Toggles["Instant Steal"] = Config.Toggles["Auto Grab"]
end
if Config.Keybinds["Instant Steal"] == nil and Config.Keybinds["Auto Grab"] ~= nil then
    Config.Keybinds["Instant Steal"] = Config.Keybinds["Auto Grab"]
end
Config.Toggles["Auto Grab"] = nil
Config.Keybinds["Auto Grab"] = nil
Config.Keybinds["Instant Reset"] = Config.Keybinds["Fling Up"] or "B"
Config.Toggles["Instant Reset"] = false
if Config.Toggles["XRay Plots"] == nil and Config.Toggles["Xray Bases"] ~= nil then
    Config.Toggles["XRay Plots"] = Config.Toggles["Xray Bases"]
end
local F = {}
Config.UI = type(Config.UI) == "table" and Config.UI or {}
Config.UI.Scale = tonumber(Config.UI.Scale) or 1
Config.UI.Locked = Config.UI.Locked == true
Config.UI.Positions = type(Config.UI.Positions) == "table" and Config.UI.Positions or {}
local ScalableGui = {}
local GuiPositionLocked = Config.UI.Locked
local GuiScaleValue = math.clamp(Config.UI.Scale, 0.6, 1.4)

function F.registerScalable(object, key)
if not object then return end
ScalableGui[object] = key or object.Name
local scale = object:FindFirstChild("_WuzzUIScale")
if not scale then
scale = Instance.new("UIScale")
scale.Name = "_WuzzUIScale"
scale.Parent = object
end
scale.Scale = GuiScaleValue
end

function F.setGuiScale(value)
GuiScaleValue = math.clamp(tonumber(value) or 1, 0.6, 1.4)
Config.UI.Scale = GuiScaleValue
for object in pairs(ScalableGui) do
if object and object.Parent then
local scale = object:FindFirstChild("_WuzzUIScale")
if not scale then
scale = Instance.new("UIScale")
scale.Name = "_WuzzUIScale"
scale.Parent = object
end
scale.Scale = GuiScaleValue
end
end
saveConfig()
end

function F.setGuiLocked(state)
GuiPositionLocked = not not state
Config.UI.Locked = GuiPositionLocked
saveConfig()
end
local old = game:GetService("CoreGui"):FindFirstChild("WuzzHub")
if old then
old:Destroy()
end
local Gui = Instance.new("ScreenGui")
Gui.Name = "WuzzHub"
Gui.ResetOnSpawn = false
Gui.IgnoreGuiInset = true
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
pcall(function()
Gui.Parent = game:GetService("CoreGui")
end)
if not Gui.Parent then
Gui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end
local C = {
Background = Color3.fromRGB(13, 7, 20),
Background2 = Color3.fromRGB(20, 10, 31),
Background3 = Color3.fromRGB(29, 14, 43),
Purple = Color3.fromRGB(165, 64, 255),
Purple2 = Color3.fromRGB(206, 113, 255),
Purple3 = Color3.fromRGB(112, 31, 194),
DarkPurple = Color3.fromRGB(54, 20, 82),
Text = Color3.fromRGB(248, 242, 255),
Muted = Color3.fromRGB(174, 155, 194),
Green = Color3.fromRGB(32, 180, 111),
Red = Color3.fromRGB(185, 43, 76),
Line = Color3.fromRGB(73, 37, 94)
}
function F.corner(obj, radius)
local x = Instance.new("UICorner")
x.CornerRadius = UDim.new(0, radius or 8)
x.Parent = obj
return x
end
function F.stroke(obj, thickness, color, transparency)
local x = Instance.new("UIStroke")
x.Thickness = thickness or 1
x.Color = color or C.Purple
x.Transparency = transparency or 0
x.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
x.Parent = obj
return x
end
function F.gradient(obj)
local g = Instance.new("UIGradient")
g.Color = ColorSequence.new({
ColorSequenceKeypoint.new(0, C.Purple3),
ColorSequenceKeypoint.new(.5, C.Purple2),
ColorSequenceKeypoint.new(1, C.Purple)
})
g.Rotation = 0
g.Parent = obj
task.spawn(function()
while g.Parent do
TweenService:Create(
g,
TweenInfo.new(2.7, Enum.EasingStyle.Linear),
{Rotation = g.Rotation + 360}
):Play()
task.wait(2.7)
end
end)
return g
end
function F.animatedStroke(obj, thickness)
local s = F.stroke(obj, thickness or 1.4, C.Purple, 0.12)
task.spawn(function()
while s.Parent do
TweenService:Create(
s,
TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
{Color = C.Purple2, Transparency = 0}
):Play()
task.wait(1.2)
if not s.Parent then
break
end
TweenService:Create(
s,
TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
{Color = C.Purple3, Transparency = 0.3}
):Play()
task.wait(1.2)
end
end)
return s
end
function F.label(parent, text, size, position, fontSize, bold)
local l = Instance.new("TextLabel")
l.BackgroundTransparency = 1
l.Text = text
l.TextColor3 = C.Text
l.Font = bold and Enum.Font.GothamBold or Enum.Font.Gotham
l.TextSize = fontSize or 13
l.TextXAlignment = Enum.TextXAlignment.Left
l.Size = size
l.Position = position
l.Parent = parent
return l
end
function F.particleLayer(parent)
local layer = Instance.new("Frame")
layer.Name = "Particles"
layer.BackgroundTransparency = 1
layer.ClipsDescendants = true
layer.Size = UDim2.fromScale(1, 1)
layer.ZIndex = 2
layer.Parent = parent
task.spawn(function()
while layer.Parent do
local p = Instance.new("Frame")
local s = math.random(2, 5)
p.AnchorPoint = Vector2.new(.5, .5)
p.Size = UDim2.fromOffset(s, s)
p.Position = UDim2.new(
math.random(0, 1000) / 1000,
0,
1.05,
0
)
p.BackgroundColor3 = math.random(1, 2) == 1 and C.Purple or C.Purple2
p.BackgroundTransparency = math.random(20, 65) / 100
p.BorderSizePixel = 0
p.ZIndex = 2
F.corner(p, 100)
p.Parent = layer
local duration = math.random(35, 70) / 10
TweenService:Create(
p,
TweenInfo.new(duration, Enum.EasingStyle.Linear),
{
Position = UDim2.new(
math.clamp(p.Position.X.Scale + math.random(-160, 160) / 1000, 0, 1),
0,
-0.08,
0
),
BackgroundTransparency = 1
}
):Play()
task.delay(duration, function()
if p then
p:Destroy()
end
end)
task.wait(math.random(10, 28) / 100)
end
end)
end
function F.makeDraggable(frame, dragHandle)
local dragging = false
local startInput
local startPos
dragHandle.InputBegan:Connect(function(input)
if GuiPositionLocked then return end
if input.UserInputType == Enum.UserInputType.MouseButton1 then
dragging = true
startInput = input.Position
startPos = frame.Position
end
end)
UserInputService.InputChanged:Connect(function(input)
if not dragging or GuiPositionLocked then return end
if input.UserInputType == Enum.UserInputType.MouseMovement then
local delta = input.Position - startInput
frame.Position = UDim2.new(
startPos.X.Scale,
startPos.X.Offset + delta.X,
startPos.Y.Scale,
startPos.Y.Offset + delta.Y
)
end
end)
UserInputService.InputEnded:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseButton1 and dragging then
dragging = false
local p = frame.Position
Config.UI.Positions[frame.Name] = {p.X.Scale, p.X.Offset, p.Y.Scale, p.Y.Offset}
saveConfig()
end
end)
end
function F.createPanel(title, abbreviation, position, size)
local frame = Instance.new("Frame")
frame.Name = title:gsub("%s", "")
frame.BackgroundColor3 = C.Background
frame.BackgroundTransparency = 0.03
frame.BorderSizePixel = 0
local savedPosition = Config.UI.Positions[frame.Name]
if type(savedPosition) == "table" and #savedPosition >= 4 then
frame.Position = UDim2.new(tonumber(savedPosition[1]) or position.X.Scale, tonumber(savedPosition[2]) or position.X.Offset, tonumber(savedPosition[3]) or position.Y.Scale, tonumber(savedPosition[4]) or position.Y.Offset)
else
frame.Position = position
end
frame.Size = size
frame.ClipsDescendants = true
frame.Parent = Gui
F.registerScalable(frame, frame.Name)
F.corner(frame, 12)
F.animatedStroke(frame, 1.5)
F.particleLayer(frame)
local top = Instance.new("Frame")
top.Name = "Top"
top.BackgroundColor3 = C.Background2
top.BorderSizePixel = 0
top.Size = UDim2.new(1, 0, 0, 42)
top.ZIndex = 5
top.Parent = frame
F.corner(top, 12)
local blocker = Instance.new("Frame")
blocker.BackgroundColor3 = C.Background2
blocker.BorderSizePixel = 0
blocker.Position = UDim2.new(0, 0, 1, -12)
blocker.Size = UDim2.new(1, 0, 0, 12)
blocker.ZIndex = 5
blocker.Parent = top
local icon = Instance.new("Frame")
icon.BackgroundColor3 = C.DarkPurple
icon.Size = UDim2.fromOffset(27, 27)
icon.Position = UDim2.fromOffset(9, 7)
icon.BorderSizePixel = 0
icon.ZIndex = 7
icon.Parent = top
F.corner(icon, 7)
F.animatedStroke(icon, 1.2)
local il = F.label(
icon,
abbreviation,
UDim2.fromScale(1, 1),
UDim2.fromScale(0, 0),
10,
true
)
il.TextXAlignment = Enum.TextXAlignment.Center
il.TextYAlignment = Enum.TextYAlignment.Center
il.ZIndex = 8
local titleLabel = F.label(
top,
string.upper(title),
UDim2.new(1, -80, 1, 0),
UDim2.fromOffset(45, 0),
12,
true
)
titleLabel.TextYAlignment = Enum.TextYAlignment.Center
titleLabel.ZIndex = 7
local collapse = Instance.new("TextButton")
collapse.BackgroundColor3 = C.DarkPurple
collapse.BorderSizePixel = 0
collapse.Size = UDim2.fromOffset(24, 24)
collapse.Position = UDim2.new(1, -32, 0, 9)
collapse.Text = "−"
collapse.TextColor3 = C.Text
collapse.Font = Enum.Font.GothamBold
collapse.TextSize = 14
collapse.AutoButtonColor = false
collapse.ZIndex = 7
collapse.Parent = top
F.corner(collapse, 6)
F.stroke(collapse, 1, C.Purple3, .3)
local body = Instance.new("Frame")
body.Name = "Body"
body.BackgroundTransparency = 1
body.Position = UDim2.fromOffset(8, 49)
body.Size = UDim2.new(1, -16, 1, -57)
body.ZIndex = 4
body.Parent = frame
local expanded = true
local originalSize = size
collapse.MouseButton1Click:Connect(function()
expanded = not expanded
if expanded then
collapse.Text = "−"
blocker.Visible = true
TweenService:Create(
frame,
TweenInfo.new(.25, Enum.EasingStyle.Quart),
{Size = originalSize}
):Play()
body.Visible = true
else
collapse.Text = "+"
body.Visible = false
blocker.Visible = false
TweenService:Create(
frame,
TweenInfo.new(.25, Enum.EasingStyle.Quart),
{Size = UDim2.new(originalSize.X.Scale, originalSize.X.Offset, 0, 42)}
):Play()
end
end)
F.makeDraggable(frame, top)
return frame, body
end
function F.makeSectionLayout(body)
local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 7)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = body
return layout
end
local ToggleActions = {}
local KeybindCallbacks = {}
local KeybindEntries = {}
local ListeningKeybind = nil
function F.makeToggle(parent, name, state, onChanged)
if Config.Toggles[name] ~= nil then
state = Config.Toggles[name] == true
else
state = not not state
Config.Toggles[name] = state
saveConfig()
end
local row = Instance.new("Frame")
row.BackgroundColor3 = C.Background3
row.BackgroundTransparency = .1
row.BorderSizePixel = 0
row.Size = UDim2.new(1, 0, 0, 31)
row.Parent = parent
F.corner(row, 7)
F.stroke(row, 1, C.Line, .15)
local nameLabel = F.label(
row,
name,
UDim2.new(1, -70, 1, 0),
UDim2.fromOffset(10, 0),
10,
true
)
nameLabel.TextYAlignment = Enum.TextYAlignment.Center
local button = Instance.new("TextButton")
button.AutoButtonColor = false
button.BackgroundColor3 = state and C.Green or C.DarkPurple
button.BorderSizePixel = 0
button.Position = UDim2.new(1, -63, .5, -10)
button.Size = UDim2.fromOffset(54, 20)
button.Font = Enum.Font.GothamBold
button.Text = state and "ON" or "OFF"
button.TextColor3 = C.Text
button.TextSize = 9
button.Parent = row
F.corner(button, 6)
F.stroke(button, 1, state and Color3.fromRGB(42, 239, 157) or C.Purple3, .25)
local enabled = state
local function setEnabled(newState)
enabled = not not newState
Config.Toggles[name] = enabled
saveConfig()
button.Text = enabled and "ON" or "OFF"
TweenService:Create(
button,
TweenInfo.new(.18),
{BackgroundColor3 = enabled and C.Green or C.DarkPurple}
):Play()
if onChanged then
task.spawn(onChanged, enabled)
end
end
local function toggle()
setEnabled(not enabled)
end
button.MouseButton1Click:Connect(toggle)
ToggleActions[name] = toggle
task.defer(function()
if onChanged then
onChanged(enabled)
end
end)
return row, button, toggle, setEnabled
end
function F.keyName(code)
return code and code.Name or "NONE"
end
UserInputService.InputBegan:Connect(function(input, gameProcessed)
if input.UserInputType ~= Enum.UserInputType.Keyboard then
return
end
if ListeningKeybind then
if input.KeyCode == Enum.KeyCode.Escape then
ListeningKeybind.button.Text = F.keyName(ListeningKeybind.keyCode)
ListeningKeybind = nil
return
end
if input.KeyCode == Enum.KeyCode.Backspace or input.KeyCode == Enum.KeyCode.Delete then
ListeningKeybind.keyCode = nil
Config.Keybinds[ListeningKeybind.name] = "NONE"
saveConfig()
ListeningKeybind.button.Text = "NONE"
ListeningKeybind = nil
return
end
if input.KeyCode ~= Enum.KeyCode.Unknown then
ListeningKeybind.keyCode = input.KeyCode
Config.Keybinds[ListeningKeybind.name] = input.KeyCode.Name
saveConfig()
ListeningKeybind.button.Text = input.KeyCode.Name
ListeningKeybind = nil
end
return
end
if gameProcessed then
return
end
for _, entry in ipairs(KeybindEntries) do
if entry.keyCode and entry.keyCode == input.KeyCode then
local callback = KeybindCallbacks[entry.name] or ToggleActions[entry.name]
if callback then
task.spawn(callback)
end
end
end
end)
function F.makeKeybind(parent, name, key)
key = Config.Keybinds[name] or key
local row = Instance.new("Frame")
row.BackgroundColor3 = C.Background3
row.BackgroundTransparency = .1
row.BorderSizePixel = 0
row.Size = UDim2.new(1, 0, 0, 31)
row.Parent = parent
F.corner(row, 7)
F.stroke(row, 1, C.Line, .15)
local a = F.label(
row,
name,
UDim2.new(.68, 0, 1, 0),
UDim2.fromOffset(10, 0),
9,
true
)
a.TextYAlignment = Enum.TextYAlignment.Center
local b = Instance.new("TextButton")
b.AutoButtonColor = false
b.BackgroundColor3 = C.DarkPurple
b.BorderSizePixel = 0
b.Position = UDim2.new(.7, 0, .5, -10)
b.Size = UDim2.new(.3, -8, 0, 20)
b.Font = Enum.Font.GothamBold
b.Text = key
b.TextColor3 = C.Purple2
b.TextSize = 8
b.Parent = row
F.corner(b, 6)
F.stroke(b, 1, C.Purple3, .25)
local entry = {
name = name,
keyCode = (key ~= "NONE" and Enum.KeyCode[key]) or nil,
button = b
}
table.insert(KeybindEntries, entry)
b.MouseButton1Click:Connect(function()
if ListeningKeybind and ListeningKeybind ~= entry then
ListeningKeybind.button.Text = F.keyName(ListeningKeybind.keyCode)
end
ListeningKeybind = entry
b.Text = "..."
end)
return row, entry
end
local SliderValues = {}
local SliderSetters = {}
function F.makeSlider(parent, name, value, minValue, maxValue, onChanged, step)
if Config.Sliders[name] ~= nil then value = tonumber(Config.Sliders[name]) or value end
minValue = minValue or 0
maxValue = maxValue or 100
step = step or 1
local row = Instance.new("Frame")
row.BackgroundColor3 = C.Background3
row.BackgroundTransparency = .1
row.BorderSizePixel = 0
row.Size = UDim2.new(1, 0, 0, 42)
row.Parent = parent
F.corner(row, 7)
F.stroke(row, 1, C.Line, .15)
local n = F.label(
row,
name,
UDim2.new(.6, 0, 0, 19),
UDim2.fromOffset(10, 2),
9,
true
)
local valueLabel = F.label(
row,
tostring(value),
UDim2.fromOffset(52, 19),
UDim2.new(1, -59, 0, 2),
9,
true
)
valueLabel.TextXAlignment = Enum.TextXAlignment.Right
valueLabel.TextColor3 = C.Purple2
local bar = Instance.new("Frame")
bar.BackgroundColor3 = C.DarkPurple
bar.BorderSizePixel = 0
bar.Position = UDim2.new(0, 10, 1, -13)
bar.Size = UDim2.new(1, -20, 0, 4)
bar.Active = true
bar.Parent = row
F.corner(bar, 4)
local fill = Instance.new("Frame")
fill.BackgroundColor3 = C.Purple
fill.BorderSizePixel = 0
fill.Parent = bar
F.corner(fill, 4)
local knob = Instance.new("Frame")
knob.AnchorPoint = Vector2.new(.5, .5)
knob.BackgroundColor3 = C.Text
knob.BorderSizePixel = 0
knob.Size = UDim2.fromOffset(10, 10)
knob.Active = true
knob.Parent = bar
F.corner(knob, 10)
F.stroke(knob, 2, C.Purple, 0)
local currentValue = value
local dragging = false
local function formatValue(v)
if math.abs(v - math.round(v)) < 0.001 then
return tostring(math.round(v))
end
return string.format("%.1f", v)
end
local function setValue(newValue, fireCallback)
newValue = math.clamp(tonumber(newValue) or minValue, minValue, maxValue)
if step > 0 then
newValue = math.round(newValue / step) * step
newValue = math.clamp(newValue, minValue, maxValue)
end
currentValue = newValue
SliderValues[name] = currentValue
Config.Sliders[name] = currentValue
saveConfig()
local alpha = 0
if maxValue > minValue then
alpha = (currentValue - minValue) / (maxValue - minValue)
end
fill.Size = UDim2.new(alpha, 0, 1, 0)
knob.Position = UDim2.new(alpha, 0, .5, 0)
valueLabel.Text = formatValue(currentValue)
if fireCallback ~= false and onChanged then
task.spawn(onChanged, currentValue)
end
end
local function setFromX(x)
if bar.AbsoluteSize.X <= 0 then
return
end
local alpha = math.clamp((x - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
setValue(minValue + ((maxValue - minValue) * alpha), true)
end
bar.InputBegan:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseButton1
or input.UserInputType == Enum.UserInputType.Touch then
dragging = true
setFromX(input.Position.X)
end
end)
knob.InputBegan:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseButton1
or input.UserInputType == Enum.UserInputType.Touch then
dragging = true
setFromX(input.Position.X)
end
end)
UserInputService.InputChanged:Connect(function(input)
if not dragging then
return
end
if input.UserInputType == Enum.UserInputType.MouseMovement
or input.UserInputType == Enum.UserInputType.Touch then
setFromX(input.Position.X)
end
end)
UserInputService.InputEnded:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseButton1
or input.UserInputType == Enum.UserInputType.Touch then
dragging = false
end
end)
SliderSetters[name] = setValue
setValue(value, false)
if onChanged then
task.defer(onChanged, currentValue)
end
return row, function()
return currentValue
end, setValue
end
function F.makeButton(parent, text)
local b = Instance.new("TextButton")
b.AutoButtonColor = false
b.BackgroundColor3 = C.DarkPurple
b.BorderSizePixel = 0
b.Size = UDim2.new(1, 0, 0, 29)
b.Font = Enum.Font.GothamBold
b.Text = text
b.TextColor3 = C.Text
b.TextSize = 9
b.Parent = parent
F.corner(b, 7)
F.stroke(b, 1, C.Purple3, .15)
b.MouseEnter:Connect(function()
TweenService:Create(
b,
TweenInfo.new(.14),
{BackgroundColor3 = Color3.fromRGB(83, 27, 120)}
):Play()
end)
b.MouseLeave:Connect(function()
TweenService:Create(
b,
TweenInfo.new(.14),
{BackgroundColor3 = C.DarkPurple}
):Play()
end)
return b
end
function F.buildServerPanel()
local serverJob, serverJobBody = F.createPanel(
"Server Job ID",
"ID",
UDim2.new(.5, -220, 0, 20),
UDim2.fromOffset(440, 146)
)
local currentJobLabel = F.label(
serverJobBody,
"JOB ID",
UDim2.new(1, 0, 0, 16),
UDim2.fromOffset(0, 0),
9,
true
)
currentJobLabel.TextColor3 = C.Muted
local currentJobBox = Instance.new("TextBox")
currentJobBox.BackgroundColor3 = C.Background3
currentJobBox.BackgroundTransparency = .08
currentJobBox.BorderSizePixel = 0
currentJobBox.Position = UDim2.fromOffset(0, 18)
currentJobBox.Size = UDim2.new(1, 0, 0, 34)
currentJobBox.ClearTextOnFocus = false
currentJobBox.Text = game.JobId ~= "" and game.JobId or ""
currentJobBox.PlaceholderText = "Paste a server Job ID..."
currentJobBox.TextColor3 = C.Text
currentJobBox.PlaceholderColor3 = C.Muted
currentJobBox.Font = Enum.Font.Code
currentJobBox.TextSize = 10
currentJobBox.TextXAlignment = Enum.TextXAlignment.Left
currentJobBox.Parent = serverJobBody
F.corner(currentJobBox, 7)
F.stroke(currentJobBox, 1, C.Line, .15)
local currentPadding = Instance.new("UIPadding")
currentPadding.PaddingLeft = UDim.new(0, 10)
currentPadding.PaddingRight = UDim.new(0, 10)
currentPadding.Parent = currentJobBox
local serverButtons = Instance.new("Frame")
serverButtons.BackgroundTransparency = 1
serverButtons.Position = UDim2.fromOffset(0, 59)
serverButtons.Size = UDim2.new(1, 0, 0, 30)
serverButtons.Parent = serverJobBody
local copyJobButton = Instance.new("TextButton")
copyJobButton.AutoButtonColor = false
copyJobButton.BackgroundColor3 = C.DarkPurple
copyJobButton.BorderSizePixel = 0
copyJobButton.Size = UDim2.new(.49, 0, 1, 0)
copyJobButton.Text = "COPY JOB ID"
copyJobButton.TextColor3 = C.Text
copyJobButton.Font = Enum.Font.GothamBold
copyJobButton.TextSize = 9
copyJobButton.Parent = serverButtons
F.corner(copyJobButton, 7)
F.stroke(copyJobButton, 1, C.Purple3, .15)
local joinJobButton = Instance.new("TextButton")
joinJobButton.AutoButtonColor = false
joinJobButton.BackgroundColor3 = C.DarkPurple
joinJobButton.BorderSizePixel = 0
joinJobButton.Position = UDim2.new(.51, 0, 0, 0)
joinJobButton.Size = UDim2.new(.49, 0, 1, 0)
joinJobButton.Text = "JOIN SERVER"
joinJobButton.TextColor3 = C.Text
joinJobButton.Font = Enum.Font.GothamBold
joinJobButton.TextSize = 9
joinJobButton.Parent = serverButtons
F.corner(joinJobButton, 7)
F.stroke(joinJobButton, 1, C.Purple3, .15)
function F.pulseServerButton(button, text, resetText)
button.Text = text
task.delay(1.2, function()
if button and button.Parent then
button.Text = resetText
end
end)
end
copyJobButton.MouseButton1Click:Connect(function()
local jobId = currentJobBox.Text:gsub("%s+", "")
if jobId == "" then
F.pulseServerButton(copyJobButton, "NO JOB ID", "COPY JOB ID")
return
end
local copied = false
if setclipboard then
copied = pcall(setclipboard, jobId)
elseif toclipboard then
copied = pcall(toclipboard, jobId)
end
if copied then
F.pulseServerButton(copyJobButton, "COPIED!", "COPY JOB ID")
else
currentJobBox:CaptureFocus()
currentJobBox.CursorPosition = #currentJobBox.Text + 1
currentJobBox.SelectionStart = 1
F.pulseServerButton(copyJobButton, "SELECTED", "COPY JOB ID")
end
end)
joinJobButton.MouseButton1Click:Connect(function()
local jobId = currentJobBox.Text:gsub("%s+", "")
if jobId == "" then
F.pulseServerButton(joinJobButton, "ENTER JOB ID", "JOIN SERVER")
return
end
joinJobButton.Text = "JOINING..."
local ok, err = pcall(function()
TeleportService:TeleportToPlaceInstance(
game.PlaceId,
jobId,
LocalPlayer
)
end)
if not ok then
warn("Wuzz Hub Job ID teleport failed:", err)
F.pulseServerButton(joinJobButton, "FAILED", "JOIN SERVER")
end
end)
for _, button in ipairs({copyJobButton, joinJobButton}) do
button.MouseEnter:Connect(function()
TweenService:Create(
button,
TweenInfo.new(.14),
{BackgroundColor3 = Color3.fromRGB(83, 27, 120)}
):Play()
end)
button.MouseLeave:Connect(function()
TweenService:Create(
button,
TweenInfo.new(.14),
{BackgroundColor3 = C.DarkPurple}
):Play()
end)
end
end
do
local ok, err = pcall(F.buildServerPanel)
if not ok then
warn("[WuzzHub] Server panel failed:", err)
end
end
local SetAntiRagdollImported
local GetAntiRagdollImported
do
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local Player = Players.LocalPlayer
local CharacterController
pcall(function()
local controllers = ReplicatedStorage:FindFirstChild("Controllers")
if not controllers then
controllers = ReplicatedStorage:WaitForChild("Controllers", 2)
end
local module = controllers and (controllers:FindFirstChild("CharacterController") or controllers:WaitForChild("CharacterController", 2))
if module then
CharacterController = require(module)
end
end)
local AntiRagdoll = false
local RagdollActive = false
local CharacterConnections = {}
local PreSimulationConnection
local PostSimulationConnection
local MovementConnection
local CharacterConnection
local MotorCache = {}
local Recovering = false
local LastRagdollSignal = 0
local AllowedExtraKnockback = 0
local MaxUpwardKnockback = 0
local MaxAngularVelocity = 0
local RagdollGraceTime = 0
local RagdollLockUntil = 0
local MinimumRagdollLock = 0.3
local LastWalkSpeed = 16
local BadStates = {
[Enum.HumanoidStateType.Physics] = true,
[Enum.HumanoidStateType.Ragdoll] = true,
[Enum.HumanoidStateType.FallingDown] = true
}
function F.GetCharacter()
return Player.Character
end
function F.GetHumanoid()
local Character = F.GetCharacter()
if not Character then
return nil
end
return Character:FindFirstChildWhichIsA("Humanoid")
end
function F.GetRoot()
local Character = F.GetCharacter()
if not Character then
return nil
end
return Character:FindFirstChild("HumanoidRootPart")
end
function F.EnableControls()
if not CharacterController then
return
end
pcall(function()
if CharacterController.Controls then
CharacterController.Controls:Enable()
end
end)
end
function F.DisconnectCharacterConnections()
for _, Connection in ipairs(CharacterConnections) do
pcall(function()
Connection:Disconnect()
end)
end
table.clear(CharacterConnections)
end
function F.CacheMotors()
table.clear(MotorCache)
local Character = F.GetCharacter()
if not Character then
return
end
for _, Object in ipairs(Character:GetDescendants()) do
if Object:IsA("Motor6D") then
table.insert(MotorCache, {
Name = Object.Name,
Parent = Object.Parent,
Part0 = Object.Part0,
Part1 = Object.Part1,
C0 = Object.C0,
C1 = Object.C1
})
end
end
end
function F.FindMotor(Data)
if not Data.Parent or not Data.Parent.Parent then
return nil
end
for _, Object in ipairs(Data.Parent:GetChildren()) do
if Object:IsA("Motor6D")
and Object.Name == Data.Name
and Object.Part0 == Data.Part0
and Object.Part1 == Data.Part1 then
return Object
end
end
return nil
end
function F.RestoreMotors()
if not AntiRagdoll then
return
end
for _, Data in ipairs(MotorCache) do
if Data.Parent
and Data.Parent.Parent
and Data.Part0
and Data.Part0.Parent
and Data.Part1
and Data.Part1.Parent then
local Motor = F.FindMotor(Data)
if Motor then
pcall(function()
Motor.Enabled = true
end)
else
pcall(function()
local Motor =
Instance.new("Motor6D")
Motor.Name = Data.Name
Motor.Part0 = Data.Part0
Motor.Part1 = Data.Part1
Motor.C0 = Data.C0
Motor.C1 = Data.C1
Motor.Parent = Data.Parent
end)
end
end
end
end
function F.IsRagdollConstraint(Object)
if not (
Object:IsA("BallSocketConstraint")
or Object:IsA("HingeConstraint")
or Object:IsA("NoCollisionConstraint")
or Object:IsA("RodConstraint")
or Object:IsA("SpringConstraint")
) then
return false
end
return string.find(
string.lower(Object.Name),
"ragdoll",
1,
true
) ~= nil
end
function F.FixObject(Object)
if not AntiRagdoll then
return
end
if Object:IsA("Motor6D") then
pcall(function()
Object.Enabled = true
end)
return
end
if F.IsRagdollConstraint(Object) then
pcall(function()
Object.Enabled = false
end)
end
end
function F.AttributeSaysRagdoll()
local EndTime =
Player:GetAttribute("RagdollEndTime")
if type(EndTime) ~= "number" then
return false
end
return EndTime >
workspace:GetServerTimeNow()
end
function F.IsRagdolling()
if F.Resetting then return false end
if F.AttributeSaysRagdoll() then
return true
end
local Humanoid = F.GetHumanoid()
if Humanoid then
if Humanoid.PlatformStand then
return true
end
if BadStates[Humanoid:GetState()] then
return true
end
end
if os.clock() < RagdollLockUntil then
return true
end
if os.clock() - LastRagdollSignal <
RagdollGraceTime then
return true
end
return false
end
function F.GetInputDirection()
local X = 0
local ForwardAmount = 0
if UserInputService:IsKeyDown(Enum.KeyCode.W) then
ForwardAmount += 1
end
if UserInputService:IsKeyDown(Enum.KeyCode.S) then
ForwardAmount -= 1
end
if UserInputService:IsKeyDown(Enum.KeyCode.D) then
X += 1
end
if UserInputService:IsKeyDown(Enum.KeyCode.A) then
X -= 1
end
if X == 0 and ForwardAmount == 0 then
return Vector3.zero
end
local Camera = workspace.CurrentCamera
if not Camera then
return Vector3.new(X, 0, -ForwardAmount).Unit
end
local Forward = Vector3.new(
Camera.CFrame.LookVector.X,
0,
Camera.CFrame.LookVector.Z
)
local Right = Vector3.new(
Camera.CFrame.RightVector.X,
0,
Camera.CFrame.RightVector.Z
)
if Forward.Magnitude <= 0.001 then
Forward = Vector3.new(0, 0, -1)
else
Forward = Forward.Unit
end
if Right.Magnitude <= 0.001 then
Right = Vector3.new(1, 0, 0)
else
Right = Right.Unit
end
local Direction = Right * X + Forward * ForwardAmount
if Direction.Magnitude > 1 then
Direction = Direction.Unit
end
return Direction
end
function F.GetMovementSpeed(Humanoid)
local Speed = Humanoid.WalkSpeed
if Speed > 0.1 then
LastWalkSpeed = Speed
else
Speed = LastWalkSpeed
end
return math.max(Speed, 1)
end
function F.GetMovementVelocity(Humanoid)
local Direction = F.GetInputDirection()
if Direction.Magnitude <= 0.001 then
Direction = Humanoid.MoveDirection
end
if Direction.Magnitude <= 0.001 then
return Vector3.zero
end
if Direction.Magnitude > 1 then
Direction = Direction.Unit
end
return Direction * F.GetMovementSpeed(Humanoid)
end
function F.ForceMovement(DeltaTime)
if not AntiRagdoll or not RagdollActive then
return
end
local Root = F.GetRoot()
local Humanoid = F.GetHumanoid()
if not Root or not Humanoid then
return
end
local Direction = F.GetInputDirection()
pcall(function()
Humanoid.PlatformStand = false
Humanoid.Sit = false
Humanoid.AutoRotate = true
Humanoid:Move(Direction, false)
end)
if Direction.Magnitude <= 0.001 then
return
end
local Speed = F.GetMovementSpeed(Humanoid)
local CurrentVelocity = Root.AssemblyLinearVelocity
local CurrentHorizontal = Vector3.new(
CurrentVelocity.X,
0,
CurrentVelocity.Z
)
pcall(function()
Root.Anchored = false
if CurrentHorizontal.Magnitude < Speed * 0.25 then
Root.CFrame = Root.CFrame + Direction * Speed * DeltaTime
end
Root.AssemblyLinearVelocity = Vector3.new(
Direction.X * Speed,
math.min(CurrentVelocity.Y, 0),
Direction.Z * Speed
)
end)
end
function F.StopKnockback()
if not AntiRagdoll
or not RagdollActive then
return
end
local Root = F.GetRoot()
local Humanoid = F.GetHumanoid()
if not Root or not Humanoid then
return
end
local Velocity =
Root.AssemblyLinearVelocity
local Horizontal =
Vector3.new(
Velocity.X,
0,
Velocity.Z
)
local MovementVelocity =
F.GetMovementVelocity(Humanoid)
local ExtraVelocity =
Horizontal - MovementVelocity
if ExtraVelocity.Magnitude >
AllowedExtraKnockback then
ExtraVelocity =
ExtraVelocity.Unit *
AllowedExtraKnockback
end
local FinalVelocity =
MovementVelocity +
ExtraVelocity
local YVelocity =
Velocity.Y
if YVelocity >
MaxUpwardKnockback then
YVelocity =
MaxUpwardKnockback
end
pcall(function()
Root.AssemblyLinearVelocity =
Vector3.new(
FinalVelocity.X,
YVelocity,
FinalVelocity.Z
)
end)
local Angular =
Root.AssemblyAngularVelocity
if Angular.Magnitude >
MaxAngularVelocity then
pcall(function()
Root.AssemblyAngularVelocity =
Angular.Unit *
MaxAngularVelocity
end)
end
end
function F.FixHumanoid()
local Humanoid = F.GetHumanoid()
if not Humanoid then
return
end
pcall(function()
Humanoid.PlatformStand = false
Humanoid.Sit = false
Humanoid.AutoRotate = true
end)
local State =
Humanoid:GetState()
if BadStates[State] then
pcall(function()
Humanoid:ChangeState(
Enum.HumanoidStateType.Running
)
end)
end
end
function F.Recover()
if F.Resetting or not AntiRagdoll or Recovering then
return
end
local Character = F.GetCharacter()
local Humanoid = F.GetHumanoid()
if not Character or not Humanoid then
return
end
Recovering = true
F.RestoreMotors()
F.FixHumanoid()
local Head = Character:FindFirstChild("Head")
if Head and Head:IsA("BasePart") then
pcall(function()
Head.CanCollide = false
end)
end
local Root = F.GetRoot()
if Root then
pcall(function()
Root.CanCollide = false
end)
end
F.EnableControls()
pcall(function()
workspace.CurrentCamera.CameraSubject = Humanoid
end)
Recovering = false
end
function F.DisableRagdollStates()
local Humanoid = F.GetHumanoid()
if not Humanoid then
return
end
pcall(function()
Humanoid:SetStateEnabled(
Enum.HumanoidStateType.Ragdoll,
false
)
Humanoid:SetStateEnabled(
Enum.HumanoidStateType.FallingDown,
false
)
Humanoid:SetStateEnabled(
Enum.HumanoidStateType.GettingUp,
true
)
end)
end
function F.RestoreRagdollStates()
local Humanoid = F.GetHumanoid()
if not Humanoid then
return
end
pcall(function()
Humanoid:SetStateEnabled(
Enum.HumanoidStateType.Ragdoll,
true
)
Humanoid:SetStateEnabled(
Enum.HumanoidStateType.FallingDown,
true
)
Humanoid:SetStateEnabled(
Enum.HumanoidStateType.GettingUp,
true
)
end)
end
function F.KeepMovable()
if not AntiRagdoll then
return
end
local Root = F.GetRoot()
local Humanoid = F.GetHumanoid()
if not Root or not Humanoid then
return
end
pcall(function()
Root.Anchored = false
Root.CanCollide = false
Humanoid.PlatformStand = false
Humanoid.Sit = false
Humanoid.AutoRotate = true
end)
F.StopKnockback()
end
function F.ReleaseRoot()
RagdollLockUntil = 0
local Root = F.GetRoot()
if Root then
pcall(function()
Root.Anchored = false
Root.AssemblyAngularVelocity = Vector3.zero
end)
end
end
function F.StartRagdoll()
if F.Resetting then return end
LastRagdollSignal = os.clock()
RagdollLockUntil = math.max(RagdollLockUntil, os.clock() + MinimumRagdollLock)
RagdollActive = true
F.RestoreMotors()
F.FixHumanoid()
F.KeepMovable()
end
function F.StopRagdoll()
RagdollActive = false
F.ReleaseRoot()
F.FixHumanoid()
F.EnableControls()
end
function F.WatchCharacter()
F.DisconnectCharacterConnections()
local Character = F.GetCharacter()
if not Character then
return
end
local Humanoid =
Character:FindFirstChildWhichIsA(
"Humanoid"
)
or Character:WaitForChild(
"Humanoid",
5
)
local Root =
Character:FindFirstChild(
"HumanoidRootPart"
)
or Character:WaitForChild(
"HumanoidRootPart",
5
)
if not Humanoid or not Root then
return
end
if Humanoid.WalkSpeed > 0.1 then
LastWalkSpeed = Humanoid.WalkSpeed
end
local LastHealth = Humanoid.Health
F.CacheMotors()
F.DisableRagdollStates()
for _, Object in ipairs(
Character:GetDescendants()
) do
F.FixObject(Object)
end
table.insert(
CharacterConnections,
Character.DescendantAdded:Connect(
function(Object)
if not AntiRagdoll then
return
end
if F.IsRagdollConstraint(Object) then
F.StartRagdoll()
end
task.defer(function()
F.FixObject(Object)
F.RestoreMotors()
end)
end
)
)
table.insert(
CharacterConnections,
Humanoid.StateChanged:Connect(
function(_, NewState)
if not AntiRagdoll then
return
end
if BadStates[NewState] then
F.StartRagdoll()
task.defer(
F.Recover
)
end
end
)
)
table.insert(
CharacterConnections,
Humanoid:GetPropertyChangedSignal(
"PlatformStand"
):Connect(function()
if not AntiRagdoll then
return
end
if Humanoid.PlatformStand then
F.StartRagdoll()
task.defer(
F.Recover
)
end
end)
)
table.insert(
CharacterConnections,
Humanoid.HealthChanged:Connect(function(NewHealth)
if not AntiRagdoll then
LastHealth = NewHealth
return
end
if NewHealth < LastHealth then
F.StartRagdoll()
end
LastHealth = NewHealth
end)
)
table.insert(
CharacterConnections,
Player:GetAttributeChangedSignal(
"RagdollEndTime"
):Connect(function()
if not AntiRagdoll then
return
end
if F.AttributeSaysRagdoll() then
F.StartRagdoll()
end
end)
)
F.Recover()
end
function F.StartLoops()
if PreSimulationConnection then
PreSimulationConnection:Disconnect()
PreSimulationConnection = nil
end
if PostSimulationConnection then
PostSimulationConnection:Disconnect()
PostSimulationConnection = nil
end
if MovementConnection then
MovementConnection:Disconnect()
MovementConnection = nil
end
local LastMotorCheck = 0
PreSimulationConnection =
RunService.PreSimulation:Connect(
function()
if not AntiRagdoll or F.Resetting then
return
end
F.DisableRagdollStates()
local Ragdolling =
F.IsRagdolling()
if Ragdolling then
if not RagdollActive then
F.StartRagdoll()
end
F.KeepMovable()
F.FixHumanoid()
elseif RagdollActive then
F.StopRagdoll()
end
local Now = os.clock()
if Now -
LastMotorCheck >= 0.15 then
LastMotorCheck = Now
F.RestoreMotors()
end
end
)
PostSimulationConnection =
RunService.PostSimulation:Connect(
function()
if not AntiRagdoll or F.Resetting or not RagdollActive then
return
end
F.KeepMovable()
end
)
MovementConnection =
RunService.Heartbeat:Connect(
function(DeltaTime)
if F.Resetting then return end
F.ForceMovement(DeltaTime)
end
)
end
function F.SetAntiRagdoll(Value)
AntiRagdoll = Value
if AntiRagdoll then
RagdollActive = false
RagdollLockUntil = 0
LastRagdollSignal = 0
F.WatchCharacter()
F.StartLoops()
if F.IsRagdolling() then
F.StartRagdoll()
end
print(
"[Anti Ragdoll] ON"
)
else
RagdollActive = false
F.DisconnectCharacterConnections()
if PreSimulationConnection then
PreSimulationConnection:Disconnect()
PreSimulationConnection = nil
end
if PostSimulationConnection then
PostSimulationConnection:Disconnect()
PostSimulationConnection = nil
end
if MovementConnection then
MovementConnection:Disconnect()
MovementConnection = nil
end
F.RestoreRagdollStates()
F.ReleaseRoot()
F.EnableControls()
print(
"[Anti Ragdoll] OFF"
)
end
end
CharacterConnection =
Player.CharacterAdded:Connect(
function(Character)
RagdollActive = false
RagdollLockUntil = 0
table.clear(MotorCache)
if not AntiRagdoll then
return
end
Character:WaitForChild(
"Humanoid",
5
)
Character:WaitForChild(
"HumanoidRootPart",
5
)
task.wait(0.1)
if AntiRagdoll then
F.WatchCharacter()
end
end
)
SetAntiRagdollImported = F.SetAntiRagdoll
GetAntiRagdollImported = function() return AntiRagdoll end
end
local SetAutoTurretImported
do
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local ENABLED = false
local READY_DELAY = 3
local ATTACK_DELAY = 0.05
local attacking = {}
function F.getCharacter()
return Player.Character or Player.CharacterAdded:Wait()
end
function F.getHumanoid()
local character = F.getCharacter()
return character:FindFirstChildOfClass("Humanoid")
or character:WaitForChild("Humanoid", 5)
end
function F.getBat()
local character = F.getCharacter()
local bat = character:FindFirstChild("Bat")
if bat and bat:IsA("Tool") then
return bat
end
local backpack = Player:FindFirstChildOfClass("Backpack")
if backpack then
bat = backpack:FindFirstChild("Bat")
if bat and bat:IsA("Tool") then
return bat
end
end
return nil
end
function F.isSentry(object)
if not object or not object.Name or object.Name:sub(1, 7) ~= "Sentry_" then return false end
local suffix = object.Name:sub(8)
local myId = tostring(Player.UserId)
if suffix == myId or object.Name == ("Sentry_" .. myId) or string.find(suffix, myId, 1, true) then
return false
end
return true
end
function F.getBatHitboxes(bat)
local parts = {}
for _, object in ipairs(bat:GetDescendants()) do
if object:IsA("BasePart") then
table.insert(parts, object)
end
end
return parts
end
function F.getSentryParts(sentry)
local parts = {}
if sentry:IsA("BasePart") then
table.insert(parts, sentry)
end
for _, object in ipairs(sentry:GetDescendants()) do
if object:IsA("BasePart") then
table.insert(parts, object)
end
end
return parts
end
function F.touchPart(hitbox, target)
if not firetouchinterest then
return
end
pcall(function()
firetouchinterest(hitbox, target, 0)
task.wait()
firetouchinterest(hitbox, target, 1)
end)
end
function F.attackSentry(sentry)
if attacking[sentry] then
return
end
attacking[sentry] = true
task.wait(READY_DELAY)
if not ENABLED or not sentry or not sentry.Parent then
attacking[sentry] = nil
return
end
local humanoid = F.getHumanoid()
while ENABLED and sentry and sentry.Parent do
local character = F.getCharacter()
humanoid = F.getHumanoid()
local bat = F.getBat()
if not humanoid or not bat then
task.wait(0.1)
continue
end
if bat.Parent ~= character then
humanoid:EquipTool(bat)
task.wait(0.1)
end
pcall(function()
bat:Activate()
end)
local batParts = F.getBatHitboxes(bat)
local sentryParts = F.getSentryParts(sentry)
if firetouchinterest then
for _, hitbox in ipairs(batParts) do
for _, target in ipairs(sentryParts) do
if not ENABLED or not sentry.Parent then
break
end
F.touchPart(hitbox, target)
end
if not ENABLED or not sentry.Parent then
break
end
end
end
pcall(function()
bat:Activate()
end)
task.wait(ATTACK_DELAY)
end
humanoid = F.getHumanoid()
if humanoid then
pcall(function()
humanoid:UnequipTools()
end)
end
attacking[sentry] = nil
end
function F.detect(object)
if ENABLED and F.isSentry(object) and not attacking[object] then
task.spawn(F.attackSentry, object)
end
end
for _, object in ipairs(workspace:GetDescendants()) do
F.detect(object)
end
workspace.DescendantAdded:Connect(function(object)
F.detect(object)
end)
SetAutoTurretImported = function(value)
ENABLED = not not value
if ENABLED then
for _, object in ipairs(workspace:GetDescendants()) do
F.detect(object)
end
else
local humanoid = F.getHumanoid()
if humanoid then
pcall(function()
humanoid:UnequipTools()
end)
end
end
end
end
function F.balloonReset()
local channels = TextChatService:FindFirstChild("TextChannels")
local general = channels and channels:FindFirstChild("RBXGeneral")
if general then
general:SendAsync(";balloon " .. LocalPlayer.Name)
else
local events = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
local remote = events and events:FindFirstChild("SayMessageRequest")
if remote then
remote:FireServer(";balloon " .. LocalPlayer.Name, "All")
end
end
end
local infiniteJumpEnabled = false
local infiniteJumpConnection
local infiniteJumpLast = 0

function F.setInfiniteJump(state)
infiniteJumpEnabled = not not state
_G.InfiniteJumpEnabled = infiniteJumpEnabled
if infiniteJumpConnection then
pcall(function() infiniteJumpConnection:Disconnect() end)
infiniteJumpConnection = nil
end
if not infiniteJumpEnabled then return end
infiniteJumpConnection = RunService.Heartbeat:Connect(function()
if not infiniteJumpEnabled or F.Resetting then return end
if not UserInputService:IsKeyDown(Enum.KeyCode.Space) then return end
local now = tick()
if now - infiniteJumpLast < 0.1 then return end
local character = LocalPlayer.Character
local root = character and character:FindFirstChild("HumanoidRootPart")
local humanoid = character and character:FindFirstChildOfClass("Humanoid")
if not root or not humanoid or humanoid.Health <= 0 then return end
infiniteJumpLast = now
local velocity = root.AssemblyLinearVelocity
root.AssemblyLinearVelocity = Vector3.new(velocity.X, 55, velocity.Z)
end)
end

_G.InfiniteJumpEnabled = false
_G.setInfiniteJump = F.setInfiniteJump

function F.flingUp()
local character = LocalPlayer.Character
local root = character and (character.PrimaryPart or character:FindFirstChild("HumanoidRootPart"))
local humanoid = character and character:FindFirstChildOfClass("Humanoid")
if not root or not humanoid or humanoid.Health <= 0 then return false end
_G.FlingActive = true
pcall(function()
humanoid.PlatformStand = true
root.Anchored = false
end)
local started = os.clock()
while os.clock() - started < 0.15 do
local currentCharacter = LocalPlayer.Character
root = currentCharacter and (currentCharacter.PrimaryPart or currentCharacter:FindFirstChild("HumanoidRootPart")) or nil
if not root then break end
root.AssemblyLinearVelocity = Vector3.new(0, 99999, 0)
RunService.Heartbeat:Wait()
end
pcall(function()
if humanoid and humanoid.Parent then humanoid.PlatformStand = false end
end)
_G.FlingActive = false
return true
end

_G.FlingActive = false
_G.FlingUp = F.flingUp

local setInstantResetToggle
function F.setInstantResetState(state)
if not state then return end
task.spawn(function()
F.flingUp()
if setInstantResetToggle then
pcall(setInstantResetToggle, false)
end
end)
end
_G.InstantReset = F.flingUp

function F.instantLeave()
local success = pcall(function()
game:Shutdown()
end)
return success
end

local autoLeaveEnabled = false
local autoLeaveTriggered = false
local matchedLocalPlot = nil
local matchedDeliveryHitbox = nil
local spawnedLocalPlot = nil
local spawnedLocalPlotName = nil
local spawnPlotLocked = false
local deliveryTouchConnection = nil
local deliveryHeartbeatConnection = nil
local setAutoLeaveToggle
local stealPromptEngaged = false

function F.setAutoLeaveEnabled(state)
autoLeaveEnabled = not not state
if autoLeaveEnabled then
autoLeaveTriggered = false
stealPromptEngaged = false
task.defer(F.bindLocalPlotDelivery)
else
stealPromptEngaged = false
autoLeaveTriggered = false
end
end

function F.objectContainsUsername(object, usernameLower)
local function matches(value)
if type(value) ~= "string" or value == "" then
return false
end
return string.find(string.lower(value), usernameLower, 1, true) ~= nil
end
if object:IsA("TextLabel") or object:IsA("TextButton") or object:IsA("TextBox") then
if matches(object.Text) then
return true
end
elseif object:IsA("StringValue") then
if matches(object.Value) then
return true
end
end
for _, attributeValue in pairs(object:GetAttributes()) do
if type(attributeValue) == "string" and matches(attributeValue) then
return true
end
end
return false
end

function F.findDeliveryHitbox(plot)
local exactNames = {
"DeliverHitbox",
"DeliveryHitbox",
"DeliverHitBox",
"DeliveryHitBox",
"Delivery",
"Deliver"
}
for _, name in ipairs(exactNames) do
local found = plot and plot:FindFirstChild(name, true)
if found and found:IsA("BasePart") then
return found
end
end
if not plot then return nil end
for _, object in ipairs(plot:GetDescendants()) do
if object:IsA("BasePart") then
local lowerName = string.lower(object.Name)
if string.find(lowerName, "deliver", 1, true)
and (string.find(lowerName, "hitbox", 1, true)
or string.find(lowerName, "zone", 1, true)) then
return object
end
end
end
return nil
end

function F.getPlotSpawnAnchor(plot)
if not plot then return nil end
local respawn = LocalPlayer.RespawnLocation
if respawn and respawn:IsDescendantOf(plot) then
return respawn
end
local exactNames = {
"SpawnLocation",
"PlayerSpawn",
"SpawnPoint",
"Spawn",
"Teleport",
"Entrance"
}
for _, name in ipairs(exactNames) do
local found = plot:FindFirstChild(name, true)
if found and found:IsA("BasePart") then
return found
end
end
local best
for _, object in ipairs(plot:GetDescendants()) do
if object:IsA("BasePart") then
local lower = string.lower(object.Name)
if string.find(lower, "spawn", 1, true) then
best = object
break
end
end
end
return best or F.findDeliveryHitbox(plot) or plot:FindFirstChildWhichIsA("BasePart", true)
end

function F.captureSpawnPlot(character)
local plots = workspace:FindFirstChild("Plots")
if not plots then return nil end

if spawnPlotLocked then
if spawnedLocalPlot and spawnedLocalPlot.Parent == plots then
matchedLocalPlot = spawnedLocalPlot
return spawnedLocalPlot
end
if spawnedLocalPlotName then
local samePlot = plots:FindFirstChild(spawnedLocalPlotName)
if samePlot then
spawnedLocalPlot = samePlot
matchedLocalPlot = samePlot
return samePlot
end
end
return nil
end

local respawn = LocalPlayer.RespawnLocation
if respawn then
for _, plot in ipairs(plots:GetChildren()) do
if respawn:IsDescendantOf(plot) then
spawnedLocalPlot = plot
spawnedLocalPlotName = plot.Name
spawnPlotLocked = true
matchedLocalPlot = plot
return plot
end
end
end

character = character or LocalPlayer.Character
local root = character and (character:FindFirstChild("HumanoidRootPart") or character:WaitForChild("HumanoidRootPart", 5))
if not root then return nil end
local bestPlot, bestDistance
for _, plot in ipairs(plots:GetChildren()) do
local anchor = F.getPlotSpawnAnchor(plot)
if anchor then
local distance = (root.Position - anchor.Position).Magnitude
if not bestDistance or distance < bestDistance then
bestDistance = distance
bestPlot = plot
end
end
end
if bestPlot then
spawnedLocalPlot = bestPlot
spawnedLocalPlotName = bestPlot.Name
spawnPlotLocked = true
matchedLocalPlot = bestPlot
end
return bestPlot
end

function F.findPlotSign(plot)
if not plot then return nil end
local exact = plot:FindFirstChild("PlotSign", true)
if exact then return exact end
for _, object in ipairs(plot:GetDescendants()) do
if string.lower(tostring(object.Name or "")) == "plotsign" then
return object
end
end
return nil
end

function F.getPlotSignTexts(plot)
local texts = {}
local plotSign = F.findPlotSign(plot)
if not plotSign then return texts end
local seen = {}
local function push(value)
if type(value) ~= "string" then return end
local clean = value:gsub("<.->", " "):gsub("%s+", " "):gsub("^%s+", ""):gsub("%s+$", "")
if clean ~= "" and not seen[clean] then
seen[clean] = true
table.insert(texts, clean)
end
end
if plotSign:IsA("TextLabel") or plotSign:IsA("TextButton") or plotSign:IsA("TextBox") then push(plotSign.Text) end
if plotSign:IsA("StringValue") then push(plotSign.Value) end
for _, value in pairs(plotSign:GetAttributes()) do push(value) end
for _, object in ipairs(plotSign:GetDescendants()) do
if object:IsA("TextLabel") or object:IsA("TextButton") or object:IsA("TextBox") then
push(object.Text)
elseif object:IsA("StringValue") then
push(object.Value)
end
for _, value in pairs(object:GetAttributes()) do push(value) end
end
return texts
end

function F.plotBelongsToLocalPlayer(plot)
if not plot then return false end
local username = string.lower(tostring(LocalPlayer.Name or ""))
local display = string.lower(tostring(LocalPlayer.DisplayName or ""))
local compactUsername = username:gsub("[%s%p_]+", "")
local compactDisplay = display:gsub("[%s%p_]+", "")
for _, text in ipairs(F.getPlotSignTexts(plot)) do
local lower = string.lower(text)
local compact = lower:gsub("[%s%p_]+", "")
if username ~= "" and string.find(lower, username, 1, true) then return true end
if display ~= "" and string.find(lower, display, 1, true) then return true end
if compactUsername ~= "" and string.find(compact, compactUsername, 1, true) then return true end
if compactDisplay ~= "" and string.find(compact, compactDisplay, 1, true) then return true end
end
return false
end

function F.findLocalPlotFromSign()
local plots = workspace:FindFirstChild("Plots")
if not plots then return nil end
for _, plot in ipairs(plots:GetChildren()) do
if F.plotBelongsToLocalPlayer(plot) then
matchedLocalPlot = plot
spawnedLocalPlot = plot
spawnedLocalPlotName = plot.Name
spawnPlotLocked = true
return plot
end
end
matchedLocalPlot = nil
spawnedLocalPlot = nil
spawnedLocalPlotName = nil
spawnPlotLocked = false
return nil
end

function F.localCharacterTouched(part)
local character = LocalPlayer.Character
return character and part and part:IsDescendantOf(character) or false
end

function F.rootReachedHitbox(root, hitbox)
if not root or not hitbox or not hitbox.Parent then
return false
end
local point = hitbox.CFrame:PointToObjectSpace(root.Position)
local half = hitbox.Size * 0.5
local padding = 2.5
return math.abs(point.X) <= half.X + padding
and math.abs(point.Y) <= half.Y + padding
and math.abs(point.Z) <= half.Z + padding
end

function F.triggerAutoLeaveAtDelivery()
if not autoLeaveEnabled or not stealPromptEngaged or autoLeaveTriggered then return end
autoLeaveTriggered = true
task.delay(1, function()
if not autoLeaveEnabled or not autoLeaveTriggered then return end
autoLeaveEnabled = false
stealPromptEngaged = false
if setAutoLeaveToggle then
task.defer(function() setAutoLeaveToggle(false) end)
end
local worked = F.instantLeave()
if not worked then
autoLeaveTriggered = false
end
end)
end

function F.clearDeliveryConnections()
if deliveryTouchConnection then
deliveryTouchConnection:Disconnect()
deliveryTouchConnection = nil
end
if deliveryHeartbeatConnection then
deliveryHeartbeatConnection:Disconnect()
deliveryHeartbeatConnection = nil
end
end

function F.bindLocalPlotDelivery()
F.clearDeliveryConnections()
matchedDeliveryHitbox = nil
local plots = workspace:FindFirstChild("Plots")
if not plots then
return false
end

local signPlot = F.findLocalPlotFromSign()
if signPlot then
matchedLocalPlot = signPlot
spawnedLocalPlot = signPlot
spawnedLocalPlotName = signPlot.Name
spawnPlotLocked = true
else
matchedLocalPlot = nil
matchedDeliveryHitbox = nil
return false
end

matchedDeliveryHitbox = F.findDeliveryHitbox(matchedLocalPlot)
if not matchedDeliveryHitbox then
return false
end

deliveryTouchConnection = matchedDeliveryHitbox.Touched:Connect(function(part)
if F.localCharacterTouched(part) then
F.triggerAutoLeaveAtDelivery()
end
end)

local elapsed = 0
deliveryHeartbeatConnection = RunService.Heartbeat:Connect(function(dt)
elapsed += dt
if elapsed < 0.08 then return end
elapsed = 0
if not matchedDeliveryHitbox or not matchedDeliveryHitbox.Parent then
task.defer(F.bindLocalPlotDelivery)
return
end
if not autoLeaveEnabled then return end
local character = LocalPlayer.Character
local root = character and character:FindFirstChild("HumanoidRootPart")
if F.rootReachedHitbox(root, matchedDeliveryHitbox) then
F.triggerAutoLeaveAtDelivery()
end
end)
return true
end

function F.schedulePlotRefresh()
task.delay(0.12, function()
F.findLocalPlotFromSign()
F.bindLocalPlotDelivery()
end)
end

task.spawn(function()
local plots = workspace:WaitForChild("Plots", 15)
if not plots then return end
F.bindLocalPlotDelivery()
plots.ChildAdded:Connect(F.schedulePlotRefresh)
plots.ChildRemoved:Connect(F.schedulePlotRefresh)
while plots.Parent do
task.wait(1)
if not matchedLocalPlot
or not matchedLocalPlot.Parent
or not matchedDeliveryHitbox
or not matchedDeliveryHitbox.Parent then
F.bindLocalPlotDelivery()
end
end
end)

LocalPlayer.CharacterAdded:Connect(function(character)
matchedDeliveryHitbox = nil
task.defer(function()
F.findLocalPlotFromSign()
F.bindLocalPlotDelivery()
end)
end)

local selectedTargetPrompt = nil
local selectedTargetRecord = nil
-- Instant Steal engine integrated from the standalone version.
-- The standalone GUI/toggle is intentionally omitted; the hub toggle controls this engine.

if _G.WuzzInstantSteal and type(_G.WuzzInstantSteal.Destroy) == "function" then
pcall(function()
_G.WuzzInstantSteal:Destroy()
end)
end

local WuzzInstantSteal = {
Enabled = false,
SelectedBrainrot = nil,
State = {
stealing = false,
target = "",
totalSteals = 0,
lastResetAt = 0,
cycle = 1.45,
dip = 0.05,
},
}

local instantTrackedPrompts = setmetatable({}, {__mode = "k"})
local instantPromptCooldowns = setmetatable({}, {__mode = "k"})
local instantPromptAttempts = setmetatable({}, {__mode = "k"})
local instantPromptNames = setmetatable({}, {__mode = "k"})
local instantCloseBurstCooldowns = setmetatable({}, {__mode = "k"})
local instantTrackedContainers = setmetatable({}, {__mode = "k"})
local instantActiveAttempts = {}
local instantOwnPlotCache = {}
local instantOwnPlotCacheTime = 0
local instantConnections = {}
local instantRunning = true
local instantNextGlobalAttempt = 0
local INSTANT_SCAN_COOLDOWN = 0.08
local INSTANT_CLOSE_BURST_DISTANCE = 9.5
local INSTANT_CLOSE_BURST_COOLDOWN = 0.08
local INSTANT_MAX_PROMPT_DISTANCE = 25
local INSTANT_RETRY_SCHEDULE = {0, 0.05, 0.12, 0.2, 0.3, 0.45, 0.65, 0.9, 1.2, 1.5, 1.9, 2.3, 2.8, 3.4, 4, 4.8, 5.6, 6.5}

local function instantConnect(signal, callback)
local connection = signal:Connect(callback)
table.insert(instantConnections, connection)
return connection
end

local function instantGetRoot()
local character = LocalPlayer.Character
return character and character:FindFirstChild("HumanoidRootPart")
end

local function instantGetPlots()
return Workspace:FindFirstChild("Plots")
end

local function instantGetPlot(instance)
local plots = instantGetPlots()
if not plots then return nil end
while instance do
if instance.Parent == plots then return instance end
instance = instance.Parent
end
return nil
end

local function instantIsOwnPlot(plot)
if not plot then return false end
local now = tick()
if now - instantOwnPlotCacheTime > 3 then
table.clear(instantOwnPlotCache)
instantOwnPlotCacheTime = now
end
local cached = instantOwnPlotCache[plot.Name]
if cached ~= nil then return cached end

local plotSign = plot:FindFirstChild("PlotSign")
local owned = false
if plotSign then
local yourBase = plotSign:FindFirstChild("YourBase")
if yourBase and yourBase:IsA("BillboardGui") then
owned = yourBase.Enabled == true
end
if not owned then
local surfaceGui = plotSign:FindFirstChildWhichIsA("SurfaceGui", true)
local textLabel = surfaceGui and surfaceGui:FindFirstChildWhichIsA("TextLabel", true)
if textLabel and type(textLabel.Text) == "string" then
local signText = textLabel.Text:lower()
owned = signText:find(LocalPlayer.Name:lower(), 1, true) ~= nil
or signText:find(LocalPlayer.DisplayName:lower(), 1, true) ~= nil
end
end
end
instantOwnPlotCache[plot.Name] = owned
return owned
end

local function instantGetPromptPosition(prompt)
local parent = prompt and prompt.Parent
if not parent then return nil end
if parent:IsA("Attachment") then
local ok, position = pcall(function()
return parent.WorldPosition
end)
if ok and typeof(position) == "Vector3" then return position end
parent = parent.Parent
end
if not parent then return nil end
if parent:IsA("BasePart") then return parent.Position end
if parent:IsA("Model") then
local ok, pivot = pcall(function()
return parent:GetPivot().Position
end)
if ok then return pivot end
end
return nil
end

local function instantGetPodiumModel(prompt)
local parent = prompt and prompt.Parent
while parent do
if parent:IsA("Model") and parent.Parent and parent.Parent.Name == "AnimalPodiums" then
return parent
end
parent = parent.Parent
end
return nil
end

local function instantMatchesSelectedBrainrot(prompt)
local selected = WuzzInstantSteal.SelectedBrainrot
if type(selected) ~= "table" then return true end

if selected.plot then
local plot = instantGetPlot(prompt)
if plot and plot.Name ~= tostring(selected.plot) then return false end
end

local model = prompt:FindFirstAncestorOfClass("Model")
if not model then return false end

if selected.slot then
local slot = tostring(selected.slot)
if prompt:FindFirstAncestor(slot) then return true end
if model.Name == slot then return true end
if model.Parent and model.Parent.Name == slot then return true end
end

if selected.name then
local wantedName = string.lower(tostring(selected.name))
local current = model
while current do
if current.Name and string.lower(current.Name) == wantedName then return true end
current = current.Parent
end
end

return selected.slot == nil and selected.name == nil
end

local function instantIsPromptUsable(prompt)
if not prompt or not prompt.Parent then return false end
if not prompt:IsA("ProximityPrompt") or not prompt.Enabled then return false end
if LocalPlayer:GetAttribute("Stealing") == true then return false end
local plot = instantGetPlot(prompt)
if plot and instantIsOwnPlot(plot) then return false end
if not instantMatchesSelectedBrainrot(prompt) then return false end
return true
end

local function instantCanAttempt(prompt, cooldown)
local now = os.clock()
local previous = instantPromptCooldowns[prompt]
if previous and now - previous < cooldown then return false end
instantPromptCooldowns[prompt] = now
return true
end

local function instantSafeCall(callback, ...)
return pcall(callback, ...)
end

local function instantFirePrompt(prompt, amount)
if not prompt or not prompt.Parent then return false end
amount = math.max(1, tonumber(amount) or 1)
local ok, result = instantSafeCall(function()
if typeof(fireproximityprompt) == "function" then
fireproximityprompt(prompt, amount)
return true
end
if typeof(firesignal) == "function" then
for _ = 1, amount do
pcall(firesignal, prompt.Triggered)
end
return true
end
return false
end)
return ok and result == true
end

local function instantBeginHold(prompt)
instantSafeCall(function()
if typeof(firesignal) == "function" then
pcall(firesignal, prompt.PromptButtonHoldBegan)
end
pcall(function()
prompt:InputHoldBegin()
end)
end)
end

local function instantAttemptPrompt(prompt, burstCount, cooldown)
if not prompt or not prompt.Parent or not prompt.Enabled then return end
local now = tick()
if now < instantNextGlobalAttempt then return end
if not instantCanAttempt(prompt, cooldown) then return end

instantBeginHold(prompt)
task.delay(0.05, function()
if not prompt.Parent or not prompt.Enabled or not WuzzInstantSteal.Enabled then return end
for _ = 1, burstCount do
instantFirePrompt(prompt, 1)
end
end)

WuzzInstantSteal.State.totalSteals += 1
instantNextGlobalAttempt = now + WuzzInstantSteal.State.cycle
WuzzInstantSteal.State.lastResetAt = now
end

local function instantCloseBurst(prompt)
if not prompt or not prompt.Parent or not prompt.Enabled then return end
local now = os.clock()
local previous = instantCloseBurstCooldowns[prompt]
if previous and now - previous < INSTANT_CLOSE_BURST_COOLDOWN then return end
instantCloseBurstCooldowns[prompt] = now
for _ = 1, 5 do
instantFirePrompt(prompt, 1)
end
end

local function instantGetPromptName(prompt)
local cached = instantPromptNames[prompt]
if cached then return cached end
local name = ""
pcall(function()
if type(prompt.ObjectText) == "string" then
name = prompt.ObjectText
end
end)
if name == "" then
local podium = instantGetPodiumModel(prompt)
name = podium and podium.Name or "Brainrot"
end
instantPromptNames[prompt] = name
return name
end

local function instantIsPromptInRange(prompt, root)
if not prompt or not prompt.Parent or not root then return false end
local plot = instantGetPlot(prompt)
if plot and instantIsOwnPlot(plot) then return false end
local position = instantGetPromptPosition(prompt)
return position ~= nil and (position - root.Position).Magnitude <= INSTANT_MAX_PROMPT_DISTANCE
end

local function instantFindSlotPrompt(plot, slot)
local animalPodiums = plot and plot:FindFirstChild("AnimalPodiums")
local podium = animalPodiums and animalPodiums:FindFirstChild(tostring(slot))
if not podium then return nil end

local base = podium:FindFirstChild("Base")
base = base and base:FindFirstChild("Spawn")
base = base and base:FindFirstChild("PromptAttachment")
if base then
for _, child in ipairs(base:GetChildren()) do
if child:IsA("ProximityPrompt") then return child end
end
end

for _, descendant in ipairs(podium:GetDescendants()) do
if descendant:IsA("ProximityPrompt") then return descendant end
end
return nil
end

local function instantArmPrompt(key, promptGetter)
if not WuzzInstantSteal.Enabled then return false end
local root = instantGetRoot()
if not root then return false end
if LocalPlayer:GetAttribute("Stealing") == true then return false end

local currentPrompt = promptGetter()
if currentPrompt then
if not instantIsPromptUsable(currentPrompt) then return false end
if not instantIsPromptInRange(currentPrompt, root) then return false end
end

local token = {}
instantActiveAttempts[key] = token
task.spawn(function()
local started = os.clock()
local firedOnce = false

for index, delayTime in ipairs(INSTANT_RETRY_SCHEDULE) do
local waitTime = delayTime - (os.clock() - started)
if waitTime > 0 then task.wait(waitTime) end
if instantActiveAttempts[key] ~= token or not WuzzInstantSteal.Enabled then return end
if LocalPlayer:GetAttribute("Stealing") == true then break end

local currentRoot = instantGetRoot()
local prompt = promptGetter()
if currentRoot and prompt and prompt.Enabled and instantIsPromptInRange(prompt, currentRoot) then
local now = os.clock()
instantPromptAttempts[prompt] = now
instantPromptCooldowns[prompt] = now
instantBeginHold(prompt)

local count = (index == 1 or not firedOnce) and 25 or 10
for _ = 1, count do
instantFirePrompt(prompt, 1)
end

if not firedOnce then
WuzzInstantSteal.State.totalSteals += 1
WuzzInstantSteal.State.lastResetAt = tick()
instantPromptNames[prompt] = nil
WuzzInstantSteal.State.target = instantGetPromptName(prompt)
firedOnce = true
end
end
end

if instantActiveAttempts[key] == token then
instantActiveAttempts[key] = nil
end
end)
return true
end

local function instantBuildPromptKey(prompt)
local plot = instantGetPlot(prompt)
local podium = instantGetPodiumModel(prompt)
if plot and podium then
return plot.Name .. "|" .. podium.Name
end
return prompt
end

local function instantArmTrackedPrompt(prompt)
return instantArmPrompt(instantBuildPromptKey(prompt), function()
if prompt.Parent then return prompt end
return nil
end)
end

local function instantRefreshPrompt(prompt)
instantPromptNames[prompt] = nil
end

local function instantBindPrompt(prompt)
if instantTrackedPrompts[prompt] then return end
instantTrackedPrompts[prompt] = true

local function process()
if not WuzzInstantSteal.Enabled then return end
if not instantGetRoot() then return end
if instantArmTrackedPrompt(prompt) then return end
if not instantIsPromptUsable(prompt) then return end

local now = os.clock()
local previous = instantPromptAttempts[prompt]
if not previous or now - previous >= INSTANT_SCAN_COOLDOWN then
instantPromptAttempts[prompt] = now
instantAttemptPrompt(prompt, 25, 0.08)
end
end

instantRefreshPrompt(prompt)
task.defer(process)

pcall(function()
instantConnect(prompt:GetPropertyChangedSignal("Enabled"), function()
if prompt.Enabled then
instantRefreshPrompt(prompt)
process()
end
end)
end)

pcall(function()
instantConnect(prompt:GetPropertyChangedSignal("ObjectText"), function()
instantRefreshPrompt(prompt)
process()
end)
end)

instantConnect(prompt.AncestryChanged, function()
if not prompt:IsDescendantOf(Workspace) then
instantTrackedPrompts[prompt] = nil
instantPromptCooldowns[prompt] = nil
instantPromptAttempts[prompt] = nil
instantPromptNames[prompt] = nil
instantCloseBurstCooldowns[prompt] = nil
end
end)
end

local function instantScanPrompts()
local plots = instantGetPlots()
if not plots then return end
for _, plot in ipairs(plots:GetChildren()) do
local animalPodiums = plot:FindFirstChild("AnimalPodiums")
if animalPodiums then
for _, descendant in ipairs(animalPodiums:GetDescendants()) do
if descendant:IsA("ProximityPrompt") then
instantBindPrompt(descendant)
end
end
end
end
end

local function instantWatchAnimalPodiums(container)
if not container or instantTrackedContainers[container] then return end
instantTrackedContainers[container] = true

instantConnect(container.DescendantAdded, function(descendant)
if descendant:IsA("ProximityPrompt") then
instantBindPrompt(descendant)
end
end)

for _, descendant in ipairs(container:GetDescendants()) do
if descendant:IsA("ProximityPrompt") then
instantBindPrompt(descendant)
end
end
end

local function instantWatchPlot(plot)
instantWatchAnimalPodiums(plot:FindFirstChild("AnimalPodiums"))
instantConnect(plot.ChildAdded, function(child)
if child.Name == "AnimalPodiums" then
instantWatchAnimalPodiums(child)
end
end)
end

function WuzzInstantSteal:SetSelectedBrainrot(selection)
self.SelectedBrainrot = selection
end

function WuzzInstantSteal:OnNewAnimal(plot, slot)
if not self.Enabled or not plot then return end
local plots = instantGetPlots()
if plots and plot.Parent ~= plots then return end
if instantIsOwnPlot(plot) then return end
local key = plot.Name .. "|" .. tostring(slot)
instantArmPrompt(key, function()
return instantFindSlotPrompt(plot, slot)
end)
end

function WuzzInstantSteal:SetEnabled(value)
self.Enabled = value and true or false
if self.Enabled then
instantScanPrompts()
else
self.State.stealing = false
self.State.target = ""
for key in pairs(instantActiveAttempts) do
instantActiveAttempts[key] = nil
end
end
return self.Enabled
end

function WuzzInstantSteal:Toggle()
return self:SetEnabled(not self.Enabled)
end

function WuzzInstantSteal:Destroy()
self:SetEnabled(false)
instantRunning = false
for _, connection in ipairs(instantConnections) do
pcall(function()
connection:Disconnect()
end)
end
table.clear(instantConnections)
end

instantConnect(Workspace.DescendantAdded, function(descendant)
if descendant:IsA("ProximityPrompt") and descendant:FindFirstAncestor("AnimalPodiums") then
instantBindPrompt(descendant)
end
end)

task.spawn(function()
local plots = Workspace:FindFirstChild("Plots") or Workspace:WaitForChild("Plots", 300)
if not plots or not instantRunning then return end
for _, plot in ipairs(plots:GetChildren()) do
pcall(instantWatchPlot, plot)
end
instantConnect(plots.ChildAdded, function(plot)
pcall(instantWatchPlot, plot)
end)
end)

task.spawn(function()
while instantRunning do
task.wait(0.05)

if not WuzzInstantSteal.Enabled then
WuzzInstantSteal.State.stealing = false
WuzzInstantSteal.State.target = ""
elseif LocalPlayer:GetAttribute("Stealing") == true then
WuzzInstantSteal.State.stealing = false
WuzzInstantSteal.State.target = ""
else
local root = instantGetRoot()
if not root then
WuzzInstantSteal.State.stealing = false
WuzzInstantSteal.State.target = ""
else
local nearestDistance = math.huge
local nearestPrompt = nil

for prompt in pairs(instantTrackedPrompts) do
if instantIsPromptUsable(prompt) then
local position = instantGetPromptPosition(prompt)
local distance = position and (position - root.Position).Magnitude or math.huge
if distance < nearestDistance then
nearestDistance = distance
nearestPrompt = prompt
end
end
end

if nearestPrompt then
WuzzInstantSteal.State.stealing = true
WuzzInstantSteal.State.target = instantGetPromptName(nearestPrompt)
instantAttemptPrompt(nearestPrompt, 1, 0.08)
if nearestDistance <= INSTANT_CLOSE_BURST_DISTANCE then
instantCloseBurst(nearestPrompt)
end
else
WuzzInstantSteal.State.stealing = false
WuzzInstantSteal.State.target = ""
end
end
end
end
end)

-- Preserve the hub's existing steal-trigger integrations.
instantConnect(ProximityPromptService.PromptTriggered, function(prompt, triggeringPlayer)
if not prompt or (triggeringPlayer and triggeringPlayer ~= LocalPlayer) then return end
if prompt:FindFirstAncestor("AnimalPodiums") then
if autoLeaveEnabled then stealPromptEngaged = true end
if F.onStealPromptTriggered then task.defer(F.onStealPromptTriggered, prompt) end
if F.reapplyWalkSpeed then F.reapplyWalkSpeed(2) end
end
end)

function F.setInstantSteal(state)
local selection = nil
if selectedTargetRecord then
selection = {
plot = selectedTargetRecord.Plot and selectedTargetRecord.Plot.Name or nil,
slot = selectedTargetRecord.Slot and tostring(selectedTargetRecord.Slot.Name) or nil,
name = selectedTargetRecord.Name,
}
end
WuzzInstantSteal:SetSelectedBrainrot(selection)
return WuzzInstantSteal:SetEnabled(state)
end

_G.WuzzInstantSteal = WuzzInstantSteal
_G.SetInstantSteal = function(value)
return F.setInstantSteal(value)
end
_G.ToggleInstantSteal = function()
return WuzzInstantSteal:Toggle()
end



local walkSpeedEnabled = false
local desiredWalkSpeed = 28
local walkSpeedConnection

function F.setWalkSpeedValue(value)
desiredWalkSpeed = math.clamp(tonumber(value) or 28, 5, 32)
_G.RyWalkSpeed = desiredWalkSpeed
_G.RyWSValue = desiredWalkSpeed
return desiredWalkSpeed
end

function F.reapplyWalkSpeed()
if not walkSpeedEnabled then return end
if not walkSpeedConnection then
F.setWalkSpeedEnabled(true)
end
end

function F.setWalkSpeedEnabled(state)
walkSpeedEnabled = not not state
_G.RyWSEnabled = walkSpeedEnabled
_G.RyWalkSpeedOn = walkSpeedEnabled
if walkSpeedConnection then
pcall(function() walkSpeedConnection:Disconnect() end)
walkSpeedConnection = nil
end
if not walkSpeedEnabled then return end
walkSpeedConnection = RunService.Heartbeat:Connect(function(dt)
if not walkSpeedEnabled or F.Resetting then return end
if LocalPlayer:GetAttribute("Stealing") ~= true then return end
if _G.StealHold == true then return end
local character = LocalPlayer.Character
local humanoid = character and character:FindFirstChildOfClass("Humanoid")
local root = character and character:FindFirstChild("HumanoidRootPart")
if not humanoid or not root or humanoid.Health <= 0 then return end
local direction = humanoid.MoveDirection
if direction.Magnitude <= 0 then return end
local target = math.clamp(tonumber(desiredWalkSpeed) or 28, 5, 32)
if target <= humanoid.WalkSpeed then return end
root.CFrame = root.CFrame + direction * (target - humanoid.WalkSpeed) * (dt or 0.016)
end)
end

_G.RySetWalkSpeed = F.setWalkSpeedEnabled
_G.setWalkSpeedEnabled = F.setWalkSpeedEnabled
_G.setWalkSpeedValue = F.setWalkSpeedValue
F.setWalkSpeedValue(desiredWalkSpeed)

local invisibleStealEnabled = false
local invisibleRotation = 225
local invisActive = false
local invisGeneration = 0
local invisRealRoot
local invisFakeRoot
local invisCharacter
local invisHumanoid
local invisSavedHipHeight
local invisSavedStates
local invisSavedTransparency
local invisPoseTrack
local invisConnections = {}

_G.RyInvisAngle = invisibleRotation
_G.RyInvisDepth = 4.2
_G.RyInvisActive = false
_G.invisibleStealEnabled = false

local function invisAddConnection(connection)
invisConnections[#invisConnections + 1] = connection
return connection
end

local function invisDisconnectAll()
for _, connection in ipairs(invisConnections) do
pcall(function()
connection:Disconnect()
end)
end
table.clear(invisConnections)
end

local function invisDepthOffset()
return 0.01 + math.clamp(tonumber(_G.RyInvisDepth) or 4.2, 0, 10) / 10 * 0.19
end

local function invisAngle()
return math.clamp(tonumber(_G.RyInvisAngle) or invisibleRotation or 225, 0, 360)
end

local function invisRewireJoints(character, fromPart, toPart)
if not character or not fromPart or not toPart then
return
end
for _, descendant in ipairs(character:GetDescendants()) do
if descendant:IsA("Weld") or descendant:IsA("Motor6D") then
if descendant.Part0 == fromPart then
descendant.Part0 = toPart
end
if descendant.Part1 == fromPart then
descendant.Part1 = toPart
end
end
end
end

local function invisWithDetachedCharacter(character, callback)
local holder = Instance.new("Model")
pcall(function()
holder.Parent = game
end)
local ok, result = pcall(function()
character.Parent = holder
callback()
end)
if character.Parent ~= workspace then
pcall(function()
character.Parent = workspace
end)
end
pcall(function()
holder:Destroy()
end)
return ok, result
end

local function invisCountRoots(character)
local count = 0
for _, child in ipairs(character:GetChildren()) do
if child.Name == "HumanoidRootPart" and child:IsA("BasePart") then
count += 1
end
end
return count
end

local function invisStopPose()
if not invisPoseTrack then
return
end
local track = invisPoseTrack
invisPoseTrack = nil
pcall(function()
track:AdjustSpeed(1)
track:Stop(0)
track:Destroy()
end)
end

local function invisPlayPose(character, humanoid, animator)
if not character or not humanoid or not animator or humanoid.Health <= 0 then
return false
end
local animation = Instance.new("Animation")
animation.AnimationId = "http://www.roblox.com/asset/?id=18537363391"
local ok, track = pcall(function()
return animator:LoadAnimation(animation)
end)
animation:Destroy()
if not ok or not track then
return false
end
invisPoseTrack = track
pcall(function()
track.Priority = Enum.AnimationPriority.Action4
track.Looped = true
track:Play(0, 1, 0)
end)
invisAddConnection(track.Stopped:Connect(function()
if not invisActive or invisPoseTrack ~= track or invisCharacter ~= character then
return
end
task.defer(function()
if invisActive and invisCharacter == character then
invisPlayPose(character, humanoid, animator)
end
end)
end))
task.defer(function()
if invisPoseTrack ~= track then
return
end
pcall(function()
track.TimePosition = 0.7
end)
task.delay(0.1, function()
if invisPoseTrack == track then
pcall(function()
track:AdjustSpeed(math.huge)
end)
end
end)
end)
return true
end

local function invisRestoreRoot()
local character = invisCharacter
local humanoid = invisHumanoid
local original = invisRealRoot
local replacement = invisFakeRoot
if not character or LocalPlayer.Character ~= character or not character.Parent then
if original and original.Parent then
pcall(function()
original:Destroy()
end)
end
if replacement and replacement.Parent then
pcall(function()
replacement:Destroy()
end)
end
return false
end
if original and original:IsDescendantOf(game) then
local replacementCFrame
if replacement and replacement.Parent == character then
replacementCFrame = replacement.CFrame
end
local ok = invisWithDetachedCharacter(character, function()
original.Parent = character
character.PrimaryPart = original
end)
pcall(function()
original.CanCollide = true
end)
pcall(invisRewireJoints, character, replacement, original)
if replacement and replacement ~= original then
pcall(function()
replacement:Destroy()
end)
end
if replacementCFrame then
pcall(function()
original.CFrame = replacementCFrame
end)
end
if humanoid and invisSavedHipHeight then
pcall(function()
humanoid.HipHeight = invisSavedHipHeight
end)
end
return ok == true
end
if replacement and replacement.Parent then
pcall(function()
replacement:Destroy()
end)
end
return false
end

local function invisStop(reason, keepEnabled)
invisGeneration += 1
invisActive = false
invisDisconnectAll()
if invisSavedTransparency then
for part, value in pairs(invisSavedTransparency) do
if part and part.Parent then
pcall(function()
part.LocalTransparencyModifier = value
end)
end
end
invisSavedTransparency = nil
end
invisStopPose()
if invisRealRoot or invisFakeRoot then
pcall(invisRestoreRoot)
end
if invisSavedStates and invisHumanoid and invisHumanoid.Parent then
for state, enabled in pairs(invisSavedStates) do
pcall(function()
invisHumanoid:SetStateEnabled(state, enabled)
end)
end
end
invisSavedStates = nil
invisRealRoot = nil
invisFakeRoot = nil
invisCharacter = nil
invisHumanoid = nil
invisSavedHipHeight = nil
_G.RyInvisActive = false
_G.invisibleStealEnabled = false
if not keepEnabled then
invisibleStealEnabled = false
end
end

local function invisCanStart()
if invisActive then
return true
end
local character = LocalPlayer.Character
local humanoid = character and character:FindFirstChildOfClass("Humanoid")
if not character or not humanoid then
return false, "character not ready", true
end
if character.Parent ~= workspace then
return false, "character is not in workspace", true
end
if humanoid.Health <= 0 then
return false, "character is dead", true
end
local root = character:FindFirstChild("HumanoidRootPart")
if not root or not root:IsA("BasePart") then
return false, "HumanoidRootPart missing", true
end
if invisCountRoots(character) > 1 then
return false, "multiple HumanoidRootParts found"
end
local animator = humanoid:FindFirstChildOfClass("Animator")
if not animator then
return false, "Animator not ready", true
end
if not workspace.CurrentCamera then
return false, "camera not ready", true
end
return true
end

local function invisStart()
local allowed, message = invisCanStart()
if not allowed then
return false, message
end
if invisActive then
return true
end
local character = LocalPlayer.Character
local humanoid = character:FindFirstChildOfClass("Humanoid")
local root = character:FindFirstChild("HumanoidRootPart")
local animator = humanoid:FindFirstChildOfClass("Animator")
local camera = workspace.CurrentCamera
invisSavedStates = {}
for _, name in ipairs({"Dead", "FallingDown", "Ragdoll"}) do
local state = Enum.HumanoidStateType[name]
local ok, enabled = pcall(function()
return humanoid:GetStateEnabled(state)
end)
invisSavedStates[state] = not ok or enabled == true
pcall(function()
humanoid:SetStateEnabled(state, false)
end)
end
invisSavedHipHeight = humanoid.HipHeight
local replacement
local ok, err = invisWithDetachedCharacter(character, function()
replacement = root:Clone()
replacement.Parent = character
root.Parent = camera
replacement.CFrame = root.CFrame
character.PrimaryPart = replacement
end)
if not ok or not replacement or replacement.Parent ~= character or root.Parent ~= camera then
if root.Parent ~= character then
invisWithDetachedCharacter(character, function()
root.Parent = character
character.PrimaryPart = root
end)
end
if replacement and replacement ~= root then
pcall(function()
replacement:Destroy()
end)
end
if invisSavedStates then
for state, enabled in pairs(invisSavedStates) do
pcall(function()
humanoid:SetStateEnabled(state, enabled)
end)
end
end
invisSavedStates = nil
return false, "root swap failed: " .. tostring(err)
end
pcall(invisRewireJoints, character, root, replacement)
invisRealRoot = root
invisFakeRoot = replacement
invisCharacter = character
invisHumanoid = humanoid
invisActive = true
_G.RyInvisActive = true
_G.invisibleStealEnabled = true
invisAddConnection(RunService.PreSimulation:Connect(function()
if not invisActive or invisCharacter ~= character then
return
end
if not invisRealRoot or not humanoid.Parent or humanoid.Health <= 0 then
return
end
local visibleRoot = character.PrimaryPart or character:FindFirstChild("HumanoidRootPart")
if not visibleRoot or visibleRoot == invisRealRoot then
return
end
local target = visibleRoot.CFrame - Vector3.new(
0,
humanoid.HipHeight + visibleRoot.Size.Y / 2 - 1 + invisDepthOffset(),
0
)
local velocity = visibleRoot.AssemblyLinearVelocity
local moved = pcall(function()
invisRealRoot.CFrame = target * CFrame.Angles(math.rad(invisAngle()), 0, 0)
invisRealRoot.AssemblyLinearVelocity = velocity
invisRealRoot.CanCollide = false
local currentCamera = workspace.CurrentCamera
if currentCamera and invisRealRoot.Parent ~= currentCamera then
invisRealRoot.Parent = currentCamera
end
end)
if not moved and not invisRealRoot:IsDescendantOf(game) then
task.spawn(function()
invisStop("real root lost", true)
end)
end
end))
invisAddConnection(RunService.Heartbeat:Connect(function()
if not invisActive or not humanoid.Parent then
return
end
pcall(function()
humanoid.Health = humanoid.MaxHealth
humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
local state = humanoid:GetState()
if state == Enum.HumanoidStateType.Dead
or state == Enum.HumanoidStateType.FallingDown
or state == Enum.HumanoidStateType.Ragdoll then
humanoid:ChangeState(Enum.HumanoidStateType.Running)
end
end)
end))
if not invisPlayPose(character, humanoid, animator) then
invisStop("pose failed", true)
return false, "pose failed"
end
invisSavedTransparency = {}
for _, descendant in ipairs(character:GetDescendants()) do
if descendant:IsA("BasePart") then
invisSavedTransparency[descendant] = descendant.LocalTransparencyModifier
descendant.LocalTransparencyModifier = 1
end
end
invisAddConnection(character.DescendantAdded:Connect(function(descendant)
if not invisActive or not invisSavedTransparency or not descendant:IsA("BasePart") then
return
end
if invisSavedTransparency[descendant] == nil then
invisSavedTransparency[descendant] = descendant.LocalTransparencyModifier
end
pcall(function()
descendant.LocalTransparencyModifier = 1
end)
end))
return true
end

local function invisStartWithRetry(timeout)
local startedAt = os.clock()
local ok, message, retryable = invisCanStart()
while not ok and retryable and os.clock() - startedAt < (timeout or 3) do
task.wait(0.2)
if invisActive then
return true
end
if not invisibleStealEnabled then
return false, "disabled"
end
ok, message, retryable = invisCanStart()
end
if not ok then
return false, message
end
return invisStart()
end

function F.setInvisibleStealEnabled(state)
invisibleStealEnabled = not not state
if invisibleStealEnabled then
invisGeneration += 1
task.spawn(function()
local ok, message = invisStartWithRetry(3)
if not ok and invisibleStealEnabled then
warn("[WuzzHub/Invis] " .. tostring(message))
end
end)
else
invisStop("toggle", false)
end
end

function F.setInvisibleRotation(value)
invisibleRotation = math.clamp(tonumber(value) or invisibleRotation, 0, 360)
_G.RyInvisAngle = invisibleRotation
end

_G.RyInvisStart = function()
invisibleStealEnabled = true
local ok, message = invisStartWithRetry(3)
if not ok then
warn("[WuzzHub/Invis] " .. tostring(message))
end
return ok
end

_G.RyInvisStop = function(reason)
invisStop(reason or "external", false)
end

_G.RyInvisToggle = function()
F.setInvisibleStealEnabled(not invisibleStealEnabled)
return invisibleStealEnabled
end

_G.InvisStart = _G.RyInvisStart
_G.InvisStop = _G.RyInvisStop
_G.InvisToggle = _G.RyInvisToggle
_G.toggleInvisibleSteal = _G.RyInvisToggle

LocalPlayer.CharacterAdded:Connect(function()
local shouldRestart = invisibleStealEnabled
invisGeneration += 1
if invisActive or invisRealRoot or invisFakeRoot then
invisStop("respawn", true)
end
invisibleStealEnabled = shouldRestart
if shouldRestart then
task.delay(0.8, function()
if invisibleStealEnabled and not invisActive then
invisStartWithRetry(3)
end
end)
end
end)

local Lighting = game:GetService("Lighting")
local originalQualityLevel
local originalGlobalShadows
pcall(function()
originalQualityLevel = settings().Rendering.QualityLevel
originalGlobalShadows = Lighting.GlobalShadows
end)

local fpsBoostEnabled = false
local fpsSaved = {}
local fpsWorkspaceConnection
local fpsLightingConnection

function F.isWuzzVisualObject(object)
local current = object
while current and current ~= game do
local n = current.Name or ""
if string.sub(n, 1, 5) == "_Wuzz" or n == "WuzzHub" then
return true
end
current = current.Parent
end
return false
end

function F.saveFPSProperty(object, property)
if not object or not object.Parent then return end
fpsSaved[object] = fpsSaved[object] or {}
if fpsSaved[object][property] ~= nil then return end
local ok, value = pcall(function() return object[property] end)
if ok then
fpsSaved[object][property] = value
end
end

function F.setFPSProperty(object, property, value)
F.saveFPSProperty(object, property)
pcall(function() object[property] = value end)
end

function F.applyFPSObject(object)
if not fpsBoostEnabled or not object or F.isWuzzVisualObject(object) then return end
if object:IsA("ParticleEmitter")
or object:IsA("Trail")
or object:IsA("Beam")
or object:IsA("Smoke")
or object:IsA("Fire")
or object:IsA("Sparkles") then
F.setFPSProperty(object, "Enabled", false)
elseif object:IsA("Decal") or object:IsA("Texture") then
F.setFPSProperty(object, "Transparency", 1)
elseif object:IsA("MeshPart") then
F.setFPSProperty(object, "CastShadow", false)
F.setFPSProperty(object, "Material", Enum.Material.Plastic)
F.setFPSProperty(object, "Reflectance", 0)
F.setFPSProperty(object, "TextureID", "")
pcall(function()
F.setFPSProperty(object, "RenderFidelity", Enum.RenderFidelity.Performance)
end)
elseif object:IsA("BasePart") then
F.setFPSProperty(object, "CastShadow", false)
F.setFPSProperty(object, "Material", Enum.Material.Plastic)
F.setFPSProperty(object, "Reflectance", 0)
elseif object:IsA("SpecialMesh") then
F.setFPSProperty(object, "TextureId", "")
elseif object:IsA("SurfaceAppearance") then
for _, property in ipairs({"ColorMap", "NormalMap", "MetalnessMap", "RoughnessMap"}) do
F.setFPSProperty(object, property, "")
end
elseif object:IsA("Shirt") then
F.setFPSProperty(object, "ShirtTemplate", "")
elseif object:IsA("Pants") then
F.setFPSProperty(object, "PantsTemplate", "")
elseif object:IsA("ShirtGraphic") then
F.setFPSProperty(object, "Graphic", "")
elseif object:IsA("BloomEffect")
or object:IsA("BlurEffect")
or object:IsA("ColorCorrectionEffect")
or object:IsA("DepthOfFieldEffect")
or object:IsA("SunRaysEffect") then
F.setFPSProperty(object, "Enabled", false)
elseif object:IsA("Animator") then
pcall(function()
for _, track in ipairs(object:GetPlayingAnimationTracks()) do track:Stop(0) end
end)
elseif object:IsA("AnimationController") then
local animator = object:FindFirstChildOfClass("Animator")
if animator then pcall(function() for _, track in ipairs(animator:GetPlayingAnimationTracks()) do track:Stop(0) end end) end
elseif object:IsA("LocalScript") and object.Name == "Animate" then
local character = object:FindFirstAncestorOfClass("Model")
if character and Players:GetPlayerFromCharacter(character) then
F.setFPSProperty(object, "Disabled", true)
end
end
end

function F.stopCharacterAnimations()
if not fpsBoostEnabled then return end
for _, object in ipairs(workspace:GetDescendants()) do
if object:IsA("Animator") then
pcall(function()
for _, track in ipairs(object:GetPlayingAnimationTracks()) do track:Stop(0) end
end)
end
end
end

function F.restoreFPSBoost()
for object, properties in pairs(fpsSaved) do
if object and object.Parent then
for property, value in pairs(properties) do
pcall(function() object[property] = value end)
end
end
end
table.clear(fpsSaved)
pcall(function()
if originalQualityLevel then settings().Rendering.QualityLevel = originalQualityLevel end
if originalGlobalShadows ~= nil then Lighting.GlobalShadows = originalGlobalShadows end
end)
end

function F.setFPSBoost(state)
fpsBoostEnabled = not not state
if fpsBoostEnabled then
pcall(function()
settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
Lighting.GlobalShadows = false
end)
if setfpscap then pcall(setfpscap, 240) end

for _, object in ipairs(workspace:GetDescendants()) do
F.applyFPSObject(object)
end
for _, object in ipairs(Lighting:GetDescendants()) do
F.applyFPSObject(object)
end
local terrain = workspace:FindFirstChildOfClass("Terrain")
if terrain then
for property, value in pairs({
WaterWaveSize = 0,
WaterWaveSpeed = 0,
WaterReflectance = 0,
WaterTransparency = 1,
}) do
F.setFPSProperty(terrain, property, value)
end
end
if fpsWorkspaceConnection then fpsWorkspaceConnection:Disconnect() end
fpsWorkspaceConnection = workspace.DescendantAdded:Connect(function(object)
task.defer(F.applyFPSObject, object)
end)
if fpsLightingConnection then fpsLightingConnection:Disconnect() end
fpsLightingConnection = Lighting.DescendantAdded:Connect(function(object)
task.defer(F.applyFPSObject, object)
end)
F.stopCharacterAnimations()
else
if fpsWorkspaceConnection then fpsWorkspaceConnection:Disconnect(); fpsWorkspaceConnection = nil end
if fpsLightingConnection then fpsLightingConnection:Disconnect(); fpsLightingConnection = nil end
F.restoreFPSBoost()
end
end

task.spawn(function()
while Gui.Parent do
task.wait(.4)
F.stopCharacterAnimations()
end
end)

function F.setCameraFOV(value)
local camera = workspace.CurrentCamera
if camera then
camera.FieldOfView = math.clamp(value, 1, 120)
end
end

workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
local fov = SliderValues and SliderValues["FOV"]
if fov then F.setCameraFOV(fov) end
end)

local dataModules = {}
local animalLookupCache = {}
local traitIconCache = {}
local mpsCache = {}
local traitVisualCache = {}

function F.normalizeDataName(value)
return string.lower(tostring(value or ""):gsub("[%s%p_]+", ""))
end

function F.requireData(name)
if dataModules[name] ~= nil then return dataModules[name] end
local datas = ReplicatedStorage:FindFirstChild("Datas")
local module = datas and (datas:FindFirstChild(name) or datas:FindFirstChild(name, true))
local value = false
if module and module:IsA("ModuleScript") then
local ok, result = pcall(require, module)
if ok then value = result end
end
dataModules[name] = value
return value
end

function F.findDataRecord(root, wantedName)
if type(root) ~= "table" then return nil end
local wanted = F.normalizeDataName(wantedName)
if wanted == "" then return nil end
local seen = {}
local found

local function scan(tbl, depth)
if found or type(tbl) ~= "table" or seen[tbl] or depth > 4 then return end
seen[tbl] = true
for key, value in pairs(tbl) do
if found then return end
if type(value) == "table" then
local candidates = {
key,
value.Name,
value.DisplayName,
value.Display,
value.AnimalName,
value.Title,
value.Id,
value.ID,
}
for _, candidate in ipairs(candidates) do
if candidate ~= nil and F.normalizeDataName(candidate) == wanted then
found = value
return
end
end
scan(value, depth + 1)
elseif type(key) == "string" and F.normalizeDataName(key) == wanted then
found = value
return
end
end
end
scan(root, 0)
return found
end

function F.getAnimalData(name)
local key = F.normalizeDataName(name)
if animalLookupCache[key] ~= nil then
return animalLookupCache[key] or nil
end
local animals = F.requireData("Animals")
local record = F.findDataRecord(animals, name)
animalLookupCache[key] = record or false
return record
end

local knownDataNameCache = {}
local syncModuleCache = nil
local syncRecordCache = {}
local gcAnimalStateCache = {Time = 0, Tables = {}}

function F.getKnownDataNames(moduleName)
if knownDataNameCache[moduleName] then return knownDataNameCache[moduleName] end
local out = {}
local data = F.requireData(moduleName)
local seen = {}
local function scan(tbl, depth)
if type(tbl) ~= "table" or seen[tbl] or depth > 3 then return end
seen[tbl] = true
for key, value in pairs(tbl) do
if type(key) == "string" then out[F.normalizeDataName(key)] = key end
if type(value) == "table" then
for _, field in ipairs({"Name","DisplayName","Display","Title","Id","ID"}) do
local v = value[field]
if type(v) == "string" and v ~= "" then out[F.normalizeDataName(v)] = v end
end
scan(value, depth + 1)
end
end
end
scan(data, 0)
knownDataNameCache[moduleName] = out
return out
end

function F.getSynchronizerModule()
if syncModuleCache ~= nil then return syncModuleCache or nil end
for _, object in ipairs(ReplicatedStorage:GetDescendants()) do
if object:IsA("ModuleScript") then
local lower = string.lower(object.Name)
if string.find(lower, "synchronizer", 1, true) or string.find(lower, "replicator", 1, true) then
local ok, result = pcall(require, object)
if ok and type(result) == "table" then
syncModuleCache = result
return result
end
end
end
end
syncModuleCache = false
return nil
end

local sourceSyncChannelClass
local sourceSyncChannels = {}
local sourceSyncPulled = {}
local sourceSyncCacheAt = 0
local sourceSyncSweepAt = 0
local sourceSyncPullAt = {}

function F.getSourceSyncChannelClass()
if sourceSyncChannelClass ~= nil then return sourceSyncChannelClass or nil end
local ok, result = pcall(function()
return require(ReplicatedStorage:WaitForChild("Packages", 5):WaitForChild("Synchronizer", 5):WaitForChild("Channel", 5))
end)
if ok and type(result) == "table" then
sourceSyncChannelClass = result
return result
end
sourceSyncChannelClass = false
return nil
end

function F.getSyncChannelData(channel)
if type(channel) ~= "table" then return nil end
local cache = rawget(channel, "CacheTable")
if type(cache) == "table" then return cache end
local data = rawget(channel, "Data")
if type(data) == "table" then return data end
if type(rawget(channel, "AnimalList")) == "table"
or rawget(channel, "Owner") ~= nil then
return channel
end
return nil
end

function F.syncChannelScore(channel)
local data = F.getSyncChannelData(channel)
if type(data) ~= "table" then return 0 end
local score = 1
if rawget(data, "Owner") ~= nil then score += 3 end
local animals = rawget(data, "AnimalList") or rawget(data, "Animals")
if type(animals) == "table" then
score += 2
local count = 0
for _, value in pairs(animals) do
if type(value) == "table" then count += 1 end
end
score += math.min(count, 20) * 0.01
end
return score
end

function F.pullSourceSyncPlot(name)
if type(name) ~= "string" or name == "" then return nil end
local now = os.clock()
if now - (sourceSyncPullAt[name] or 0) < 1 then return sourceSyncPulled[name] end
sourceSyncPullAt[name] = now
local packages = ReplicatedStorage:FindFirstChild("Packages")
local synchronizer = packages and packages:FindFirstChild("Synchronizer")
local requestData = synchronizer and synchronizer:FindFirstChild("RequestData")
if not requestData or not requestData:IsA("RemoteFunction") then return nil end
local ok, result = pcall(function() return requestData:InvokeServer(name) end)
if ok and type(result) == "table" then
sourceSyncPulled[name] = result
sourceSyncCacheAt = 0
return result
end
return nil
end

function F.getSourceSyncChannels(force)
local now = os.clock()
if not force and next(sourceSyncChannels) and now - sourceSyncCacheAt < 0.25 then
return sourceSyncChannels
end
local channels = {}
for key, value in pairs(sourceSyncChannels) do
if type(value) == "table" then channels[key] = value end
end
local channelClass = F.getSourceSyncChannelClass()
if channelClass and type(getgc) == "function" and (force or now - sourceSyncSweepAt > 20 or not next(channels)) then
sourceSyncSweepAt = now
local ok, objects = pcall(getgc, true)
if ok and type(objects) == "table" then
for _, value in ipairs(objects) do
if type(value) == "table" and getmetatable(value) == channelClass then
local index = rawget(value, "Index")
if index ~= nil then
local current = channels[index]
if not current or F.syncChannelScore(value) > F.syncChannelScore(current) then
channels[index] = value
end
end
end
end
end
end
local upvalueReader = type(debug) == "table" and debug.getupvalues or getupvalues
if type(getconnections) == "function" and type(upvalueReader) == "function" then
local packages = ReplicatedStorage:FindFirstChild("Packages")
local synchronizer = packages and packages:FindFirstChild("Synchronizer")
local channelContainer = synchronizer and synchronizer:FindFirstChild("Channel")
if channelContainer then
for _, child in ipairs(channelContainer:GetChildren()) do
if child:IsA("RemoteEvent") then
local ok, connections = pcall(getconnections, child.OnClientEvent)
if ok and type(connections) == "table" then
for _, connection in ipairs(connections) do
local fn
pcall(function() fn = connection.Function end)
if type(fn) == "function" then
local ok2, values = pcall(upvalueReader, fn)
if ok2 and type(values) == "table" then
for _, value in pairs(values) do
if type(value) == "table" and type(rawget(value, "CacheTable")) == "table" then
local current = channels[child.Name]
if not current or F.syncChannelScore(value) > F.syncChannelScore(current) then
channels[child.Name] = value
end
break
end
end
end
end
if channels[child.Name] then break end
end
end
end
end
end
end
for key, data in pairs(sourceSyncPulled) do
local current = channels[key]
local wrapped = {CacheTable = data}
if not current or F.syncChannelScore(wrapped) > F.syncChannelScore(current) then
channels[key] = wrapped
end
end
local plots = workspace:FindFirstChild("Plots")
if plots then
for _, plot in ipairs(plots:GetChildren()) do
if channels[plot.Name] == nil then
local pulled = F.pullSourceSyncPlot(plot.Name)
if type(pulled) == "table" then
channels[plot.Name] = {CacheTable = pulled}
end
end
end
end
sourceSyncChannels = channels
sourceSyncCacheAt = os.clock()
return sourceSyncChannels
end

function F.getSourcePlotData(plotName)
local channels = F.getSourceSyncChannels(false)
local channel = channels and channels[plotName]
local data = F.getSyncChannelData(channel)
if type(data) == "table" then return data, channel end
local pulled = F.pullSourceSyncPlot(plotName)
if type(pulled) == "table" then return pulled, {CacheTable = pulled} end
return nil, nil
end

function F.syncOwnerIsLocal(owner)
if owner == nil then return false end
if typeof(owner) == "Instance" and owner:IsA("Player") then return owner.UserId == LocalPlayer.UserId end
if type(owner) == "number" then return owner == LocalPlayer.UserId end
if type(owner) == "table" then
if tonumber(owner.UserId) then return tonumber(owner.UserId) == LocalPlayer.UserId end
if owner.Name then owner = owner.Name else return false end
end
if type(owner) == "string" then
local lower = string.lower(owner)
return lower == string.lower(LocalPlayer.Name)
or lower == string.lower(LocalPlayer.DisplayName or LocalPlayer.Name)
end
return false
end

function F.syncOwnerInGame(owner)
if owner == nil then return false end
if typeof(owner) == "Instance" and owner:IsA("Player") then return Players:FindFirstChild(owner.Name) ~= nil end
if type(owner) == "number" then return Players:GetPlayerByUserId(owner) ~= nil end
if type(owner) == "table" then
if tonumber(owner.UserId) then return Players:GetPlayerByUserId(tonumber(owner.UserId)) ~= nil end
if owner.Name then owner = owner.Name else return false end
end
if type(owner) == "string" then
if Players:FindFirstChild(owner) then return true end
local lower = string.lower(owner)
for _, player in ipairs(Players:GetPlayers()) do
if string.lower(player.Name) == lower
or string.lower(player.DisplayName or "") == lower then
return true
end
end
end
return false
end

_G.SyncAll = function() return F.getSourceSyncChannels(false) end
_G.SyncGet = function(name)
local channels = F.getSourceSyncChannels(false)
return channels and channels[name] or nil
end

function F.extractAnimalRecordFromTable(root, slotName, animalName)
if type(root) ~= "table" then return nil end
local wantedSlot = tostring(slotName or "")
local wantedAnimal = F.normalizeDataName(animalName)
local seen = {}
local found
local function testList(list)
if type(list) ~= "table" then return nil end
local direct = list[wantedSlot] or list[tonumber(wantedSlot)]
if type(direct) == "table" then return direct end
for key, record in pairs(list) do
if type(record) == "table" then
local slotValue = record.Slot or record.SlotIndex or record.IndexSlot or record.Podium or record.PodiumIndex
if slotValue ~= nil and tostring(slotValue) == wantedSlot then return record end
local idx = record.Index or record.Name or record.Animal or record.AnimalName
if wantedAnimal ~= "" and idx ~= nil and F.normalizeDataName(idx) == wantedAnimal then return record end
end
end
return nil
end
local function scan(tbl, depth)
if found or type(tbl) ~= "table" or seen[tbl] or depth > 4 then return end
seen[tbl] = true
local animalList = rawget(tbl, "AnimalList") or rawget(tbl, "Animals")
found = testList(animalList)
if found then return end
local dotted = rawget(tbl, "AnimalList." .. wantedSlot)
if type(dotted) == "table" then found = dotted return end
for key, value in pairs(tbl) do
if found then return end
if type(key) == "string" and string.lower(key) == string.lower("AnimalList." .. wantedSlot) and type(value) == "table" then
found = value
return
end
if type(value) == "table" then scan(value, depth + 1) end
end
end
scan(root, 0)
return found
end

function F.getGCAnimalStateTables()
if not getgc then return {} end
if os.clock() - gcAnimalStateCache.Time < 2 then return gcAnimalStateCache.Tables end
gcAnimalStateCache.Time = os.clock()
local out = {}
local ok, objects = pcall(getgc, true)
if ok and type(objects) == "table" then
local checked = 0
for _, value in ipairs(objects) do
if type(value) == "table" then
checked += 1
local hasAnimalList = rawget(value, "AnimalList") ~= nil or rawget(value, "Animals") ~= nil
if not hasAnimalList then
for key in pairs(value) do
if type(key) == "string" and string.sub(string.lower(key), 1, 11) == "animallist." then hasAnimalList = true break end
end
end
if hasAnimalList then table.insert(out, value) end
if checked >= 3500 then break end
end
end
end
gcAnimalStateCache.Tables = out
return out
end

function F.getSyncedAnimalRecord(plot, slot, animalName)
local plotName = typeof(plot) == "Instance" and plot.Name or tostring(plot or "")
local slotName = typeof(slot) == "Instance" and slot.Name or tostring(slot or "")
if plotName == "" or slotName == "" then return nil end
local data = F.getSourcePlotData(plotName)
if type(data) == "table" then
local record = F.extractAnimalRecordFromTable(data, slotName, animalName)
if type(record) == "table" then return record end
end
for _, state in ipairs(F.getGCAnimalStateTables()) do
local record = F.extractAnimalRecordFromTable(state, slotName, animalName)
if type(record) == "table" then
local owner = rawget(state, "Owner")
if owner == nil or F.syncOwnerIsLocal(owner) == F.plotBelongsToLocalPlayer(plot) then
return record
end
end
end
return nil
end

function F.compactNumber(value)
value = tonumber(value)
if not value then return tostring(value or "?") end
local abs = math.abs(value)
local units = {
{1e12, "T"},
{1e9, "B"},
{1e6, "M"},
{1e3, "K"},
}
for _, unit in ipairs(units) do
if abs >= unit[1] then
local n = value / unit[1]
if math.abs(n) >= 100 then
return string.format("%.0f%s", n, unit[2])
elseif math.abs(n) >= 10 then
return string.format("%.1f%s", n, unit[2])
else
return string.format("%.2f%s", n, unit[2])
end
end
end
return tostring(math.floor(value + .5))
end


function F.parseCompactNumber(text)
if type(text) == "number" then return text end
if type(text) ~= "string" then return 0 end
local cleaned = string.upper(text):gsub(",", "")
local n, suffix = cleaned:match("([%d%.]+)%s*([KMBT]?)")
n = tonumber(n)
if not n then return 0 end
local mult = ({K=1e3,M=1e6,B=1e9,T=1e12})[suffix] or 1
return n * mult
end

function F.readMPSFromObject(object)
if not object then return nil end
for attributeName, attributeValue in pairs(object:GetAttributes()) do
local lower = string.lower(attributeName)
if type(attributeValue) == "number"
and (string.find(lower, "income", 1, true)
or string.find(lower, "mps", 1, true)
or string.find(lower, "persecond", 1, true)
or string.find(lower, "moneypersecond", 1, true)) then
return "$" .. F.compactNumber(attributeValue) .. "/s"
elseif type(attributeValue) == "string"
and (string.find(lower, "income", 1, true)
or string.find(lower, "mps", 1, true)
or string.find(lower, "persecond", 1, true)) then
return attributeValue
end
end

if object:IsA("NumberValue") or object:IsA("IntValue") then
local lower = string.lower(object.Name)
if string.find(lower, "income", 1, true)
or string.find(lower, "mps", 1, true)
or string.find(lower, "persecond", 1, true) then
return "$" .. F.compactNumber(object.Value) .. "/s"
end
elseif object:IsA("TextLabel") or object:IsA("TextButton") or object:IsA("TextBox") then
local text = object.Text
if type(text) == "string" and text ~= "" then
local lower = string.lower(text)
if string.find(lower, "/s", 1, true)
or string.find(lower, "per second", 1, true)
or string.find(lower, "mps", 1, true) then
return text
end
end
end
return nil
end

function F.getBrainrotMPS(slot, prompt)
local cache = slot and mpsCache[slot]
if cache and os.clock() - cache.Time < 1.2 then return cache.Value, cache.Numeric end
local value = F.readMPSFromObject(prompt) or F.readMPSFromObject(slot)
if not value and slot then
for _, object in ipairs(slot:GetDescendants()) do
value = F.readMPSFromObject(object)
if value then break end
end
end
if not value and slot then
for _, gui in ipairs(slot:GetDescendants()) do
if gui:IsA("BillboardGui") or gui:IsA("SurfaceGui") then
for _, object in ipairs(gui:GetDescendants()) do
value = F.readMPSFromObject(object)
if value then break end
end
if value then break end
end
end
end
if not value and prompt then
local data = F.getAnimalData(prompt.ObjectText)
if type(data) == "table" then
for key, candidate in pairs(data) do
local lower = string.lower(tostring(key))
if type(candidate) == "number" and (string.find(lower,"income",1,true) or string.find(lower,"mps",1,true) or string.find(lower,"persecond",1,true) or string.find(lower,"generation",1,true)) then
value = "$" .. F.compactNumber(candidate) .. "/s"
break
end
end
end
end
value = value or "MPS N/A"
local numeric = F.parseCompactNumber(value)
if slot then mpsCache[slot] = {Time=os.clock(), Value=value, Numeric=numeric} end
return value, numeric
end

function F.normalizeIcon(value)
if type(value) == "number" then
return "rbxassetid://" .. tostring(math.floor(value))
elseif type(value) == "string" and value ~= "" then
if string.match(value, "^%d+$") then
return "rbxassetid://" .. value
end
return value
end
return nil
end

function F.lookupTraitIcon(name)
local key = F.normalizeDataName(name)
if traitIconCache[key] ~= nil then return traitIconCache[key] or nil end
for _, moduleName in ipairs({"Traits", "Mutations"}) do
local data = F.requireData(moduleName)
local record = F.findDataRecord(data, name)
if type(record) == "table" then
for _, field in ipairs({"Icon", "Image", "ImageId", "IconId", "Texture", "Asset"}) do
local icon = F.normalizeIcon(record[field])
if icon then
traitIconCache[key] = icon
return icon
end
end
end
end
traitIconCache[key] = false
return nil
end

function F.addTraitVisual(list, seen, name, icon)
name = tostring(name or "")
if name == "" then return end
local key = F.normalizeDataName(name)
if key == "" or seen[key] then return end
seen[key] = true
table.insert(list, {
Name = name,
Icon = F.normalizeIcon(icon) or F.lookupTraitIcon(name),
})
end

function F.resolveDataDisplayName(moduleName, value)
if value == nil then return nil end
local data = F.requireData(moduleName)
if type(value) == "string" then
local record = F.findDataRecord(data, value)
if type(record) == "table" then
return record.DisplayName or record.Name or record.Display or record.Title or value
end
return value
elseif type(value) == "number" and type(data) == "table" then
local direct = data[value] or data[tostring(value)]
if type(direct) == "table" then
return direct.DisplayName or direct.Name or direct.Display or direct.Title or tostring(value)
elseif type(direct) == "string" then
return direct
end
local seen = {}
local found
local function scan(tbl, depth)
if found or type(tbl) ~= "table" or seen[tbl] or depth > 3 then return end
seen[tbl] = true
for _, record in pairs(tbl) do
if type(record) == "table" then
local id = record.Id or record.ID or record.Index
if tonumber(id) == value then
found = record.DisplayName or record.Name or record.Display or record.Title or tostring(value)
return
end
scan(record, depth + 1)
end
end
end
scan(data, 0)
return found or tostring(value)
end
return tostring(value)
end

function F.addMetadataFromRecord(record, list, seen, mutationHolder)
if type(record) ~= "table" then return end
for _, field in ipairs({"Mutation","MutationName","MutationId","MutationID"}) do
local value = record[field]
if value ~= nil and value ~= false and value ~= 0 and tostring(value) ~= "" then
mutationHolder.Value = F.resolveDataDisplayName("Mutations", value) or tostring(value)
break
end
end
for _, field in ipairs({"Traits","Trait","TraitList","ActiveTraits"}) do
local value = record[field]
if type(value) == "string" then
for token in string.gmatch(value, "[^,|;/]+") do
F.addTraitVisual(list, seen, token:gsub("^%s+", ""):gsub("%s+$", ""))
end
elseif type(value) == "table" then
for key, enabled in pairs(value) do
if enabled and enabled ~= 0 and enabled ~= false then
local name = type(key) == "string" and key or enabled
if type(name) == "string" or type(name) == "number" then
name = F.resolveDataDisplayName("Traits", name) or name
F.addTraitVisual(list, seen, name)
end
end
end
end
end
end

function F.scanMetadataObject(root, list, seen, mutationHolder)
if not root then return end
local knownTraits = F.getKnownDataNames("Traits")
local knownMutations = F.getKnownDataNames("Mutations")
local objects = {root}
for _, object in ipairs(root:GetDescendants()) do table.insert(objects, object) end
for _, object in ipairs(objects) do
local rawName = tostring(object.Name or "")
local traitName = rawName:match("^_Trait[%.%_%-](.+)$") or rawName:match("^_Trait(.+)$")
if traitName and traitName ~= "" then
local icon = (object:IsA("ImageLabel") or object:IsA("ImageButton")) and object.Image or nil
F.addTraitVisual(list, seen, traitName:gsub("^[%._%-]+", ""), icon)
end
for attributeName, attributeValue in pairs(object:GetAttributes()) do
local lower = string.lower(attributeName)
if string.find(lower, "mutation", 1, true) and attributeValue ~= nil and tostring(attributeValue) ~= "" then
mutationHolder.Value = tostring(attributeValue)
elseif string.find(lower, "trait", 1, true) then
if type(attributeValue) == "string" then
for token in string.gmatch(attributeValue, "[^,|;/]+") do F.addTraitVisual(list, seen, token:gsub("^%s+", ""):gsub("%s+$", "")) end
elseif attributeValue == true then
F.addTraitVisual(list, seen, attributeName:gsub("^[Tt]rait[_%.%-]*", ""))
end
end
end
if object:IsA("StringValue") then
local lower = string.lower(rawName)
if string.find(lower, "mutation", 1, true) and object.Value ~= "" then
mutationHolder.Value = tostring(object.Value)
elseif string.find(lower, "trait", 1, true) and object.Value ~= "" then
F.addTraitVisual(list, seen, object.Value)
end
elseif object:IsA("ImageLabel") or object:IsA("ImageButton") then
local parentName = object.Parent and tostring(object.Parent.Name) or ""
local candidate = object:GetAttribute("Trait") or object:GetAttribute("Mutation") or object:GetAttribute("DisplayName") or rawName
local norm = F.normalizeDataName(candidate)
if knownTraits[norm] then F.addTraitVisual(list, seen, knownTraits[norm], object.Image) end
if knownMutations[norm] and not mutationHolder.Value then mutationHolder.Value = knownMutations[norm] end
local parentNorm = F.normalizeDataName(parentName)
if knownTraits[parentNorm] then F.addTraitVisual(list, seen, knownTraits[parentNorm], object.Image) end
if knownMutations[parentNorm] and not mutationHolder.Value then mutationHolder.Value = knownMutations[parentNorm] end
elseif object:IsA("TextLabel") or object:IsA("TextButton") or object:IsA("TextBox") then
local text = tostring(object.Text or "")
if text ~= "" then
local norm = F.normalizeDataName(text)
if knownTraits[norm] then F.addTraitVisual(list, seen, knownTraits[norm]) end
if knownMutations[norm] and not mutationHolder.Value then mutationHolder.Value = knownMutations[norm] end
local afterMutation = text:match("[Mm]utation%s*:%s*(.+)")
if afterMutation and afterMutation ~= "" then mutationHolder.Value = afterMutation end
local afterTrait = text:match("[Tt]raits?%s*:%s*(.+)")
if afterTrait then
for token in string.gmatch(afterTrait, "[^,|;/]+") do F.addTraitVisual(list, seen, token:gsub("^%s+", ""):gsub("%s+$", "")) end
end
end
end
end
end

function F.getBrainrotMetadata(slot, animalName, adornee, prompt, plot)
local cache = slot and traitVisualCache[slot]
if cache and os.clock() - cache.Time < 1.1 then return cache.Value, cache.Mutation end
local list, seen = {}, {}
local mutationHolder = {Value=nil}

F.scanMetadataObject(slot, list, seen, mutationHolder)
if adornee and adornee ~= slot then F.scanMetadataObject(adornee, list, seen, mutationHolder) end
if prompt then F.scanMetadataObject(prompt, list, seen, mutationHolder) end

local data = F.getAnimalData(animalName)
if #list == 0 or not mutationHolder.Value then
F.addMetadataFromRecord(data, list, seen, mutationHolder)
end

local mutation = mutationHolder.Value
if mutation then
local known = F.getKnownDataNames("Mutations")
local normalized = F.normalizeDataName(mutation)
mutation = known[normalized] or tostring(mutation)
end
if slot then traitVisualCache[slot] = {Time=os.clock(), Value=list, Mutation=mutation} end
return list, mutation
end

function F.getTraitVisuals(slot, animalName, adornee, prompt, plot)
local list = F.getBrainrotMetadata(slot, animalName, adornee, prompt, plot)
return list
end

function F.getPromptAttachment(slot)
local base = slot and slot:FindFirstChild("Base")
local spawnPart = base and base:FindFirstChild("Spawn")
local attachment = spawnPart and spawnPart:FindFirstChild("PromptAttachment")
return attachment, spawnPart
end

function F.chooseBrainrotPrompt(slot)
local attachment, spawnPart = F.getPromptAttachment(slot)
if not attachment then return nil, spawnPart end
local best, bestPriority = nil, -1
for _, object in ipairs(attachment:GetChildren()) do
if object:IsA("ProximityPrompt") and object.ObjectText and object.ObjectText ~= "" then
local action = string.lower(object.ActionText or "")
local priority = action == "steal" and 4 or (action == "grab" and 3 or (action == "collect" and 2 or 1))
if priority > bestPriority then
best, bestPriority = object, priority
end
end
end
return best, spawnPart
end

function F.readPriceFromObject(object)
if not object then return nil end
local attributeNames = {"Price", "Cost", "BuyPrice", "CashPrice", "ValuePrice"}
for _, attributeName in ipairs(attributeNames) do
local value = object:GetAttribute(attributeName)
if type(value) == "number" then
return "$" .. F.compactNumber(value)
elseif type(value) == "string" and value ~= "" then
return value
end
end
if object:IsA("IntValue") or object:IsA("NumberValue") then
local lowerName = string.lower(object.Name)
if string.find(lowerName, "price", 1, true) or string.find(lowerName, "cost", 1, true) then
return "$" .. F.compactNumber(object.Value)
end
elseif object:IsA("StringValue") then
local lowerName = string.lower(object.Name)
if string.find(lowerName, "price", 1, true) or string.find(lowerName, "cost", 1, true) then
return object.Value
end
elseif object:IsA("TextLabel") or object:IsA("TextButton") or object:IsA("TextBox") then
local value = object.Text
if type(value) == "string" and value ~= "" then
local lower = string.lower(value)
if string.find(value, "$", 1, true)
or string.find(lower, "price", 1, true)
or string.find(lower, "cost", 1, true) then
return value
end
end
end
return nil
end

function F.getBrainrotPrice(slot, prompt)
for _, object in ipairs({prompt, slot}) do
local price = F.readPriceFromObject(object)
if price then return price end
end
if slot then
for _, object in ipairs(slot:GetDescendants()) do
local price = F.readPriceFromObject(object)
if price then return price end
end
end
return "PRICE N/A"
end

local safeDataReady = false
local safeAnimalsData
local safeSharedAnimals
local safeTraitByIcon = {}
local safeTraitByName = {}
local safeAnimalByDisplay = {}
local overheadCacheAt = 0
local overheadCache = {}

local function normalizeAsset(value)
if value == nil then return "" end
local text = tostring(value)
local best = ""
for digits in string.gmatch(text, "%d+") do
if #digits > #best then best = digits end
end
if best ~= "" then return best end
return string.lower(text):gsub("[^%w]", "")
end

function F.initSafeBrainrotData()
if safeDataReady then return end
safeDataReady = true
pcall(function()
safeAnimalsData = require(ReplicatedStorage:WaitForChild("Datas"):WaitForChild("Animals"))
for key, record in pairs(safeAnimalsData) do
if type(record) == "table" then
local display = record.DisplayName or record.Name or key
safeAnimalByDisplay[F.normalizeDataName(display)] = key
safeAnimalByDisplay[F.normalizeDataName(key)] = key
end
end
end)
pcall(function()
safeSharedAnimals = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Animals"))
end)
pcall(function()
local traits = require(ReplicatedStorage:WaitForChild("Datas"):WaitForChild("Traits"))
for key, record in pairs(traits) do
if type(record) == "table" then
local icon = normalizeAsset(record.Icon or record.Image or record.ImageId or record.IconId)
local info = {
Key = tostring(key),
Name = tostring(record.Display or record.DisplayName or record.Name or key),
Icon = F.normalizeIcon(record.Icon or record.Image or record.ImageId or record.IconId),
}
if icon ~= "" then safeTraitByIcon[icon] = info end
safeTraitByName[F.normalizeDataName(key)] = info
safeTraitByName[F.normalizeDataName(info.Name)] = info
if record.Display then safeTraitByName[F.normalizeDataName(record.Display)] = info end
end
end
end)
end

function F.refreshOverheadCache(force)
local now = os.clock()
if not force and now - overheadCacheAt < 1 then return end
overheadCacheAt = now
table.clear(overheadCache)
local debris = workspace:FindFirstChild("Debris")
if not debris then return end
for _, part in ipairs(debris:GetChildren()) do
if part:IsA("BasePart") then
local gui = part:FindFirstChild("AnimalOverhead") or part:FindFirstChild("AnimalOverhead", true)
if gui and (gui:IsA("SurfaceGui") or gui:IsA("BillboardGui"))
and gui:FindFirstChild("DisplayName") and gui:FindFirstChild("Generation") then
table.insert(overheadCache, {Part = part, Gui = gui})
end
end
end
end

function F.findOverheadForSpawn(spawnPart)
if not spawnPart then return nil end
F.refreshOverheadCache(false)
local best, bestDistance
for _, entry in ipairs(overheadCache) do
if entry.Part.Parent and entry.Gui.Parent then
local d = (entry.Part.Position - spawnPart.Position).Magnitude
if d <= 12 and (not bestDistance or d < bestDistance) then
best, bestDistance = entry.Gui, d
end
end
end
return best
end

function F.chooseBrainrotPrompt(slot)
local base = slot and slot:FindFirstChild("Base")
local spawnPart = base and base:FindFirstChild("Spawn")
local attachment = spawnPart and spawnPart:FindFirstChild("PromptAttachment")
if not attachment then return nil, spawnPart end
local best, bestPriority = nil, -1
for _, prompt in ipairs(attachment:GetChildren()) do
if prompt:IsA("ProximityPrompt") then
local state = tostring(prompt:GetAttribute("State") or "")
local action = tostring(prompt.ActionText or "")
local objectText = tostring(prompt.ObjectText or "")
local priority = 0
if state == "Steal" or string.lower(action) == "steal" then priority = 5
elseif state == "Grab" or string.lower(action) == "grab" then priority = 4
elseif state == "Collect" or string.lower(action) == "collect" then priority = 3
elseif objectText ~= "" and state ~= "None" then priority = 1 end
if objectText ~= "" and priority > bestPriority then
best, bestPriority = prompt, priority
end
end
end
return best, spawnPart
end

local brainrotAdorneeCache = {}

function F.findBrainrotAdornee(slot, promptName, plot)
if not slot or not plot then return nil end
local _, spawnPart = F.getPromptAttachment(slot)
if not spawnPart then return nil end
local cached = brainrotAdorneeCache[slot]
if cached and os.clock() - cached.Time < 2 and cached.Value and cached.Value.Parent then
return cached.Value
end

local wanted = F.normalizeDataName(promptName)
local best, bestScore
for _, object in ipairs(plot:GetChildren()) do
if object:IsA("Model") then
local fakeRoot = object:FindFirstChild("FakeRootPart", true)
if fakeRoot and fakeRoot:IsA("BasePart") then
local d = (fakeRoot.Position - spawnPart.Position).Magnitude
if d <= 18 then
local score = 80 - d * 4
local nameNorm = F.normalizeDataName(object.Name)
if wanted ~= "" and (nameNorm == wanted or string.find(nameNorm, wanted, 1, true) or string.find(wanted, nameNorm, 1, true)) then score += 180 end
if not bestScore or score > bestScore then best, bestScore = object, score end
end
end
end
end

if not best then
for _, object in ipairs(slot:GetDescendants()) do
if object:IsA("Model") then
local fakeRoot = object:FindFirstChild("FakeRootPart", true)
if fakeRoot and fakeRoot:IsA("BasePart") then
best = object
break
end
end
end
end

if not best then
F.refreshOverheadCache(false)
local nearest, nearestDistance
for _, entry in ipairs(overheadCache) do
if entry.Part and entry.Part.Parent then
local d = (entry.Part.Position - spawnPart.Position).Magnitude
if d <= 12 and (not nearestDistance or d < nearestDistance) then
nearest, nearestDistance = entry.Part, d
end
end
end
best = nearest
end

local result = best or spawnPart
brainrotAdorneeCache[slot] = {Time = os.clock(), Value = result}
return result
end

function F.readSafeOverhead(slot, adornee)
local _, spawnPart = F.getPromptAttachment(slot)
local gui
if adornee and adornee:IsA("Model") then
gui = adornee:FindFirstChild("AnimalOverhead", true)
end
if not gui and slot then gui = slot:FindFirstChild("AnimalOverhead", true) end
if not gui then gui = F.findOverheadForSpawn(spawnPart) end
return gui
end

function F.collectTraitNode(node, list, seen)
if not node then return end
local rawName = tostring(node.Name or "")
local direct = rawName:match("^_Trait[%.%_%-](.+)$")
if direct and direct ~= "" then
local info = safeTraitByName[F.normalizeDataName(direct)]
F.addTraitVisual(list, seen, info and info.Name or direct, info and info.Icon or nil)
end
if rawName == "_Trait" or rawName == "Traits" then
for _, child in ipairs(node:GetDescendants()) do
local name = tostring(child.Name or "")
local value
if child:IsA("StringValue") then value = child.Value
elseif child:IsA("BoolValue") and child.Value then value = name
elseif child:IsA("IntValue") or child:IsA("NumberValue") then
if child.Value ~= 0 then value = name end
end
value = child:GetAttribute("Trait") or child:GetAttribute("DisplayName") or child:GetAttribute("Name") or value
local image = (child:IsA("ImageLabel") or child:IsA("ImageButton")) and child.Image or nil
local byIcon = image and safeTraitByIcon[normalizeAsset(image)] or nil
if byIcon then
F.addTraitVisual(list, seen, byIcon.Name, byIcon.Icon)
elseif value and tostring(value) ~= "" then
local info = safeTraitByName[F.normalizeDataName(value)]
F.addTraitVisual(list, seen, info and info.Name or value, info and info.Icon or image)
elseif name ~= "" and name ~= "Template" and name ~= "UIListLayout" and name ~= "UIPadding" then
local info = safeTraitByName[F.normalizeDataName(name)]
if info then F.addTraitVisual(list, seen, info.Name, info.Icon) end
end
end
end
end

function F.collectTraitsBounded(root, list, seen)
if not root then return end
F.collectTraitNode(root, list, seen)
for _, object in ipairs(root:GetDescendants()) do
local name = tostring(object.Name or "")
if name == "_Trait" or name == "Traits" or name:match("^_Trait[%.%_%-]") then
F.collectTraitNode(object, list, seen)
elseif object:IsA("ImageLabel") or object:IsA("ImageButton") then
local info = safeTraitByIcon[normalizeAsset(object.Image)]
if info then F.addTraitVisual(list, seen, info.Name, info.Icon) end
end
end
end

function F.getBrainrotMetadata(slot, animalName, adornee, prompt, plot)
local cache = slot and traitVisualCache[slot]
if cache and os.clock() - cache.Time < 1.25 then return cache.Value, cache.Mutation end
F.initSafeBrainrotData()
local list, seen = {}, {}
local mutationHolder = {Value=nil}

F.collectTraitsBounded(slot, list, seen)
if adornee and adornee ~= slot then F.collectTraitsBounded(adornee, list, seen) end
if prompt then
local mutation = prompt:GetAttribute("Mutation")
if mutation ~= nil and tostring(mutation) ~= "" then mutationHolder.Value = tostring(mutation) end
end

local overhead = F.readSafeOverhead(slot, adornee)
if overhead then
F.collectTraitsBounded(overhead, list, seen)
local mutationLabel = overhead:FindFirstChild("Mutation", true)
if mutationLabel and mutationLabel:IsA("TextLabel") and tostring(mutationLabel.Text or "") ~= "" then
mutationHolder.Value = mutationLabel.Text
end
end

if adornee then
for attributeName, attributeValue in pairs(adornee:GetAttributes()) do
local lower = string.lower(tostring(attributeName))
if string.find(lower, "mutation", 1, true) and attributeValue ~= nil and tostring(attributeValue) ~= "" then
mutationHolder.Value = tostring(attributeValue)
elseif string.find(lower, "trait", 1, true) and type(attributeValue) == "string" then
for token in string.gmatch(attributeValue, "[^,|;/]+") do
F.addTraitVisual(list, seen, token:gsub("^%s+", ""):gsub("%s+$", ""))
end
end
end
local ok, tags = pcall(CollectionService.GetTags, CollectionService, adornee)
if ok and type(tags) == "table" then
local knownTraits = F.getKnownDataNames("Traits")
for _, tag in ipairs(tags) do
local known = knownTraits[F.normalizeDataName(tag)]
if known then F.addTraitVisual(list, seen, known) end
end
end
end

local data = F.getAnimalData(animalName)
if type(data) == "table" then F.addMetadataFromRecord(data, list, seen, mutationHolder) end

local mutation = mutationHolder.Value
if mutation then
local known = F.getKnownDataNames("Mutations")
mutation = known[F.normalizeDataName(mutation)] or tostring(mutation)
end
if slot then traitVisualCache[slot] = {Time=os.clock(), Value=list, Mutation=mutation} end
return list, mutation
end

function F.getBrainrotPriceSafe(slot, adornee)
local overhead = F.readSafeOverhead(slot, adornee)
if overhead then
local price = overhead:FindFirstChild("Price")
if price and price:IsA("TextLabel") and price.Text ~= "" then return price.Text end
end
return "PRICE N/A"
end

function F.getBrainrotMPS(slot, prompt, adornee, plot)
F.initSafeBrainrotData()
local overhead = F.readSafeOverhead(slot, adornee)
if overhead then
local generation = overhead:FindFirstChild("Generation")
if generation and generation:IsA("TextLabel") and generation.Text ~= "" then
local value = generation.Text
return value, F.parseCompactNumber(value)
end
end

local display = prompt and prompt.ObjectText or nil
local index = display and safeAnimalByDisplay[F.normalizeDataName(display)] or nil
if index and safeSharedAnimals and type(safeSharedAnimals.GetGeneration) == "function" then
local traits, mutation = F.getBrainrotMetadata(slot, display, adornee, prompt, plot)
local traitKeys = {}
for _, trait in ipairs(traits) do table.insert(traitKeys, trait.Key or trait.Name) end
local ok, amount = pcall(function()
return safeSharedAnimals:GetGeneration(index, mutation, #traitKeys > 0 and traitKeys or nil, nil)
end)
if ok and type(amount) == "number" then
local value = "$" .. F.compactNumber(amount) .. "/s"
return value, amount
end
end
return "MPS N/A", 0
end

function F.readBrainrotNameFromOverhead(overhead)
if not overhead then return nil end
for _, name in ipairs({"DisplayName", "Name", "AnimalName", "BrainrotName"}) do
local object = overhead:FindFirstChild(name, true)
if object and (object:IsA("TextLabel") or object:IsA("TextButton") or object:IsA("TextBox")) then
local text = tostring(object.Text or ""):gsub("^%s+", ""):gsub("%s+$", "")
if text ~= "" then return text end
end
end
return nil
end

function F.findNearestPodiumSlot(podiums, part)
if not podiums or not part then return nil, nil end
local bestSlot, bestSpawn, bestDistance
for _, slot in ipairs(podiums:GetChildren()) do
local _, spawnPart = F.getPromptAttachment(slot)
if spawnPart then
local d = (spawnPart.Position - part.Position).Magnitude
if d <= 18 and (not bestDistance or d < bestDistance) then
bestSlot, bestSpawn, bestDistance = slot, spawnPart, d
end
end
end
return bestSlot, bestSpawn
end

local blockedBrainrotMachines = {
Fuse = true,
Duel = true,
Trade = true,
Crafting = true,
}

function F.syncRecordBlocked(record)
if type(record) ~= "table" then return true end
local machine = record.Machine
return type(machine) == "table" and blockedBrainrotMachines[machine.Type] == true
end

function F.getSyncRecordName(record)
if type(record) ~= "table" then return nil, nil end
F.initSafeBrainrotData()
local index = record.Index or record.Animal or record.AnimalIndex or record.Name
if index == nil then return nil, nil end
local data = safeAnimalsData and safeAnimalsData[index]
local display
if type(data) == "table" then
display = data.DisplayName or data.Name or data.Display or data.Title
elseif type(data) == "string" then
display = data
end
return tostring(display or index), index
end

function F.getSyncRecordTraits(record, fallbackTraits)
local list = {}
local seen = {}
local traits = type(record) == "table" and record.Traits or nil
if type(traits) == "table" then
for key, value in pairs(traits) do
local name
if type(key) == "number" then
if type(value) == "string" or type(value) == "number" then name = value end
elseif value == true or value == 1 then
name = key
elseif type(value) == "string" then
name = value
end
if name ~= nil then
F.addTraitVisual(list, seen, tostring(name))
end
end
end
if #list == 0 then
for _, trait in ipairs(fallbackTraits or {}) do
F.addTraitVisual(list, seen, trait.Name or trait.Key, trait.Icon)
end
end
return list
end

function F.getSyncRecordGeneration(record, index)
F.initSafeBrainrotData()
if type(record) ~= "table" then return 0 end
local amount = 0
if safeSharedAnimals and type(safeSharedAnimals.GetGeneration) == "function" and index ~= nil then
pcall(function()
amount = safeSharedAnimals:GetGeneration(index, record.Mutation, record.Traits, nil) or 0
end)
end
if type(amount) ~= "number" or amount < 0 then amount = 0 end
return amount
end

function F.buildBrainrotRecord(plot, slot, syncRecord)
local prompt, spawnPart = F.chooseBrainrotPrompt(slot)
local syncName, index = F.getSyncRecordName(syncRecord)
local adornee = spawnPart and F.findBrainrotAdornee(slot, syncName or (prompt and prompt.ObjectText), plot) or nil
local overhead = spawnPart and F.readSafeOverhead(slot, adornee) or nil
local fallbackName = (prompt and tostring(prompt.ObjectText or "") ~= "" and prompt.ObjectText)
or F.readBrainrotNameFromOverhead(overhead)
or (adornee and adornee.Name)
local name = syncName or fallbackName
if not spawnPart or not name or name == "" then return nil end
local fallbackTraits, fallbackMutation = F.getBrainrotMetadata(slot, name, adornee, prompt, plot)
local traits = syncRecord and F.getSyncRecordTraits(syncRecord, fallbackTraits) or fallbackTraits
local mutation = syncRecord and syncRecord.Mutation or fallbackMutation
if mutation == "None" then mutation = nil end
local generation = syncRecord and F.getSyncRecordGeneration(syncRecord, index) or 0
local mps
if generation and generation > 0 then
mps = "$" .. F.compactNumber(generation) .. "/s"
else
mps, generation = F.getBrainrotMPS(slot, prompt, adornee, plot)
end
return {
Name = name,
Index = index,
Price = F.getBrainrotPriceSafe(slot, adornee),
MPS = mps or "MPS N/A",
MPSValue = tonumber(generation) or 0,
Traits = traits or {},
Mutation = mutation,
Action = prompt and prompt.ActionText or "",
Prompt = prompt,
Spawn = spawnPart,
Adornee = adornee or spawnPart,
FakeRootPart = F.getFakeRootPart(adornee),
Slot = slot,
SlotNumber = tonumber(slot.Name) or math.huge,
Plot = plot,
SyncRecord = syncRecord,
}
end

function F.collectPlotBrainrots(includeLocal)
local results = {}
local plots = workspace:FindFirstChild("Plots")
if not plots then return results end
F.refreshOverheadCache(false)

for _, plot in ipairs(plots:GetChildren()) do
local ownPlot = F.plotBelongsToLocalPlayer(plot)
if includeLocal or not ownPlot then
local podiums = plot:FindFirstChild("AnimalPodiums")
if podiums then
local usedSlots = {}
for _, model in ipairs(plot:GetChildren()) do
if model:IsA("Model") then
local fakeRoot = model:FindFirstChild("FakeRootPart", true)
if fakeRoot and fakeRoot:IsA("BasePart") then
local slot, spawnPart = F.findNearestPodiumSlot(podiums, fakeRoot)
if slot and spawnPart then
usedSlots[slot] = true
local prompt = F.chooseBrainrotPrompt(slot)
local overhead = F.readSafeOverhead(slot, model)
local name = tostring(model.Name or "")
if name == "" or name == "Model" then name = F.readBrainrotNameFromOverhead(overhead) or (prompt and prompt.ObjectText) or "BRAINROT" end
local traits, mutation = F.getBrainrotMetadata(slot, name, model, prompt, plot)
local mps, mpsValue = F.getBrainrotMPS(slot, prompt, model, plot)
table.insert(results, {
Name = name,
Price = F.getBrainrotPriceSafe(slot, model),
MPS = mps,
MPSValue = mpsValue,
Traits = traits,
Mutation = mutation,
Action = prompt and prompt.ActionText or "",
Prompt = prompt,
Spawn = spawnPart,
Adornee = model,
FakeRootPart = fakeRoot,
Slot = slot,
SlotNumber = tonumber(slot.Name) or math.huge,
Plot = plot,
})
end
end
end
end

for _, slot in ipairs(podiums:GetChildren()) do
if not usedSlots[slot] then
local prompt, spawnPart = F.chooseBrainrotPrompt(slot)
local adornee = spawnPart and F.findBrainrotAdornee(slot, prompt and prompt.ObjectText or nil, plot) or nil
local fakeRoot = adornee and F.getFakeRootPart(adornee) or nil
local overhead = spawnPart and F.readSafeOverhead(slot, adornee) or nil
local name = (prompt and tostring(prompt.ObjectText or "") ~= "" and prompt.ObjectText) or F.readBrainrotNameFromOverhead(overhead)
if spawnPart and name and name ~= "" and (prompt or fakeRoot or overhead) then
local traits, mutation = F.getBrainrotMetadata(slot, name, adornee, prompt, plot)
local mps, mpsValue = F.getBrainrotMPS(slot, prompt, adornee, plot)
table.insert(results, {
Name = name,
Price = F.getBrainrotPriceSafe(slot, adornee),
MPS = mps,
MPSValue = mpsValue,
Traits = traits,
Mutation = mutation,
Action = prompt and prompt.ActionText or "",
Prompt = prompt,
Spawn = spawnPart,
Adornee = adornee or spawnPart,
FakeRootPart = fakeRoot or F.getFakeRootPart(adornee),
Slot = slot,
SlotNumber = tonumber(slot.Name) or math.huge,
Plot = plot,
})
end
end
end
end
end
end

table.sort(results, function(a, b)
if a.Name ~= b.Name then return string.lower(a.Name) < string.lower(b.Name) end
return a.SlotNumber < b.SlotNumber
end)
return results
end


-- Lightweight, read-only brainrot collector used by ESP/target list.
-- It only inspects already-replicated Workspace objects and local GUI text.
local liteBrainrotCacheAll = {}
local liteBrainrotCacheForeign = {}
local liteBrainrotCacheAllAt = 0
local liteBrainrotCacheForeignAt = 0
local LITE_BRAINROT_CACHE_TIME = 2.5

function F.getLiteBrainrotPrompt(slot)
local attachment, spawnPart = F.getPromptAttachment(slot)
if not attachment then return nil, spawnPart end
local best, bestPriority = nil, -1
for _, prompt in ipairs(attachment:GetChildren()) do
if prompt:IsA("ProximityPrompt") then
local objectText = tostring(prompt.ObjectText or "")
if objectText ~= "" then
local state = string.lower(tostring(prompt:GetAttribute("State") or ""))
local action = string.lower(tostring(prompt.ActionText or ""))
local priority = 1
if state == "steal" or action == "steal" then priority = 5
elseif state == "grab" or action == "grab" then priority = 4
elseif state == "collect" or action == "collect" then priority = 3
end
if priority > bestPriority then
best, bestPriority = prompt, priority
end
end
end
end
return best, spawnPart
end

function F.getLiteExactOverhead(slot, adornee)
local overhead
if adornee and adornee:IsA("Model") then
overhead = adornee:FindFirstChild("AnimalOverhead", true)
if overhead then return overhead end
end
if slot then
overhead = slot:FindFirstChild("AnimalOverhead", true)
if overhead then return overhead end
end
return nil
end

local function liteText(overhead, names)
if not overhead then return nil end
for _, childName in ipairs(names) do
local object = overhead:FindFirstChild(childName, true)
if object and (object:IsA("TextLabel") or object:IsA("TextButton") or object:IsA("TextBox")) then
local value = tostring(object.Text or ""):gsub("^%s+", ""):gsub("%s+$", "")
if value ~= "" then return value end
end
end
return nil
end

local function liteReadMutationFromObject(root)
if not root then return nil end
for attributeName, attributeValue in pairs(root:GetAttributes()) do
if string.find(string.lower(tostring(attributeName)), "mutation", 1, true)
and attributeValue ~= nil and tostring(attributeValue) ~= "" then
return tostring(attributeValue)
end
end
for _, name in ipairs({"Mutation", "_Mutation"}) do
local object = root:FindFirstChild(name, true)
if object then
if object:IsA("StringValue") and tostring(object.Value or "") ~= "" then
return tostring(object.Value)
elseif object:IsA("TextLabel") or object:IsA("TextButton") or object:IsA("TextBox") then
local value = tostring(object.Text or ""):gsub("^%s+", ""):gsub("%s+$", "")
if value ~= "" then return value end
end
local value = object:GetAttribute("Mutation")
if value ~= nil and tostring(value) ~= "" then return tostring(value) end
end
end
return nil
end

local function liteAddTrait(list, seen, value, icon)
if value == nil then return end
local name = tostring(value):gsub("^%s+", ""):gsub("%s+$", "")
if name == "" then return end
local normalized = F.normalizeDataName(name)
local info = safeTraitByName and safeTraitByName[normalized] or nil
if info then
name = info.Name or name
icon = info.Icon or icon
normalized = F.normalizeDataName(name)
end
if normalized == "" or seen[normalized] then return end
seen[normalized] = true
table.insert(list, {
Key = info and info.Key or name,
Name = name,
Icon = F.normalizeIcon(icon or (info and info.Icon) or ""),
})
end

local function liteCollectTraitsFromObject(root, list, seen)
if not root then return end

for attributeName, attributeValue in pairs(root:GetAttributes()) do
local lower = string.lower(tostring(attributeName))
if string.find(lower, "trait", 1, true) then
if type(attributeValue) == "string" then
for token in string.gmatch(attributeValue, "[^,|;/]+") do
liteAddTrait(list, seen, token)
end
elseif attributeValue == true then
local stripped = tostring(attributeName):gsub("^[Tt]raits?[_.%-]*", "")
if stripped ~= "" then liteAddTrait(list, seen, stripped) end
end
end
end

local okTags, tags = pcall(CollectionService.GetTags, CollectionService, root)
if okTags and type(tags) == "table" then
for _, tag in ipairs(tags) do
local info = safeTraitByName and safeTraitByName[F.normalizeDataName(tag)] or nil
if info then liteAddTrait(list, seen, info.Name, info.Icon) end
end
end

for _, object in ipairs(root:GetDescendants()) do
local rawName = tostring(object.Name or "")
local direct = rawName:match("^_Trait[%.%_%-](.+)$") or rawName:match("^_Trait(.+)$")
if direct and direct ~= "" then
local image = (object:IsA("ImageLabel") or object:IsA("ImageButton")) and object.Image or nil
liteAddTrait(list, seen, direct:gsub("^[%._%-]+", ""), image)
elseif rawName == "_Trait" or rawName == "Traits" then
for _, child in ipairs(object:GetChildren()) do
local value
if child:IsA("StringValue") then value = child.Value
elseif child:IsA("BoolValue") and child.Value then value = child.Name
elseif child:IsA("IntValue") or child:IsA("NumberValue") then
if child.Value ~= 0 then value = child.Name end
end
value = child:GetAttribute("Trait") or child:GetAttribute("DisplayName") or child:GetAttribute("Name") or value
local image = (child:IsA("ImageLabel") or child:IsA("ImageButton")) and child.Image or nil
if value then
liteAddTrait(list, seen, value, image)
elseif image and safeTraitByIcon then
local info = safeTraitByIcon[normalizeAsset(image)]
if info then liteAddTrait(list, seen, info.Name, info.Icon) end
end
end
elseif object:IsA("ImageLabel") or object:IsA("ImageButton") then
local parentName = object.Parent and tostring(object.Parent.Name or "") or ""
if parentName == "_Trait" or parentName == "Traits" then
local info = safeTraitByIcon and safeTraitByIcon[normalizeAsset(object.Image)] or nil
if info then liteAddTrait(list, seen, info.Name, info.Icon) end
end
end
end
end

local function liteCollectTraits(slot, adornee, prompt)
F.initSafeBrainrotData()
local list, seen = {}, {}
-- Only scan objects that belong to this exact slot/model. Never borrow a nearby overhead's traits.
if adornee then liteCollectTraitsFromObject(adornee, list, seen) end
if slot then liteCollectTraitsFromObject(slot, list, seen) end
if prompt then liteCollectTraitsFromObject(prompt, list, seen) end
return list
end

local function liteExactMutation(slot, adornee, prompt)
-- Exact ownership priority: brainrot model -> prompt -> slot.
-- Nearby Debris overheads are deliberately excluded so mutations cannot bleed between slots.
return liteReadMutationFromObject(adornee)
or liteReadMutationFromObject(prompt)
or liteReadMutationFromObject(slot)
end

local function buildUniqueOverheadAssignments(slotInfo)
F.refreshOverheadCache(false)
local pairsList = {}
for _, info in ipairs(slotInfo) do
if info.Spawn and not info.ExactOverhead then
for _, entry in ipairs(overheadCache) do
if entry.Part and entry.Part.Parent and entry.Gui and entry.Gui.Parent then
local distance = (entry.Part.Position - info.Spawn.Position).Magnitude
if distance <= 10 then
local promptName = info.Prompt and F.normalizeDataName(info.Prompt.ObjectText) or ""
local overheadName = F.normalizeDataName(liteText(entry.Gui, {"DisplayName", "AnimalName", "BrainrotName", "Name"}) or "")
local nameBonus = (promptName ~= "" and overheadName ~= "" and
(promptName == overheadName or string.find(promptName, overheadName, 1, true) or string.find(overheadName, promptName, 1, true))) and -20 or 0
table.insert(pairsList, {Info = info, Entry = entry, Score = distance + nameBonus})
end
end
end
end
end
table.sort(pairsList, function(a, b) return a.Score < b.Score end)
local usedInfo, usedEntry = {}, {}
for _, pair in ipairs(pairsList) do
if not usedInfo[pair.Info] and not usedEntry[pair.Entry] then
pair.Info.FallbackOverhead = pair.Entry.Gui
usedInfo[pair.Info] = true
usedEntry[pair.Entry] = true
end
end
end

function F.collectBrainrotsLite(includeLocal)
local results = {}
local plots = workspace:FindFirstChild("Plots")
if not plots then return results end

F.initSafeBrainrotData()

for _, plot in ipairs(plots:GetChildren()) do
if includeLocal or not F.plotBelongsToLocalPlayer(plot) then
local podiums = plot:FindFirstChild("AnimalPodiums")
if podiums then
local slots = {}
for _, slot in ipairs(podiums:GetChildren()) do
local prompt, spawnPart = F.getLiteBrainrotPrompt(slot)
if spawnPart then
table.insert(slots, {Slot = slot, Prompt = prompt, Spawn = spawnPart})
end
end

local candidates = {}
for _, object in ipairs(plot:GetChildren()) do
if object:IsA("Model") then
local fakeRoot = object:FindFirstChild("FakeRootPart", true)
if fakeRoot and fakeRoot:IsA("BasePart") then
table.insert(candidates, {Model = object, Root = fakeRoot})
end
end
end

-- Build a global nearest-pair assignment so a model can never be used by two podium slots.
local modelPairs = {}
for _, info in ipairs(slots) do
for _, candidate in ipairs(candidates) do
local distance = (candidate.Root.Position - info.Spawn.Position).Magnitude
if distance <= 18 then
local promptName = info.Prompt and F.normalizeDataName(info.Prompt.ObjectText) or ""
local modelName = F.normalizeDataName(candidate.Model.Name)
local nameBonus = (promptName ~= "" and modelName ~= "" and
(promptName == modelName or string.find(promptName, modelName, 1, true) or string.find(modelName, promptName, 1, true))) and -25 or 0
table.insert(modelPairs, {Info = info, Candidate = candidate, Score = distance + nameBonus})
end
end
end
table.sort(modelPairs, function(a, b) return a.Score < b.Score end)
local usedSlots, usedModels = {}, {}
for _, pair in ipairs(modelPairs) do
if not usedSlots[pair.Info] and not usedModels[pair.Candidate.Model] then
pair.Info.Adornee = pair.Candidate.Model
pair.Info.FakeRoot = pair.Candidate.Root
usedSlots[pair.Info] = true
usedModels[pair.Candidate.Model] = true
end
end

for _, info in ipairs(slots) do
info.ExactOverhead = F.getLiteExactOverhead(info.Slot, info.Adornee)
end
buildUniqueOverheadAssignments(slots)

local emitted = {}
for _, info in ipairs(slots) do
local slot = info.Slot
local prompt = info.Prompt
local spawnPart = info.Spawn
local adornee = info.Adornee
local fakeRoot = info.FakeRoot
local overhead = info.ExactOverhead or info.FallbackOverhead

local promptName = prompt and tostring(prompt.ObjectText or "") or ""
local overheadName = liteText(overhead, {"DisplayName", "AnimalName", "BrainrotName", "Name"})
local modelName = adornee and tostring(adornee.Name or "") or ""
if modelName == "Model" then modelName = "" end
local name = promptName ~= "" and promptName or overheadName or (modelName ~= "" and modelName or nil)

if name then
local uniqueKey = adornee and ("M:" .. tostring(adornee)) or ("S:" .. tostring(plot) .. ":" .. tostring(slot))
if not emitted[uniqueKey] then
emitted[uniqueKey] = true

local mps = liteText(overhead, {"Generation", "MPS", "Income", "MoneyPerSecond"}) or "MPS N/A"
local mutation = liteExactMutation(slot, adornee, prompt)
local traits = liteCollectTraits(slot, adornee, prompt)
local price = liteText(overhead, {"Price", "Cost"}) or "PRICE N/A"

table.insert(results, {
Name = name,
Price = price,
MPS = mps,
MPSValue = F.parseCompactNumber(mps) or 0,
Traits = traits,
Mutation = mutation,
Action = prompt and tostring(prompt.ActionText or "") or "",
Prompt = prompt,
Spawn = spawnPart,
Adornee = adornee or spawnPart,
FakeRootPart = fakeRoot or spawnPart,
Slot = slot,
SlotNumber = tonumber(slot.Name) or math.huge,
Plot = plot,
})
end
end
end
end
end
end

table.sort(results, function(a, b)
if (a.MPSValue or 0) ~= (b.MPSValue or 0) then
return (a.MPSValue or 0) > (b.MPSValue or 0)
end
if tostring(a.Name) ~= tostring(b.Name) then
return string.lower(tostring(a.Name)) < string.lower(tostring(b.Name))
end
return (a.SlotNumber or math.huge) < (b.SlotNumber or math.huge)
end)
return results
end

function F.getLiteBrainrotCache(includeLocal, force)
local now = os.clock()
if includeLocal then
if force or now - liteBrainrotCacheAllAt >= LITE_BRAINROT_CACHE_TIME then
liteBrainrotCacheAll = F.collectBrainrotsLite(true)
liteBrainrotCacheAllAt = now
end
return liteBrainrotCacheAll
end
if force or now - liteBrainrotCacheForeignAt >= LITE_BRAINROT_CACHE_TIME then
liteBrainrotCacheForeign = F.collectBrainrotsLite(false)
liteBrainrotCacheForeignAt = now
end
return liteBrainrotCacheForeign
end

_G.ScanAllPets = function()
local out = {}
for _, record in ipairs(F.getLiteBrainrotCache(false, true)) do
table.insert(out, {
name = record.Name,
mps = record.MPSValue,
mutation = record.Mutation or "None",
position = record.Spawn and record.Spawn.Position or F.getWorldPosition(record.Adornee),
plot = record.Plot and record.Plot.Name or nil,
slot = record.Slot and tostring(record.Slot.Name) or nil,
record = record,
})
end
return out
end

local visualState = {
XrayBases = false,
BrainrotESP = false,
SlotESP = false,
SlotNumbers = false,
PubMethod = false,
NextEmptyBase = false,
LineToBase = false,
}
local previousVisualRoot = workspace:FindFirstChild("_WuzzWorldVisuals")
if previousVisualRoot then previousVisualRoot:Destroy() end
local visualWorldRoot = nil
function F.getVisualWorldRoot()
if visualWorldRoot and visualWorldRoot.Parent then return visualWorldRoot end
visualWorldRoot = Instance.new("Folder")
visualWorldRoot.Name = "_WuzzWorldVisuals"
visualWorldRoot.Parent = workspace
return visualWorldRoot
end

local visualEntries = {}
local visualCache = {}
local visualLastScan = 0
local xrayScreenEntries = {}
local xrayLastScreenUpdate = 0
local xrayPartCache = {}
local xrayPartCacheAt = 0

function F.getPlotAnchor(plot)
return F.findPlotSign(plot)
or F.findDeliveryHitbox(plot)
or (plot and plot:FindFirstChild("MainRoot", true))
or (plot and plot:FindFirstChild("Spawn", true))
end

function F.getInstancePart(object)
if not object then return nil end
if object:IsA("BasePart") then return object end
if object:IsA("Attachment") then return object.Parent end
if object:IsA("Model") then return object.PrimaryPart or object:FindFirstChildWhichIsA("BasePart", true) end
return object:FindFirstChildWhichIsA("BasePart", true)
end

function F.getWorldPosition(object)
if not object then return nil end
if object:IsA("Attachment") then return object.WorldPosition end
local part = F.getInstancePart(object)
return part and part.Position or nil
end

function F.getFakeRootPart(object)
if not object then return nil end
if object:IsA("BasePart") and string.lower(object.Name) == "fakerootpart" then return object end
local exact = object:FindFirstChild("FakeRootPart", true)
if exact and exact:IsA("BasePart") then return exact end
for _, child in ipairs(object:GetDescendants()) do
if child:IsA("BasePart") then
local name = string.lower(child.Name):gsub("[^%w]", "")
if name == "fakerootpart" or name == "fakeroot" then return child end
end
end
return F.getInstancePart(object)
end

local function destroyDeep(value)
if typeof(value) == "Instance" then
if value.Parent then pcall(function() value:Destroy() end) end
elseif type(value) == "table" then
for _, child in pairs(value) do destroyDeep(child) end
end
end

function F.destroyVisualEntry(key)
local entry = visualEntries[key]
if not entry then return end
for field, value in pairs(entry) do
if field ~= "Adornee" and field ~= "TargetPart" and field ~= "Plot" and field ~= "Record" then
destroyDeep(value)
end
end
visualEntries[key] = nil
end

function F.clearVisualPrefix(prefix)
local keys = {}
for key in pairs(visualEntries) do
if string.sub(key, 1, #prefix) == prefix then table.insert(keys, key) end
end
for _, key in ipairs(keys) do F.destroyVisualEntry(key) end
end

function F.setScreenLine(frame, a, b, color, thickness, transparency)
if not frame or not a or not b then
if frame then frame.Visible = false end
return
end
local dx, dy = b.X - a.X, b.Y - a.Y
local length = math.sqrt(dx * dx + dy * dy)
if length < 1 then frame.Visible = false return end
frame.AnchorPoint = Vector2.new(0, .5)
frame.Position = UDim2.fromOffset(a.X, a.Y)
frame.Size = UDim2.fromOffset(length, thickness or 2)
frame.Rotation = math.deg(math.atan2(dy, dx))
frame.BackgroundColor3 = color or C.Purple
frame.BackgroundTransparency = transparency == nil and .15 or transparency
frame.Visible = true
end

function F.makeScreenLine(key, color, thickness, z)
local entry = visualEntries[key]
if entry and entry.Line and entry.Line.Parent then
entry.Color = color or entry.Color
entry.Thickness = thickness or entry.Thickness
return entry
end
if entry then F.destroyVisualEntry(key) end
local line = Instance.new("Frame")
line.Name = "_WuzzLine_" .. key
line.BorderSizePixel = 0
line.BackgroundColor3 = color or C.Purple
line.BackgroundTransparency = .08
line.Visible = false
line.ZIndex = z or 80
line.Parent = Gui
F.corner(line, 999)
entry = {Line = line, Color = color or C.Purple, Thickness = thickness or 2, SmoothA = nil, SmoothB = nil}
visualEntries[key] = entry
return entry
end

function F.updateTracerEntry(entry, targetPart, offset, dt)
local camera = workspace.CurrentCamera
local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
if not camera or not root or not targetPart or not targetPart.Parent then
if entry and entry.Line then entry.Line.Visible = false end
return
end
local a3 = camera:WorldToViewportPoint(root.Position)
local targetWorld = targetPart.Position + (offset or Vector3.zero)
local b3 = camera:WorldToViewportPoint(targetWorld)
if a3.Z <= 0 or b3.Z <= 0 then entry.Line.Visible = false return end
local a = Vector2.new(a3.X, a3.Y)
local b = Vector2.new(b3.X, b3.Y)
local alpha = 1 - math.exp(-math.max(dt or 1/60, 1/240) * 18)
entry.SmoothA = entry.SmoothA and entry.SmoothA:Lerp(a, alpha) or a
entry.SmoothB = entry.SmoothB and entry.SmoothB:Lerp(b, alpha) or b
F.setScreenLine(entry.Line, entry.SmoothA, entry.SmoothB, entry.Color, entry.Thickness, .05)
end

function F.projectObjectBounds(object)
local camera = workspace.CurrentCamera
if not camera or not object then return nil end
local cf, size
if object:IsA("BasePart") then
cf, size = object.CFrame, object.Size
elseif object:IsA("Model") then
local ok
ok, cf, size = pcall(function() return object:GetBoundingBox() end)
if not ok then return nil end
else
local part = F.getInstancePart(object)
if not part then return nil end
cf, size = part.CFrame, part.Size
end
local half = size * .5
local minX, minY, maxX, maxY = math.huge, math.huge, -math.huge, -math.huge
local visible = false
for _, v in ipairs({
Vector3.new(-half.X,-half.Y,-half.Z), Vector3.new(half.X,-half.Y,-half.Z),
Vector3.new(-half.X, half.Y,-half.Z), Vector3.new(half.X, half.Y,-half.Z),
Vector3.new(-half.X,-half.Y, half.Z), Vector3.new(half.X,-half.Y, half.Z),
Vector3.new(-half.X, half.Y, half.Z), Vector3.new(half.X, half.Y, half.Z),
}) do
local screen = camera:WorldToViewportPoint(cf:PointToWorldSpace(v))
if screen.Z > 0 then
visible = true
minX, minY = math.min(minX, screen.X), math.min(minY, screen.Y)
maxX, maxY = math.max(maxX, screen.X), math.max(maxY, screen.Y)
end
end
if not visible then return nil end
if maxX - minX > camera.ViewportSize.X * 1.8 or maxY - minY > camera.ViewportSize.Y * 1.8 then return nil end
return minX, minY, maxX, maxY
end

local function makeRect(key, color, fillTransparency, z)
local entry = visualEntries[key]
if entry and entry.Frame and entry.Frame.Parent then return entry end
if entry then F.destroyVisualEntry(key) end
local frame = Instance.new("Frame")
frame.Name = "_WuzzRect_" .. key
frame.BorderSizePixel = 0
frame.BackgroundColor3 = color or C.Purple
frame.BackgroundTransparency = fillTransparency or .88
frame.Visible = false
frame.ZIndex = z or 45
frame.Parent = Gui
F.corner(frame, 5)
local stroke = F.stroke(frame, 1.3, color or C.Purple2, .08)
entry = {Frame = frame, Stroke = stroke, Color = color or C.Purple}
visualEntries[key] = entry
return entry
end

local function updateRect(entry, object)
local minX,minY,maxX,maxY = F.projectObjectBounds(object)
if not minX then entry.Frame.Visible = false return nil end
local w, h = maxX - minX, maxY - minY
if w < 2 or h < 2 then entry.Frame.Visible = false return nil end
entry.Frame.Position = UDim2.fromOffset(minX, minY)
entry.Frame.Size = UDim2.fromOffset(w, h)
entry.Frame.Visible = true
return minX,minY,maxX,maxY
end

function F.buildTraitRow(parent, traits)
for _, child in ipairs(parent:GetChildren()) do
if not child:IsA("UIListLayout") then child:Destroy() end
end
for index, trait in ipairs(traits or {}) do
if index > 7 then break end
local icon = Instance.new("ImageLabel")
icon.BackgroundColor3 = C.DarkPurple
icon.BackgroundTransparency = .12
icon.BorderSizePixel = 0
icon.Size = UDim2.fromOffset(14, 14)
icon.Image = trait.Icon or ""
icon.ScaleType = Enum.ScaleType.Fit
icon.ZIndex = 56
icon.Parent = parent
F.corner(icon, 4)
if not trait.Icon or trait.Icon == "" then
icon.ImageTransparency = 1
local text = Instance.new("TextLabel")
text.BackgroundTransparency = 1
text.Size = UDim2.fromScale(1,1)
text.Text = string.upper(string.sub(trait.Name or "?",1,2))
text.TextColor3 = C.Text
text.TextSize = 6
text.Font = Enum.Font.GothamBold
text.ZIndex = 57
text.Parent = icon
end
end
end

function F.getMutationColor(name)
local key = string.lower(tostring(name or ""))
local colors = {
gold = Color3.fromRGB(255, 206, 70),
diamond = Color3.fromRGB(92, 226, 255),
bloodrot = Color3.fromRGB(220, 35, 55),
candy = Color3.fromRGB(255, 105, 205),
lava = Color3.fromRGB(255, 95, 25),
galaxy = Color3.fromRGB(142, 96, 255),
yinyang = Color3.fromRGB(235, 235, 235),
radioactive = Color3.fromRGB(112, 255, 70),
cursed = Color3.fromRGB(128, 38, 170),
divine = Color3.fromRGB(255, 238, 155),
cyber = Color3.fromRGB(55, 235, 255),
phantom = Color3.fromRGB(178, 142, 255),
crystal = Color3.fromRGB(135, 235, 255),
}
return colors[key] or C.Purple2
end

function F.styleMutationLabel(label, mutation)
if not label then return end
local name = tostring(mutation or "")
label.Text = name ~= "" and name or "NONE"
if string.lower(name) == "rainbow" then
task.spawn(function()
while label.Parent and label.Text == name do
label.TextColor3 = Color3.fromHSV((os.clock() * .18) % 1, .82, 1)
task.wait(.04)
end
end)
else
label.TextColor3 = name ~= "" and F.getMutationColor(name) or C.Muted
end
end

function F.ensureBrainrotESP(key, record)
local target = record.FakeRootPart or F.getFakeRootPart(record.Adornee) or record.Spawn
local chamTarget = record.Adornee or target
if not target then return end
local traitNames = {}
for _, trait in ipairs(record.Traits or {}) do table.insert(traitNames, trait.Name or "") end
local signature = table.concat({tostring(record.Name), tostring(record.MPS), tostring(record.Mutation), table.concat(traitNames, ",")}, "|")
local entry = visualEntries[key]
if entry and entry.TargetPart == target and entry.Signature == signature then
entry.Record = record
return
end
if entry then F.destroyVisualEntry(key) end

entry = {TargetPart = target, Signature = signature, Record = record}
visualEntries[key] = entry
local cham = Instance.new("Highlight")
cham.Name = "_WuzzBrainrotCham"
cham.Adornee = chamTarget
cham.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
cham.FillColor = C.Purple
cham.FillTransparency = .55
cham.OutlineColor = C.Purple2
cham.OutlineTransparency = .02
cham.Enabled = true
cham.Parent = F.getVisualWorldRoot()
entry.Cham = cham

local tag = Instance.new("Frame")
tag.Name = "Tag"
tag.BackgroundColor3 = C.Background
tag.BackgroundTransparency = .08
tag.BorderSizePixel = 0
tag.Size = UDim2.fromOffset(194, 57)
tag.Visible = false
tag.ZIndex = 52
tag.Parent = Gui
F.corner(tag, 8)
F.stroke(tag, 1.2, C.Purple2, .05)
local nameLabel = F.label(tag, record.Name or "?", UDim2.new(1,-10,0,17), UDim2.fromOffset(6,2), 10, true)
nameLabel.ZIndex = 55
nameLabel.TextTruncate = Enum.TextTruncate.AtEnd
local mpsLabel = F.label(tag, record.MPS or "MPS N/A", UDim2.new(.57,-8,0,14), UDim2.fromOffset(6,18), 8, true)
mpsLabel.TextColor3 = C.Purple2
mpsLabel.ZIndex = 55
local mutationLabel = F.label(tag, "", UDim2.new(.43,-8,0,14), UDim2.new(.57,0,0,18), 7, true)
mutationLabel.TextXAlignment = Enum.TextXAlignment.Right
mutationLabel.ZIndex = 55
F.styleMutationLabel(mutationLabel, record.Mutation)
local traitRow = Instance.new("Frame")
traitRow.BackgroundTransparency = 1
traitRow.Position = UDim2.fromOffset(6,36)
traitRow.Size = UDim2.new(1,-12,0,15)
traitRow.ZIndex = 55
traitRow.Parent = tag
local layout = Instance.new("UIListLayout")
layout.FillDirection = Enum.FillDirection.Horizontal
layout.Padding = UDim.new(0,3)
layout.Parent = traitRow
F.buildTraitRow(traitRow, record.Traits)
entry.Tag = tag
entry.TraitRow = traitRow
end

function F.ensureSlotCham(key, slot)
if not slot or not slot.Parent then return end
local base = slot:FindFirstChild("Base") or slot
local entry = visualEntries[key]
if entry and entry.Highlight and entry.Highlight.Parent and entry.Adornee == base then return end
if entry then F.destroyVisualEntry(key) end
local highlight = Instance.new("Highlight")
highlight.Name = "_WuzzSlotCham"
highlight.Adornee = base
highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
highlight.FillColor = C.Purple
highlight.FillTransparency = .58
highlight.OutlineColor = C.Purple2
highlight.OutlineTransparency = .02
highlight.Enabled = true
highlight.Parent = Gui
visualEntries[key] = {Highlight = highlight, Adornee = base}
end

function F.makeSlotNumber(key, slot, part)
local entry = visualEntries[key]
if entry and entry.TargetPart == part and entry.Circle and entry.Circle.Parent then return end
if entry then F.destroyVisualEntry(key) end
local circle = Instance.new("TextLabel")
circle.Name = "_WuzzSlotNumber"
circle.AnchorPoint = Vector2.new(.5,.5)
circle.Size = UDim2.fromOffset(32,32)
circle.BackgroundColor3 = C.DarkPurple
circle.BackgroundTransparency = .08
circle.BorderSizePixel = 0
circle.Font = Enum.Font.GothamBold
circle.Text = tostring(slot.Name)
circle.TextColor3 = C.Text
circle.TextSize = 11
circle.Visible = false
circle.ZIndex = 62
circle.Parent = Gui
F.corner(circle, 100)
F.stroke(circle, 1.4, C.Purple2, .05)
visualEntries[key] = {Circle=circle, TargetPart=part, Adornee=slot}
end

function F.getSortedPlots()
local plotsFolder = workspace:FindFirstChild("Plots")
local plots = plotsFolder and plotsFolder:GetChildren() or {}
local orderKeys = {}
local hasExplicit = false
for index, plot in ipairs(plots) do
local explicit = plot:GetAttribute("PlotOrder") or plot:GetAttribute("Order") or plot:GetAttribute("Index")
if type(explicit) == "number" then hasExplicit = true; orderKeys[plot] = explicit else orderKeys[plot] = index end
end
if hasExplicit then table.sort(plots, function(a,b) return orderKeys[a] == orderKeys[b] and a.Name < b.Name or orderKeys[a] < orderKeys[b] end) end
return plots
end

function F.plotHasOwner(plot)
if F.plotBelongsToLocalPlayer(plot) then return true end
for attributeName, value in pairs(plot:GetAttributes()) do
local lower = string.lower(attributeName)
if string.find(lower,"owner",1,true) or string.find(lower,"player",1,true) then
if (type(value)=="string" and value~="" and value~="0") or (type(value)=="number" and value~=0) or value==true then return true end
end
end
local sign = F.findPlotSign(plot)
if sign then
for _, player in ipairs(Players:GetPlayers()) do
local playerName = string.lower(tostring(player.Name or ""))
local displayName = string.lower(tostring(player.DisplayName or ""))
for _, object in ipairs(sign:GetDescendants()) do
if object:IsA("TextLabel") or object:IsA("TextButton") or object:IsA("TextBox") then
local value = string.lower(tostring(object.Text or ""))
if (playerName ~= "" and string.find(value, playerName, 1, true))
or (displayName ~= "" and string.find(value, displayName, 1, true)) then
return true
end
end
end
end
end
return false
end
function F.findNextJoinPlot()
for _, plot in ipairs(F.getSortedPlots()) do if not F.plotHasOwner(plot) then return plot end end
return nil
end
function F.findClosestPlot()
local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
if not root then return nil end
local best,bestDistance
for _, plot in ipairs(F.getSortedPlots()) do
local pos = F.getWorldPosition(F.getPlotAnchor(plot))
if pos then
local d = (root.Position-pos).Magnitude
if not bestDistance or d<bestDistance then best,bestDistance=plot,d end
end
end
return best
end
function F.slotIsAvailable(slot) return F.chooseBrainrotPrompt(slot) == nil end

local xrayConnections = {}
local xrayOriginalTransparency = setmetatable({}, {__mode = "k"})
local xrayWatched = setmetatable({}, {__mode = "k"})
local xrayGeneration = 0
local xrayFolders = {
Base = true,
PlotSign = true,
FriendPanel = true,
Cash = true,
Decorations = true,
Skin = true,
Unlock = true,
Purchases = true,
}

function F.restoreXrayBases()
for _, connection in ipairs(xrayConnections) do
pcall(function() connection:Disconnect() end)
end
table.clear(xrayConnections)
xrayGeneration += 1
local original = xrayOriginalTransparency
xrayOriginalTransparency = setmetatable({}, {__mode = "k"})
xrayWatched = setmetatable({}, {__mode = "k"})
for part, transparency in pairs(original) do
if part and part.Parent and part:IsA("BasePart") then
pcall(function() part.Transparency = transparency end)
end
end
end

function F.applyXrayPart(part, alpha, generation)
if generation ~= xrayGeneration or not visualState.XrayBases then return end
if not part:IsA("BasePart") then return end
if xrayOriginalTransparency[part] == nil then
xrayOriginalTransparency[part] = part.Transparency
end
local original = xrayOriginalTransparency[part]
if original < 1 then
local transparency = original + (1 - original) * alpha
if math.abs(part.Transparency - transparency) > 0.01 then
part.Transparency = transparency
end
end
end

function F.watchXrayContainer(container, alpha, generation)
if not container or generation ~= xrayGeneration or xrayWatched[container] == generation then return end
xrayWatched[container] = generation
table.insert(xrayConnections, container.DescendantAdded:Connect(function(object)
if generation == xrayGeneration and visualState.XrayBases then
F.applyXrayPart(object, alpha, generation)
end
end))
F.applyXrayPart(container, alpha, generation)
local count = 0
for _, object in ipairs(container:GetDescendants()) do
if generation ~= xrayGeneration or not visualState.XrayBases then return end
F.applyXrayPart(object, alpha, generation)
count += 1
if count % 1500 == 0 then task.wait() end
end
end

function F.watchXrayPlot(plot, alpha, generation)
if not plot or generation ~= xrayGeneration or xrayWatched[plot] == generation then return end
xrayWatched[plot] = generation
table.insert(xrayConnections, plot.ChildAdded:Connect(function(child)
if generation == xrayGeneration and visualState.XrayBases and xrayFolders[child.Name] then
task.spawn(F.watchXrayContainer, child, alpha, generation)
end
end))
for name in pairs(xrayFolders) do
if generation ~= xrayGeneration then return end
F.watchXrayContainer(plot:FindFirstChild(name), alpha, generation)
end
end

function F.applyXrayBases()
F.restoreXrayBases()
visualState.XrayBases = true
xrayGeneration += 1
local generation = xrayGeneration
local alpha = math.clamp(tonumber(_G.XRayAlpha) or 0.6, 0, 1)
local plots = workspace:FindFirstChild("Plots")
if plots then
for _, plot in ipairs(plots:GetChildren()) do
task.spawn(F.watchXrayPlot, plot, alpha, generation)
end
table.insert(xrayConnections, plots.ChildAdded:Connect(function(plot)
if generation == xrayGeneration and visualState.XrayBases then
task.spawn(F.watchXrayPlot, plot, alpha, generation)
end
end))
end
table.insert(xrayConnections, workspace.ChildAdded:Connect(function(child)
if child.Name ~= "Plots" or generation ~= xrayGeneration or not visualState.XrayBases then return end
for _, plot in ipairs(child:GetChildren()) do
task.spawn(F.watchXrayPlot, plot, alpha, generation)
end
table.insert(xrayConnections, child.ChildAdded:Connect(function(plot)
if generation == xrayGeneration and visualState.XrayBases then
task.spawn(F.watchXrayPlot, plot, alpha, generation)
end
end))
end))
end

function F.setXrayBases(state)
visualState.XrayBases = not not state
_G.XRayEnabled = visualState.XrayBases
if visualState.XrayBases then
F.applyXrayBases()
else
F.restoreXrayBases()
end
end

_G.XRayAlpha = tonumber(_G.XRayAlpha) or 0.6
_G.setXRay = F.setXrayBases
_G.toggleXRay = function()
F.setXrayBases(not visualState.XrayBases)
end

function F.setBrainrotESP(state)
visualState.BrainrotESP = not not state
if visualState.BrainrotESP then
visualLastScan = 0
liteBrainrotCacheAllAt = 0
liteBrainrotCacheForeignAt = 0
task.defer(function()
if visualState.BrainrotESP then F.updateVisuals() end
end)
else
F.clearVisualPrefix("Brainrot_")
end
end
function F.setSlotESP(state)
visualState.SlotESP = not not state
if not visualState.SlotESP then F.clearVisualPrefix("SlotCham_") end
end
function F.setSlotNumbers(state)
visualState.SlotNumbers = not not state
if not visualState.SlotNumbers or visualState.PubMethod then
F.clearVisualPrefix("SlotNumber_")
end
end

local PUB_MAX_SEARCH_HEIGHT = 500
local PUB_FIRST_MIRROR_Y_OFFSET = 2
local pubMethodRoot = nil
local pubMethodConnections = {}
local pubMethodNumberGuis = {}

local function pubDisconnectConnections()
for _, connection in ipairs(pubMethodConnections) do
pcall(function() connection:Disconnect() end)
end
table.clear(pubMethodConnections)
end

local function pubClearNumberGuis()
for _, gui in ipairs(pubMethodNumberGuis) do
if gui and gui.Parent then
pcall(function() gui:Destroy() end)
end
end
table.clear(pubMethodNumberGuis)
end

local function pubDestroyRoot()
if pubMethodRoot and pubMethodRoot.Parent then
pcall(function() pubMethodRoot:Destroy() end)
end
pubMethodRoot = nil
end

local function pubGetRoot()
if pubMethodRoot and pubMethodRoot.Parent then
return pubMethodRoot
end
pubMethodRoot = Instance.new("Folder")
pubMethodRoot.Name = "_WuzzPubMethod"
pubMethodRoot.Parent = workspace
return pubMethodRoot
end

local function pubGetBaseAndSpawn(podium)
if not podium then return nil, nil end
local base = podium:FindFirstChild("Base")
if not base then return nil, nil end
local spawn = base:FindFirstChild("Spawn")
if not spawn or not spawn:IsA("BasePart") then
return base, nil
end
return base, spawn
end

local function pubMakeNumber(adornee, number)
if not adornee or not adornee:IsA("BasePart") then return nil end
local gui = Instance.new("BillboardGui")
gui.Name = "_WuzzPubSlotNumber"
gui.Adornee = adornee
gui.Size = UDim2.fromOffset(76, 76)
gui.StudsOffsetWorldSpace = Vector3.new(0, 3, 0)
gui.AlwaysOnTop = true
gui.LightInfluence = 0
gui.MaxDistance = 1000
gui.Parent = adornee

local background = Instance.new("Frame")
background.Name = "Background"
background.AnchorPoint = Vector2.new(.5, .5)
background.Position = UDim2.fromScale(.5, .5)
background.Size = UDim2.fromOffset(64, 64)
background.BackgroundColor3 = Color3.fromRGB(24, 26, 31)
background.BackgroundTransparency = .05
background.BorderSizePixel = 0
background.Parent = gui
F.corner(background, 3)
F.stroke(background, 3, Color3.fromRGB(5, 5, 7), 0)

local label = Instance.new("TextLabel")
label.Name = "Number"
label.AnchorPoint = Vector2.new(.5, .5)
label.Position = UDim2.fromScale(.5, .5)
label.Size = UDim2.new(1, -8, 1, -8)
label.BackgroundTransparency = 1
label.Text = tostring(number)
label.TextColor3 = Color3.fromRGB(255, 255, 255)
label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
label.TextStrokeTransparency = 0
label.Font = Enum.Font.GothamBlack
label.TextScaled = true
label.Parent = background

local sizeConstraint = Instance.new("UITextSizeConstraint")
sizeConstraint.MinTextSize = 18
sizeConstraint.MaxTextSize = 42
sizeConstraint.Parent = label

table.insert(pubMethodNumberGuis, gui)
return gui
end

local function pubFindRoofAbove(podium, spawn)
local ignored = {podium, pubGetRoot()}
local origin = Vector3.new(
spawn.Position.X,
spawn.Position.Y + spawn.Size.Y / 2 + .1,
spawn.Position.Z
)
local remaining = PUB_MAX_SEARCH_HEIGHT
while remaining > 0 do
local params = RaycastParams.new()
params.FilterType = Enum.RaycastFilterType.Exclude
params.FilterDescendantsInstances = ignored
params.IgnoreWater = true
local result = workspace:Raycast(origin, Vector3.new(0, remaining, 0), params)
if not result then return nil end
local hit = result.Instance
if hit and hit:IsA("BasePart") and hit.CanCollide and hit.Transparency < 1 then
return hit
end
if hit then table.insert(ignored, hit) end
local travelled = math.max(result.Position.Y - origin.Y, 0)
remaining -= travelled + .1
origin = result.Position + Vector3.new(0, .1, 0)
end
return nil
end

local function pubGetRoofTopY(roof, spawn)
if not roof or not roof:IsA("BasePart") then return nil end
local params = RaycastParams.new()
params.FilterType = Enum.RaycastFilterType.Include
params.FilterDescendantsInstances = {roof}
params.IgnoreWater = true
local origin = Vector3.new(
spawn.Position.X,
roof.Position.Y + roof.Size.Magnitude + 50,
spawn.Position.Z
)
local result = workspace:Raycast(origin, Vector3.new(0, -1000, 0), params)
if result then return result.Position.Y end
return roof.Position.Y + roof.Size.Y / 2
end

local function pubPrepareClone(object)
if object:IsA("BasePart") then
object.Anchored = true
end
for _, descendant in ipairs(object:GetDescendants()) do
if descendant:IsA("Script") or descendant:IsA("LocalScript") then
descendant:Destroy()
elseif descendant:IsA("BasePart") then
descendant.Anchored = true
end
end
end

local function pubMoveClone(object, offset)
if object:IsA("BasePart") then
object.CFrame = object.CFrame + offset
return
end
if object:IsA("Model") then
object:PivotTo(object:GetPivot() + offset)
return
end
for _, descendant in ipairs(object:GetDescendants()) do
if descendant:IsA("BasePart") then
descendant.CFrame = descendant.CFrame + offset
end
end
end

local function pubGetAdornee(object)
if not object then return nil end
if object:IsA("BasePart") then return object end
if object:IsA("Model") and object.PrimaryPart then return object.PrimaryPart end
for _, descendant in ipairs(object:GetDescendants()) do
if descendant:IsA("BasePart") then return descendant end
end
return nil
end

local function pubCloneDecoration(source, offset, parent)
if not source then return nil end
local clone = source:Clone()
pubPrepareClone(clone)
pubMoveClone(clone, offset)
clone.Parent = parent
return clone
end

local function pubFirstMirrorNumber(sourceSlot)
local map = {
[1] = 11,
[2] = 12,
[3] = 13,
[4] = 14,
[5] = 15,
[8] = 18,
[9] = 17,
[10] = 16,
}
return map[sourceSlot]
end

local function pubSecondMirrorNumber(sourceSlot)
local map = {
[1] = 19,
[2] = 20,
[3] = 21,
[4] = 22,
[5] = 23,
[6] = 28,
[7] = 27,
[8] = 26,
[9] = 25,
[10] = 24,
}
return map[sourceSlot]
end

local function pubCreateMirror(plot, base, spawn, sourceSlot, displaySlot, targetY, layerName)
local decorations = base:FindFirstChild("Decorations")
if not decorations then return end
local sourcePart = decorations:FindFirstChild("Part")
local sourceDecoration = decorations:FindFirstChild("Decoration")
if not sourcePart and not sourceDecoration then return end

local folder = Instance.new("Folder")
folder.Name = tostring(plot.Name)
.. "_" .. layerName
.. "_Source" .. tostring(sourceSlot)
.. "_Slot" .. tostring(displaySlot)
folder.Parent = pubGetRoot()

local offset = Vector3.new(0, targetY - spawn.Position.Y, 0)
local clonedPart = sourcePart and pubCloneDecoration(sourcePart, offset, folder) or nil
local clonedDecoration = sourceDecoration and pubCloneDecoration(sourceDecoration, offset, folder) or nil
local adornee = pubGetAdornee(clonedPart) or pubGetAdornee(clonedDecoration)
if adornee then
pubMakeNumber(adornee, displaySlot)
end
end

local function pubBuildPodium(plot, podium, sourceSlot)
local base, spawn = pubGetBaseAndSpawn(podium)
if not base or not spawn then return end
pubMakeNumber(spawn, sourceSlot)

local roof = pubFindRoofAbove(podium, spawn)
if not roof then return end
local roofY = pubGetRoofTopY(roof, spawn)
if not roofY then return end

local firstNumber = pubFirstMirrorNumber(sourceSlot)
if firstNumber then
pubCreateMirror(
plot,
base,
spawn,
sourceSlot,
firstNumber,
roofY + PUB_FIRST_MIRROR_Y_OFFSET,
"FirstMirror"
)
end

local distance = roofY - spawn.Position.Y
local upperY = roofY + distance
pubCreateMirror(
plot,
base,
spawn,
sourceSlot,
pubSecondMirrorNumber(sourceSlot),
upperY,
"SecondMirror"
)
end

local function pubBuildPlot(plot)
if not visualState.PubMethod or not plot or not plot.Parent then return end
local podiums = plot:FindFirstChild("AnimalPodiums")
if not podiums then
local connection
connection = plot.ChildAdded:Connect(function(child)
if child.Name == "AnimalPodiums" then
if connection then connection:Disconnect() end
if visualState.PubMethod then
F.refreshPubMethod()
end
end
end)
table.insert(pubMethodConnections, connection)
return
end
for sourceSlot = 1, 10 do
local podium = podiums:FindFirstChild(tostring(sourceSlot))
if podium then
pubBuildPodium(plot, podium, sourceSlot)
end
end
end

function F.clearPubMethod()
pubDisconnectConnections()
pubClearNumberGuis()
pubDestroyRoot()
end

function F.refreshPubMethod()
if not visualState.PubMethod then return end
pubDisconnectConnections()
pubClearNumberGuis()
pubDestroyRoot()
pubGetRoot()
local plots = workspace:FindFirstChild("Plots")
if not plots then return end
for _, plot in ipairs(plots:GetChildren()) do
pubBuildPlot(plot)
end
table.insert(pubMethodConnections, plots.ChildAdded:Connect(function(plot)
task.delay(.35, function()
if visualState.PubMethod and plot and plot.Parent then
F.refreshPubMethod()
end
end)
end))
end

function F.setPubMethod(state)
visualState.PubMethod = not not state
F.clearVisualPrefix("SlotNumber_")
if visualState.PubMethod then
F.refreshPubMethod()
else
F.clearPubMethod()
task.defer(function()
if visualState.SlotNumbers then
F.updateVisuals()
end
end)
end
end

function F.setNextEmptyBase(state)
visualState.NextEmptyBase=not not state
if not visualState.NextEmptyBase then F.destroyVisualEntry("NextBaseLabel") F.destroyVisualEntry("NextBaseBeam") end
end
function F.setLineToBase(state)
visualState.LineToBase=not not state
if not visualState.LineToBase then F.destroyVisualEntry("OwnBaseBeam") end
end

function F.getVisualCache()
local now=os.clock()
if now-visualLastScan<0.5 then return visualCache end
visualLastScan=now
visualCache=F.getLiteBrainrotCache(true, false)
return visualCache
end

function F.makeWorldBeam(key, color)
local entry = visualEntries[key]
if entry and entry.Beam and entry.Beam.Parent then return entry end
if entry then F.destroyVisualEntry(key) end

local folder = Instance.new("Folder")
folder.Name = "_WuzzBeam_" .. key
folder.Parent = F.getVisualWorldRoot()

local p0 = Instance.new("Part")
p0.Name = "A"
p0.Size = Vector3.new(.05, .05, .05)
p0.Anchored = true
p0.CanCollide = false
p0.CanTouch = false
p0.CanQuery = false
p0.Transparency = 1
p0.Parent = folder

local p1 = p0:Clone()
p1.Name = "B"
p1.Parent = folder

local a0 = Instance.new("Attachment")
a0.Parent = p0
local a1 = Instance.new("Attachment")
a1.Parent = p1

local beam = Instance.new("Beam")
beam.Attachment0 = a0
beam.Attachment1 = a1
beam.FaceCamera = true
beam.LightEmission = 1
beam.LightInfluence = 0
beam.Width0 = .16
beam.Width1 = .16
beam.Color = ColorSequence.new(color)
beam.Transparency = NumberSequence.new(.08)
beam.Parent = folder

entry = {Folder=folder, Part0=p0, Part1=p1, Beam=beam}
visualEntries[key] = entry
return entry
end

function F.ensureNextBaseLabel(plot)
local key = "NextBaseLabel"
local anchor = F.getInstancePart(F.getPlotAnchor(plot))
if not anchor then
F.destroyVisualEntry(key)
F.destroyVisualEntry("NextBaseBeam")
return
end

local entry = visualEntries[key]
if not entry or entry.Adornee ~= anchor then
if entry then F.destroyVisualEntry(key) end

local billboard = Instance.new("BillboardGui")
billboard.Name = "_WuzzNextBase"
billboard.Adornee = anchor
billboard.AlwaysOnTop = true
billboard.LightInfluence = 0
billboard.Size = UDim2.fromOffset(190, 54)
billboard.StudsOffsetWorldSpace = Vector3.new(0, 6.5, 0)
billboard.Parent = anchor

local label = Instance.new("TextLabel")
label.BackgroundColor3 = C.DarkPurple
label.BackgroundTransparency = .04
label.BorderSizePixel = 0
label.Size = UDim2.fromScale(1, 1)
label.Font = Enum.Font.GothamBold
label.Text = "NEXT BASE"
label.TextColor3 = Color3.new(1,1,1)
label.TextSize = 16
label.Parent = billboard
F.corner(label, 12)
F.animatedStroke(label, 2)

visualEntries[key] = {Billboard=billboard, Adornee=anchor}
end

local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
if root then
local beam = F.makeWorldBeam("NextBaseBeam", Color3.fromRGB(205, 35, 255))
beam.TargetPart = anchor
beam.TargetOffset = Vector3.new(0, 1.5, 0)
beam.SmoothTarget = beam.SmoothTarget or (anchor.Position + beam.TargetOffset)
beam.Beam.Width0 = .32
beam.Beam.Width1 = .32
beam.Beam.Transparency = NumberSequence.new(.01)
beam.Beam.LightEmission = 1
end
end

function F.updateLineToBase()
if not visualState.LineToBase then
F.destroyVisualEntry("OwnBaseBeam")
return
end

local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
local plot = spawnedLocalPlot or matchedLocalPlot
if not plot then
for _, candidate in ipairs(F.getSortedPlots()) do
if F.plotBelongsToLocalPlayer(candidate) then plot = candidate break end
end
end

local anchor = plot and F.getInstancePart(F.getPlotAnchor(plot))
if not root or not anchor then
F.destroyVisualEntry("OwnBaseBeam")
return
end

local beam = F.makeWorldBeam("OwnBaseBeam", C.Purple2)
beam.TargetPart = anchor
beam.TargetOffset = Vector3.new(0, 1.5, 0)
beam.SmoothTarget = beam.SmoothTarget or (anchor.Position + beam.TargetOffset)
beam.Beam.Width0 = .14
beam.Beam.Width1 = .22
end

function F.updateVisuals()
local used={}
if visualState.BrainrotESP then
for _,record in ipairs(F.getVisualCache()) do
local key="Brainrot_"..record.Plot.Name.."_"..tostring(record.Slot.Name)
F.ensureBrainrotESP(key,record)
used[key]=true
end
for key in pairs(visualEntries) do if string.sub(key,1,9)=="Brainrot_" and not used[key] then F.destroyVisualEntry(key) end end
end
local allowSlotNumbers = visualState.SlotNumbers and not visualState.PubMethod
if visualState.SlotESP or allowSlotNumbers then
local closest=F.findClosestPlot()
local podiums=closest and closest:FindFirstChild("AnimalPodiums")
local chamUsed,numUsed={},{}
if podiums then
for _,slot in ipairs(podiums:GetChildren()) do
local _,spawnPart=F.getPromptAttachment(slot)
if spawnPart then
if visualState.SlotESP then
local key="SlotCham_"..tostring(slot.Name) F.ensureSlotCham(key,slot) chamUsed[key]=true
end
if allowSlotNumbers then
local key="SlotNumber_"..tostring(slot.Name) F.makeSlotNumber(key,slot,spawnPart) numUsed[key]=true
end
end
end
end
for key in pairs(visualEntries) do
if string.sub(key,1,9)=="SlotCham_" and not chamUsed[key] then F.destroyVisualEntry(key) end
if string.sub(key,1,11)=="SlotNumber_" and not numUsed[key] then F.destroyVisualEntry(key) end
end
end
if visualState.NextEmptyBase then
local plot=F.findNextJoinPlot()
if plot then F.ensureNextBaseLabel(plot) else F.destroyVisualEntry("NextBaseLabel") F.destroyVisualEntry("NextBaseBeam") end
end
F.updateLineToBase()
end

task.spawn(function()
while Gui.Parent do
F.updateVisuals()
task.wait(.5)
end
end)

function F.updateScreenVisuals(dt)
local camera=workspace.CurrentCamera
if not camera then return end
for key,entry in pairs(visualEntries) do
if string.sub(key,1,9)=="Brainrot_" and entry.Tag and entry.TargetPart then
local position = F.getWorldPosition(entry.TargetPart)
if position then
local p = camera:WorldToViewportPoint(position + Vector3.new(0, 4.6, 0))
entry.Tag.Visible = p.Z > 0
if p.Z > 0 then entry.Tag.Position = UDim2.fromOffset(p.X - 97, p.Y - 30) end
else
entry.Tag.Visible = false
end
elseif string.sub(key,1,11)=="SlotNumber_" and entry.Circle then
local p=camera:WorldToViewportPoint(entry.TargetPart.Position+Vector3.new(0,2.1,0))
entry.Circle.Visible=p.Z>0
if p.Z>0 then entry.Circle.Position=UDim2.fromOffset(p.X,p.Y) end
elseif key=="NextBaseLabel" and entry.Label and entry.TargetPart then
local p=camera:WorldToViewportPoint(entry.TargetPart.Position+Vector3.new(0,7,0))
entry.Label.Visible=p.Z>0
if p.Z>0 then entry.Label.Position=UDim2.fromOffset(p.X,p.Y) end
end
end
end
RunService.RenderStepped:Connect(F.updateScreenVisuals)

local floatEnabled = false
local floatPlatform
local FLOAT_PLATFORM_SPEED = 900
function F.destroyFloatPlatform()
if floatPlatform then floatPlatform:Destroy(); floatPlatform = nil end
end
function F.setFloat(state)
floatEnabled = not not state
if not floatEnabled then F.destroyFloatPlatform() end
end
RunService.Heartbeat:Connect(function(dt)
if not floatEnabled then return end
local character = LocalPlayer.Character
local root = character and character:FindFirstChild("HumanoidRootPart")
if not root then F.destroyFloatPlatform(); return end
if not floatPlatform or not floatPlatform.Parent then
floatPlatform = Instance.new("Part")
floatPlatform.Name = "_WuzzFloatPlatform"
floatPlatform.Size = Vector3.new(5.5, .35, 5.5)
floatPlatform.Anchored = true
floatPlatform.CanCollide = true
floatPlatform.CanTouch = false
floatPlatform.CanQuery = false
floatPlatform.Transparency = .32
floatPlatform.Material = Enum.Material.Neon
floatPlatform.Color = C.Purple
floatPlatform.CFrame = CFrame.new(root.Position - Vector3.new(0, 3.25, 0))
floatPlatform.Parent = workspace
end
local pos = floatPlatform.Position
local targetXZ = Vector3.new(root.Position.X, 0, root.Position.Z)
local step = math.min(FLOAT_PLATFORM_SPEED * math.clamp(dt, 1/240, .05), 20)
local ceiling = root.Position.Y - 1.9
local nextY = math.min(pos.Y + step, ceiling)
if pos.Y > ceiling + 2 then nextY = root.Position.Y - 3.0 end
floatPlatform.CFrame = CFrame.new(targetXZ.X, nextY, targetXZ.Z)
end)

function F.findLocalTool(name)
local character = LocalPlayer.Character
if character then
local tool = character:FindFirstChild(name)
if tool and tool:IsA("Tool") then return tool end
end
local backpack = LocalPlayer:FindFirstChildOfClass("Backpack")
if backpack then
local tool = backpack:FindFirstChild(name)
if tool and tool:IsA("Tool") then return tool end
end
return nil
end
function F.equipTool(tool)
local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
if humanoid and tool then
pcall(function() humanoid:EquipTool(tool) end)
return humanoid
end
end
local instantCloneBusy = false
local setAutoCloneToggle
function F.runInstantClone()
if instantCloneBusy then return end
instantCloneBusy = true
task.spawn(function()
local tool = F.findLocalTool("Quantum Cloner") or F.findLocalTool("QuantumCloner")
local humanoid = F.equipTool(tool)
if tool and humanoid then
task.wait(.08)
pcall(function() tool:Activate() end)
local cloneNameA = "Clone_" .. tostring(LocalPlayer.UserId)
local cloneNameB = tostring(LocalPlayer.UserId) .. "_Clone"
local started = os.clock()
while os.clock() - started < 1.5 and not workspace:FindFirstChild(cloneNameA) and not workspace:FindFirstChild(cloneNameB) do
task.wait(.05)
end
local toolsFrames = LocalPlayer.PlayerGui:FindFirstChild("ToolsFrames")
local quantum = toolsFrames and toolsFrames:FindFirstChild("QuantumCloner")
local teleportButton = quantum and quantum:FindFirstChild("TeleportToClone")
local fired = false
if teleportButton and firesignal then
pcall(function()
firesignal(teleportButton.MouseButton1Up)
fired = true
end)
end
if not fired then
pcall(function()
local Net = require(ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Net"))
Net:RemoteEvent("QuantumCloner/OnTeleport"):FireServer()
end)
end
task.wait(.08)
pcall(function() humanoid:UnequipTools() end)
end
instantCloneBusy = false
if setAutoCloneToggle then
task.defer(setAutoCloneToggle, false)
end
end)
end
local carpetSpeedEnabled = false
local CARPET_SPEED = 200
local carpetWasEquippedByWuzz = false
function F.setCarpetSpeed(state)
carpetSpeedEnabled = not not state
if not carpetSpeedEnabled then
local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
if humanoid and carpetWasEquippedByWuzz then
pcall(function() humanoid:UnequipTools() end)
end
carpetWasEquippedByWuzz = false
end
end
RunService.Heartbeat:Connect(function()
if not carpetSpeedEnabled then return end
local character = LocalPlayer.Character
local humanoid = character and character:FindFirstChildOfClass("Humanoid")
local root = character and character:FindFirstChild("HumanoidRootPart")
if not humanoid or not root then return end
local carpet = F.findLocalTool("Flying Carpet")
if carpet and carpet.Parent ~= character then
pcall(function() humanoid:EquipTool(carpet) end)
carpetWasEquippedByWuzz = true
end
local direction = humanoid.MoveDirection
local flightPower = root:FindFirstChild("FlightPower")
if flightPower and flightPower:IsA("BodyVelocity") then
if direction.Magnitude > .01 then
flightPower.Velocity = direction.Unit * CARPET_SPEED
else
flightPower.Velocity = Vector3.zero
end
elseif direction.Magnitude > .01 then
local v = root.AssemblyLinearVelocity
root.AssemblyLinearVelocity = Vector3.new(
direction.Unit.X * CARPET_SPEED,
v.Y,
direction.Unit.Z * CARPET_SPEED
)
end
end)
local dropBrainrotActive = false
local dropBrainrotConnections = {}
local dropCollisionCache = setmetatable({}, {__mode = "k"})

function F.stopDropBrainrot()
dropBrainrotActive = false
for _, connection in ipairs(dropBrainrotConnections) do
if typeof(connection) == "RBXScriptConnection" then
pcall(function() connection:Disconnect() end)
end
end
table.clear(dropBrainrotConnections)
for part, canCollide in pairs(dropCollisionCache) do
if part and part.Parent then
pcall(function() part.CanCollide = canCollide end)
end
end
dropCollisionCache = setmetatable({}, {__mode = "k"})
end

function F.velocityDropPulse()
return F.dropBrainrot()
end

function F.dropBrainrot()
if dropBrainrotActive then return false end
dropBrainrotActive = true
local character = LocalPlayer.Character
if not character then
dropBrainrotActive = false
return false
end
local root = character:FindFirstChild("HumanoidRootPart")
local camera = workspace.CurrentCamera
if camera then
for _, child in ipairs(camera:GetChildren()) do
if child.Name == "HumanoidRootPart" and child:IsA("BasePart") then
root = child
break
end
end
end
if not root then
dropBrainrotActive = false
return false
end
table.insert(dropBrainrotConnections, RunService.Stepped:Connect(function()
if not dropBrainrotActive then return end
for _, player in ipairs(Players:GetPlayers()) do
if player ~= LocalPlayer and player.Character then
for _, part in ipairs(player.Character:GetChildren()) do
if part:IsA("BasePart") then
if dropCollisionCache[part] == nil then dropCollisionCache[part] = part.CanCollide end
part.CanCollide = false
end
end
end
end
end))
task.spawn(function()
if _G.InvisActive or _G.RyInvisActive then
root.CFrame = root.CFrame * CFrame.new(0, 3, 0)
end
while dropBrainrotActive do
RunService.Heartbeat:Wait()
if not root or not root.Parent then break end
local velocity = root.Velocity
root.Velocity = velocity * 10000 + Vector3.new(0, 10000, 0)
RunService.RenderStepped:Wait()
if root and root.Parent then root.Velocity = velocity end
RunService.Stepped:Wait()
if root and root.Parent then root.Velocity = velocity + Vector3.new(0, 0.1, 0) end
end
end)
task.delay(0.4, F.stopDropBrainrot)
return true
end

_G.DropBrainrot = F.dropBrainrot
_G.executeDropBrainrot = F.dropBrainrot

function F.buildMainUI()
local protection, protectionBody = F.createPanel(
"Protection",
"PR",
UDim2.new(1, -402, 0, 20),
UDim2.fromOffset(190, 210)
)
F.makeSectionLayout(protectionBody)
F.makeToggle(protectionBody, "Anti Ragdoll", false, function(state)
if SetAntiRagdollImported then
SetAntiRagdollImported(state)
end
end)
F.makeToggle(protectionBody, "Auto Turret", false, function(state)
if SetAutoTurretImported then
SetAutoTurretImported(state)
end
end)
local setBalloonResetToggle
local _, _, _, balloonSetter = F.makeToggle(protectionBody, "Balloon Reset", false, function(state)
if state then
F.balloonReset()
task.defer(function()
if setBalloonResetToggle then
setBalloonResetToggle(false)
end
end)
end
end)
setBalloonResetToggle = balloonSetter
local invisible, invisibleBody = F.createPanel(
"Invisible Steal",
"IS",
UDim2.new(1, -202, 0, 20),
UDim2.fromOffset(188, 230)
)
F.makeSectionLayout(invisibleBody)
local _, _, _, setInvisibleToggle = F.makeToggle(
invisibleBody,
"Invisible Steal",
false,
F.setInvisibleStealEnabled
)
F.makeToggle(invisibleBody, "WalkSpeed", false, F.setWalkSpeedEnabled)
F.makeSlider(invisibleBody, "Speed", 28, 15, 32, F.setWalkSpeedValue, 1)
F.makeSlider(invisibleBody, "Rotation", 225, 0, 360, F.setInvisibleRotation, 1)
local keybinds, keybindBody = F.createPanel(
"Keybinds",
"KB",
UDim2.new(1, -415, 0, 240),
UDim2.fromOffset(203, 305)
)
local keybindScroll = Instance.new("ScrollingFrame")
keybindScroll.Name = "KeybindScroll"
keybindScroll.BackgroundTransparency = 1
keybindScroll.BorderSizePixel = 0
keybindScroll.Size = UDim2.fromScale(1, 1)
keybindScroll.CanvasSize = UDim2.fromOffset(0, 0)
keybindScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
keybindScroll.ScrollBarThickness = 3
keybindScroll.ScrollBarImageColor3 = C.Purple
keybindScroll.ScrollingDirection = Enum.ScrollingDirection.Y
keybindScroll.Parent = keybindBody
local keybindPadding = Instance.new("UIPadding")
keybindPadding.PaddingRight = UDim.new(0, 5)
keybindPadding.Parent = keybindScroll
F.makeSectionLayout(keybindScroll)
F.makeKeybind(keybindScroll, "Invisible Steal", "PageDown")
F.makeKeybind(keybindScroll, "WalkSpeed", "PageUp")
F.makeKeybind(keybindScroll, "Auto Clone", "Z")
F.makeKeybind(keybindScroll, "Float", "X")
F.makeKeybind(keybindScroll, "Carpet Speed", "C")
F.makeKeybind(keybindScroll, "Drop Brainrot", "V")
F.makeKeybind(keybindScroll, "Instant Steal", "G")
F.makeKeybind(keybindScroll, "Instant Reset", "B")
KeybindCallbacks["Invisible Steal"] = function()
local action = ToggleActions["Invisible Steal"]
if action then action() end
end
KeybindCallbacks["WalkSpeed"] = function()
local action = ToggleActions["WalkSpeed"]
if action then action() end
end
KeybindCallbacks["Instant Steal"] = function()
local action = ToggleActions["Instant Steal"]
if action then action() end
end
KeybindCallbacks["Instant Reset"] = function()
local action = ToggleActions["Instant Reset"]
if action then action() else task.spawn(F.flingUp) end
end
KeybindCallbacks["Auto Clone"] = function()
local action = ToggleActions["Auto Clone"]
if action then action() else F.runInstantClone() end
end
KeybindCallbacks["Float"] = function()
local action = ToggleActions["Float"]
if action then action() end
end
KeybindCallbacks["Carpet Speed"] = function()
local action = ToggleActions["Carpet Speed"]
if action then action() end
end
KeybindCallbacks["Drop Brainrot"] = F.dropBrainrot
local visuals, visualsBody = F.createPanel(
"Visuals",
"VS",
UDim2.new(1, -202, 0, 330),
UDim2.fromOffset(188, 355)
)
F.makeSectionLayout(visualsBody)
F.makeToggle(visualsBody, "XRay Plots", false, F.setXrayBases)
F.makeToggle(visualsBody, "Brainrot ESP", false, F.setBrainrotESP)
F.makeToggle(visualsBody, "Slot ESP", false, F.setSlotESP)
F.makeToggle(visualsBody, "Slot Numbers", false, F.setSlotNumbers)
F.makeToggle(visualsBody, "Next Empty Base", false, F.setNextEmptyBase)
F.makeToggle(visualsBody, "Line to Base", false, F.setLineToBase)
F.makeToggle(visualsBody, "FPS Boost", false, F.setFPSBoost)
local _, _, setFOVSlider = F.makeSlider(visualsBody, "FOV", 70, 40, 120, F.setCameraFOV, 1)
local resetFOVButton = F.makeButton(visualsBody, "RESET FOV")
resetFOVButton.MouseButton1Click:Connect(function()
setFOVSlider(70, true)
end)
local targetControls, targetControlsBody = F.createPanel(
"Target Controls",
"TC",
UDim2.new(1, -202, 0, 700),
UDim2.fromOffset(188, 440)
)
F.makeSectionLayout(targetControlsBody)
F.makeToggle(targetControlsBody, "Instant Steal", false, F.setInstantSteal)
F.makeToggle(targetControlsBody, "Pub Method", false, F.setPubMethod)
F.makeToggle(targetControlsBody, "Infinite Jump", false, F.setInfiniteJump)
local _, _, _, autoCloneSetter = F.makeToggle(targetControlsBody, "Auto Clone", false, function(state)
if state then
F.runInstantClone()
end
end)
setAutoCloneToggle = autoCloneSetter
F.makeToggle(targetControlsBody, "Float", false, F.setFloat)
F.makeToggle(targetControlsBody, "Carpet Speed", false, F.setCarpetSpeed)
local _, _, _, instantResetSetter = F.makeToggle(targetControlsBody, "Instant Reset", false, F.setInstantResetState)
setInstantResetToggle = instantResetSetter
local _, _, _, autoLeaveSetter = F.makeToggle(targetControlsBody, "Auto Leave", false, function(state)
F.setAutoLeaveEnabled(state)
if state and not matchedDeliveryHitbox then
task.defer(F.bindLocalPlotDelivery)
end
end)
setAutoLeaveToggle = autoLeaveSetter
local bottomButtons = Instance.new("Frame")
bottomButtons.BackgroundTransparency = 1
bottomButtons.Size = UDim2.new(1, 0, 0, 31)
bottomButtons.Parent = targetControlsBody
local drop = Instance.new("TextButton")
drop.BackgroundColor3 = Color3.fromRGB(135, 36, 92)
drop.BorderSizePixel = 0
drop.Size = UDim2.new(.49, 0, 1, 0)
drop.Text = "DROP"
drop.TextColor3 = C.Text
drop.Font = Enum.Font.GothamBold
drop.TextSize = 9
drop.Parent = bottomButtons
F.corner(drop, 7)
drop.MouseButton1Click:Connect(F.dropBrainrot)
local reset = Instance.new("TextButton")
reset.BackgroundColor3 = Color3.fromRGB(100, 28, 130)
reset.BorderSizePixel = 0
reset.Position = UDim2.new(.51, 0, 0, 0)
reset.Size = UDim2.new(.49, 0, 1, 0)
reset.Text = "LEAVE"
reset.TextColor3 = C.Text
reset.Font = Enum.Font.GothamBold
reset.TextSize = 9
reset.Parent = bottomButtons
F.corner(reset, 7)
reset.MouseButton1Click:Connect(F.instantLeave)
local target, targetBody = F.createPanel(
"Target List",
"TL",
UDim2.new(1, -430, 0, 560),
UDim2.fromOffset(218, 265)
)
local targetList = Instance.new("ScrollingFrame")
targetList.Name = "BrainrotTargets"
targetList.BackgroundTransparency = 1
targetList.BorderSizePixel = 0
targetList.Position = UDim2.fromOffset(0, 4)
targetList.Size = UDim2.new(1, 0, 1, -4)
targetList.CanvasSize = UDim2.fromOffset(0, 0)
targetList.AutomaticCanvasSize = Enum.AutomaticSize.Y
targetList.ScrollBarThickness = 3
targetList.ScrollBarImageColor3 = C.Purple
targetList.Parent = targetBody
local targetListLayout = Instance.new("UIListLayout")
targetListLayout.Padding = UDim.new(0, 5)
targetListLayout.SortOrder = Enum.SortOrder.LayoutOrder
targetListLayout.Parent = targetList
local targetListSignature = ""
function F.updateTargetTracer()
if not selectedTargetRecord then
F.destroyVisualEntry("TargetTracer")
return
end

local targetPart = selectedTargetRecord.FakeRootPart or F.getFakeRootPart(selectedTargetRecord.Adornee) or F.getInstancePart(selectedTargetRecord.Spawn)
if not targetPart or not targetPart.Parent then
F.destroyVisualEntry("TargetTracer")
return
end

local beam = F.makeWorldBeam("TargetTracer", Color3.fromRGB(255, 40, 60))
beam.TargetPart = targetPart
beam.TargetOffset = Vector3.zero
beam.SmoothTarget = beam.SmoothTarget or targetPart.Position
beam.Beam.Width0 = .2
beam.Beam.Width1 = .2
beam.Beam.Transparency = NumberSequence.new(.02)
end

function F.updateFollowBeams(dt)
local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
if not root then return end

for _, key in ipairs({"NextBaseBeam", "OwnBaseBeam", "TargetTracer"}) do
local entry = visualEntries[key]
if entry and entry.Beam and entry.TargetPart and entry.TargetPart.Parent then
entry.Part0.CFrame = CFrame.new(root.Position)
local wanted = entry.TargetPart.Position + (entry.TargetOffset or Vector3.zero)
local alpha = 1 - math.exp(-math.max(dt, 1/240) * 24)
entry.SmoothTarget = entry.SmoothTarget and entry.SmoothTarget:Lerp(wanted, alpha) or wanted
entry.Part1.CFrame = CFrame.new(entry.SmoothTarget)
end
end
end

RunService.RenderStepped:Connect(function(dt)
F.updateTargetTracer()
F.updateFollowBeams(dt)
end)

function F.rebuildBrainrotTargetList()
if not targetList.Parent then return end
local records = F.getLiteBrainrotCache(false, false)
table.sort(records, function(a,b)
if (a.MPSValue or 0) ~= (b.MPSValue or 0) then return (a.MPSValue or 0) > (b.MPSValue or 0) end
return string.lower(a.Name or "") < string.lower(b.Name or "")
end)
local signatureParts = {}
for _, record in ipairs(records) do
local traitNames = {}
for _, trait in ipairs(record.Traits or {}) do
table.insert(traitNames, trait.Name or "")
end
table.insert(signatureParts,
record.Plot.Name .. ":" ..
record.Slot.Name .. ":" ..
record.Name .. ":" ..
tostring(record.MPS) .. ":" .. tostring(record.MPSValue or 0) .. ":" ..
tostring(record.Mutation or "") .. ":" .. table.concat(traitNames, ",")
)
end
local signature = table.concat(signatureParts, "|")
if signature == targetListSignature then return end
targetListSignature = signature

for _, child in ipairs(targetList:GetChildren()) do
if child:IsA("TextButton") then child:Destroy() end
end

for index, record in ipairs(records) do
local button = Instance.new("TextButton")
button.Name = "Target_" .. tostring(index)
button.AutoButtonColor = false
button.BackgroundColor3 = C.Background3
button.BackgroundTransparency = .06
button.BorderSizePixel = 0
button.Size = UDim2.new(1, -4, 0, 62)
button.Text = ""
button.Parent = targetList
F.corner(button, 8)
local stroke = F.stroke(button, 1, C.Line, .12)

local nameLabel = F.label(
button,
(index == 1 and "★ " or "") .. record.Name,
UDim2.new(1, -12, 0, 18),
UDim2.fromOffset(8, 4),
10,
true
)
nameLabel.TextTruncate = Enum.TextTruncate.AtEnd
nameLabel.ZIndex = 4

local mpsLabel = F.label(
button,
record.MPS or "MPS N/A",
UDim2.new(.6, -8, 0, 14),
UDim2.fromOffset(8, 21),
8,
true
)
mpsLabel.TextColor3 = C.Purple2
mpsLabel.ZIndex = 4
local mutationLabel = F.label(
button,
"",
UDim2.new(.4, -8, 0, 14),
UDim2.new(.6, 0, 0, 21),
7,
true
)
mutationLabel.TextXAlignment = Enum.TextXAlignment.Right
mutationLabel.ZIndex = 4
F.styleMutationLabel(mutationLabel, record.Mutation)

local traitsRow = Instance.new("Frame")
traitsRow.BackgroundTransparency = 1
traitsRow.Position = UDim2.fromOffset(8, 42)
traitsRow.Size = UDim2.new(1, -16, 0, 14)
traitsRow.ZIndex = 4
traitsRow.Parent = button
local traitLayout = Instance.new("UIListLayout")
traitLayout.FillDirection = Enum.FillDirection.Horizontal
traitLayout.Padding = UDim.new(0, 3)
traitLayout.Parent = traitsRow

local shownTraits = 0
for _, trait in ipairs(record.Traits or {}) do
shownTraits += 1
if shownTraits > 7 then break end
if trait.Icon then
local icon = Instance.new("ImageLabel")
icon.BackgroundColor3 = C.DarkPurple
icon.BackgroundTransparency = .14
icon.BorderSizePixel = 0
icon.Size = UDim2.fromOffset(14, 14)
icon.Image = trait.Icon
icon.ScaleType = Enum.ScaleType.Fit
icon.ZIndex = 5
icon.Parent = traitsRow
F.corner(icon, 4)
F.stroke(icon, .8, C.Purple3, .25)
else
local traitLabel = Instance.new("TextLabel")
traitLabel.BackgroundColor3 = C.DarkPurple
traitLabel.BackgroundTransparency = .14
traitLabel.BorderSizePixel = 0
traitLabel.Size = UDim2.fromOffset(28, 14)
traitLabel.Font = Enum.Font.GothamBold
traitLabel.Text = string.upper(string.sub(trait.Name or "?", 1, 3))
traitLabel.TextColor3 = C.Text
traitLabel.TextSize = 6
traitLabel.ZIndex = 5
traitLabel.Parent = traitsRow
F.corner(traitLabel, 4)
end
end

if shownTraits == 0 then
local none = F.label(
traitsRow,
"NO TRAITS",
UDim2.fromOffset(55, 14),
UDim2.fromOffset(0, 0),
7,
true
)
none.TextColor3 = C.Muted
none.ZIndex = 5
end

button.MouseEnter:Connect(function()
TweenService:Create(button, TweenInfo.new(.12), {BackgroundColor3 = Color3.fromRGB(48, 22, 67)}):Play()
end)
button.MouseLeave:Connect(function()
if selectedTargetRecord ~= record then
TweenService:Create(button, TweenInfo.new(.12), {BackgroundColor3 = C.Background3}):Play()
end
end)

button.MouseButton1Click:Connect(function()
selectedTargetRecord = record
selectedTargetPrompt = record.Prompt
if WuzzInstantSteal then
WuzzInstantSteal:SetSelectedBrainrot({
plot = record.Plot and record.Plot.Name or nil,
slot = record.Slot and tostring(record.Slot.Name) or nil,
name = record.Name,
})
end
for _, row in ipairs(targetList:GetChildren()) do
if row:IsA("TextButton") then
row.BackgroundColor3 = C.Background3
local rowStroke = row:FindFirstChildOfClass("UIStroke")
if rowStroke then rowStroke.Color = C.Line end
end
end
button.BackgroundColor3 = C.DarkPurple
stroke.Color = C.Purple2
end)
end
end
task.spawn(function()
task.wait(1)
while targetList.Parent do
F.rebuildBrainrotTargetList()
task.wait(1)
end
end)
local ap, apBody = F.createPanel(
"AP Spam",
"AP",
UDim2.new(0, 24, .5, -255),
UDim2.fromOffset(255, 510)
)
local searchBox = Instance.new("TextBox")
searchBox.BackgroundColor3 = C.Background3
searchBox.BorderSizePixel = 0
searchBox.PlaceholderText = "Search player..."
searchBox.PlaceholderColor3 = C.Muted
searchBox.Text = ""
searchBox.TextColor3 = C.Text
searchBox.Font = Enum.Font.Gotham
searchBox.TextSize = 10
searchBox.ClearTextOnFocus = false
searchBox.Size = UDim2.new(1, 0, 0, 32)
searchBox.Parent = apBody
F.corner(searchBox, 7)
F.stroke(searchBox, 1, C.Purple3, .2)
local info = F.label(
apBody,
"CLICK A PLAYER TO SEND AP COMMANDS",
UDim2.new(1, 0, 0, 22),
UDim2.fromOffset(0, 39),
8,
true
)
info.TextColor3 = C.Purple2
info.TextXAlignment = Enum.TextXAlignment.Center
local list = Instance.new("ScrollingFrame")
list.BackgroundTransparency = 1
list.BorderSizePixel = 0
list.Position = UDim2.fromOffset(0, 67)
list.Size = UDim2.new(1, 0, 1, -67)
list.ScrollBarThickness = 3
list.ScrollBarImageColor3 = C.Purple
list.AutomaticCanvasSize = Enum.AutomaticSize.Y
list.CanvasSize = UDim2.fromOffset(0, 0)
list.Parent = apBody
local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 6)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Parent = list
local commands = {
";rocket %s",
";ragdoll %s",
";inverse %s",
";jail %s",
";tiny %s",
";morph %s",
";jumpscare %s",
";balloon %s"
}
function F.sendChat(message)
local sent = false
pcall(function()
local channels = TextChatService:FindFirstChild("TextChannels")
if channels then
local channel =
channels:FindFirstChild("RBXGeneral")
or channels:FindFirstChildWhichIsA("TextChannel")
if channel then
channel:SendAsync(message)
sent = true
end
end
end)
if sent then
return
end
pcall(function()
local events = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
if events then
local remote = events:FindFirstChild("SayMessageRequest")
if remote then
remote:FireServer(message, "All")
end
end
end)
end
local sending = {}
function F.sendCommands(player)
if sending[player.UserId] then
return
end
sending[player.UserId] = true
task.spawn(function()
for _, command in ipairs(commands) do
if not Players:GetPlayerByUserId(player.UserId) then
break
end
F.sendChat(string.format(command, player.Name))
task.wait(.12)
end
sending[player.UserId] = nil
end)
end
function F.createPlayerButton(player)
local button = Instance.new("TextButton")
button.Name = tostring(player.UserId)
button.AutoButtonColor = false
button.BackgroundColor3 = C.Background3
button.BackgroundTransparency = .08
button.BorderSizePixel = 0
button.Size = UDim2.new(1, -4, 0, 47)
button.Text = ""
button.Parent = list
F.corner(button, 8)
F.stroke(button, 1, C.Line, .15)
local avatar = Instance.new("ImageLabel")
avatar.BackgroundColor3 = C.DarkPurple
avatar.BorderSizePixel = 0
avatar.Position = UDim2.fromOffset(7, 6)
avatar.Size = UDim2.fromOffset(35, 35)
avatar.Image = ""
avatar.Parent = button
F.corner(avatar, 7)
F.stroke(avatar, 1, C.Purple3, .25)
task.spawn(function()
local ok, image = pcall(
Players.GetUserThumbnailAsync,
Players,
player.UserId,
Enum.ThumbnailType.HeadShot,
Enum.ThumbnailSize.Size100x100
)
if ok and avatar.Parent then
avatar.Image = image
end
end)
local display = F.label(
button,
player.DisplayName,
UDim2.new(1, -55, 0, 18),
UDim2.fromOffset(51, 6),
10,
true
)
local username = F.label(
button,
"@" .. player.Name,
UDim2.new(1, -55, 0, 15),
UDim2.fromOffset(51, 25),
8,
false
)
username.TextColor3 = C.Muted
local flash = Instance.new("Frame")
flash.BackgroundColor3 = C.Purple
flash.BackgroundTransparency = 1
flash.BorderSizePixel = 0
flash.Size = UDim2.fromScale(1, 1)
flash.ZIndex = 0
flash.Parent = button
F.corner(flash, 8)
button.MouseEnter:Connect(function()
TweenService:Create(
button,
TweenInfo.new(.13),
{BackgroundColor3 = Color3.fromRGB(49, 20, 67)}
):Play()
end)
button.MouseLeave:Connect(function()
TweenService:Create(
button,
TweenInfo.new(.13),
{BackgroundColor3 = C.Background3}
):Play()
end)
button.MouseButton1Click:Connect(function()
TweenService:Create(
flash,
TweenInfo.new(.08),
{BackgroundTransparency = .72}
):Play()
task.delay(.08, function()
TweenService:Create(
flash,
TweenInfo.new(.35),
{BackgroundTransparency = 1}
):Play()
end)
info.Text = "SENDING TO @" .. string.upper(player.Name)
info.TextColor3 = C.Purple2
F.sendCommands(player)
task.delay(1.3, function()
if info.Parent then
info.Text = "CLICK A PLAYER TO SEND AP COMMANDS"
end
end)
end)
return button
end
local playerButtons = {}
function F.rebuildPlayers()
for _, item in ipairs(list:GetChildren()) do
if item:IsA("TextButton") then
item:Destroy()
end
end
table.clear(playerButtons)
local filter = string.lower(searchBox.Text)
local all = Players:GetPlayers()
table.sort(all, function(a, b)
return string.lower(a.DisplayName) < string.lower(b.DisplayName)
end)
for _, player in ipairs(all) do
local searchable = string.lower(player.DisplayName .. " " .. player.Name)
if filter == "" or string.find(searchable, filter, 1, true) then
local button = F.createPlayerButton(player)
playerButtons[player.UserId] = button
end
end
end
searchBox:GetPropertyChangedSignal("Text"):Connect(F.rebuildPlayers)
Players.PlayerAdded:Connect(F.rebuildPlayers)
Players.PlayerRemoving:Connect(F.rebuildPlayers)
F.rebuildPlayers()
local watermark = Instance.new("Frame")
watermark.AnchorPoint = Vector2.new(.5, 1)
watermark.BackgroundColor3 = C.Background
watermark.BackgroundTransparency = .03
watermark.BorderSizePixel = 0
watermark.Position = UDim2.new(.5, 0, 1, -72)
watermark.Size = UDim2.fromOffset(520, 40)
watermark.Parent = Gui
F.registerScalable(watermark, "MainBar")
F.corner(watermark, 10)
F.animatedStroke(watermark, 1.4)
F.particleLayer(watermark)
local dot = Instance.new("Frame")
dot.AnchorPoint = Vector2.new(.5, .5)
dot.BackgroundColor3 = C.Purple2
dot.BorderSizePixel = 0
dot.Position = UDim2.new(0, 17, .5, 0)
dot.Size = UDim2.fromOffset(8, 8)
dot.ZIndex = 5
dot.Parent = watermark
F.corner(dot, 10)
task.spawn(function()
while dot.Parent do
TweenService:Create(
dot,
TweenInfo.new(.65, Enum.EasingStyle.Sine),
{BackgroundTransparency = .65, Size = UDim2.fromOffset(5, 5)}
):Play()
task.wait(.65)
if not dot.Parent then
break
end
TweenService:Create(
dot,
TweenInfo.new(.65, Enum.EasingStyle.Sine),
{BackgroundTransparency = 0, Size = UDim2.fromOffset(8, 8)}
):Play()
task.wait(.65)
end
end)
local hubText = F.label(
watermark,
"WUZZ HUB",
UDim2.fromOffset(82, 40),
UDim2.fromOffset(29, 0),
11,
true
)
hubText.TextYAlignment = Enum.TextYAlignment.Center
local divider = Instance.new("Frame")
divider.BackgroundColor3 = C.Line
divider.BorderSizePixel = 0
divider.Position = UDim2.fromOffset(115, 10)
divider.Size = UDim2.fromOffset(1, 20)
divider.Parent = watermark
local statsText = F.label(
watermark,
"FPS: ?   PING: ? ms",
UDim2.fromOffset(142, 40),
UDim2.fromOffset(127, 0),
10,
true
)
statsText.TextColor3 = C.Purple2
statsText.TextYAlignment = Enum.TextYAlignment.Center
local divider2 = Instance.new("Frame")
divider2.BackgroundColor3 = C.Line
divider2.BorderSizePixel = 0
divider2.Position = UDim2.fromOffset(278, 10)
divider2.Size = UDim2.fromOffset(1, 20)
divider2.Parent = watermark
local discord = F.label(
watermark,
"discord.gg/szq24meDtm",
UDim2.new(1, -342, 1, 0),
UDim2.fromOffset(293, 0),
10,
true
)
discord.TextColor3 = C.Purple2
discord.TextYAlignment = Enum.TextYAlignment.Center

local gearButton = Instance.new("TextButton")
gearButton.AutoButtonColor = false
gearButton.BackgroundColor3 = C.DarkPurple
gearButton.BorderSizePixel = 0
gearButton.Position = UDim2.new(1, -34, .5, -12)
gearButton.Size = UDim2.fromOffset(24, 24)
gearButton.Text = "⚙"
gearButton.TextColor3 = C.Purple2
gearButton.Font = Enum.Font.GothamBold
gearButton.TextSize = 14
gearButton.ZIndex = 12
gearButton.Parent = watermark
F.corner(gearButton, 6)
F.stroke(gearButton, 1, C.Purple3, .2)

local settingsPanel = Instance.new("Frame")
settingsPanel.Name = "HubSettings"
settingsPanel.AnchorPoint = Vector2.new(.5, 1)
settingsPanel.BackgroundColor3 = C.Background
settingsPanel.BackgroundTransparency = .02
settingsPanel.BorderSizePixel = 0
settingsPanel.Position = UDim2.new(.5, 150, 1, -122)
settingsPanel.Size = UDim2.fromOffset(230, 122)
settingsPanel.Visible = false
settingsPanel.ZIndex = 195
settingsPanel.Parent = Gui
F.registerScalable(settingsPanel, "HubSettings")
F.corner(settingsPanel, 10)
F.animatedStroke(settingsPanel, 1.3)

local settingsTitle = F.label(settingsPanel, "GUI SETTINGS", UDim2.new(1,-16,0,22), UDim2.fromOffset(8,5), 10, true)
settingsTitle.ZIndex = 196

local settingsBody = Instance.new("Frame")
settingsBody.BackgroundTransparency = 1
settingsBody.Position = UDim2.fromOffset(8, 30)
settingsBody.Size = UDim2.new(1,-16,1,-38)
settingsBody.ZIndex = 196
settingsBody.Parent = settingsPanel
F.makeSectionLayout(settingsBody)

F.makeSlider(settingsBody, "GUI Scale", GuiScaleValue * 100, 60, 140, function(value)
F.setGuiScale(value / 100)
end, 5)

local lockButton = F.makeButton(settingsBody, GuiPositionLocked and "UNLOCK GUI POSITIONS" or "LOCK GUI POSITIONS")
lockButton.ZIndex = 197
lockButton.MouseButton1Click:Connect(function()
F.setGuiLocked(not GuiPositionLocked)
lockButton.Text = GuiPositionLocked and "UNLOCK GUI POSITIONS" or "LOCK GUI POSITIONS"
end)

gearButton.MouseButton1Click:Connect(function()
settingsPanel.Visible = not settingsPanel.Visible
end)

local frameCount = 0
local sampleStarted = os.clock()
RunService.RenderStepped:Connect(function()
frameCount += 1
local now = os.clock()
local elapsed = now - sampleStarted
if elapsed >= .5 then
local fps = math.floor((frameCount / elapsed) + .5)
local ping = 0
pcall(function()
ping = math.floor((LocalPlayer:GetNetworkPing() * 1000) + .5)
end)
if statsText.Parent then
statsText.Text = string.format("FPS: %d   PING: %d ms", fps, ping)
end
frameCount = 0
sampleStarted = now
end
end)
local glow = Instance.new("Frame")
glow.AnchorPoint = Vector2.new(.5, .5)
glow.BackgroundColor3 = C.Purple
glow.BackgroundTransparency = .93
glow.BorderSizePixel = 0
glow.Position = UDim2.fromScale(.5, .5)
glow.Size = UDim2.new(1, 20, 1, 20)
glow.ZIndex = -1
glow.Parent = watermark
F.corner(glow, 14)
task.spawn(function()
while glow.Parent do
TweenService:Create(
glow,
TweenInfo.new(1.3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
{
BackgroundTransparency = .97,
Size = UDim2.new(1, 32, 1, 32)
}
):Play()
task.wait(1.3)
if not glow.Parent then
break
end
TweenService:Create(
glow,
TweenInfo.new(1.3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
{
BackgroundTransparency = .91,
Size = UDim2.new(1, 20, 1, 20)
}
):Play()
task.wait(1.3)
end
end)
end
do
local ok, err = pcall(F.buildMainUI)
if not ok then
warn("[WuzzHub] Main UI failed:", err)
end
end
