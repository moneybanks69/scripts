local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local GuiService = game:GetService("GuiService")
local HttpService = game:GetService("HttpService")
local Workspace = game:GetService("Workspace")
local LP = Players.LocalPlayer
local Env = getgenv and getgenv() or _G
if Env.WuzzConvincerCleanup then
    pcall(Env.WuzzConvincerCleanup)
end
local Connections = {}
local Gui
local Trading = false
local ClearSelectedBaseESP
local BaseViewerFrame
local AutoMessageFrame
local AutoMessageEditor
local FrienderFrame
local SaveGuiPositions
local function Connect(signal, callback)
    local c = signal:Connect(callback)
    table.insert(Connections, c)
    return c
end
local function Cleanup()
    if SaveGuiPositions then
        pcall(SaveGuiPositions)
    end
    for _, c in ipairs(Connections) do
        pcall(function()
            c:Disconnect()
        end)
    end
    Connections = {}
    if ClearSelectedBaseESP then
        pcall(ClearSelectedBaseESP)
    end
    if Gui then
        pcall(function()
            Gui:Destroy()
        end)
    end
end
Env.WuzzConvincerCleanup = Cleanup
local Parent = LP:WaitForChild("PlayerGui")
pcall(function()
    if gethui then
        Parent = gethui()
    end
end)
local Old = Parent:FindFirstChild("WuzzConvincer")
if Old then
    Old:Destroy()
end
Gui = Instance.new("ScreenGui")
Gui.Name = "WuzzConvincer"
Gui.ResetOnSpawn = false
Gui.IgnoreGuiInset = true
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Gui.Parent = Parent
local GuiPositionFile = "wuzz_gui_positions.json"
local SavedGuiPositions = {}
pcall(function()
    if isfile and readfile and isfile(GuiPositionFile) then
        local Data = HttpService:JSONDecode(readfile(GuiPositionFile))
        if type(Data) == "table" then
            SavedGuiPositions = Data
        end
    end
end)
local function SavedPosition(Key,Default)
    local Data = SavedGuiPositions[Key]
    if type(Data) == "table"
    and type(Data.XScale) == "number"
    and type(Data.XOffset) == "number"
    and type(Data.YScale) == "number"
    and type(Data.YOffset) == "number" then
        return UDim2.new(Data.XScale,Data.XOffset,Data.YScale,Data.YOffset)
    end
    return Default
end
local function PackPosition(Position)
    return {
        XScale = Position.X.Scale,
        XOffset = Position.X.Offset,
        YScale = Position.Y.Scale,
        YOffset = Position.Y.Offset
    }
end
local Main = Instance.new("Frame")
Main.Size = UDim2.fromOffset(365,500)
Main.Position = SavedPosition("Main",UDim2.new(1,-390,0.5,-250))
Main.BackgroundColor3 = Color3.fromRGB(10,7,17)
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
Main.Active = true
Main.Parent = Gui
SaveGuiPositions = function()
    SavedGuiPositions.Main = PackPosition(Main.Position)
    if BaseViewerFrame and BaseViewerFrame.Parent then
        SavedGuiPositions.BaseViewer = PackPosition(BaseViewerFrame.Position)
    end
    if AutoMessageFrame and AutoMessageFrame.Parent then
        SavedGuiPositions.AutoMessage = PackPosition(AutoMessageFrame.Position)
    end
    if AutoMessageEditor and AutoMessageEditor.Parent then
        SavedGuiPositions.AutoMessageText = tostring(AutoMessageEditor.Text or "")
    end
    if FrienderFrame and FrienderFrame.Parent then
        SavedGuiPositions.Friender = PackPosition(FrienderFrame.Position)
    end
    if writefile then
        pcall(function()
            writefile(GuiPositionFile,HttpService:JSONEncode(SavedGuiPositions))
        end)
    end
end
local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0,16)
MainCorner.Parent = Main
local MainStroke = Instance.new("UIStroke")
MainStroke.Thickness = 2
MainStroke.Color = Color3.fromRGB(180,70,255)
MainStroke.Parent = Main
local StrokeGradient = Instance.new("UIGradient")
StrokeGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0,Color3.fromRGB(90,25,190)),
    ColorSequenceKeypoint.new(0.25,Color3.fromRGB(220,100,255)),
    ColorSequenceKeypoint.new(0.5,Color3.fromRGB(125,40,245)),
    ColorSequenceKeypoint.new(0.75,Color3.fromRGB(230,120,255)),
    ColorSequenceKeypoint.new(1,Color3.fromRGB(90,25,190))
})
StrokeGradient.Parent = MainStroke
local BGGradient = Instance.new("UIGradient")
BGGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0,Color3.fromRGB(29,10,47)),
    ColorSequenceKeypoint.new(0.5,Color3.fromRGB(11,7,18)),
    ColorSequenceKeypoint.new(1,Color3.fromRGB(32,10,50))
})
BGGradient.Rotation = 32
BGGradient.Parent = Main
local Particles = Instance.new("Frame")
Particles.Size = UDim2.fromScale(1,1)
Particles.BackgroundTransparency = 1
Particles.ClipsDescendants = true
Particles.ZIndex = 1
Particles.Parent = Main
for i = 1,8 do
    local P = Instance.new("Frame")
    local S = math.random(2,4)
    P.Size = UDim2.fromOffset(S,S)
    P.Position = UDim2.new(math.random(),0,math.random(),0)
    P.BackgroundColor3 = Color3.fromRGB(
        math.random(145,205),
        math.random(45,95),
        255
    )
    P.BackgroundTransparency = 0.55
    P.BorderSizePixel = 0
    P.ZIndex = 1
    P.Parent = Particles
    local C = Instance.new("UICorner")
    C.CornerRadius = UDim.new(1,0)
    C.Parent = P
    task.spawn(function()
        while Gui and Gui.Parent and P.Parent do
            P.Position = UDim2.new(math.random(),0,1.05,0)
            P.BackgroundTransparency = 0.5
            local T = TweenService:Create(
                P,
                TweenInfo.new(
                    math.random(7,11),
                    Enum.EasingStyle.Linear
                ),
                {
                    Position = UDim2.new(math.random(),0,-0.05,0),
                    BackgroundTransparency = 1
                }
            )
            T:Play()
            T.Completed:Wait()
        end
    end)
end
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1,0,0,64)
Header.BackgroundTransparency = 1
Header.ZIndex = 5
Header.Parent = Main
local Logo = Instance.new("Frame")
Logo.Size = UDim2.fromOffset(40,40)
Logo.Position = UDim2.fromOffset(14,12)
Logo.BackgroundColor3 = Color3.fromRGB(78,29,126)
Logo.BorderSizePixel = 0
Logo.ZIndex = 6
Logo.Parent = Header
local LogoCorner = Instance.new("UICorner")
LogoCorner.CornerRadius = UDim.new(0,11)
LogoCorner.Parent = Logo
local LogoStroke = Instance.new("UIStroke")
LogoStroke.Color = Color3.fromRGB(195,90,255)
LogoStroke.Parent = Logo
local LogoText = Instance.new("TextLabel")
LogoText.Size = UDim2.fromScale(1,1)
LogoText.BackgroundTransparency = 1
LogoText.Text = "W"
LogoText.TextColor3 = Color3.fromRGB(240,195,255)
LogoText.Font = Enum.Font.GothamBlack
LogoText.TextSize = 20
LogoText.ZIndex = 7
LogoText.Parent = Logo
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1,-120,1,0)
Title.Position = UDim2.fromOffset(66,0)
Title.BackgroundTransparency = 1
Title.Text = "Wuzz Pub Method"
Title.TextColor3 = Color3.fromRGB(250,240,255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.ZIndex = 6
Title.Parent = Header
local Close = Instance.new("TextButton")
Close.Size = UDim2.fromOffset(34,34)
Close.Position = UDim2.new(1,-46,0,15)
Close.BackgroundColor3 = Color3.fromRGB(46,24,66)
Close.BorderSizePixel = 0
Close.Text = "×"
Close.TextColor3 = Color3.fromRGB(230,165,255)
Close.Font = Enum.Font.GothamBold
Close.TextSize = 21
Close.AutoButtonColor = false
Close.ZIndex = 7
Close.Parent = Header
local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0,9)
CloseCorner.Parent = Close
local CloseStroke = Instance.new("UIStroke")
CloseStroke.Color = Color3.fromRGB(125,55,185)
CloseStroke.Parent = Close
local List = Instance.new("ScrollingFrame")
List.Size = UDim2.new(1,-22,1,-76)
List.Position = UDim2.fromOffset(11,65)
List.BackgroundTransparency = 1
List.BorderSizePixel = 0
List.ScrollBarThickness = 3
List.ScrollBarImageColor3 = Color3.fromRGB(175,75,255)
List.AutomaticCanvasSize = Enum.AutomaticSize.Y
List.CanvasSize = UDim2.new()
List.ZIndex = 5
List.Parent = Main
local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0,8)
Layout.SortOrder = Enum.SortOrder.LayoutOrder
Layout.Parent = List

FrienderFrame = Instance.new("Frame")
FrienderFrame.Name = "WuzzFriender"
FrienderFrame.Size = UDim2.fromOffset(310,360)
FrienderFrame.Position = SavedPosition("Friender",UDim2.new(1,-1100,0.5,-180))
FrienderFrame.BackgroundColor3 = Color3.fromRGB(10,7,17)
FrienderFrame.BorderSizePixel = 0
FrienderFrame.ClipsDescendants = true
FrienderFrame.Active = true
FrienderFrame.ZIndex = 30
FrienderFrame.Parent = Gui

local FrienderCorner = Instance.new("UICorner")
FrienderCorner.CornerRadius = UDim.new(0,15)
FrienderCorner.Parent = FrienderFrame

local FrienderStroke = Instance.new("UIStroke")
FrienderStroke.Thickness = 2
FrienderStroke.Color = Color3.fromRGB(180,70,255)
FrienderStroke.Parent = FrienderFrame

local FrienderStrokeGradient = Instance.new("UIGradient")
FrienderStrokeGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0,Color3.fromRGB(90,25,190)),
    ColorSequenceKeypoint.new(0.25,Color3.fromRGB(220,100,255)),
    ColorSequenceKeypoint.new(0.5,Color3.fromRGB(125,40,245)),
    ColorSequenceKeypoint.new(0.75,Color3.fromRGB(230,120,255)),
    ColorSequenceKeypoint.new(1,Color3.fromRGB(90,25,190))
})
FrienderStrokeGradient.Parent = FrienderStroke

local FrienderBGGradient = Instance.new("UIGradient")
FrienderBGGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0,Color3.fromRGB(29,10,47)),
    ColorSequenceKeypoint.new(0.5,Color3.fromRGB(11,7,18)),
    ColorSequenceKeypoint.new(1,Color3.fromRGB(32,10,50))
})
FrienderBGGradient.Rotation = 32
FrienderBGGradient.Parent = FrienderFrame

local FrienderParticles = Instance.new("Frame")
FrienderParticles.Size = UDim2.fromScale(1,1)
FrienderParticles.BackgroundTransparency = 1
FrienderParticles.ClipsDescendants = true
FrienderParticles.ZIndex = 31
FrienderParticles.Parent = FrienderFrame

for i = 1,7 do
    local P = Instance.new("Frame")
    local S = math.random(2,4)
    P.Size = UDim2.fromOffset(S,S)
    P.Position = UDim2.new(math.random(),0,math.random(),0)
    P.BackgroundColor3 = Color3.fromRGB(math.random(145,205),math.random(45,95),255)
    P.BackgroundTransparency = 0.55
    P.BorderSizePixel = 0
    P.ZIndex = 31
    P.Parent = FrienderParticles
    local C = Instance.new("UICorner")
    C.CornerRadius = UDim.new(1,0)
    C.Parent = P
    task.spawn(function()
        while Gui and Gui.Parent and P.Parent do
            P.Position = UDim2.new(math.random(),0,1.05,0)
            P.BackgroundTransparency = 0.5
            local T = TweenService:Create(
                P,
                TweenInfo.new(math.random(6,10),Enum.EasingStyle.Linear),
                {
                    Position = UDim2.new(math.random(),0,-0.05,0),
                    BackgroundTransparency = 1
                }
            )
            T:Play()
            T.Completed:Wait()
        end
    end)
end

local FrienderHeader = Instance.new("Frame")
FrienderHeader.Size = UDim2.new(1,0,0,58)
FrienderHeader.BackgroundTransparency = 1
FrienderHeader.Active = true
FrienderHeader.ZIndex = 33
FrienderHeader.Parent = FrienderFrame

local FrienderLogo = Instance.new("Frame")
FrienderLogo.Size = UDim2.fromOffset(36,36)
FrienderLogo.Position = UDim2.fromOffset(12,11)
FrienderLogo.BackgroundColor3 = Color3.fromRGB(78,29,126)
FrienderLogo.BorderSizePixel = 0
FrienderLogo.ZIndex = 34
FrienderLogo.Parent = FrienderHeader

local FrienderLogoCorner = Instance.new("UICorner")
FrienderLogoCorner.CornerRadius = UDim.new(0,10)
FrienderLogoCorner.Parent = FrienderLogo

local FrienderLogoStroke = Instance.new("UIStroke")
FrienderLogoStroke.Color = Color3.fromRGB(195,90,255)
FrienderLogoStroke.Transparency = 0.1
FrienderLogoStroke.Parent = FrienderLogo

local FrienderLogoText = Instance.new("TextLabel")
FrienderLogoText.Size = UDim2.fromScale(1,1)
FrienderLogoText.BackgroundTransparency = 1
FrienderLogoText.Text = "W"
FrienderLogoText.TextColor3 = Color3.fromRGB(240,195,255)
FrienderLogoText.Font = Enum.Font.GothamBlack
FrienderLogoText.TextSize = 18
FrienderLogoText.ZIndex = 35
FrienderLogoText.Parent = FrienderLogo

