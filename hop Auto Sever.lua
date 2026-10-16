-- ==============================================================================
-- Project: Luxury Dashboard UI (Real-time Online Global Chat Version)
-- Author: Kit_n67 | Upgraded for Boss Man
-- ==============================================================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local SoundService = game:GetService("SoundService")
local StarterGui = game:GetService("StarterGui")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- XÁC NHẬN ADMIN CHÍNH CHỦ VỚI TÊN @ TÀI KHOẢN ROBROX
local ADMIN_USERNAME = "kit_n67"
local isAdmin = (LocalPlayer.Name:lower() == ADMIN_USERNAME:lower())

-- SERVER DATABASE DÙNG CHUNG CHO CẢ CỘNG ĐỒNG DÙNG SCRIPT
local CHAT_API_URL = "https://luxury-hub-chat-default-rtdb.firebaseio.com/chat.json"

local CONFIG = {
    Theme = "Purple",
    MenuWidth = 720,
    MenuHeight = 460,
    MinWidth = 550,
    MaxWidth = 900,
    MinHeight = 380,
    MaxHeight = 650,
    MaxServerPlayers = 3,
    TeleportOffset = 5,
}

local THEMES = {
    Purple = Color3.fromRGB(140, 70, 255),
    Pink = Color3.fromRGB(255, 60, 150),
    Blue = Color3.fromRGB(50, 120, 255),
    Cyan = Color3.fromRGB(20, 200, 210),
    Green = Color3.fromRGB(40, 200, 100),
    Red = Color3.fromRGB(230, 50, 60),
    Orange = Color3.fromRGB(255, 130, 40),
}

local Accent = THEMES[CONFIG.Theme]
local UserId = LocalPlayer.UserId
local DisplayName = LocalPlayer.DisplayName
local Username = "@" .. LocalPlayer.Name
local AvatarURL = ""

local ClickSound = Instance.new("Sound")
ClickSound.Name = "LuxuryClickSound"
ClickSound.SoundId = "rbxassetid://6895079853" 
ClickSound.Volume = 1
ClickSound.Parent = SoundService

pcall(function()
    AvatarURL = Players:GetUserThumbnailAsync(
        UserId,
        Enum.ThumbnailType.HeadShot,
        Enum.ThumbnailSize.Size420x420
    )
end)

local Old = PlayerGui:FindFirstChild("LuxuryDashboardUI")
if Old then Old:Destroy() end

local function Corner(Object, Radius)
    local C = Instance.new("UICorner")
    C.CornerRadius = UDim.new(0, Radius)
    C.Parent = Object
    return C
end

local function Stroke(Object, Color, Thickness)
    local S = Instance.new("UIStroke")
    S.Color = Color
    S.Thickness = Thickness or 1
    S.Transparency = 0.3
    S.Parent = Object
    return S
end

local Gui = Instance.new("ScreenGui")
Gui.Name = "LuxuryDashboardUI"
Gui.ResetOnSpawn = false
Gui.IgnoreGuiInset = true
Gui.DisplayOrder = 999999
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Gui.Parent = PlayerGui

-- ICON NỔI BẬT MENU (CÓ THỂ KÉO THẢ)
local Icon = Instance.new("ImageButton")
Icon.Name = "MenuIcon"
Icon.Parent = Gui
Icon.Size = UDim2.fromOffset(52, 52)
Icon.Position = UDim2.new(0, 20, 0.5, -26)
Icon.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
Icon.BorderSizePixel = 0
Icon.AutoButtonColor = false
Icon.Image = "rbxthumb://type=Asset&id=113875514885319&w=150&h=150"
Corner(Icon, 26)
Stroke(Icon, Accent, 2)

-- MENU CHÍNH
local Menu = Instance.new("Frame")
Menu.Name = "MainMenu"
Menu.Parent = Gui
Menu.Size = UDim2.fromOffset(CONFIG.MenuWidth, CONFIG.MenuHeight)
Menu.Position = UDim2.new(0.5, -CONFIG.MenuWidth/2, 0.5, -CONFIG.MenuHeight/2)
Menu.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
Menu.BorderSizePixel = 0
Menu.Visible = false
Menu.ClipsDescendants = true
Corner(Menu, 16)
Stroke(Menu, Accent, 1.5)

-- THANH TIÊU ĐỀ KÉO THẢ MENU
local DragHeader = Instance.new("Frame")
DragHeader.Parent = Menu
DragHeader.Size = UDim2.new(1, -110, 0, 35)
DragHeader.Position = UDim2.fromOffset(0, 0)
DragHeader.BackgroundTransparency = 1
DragHeader.ZIndex = 5

local TopBarControls = Instance.new("Frame")
TopBarControls.Parent = Menu
TopBarControls.Size = UDim2.fromOffset(100, 35)
TopBarControls.Position = UDim2.new(1, -105, 0, 8)
TopBarControls.BackgroundTransparency = 1
TopBarControls.ZIndex = 10

local function MakeTopBtn(XOffset, Text, Callback)
    local Btn = Instance.new("TextButton")
    Btn.Parent = TopBarControls
    Btn.Size = UDim2.fromOffset(28, 28)
    Btn.Position = UDim2.fromOffset(XOffset, 0)
    Btn.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
    Btn.BorderSizePixel = 0
    Btn.Text = Text
    Btn.TextColor3 = Color3.fromRGB(200, 200, 210)
    Btn.TextSize = 13
    Btn.Font = Enum.Font.GothamBold
    Corner(Btn, 6)
    
    Btn.MouseButton1Click:Connect(function()
        ClickSound:Play()
        Callback()
    end)
    return Btn