local FrienderTitle = Instance.new("TextLabel")
FrienderTitle.Size = UDim2.new(1,-72,1,0)
FrienderTitle.Position = UDim2.fromOffset(60,0)
FrienderTitle.BackgroundTransparency = 1
FrienderTitle.Text = "Wuzz Friender"
FrienderTitle.TextColor3 = Color3.fromRGB(250,240,255)
FrienderTitle.Font = Enum.Font.GothamBold
FrienderTitle.TextSize = 17
FrienderTitle.TextXAlignment = Enum.TextXAlignment.Left
FrienderTitle.ZIndex = 34
FrienderTitle.Parent = FrienderHeader

local FrienderDivider = Instance.new("Frame")
FrienderDivider.Size = UDim2.new(1,-24,0,1)
FrienderDivider.Position = UDim2.fromOffset(12,57)
FrienderDivider.BackgroundColor3 = Color3.fromRGB(160,70,235)
FrienderDivider.BackgroundTransparency = 0.65
FrienderDivider.BorderSizePixel = 0
FrienderDivider.ZIndex = 33
FrienderDivider.Parent = FrienderFrame

local FrienderSearch = Instance.new("TextBox")
FrienderSearch.Name = "Search"
FrienderSearch.Size = UDim2.new(1,-18,0,34)
FrienderSearch.Position = UDim2.fromOffset(9,64)
FrienderSearch.BackgroundColor3 = Color3.fromRGB(21,12,31)
FrienderSearch.BackgroundTransparency = 0.04
FrienderSearch.BorderSizePixel = 0
FrienderSearch.ClearTextOnFocus = false
FrienderSearch.Text = ""
FrienderSearch.PlaceholderText = "Search display or @username..."
FrienderSearch.PlaceholderColor3 = Color3.fromRGB(135,116,151)
FrienderSearch.TextColor3 = Color3.fromRGB(246,235,255)
FrienderSearch.Font = Enum.Font.GothamMedium
FrienderSearch.TextSize = 11
FrienderSearch.TextXAlignment = Enum.TextXAlignment.Left
FrienderSearch.ZIndex = 34
FrienderSearch.Parent = FrienderFrame

local FrienderSearchCorner = Instance.new("UICorner")
FrienderSearchCorner.CornerRadius = UDim.new(0,10)
FrienderSearchCorner.Parent = FrienderSearch

local FrienderSearchStroke = Instance.new("UIStroke")
FrienderSearchStroke.Color = Color3.fromRGB(126,53,188)
FrienderSearchStroke.Transparency = 0.4
FrienderSearchStroke.Parent = FrienderSearch

local FrienderSearchPadding = Instance.new("UIPadding")
FrienderSearchPadding.PaddingLeft = UDim.new(0,11)
FrienderSearchPadding.PaddingRight = UDim.new(0,11)
FrienderSearchPadding.Parent = FrienderSearch

local FrienderList = Instance.new("ScrollingFrame")
FrienderList.Name = "Players"
FrienderList.Size = UDim2.new(1,-18,1,-112)
FrienderList.Position = UDim2.fromOffset(9,106)
FrienderList.BackgroundTransparency = 1
FrienderList.BorderSizePixel = 0
FrienderList.ScrollBarThickness = 3
FrienderList.ScrollBarImageColor3 = Color3.fromRGB(175,75,255)
FrienderList.AutomaticCanvasSize = Enum.AutomaticSize.Y
FrienderList.CanvasSize = UDim2.new()
FrienderList.ZIndex = 33
FrienderList.Parent = FrienderFrame

local FrienderPadding = Instance.new("UIPadding")
FrienderPadding.PaddingTop = UDim.new(0,2)
FrienderPadding.PaddingBottom = UDim.new(0,4)
FrienderPadding.PaddingLeft = UDim.new(0,2)
FrienderPadding.PaddingRight = UDim.new(0,4)
FrienderPadding.Parent = FrienderList

local FrienderLayout = Instance.new("UIListLayout")
FrienderLayout.Padding = UDim.new(0,7)
FrienderLayout.SortOrder = Enum.SortOrder.LayoutOrder
FrienderLayout.Parent = FrienderList

local FrienderRows = {}

local function NormalizeFrienderSearch(Text)
    return tostring(Text or "")
        :lower()
        :gsub("^%s+","")
        :gsub("%s+$","")
        :gsub("^@","")
end

local function FrienderMatchesSearch(Player)
    local Query = NormalizeFrienderSearch(FrienderSearch.Text)
    if Query == "" then
        return true
    end

    local Username = string.lower(tostring(Player.Name or ""))
    local DisplayName = string.lower(tostring(Player.DisplayName or ""))

    return string.find(Username,Query,1,true) ~= nil
        or string.find(DisplayName,Query,1,true) ~= nil
end

local function ApplyFrienderSearch()
    for Player,Row in pairs(FrienderRows) do
        if Row and Row.Parent then
            Row.Visible = FrienderMatchesSearch(Player)
        end
    end
end

Connect(FrienderSearch:GetPropertyChangedSignal("Text"),ApplyFrienderSearch)

Connect(FrienderSearch.Focused,function()
    TweenService:Create(
        FrienderSearchStroke,
        TweenInfo.new(0.12),
        {Transparency = 0.08}
    ):Play()
end)

Connect(FrienderSearch.FocusLost,function()
    TweenService:Create(
        FrienderSearchStroke,
        TweenInfo.new(0.12),
        {Transparency = 0.4}
    ):Play()
end)

local function FrienderIsFriend(Player)
    if Player == LP then
        return true
    end
    local Success,Result = pcall(function()
        return LP:IsFriendsWith(Player.UserId)
    end)
    return Success and Result
end

local function FrienderRequest(Player)
    if not Player or Player == LP then
        return false
    end
    local Success = pcall(function()
        StarterGui:SetCore("PromptSendFriendRequest",Player)
    end)
    if Success then
        return true
    end
    task.wait(0.35)
    return pcall(function()
        StarterGui:SetCore("PromptSendFriendRequest",Player)
    end)
end

local function CreateFrienderRow(Player)
    if FrienderRows[Player] then
        return
    end

    local Row = Instance.new("Frame")
    Row.Name = tostring(Player.UserId)
    Row.Size = UDim2.new(1,-3,0,55)
    Row.BackgroundColor3 = Color3.fromRGB(21,12,31)
    Row.BackgroundTransparency = 0.04
    Row.BorderSizePixel = 0
    Row.ZIndex = 34
    Row.Parent = FrienderList

    local RowCorner = Instance.new("UICorner")
    RowCorner.CornerRadius = UDim.new(0,11)
    RowCorner.Parent = Row

    local RowStroke = Instance.new("UIStroke")
    RowStroke.Color = Color3.fromRGB(126,53,188)
    RowStroke.Transparency = 0.5
    RowStroke.Parent = Row

    local RowGradient = Instance.new("UIGradient")
    RowGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0,Color3.fromRGB(31,17,44)),
        ColorSequenceKeypoint.new(1,Color3.fromRGB(18,11,27))
    })
    RowGradient.Rotation = 20
    RowGradient.Parent = Row

    local Avatar = Instance.new("ImageLabel")
    Avatar.Size = UDim2.fromOffset(39,39)
    Avatar.Position = UDim2.fromOffset(8,8)
    Avatar.BackgroundColor3 = Color3.fromRGB(39,24,55)
    Avatar.BorderSizePixel = 0
    Avatar.ScaleType = Enum.ScaleType.Crop
    Avatar.ZIndex = 35
    Avatar.Parent = Row

    local AvatarCorner = Instance.new("UICorner")
    AvatarCorner.CornerRadius = UDim.new(0,10)
    AvatarCorner.Parent = Avatar

    local AvatarStroke = Instance.new("UIStroke")
    AvatarStroke.Color = Color3.fromRGB(177,76,255)
    AvatarStroke.Transparency = 0.3
    AvatarStroke.Parent = Avatar

    task.spawn(function()
        local Success,Image = pcall(function()
            return Players:GetUserThumbnailAsync(
                Player.UserId,
                Enum.ThumbnailType.HeadShot,
                Enum.ThumbnailSize.Size150x150
            )
        end)
        if Success and Avatar.Parent then
            Avatar.Image = Image
        end
    end)

    local Display = Instance.new("TextLabel")
    Display.Size = UDim2.new(1,-137,0,19)
    Display.Position = UDim2.fromOffset(57,8)
    Display.BackgroundTransparency = 1
    Display.Text = Player.DisplayName
    Display.TextColor3 = Color3.fromRGB(250,240,255)
    Display.Font = Enum.Font.GothamBold
    Display.TextSize = 12
    Display.TextXAlignment = Enum.TextXAlignment.Left
    Display.TextTruncate = Enum.TextTruncate.AtEnd
    Display.ZIndex = 35
    Display.Parent = Row

    local Username = Instance.new("TextLabel")
    Username.Size = UDim2.new(1,-137,0,17)
    Username.Position = UDim2.fromOffset(57,28)
    Username.BackgroundTransparency = 1
    Username.Text = "@"..Player.Name
    Username.TextColor3 = Color3.fromRGB(163,145,179)
    Username.Font = Enum.Font.GothamMedium
    Username.TextSize = 9
    Username.TextXAlignment = Enum.TextXAlignment.Left
    Username.TextTruncate = Enum.TextTruncate.AtEnd
    Username.ZIndex = 35
    Username.Parent = Row

    local Add = Instance.new("TextButton")
    Add.AnchorPoint = Vector2.new(1,0.5)
    Add.Size = UDim2.fromOffset(58,29)
    Add.Position = UDim2.new(1,-9,0.5,0)
    Add.BackgroundColor3 = Color3.fromRGB(132,47,214)
    Add.BorderSizePixel = 0
    Add.Text = "Add"
    Add.TextColor3 = Color3.fromRGB(255,245,255)
    Add.Font = Enum.Font.GothamBold
    Add.TextSize = 10
    Add.AutoButtonColor = false
    Add.ZIndex = 35
    Add.Parent = Row

    local AddCorner = Instance.new("UICorner")
    AddCorner.CornerRadius = UDim.new(0,8)
    AddCorner.Parent = Add

    local AddStroke = Instance.new("UIStroke")
    AddStroke.Color = Color3.fromRGB(213,130,255)
    AddStroke.Transparency = 0.35
    AddStroke.Parent = Add

    local AddGradient = Instance.new("UIGradient")
    AddGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0,Color3.fromRGB(177,78,255)),
        ColorSequenceKeypoint.new(1,Color3.fromRGB(105,39,192))
    })
    AddGradient.Rotation = 45
    AddGradient.Parent = Add

    local function Refresh()
        if Player == LP then
            Add.Text = "You"
            Add.Active = false
            Add.BackgroundTransparency = 0.55
            Add.TextTransparency = 0.2
            return
        end
        if FrienderIsFriend(Player) then
            Add.Text = "Added"
            Add.Active = false
            Add.BackgroundTransparency = 0.45
            Add.TextTransparency = 0
            return
        end
        Add.Text = "Add"
        Add.Active = true
        Add.BackgroundTransparency = 0
        Add.TextTransparency = 0
    end

    Refresh()

    Connect(Add.MouseEnter,function()
        if not Add.Active then
            return
        end
        TweenService:Create(Add,TweenInfo.new(0.12),{Size = UDim2.fromOffset(61,31)}):Play()
        TweenService:Create(AddStroke,TweenInfo.new(0.12),{Transparency = 0.05}):Play()
    end)

    Connect(Add.MouseLeave,function()
        if not Add.Active then
            return
        end
        TweenService:Create(Add,TweenInfo.new(0.12),{Size = UDim2.fromOffset(58,29)}):Play()
        TweenService:Create(AddStroke,TweenInfo.new(0.12),{Transparency = 0.35}):Play()
    end)

    Connect(Add.MouseButton1Click,function()
        if Player == LP or FrienderIsFriend(Player) then
            Refresh()
            return
        end
        if FrienderRequest(Player) then
            Add.Text = "Sent"
        else
            Add.Text = "Retry"
        end
        task.delay(1.6,function()
            if Add.Parent then
                Refresh()
            end
        end)
    end)

    Connect(Row.MouseEnter,function()
        TweenService:Create(RowStroke,TweenInfo.new(0.12),{Transparency = 0.18}):Play()
    end)

    Connect(Row.MouseLeave,function()
        TweenService:Create(RowStroke,TweenInfo.new(0.12),{Transparency = 0.5}):Play()
    end)

    FrienderRows[Player] = Row
    Row.Visible = FrienderMatchesSearch(Player)
end

local function RemoveFrienderRow(Player)
    local Row = FrienderRows[Player]
    if not Row then
        return
    end
    FrienderRows[Player] = nil
    Row:Destroy()
end

local FrienderPlayers = Players:GetPlayers()
table.sort(FrienderPlayers,function(A,B)
    if A == LP then
        return true
    end
    if B == LP then
        return false
    end
    return string.lower(A.DisplayName) < string.lower(B.DisplayName)
end)

for Index,Player in ipairs(FrienderPlayers) do
    CreateFrienderRow(Player)
    local Row = FrienderRows[Player]
    if Row then
        Row.LayoutOrder = Player == LP and -1000 or Index
    end
end

Connect(Players.PlayerAdded,function(Player)
    CreateFrienderRow(Player)
    ApplyFrienderSearch()
end)

Connect(Players.PlayerRemoving,function(Player)
    RemoveFrienderRow(Player)
end)

local FrienderDragging = false
local FrienderDragStart
local FrienderStartPosition

Connect(FrienderHeader.InputBegan,function(Input)
    if Input.UserInputType == Enum.UserInputType.MouseButton1
    or Input.UserInputType == Enum.UserInputType.Touch then
        FrienderDragging = true
        FrienderDragStart = Input.Position
        FrienderStartPosition = FrienderFrame.Position
    end
end)

Connect(UserInputService.InputChanged,function(Input)
    if FrienderDragging and (
        Input.UserInputType == Enum.UserInputType.MouseMovement
        or Input.UserInputType == Enum.UserInputType.Touch
    ) then
        local Delta = Input.Position - FrienderDragStart
        FrienderFrame.Position = UDim2.new(
            FrienderStartPosition.X.Scale,
            FrienderStartPosition.X.Offset + Delta.X,
            FrienderStartPosition.Y.Scale,
            FrienderStartPosition.Y.Offset + Delta.Y
        )
    end
end)