end

local IsMaximized = false
local NormalSize = UDim2.fromOffset(CONFIG.MenuWidth, CONFIG.MenuHeight)
local NormalPos = Menu.Position

MakeTopBtn(0, "—", function() Menu.Visible = false end)

MakeTopBtn(32, "🗖", function()
    IsMaximized = not IsMaximized
    if IsMaximized then
        NormalSize = Menu.Size
        NormalPos = Menu.Position
        Menu.Size = UDim2.new(0, 850, 0, 580)
        Menu.Position = UDim2.new(0.5, -425, 0.5, -290)
    else
        Menu.Size = NormalSize
        Menu.Position = NormalPos
    end
end)

local IconEnabled = true
MakeTopBtn(64, "×", function()
    Menu.Visible = false
    IconEnabled = false
    Icon.Visible = false
end)

-- SIDEBAR BÊN TRÁI
local Sidebar = Instance.new("Frame")
Sidebar.Parent = Menu
Sidebar.Size = UDim2.new(0, 180, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(16, 16, 22)
Sidebar.BorderSizePixel = 0
Corner(Sidebar, 16)

local Logo = Instance.new("TextLabel")
Logo.Parent = Sidebar
Logo.Size = UDim2.new(1, -20, 0, 45)
Logo.Position = UDim2.fromOffset(15, 12)
Logo.BackgroundTransparency = 1
Logo.Text = "LUXURY HUB"
Logo.TextColor3 = Accent
Logo.TextSize = 16
Logo.Font = Enum.Font.GothamBold
Logo.TextXAlignment = Enum.TextXAlignment.Left

local Pages = {}
local NavButtons = {}

local function MakePage(Name)
    local Page = Instance.new("Frame")
    Page.Name = Name
    Page.Parent = Menu
    Page.Size = UDim2.new(1, -200, 1, -20)
    Page.Position = UDim2.fromOffset(190, 10)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    Pages[Name] = Page
    return Page
end

local function MakeNav(Text, Y, PageName)
    local Button = Instance.new("TextButton")
    Button.Parent = Sidebar
    Button.Size = UDim2.new(1, -20, 0, 38)
    Button.Position = UDim2.fromOffset(10, Y)
    Button.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
    Button.BackgroundTransparency = 1
    Button.BorderSizePixel = 0
    Button.Text = Text
    Button.TextColor3 = Color3.fromRGB(150, 150, 165)
    Button.TextSize = 12
    Button.Font = Enum.Font.GothamMedium
    Button.TextXAlignment = Enum.TextXAlignment.Left
    
    local TextPadding = Instance.new("UIPadding")
    TextPadding.PaddingLeft = UDim.new(0, 14)
    TextPadding.Parent = Button

    Corner(Button, 10)
    NavButtons[PageName] = Button
    return Button
end

local HomePage = MakePage("Home")
local PlayersPage = MakePage("Players")
local ServerPage = MakePage("Server")
local ChatPage = MakePage("Chat")
local SettingsPage = MakePage("Settings")
local CreatorPage = MakePage("Creator")

local HomeNav = MakeNav("🏠   Dashboard", 65, "Home")
local PlayersNav = MakeNav("👥   Players", 110, "Players")
local ServerNav = MakeNav("🌐   Server Hop", 155, "Server")
local ChatNav = MakeNav("💬   Global Chat", 200, "Chat")
local SettingsNav = MakeNav("⚙️   Settings", 245, "Settings")
local CreatorNav = MakeNav("👑   Creator Info", 290, "Creator")

local BottomProfile = Instance.new("Frame")
BottomProfile.Parent = Sidebar
BottomProfile.Size = UDim2.new(1, -20, 0, 55)
BottomProfile.Position = UDim2.new(0, 10, 1, -65)
BottomProfile.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
BottomProfile.BorderSizePixel = 0
Corner(BottomProfile, 12)

local BottomAvatar = Instance.new("ImageLabel")
BottomAvatar.Parent = BottomProfile
BottomAvatar.Size = UDim2.fromOffset(38, 38)
BottomAvatar.Position = UDim2.fromOffset(8, 8)
BottomAvatar.BackgroundTransparency = 1
BottomAvatar.Image = AvatarURL
Corner(BottomAvatar, 19)

local BottomName = Instance.new("TextLabel")
BottomName.Parent = BottomProfile
BottomName.Size = UDim2.new(1, -52, 0, 18)
BottomName.Position = UDim2.fromOffset(50, 10)
BottomName.BackgroundTransparency = 1
BottomName.Text = DisplayName
BottomName.TextColor3 = Color3.new(1, 1, 1)
BottomName.TextSize = 11
BottomName.Font = Enum.Font.GothamBold
BottomName.TextXAlignment = Enum.TextXAlignment.Left
BottomName.TextTruncate = Enum.TextTruncate.AtEnd

local BottomUser = Instance.new("TextLabel")
BottomUser.Parent = BottomProfile
BottomUser.Size = UDim2.new(1, -52, 0, 16)
BottomUser.Position = UDim2.fromOffset(50, 28)
BottomUser.BackgroundTransparency = 1
BottomUser.Text = Username
BottomUser.TextColor3 = Accent
BottomUser.TextSize = 10
BottomUser.Font = Enum.Font.Gotham
BottomUser.TextXAlignment = Enum.TextXAlignment.Left

local function PageTitle(Page, Main, Sub)
    local Title = Instance.new("TextLabel")
    Title.Parent = Page
    Title.Size = UDim2.new(1, 0, 0, 30)
    Title.Position = UDim2.fromOffset(5, 8)
    Title.BackgroundTransparency = 1
    Title.Text = Main
    Title.TextColor3 = Color3.new(1, 1, 1)
    Title.TextSize = 20
    Title.Font = Enum.Font.GothamBold
    Title.TextXAlignment = Enum.TextXAlignment.Left

    local Subtitle = Instance.new("TextLabel")
    Subtitle.Parent = Page
    Subtitle.Size = UDim2.new(1, 0, 0, 18)
    Subtitle.Position = UDim2.fromOffset(5, 38)
    Subtitle.BackgroundTransparency = 1
    Subtitle.Text = Sub
    Subtitle.TextColor3 = Color3.fromRGB(140, 140, 155)
    Subtitle.TextSize = 11
    Subtitle.Font = Enum.Font.Gotham
    Subtitle.TextXAlignment = Enum.TextXAlignment.Left
end

PageTitle(HomePage, "Dashboard Overview", "Thống kê hệ thống và thông tin cá nhân")

local function StatCard(Page, X, Y, W, Label)
    local Card = Instance.new("Frame")
    Card.Parent = Page
    Card.Size = UDim2.fromOffset(W, 75)
    Card.Position = UDim2.fromOffset(X, Y)
    Card.BackgroundColor3 = Color3.fromRGB(18, 18, 25)
    Card.BorderSizePixel = 0
    Corner(Card, 12)
    Stroke(Card, Color3.fromRGB(40, 40, 55), 1)

    local L = Instance.new("TextLabel")
    L.Parent = Card
    L.Size = UDim2.new(1, -20, 0, 18)
    L.Position = UDim2.fromOffset(10, 10)
    L.BackgroundTransparency = 1
    L.Text = Label
    L.TextColor3 = Color3.fromRGB(130, 130, 145)
    L.TextSize = 10
    L.Font = Enum.Font.GothamMedium
    L.TextXAlignment = Enum.TextXAlignment.Left

    local V = Instance.new("TextLabel")
    V.Parent = Card
    V.Size = UDim2.new(1, -20, 0, 32)
    V.Position = UDim2.fromOffset(10, 30)
    V.BackgroundTransparency = 1
    V.Text = "--"
    V.TextColor3 = Accent
    V.TextSize = 20
    V.Font = Enum.Font.GothamBold
    V.TextXAlignment = Enum.TextXAlignment.Left
    return V
end

local FPSValue = StatCard(HomePage, 5, 75, 150, "FRAME RATE (FPS)")
local PingValue = StatCard(HomePage, 160, 75, 150, "NETWORK PING")
local PlayerCount = StatCard(HomePage, 5, 158, 150, "SERVER PLAYERS")
local UserIDValue = StatCard(HomePage, 160, 158, 150, "ROBLOX USER ID")
UserIDValue.Text = tostring(UserId)

-- TAB CREATOR
PageTitle(CreatorPage, "Developer Information", "Thông tin chi tiết về nhà phát triển script")
local CreatorCard = Instance.new("Frame")
CreatorCard.Parent = CreatorPage
CreatorCard.Size = UDim2.new(1, -5, 0, 100)
CreatorCard.Position = UDim2.fromOffset(0, 70)
CreatorCard.BackgroundColor3 = Color3.fromRGB(18, 18, 25)
CreatorCard.BorderSizePixel = 0
Corner(CreatorCard, 12)
Stroke(CreatorCard, Accent, 1.5)

local CreatorTitle = Instance.new("TextLabel")
CreatorTitle.Parent = CreatorCard
CreatorTitle.Size = UDim2.new(1, -20, 0, 24)
CreatorTitle.Position = UDim2.fromOffset(15, 15)
CreatorTitle.BackgroundTransparency = 1
CreatorTitle.Text = "👑  SCRIPT CREATOR: Kit_n67"
CreatorTitle.TextColor3 = Accent
CreatorTitle.TextSize = 14
CreatorTitle.Font = Enum.Font.GothamBold
CreatorTitle.TextXAlignment = Enum.TextXAlignment.Left

local CreatorDesc = Instance.new("TextLabel")
CreatorDesc.Parent = CreatorCard
CreatorDesc.Size = UDim2.new(1, -20, 0, 40)
CreatorDesc.Position = UDim2.fromOffset(15, 45)
CreatorDesc.BackgroundTransparency = 1
CreatorDesc.Text = "Luxury Dashboard v1.0 - Được tinh chỉnh và phát triển tối ưu riêng cho hệ thống game Roblox."
CreatorDesc.TextColor3 = Color3.fromRGB(160, 160, 175)
CreatorDesc.TextSize = 11
CreatorDesc.Font = Enum.Font.Gotham
CreatorDesc.TextXAlignment = Enum.TextXAlignment.Left
CreatorDesc.TextWrapped = true

-- ========================================================
-- TAB GLOBAL CHAT & SERVER DATABASE ĐỒNG BỘ THỜI GIAN THỰC
-- ========================================================
PageTitle(ChatPage, "Global Community Chat", "Trò chuyện trực tuyến cùng những người dùng script khác")

-- BẢNG GHIM TIN NHẮN TẠI ĐẦU CHAT
local PinnedBanner = Instance.new("Frame")
PinnedBanner.Parent = ChatPage
PinnedBanner.Size = UDim2.new(1, -5, 0, 36)
PinnedBanner.Position = UDim2.fromOffset(0, 62)
PinnedBanner.BackgroundColor3 = Color3.fromRGB(22, 18, 30)
PinnedBanner.BorderSizePixel = 0
Corner(PinnedBanner, 8)
Stroke(PinnedBanner, Accent, 1)

local PinIcon = Instance.new("TextLabel")
PinIcon.Parent = PinnedBanner
PinIcon.Size = UDim2.fromOffset(30, 36)
PinIcon.Position = UDim2.fromOffset(5, 0)
PinIcon.BackgroundTransparency = 1
PinIcon.Text = "📌"
PinIcon.TextSize = 14

local PinnedText = Instance.new("TextLabel")
PinnedText.Parent = PinnedBanner
PinnedText.Size = UDim2.new(1, -40, 1, 0)
PinnedText.Position = UDim2.fromOffset(35, 0)
PinnedText.BackgroundTransparency = 1
PinnedText.Text = "Tin nhắn ghim từ Admin: Chào mừng bạn đến với Luxury Hub!"
PinnedText.TextColor3 = Color3.fromRGB(240, 220, 255)
PinnedText.TextSize = 11
PinnedText.Font = Enum.Font.GothamBold
PinnedText.TextXAlignment = Enum.TextXAlignment.Left
PinnedText.TextTruncate = Enum.TextTruncate.AtEnd

-- KHUNG CHAT CONTAINER
local ChatBoxContainer = Instance.new("ScrollingFrame")
ChatBoxContainer.Parent = ChatPage
ChatBoxContainer.Size = UDim2.new(1, -5, 1, -165)
ChatBoxContainer.Position = UDim2.fromOffset(0, 105)
ChatBoxContainer.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
ChatBoxContainer.BorderSizePixel = 0
ChatBoxContainer.ScrollBarThickness = 3
ChatBoxContainer.ScrollBarImageColor3 = Accent
Corner(ChatBoxContainer, 10)
Stroke(ChatBoxContainer, Color3.fromRGB(40, 40, 55), 1)

local ChatLayout = Instance.new("UIListLayout")
ChatLayout.Parent = ChatBoxContainer
ChatLayout.Padding = UDim.new(0, 6)
ChatLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    ChatBoxContainer.CanvasSize = UDim2.new(0, 0, 0, ChatLayout.AbsoluteContentSize.Y + 10)
end)