Connect(UserInputService.InputEnded,function(Input)
    if Input.UserInputType == Enum.UserInputType.MouseButton1
    or Input.UserInputType == Enum.UserInputType.Touch then
        if FrienderDragging then
            FrienderDragging = false
            if SaveGuiPositions then
                pcall(SaveGuiPositions)
            end
        end
    end
end)

task.spawn(function()
    while Gui and Gui.Parent and FrienderFrame.Parent do
        FrienderStrokeGradient.Rotation = (FrienderStrokeGradient.Rotation + 3) % 360
        local Pulse = (math.sin(os.clock() * 2.8) + 1) * 0.5
        FrienderStroke.Transparency = 0.02 + Pulse * 0.18
        FrienderLogoStroke.Transparency = 0.08 + Pulse * 0.32
        task.wait(0.06)
    end
end)
local MESSAGE_DELAY = 5
local AutoMessageEnabled = false
local AutoMessageGeneration = 0
local DefaultAutoMessageText = [[yo can you help me with something in my game
i need another person for a few things
the more you help me with the better brainrot ill give you after
you dont have to bring anything or give me anything
just join me and ill show you what i need help with
if you stay and help with everything ill give you one of my better brainrots
join when youre ready or i can invite you
add me if you want to]]

AutoMessageFrame = Instance.new("Frame")
AutoMessageFrame.Name = "AutoMessageWindow"
AutoMessageFrame.Size = UDim2.fromOffset(365,250)
AutoMessageFrame.Position = SavedPosition(
    "AutoMessage",
    UDim2.new(1,-770,0.5,-125)
)
AutoMessageFrame.BackgroundColor3 = Color3.fromRGB(10,7,17)
AutoMessageFrame.BorderSizePixel = 0
AutoMessageFrame.ClipsDescendants = true
AutoMessageFrame.Active = true
AutoMessageFrame.ZIndex = 20
AutoMessageFrame.Parent = Gui

local AutoMessageFrameCorner = Instance.new("UICorner")
AutoMessageFrameCorner.CornerRadius = UDim.new(0,16)
AutoMessageFrameCorner.Parent = AutoMessageFrame

local AutoMessageFrameStroke = Instance.new("UIStroke")
AutoMessageFrameStroke.Thickness = 2
AutoMessageFrameStroke.Color = Color3.fromRGB(180,70,255)
AutoMessageFrameStroke.Parent = AutoMessageFrame

local AutoMessageStrokeGradient = Instance.new("UIGradient")
AutoMessageStrokeGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0,Color3.fromRGB(90,25,190)),
    ColorSequenceKeypoint.new(0.25,Color3.fromRGB(220,100,255)),
    ColorSequenceKeypoint.new(0.5,Color3.fromRGB(125,40,245)),
    ColorSequenceKeypoint.new(0.75,Color3.fromRGB(230,120,255)),
    ColorSequenceKeypoint.new(1,Color3.fromRGB(90,25,190))
})
AutoMessageStrokeGradient.Parent = AutoMessageFrameStroke

local AutoMessageBGGradient = Instance.new("UIGradient")
AutoMessageBGGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0,Color3.fromRGB(29,10,47)),
    ColorSequenceKeypoint.new(0.5,Color3.fromRGB(11,7,18)),
    ColorSequenceKeypoint.new(1,Color3.fromRGB(32,10,50))
})
AutoMessageBGGradient.Rotation = 32
AutoMessageBGGradient.Parent = AutoMessageFrame

local AutoMessageHeader = Instance.new("Frame")
AutoMessageHeader.Name = "Header"
AutoMessageHeader.Size = UDim2.new(1,0,0,58)
AutoMessageHeader.BackgroundTransparency = 1
AutoMessageHeader.Active = true
AutoMessageHeader.ZIndex = 23
AutoMessageHeader.Parent = AutoMessageFrame

local AutoMessageLogo = Instance.new("Frame")
AutoMessageLogo.Size = UDim2.fromOffset(36,36)
AutoMessageLogo.Position = UDim2.fromOffset(12,11)
AutoMessageLogo.BackgroundColor3 = Color3.fromRGB(78,29,126)
AutoMessageLogo.BorderSizePixel = 0
AutoMessageLogo.ZIndex = 24
AutoMessageLogo.Parent = AutoMessageHeader

local AutoMessageLogoCorner = Instance.new("UICorner")
AutoMessageLogoCorner.CornerRadius = UDim.new(0,10)
AutoMessageLogoCorner.Parent = AutoMessageLogo

local AutoMessageLogoStroke = Instance.new("UIStroke")
AutoMessageLogoStroke.Color = Color3.fromRGB(195,90,255)
AutoMessageLogoStroke.Parent = AutoMessageLogo

local AutoMessageLogoText = Instance.new("TextLabel")
AutoMessageLogoText.Size = UDim2.fromScale(1,1)
AutoMessageLogoText.BackgroundTransparency = 1
AutoMessageLogoText.Text = "W"
AutoMessageLogoText.TextColor3 = Color3.fromRGB(240,195,255)
AutoMessageLogoText.Font = Enum.Font.GothamBlack
AutoMessageLogoText.TextSize = 18
AutoMessageLogoText.ZIndex = 25
AutoMessageLogoText.Parent = AutoMessageLogo

local AutoMessageTitle = Instance.new("TextLabel")
AutoMessageTitle.Size = UDim2.new(1,-168,1,0)
AutoMessageTitle.Position = UDim2.fromOffset(60,0)
AutoMessageTitle.BackgroundTransparency = 1
AutoMessageTitle.Text = "Auto Message"
AutoMessageTitle.TextColor3 = Color3.fromRGB(250,240,255)
AutoMessageTitle.Font = Enum.Font.GothamBold
AutoMessageTitle.TextSize = 17
AutoMessageTitle.TextXAlignment = Enum.TextXAlignment.Left
AutoMessageTitle.ZIndex = 24
AutoMessageTitle.Parent = AutoMessageHeader

local AutoMessageToggle = Instance.new("TextButton")
AutoMessageToggle.Name = "Toggle"
AutoMessageToggle.Size = UDim2.fromOffset(82,32)
AutoMessageToggle.Position = UDim2.new(1,-94,0,13)
AutoMessageToggle.BackgroundColor3 = Color3.fromRGB(108,42,172)
AutoMessageToggle.BorderSizePixel = 0
AutoMessageToggle.Text = "OFF"
AutoMessageToggle.TextColor3 = Color3.fromRGB(255,245,255)
AutoMessageToggle.Font = Enum.Font.GothamBold
AutoMessageToggle.TextSize = 11
AutoMessageToggle.AutoButtonColor = false
AutoMessageToggle.ZIndex = 25
AutoMessageToggle.Parent = AutoMessageHeader

local AutoMessageToggleCorner = Instance.new("UICorner")
AutoMessageToggleCorner.CornerRadius = UDim.new(0,9)
AutoMessageToggleCorner.Parent = AutoMessageToggle

local AutoMessageToggleStroke = Instance.new("UIStroke")
AutoMessageToggleStroke.Color = Color3.fromRGB(200,100,255)
AutoMessageToggleStroke.Transparency = 0.15
AutoMessageToggleStroke.Parent = AutoMessageToggle

AutoMessageEditor = Instance.new("TextBox")
AutoMessageEditor.Name = "AutoMessages"
AutoMessageEditor.Size = UDim2.new(1,-24,1,-72)
AutoMessageEditor.Position = UDim2.fromOffset(12,60)
AutoMessageEditor.BackgroundColor3 = Color3.fromRGB(21,12,31)
AutoMessageEditor.BorderSizePixel = 0
AutoMessageEditor.ClearTextOnFocus = false
AutoMessageEditor.MultiLine = true
AutoMessageEditor.TextWrapped = true
AutoMessageEditor.TextXAlignment = Enum.TextXAlignment.Left
AutoMessageEditor.TextYAlignment = Enum.TextYAlignment.Top
AutoMessageEditor.TextColor3 = Color3.fromRGB(246,235,255)
AutoMessageEditor.PlaceholderText = ""
AutoMessageEditor.Font = Enum.Font.Gotham
AutoMessageEditor.TextSize = 11
AutoMessageEditor.ZIndex = 23
AutoMessageEditor.Text = type(SavedGuiPositions.AutoMessageText) == "string"
    and SavedGuiPositions.AutoMessageText
    or DefaultAutoMessageText
AutoMessageEditor.Parent = AutoMessageFrame

local AutoMessageEditorCorner = Instance.new("UICorner")
AutoMessageEditorCorner.CornerRadius = UDim.new(0,10)
AutoMessageEditorCorner.Parent = AutoMessageEditor

local AutoMessageEditorStroke = Instance.new("UIStroke")
AutoMessageEditorStroke.Color = Color3.fromRGB(125,52,188)
AutoMessageEditorStroke.Transparency = 0.25
AutoMessageEditorStroke.Parent = AutoMessageEditor

local AutoMessageEditorPadding = Instance.new("UIPadding")
AutoMessageEditorPadding.PaddingLeft = UDim.new(0,10)
AutoMessageEditorPadding.PaddingRight = UDim.new(0,10)
AutoMessageEditorPadding.PaddingTop = UDim.new(0,9)
AutoMessageEditorPadding.PaddingBottom = UDim.new(0,9)
AutoMessageEditorPadding.Parent = AutoMessageEditor

local function GetAutoMessages()
    local Result = {}
    local Text = tostring(AutoMessageEditor.Text or ""):gsub("\r","")
    for Line in (Text.."\n"):gmatch("(.-)\n") do
        Line = Line:gsub("^%s+",""):gsub("%s+$","")
        if Line ~= "" then
            table.insert(Result,Line)
        end
    end
    return Result
end

local function GetTradeChatBox()
    local Success,TextBox = pcall(function()
        return game:GetService("Players").LocalPlayer.PlayerGui.TradeLiveTrade.TradeLiveTrade.Chat.NormalChat.ChatBox.TextBox
    end)
    if Success and TextBox and TextBox:IsA("TextBox") then
        return TextBox
    end
    return nil
end

local function WaitForTradeChatBoxFocus(Generation)
    while AutoMessageEnabled
    and Generation == AutoMessageGeneration
    and Gui
    and Gui.Parent do
        local TextBox = GetTradeChatBox()
        if TextBox
        and TextBox.Parent
        and TextBox:IsFocused() then
            return TextBox
        end
        task.wait(0.03)
    end
    return nil
end

local function PressEnter()
    if typeof(keypress) == "function" and typeof(keyrelease) == "function" then
        local Success = pcall(function()
            keypress(0x0D)
            task.wait(0.03)
            keyrelease(0x0D)
        end)
        if Success then
            return true
        end
    end
    return pcall(function()
        local VirtualInputManager = game:GetService("VirtualInputManager")
        VirtualInputManager:SendKeyEvent(true,Enum.KeyCode.Return,false,game)
        task.wait(0.03)
        VirtualInputManager:SendKeyEvent(false,Enum.KeyCode.Return,false,game)
    end)
end

local function SendAutoMessage(Message,Generation)
    local TextBox = WaitForTradeChatBoxFocus(Generation)
    if not TextBox then
        return false
    end
    pcall(function()
        TextBox.Text = tostring(Message or "")
    end)
    task.wait(0.08)
    local Sent = PressEnter()
    task.wait(0.05)
    pcall(function()
        TextBox:ReleaseFocus()
    end)
    return Sent
end

local function SetAutoMessageEnabled(State)
    AutoMessageEnabled = State
    if State then
        AutoMessageToggle.BackgroundColor3 = Color3.fromRGB(52,145,82)
        AutoMessageToggleStroke.Color = Color3.fromRGB(105,255,150)
        AutoMessageToggle.Text = "ON"
    else
        AutoMessageToggle.BackgroundColor3 = Color3.fromRGB(108,42,172)
        AutoMessageToggleStroke.Color = Color3.fromRGB(200,100,255)
        AutoMessageToggle.Text = "OFF"
    end
end

local function WaitAutoMessageDelay(Generation)
    local Until = os.clock() + MESSAGE_DELAY
    while AutoMessageEnabled
    and Generation == AutoMessageGeneration
    and Gui
    and Gui.Parent
    and os.clock() < Until do
        task.wait(math.min(0.05,math.max(0,Until-os.clock())))
    end
    return AutoMessageEnabled
        and Generation == AutoMessageGeneration
        and Gui
        and Gui.Parent
end

local function RunAutoMessageWorker(Generation)
    local Messages = GetAutoMessages()
    if #Messages == 0 then
        SetAutoMessageEnabled(false)
        return
    end
    for _,Message in ipairs(Messages) do
        if not WaitAutoMessageDelay(Generation) then
            return
        end
        local Sent = false
        while AutoMessageEnabled
        and Generation == AutoMessageGeneration
        and Gui
        and Gui.Parent
        and not Sent do
            Sent = SendAutoMessage(Message,Generation)
            if not Sent then
                task.wait(0.1)
            end
        end
        if not AutoMessageEnabled or Generation ~= AutoMessageGeneration then
            return
        end
    end
    if AutoMessageEnabled and Generation == AutoMessageGeneration then
        SetAutoMessageEnabled(false)
    end
end

local AutoMessageToggleDebounce = false
local function ToggleAutoMessage()
    if AutoMessageToggleDebounce then
        return
    end
    AutoMessageToggleDebounce = true
    task.delay(0.12,function()
        AutoMessageToggleDebounce = false
    end)
    AutoMessageGeneration += 1
    if AutoMessageEnabled then
        SetAutoMessageEnabled(false)
        return
    end
    if #GetAutoMessages() == 0 then
        SetAutoMessageEnabled(false)
        return
    end
    local Generation = AutoMessageGeneration
    SetAutoMessageEnabled(true)
    task.spawn(function()
        RunAutoMessageWorker(Generation)
    end)
end

Connect(AutoMessageToggle.Activated,ToggleAutoMessage)

local AutoMessageSaveGeneration = 0
Connect(AutoMessageEditor:GetPropertyChangedSignal("Text"),function()
    AutoMessageSaveGeneration += 1
    local Generation = AutoMessageSaveGeneration
    task.delay(0.35,function()
        if Generation == AutoMessageSaveGeneration and SaveGuiPositions then
            pcall(SaveGuiPositions)
        end
    end)
end)