local ChatInput = Instance.new("TextBox")
ChatInput.Parent = ChatPage
ChatInput.Size = UDim2.new(1, -75, 0, 40)
ChatInput.Position = UDim2.new(0, 0, 1, -50)
ChatInput.BackgroundColor3 = Color3.fromRGB(18, 18, 25)
ChatInput.BorderSizePixel = 0
ChatInput.PlaceholderText = "Nhập nội dung tin nhắn..."
ChatInput.PlaceholderColor3 = Color3.fromRGB(100, 100, 115)
ChatInput.Text = ""
ChatInput.TextColor3 = Color3.new(1, 1, 1)
ChatInput.TextSize = 12
ChatInput.Font = Enum.Font.Gotham
Corner(ChatInput, 10)
Stroke(ChatInput, Color3.fromRGB(40, 40, 55), 1)

local InputPadding = Instance.new("UIPadding")
InputPadding.PaddingLeft = UDim.new(0, 12)
InputPadding.Parent = ChatInput

local SendChatBtn = Instance.new("TextButton")
SendChatBtn.Parent = ChatPage
SendChatBtn.Size = UDim2.fromOffset(70, 40)
SendChatBtn.Position = UDim2.new(1, -70, 1, -50)
SendChatBtn.BackgroundColor3 = Accent
SendChatBtn.BorderSizePixel = 0
SendChatBtn.Text = "GỬI"
SendChatBtn.TextColor3 = Color3.new(1, 1, 1)
SendChatBtn.TextSize = 12
SendChatBtn.Font = Enum.Font.GothamBold
Corner(SendChatBtn, 10)