local AutoMessageDragging = false
local AutoMessageDragStart
local AutoMessageStartPosition
Connect(AutoMessageHeader.InputBegan,function(Input)
    if Input.UserInputType == Enum.UserInputType.MouseButton1
    or Input.UserInputType == Enum.UserInputType.Touch then
        AutoMessageDragging = true
        AutoMessageDragStart = Input.Position
        AutoMessageStartPosition = AutoMessageFrame.Position
    end
end)
Connect(UserInputService.InputChanged,function(Input)
    if AutoMessageDragging and (
        Input.UserInputType == Enum.UserInputType.MouseMovement
        or Input.UserInputType == Enum.UserInputType.Touch
    ) then
        local Delta = Input.Position - AutoMessageDragStart
        AutoMessageFrame.Position = UDim2.new(
            AutoMessageStartPosition.X.Scale,
            AutoMessageStartPosition.X.Offset + Delta.X,
            AutoMessageStartPosition.Y.Scale,
            AutoMessageStartPosition.Y.Offset + Delta.Y
        )
    end
end)
Connect(UserInputService.InputEnded,function(Input)
    if Input.UserInputType == Enum.UserInputType.MouseButton1
    or Input.UserInputType == Enum.UserInputType.Touch then
        if AutoMessageDragging then
            AutoMessageDragging = false
            if SaveGuiPositions then
                pcall(SaveGuiPositions)
            end
        end
    end
end)
local Dragging = false
local DragStart
local StartPosition
Connect(Header.InputBegan,function(Input)
    if Input.UserInputType == Enum.UserInputType.MouseButton1
    or Input.UserInputType == Enum.UserInputType.Touch then
        Dragging = true
        DragStart = Input.Position
        StartPosition = Main.Position
    end
end)
Connect(UserInputService.InputChanged,function(Input)
    if Dragging and (
        Input.UserInputType == Enum.UserInputType.MouseMovement
        or Input.UserInputType == Enum.UserInputType.Touch
    ) then
        local Delta = Input.Position - DragStart
        Main.Position = UDim2.new(
            StartPosition.X.Scale,
            StartPosition.X.Offset + Delta.X,
            StartPosition.Y.Scale,
            StartPosition.Y.Offset + Delta.Y
        )
    end
end)
Connect(UserInputService.InputEnded,function(Input)
    if Input.UserInputType == Enum.UserInputType.MouseButton1
    or Input.UserInputType == Enum.UserInputType.Touch then
        if Dragging then
            Dragging = false
            if SaveGuiPositions then
                pcall(SaveGuiPositions)
            end
        end
    end
end)
local function Normalize(Text)
    return tostring(Text or "")
        :lower()
        :gsub("^@","")
        :gsub("%s+","")
end
local function GetPlots()
    return Workspace:FindFirstChild("Plots")
        or Workspace:FindFirstChild("plots")
end
local function TextMatchesPlayer(Text,Player)
    local T = Normalize(Text)
    local Username = Normalize(Player.Name)
    local Display = Normalize(Player.DisplayName)
    if T == Username or T == Display then
        return true
    end
    if string.find(T,Username,1,true) then
        return true
    end
    if #Display > 2
    and string.find(T,Display,1,true) then
        return true
    end
    return false
end
local function GetSignLabel(Plot)
    local BaseAssets = Plot:FindFirstChild("BaseAssets")
    if not BaseAssets then
        return nil
    end
    local PlotSign = BaseAssets:FindFirstChild("PlotSign")
    if not PlotSign then
        return nil
    end
    local Model = PlotSign:FindFirstChild("Model")
    if Model then
        local SurfaceGui =
            Model:FindFirstChild("SurfaceGui")
            or Model:FindFirstChildWhichIsA("SurfaceGui",true)
        if SurfaceGui then
            local Frame = SurfaceGui:FindFirstChild("Frame")
            if Frame then
                local Label =
                    Frame:FindFirstChildWhichIsA(
                        "TextLabel",
                        true
                    )
                if Label then
                    return Label
                end
            end
            local Label =
                SurfaceGui:FindFirstChildWhichIsA(
                    "TextLabel",
                    true
                )
            if Label then
                return Label
            end
        end
    end
    for _,V in ipairs(PlotSign:GetDescendants()) do
        if V:IsA("TextLabel") then
            return V
        end
    end
    return nil
end
local function FindPlotPart(Plot)
    local BaseAssets = Plot:FindFirstChild("BaseAssets")
    if not BaseAssets then
        return nil
    end
    local PlotSign = BaseAssets:FindFirstChild("PlotSign")
    if PlotSign then
        if PlotSign:IsA("BasePart") then
            return PlotSign
        end
        if PlotSign:IsA("Model") then
            if PlotSign.PrimaryPart then
                return PlotSign.PrimaryPart
            end
            local P =
                PlotSign:FindFirstChildWhichIsA(
                    "BasePart",
                    true
                )
            if P then
                return P
            end
        end
        local P =
            PlotSign:FindFirstChildWhichIsA(
                "BasePart",
                true
            )
        if P then
            return P
        end
    end
    if BaseAssets:IsA("Model")
    and BaseAssets.PrimaryPart then
        return BaseAssets.PrimaryPart
    end
    return BaseAssets:FindFirstChildWhichIsA(
        "BasePart",
        true
    )
end
local function FindPlayerPlot(Player)
    local Plots = GetPlots()
    if not Plots or not Player then
        return nil,nil
    end
    local Username = tostring(Player.Name):lower()
    local DisplayName = tostring(Player.DisplayName):lower()
    local UserId = tonumber(Player.UserId)
    local function MatchesOwnerValue(Value)
        if typeof(Value) == "Instance" and Value:IsA("Player") then
            return Value == Player or Value.UserId == Player.UserId
        end
        if type(Value) == "number" then
            return UserId and tonumber(Value) == UserId
        end
        local Text = tostring(Value or ""):lower()
        if Text == Username or Text == DisplayName then
            return true
        end
        local Numeric = tonumber(Text)
        return Numeric and UserId and Numeric == UserId or false
    end
    local OwnerAttributeNames = {
        "Owner",
        "OwnerName",
        "OwnerUserId",
        "OwnerId",
        "Player",
        "PlayerName",
        "PlayerUserId",
        "UserId",
        "Username",
        "DisplayName"
    }
    for _,Plot in ipairs(Plots:GetChildren()) do
        for _,AttributeName in ipairs(OwnerAttributeNames) do
            local Value = Plot:GetAttribute(AttributeName)
            if Value ~= nil and MatchesOwnerValue(Value) then
                return Plot,FindPlotPart(Plot)
            end
        end
        for _,Child in ipairs(Plot:GetChildren()) do
            if Child:IsA("StringValue")
            or Child:IsA("IntValue")
            or Child:IsA("NumberValue")
            or Child:IsA("ObjectValue") then
                local Key = Child.Name:lower()
                if Key:find("owner",1,true)
                or Key:find("player",1,true)
                or Key == "userid"
                or Key == "username" then
                    local Value = Child.Value
                    if MatchesOwnerValue(Value) then
                        return Plot,FindPlotPart(Plot)
                    end
                end
            end
        end
    end
    for _,Plot in ipairs(Plots:GetChildren()) do
        local BaseAssets = Plot:FindFirstChild("BaseAssets")
        if BaseAssets then
            local Label = GetSignLabel(Plot)
            if Label and TextMatchesPlayer(Label.Text,Player) then
                return Plot,FindPlotPart(Plot)
            end
        end
    end
    for _,Plot in ipairs(Plots:GetChildren()) do
        local BaseAssets = Plot:FindFirstChild("BaseAssets")
        if BaseAssets then
            local PlotSign = BaseAssets:FindFirstChild("PlotSign")
            if PlotSign then
                for _,V in ipairs(PlotSign:GetDescendants()) do
                    if V:IsA("TextLabel")
                    and TextMatchesPlayer(V.Text,Player) then
                        return Plot,FindPlotPart(Plot)
                    end
                end
            end
        end
    end
    return nil,nil
end
local SelectedTradePlayer = nil
local SelectedTradePlayersUntil = {}
local SelectedBaseData = nil
local PlotBaseESPs = {}
local FetchedListPlayers = {}
local BaseAvatarCache = {}
local BasePlayerByUsername = {}
local BasePlayersByDisplay = {}
local BaseListLoaded = false
local function CleanBaseText(Text)
    return tostring(Text or "")
        :gsub("<.->","")
        :gsub("^%s+","")
        :gsub("%s+$","")
end
local function NormalizeBaseKey(Text)
    return CleanBaseText(Text)
        :gsub("’","'")
        :gsub("‘","'")
        :gsub("´","'")
        :lower()
        :gsub("^@","")
        :gsub("%s+","")
end
local function ExtractBaseOwnerKey(Text)
    local Clean = CleanBaseText(Text)
    local Lower = Clean:lower()
    if Clean == ""
    or string.find(Lower,"empty base",1,true) then
        return nil
    end
    local Key = NormalizeBaseKey(Clean)
    Key = Key:gsub("'sbase$","")
    Key = Key:gsub("'sbase[:%-_]*$","")
    if Key == ""
    or Key == "emptybase" then
        return nil
    end
    return Key
end
local function RebuildBasePlayerMaps()
    BasePlayerByUsername = {}
    BasePlayersByDisplay = {}
    local Added = {}
    local Source = {}
    if #FetchedListPlayers > 0 then
        for _,Player in ipairs(FetchedListPlayers) do
            table.insert(Source,Player)
        end
    else
        for _,Player in ipairs(Players:GetPlayers()) do
            if Player ~= LP then
                table.insert(Source,Player)
            end
        end
    end
    for _,Player in ipairs(Source) do
        if Player
        and Player ~= LP
        and Player.Parent == Players
        and not Added[Player.UserId] then
            Added[Player.UserId] = true
            local Username = NormalizeBaseKey(Player.Name)
            local Display = NormalizeBaseKey(Player.DisplayName)
            if Username ~= "" then
                BasePlayerByUsername[Username] = Player
            end
            if Display ~= "" then
                local Bucket = BasePlayersByDisplay[Display]
                if not Bucket then
                    Bucket = {}
                    BasePlayersByDisplay[Display] = Bucket
                end
                table.insert(Bucket,Player)
            end
        end
    end
    BaseListLoaded = true
end
local function SetFetchedBasePlayers(List)
    FetchedListPlayers = {}
    local Seen = {}
    for _,Player in ipairs(List or {}) do
        if Player
        and Player ~= LP
        and Player.Parent == Players
        and not Seen[Player.UserId] then
            Seen[Player.UserId] = true
            table.insert(FetchedListPlayers,Player)
        end
    end
    RebuildBasePlayerMaps()
end
local function RefreshBasePlayerList()
    local Cleaned = {}
    local Seen = {}
    for _,Player in ipairs(FetchedListPlayers) do
        if Player
        and Player ~= LP
        and Player.Parent == Players
        and not Seen[Player.UserId] then
            Seen[Player.UserId] = true
            table.insert(Cleaned,Player)
        end
    end
    FetchedListPlayers = Cleaned
    RebuildBasePlayerMaps()
end
local function MatchBaseTextToListPlayer(Text)
    local Owner = ExtractBaseOwnerKey(Text)
    if not Owner then
        return nil
    end
    local UsernameMatch = BasePlayerByUsername[Owner]
    if UsernameMatch
    and UsernameMatch.Parent == Players then
        return UsernameMatch
    end
    local DisplayMatches = BasePlayersByDisplay[Owner]
    if DisplayMatches then
        for _,Player in ipairs(DisplayMatches) do
            if Player
            and Player.Parent == Players
            and NormalizeBaseKey(Player.DisplayName) == Owner then
                return Player
            end
        end
    end
    return nil
end
local function GetBaseSurfaceLabel(PlotSign)
    local Best = nil
    for _,Object in ipairs(PlotSign:GetDescendants()) do
        if Object:IsA("SurfaceGui") then
            local Frame = Object:FindFirstChild("Frame")
            if Frame then
                for _,Label in ipairs(Frame:GetDescendants()) do
                    if Label:IsA("TextLabel") then
                        local T = CleanBaseText(Label.Text)
                        if T ~= "" then
                            if string.find(T:lower(),"base",1,true) then
                                return Label
                            end
                            Best = Best or Label
                        end
                    end
                end
            end
            for _,Label in ipairs(Object:GetDescendants()) do
                if Label:IsA("TextLabel") then
                    local T = CleanBaseText(Label.Text)
                    if T ~= "" then
                        if string.find(T:lower(),"base",1,true) then
                            return Label
                        end
                        Best = Best or Label
                    end
                end
            end
        end
    end
    if Best then
        return Best
    end
    for _,Object in ipairs(PlotSign:GetDescendants()) do
        if Object:IsA("TextLabel") then
            local T = CleanBaseText(Object.Text)
            if T ~= "" then
                if string.find(T:lower(),"base",1,true) then
                    return Object
                end
                Best = Best or Object
            end
        end
    end
    return Best
end
local function GetObjectBounds(Object)
    if Object:IsA("Model") then
        return Object:GetBoundingBox()
    end
    if Object:IsA("BasePart") then
        return Object.CFrame,Object.Size
    end
    local Min = Vector3.new(math.huge,math.huge,math.huge)
    local Max = Vector3.new(-math.huge,-math.huge,-math.huge)
    local Found = false
    for _,Part in ipairs(Object:GetDescendants()) do
        if Part:IsA("BasePart") then
            Found = true
            local Half = Part.Size * 0.5
            for X = -1,1,2 do
                for Y = -1,1,2 do
                    for Z = -1,1,2 do
                        local Point = Part.CFrame:PointToWorldSpace(
                            Vector3.new(
                                Half.X * X,
                                Half.Y * Y,
                                Half.Z * Z
                            )
                        )
                        Min = Vector3.new(
                            math.min(Min.X,Point.X),
                            math.min(Min.Y,Point.Y),
                            math.min(Min.Z,Point.Z)
                        )
                        Max = Vector3.new(
                            math.max(Max.X,Point.X),
                            math.max(Max.Y,Point.Y),
                            math.max(Max.Z,Point.Z)
                        )
                    end
                end
            end
        end
    end
    if not Found then
        return nil,nil
    end
    local Center = (Min + Max) * 0.5
    return CFrame.new(Center),Max - Min