local RenderedMessageIDs = {}

local function AddChatMessage(msgId, senderName, senderAvatar, messageText, isSpecialAdmin)
    if RenderedMessageIDs[msgId] then return end
    RenderedMessageIDs[msgId] = true

    local Row = Instance.new("Frame")
    Row.Parent = ChatBoxContainer
    Row.Size = UDim2.new(1, -10, 0, 45)
    Row.BackgroundTransparency = 1

    local isSystem = (senderName == "System Bot")

    if not isSystem then
        local Avatar = Instance.new("ImageLabel")
        Avatar.Parent = Row
        Avatar.Size = UDim2.fromOffset(32, 32)
        Avatar.Position = UDim2.fromOffset(5, 6)
        Avatar.BackgroundTransparency = 1
        Avatar.Image = senderAvatar ~= "" and senderAvatar or AvatarURL
        Corner(Avatar, 16)
    end

    local textOffsetX = isSystem and 10 or 45
    local textWidthOffset = isSystem and -20 or -85

    local NameLabel = Instance.new("TextLabel")
    NameLabel.Parent = Row
    NameLabel.Size = UDim2.new(1, textWidthOffset, 0, 16)
    NameLabel.Position = UDim2.fromOffset(textOffsetX, 4)
    NameLabel.BackgroundTransparency = 1
    NameLabel.Text = senderName .. (isSpecialAdmin and " 👑 [ADMIN]" or "")
    NameLabel.TextColor3 = isSpecialAdmin and Color3.fromRGB(255, 100, 100) or Accent
    NameLabel.TextSize = 11
    NameLabel.Font = Enum.Font.GothamBold
    NameLabel.TextXAlignment = Enum.TextXAlignment.Left

    local TextLabel = Instance.new("TextLabel")
    TextLabel.Parent = Row
    TextLabel.Size = UDim2.new(1, textWidthOffset, 0, 20)
    TextLabel.Position = UDim2.fromOffset(textOffsetX, 20)
    TextLabel.BackgroundTransparency = 1
    TextLabel.Text = messageText
    TextLabel.TextColor3 = Color3.fromRGB(220, 220, 230)
    TextLabel.TextSize = 12
    TextLabel.Font = Enum.Font.Gotham
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel.TextWrapped = true

    if isAdmin and not isSystem then
        local InlinePinBtn = Instance.new("TextButton")
        InlinePinBtn.Parent = Row
        InlinePinBtn.Size = UDim2.fromOffset(28, 28)
        InlinePinBtn.Position = UDim2.new(1, -30, 0.5, -14)
        InlinePinBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
        InlinePinBtn.BorderSizePixel = 0
        InlinePinBtn.Text = "📌"
        InlinePinBtn.TextSize = 12
        Corner(InlinePinBtn, 6)

        InlinePinBtn.MouseButton1Click:Connect(function()
            ClickSound:Play()
            PinnedText.Text = "Tin nhắn ghim từ Admin (" .. senderName .. "): " .. messageText
        end)
    end

    ChatBoxContainer.CanvasPosition = Vector2.new(0, 99999)
end

-- TIN NHẮN BẮT ĐẦU CỦA BOT CỐ ĐỊNH
AddChatMessage("sys_init", "System Bot", "", "Hệ thống Global Chat trực tuyến đã sẵn sàng! Chúc bạn chơi game vui vẻ.", false)

-- HÀM GỬI TIN NHẮN LÊN DATABASE DÙNG CHUNG
local function SendMessageToDatabase(text)
    local payload = HttpService:JSONEncode({
        sender = DisplayName,
        avatar = AvatarURL,
        message = text,
        isAdmin = isAdmin,
        time = os.time()
    })
    
    pcall(function()
        if request then
            request({
                Url = CHAT_API_URL,
                Method = "POST",
                Headers = {["Content-Type"] = "application/json"},
                Body = payload
            })
        elseif http_request then
            http_request({
                Url = CHAT_API_URL,
                Method = "POST",
                Headers = {["Content-Type"] = "application/json"},
                Body = payload
            })
        end
    end)
end

-- HÀM NHẬN TIN NHẮN THỜI GIAN THỰC TỪ SERVER DATABASE
local function SyncMessagesFromDatabase()
    local success, response = pcall(function()
        return game:HttpGet(CHAT_API_URL)
    end)

    if success and response and response ~= "null" then
        local decodeSuccess, data = pcall(function()
            return HttpService:JSONDecode(response)
        end)

        if decodeSuccess and data then
            local msgList = {}
            for id, msgData in pairs(data) do
                msgData.id = id
                table.insert(msgList, msgData)
            end

            table.sort(msgList, function(a, b)
              return (a.time or 0) < (b.time or 0)
            end)

            for _, msgData in ipairs(msgList) do
                AddChatMessage(
                    msgData.id,
                    msgData.sender or "Unknown",
                    msgData.avatar or "",
                    msgData.message or "",
                    msgData.isAdmin or false
                )
            end
        end
    end
end

-- QUÉT TIN NHẮN TỰ ĐỘNG MỖI 3 GIÂY
task.spawn(function()
    while Gui.Parent do
        SyncMessagesFromDatabase()
        task.wait(3)
    end
end)

SendChatBtn.MouseButton1Click:Connect(function()
    local txt = ChatInput.Text
    if txt ~= "" and #txt <= 150 then
        ChatInput.Text = ""
        SendMessageToDatabase(txt)
        task.wait(0.3)
        SyncMessagesFromDatabase()
    end
end)

-- PLAYERS & SERVER PAGES
PageTitle(PlayersPage, "Active Players", "Danh sách người chơi đang ở cùng server")
local PlayerList = Instance.new("ScrollingFrame")
PlayerList.Parent = PlayersPage
PlayerList.Size = UDim2.new(1, -5, 1, -75)
PlayerList.Position = UDim2.fromOffset(0, 65)
PlayerList.BackgroundTransparency = 1
PlayerList.BorderSizePixel = 0
PlayerList.ScrollBarThickness = 3
PlayerList.ScrollBarImageColor3 = Accent

local PlayerLayout = Instance.new("UIListLayout")
PlayerLayout.Parent = PlayerList
PlayerLayout.Padding = UDim.new(0, 8)
PlayerLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    PlayerList.CanvasSize = UDim2.new(0, 0, 0, PlayerLayout.AbsoluteContentSize.Y + 10)
end)

local function TeleportToPlayer(Target)
    if Target == LocalPlayer then return end
    local MyChar, TChar = LocalPlayer.Character, Target.Character
    if MyChar and TChar and TChar:FindFirstChild("HumanoidRootPart") then
        MyChar:PivotTo(TChar.HumanoidRootPart.CFrame * CFrame.new(0, 0, CONFIG.TeleportOffset))
    end
end