end
local function ClearSelectedOverlay()
    local Data = SelectedBaseData
    SelectedBaseData = nil
    if not Data then
        return
    end
    if Data.Highlight then
        pcall(function()
            Data.Highlight:Destroy()
        end)
    end
end
local function RemovePlotBaseESP(PlotSign)
    local Data = PlotBaseESPs[PlotSign]
    if not Data then
        return
    end
    PlotBaseESPs[PlotSign] = nil
    for _,Object in ipairs({
        Data.Highlight,
        Data.Anchor,
        Data.Billboard
    }) do
        if Object then
            pcall(function()
                Object:Destroy()
            end)
        end
    end
end
ClearSelectedBaseESP = function()
    ClearSelectedOverlay()
    local Remove = {}
    for PlotSign in pairs(PlotBaseESPs) do
        table.insert(Remove,PlotSign)
    end
    for _,PlotSign in ipairs(Remove) do
        RemovePlotBaseESP(PlotSign)
    end
end
local function GetPlotForLabeledSign(PlotSign)
    if not PlotSign or not PlotSign.Parent then
        return nil
    end
    local Plots = GetPlots()
    if not Plots then
        return nil
    end
    local Plot = PlotSign
    while Plot and Plot.Parent and Plot.Parent ~= Plots do
        Plot = Plot.Parent
    end
    if Plot and Plot.Parent == Plots then
        return Plot
    end
    return nil
end
local function CreatePlotBaseESP(PlotSign,SourceLabel,MatchedPlayer)
    local BoundsCF,BoundsSize = GetObjectBounds(PlotSign)
    if not BoundsCF or not BoundsSize then
        return nil
    end
    local Anchor = Instance.new("Part")
    Anchor.Name = "PlotSignESPAnchor"
    Anchor.Size = Vector3.new(0.1,0.1,0.1)
    Anchor.Transparency = 1
    Anchor.Anchored = true
    Anchor.CanCollide = false
    Anchor.CanQuery = false
    Anchor.CanTouch = false
    Anchor.CFrame = CFrame.new(
        BoundsCF.Position.X,
        BoundsCF.Position.Y + BoundsSize.Y / 2 + 4,
        BoundsCF.Position.Z
    )
    Anchor.Parent = Workspace
    local Billboard = Instance.new("BillboardGui")
    Billboard.Name = "PlotSignBillboard"
    Billboard.Adornee = Anchor
    Billboard.Size = UDim2.fromOffset(500,230)
    Billboard.AlwaysOnTop = true
    Billboard.LightInfluence = 0
    Billboard.MaxDistance = 10000
    Billboard.StudsOffsetWorldSpace = Vector3.new(0,3,0)
    Billboard.Parent = LP:WaitForChild("PlayerGui")
    local Avatar = Instance.new("ImageLabel")
    Avatar.Name = "Avatar"
    Avatar.Size = UDim2.fromOffset(120,120)
    Avatar.AnchorPoint = Vector2.new(0.5,0)
    Avatar.Position = UDim2.new(0.5,0,0,0)
    Avatar.BackgroundTransparency = 1
    Avatar.BorderSizePixel = 0
    Avatar.ScaleType = Enum.ScaleType.Crop
    Avatar.Parent = Billboard
    local AvatarCorner = Instance.new("UICorner")
    AvatarCorner.CornerRadius = UDim.new(1,0)
    AvatarCorner.Parent = Avatar
    local AvatarStroke = Instance.new("UIStroke")
    AvatarStroke.Thickness = 4
    AvatarStroke.Color = Color3.fromRGB(185,80,255)
    AvatarStroke.Transparency = 0.05
    AvatarStroke.Parent = Avatar
    local Text = Instance.new("TextLabel")
    Text.Name = "BaseText"
    Text.Size = UDim2.new(1,0,0,90)
    Text.AnchorPoint = Vector2.new(0.5,0)
    Text.Position = UDim2.new(0.5,0,0,130)
    Text.BackgroundTransparency = 1
    Text.Text = MatchedPlayer.Name
    Text.TextColor3 = Color3.fromRGB(255,255,255)
    Text.TextStrokeColor3 = Color3.fromRGB(0,0,0)
    Text.TextStrokeTransparency = 0
    Text.Font = Enum.Font.GothamBlack
    Text.TextSize = 38
    Text.TextXAlignment = Enum.TextXAlignment.Center
    Text.TextYAlignment = Enum.TextYAlignment.Center
    Text.Parent = Billboard
    local Gradient = Instance.new("UIGradient")
    Gradient.Name = "PurpleGradient"
    Gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(
            0,
            Color3.fromRGB(105,35,255)
        ),
        ColorSequenceKeypoint.new(
            0.28,
            Color3.fromRGB(185,80,255)
        ),
        ColorSequenceKeypoint.new(
            0.5,
            Color3.fromRGB(245,170,255)
        ),
        ColorSequenceKeypoint.new(
            0.72,
            Color3.fromRGB(175,65,255)
        ),
        ColorSequenceKeypoint.new(
            1,
            Color3.fromRGB(95,25,235)
        )
    })
    Gradient.Offset = Vector2.new(-0.5,0)
    Gradient.Rotation = 0
    Gradient.Parent = Text
    local CachedAvatar = BaseAvatarCache[MatchedPlayer.UserId]
    if CachedAvatar then
        Avatar.Image = CachedAvatar
    else
        task.spawn(function()
            local Success,Image = pcall(function()
                return Players:GetUserThumbnailAsync(
                    MatchedPlayer.UserId,
                    Enum.ThumbnailType.HeadShot,
                    Enum.ThumbnailSize.Size420x420
                )
            end)
            if Success and Image then
                BaseAvatarCache[MatchedPlayer.UserId] = Image
                if Avatar and Avatar.Parent and PlotBaseESPs[PlotSign] and PlotBaseESPs[PlotSign].MatchedPlayer == MatchedPlayer then
                    Avatar.Image = Image
                end
            end
        end)
    end
    local Data = {
        Plot = GetPlotForLabeledSign(PlotSign),
        PlotSign = PlotSign,
        SourceLabel = SourceLabel,
        MatchedPlayer = MatchedPlayer,
        Anchor = Anchor,
        Billboard = Billboard,
        Avatar = Avatar,
        AvatarStroke = AvatarStroke,
        Label = Text,
        Gradient = Gradient
    }
    PlotBaseESPs[PlotSign] = Data
    return Data
end
local function UpdatePlotSignESP(PlotSign)
    local Data = PlotBaseESPs[PlotSign]
    if not PlotSign
    or not PlotSign.Parent then
        if Data then
            RemovePlotBaseESP(PlotSign)
        end
        return
    end
    local SourceLabel = GetBaseSurfaceLabel(PlotSign)
    if not SourceLabel then
        if Data then
            RemovePlotBaseESP(PlotSign)
        end
        return
    end
    local MatchedPlayer = MatchBaseTextToListPlayer(SourceLabel.Text)
    if not MatchedPlayer then
        if Data then
            RemovePlotBaseESP(PlotSign)
        end
        return
    end
    local ExpiresAt = SelectedTradePlayersUntil[MatchedPlayer.UserId]
    if not ExpiresAt or ExpiresAt <= os.clock() then
        if ExpiresAt then
            SelectedTradePlayersUntil[MatchedPlayer.UserId] = nil
        end
        if Data then
            RemovePlotBaseESP(PlotSign)
        end
        return
    end
    if not Data
    or Data.SourceLabel ~= SourceLabel
    or Data.MatchedPlayer ~= MatchedPlayer
    or not Data.Anchor
    or not Data.Anchor.Parent
    or not Data.Billboard
    or not Data.Billboard.Parent then
        if Data then
            RemovePlotBaseESP(PlotSign)
        end
        Data = CreatePlotBaseESP(
            PlotSign,
            SourceLabel,
            MatchedPlayer
        )
        if not Data then
            return
        end
    end
    Data.Plot = GetPlotForLabeledSign(PlotSign)
    Data.SourceLabel = SourceLabel
    Data.MatchedPlayer = MatchedPlayer
    Data.Label.Text = MatchedPlayer.Name
    Data.Label.TextColor3 = Color3.fromRGB(255,255,255)
    if Data.Gradient then
        Data.Gradient.Enabled = true
    end
    if Data.AvatarStroke then
        Data.AvatarStroke.Color = Color3.fromRGB(185,80,255)
    end
    Data.Billboard.Enabled = true
    local BoundsCF,BoundsSize = GetObjectBounds(PlotSign)
    if BoundsCF
    and BoundsSize
    and Data.Anchor
    and Data.Anchor.Parent then
        Data.Anchor.CFrame = CFrame.new(
            BoundsCF.Position.X,
            BoundsCF.Position.Y + BoundsSize.Y / 2 + 4,
            BoundsCF.Position.Z
        )
    end
end
local function ScanPlotBaseESPs()
    RefreshBasePlayerList()
    if not BaseListLoaded then
        return
    end
    local Plots = Workspace:FindFirstChild("Plots")
    if not Plots then
        return
    end
    local Seen = {}
    for _,Object in ipairs(Plots:GetDescendants()) do
        if Object.Name == "PlotSign" then
            Seen[Object] = true
            UpdatePlotSignESP(Object)
        end
    end
    local Remove = {}
    for PlotSign in pairs(PlotBaseESPs) do
        if not Seen[PlotSign]
        or not PlotSign.Parent then
            table.insert(Remove,PlotSign)
        end
    end
    for _,PlotSign in ipairs(Remove) do
        RemovePlotBaseESP(PlotSign)
    end
end
local function FindBaseESPForPlayer(Player)
    if not Player then
        return nil
    end
    for _,Data in pairs(PlotBaseESPs) do
        if Data.MatchedPlayer
        and Data.MatchedPlayer.UserId == Player.UserId then
            return Data
        end
    end
    return nil
end
local function RefreshSelectedBaseESP()
    ClearSelectedOverlay()
end
local function SetSelectedTradePlayer(Player)
    SelectedTradePlayer = Player
    if Player then
        SelectedTradePlayersUntil[Player.UserId] =
            os.clock() + 60
    end
    ClearSelectedOverlay()
    ScanPlotBaseESPs()
    RefreshSelectedBaseESP()
end
Connect(RunService.RenderStepped,function()
    local Time = os.clock()
    for _,BaseData in pairs(PlotBaseESPs) do
        local Gradient = BaseData.Gradient
        if Gradient
        and Gradient.Parent
        and Gradient.Enabled then
            Gradient.Offset = Vector2.new(
                math.sin(Time * 2.2) * 0.65,
                0
            )
            Gradient.Rotation =
                (Time * 32) % 360
        end
    end
end)
RefreshBasePlayerList()
ScanPlotBaseESPs()
task.spawn(function()
    while Gui and Gui.Parent do
        local Now = os.clock()
        for UserId,ExpiresAt in pairs(SelectedTradePlayersUntil) do
            if ExpiresAt <= Now then
                SelectedTradePlayersUntil[UserId] = nil
                if SelectedTradePlayer
                and SelectedTradePlayer.UserId == UserId then
                    SelectedTradePlayer = nil
                    ClearSelectedOverlay()
                end
            end
        end
        ScanPlotBaseESPs()
        RefreshSelectedBaseESP()
        task.wait(0.15)
    end
end)
local function FindNamedDescendant(ParentObject,Name,ClassName)
    if not ParentObject then
        return nil
    end
    for _,Object in ipairs(ParentObject:GetDescendants()) do
        if Object.Name == Name
        and (not ClassName or Object:IsA(ClassName)) then
            return Object
        end
    end
    return nil
end
local function PressGameButton(Button)
    if not Button
    or not Button:IsA("GuiButton")
    or typeof(firesignal) ~= "function" then
        return false
    end
    if typeof(getconnections) == "function" then
        local Success,ConnectionsFound = pcall(function()
            return getconnections(Button.MouseButton1Click)
        end)
        if Success
        and ConnectionsFound
        and #ConnectionsFound > 0 then
            return pcall(function()
                firesignal(Button.MouseButton1Click)
            end)
        end
        Success,ConnectionsFound = pcall(function()
            return getconnections(Button.Activated)
        end)
        if Success
        and ConnectionsFound
        and #ConnectionsFound > 0 then
            return pcall(function()
                firesignal(Button.Activated)
            end)
        end
    end
    local Success = pcall(function()
        firesignal(Button.MouseButton1Click)
    end)
    if Success then
        return true
    end
    return pcall(function()
        firesignal(Button.Activated)
    end)
end
local function EntryMatchesTradePlayer(Entry,Player)
    local Username = Normalize(Player.Name)
    if Normalize(Entry.Name) == Username then
        return true
    end
    for _,Object in ipairs(Entry:GetDescendants()) do
        if Object:IsA("TextLabel")
        or Object:IsA("TextButton")
        or Object:IsA("TextBox") then
            if Normalize(Object.Text) == Username then
                return true
            end
        end
    end
    return false
end
local function FindTradeSendButton(PlayerList,Player)
    local Visible = {}
    for _,Entry in ipairs(PlayerList:GetChildren()) do
        if EntryMatchesTradePlayer(Entry,Player) then
            local Fill = Entry:FindFirstChild("Fill")
            local Send = Fill and Fill:FindFirstChild("Send")
            if Send and Send:IsA("GuiButton") then
                return Send
            end
            Send = FindNamedDescendant(Entry,"Send","GuiButton")
            if Send then
                return Send
            end
        end
        local Fill = Entry:FindFirstChild("Fill")
        local Send = Fill and Fill:FindFirstChild("Send")
        if Send
        and Send:IsA("GuiButton")
        and Send.Visible then
            table.insert(Visible,Send)
        end
    end
    if #Visible == 1 then
        return Visible[1]
    end
    return nil