local function RefreshPlayers()
    for _, Child in ipairs(PlayerList:GetChildren()) do
        if Child:IsA("Frame") then Child:Destroy() end
    end
    for _, Target in ipairs(Players:GetPlayers()) do
        if Target ~= LocalPlayer then
            local Row = Instance.new("Frame")
            Row.Parent = PlayerList
            Row.Size = UDim2.new(1, -5, 0, 60)
            Row.BackgroundColor3 = Color3.fromRGB(18, 18, 25)
            Row.BorderSizePixel = 0
            Corner(Row, 12)

            local Name = Instance.new("TextLabel")
            Name.Parent = Row
            Name.Size = UDim2.new(1, -110, 0, 22)
            Name.Position = UDim2.fromOffset(14, 10)
            Name.BackgroundTransparency = 1
            Name.Text = Target.DisplayName
            Name.TextColor3 = Color3.new(1, 1, 1)
            Name.TextSize = 13
            Name.Font = Enum.Font.GothamBold
            Name.TextXAlignment = Enum.TextXAlignment.Left

            local User = Instance.new("TextLabel")
            User.Parent = Row
            User.Size = UDim2.new(1, -110, 0, 18)
            User.Position = UDim2.fromOffset(14, 32)
            User.BackgroundTransparency = 1
            User.Text = "@" .. Target.Name
            User.TextColor3 = Color3.fromRGB(130, 130, 145)
            User.TextSize = 11
            User.Font = Enum.Font.Gotham
            User.TextXAlignment = Enum.TextXAlignment.Left

            local Teleport = Instance.new("TextButton")
            Teleport.Parent = Row
            Teleport.Size = UDim2.fromOffset(75, 34)
            Teleport.Position = UDim2.new(1, -85, 0.5, -17)
            Teleport.BackgroundColor3 = Accent
            Teleport.BorderSizePixel = 0
            Teleport.Text = "TELEPORT"
            Teleport.TextColor3 = Color3.new(1, 1, 1)
            Teleport.TextSize = 11
            Teleport.Font = Enum.Font.GothamBold
            Corner(Teleport, 8)

            Teleport.MouseButton1Click:Connect(function()
                TeleportToPlayer(Target)
            end)
        end
    end
end
RefreshPlayers()
Players.PlayerAdded:Connect(function() task.wait(0.2) RefreshPlayers() end)
Players.PlayerRemoving:Connect(function() task.wait(0.1) RefreshPlayers() end)

PageTitle(ServerPage, "Server Hop Hub", "Tìm kiếm và kết nối nhanh vào các server ít người")
local FindServers = Instance.new("TextButton")
FindServers.Parent = ServerPage
FindServers.Size = UDim2.new(1, -5, 0, 44)
FindServers.Position = UDim2.fromOffset(0, 65)
FindServers.BackgroundColor3 = Accent
FindServers.BorderSizePixel = 0
FindServers.Text = "🔄  TÌM LẠI SERVER"
FindServers.TextColor3 = Color3.new(1, 1, 1)
FindServers.TextSize = 12
FindServers.Font = Enum.Font.GothamBold
Corner(FindServers, 10)

local ServerStatus = Instance.new("TextLabel")
ServerStatus.Parent = ServerPage
ServerStatus.Size = UDim2.new(1, -5, 0, 22)
ServerStatus.Position = UDim2.fromOffset(0, 114)
ServerStatus.BackgroundTransparency = 1
ServerStatus.Text = "Trạng thái: Sẵn sàng quét server"
ServerStatus.TextColor3 = Color3.fromRGB(140, 140, 155)
ServerStatus.TextSize = 11
ServerStatus.Font = Enum.Font.Gotham
ServerStatus.TextXAlignment = Enum.TextXAlignment.Left

local ServerList = Instance.new("ScrollingFrame")
ServerList.Parent = ServerPage
ServerList.Size = UDim2.new(1, -5, 1, -145)
ServerList.Position = UDim2.fromOffset(0, 140)
ServerList.BackgroundTransparency = 1
ServerList.BorderSizePixel = 0
ServerList.ScrollBarThickness = 3
ServerList.ScrollBarImageColor3 = Accent

local ServerLayout = Instance.new("UIListLayout")
ServerLayout.Parent = ServerList
ServerLayout.Padding = UDim.new(0, 8)
ServerLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    ServerList.CanvasSize = UDim2.new(0, 0, 0, ServerLayout.AbsoluteContentSize.Y + 10)
end)

local function ClearServers()
    for _, Child in ipairs(ServerList:GetChildren()) do
        if Child:IsA("Frame") then Child:Destroy() end
    end
end

local function FetchServerPage(Cursor)
    local URL = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
    if Cursor then URL = URL .. "&cursor=" .. HttpService:UrlEncode(Cursor) end
    local Success, Response = pcall(function() return game:HttpGet(URL) end)
    if not Success or not Response then return nil end
    local DecodeSuccess, Data = pcall(function() return HttpService:JSONDecode(Response) end)
    return DecodeSuccess and Data or nil
end

local function GetServers()
    local Servers = {}
    local Cursor = nil
    local PagesScanned = 0
    while PagesScanned < 15 do
        PagesScanned += 1
        local Data = FetchServerPage(Cursor)
        if not Data or not Data.data then break end
        for _, Server in ipairs(Data.data) do
            local Playing = tonumber(Server.playing) or 999
            if Server.id ~= game.JobId and Playing <= CONFIG.MaxServerPlayers and Playing > 0 then
                table.insert(Servers, Server)
            end
        end
        Cursor = Data.nextPageCursor
        if not Cursor then break end
        task.wait(0.05)
    end
    table.sort(Servers, function(a, b)
        return (tonumber(a.playing) or 999) < (tonumber(b.playing) or 999)
    end)
    return Servers
end

local function AddServer(Server, Index)
    local Playing = tonumber(Server.playing) or 0
    local MaxPlayers = tonumber(Server.maxPlayers) or 0

    local Row = Instance.new("Frame")
    Row.Parent = ServerList
    Row.Size = UDim2.new(1, -5, 0, 60)
    Row.BackgroundColor3 = Color3.fromRGB(18, 18, 25)
    Row.BorderSizePixel = 0
    Corner(Row, 12)

    local Info = Instance.new("TextLabel")
    Info.Parent = Row
    Info.Size = UDim2.new(1, -80, 1, 0)
    Info.Position = UDim2.fromOffset(14, 0)
    Info.BackgroundTransparency = 1
    Info.Text = "SERVER #" .. Index .. " (" .. Playing .. " NGƯỜI)\n👥 Tình trạng: " .. Playing .. " / " .. MaxPlayers
    Info.TextColor3 = Color3.new(1, 1, 1)
    Info.TextSize = 11
    Info.Font = Enum.Font.GothamMedium
    Info.TextXAlignment = Enum.TextXAlignment.Left

    local Join = Instance.new("TextButton")
    Join.Parent = Row
    Join.Size = UDim2.fromOffset(50, 36)
    Join.Position = UDim2.new(1, -60, 0.5, -18)
    Join.BackgroundColor3 = Accent
    Join.BorderSizePixel = 0
    Join.Text = "🚀"
    Join.TextColor3 = Color3.new(1, 1, 1)
    Join.TextSize = 16
    Join.Font = Enum.Font.GothamBold
    Corner(Join, 8)

    Join.MouseButton1Click:Connect(function()
        Join.Active = false
        Join.Text = "..."
        TeleportService:TeleportToPlaceInstance(game.PlaceId, Server.id, LocalPlayer)
    end)
end

local SearchingServers = false
local CurrentFoundServers = {}

FindServers.MouseButton1Click:Connect(function()
    if SearchingServers then return end
    SearchingServers = true
    ClearServers()
    FindServers.Text = "⏳  ĐANG QUÉT SERVER..."
    ServerStatus.Text = "Trạng thái: Đang duyệt các trang server công khai..."

    task.spawn(function()
        CurrentFoundServers = GetServers()
        if #CurrentFoundServers == 0 then
            ServerStatus.Text = "❌ Không tìm thấy server phù hợp, hãy thử lại!"
        else
            ServerStatus.Text = "✓ Đã tìm thấy " .. #CurrentFoundServers .. " server ít người"
            for i, Server in ipairs(CurrentFoundServers) do
                AddServer(Server, i)
            end
        end
        SearchingServers = false
        FindServers.Text = "🔄  TÌM LẠI SERVER"
    end)
end)

PageTitle(SettingsPage, "Customization", "Tùy chỉnh giao diện và màu chủ đạo")
local ThemeLabel = Instance.new("TextLabel")
ThemeLabel.Parent = SettingsPage
ThemeLabel.Size = UDim2.new(1, 0, 0, 24)
ThemeLabel.Position = UDim2.fromOffset(0, 70)
ThemeLabel.BackgroundTransparency = 1
ThemeLabel.Text = "CHỌN MÀU GIAO DIỆN (THEME COLOR)"
ThemeLabel.TextColor3 = Color3.new(1, 1, 1)
ThemeLabel.TextSize = 11
ThemeLabel.Font = Enum.Font.GothamBold
ThemeLabel.TextXAlignment = Enum.TextXAlignment.Left

local ThemeContainer = Instance.new("Frame")
ThemeContainer.Parent = SettingsPage
ThemeContainer.Size = UDim2.new(1, 0, 0, 160)
ThemeContainer.Position = UDim2.fromOffset(0, 100)
ThemeContainer.BackgroundTransparency = 1

local Grid = Instance.new("UIGridLayout")
Grid.Parent = ThemeContainer
Grid.CellSize = UDim2.fromOffset(108, 40)
Grid.CellPadding = UDim2.fromOffset(8, 8)

for Name, Color in pairs(THEMES) do
    local Button = Instance.new("TextButton")
    Button.Parent = ThemeContainer
    Button.BackgroundColor3 = Color
    Button.BorderSizePixel = 0
    Button.Text = Name
    Button.TextColor3 = Color3.new(1, 1, 1)
    Button.TextSize = 11
    Button.Font = Enum.Font.GothamBold
    Corner(Button, 8)

    Button.MouseButton1Click:Connect(function()
        Accent = Color
        Menu.UIStroke.Color = Accent
        Icon.UIStroke.Color = Accent
        Logo.TextColor3 = Accent
        BottomUser.TextColor3 = Accent
        PlayerList.ScrollBarImageColor3 = Accent
        ServerList.ScrollBarImageColor3 = Accent
        ChatBoxContainer.ScrollBarImageColor3 = Accent
        FindServers.BackgroundColor3 = Accent
        SendChatBtn.BackgroundColor3 = Accent

        for PageName, Nav in pairs(NavButtons) do
            if Pages[PageName].Visible then
                Nav.BackgroundColor3 = Accent
                Nav.TextColor3 = Color3.new(1, 1, 1)
            end
        end
    end)
end