end
local LastTradedPlayer = nil
local BaseViewerViewport
local BaseViewerWorld
local BaseViewerCamera
local BaseViewerTitle
local BaseViewerCurrentPlot
local BaseViewerCurrentClone
local BaseViewerSlotMarkers = {}
local BaseViewerBoundsSize = Vector3.new(10,10,10)
local BaseViewerDistance = 30
local BaseViewerZoom = 1
local BaseViewerYaw = math.rad(35)
local BaseViewerPitch = math.rad(-25)
local BaseViewerOrbitDragging = false
local BaseViewerOrbitStart
local BaseViewerWindowDragging = false
local BaseViewerWindowStart
local BaseViewerWindowPosition
local BaseViewerBuildId = 0
local BaseViewerIgnoreNames = {
    InvisibleWalls = true,
    Laser = true,
    LaserHitbox = true,
    Purchases = true,
    Skin = true,
    Unlock = true,
    CashPad = true,
    FriendPanel = true,
    Model = true,
    Multiplier = true,
    PlotSign = true,
    Spawn = true
}
local function CalculateBaseViewerBounds(Object)
    local Min = Vector3.new(math.huge,math.huge,math.huge)
    local Max = Vector3.new(-math.huge,-math.huge,-math.huge)
    local Found = false
    local function IncludePart(Part)
        Found = true
        local Half = Part.Size * 0.5
        for X = -1,1,2 do
            for Y = -1,1,2 do
                for Z = -1,1,2 do
                    local Corner = Part.CFrame:PointToWorldSpace(
                        Vector3.new(Half.X*X,Half.Y*Y,Half.Z*Z)
                    )
                    Min = Vector3.new(
                        math.min(Min.X,Corner.X),
                        math.min(Min.Y,Corner.Y),
                        math.min(Min.Z,Corner.Z)
                    )
                    Max = Vector3.new(
                        math.max(Max.X,Corner.X),
                        math.max(Max.Y,Corner.Y),
                        math.max(Max.Z,Corner.Z)
                    )
                end
            end
        end
    end
    if Object:IsA("BasePart") then
        IncludePart(Object)
    end
    for _,Descendant in ipairs(Object:GetDescendants()) do
        if Descendant:IsA("BasePart") then
            IncludePart(Descendant)
        end
    end
    if not Found then
        return Vector3.zero,Vector3.new(10,10,10)
    end
    return (Min+Max)*0.5,Max-Min
end
local function SetBaseViewerArchivable(Object)
    local States = {}
    local function SetOne(Item)
        States[Item] = Item.Archivable
        pcall(function()
            Item.Archivable = true
        end)
    end
    SetOne(Object)
    for _,Item in ipairs(Object:GetDescendants()) do
        SetOne(Item)
    end
    return States
end
local function RestoreBaseViewerArchivable(States)
    for Object,State in pairs(States) do
        pcall(function()
            Object.Archivable = State
        end)
    end
end
local function CloneBaseViewerPlot(Plot)
    local States = SetBaseViewerArchivable(Plot)
    local Success,Clone = pcall(function()
        return Plot:Clone()
    end)
    RestoreBaseViewerArchivable(States)
    return Success and Clone or nil
end
local function PrepareBaseViewerClone(Clone)
    for _,Child in ipairs(Clone:GetChildren()) do
        if BaseViewerIgnoreNames[Child.Name] then
            Child:Destroy()
        end
    end
    local Destroy = {}
    for _,Object in ipairs(Clone:GetDescendants()) do
        if Object:IsA("Script")
        or Object:IsA("LocalScript")
        or Object:IsA("ModuleScript") then
            table.insert(Destroy,Object)
        elseif Object:IsA("BasePart") then
            Object.Anchored = true
            Object.CanCollide = false
            Object.CanTouch = false
            Object.CanQuery = false
        elseif Object:IsA("ProximityPrompt") then
            Object.Enabled = false
        end
    end
    for _,Object in ipairs(Destroy) do
        Object:Destroy()
    end
end
local function RecenterBaseViewerClone(Clone)
    local Center,Size = CalculateBaseViewerBounds(Clone)
    local Offset = CFrame.new(-Center)
    if Clone:IsA("BasePart") then
        Clone.CFrame = Offset * Clone.CFrame
    end
    for _,Object in ipairs(Clone:GetDescendants()) do
        if Object:IsA("BasePart") then
            Object.CFrame = Offset * Object.CFrame
        end
    end
    return Size
end
local function UpdateBaseViewerDistance()
    if not BaseViewerViewport or not BaseViewerCamera then
        return
    end
    local Width = math.max(BaseViewerViewport.AbsoluteSize.X,1)
    local Height = math.max(BaseViewerViewport.AbsoluteSize.Y,1)
    local Aspect = Width/Height
    local Vertical = math.rad(BaseViewerCamera.FieldOfView)
    local Horizontal = 2*math.atan(math.tan(Vertical/2)*Aspect)
    local SmallFOV = math.min(Vertical,Horizontal)
    local Radius = math.max(BaseViewerBoundsSize.Magnitude/2,5)
    BaseViewerDistance = Radius/math.sin(SmallFOV/2)
    BaseViewerDistance *= 1.1
end
local function UpdateBaseViewerCamera()
    if not BaseViewerCurrentClone or not BaseViewerCamera then
        return
    end
    local Rotation =
        CFrame.Angles(0,BaseViewerYaw,0)
        * CFrame.Angles(BaseViewerPitch,0,0)
    local Direction = Rotation.LookVector
    local Distance = BaseViewerDistance*BaseViewerZoom
    BaseViewerCamera.CFrame = CFrame.lookAt(
        -Direction*Distance,
        Vector3.zero
    )
end
local function ClearBaseViewerMarkers()
    for _,Data in pairs(BaseViewerSlotMarkers) do
        if Data.Gui then
            Data.Gui:Destroy()
        end
    end
    table.clear(BaseViewerSlotMarkers)
end
local function ClearBaseViewerWorld()
    ClearBaseViewerMarkers()
    if BaseViewerCurrentClone then
        BaseViewerCurrentClone:Destroy()
        BaseViewerCurrentClone = nil
    end
    if BaseViewerWorld then
        for _,Child in ipairs(BaseViewerWorld:GetChildren()) do
            Child:Destroy()
        end
    end
end
local function BaseViewerInsideNestedModel(Part,Slot)
    local Parent = Part.Parent
    while Parent and Parent ~= Slot do
        if Parent:IsA("Model") then
            return true
        end
        Parent = Parent.Parent
    end
    return false
end
local function GetBaseViewerPreferredPart(Slot)
    local Names = {
        "Podium","Platform","Base","MainRoot","Root","Stand","Pad"
    }
    for _,Name in ipairs(Names) do
        local Direct = Slot:FindFirstChild(Name)
        if Direct and Direct:IsA("BasePart") then
            return Direct
        end
    end
    for _,Name in ipairs(Names) do
        local Object = Slot:FindFirstChild(Name,true)
        if Object
        and Object:IsA("BasePart")
        and not BaseViewerInsideNestedModel(Object,Slot) then
            return Object
        end
    end
    return nil
end
local function GetBaseViewerSlotPart(Slot)
    if Slot:IsA("BasePart") then
        return Slot
    end
    local Preferred = GetBaseViewerPreferredPart(Slot)
    if Preferred then
        return Preferred
    end
    local DirectParts = {}
    for _,Child in ipairs(Slot:GetChildren()) do
        if Child:IsA("BasePart") then
            table.insert(DirectParts,Child)
        end
    end
    if #DirectParts > 0 then
        table.sort(DirectParts,function(A,B)
            local AreaA = A.Size.X*A.Size.Z
            local AreaB = B.Size.X*B.Size.Z
            if A.Anchored ~= B.Anchored then
                return A.Anchored
            end
            if math.abs(A.Position.Y-B.Position.Y) > 0.25 then
                return A.Position.Y < B.Position.Y
            end
            return AreaA > AreaB
        end)
        return DirectParts[1]
    end
    local Candidates = {}
    for _,Object in ipairs(Slot:GetDescendants()) do
        if Object:IsA("BasePart")
        and not BaseViewerInsideNestedModel(Object,Slot) then
            table.insert(Candidates,Object)
        end
    end
    if #Candidates > 0 then
        table.sort(Candidates,function(A,B)
            local AreaA = A.Size.X*A.Size.Z
            local AreaB = B.Size.X*B.Size.Z
            if A.Anchored ~= B.Anchored then
                return A.Anchored
            end
            if math.abs(A.Position.Y-B.Position.Y) > 0.25 then
                return A.Position.Y < B.Position.Y
            end
            return AreaA > AreaB
        end)
        return Candidates[1]
    end
    if Slot:IsA("Model") and Slot.PrimaryPart then
        return Slot.PrimaryPart
    end
    local LowestPart
    local LowestY = math.huge
    local BestArea = 0
    for _,Object in ipairs(Slot:GetDescendants()) do
        if Object:IsA("BasePart") then
            local Area = Object.Size.X*Object.Size.Z
            if Object.Position.Y < LowestY-0.25 then
                LowestY = Object.Position.Y
                BestArea = Area
                LowestPart = Object
            elseif math.abs(Object.Position.Y-LowestY) <= 0.25
            and Area > BestArea then
                BestArea = Area
                LowestPart = Object
            end
        end
    end
    return LowestPart
end
local function GetBaseViewerSlotPosition(Slot)
    local Part = GetBaseViewerSlotPart(Slot)
    if not Part then
        if Slot:IsA("Model") then
            return Slot:GetPivot().Position
        end
        return Vector3.zero
    end
    local CF = Part.CFrame
    local FrontOffset = math.max(Part.Size.Z*0.5,0.35)+0.3
    return Part.Position
        + CF.LookVector*FrontOffset
        + CF.UpVector*0.08
end
local function CreateBaseViewerSlotMarker(Number,Slot)
    local Circle = Instance.new("Frame")
    Circle.Name = "Slot_"..tostring(Number)
    Circle.AnchorPoint = Vector2.new(0.5,0.5)
    Circle.Size = UDim2.fromOffset(17,17)
    Circle.BackgroundColor3 = Color3.fromRGB(155,70,255)
    Circle.BorderSizePixel = 0
    Circle.Visible = false
    Circle.ZIndex = 30
    Circle.Parent = BaseViewerViewport
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(1,0)
    Corner.Parent = Circle
    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Color3.fromRGB(220,175,255)
    Stroke.Thickness = 1
    Stroke.Transparency = 0.12
    Stroke.Parent = Circle
    local Text = Instance.new("TextLabel")
    Text.Size = UDim2.fromScale(1,1)
    Text.BackgroundTransparency = 1
    Text.Text = tostring(Number)
    Text.TextColor3 = Color3.new(1,1,1)
    Text.Font = Enum.Font.GothamBold
    Text.TextSize = 8
    Text.TextXAlignment = Enum.TextXAlignment.Center
    Text.TextYAlignment = Enum.TextYAlignment.Center
    Text.ZIndex = 31
    Text.Parent = Circle
    BaseViewerSlotMarkers[Number] = {
        Gui = Circle,
        Slot = Slot,
        Position = GetBaseViewerSlotPosition(Slot)
    }
end
local function BuildBaseViewerSlotMarkers()
    ClearBaseViewerMarkers()
    if not BaseViewerCurrentClone then
        return
    end
    local Podiums = BaseViewerCurrentClone:FindFirstChild("AnimalPodiums",true)
    if not Podiums then
        return
    end
    for I = 1,28 do
        local Slot = Podiums:FindFirstChild(tostring(I))
        if Slot then
            CreateBaseViewerSlotMarker(I,Slot)
        end
    end
end
local function ProjectBaseViewerPoint(WorldPosition)
    if not BaseViewerViewport or not BaseViewerCamera then
        return nil
    end
    local Size = BaseViewerViewport.AbsoluteSize
    if Size.X <= 0 or Size.Y <= 0 then
        return nil
    end
    local Relative = BaseViewerCamera.CFrame:PointToObjectSpace(WorldPosition)
    local Depth = -Relative.Z
    if Depth <= 0.01 then
        return nil
    end
    local VerticalFOV = math.rad(BaseViewerCamera.FieldOfView)
    local TanVertical = math.tan(VerticalFOV/2)
    local Aspect = Size.X/Size.Y
    local TanHorizontal = TanVertical*Aspect
    local NDCX = Relative.X/(Depth*TanHorizontal)
    local NDCY = Relative.Y/(Depth*TanVertical)
    local X = (NDCX+1)*0.5*Size.X
    local Y = (1-NDCY)*0.5*Size.Y
    local Visible = X >= 0 and X <= Size.X and Y >= 0 and Y <= Size.Y
    return Vector2.new(X,Y),Depth,Visible
end
local function UpdateBaseViewerMarkers()
    if not BaseViewerCurrentClone then
        return
    end
    for _,Data in pairs(BaseViewerSlotMarkers) do
        local Circle = Data.Gui
        if Circle then
            local Position,Depth,Visible = ProjectBaseViewerPoint(Data.Position)
            if Position and Visible then
                Circle.Visible = true
                Circle.Position = UDim2.fromOffset(Position.X,Position.Y)
                local Ratio = BaseViewerDistance/math.max(Depth,1)
                local MarkerSize = math.clamp(16*Ratio,11,18)
                Circle.Size = UDim2.fromOffset(MarkerSize,MarkerSize)
            else
                Circle.Visible = false
            end
        end
    end
end
local function GetMainPlotFromMatchedSign(Player)
    if not Player then
        return nil,nil
    end
    ScanPlotBaseESPs()
    local BaseData = FindBaseESPForPlayer(Player)
    if not BaseData then
        return nil,nil
    end
    local PlotSign = BaseData.PlotSign
    local Plot = BaseData.Plot
    if (not Plot or not Plot.Parent) and PlotSign and PlotSign.Parent then
        Plot = GetPlotForLabeledSign(PlotSign)
        BaseData.Plot = Plot
    end
    if Plot and Plot.Parent then
        return Plot,PlotSign
    end
    return nil,PlotSign