local function ShowPage(Name)
    for PageName, Page in pairs(Pages) do
        Page.Visible = (PageName == Name)
    end
    for PageName, Button in pairs(NavButtons) do
        if PageName == Name then
            Button.BackgroundColor3 = Accent
            Button.TextColor3 = Color3.new(1, 1, 1)
        else
            Button.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
            Button.TextColor3 = Color3.fromRGB(150, 150, 165)
        end
    end
end

HomeNav.MouseButton1Click:Connect(function() ShowPage("Home") end)
PlayersNav.MouseButton1Click:Connect(function() ShowPage("Players") end)
ServerNav.MouseButton1Click:Connect(function() ShowPage("Server") end)
ChatNav.MouseButton1Click:Connect(function() ShowPage("Chat") end)
SettingsNav.MouseButton1Click:Connect(function() ShowPage("Settings") end)
CreatorNav.MouseButton1Click:Connect(function() ShowPage("Creator") end)

ShowPage("Home")

local Frames = 0
local LastFPS = os.clock()
RunService.RenderStepped:Connect(function()
    Frames += 1
    local Now = os.clock()
    if Now - LastFPS >= 1 then
        FPSValue.Text = tostring(Frames)
        Frames = 0
        LastFPS = Now
    end
end)

task.spawn(function()
    while Gui.Parent do
        local Ping = 0
        pcall(function() Ping = Stats.Network.ServerStatsItem["Data Ping"]:GetValue() end)
        PingValue.Text = math.floor(Ping) .. " ms"
        PlayerCount.Text = tostring(#Players:GetPlayers())
        task.wait(1)
    end
end)

Icon.MouseButton1Click:Connect(function()
    if IconEnabled then
        Menu.Visible = not Menu.Visible
    end
end)

UserInputService.InputBegan:Connect(function(input, processed)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        if not Menu.Visible then return end
        local pos = input.Position

        local function isInside(gui)
            if not gui or not gui.Parent then return false end
            local absPos, absSize = gui.AbsolutePosition, gui.AbsoluteSize
            return pos.X >= absPos.X and pos.X <= (absPos.X + absSize.X) 
               and pos.Y >= absPos.Y and pos.Y <= (absPos.Y + absSize.Y)
        end

        if isInside(Icon) then return end
        if isInside(Menu) then ClickSound:Play() end
    end
end)

-- KÉO THẢ MENU VÀ ICON
local DraggingMenu, MenuDragStart, MenuStartPosition = false, nil, nil
DragHeader.InputBegan:Connect(function(Input)
    if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
        DraggingMenu = true
        MenuDragStart = Input.Position
        MenuStartPosition = Menu.Position
    end
end)

local DraggingIcon, IconDragStart, IconStartPosition = false, nil, nil
Icon.InputBegan:Connect(function(Input)
    if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
        DraggingIcon = true
        IconDragStart = Input.Position
        IconStartPosition = Icon.Position
    end
end)

UserInputService.InputChanged:Connect(function(Input)
    if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
        if DraggingMenu then
            local Delta = Input.Position - MenuDragStart
            Menu.Position = UDim2.new(MenuStartPosition.X.Scale, MenuStartPosition.X.Offset + Delta.X, MenuStartPosition.Y.Scale, MenuStartPosition.Y.Offset + Delta.Y)
        elseif DraggingIcon then
            local Delta = Input.Position - IconDragStart
            Icon.Position = UDim2.new(IconStartPosition.X.Scale, IconStartPosition.X.Offset + Delta.X, IconStartPosition.Y.Scale, IconStartPosition.Y.Offset + Delta.Y)
        end
    end
end)

UserInputService.InputEnded:Connect(function(Input)
    if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
        DraggingMenu = false
        DraggingIcon = false
    end
end)

-- VÙNG GÓC DƯỚI BÊN PHẢI (TÀNG HÌNH ĐỂ KÉO THU PHÓNG)
local Resize = Instance.new("TextButton")
Resize.Parent = Menu
Resize.Size = UDim2.fromOffset(25, 25)
Resize.Position = UDim2.new(1, -25, 1, -25)
Resize.BackgroundTransparency = 1
Resize.BorderSizePixel = 0
Resize.Text = ""

local Resizing, ResizeStart, OriginalSize = false, nil, nil
Resize.InputBegan:Connect(function(Input)
    if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
        Resizing = true
        ResizeStart = Input.Position
        OriginalSize = Menu.AbsoluteSize
    end
end)

UserInputService.InputChanged:Connect(function(Input)
    if not Resizing then return end
    if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
        local Delta = Input.Position - ResizeStart
        local W = math.clamp(OriginalSize.X + Delta.X, CONFIG.MinWidth, CONFIG.MaxWidth)
        local H = math.clamp(OriginalSize.Y + Delta.Y, CONFIG.MinHeight, CONFIG.MaxHeight)
        Menu.Size = UDim2.fromOffset(W, H)
    end
end)

UserInputService.InputEnded:Connect(function(Input)
    if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
        Resizing = false
    end
end)

-- THÔNG BÁO KHỞI ĐỘNG KHI BẬT SCRIPT
pcall(function()
    StarterGui:SetCore("SendNotification", {
        Title = "Luxury Dashboard",
        Text = isAdmin and "Chào mừng Admin kit_n67 đã đăng nhập!" or "Script đã bật thành công!",
        Icon = "rbxthumb://type=Asset&id=113875514885319&w=150&h=150",
        Duration = 4,
    })
end)

print("Luxury Dashboard Online Global Chat Sync Ready!")