end
local function EnsureLastTradeBaseViewer()
    if BaseViewerFrame and BaseViewerFrame.Parent then
        return
    end
    BaseViewerFrame = Instance.new("Frame")
    BaseViewerFrame.Name = "LastTradeBaseViewer"
    BaseViewerFrame.Size = UDim2.fromOffset(430,620)
    BaseViewerFrame.Position = SavedPosition(
        "BaseViewer",
        UDim2.new(0.5,-215,0.5,-310)
    )
    BaseViewerFrame.BackgroundColor3 = Color3.fromRGB(15,15,20)
    BaseViewerFrame.BorderSizePixel = 0
    BaseViewerFrame.ClipsDescendants = true
    BaseViewerFrame.Active = true
    BaseViewerFrame.Visible = false
    BaseViewerFrame.ZIndex = 20
    BaseViewerFrame.Parent = Gui
    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0,12)
    MainCorner.Parent = BaseViewerFrame
    local MainStroke = Instance.new("UIStroke")
    MainStroke.Thickness = 2
    MainStroke.Color = Color3.fromRGB(180,70,255)
    MainStroke.Parent = BaseViewerFrame
    local Header2 = Instance.new("Frame")
    Header2.Size = UDim2.new(1,0,0,48)
    Header2.BackgroundColor3 = Color3.fromRGB(23,23,31)
    Header2.BorderSizePixel = 0
    Header2.Active = true
    Header2.ZIndex = 22
    Header2.Parent = BaseViewerFrame
    local HeaderCorner = Instance.new("UICorner")
    HeaderCorner.CornerRadius = UDim.new(0,12)
    HeaderCorner.Parent = Header2
    BaseViewerTitle = Instance.new("TextLabel")
    BaseViewerTitle.Size = UDim2.new(1,-30,1,0)
    BaseViewerTitle.Position = UDim2.new(0,15,0,0)
    BaseViewerTitle.BackgroundTransparency = 1
    BaseViewerTitle.Text = "Last Trade Base"
    BaseViewerTitle.TextColor3 = Color3.fromRGB(205,130,255)
    BaseViewerTitle.Font = Enum.Font.GothamBold
    BaseViewerTitle.TextSize = 19
    BaseViewerTitle.TextXAlignment = Enum.TextXAlignment.Left
    BaseViewerTitle.ZIndex = 23
    BaseViewerTitle.Parent = Header2
    local PreviewContainer = Instance.new("Frame")
    PreviewContainer.Size = UDim2.new(1,-8,1,-57)
    PreviewContainer.Position = UDim2.new(0,4,0,52)
    PreviewContainer.BackgroundColor3 = Color3.fromRGB(9,9,13)
    PreviewContainer.BorderSizePixel = 0
    PreviewContainer.ClipsDescendants = true
    PreviewContainer.ZIndex = 21
    PreviewContainer.Parent = BaseViewerFrame
    local PreviewCorner = Instance.new("UICorner")
    PreviewCorner.CornerRadius = UDim.new(0,9)
    PreviewCorner.Parent = PreviewContainer
    BaseViewerViewport = Instance.new("ViewportFrame")
    BaseViewerViewport.Size = UDim2.new(1,-8,1,-8)
    BaseViewerViewport.Position = UDim2.new(0,4,0,4)
    BaseViewerViewport.BackgroundColor3 = Color3.fromRGB(6,6,10)
    BaseViewerViewport.BorderSizePixel = 0
    BaseViewerViewport.Ambient = Color3.fromRGB(190,190,200)
    BaseViewerViewport.LightColor = Color3.fromRGB(255,255,255)
    BaseViewerViewport.LightDirection = Vector3.new(-1,-1,-0.5)
    BaseViewerViewport.ClipsDescendants = true
    BaseViewerViewport.ZIndex = 22
    BaseViewerViewport.Parent = PreviewContainer
    local ViewportCorner = Instance.new("UICorner")
    ViewportCorner.CornerRadius = UDim.new(0,8)
    ViewportCorner.Parent = BaseViewerViewport
    BaseViewerWorld = Instance.new("WorldModel")
    BaseViewerWorld.Name = "LastTradeFakeWorld"
    BaseViewerWorld.Parent = BaseViewerViewport
    BaseViewerCamera = Instance.new("Camera")
    BaseViewerCamera.FieldOfView = 50
    BaseViewerCamera.Parent = BaseViewerViewport
    BaseViewerViewport.CurrentCamera = BaseViewerCamera
    Connect(BaseViewerViewport.InputBegan,function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1
        or Input.UserInputType == Enum.UserInputType.Touch then
            BaseViewerOrbitDragging = true
            BaseViewerOrbitStart = Input.Position
        end
    end)
    Connect(BaseViewerViewport.InputEnded,function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1
        or Input.UserInputType == Enum.UserInputType.Touch then
            BaseViewerOrbitDragging = false
        end
    end)
    Connect(Header2.InputBegan,function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1
        or Input.UserInputType == Enum.UserInputType.Touch then
            BaseViewerWindowDragging = true
            BaseViewerWindowStart = Input.Position
            BaseViewerWindowPosition = BaseViewerFrame.Position
        end
    end)
    Connect(Header2.InputEnded,function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1
        or Input.UserInputType == Enum.UserInputType.Touch then
            if BaseViewerWindowDragging and SaveGuiPositions then
                pcall(SaveGuiPositions)
            end
            BaseViewerWindowDragging = false
        end
    end)
    Connect(UserInputService.InputChanged,function(Input)
        if BaseViewerOrbitDragging and (
            Input.UserInputType == Enum.UserInputType.MouseMovement
            or Input.UserInputType == Enum.UserInputType.Touch
        ) then
            local Delta = Input.Position-BaseViewerOrbitStart
            BaseViewerOrbitStart = Input.Position
            BaseViewerYaw -= Delta.X*0.008
            BaseViewerPitch -= Delta.Y*0.008
            BaseViewerPitch = math.clamp(
                BaseViewerPitch,
                math.rad(-85),
                math.rad(85)
            )
            UpdateBaseViewerCamera()
        elseif Input.UserInputType == Enum.UserInputType.MouseWheel then
            local Mouse = UserInputService:GetMouseLocation()
            local Position = BaseViewerViewport.AbsolutePosition
            local Size = BaseViewerViewport.AbsoluteSize
            if Mouse.X >= Position.X
            and Mouse.X <= Position.X+Size.X
            and Mouse.Y >= Position.Y
            and Mouse.Y <= Position.Y+Size.Y then
                BaseViewerZoom -= Input.Position.Z*0.1
                BaseViewerZoom = math.clamp(BaseViewerZoom,0.2,5)
                UpdateBaseViewerCamera()
            end
        elseif BaseViewerWindowDragging and (
            Input.UserInputType == Enum.UserInputType.MouseMovement
            or Input.UserInputType == Enum.UserInputType.Touch
        ) then
            local Delta = Input.Position-BaseViewerWindowStart
            BaseViewerFrame.Position = UDim2.new(
                BaseViewerWindowPosition.X.Scale,
                BaseViewerWindowPosition.X.Offset+Delta.X,
                BaseViewerWindowPosition.Y.Scale,
                BaseViewerWindowPosition.Y.Offset+Delta.Y
            )
        end
    end)
    Connect(UserInputService.InputEnded,function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1
        or Input.UserInputType == Enum.UserInputType.Touch then
            if BaseViewerWindowDragging and SaveGuiPositions then
                pcall(SaveGuiPositions)
            end
            BaseViewerWindowDragging = false
        end
    end)
    Connect(BaseViewerViewport:GetPropertyChangedSignal("AbsoluteSize"),function()
        if BaseViewerCurrentClone then
            UpdateBaseViewerDistance()
            UpdateBaseViewerCamera()
        end
    end)
    Connect(RunService.RenderStepped,function()
        if BaseViewerFrame
        and BaseViewerFrame.Parent
        and BaseViewerFrame.Visible then
            UpdateBaseViewerMarkers()
        end
    end)
end
local function ShowLastTradedBase(Player,ForceShow)
    if not Player then
        return false
    end
    EnsureLastTradeBaseViewer()
    BaseViewerBuildId += 1
    local BuildId = BaseViewerBuildId
    if ForceShow ~= false then
        BaseViewerFrame.Visible = true
    end
    BaseViewerTitle.Text = Player.Name
    local Plot = GetMainPlotFromMatchedSign(Player)
    if not Plot then
        ClearBaseViewerWorld()
        BaseViewerCurrentPlot = nil
        BaseViewerTitle.Text = Player.Name
        return false
    end
    ClearBaseViewerWorld()
    BaseViewerCurrentPlot = Plot
    BaseViewerTitle.Text = Player.Name
    local Clone = CloneBaseViewerPlot(Plot)
    if BuildId ~= BaseViewerBuildId then
        if Clone then Clone:Destroy() end
        return false
    end
    if not Clone then
        BaseViewerTitle.Text = Player.Name
        return false
    end
    PrepareBaseViewerClone(Clone)
    Clone.Name = "Fake_"..Plot.Name
    Clone.Parent = BaseViewerWorld
    BaseViewerCurrentClone = Clone
    BaseViewerBoundsSize = RecenterBaseViewerClone(Clone)
    BaseViewerYaw = math.rad(35)
    BaseViewerPitch = math.rad(-25)
    BaseViewerZoom = 1
    UpdateBaseViewerDistance()
    UpdateBaseViewerCamera()
    BuildBaseViewerSlotMarkers()
    BaseViewerTitle.Text = Player.Name
    return true
end
local function SetLastTradedBase(Player)
    LastTradedPlayer = Player
    ShowLastTradedBase(Player,true)
end
task.spawn(function()
    while Gui and Gui.Parent do
        if LastTradedPlayer
        and LastTradedPlayer.Parent == Players
        and BaseViewerFrame
        and BaseViewerFrame.Parent
        and BaseViewerFrame.Visible then
            local Plot = GetMainPlotFromMatchedSign(LastTradedPlayer)
            if Plot and (not BaseViewerCurrentClone or BaseViewerCurrentPlot ~= Plot) then
                ShowLastTradedBase(LastTradedPlayer,false)
            elseif not Plot and BaseViewerTitle then
                BaseViewerTitle.Text = LastTradedPlayer.Name
            end
        end
        task.wait(0.8)
    end
end)
local function TradeWithPlayer(Player,Button)
    if Trading then
        return
    end
    Trading = true
    local OldText = Button.Text
    Button.Text = "..."
    local Completed = false
    local Success,Error = pcall(function()
        local PlayerGui = LP:WaitForChild("PlayerGui")
        local LeftCenter = PlayerGui:FindFirstChild("LeftCenter")
        if not LeftCenter then
            error("LeftCenter missing")
        end
        local OpenButton = FindNamedDescendant(
            LeftCenter,
            "TradePlayerList",
            "GuiButton"
        )
        if not OpenButton then
            error("TradePlayerList button missing")
        end
        if not PressGameButton(OpenButton) then
            error("TradePlayerList button failed")
        end
        task.wait(0.25)
        local TradeOuter = PlayerGui:FindFirstChild("TradePlayerList")
            or PlayerGui:WaitForChild("TradePlayerList",5)
        if not TradeOuter then
            error("TradePlayerList GUI missing")
        end
        local TradeMain = TradeOuter:FindFirstChild("TradePlayerList")
            or TradeOuter:WaitForChild("TradePlayerList",5)
        if not TradeMain then
            error("Inner TradePlayerList missing")
        end
        local Sections = TradeMain:FindFirstChild("Sections")
            or TradeMain:WaitForChild("Sections",5)
        local PlayersSection = Sections
            and (Sections:FindFirstChild("Players")
            or Sections:WaitForChild("Players",5))
        local SearchFrame = PlayersSection
            and (PlayersSection:FindFirstChild("SearchFrame")
            or PlayersSection:WaitForChild("SearchFrame",5))
        local SearchBox = SearchFrame
            and (SearchFrame:FindFirstChild("SearchBox")
            or SearchFrame:WaitForChild("SearchBox",5))
        if not SearchBox
        or not SearchBox:IsA("TextBox") then
            error("SearchBox missing")
        end
        SearchBox:CaptureFocus()
        task.wait(0.05)
        SearchBox.Text = Player.Name
        task.wait(0.08)
        SearchBox:ReleaseFocus(true)
        task.wait(0.25)
        local PlayerList = PlayersSection:FindFirstChild("List")
            or PlayersSection:WaitForChild("List",5)
        if not PlayerList then
            error("Player list missing")
        end
        local SendButton
        local Timeout = os.clock() + 8
        repeat
            SendButton = FindTradeSendButton(PlayerList,Player)
            if not SendButton then
                task.wait(0.1)
            end
        until SendButton or os.clock() >= Timeout
        if not SendButton then
            error("Send button not found for "..Player.Name)
        end
        if not PressGameButton(SendButton) then
            error("Send button failed")
        end
        task.wait(0.4)
        local Header = TradeMain:FindFirstChild("Header")
        local TradeClose = Header and Header:FindFirstChild("Close")
        if TradeClose and TradeClose:IsA("GuiButton") then
            PressGameButton(TradeClose)
        end
        Completed = true
    end)
    if not Success then
        warn(Error)
    end
    if Completed then
        SetSelectedTradePlayer(Player)
    end
    if Button.Parent then
        Button.Text = Completed and "✓" or "×"
    end
    task.wait(0.6)
    if Button.Parent then
        Button.Text = OldText
    end
    Trading = false
end
local Rows = {}
local function RemoveRow(UserId)
    local Row = Rows[UserId]
    if Row then
        Rows[UserId] = nil
        Row:Destroy()
    end
end
local function ClearRows()
    local IDs = {}
    for UserId in pairs(Rows) do
        table.insert(IDs,UserId)
    end
    for _,UserId in ipairs(IDs) do
        RemoveRow(UserId)
    end
end
local function CreateRow(Player)
    if Rows[Player.UserId] then
        return
    end
    local Row = Instance.new("Frame")
    Row.Size = UDim2.new(1,-4,0,62)
    Row.BackgroundColor3 =
        Color3.fromRGB(31,18,45)
    Row.BackgroundTransparency = 0.08
    Row.BorderSizePixel = 0
    Row.ZIndex = 6
    Row.Parent = List
    local RowCorner =
        Instance.new("UICorner")
    RowCorner.CornerRadius =
        UDim.new(0,11)
    RowCorner.Parent = Row
    local RowStroke =
        Instance.new("UIStroke")
    RowStroke.Color =
        Color3.fromRGB(125,52,188)
    RowStroke.Transparency = 0.3
    RowStroke.Parent = Row
    local Avatar =
        Instance.new("ImageLabel")
    Avatar.Size =
        UDim2.fromOffset(44,44)
    Avatar.Position =
        UDim2.fromOffset(9,9)
    Avatar.BackgroundColor3 =
        Color3.fromRGB(54,28,76)
    Avatar.BorderSizePixel = 0
    Avatar.ZIndex = 7
    Avatar.Parent = Row
    local AvatarCorner =
        Instance.new("UICorner")
    AvatarCorner.CornerRadius =
        UDim.new(1,0)
    AvatarCorner.Parent = Avatar
    local AvatarStroke =
        Instance.new("UIStroke")
    AvatarStroke.Color =
        Color3.fromRGB(150,65,215)
    AvatarStroke.Transparency = 0.25
    AvatarStroke.Parent = Avatar
    task.spawn(function()
        local Success,Image =
            pcall(function()
                return Players:GetUserThumbnailAsync(
                    Player.UserId,
                    Enum.ThumbnailType.HeadShot,
                    Enum.ThumbnailSize.Size150x150
                )
            end)
        if Success
        and Avatar.Parent then
            Avatar.Image = Image
        end
    end)
    local Username =
        Instance.new("TextLabel")
    Username.Size =
        UDim2.new(1,-175,0,32)
    Username.Position =
        UDim2.fromOffset(63,15)
    Username.BackgroundTransparency = 1
    Username.Text = Player.Name
    Username.TextColor3 =
        Color3.fromRGB(246,235,255)
    Username.Font = Enum.Font.GothamSemibold
    Username.TextSize = 13
    Username.TextXAlignment =
        Enum.TextXAlignment.Left
    Username.TextTruncate =
        Enum.TextTruncate.AtEnd
    Username.ZIndex = 7
    Username.Parent = Row
    local Trade =
        Instance.new("TextButton")
    Trade.Size =
        UDim2.fromOffset(82,34)
    Trade.Position =
        UDim2.new(1,-90,0.5,-17)
    Trade.BackgroundColor3 =
        Color3.fromRGB(108,42,172)
    Trade.BorderSizePixel = 0
    Trade.Text = "TRADE"
    Trade.TextColor3 =
        Color3.fromRGB(255,245,255)
    Trade.Font =
        Enum.Font.GothamBold
    Trade.TextSize = 11
    Trade.AutoButtonColor = false
    Trade.ZIndex = 8
    Trade.Parent = Row
    local TradeCorner =
        Instance.new("UICorner")
    TradeCorner.CornerRadius =
        UDim.new(0,9)
    TradeCorner.Parent = Trade
    local TradeStroke =
        Instance.new("UIStroke")
    TradeStroke.Color =
        Color3.fromRGB(200,100,255)
    TradeStroke.Transparency = 0.15
    TradeStroke.Parent = Trade
    Connect(
        Trade.MouseButton1Click,
        function()
            task.spawn(function()
                TradeWithPlayer(
                    Player,
                    Trade
                )
            end)
        end
    )
    Rows[Player.UserId] = Row
end
local function CoreLower(Value)
    return string.lower(tostring(Value or ""))
end
local function CoreText(Object)
    local Success,Value = pcall(function()
        return Object.ContentText
    end)
    if Success and Value and Value ~= "" then
        return Value
    end
    Success,Value = pcall(function()
        return Object.Text
    end)
    if Success then
        return Value or ""
    end
    return ""
end
local function IsOurCoreObject(Object)
    local Current = Object
    while Current do
        if Current == Gui then
            return true
        end
        if Current == CoreGui then
            break
        end
        Current = Current.Parent
    end
    return false
end
local function IsCoreObjectVisible(Object)
    if not Object:IsA("GuiObject") or not Object.Visible then
        return false
    end
    local Size = Object.AbsoluteSize
    if Size.X <= 0 or Size.Y <= 0 then
        return false
    end
    local Current = Object.Parent
    while Current and Current ~= CoreGui do
        if Current:IsA("GuiObject") and not Current.Visible then
            return false
        end
        Current = Current.Parent
    end
    return true
end
local function IsCoreMenuOpen()
    local Success,Open = pcall(function()
        return GuiService.MenuIsOpen
    end)
    return Success and Open == true
end
local CoreVoiceWords = {
    "voice",
    "mute",
    "unmute",
    "speaker",
    "microphone",
    "mic"
}
local function AnalyzeCoreRow(Row,Player)
    local Result = {
        Buttons = 0,
        HasDisplayName = false,
        HasVoiceWord = false,
        HasRedVoiceMark = false
    }
    local SeenButtons = {}
    local TargetDisplay = CoreLower(Player.DisplayName)
    local Descendants = Row:GetDescendants()
    for _,Object in ipairs(Descendants) do
        if Object:IsA("TextLabel") or Object:IsA("TextButton") then
            local Text = CoreLower(CoreText(Object))
            if Text == TargetDisplay then
                Result.HasDisplayName = true
            end
            if not Result.HasVoiceWord then
                for _,Word in ipairs(CoreVoiceWords) do
                    if string.find(Text,Word,1,true) then
                        Result.HasVoiceWord = true
                        break
                    end
                end
            end
        end
        if not Result.HasVoiceWord then
            local Name = CoreLower(Object.Name)
            for _,Word in ipairs(CoreVoiceWords) do
                if string.find(Name,Word,1,true) then
                    Result.HasVoiceWord = true
                    break
                end
            end
        end
        if not Result.HasVoiceWord then
            local Success,Attributes = pcall(function()
                return Object:GetAttributes()
            end)
            if Success then
                for Key,Value in pairs(Attributes) do
                    local AttributeText = CoreLower(Key).." "..CoreLower(Value)
                    for _,Word in ipairs(CoreVoiceWords) do
                        if string.find(AttributeText,Word,1,true) then
                            Result.HasVoiceWord = true
                            break
                        end
                    end
                    if Result.HasVoiceWord then
                        break
                    end
                end
            end
        end
        if Object:IsA("ImageButton") or Object:IsA("TextButton") then
            if Object.Visible then
                local Size = Object.AbsoluteSize
                if Size.X >= 25
                and Size.X <= 65
                and Size.Y >= 25
                and Size.Y <= 65
                and math.abs(Size.X-Size.Y) <= 18 then
                    local Position = Object.AbsolutePosition
                    local Key = math.floor(Position.X/3)..":"..math.floor(Position.Y/3)
                    if not SeenButtons[Key] then
                        SeenButtons[Key] = true
                        Result.Buttons += 1
                    end
                end
            end
        end
        if not Result.HasRedVoiceMark then
            if Object:IsA("ImageLabel") or Object:IsA("ImageButton") then
                if Object.Visible then
                    local Color = Object.ImageColor3
                    if Color.R > 0.65
                    and Color.R > Color.G*1.4
                    and Color.R > Color.B*1.2 then
                        Result.HasRedVoiceMark = true
                    end
                end
            elseif Object:IsA("Frame") and Object.Visible then
                local Color = Object.BackgroundColor3
                if Object.BackgroundTransparency < 0.7
                and Color.R > 0.65
                and Color.R > Color.G*1.4
                and Color.R > Color.B*1.2 then
                    Result.HasRedVoiceMark = true
                end
            end
        end
    end
    Result.HasVoice = Result.HasVoiceWord
        or Result.Buttons >= 4
        or (Result.Buttons >= 3 and Result.HasRedVoiceMark)
    return Result
end
local function ScoreCoreRow(Row,Player,Cache)
    if not Row:IsA("GuiObject") or not IsCoreObjectVisible(Row) then
        return -math.huge,false
    end
    local Size = Row.AbsoluteSize
    if Size.X < 200 or Size.Y < 35 or Size.Y > 140 then
        return -math.huge,false
    end
    local PerRow = Cache[Row]
    if not PerRow then
        PerRow = {}
        Cache[Row] = PerRow
    end
    local Analysis = PerRow[Player.UserId]
    if not Analysis then
        Analysis = AnalyzeCoreRow(Row,Player)
        PerRow[Player.UserId] = Analysis
    end
    local Score = 0
    if Size.Y >= 45 and Size.Y <= 90 then
        Score += 25
    end
    if Size.X >= 400 then
        Score += 20
    end
    if Analysis.HasDisplayName then
        Score += 30
    end
    if Analysis.Buttons >= 2 then
        Score += 15
    end
    if Analysis.Buttons >= 3 then
        Score += 10
    end
    if Analysis.Buttons >= 4 then
        Score += 10
    end
    return Score,Analysis.HasVoice
end
local function ScanCoreVoicePlayers()
    if not IsCoreMenuOpen() then
        return nil,false
    end
    local Success,Descendants = pcall(function()
        return CoreGui:GetDescendants()
    end)
    if not Success or not Descendants then
        return nil,false
    end
    local PeopleVisible = false
    local PlayerByName = {}
    for _,Player in ipairs(Players:GetPlayers()) do
        if Player ~= LP then
            PlayerByName[CoreLower(Player.Name)] = Player
        end
    end
    for _,Object in ipairs(Descendants) do
        if not IsOurCoreObject(Object)
        and (Object:IsA("TextLabel") or Object:IsA("TextButton"))
        and IsCoreObjectVisible(Object)
        and CoreLower(CoreText(Object)) == "people" then
            PeopleVisible = true
            break
        end
    end
    if not PeopleVisible then
        return nil,false
    end
    local Best = {}
    local Cache = {}
    for _,Object in ipairs(Descendants) do
        if not IsOurCoreObject(Object)
        and (Object:IsA("TextLabel") or Object:IsA("TextButton"))
        and IsCoreObjectVisible(Object) then
            local Text = CoreLower(CoreText(Object))
            Text = Text:gsub("^%s+",""):gsub("%s+$",""):gsub("^@","")
            local Player = PlayerByName[Text]
            if Player then
                local Current = Object.Parent
                local Depth = 0
                while Current and Current ~= CoreGui and Depth < 10 do
                    if Current:IsA("GuiObject") then
                        local Score,HasVoice = ScoreCoreRow(Current,Player,Cache)
                        local Previous = Best[Player.UserId]
                        if not Previous or Score > Previous.Score then
                            Best[Player.UserId] = {
                                Player = Player,
                                Score = Score,
                                HasVoice = HasVoice
                            }
                        end
                    end
                    Current = Current.Parent
                    Depth += 1
                end
            end
        end
    end
    local Detected = {}
    for _,Entry in pairs(Best) do
        if Entry.Score >= 40 and Entry.HasVoice then
            table.insert(Detected,Entry.Player)
        end
    end
    table.sort(Detected,function(A,B)
        return string.lower(A.DisplayName) < string.lower(B.DisplayName)
    end)
    return Detected,true
end
local function RefreshCoreVoicePlayers()
    local Detected,Scanned = ScanCoreVoicePlayers()
    if not Scanned then
        return false
    end
    SetFetchedBasePlayers(Detected)
    ClearRows()
    for _,Player in ipairs(Detected) do
        CreateRow(Player)
    end
    RefreshBasePlayerList()
    ScanPlotBaseESPs()
    RefreshSelectedBaseESP()
    return true
end
local CoreScanGeneration = 0
local CoreScanRunning = false
local LastCoreScan = 0
local function ScheduleCoreScan(Delay)
    if not IsCoreMenuOpen() then
        return
    end
    local Now = os.clock()
    if Now-LastCoreScan < 0.2 then
        return
    end
    CoreScanGeneration += 1
    local Generation = CoreScanGeneration
    task.delay(Delay or 0.15,function()
        if not Gui or not Gui.Parent
        or Generation ~= CoreScanGeneration
        or not IsCoreMenuOpen()
        or CoreScanRunning then
            return
        end
        CoreScanRunning = true
        LastCoreScan = os.clock()
        pcall(RefreshCoreVoicePlayers)
        CoreScanRunning = false
    end)
end
Connect(
    GuiService:GetPropertyChangedSignal("MenuIsOpen"),
    function()
        if IsCoreMenuOpen() then
            ScheduleCoreScan(0.18)
        else
            CoreScanGeneration += 1
        end
    end
)
Connect(
    CoreGui.DescendantAdded,
    function(Object)
        if IsCoreMenuOpen() and not IsOurCoreObject(Object) then
            ScheduleCoreScan(0.18)
        end
    end
)
Connect(
    CoreGui.DescendantRemoving,
    function(Object)
        if IsCoreMenuOpen() and not IsOurCoreObject(Object) then
            ScheduleCoreScan(0.18)
        end
    end
)
task.spawn(function()
    while Gui and Gui.Parent do
        if IsCoreMenuOpen() then
            ScheduleCoreScan(0)
            task.wait(1.1)
        else
            task.wait(0.4)
        end
    end
end)
Connect(
    Players.PlayerAdded,
    function()
        if IsCoreMenuOpen() then
            ScheduleCoreScan(0.15)
        end
    end
)
Connect(
    Players.PlayerRemoving,
    function(Player)
        RemoveRow(Player.UserId)
        SelectedTradePlayersUntil[Player.UserId] = nil
        if SelectedTradePlayer == Player then
            SelectedTradePlayer = nil
            ClearSelectedBaseESP()
        end
        if IsCoreMenuOpen() then
            ScheduleCoreScan(0.15)
        end
    end
)
Connect(
    Close.MouseButton1Click,
    Cleanup
)
Connect(
    Close.MouseEnter,
    function()
        TweenService:Create(
            Close,
            TweenInfo.new(0.12),
            {
                BackgroundColor3 =
                    Color3.fromRGB(
                        73,
                        30,
                        95
                    )
            }
        ):Play()
    end
)
Connect(
    Close.MouseLeave,
    function()
        TweenService:Create(
            Close,
            TweenInfo.new(0.12),
            {
                BackgroundColor3 =
                    Color3.fromRGB(
                        46,
                        24,
                        66
                    )
            }
        ):Play()
    end
)
task.spawn(function()
    while Gui and Gui.Parent do
        StrokeGradient.Rotation =
            (
                StrokeGradient.Rotation
                + 3
            ) % 360
        task.wait(0.08)
    end
end)
ScheduleChatScan()
