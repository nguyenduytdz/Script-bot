-- ==========================================
-- CẤU HÌNH THÔNG TIN CỦA BẠN
-- ==========================================
local WebhookURL = "https://discord.com/api/webhooks/1570446166754201803/pPCEG-HczkXcUA2fWQd6pYo62wgLmeBxf1ri812j1AO2W87wWCz1LzoF-6s8tgem5yEo"
local DiscordUserID = "1494250347731091497"

local CURRENT_MIN_MONEY = 0

-- ==========================================
-- KHỞI TẠO DỊCH VỤ & BIẾN TRẠNG THÁI
-- ==========================================
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local MarketplaceService = game:GetService("MarketplaceService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local httpRequest = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request
if not httpRequest then
    warn("❌ Executor của bạn không hỗ trợ hàm HTTP Request!")
    return
end

local isRunning = true
local startTime = tick()
local petsCaughtCount = 0
local processedItems = {} 

local cachedGameName = "Throw Food For Animals"
pcall(function()
    cachedGameName = MarketplaceService:GetProductInfo(game.PlaceId).Name
end)

-- ==========================================
-- LƯU TRỮ TÀI KHOẢN TRONG SCRIPT
-- ==========================================
local SavedAccounts = {
    {
        Name = "Seoyeon Kim",
        Email = "seoyeon@example.com",
        Password = "lumen2026",
        Phone = "Không có",
        Workspace = "New Era Studio"
    }
}
local ActiveAccount = SavedAccounts[1]
local isAuthenticated = false

local function findAccount(email, password)
    local targetEmail = string.lower((email or ""):gsub("^%s+", ""):gsub("%s+$", ""))
    for _, acc in ipairs(SavedAccounts) do
        if string.lower(acc.Email) == targetEmail and acc.Password == password then
            return acc
        end
    end
    return nil
end

local function findAccountByEmail(email)
    local targetEmail = string.lower((email or ""):gsub("^%s+", ""):gsub("%s+$", ""))
    for _, acc in ipairs(SavedAccounts) do
        if string.lower(acc.Email) == targetEmail then
            return acc
        end
    end
    return nil
end

-- ==========================================
-- BẢNG HẬU TỐ SỐ LỚN
-- ==========================================
local Suffixes = {
    "", "K", "M", "B", "T", "Qa", "Qi", "Sx", "Sp", "Oc", "No",
    "Dc", "Ud", "Dd", "Td", "Qad", "Qid", "Sxd", "Spd", "Ocd", "Nod",
    "Vg", "Uvg", "Dvg", "Tvg", "Qavg", "Qivg", "Sxvg", "Spvg", "Ocvg", "Novg",
    "Tg", "Utg", "Dtg", "Ttg", "Qatg", "Qitg", "Sxtg", "Sptg", "Octg", "Notg"
}

local function parseRawMoneyToNumber(val)
    if type(val) == "number" then return val end
    if type(val) ~= "string" then return 0 end
    val = val:gsub("%$", ""):gsub("/s", ""):gsub(",", ""):gsub("%s+", "")
    local numPart = tonumber(val:match("[%d%.]+"))
    if not numPart then return 0 end
    local suffixPart = string.upper(val:match("[%a]+") or "")
    local multipliers = {
        K = 1e3, M = 1e6, B = 1e9, T = 1e12,
        QA = 1e15, QI = 1e18, SX = 1e21, SP = 1e24, OC = 1e27, NO = 1e30,
        DC = 1e33, UD = 1e36, DD = 1e39, TD = 1e42, QAD = 1e45, QID = 1e48,
        SXD = 1e51, SPD = 1e54, OCD = 1e57, NOD = 1e60, VG = 1e63
    }
    if multipliers[suffixPart] then
        return numPart * multipliers[suffixPart]
    end
    return numPart
end

local function formatBigNumber(val)
    if type(val) == "string" then
        if string.find(val, "e%+") or tonumber(val) then val = tonumber(val) else return val end
    end
    local num = tonumber(val)
    if not num then return "Không rõ" end
    if num < 1000 then return string.format("%.2f", num):gsub("%.00$", "") end
    local tier = math.floor(math.log10(math.abs(num)) / 3)
    local suffix = Suffixes[tier + 1]
    if suffix then
        local scaled = num / (10 ^ (tier * 3))
        local formatted = string.format("%.2f", scaled):gsub("%.", ",")
        return formatted .. suffix:lower()
    else
        return string.format("%.2e", num)
    end
end

-- ==========================================
-- TẠO GIAO DIỆN (UI)
-- ==========================================
if CoreGui:FindFirstChild("ThrowFoodAutoMenu") then
    CoreGui.ThrowFoodAutoMenu:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ThrowFoodAutoMenu"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

local function onButtonClicked(btn, callback)
    local connection
    connection = btn.MouseButton1Click:Connect(callback)
    if not connection then
        btn.Activated:Connect(callback)
    end
end

local ToggleIconBtn = Instance.new("TextButton")
ToggleIconBtn.Name = "ToggleIconBtn"
ToggleIconBtn.Size = UDim2.new(0, 45, 0, 45)
ToggleIconBtn.Position = UDim2.new(0.05, 0, 0.12, 0)
ToggleIconBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
ToggleIconBtn.TextColor3 = Color3.fromRGB(255, 220, 50)
ToggleIconBtn.TextSize = 22
ToggleIconBtn.Font = Enum.Font.GothamBold
ToggleIconBtn.Text = "⚡"
ToggleIconBtn.Active = true
ToggleIconBtn.Draggable = false
ToggleIconBtn.Visible = false
ToggleIconBtn.Parent = ScreenGui
Instance.new("UICorner", ToggleIconBtn).CornerRadius = UDim.new(1, 0)
local IconStroke = Instance.new("UIStroke")
IconStroke.Color = Color3.fromRGB(224, 86, 36)
IconStroke.Thickness = 2
IconStroke.Parent = ToggleIconBtn

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 326, 0, 385)
MainFrame.Position = UDim2.new(0.05, 0, 0.18, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(19, 20, 28)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = false
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 18)
local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(123, 97, 255)
MainStroke.Transparency = 0.65
MainStroke.Thickness = 1.2
MainStroke.Parent = MainFrame

local isMenuVisible = true
onButtonClicked(ToggleIconBtn, function()
    if not isAuthenticated then return end
    isMenuVisible = not isMenuVisible
    MainFrame.Visible = isMenuVisible
    TweenService:Create(ToggleIconBtn, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Rotation = ToggleIconBtn.Rotation + 360
    }):Play()
end)

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -16, 0, 30)
TitleLabel.Position = UDim2.new(0, 8, 0, 4)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "🐾 Throw Food Auto Logger • New Era"
TitleLabel.TextColor3 = Color3.fromRGB(244, 240, 232)
TitleLabel.TextSize = 12
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Parent = MainFrame

local TabContainer = Instance.new("Frame")
TabContainer.Size = UDim2.new(1, -20, 0, 28)
TabContainer.Position = UDim2.new(0, 10, 0, 34)
TabContainer.BackgroundTransparency = 1
TabContainer.Parent = MainFrame

local Tab1Btn = Instance.new("TextButton")
Tab1Btn.Size = UDim2.new(0.32, 0, 1, 0)
Tab1Btn.Position = UDim2.new(0, 0, 0, 0)
Tab1Btn.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
Tab1Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
Tab1Btn.TextSize = 10
Tab1Btn.Font = Enum.Font.GothamBold
Tab1Btn.Text = "🚀 Webhook"
Tab1Btn.Parent = TabContainer
Instance.new("UICorner", Tab1Btn).CornerRadius = UDim.new(0, 7)

local Tab2Btn = Instance.new("TextButton")
Tab2Btn.Size = UDim2.new(0.33, 0, 1, 0)
Tab2Btn.Position = UDim2.new(0.335, 0, 0, 0)
Tab2Btn.BackgroundColor3 = Color3.fromRGB(36, 38, 50)
Tab2Btn.TextColor3 = Color3.fromRGB(180, 180, 195)
Tab2Btn.TextSize = 10
Tab2Btn.Font = Enum.Font.GothamBold
Tab2Btn.Text = "📜 Lịch sử"
Tab2Btn.Parent = TabContainer
Instance.new("UICorner", Tab2Btn).CornerRadius = UDim.new(0, 7)

local Tab3Btn = Instance.new("TextButton")
Tab3Btn.Size = UDim2.new(0.32, 0, 1, 0)
Tab3Btn.Position = UDim2.new(0.68, 0, 0, 0)
Tab3Btn.BackgroundColor3 = Color3.fromRGB(36, 38, 50)
Tab3Btn.TextColor3 = Color3.fromRGB(180, 180, 195)
Tab3Btn.TextSize = 10
Tab3Btn.Font = Enum.Font.GothamBold
Tab3Btn.Text = "⚙️ Settings"
Tab3Btn.Parent = TabContainer
Instance.new("UICorner", Tab3Btn).CornerRadius = UDim.new(0, 7)

-- ==========================================
-- KHUNG CHỮ NHẬT TO BO GÓC KHI BẬT SCRIPT:
-- PHIM XE CHẠY THỜI ĐẠI MỚI -> HIỆN TRANG TẠO TÀI KHOẢN / LOGIN
-- ==========================================
local BigRectFrame = Instance.new("Frame")
BigRectFrame.Name = "BigRoundedBootFrame"
BigRectFrame.AnchorPoint = Vector2.new(0.5, 0.5)
BigRectFrame.Size = UDim2.new(0, 344, 0, 476)
BigRectFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
BigRectFrame.BackgroundColor3 = Color3.fromRGB(14, 15, 22)
BigRectFrame.BorderSizePixel = 0
BigRectFrame.ClipsDescendants = true
BigRectFrame.Active = true
BigRectFrame.Draggable = true
BigRectFrame.ZIndex = 120
BigRectFrame.Parent = ScreenGui
Instance.new("UICorner", BigRectFrame).CornerRadius = UDim.new(0, 28)
local BigRectStroke = Instance.new("UIStroke")
BigRectStroke.Color = Color3.fromRGB(123, 97, 255)
BigRectStroke.Transparency = 0.45
BigRectStroke.Thickness = 1.5
BigRectStroke.Parent = BigRectFrame

-- --- ĐOẠN PHIM XE CHẠY THỜI ĐẠI MỚI ---
local IntroFilmPane = Instance.new("Frame")
IntroFilmPane.Name = "NewEraCarIntroPane"
IntroFilmPane.Size = UDim2.new(1, 0, 1, 0)
IntroFilmPane.BackgroundColor3 = Color3.fromRGB(10, 11, 18)
IntroFilmPane.BorderSizePixel = 0
IntroFilmPane.ZIndex = 125
IntroFilmPane.Parent = BigRectFrame
Instance.new("UICorner", IntroFilmPane).CornerRadius = UDim.new(0, 28)

local IntroBadge = Instance.new("TextLabel")
IntroBadge.Size = UDim2.new(1, -36, 0, 22)
IntroBadge.Position = UDim2.new(0, 18, 0, 26)
IntroBadge.BackgroundTransparency = 1
IntroBadge.Text = "⚡ NEW ERA AUTO FILM"
IntroBadge.TextColor3 = Color3.fromRGB(126, 232, 192)
IntroBadge.TextSize = 11
IntroBadge.Font = Enum.Font.GothamBold
IntroBadge.TextXAlignment = Enum.TextXAlignment.Left
IntroBadge.ZIndex = 126
IntroFilmPane.Parent = IntroFilmPane
IntroBadge.Parent = IntroFilmPane

local IntroTitle = Instance.new("TextLabel")
IntroTitle.Size = UDim2.new(1, -36, 0, 34)
IntroTitle.Position = UDim2.new(0, 18, 0, 48)
IntroTitle.BackgroundTransparency = 1
IntroTitle.Text = "Khởi động thời đại mới..."
IntroTitle.TextColor3 = Color3.fromRGB(244, 240, 232)
IntroTitle.TextSize = 18
IntroTitle.Font = Enum.Font.GothamBold
IntroTitle.TextXAlignment = Enum.TextXAlignment.Left
IntroTitle.ZIndex = 126
IntroTitle.Parent = IntroFilmPane

local IntroSub = Instance.new("TextLabel")
IntroSub.Size = UDim2.new(1, -36, 0, 20)
IntroSub.Position = UDim2.new(0, 18, 0, 82)
IntroSub.BackgroundTransparency = 1
IntroSub.Text = "Xe đang bứt tốc qua đường cao tốc neon"
IntroSub.TextColor3 = Color3.fromRGB(165, 162, 182)
IntroSub.TextSize = 12
IntroSub.Font = Enum.Font.Gotham
IntroSub.TextXAlignment = Enum.TextXAlignment.Left
IntroSub.ZIndex = 126
IntroSub.Parent = IntroFilmPane

-- Sân khấu phim xe chạy thời đại mới
local FilmStage = Instance.new("Frame")
FilmStage.Size = UDim2.new(1, -36, 0, 170)
FilmStage.Position = UDim2.new(0, 18, 0, 122)
FilmStage.BackgroundColor3 = Color3.fromRGB(18, 20, 34)
FilmStage.BorderSizePixel = 0
FilmStage.ClipsDescendants = true
FilmStage.ZIndex = 126
FilmStage.Parent = IntroFilmPane
Instance.new("UICorner", FilmStage).CornerRadius = UDim.new(0, 20)
local FilmStageStroke = Instance.new("UIStroke")
FilmStageStroke.Color = Color3.fromRGB(61, 139, 255)
FilmStageStroke.Transparency = 0.55
FilmStageStroke.Thickness = 1
FilmStageStroke.Parent = FilmStage

-- Vệt sáng chân trời & đường cao tốc thời đại mới
local HorizonGlow = Instance.new("Frame")
HorizonGlow.Size = UDim2.new(1, 0, 0, 3)
HorizonGlow.Position = UDim2.new(0, 0, 0.68, 0)
HorizonGlow.BackgroundColor3 = Color3.fromRGB(123, 97, 255)
HorizonGlow.BorderSizePixel = 0
HorizonGlow.ZIndex = 127
HorizonGlow.Parent = FilmStage

local RoadTrack = Instance.new("Frame")
RoadTrack.Size = UDim2.new(1, 0, 0, 52)
RoadTrack.Position = UDim2.new(0, 0, 1, -52)
RoadTrack.BackgroundColor3 = Color3.fromRGB(12, 13, 22)
RoadTrack.BorderSizePixel = 0
RoadTrack.ZIndex = 127
RoadTrack.Parent = FilmStage

local DashLine1 = Instance.new("Frame")
DashLine1.Size = UDim2.new(0, 44, 0, 4)
DashLine1.Position = UDim2.new(1, 20, 1, -28)
DashLine1.BackgroundColor3 = Color3.fromRGB(126, 232, 192)
DashLine1.BorderSizePixel = 0
DashLine1.ZIndex = 128
DashLine1.Parent = FilmStage
Instance.new("UICorner", DashLine1).CornerRadius = UDim.new(1, 0)

local DashLine2 = Instance.new("Frame")
DashLine2.Size = UDim2.new(0, 32, 0, 4)
DashLine2.Position = UDim2.new(1, 140, 1, -28)
DashLine2.BackgroundColor3 = Color3.fromRGB(61, 139, 255)
DashLine2.BorderSizePixel = 0
DashLine2.ZIndex = 128
DashLine2.Parent = FilmStage
Instance.new("UICorner", DashLine2).CornerRadius = UDim.new(1, 0)

-- Chiếc xe thời đại mới
local FutureCar = Instance.new("Frame")
FutureCar.Name = "NewEraCar"
FutureCar.Size = UDim2.new(0, 86, 0, 28)
FutureCar.Position = UDim2.new(0, -100, 1, -68)
FutureCar.BackgroundColor3 = Color3.fromRGB(61, 139, 255)
FutureCar.BorderSizePixel = 0
FutureCar.ZIndex = 130
FutureCar.Parent = FilmStage
Instance.new("UICorner", FutureCar).CornerRadius = UDim.new(0, 10)

local CarCabin = Instance.new("Frame")
CarCabin.Size = UDim2.new(0, 44, 0, 12)
CarCabin.Position = UDim2.new(0, 18, 0, -8)
CarCabin.BackgroundColor3 = Color3.fromRGB(126, 232, 192)
CarCabin.BorderSizePixel = 0
CarCabin.ZIndex = 129
CarCabin.Parent = FutureCar
Instance.new("UICorner", CarCabin).CornerRadius = UDim.new(0, 6)

local CarHeadlightBeam = Instance.new("Frame")
CarHeadlightBeam.Size = UDim2.new(0, 42, 0, 8)
CarHeadlightBeam.Position = UDim2.new(1, 0, 0.5, -2)
CarHeadlightBeam.BackgroundColor3 = Color3.fromRGB(255, 235, 130)
CarHeadlightBeam.BackgroundTransparency = 0.25
CarHeadlightBeam.BorderSizePixel = 0
CarHeadlightBeam.ZIndex = 129
CarHeadlightBeam.Parent = FutureCar
Instance.new("UICorner", CarHeadlightBeam).CornerRadius = UDim.new(1, 0)

local WheelLeft = Instance.new("Frame")
WheelLeft.Size = UDim2.new(0, 16, 0, 16)
WheelLeft.Position = UDim2.new(0, 12, 1, -8)
WheelLeft.BackgroundColor3 = Color3.fromRGB(20, 21, 30)
WheelLeft.BorderSizePixel = 0
WheelLeft.ZIndex = 131
WheelLeft.Parent = FutureCar
Instance.new("UICorner", WheelLeft).CornerRadius = UDim.new(1, 0)
local WLStroke = Instance.new("UIStroke")
WLStroke.Color = Color3.fromRGB(126, 232, 192)
WLStroke.Thickness = 2
WLStroke.Parent = WheelLeft

local WheelRight = Instance.new("Frame")
WheelRight.Size = UDim2.new(0, 16, 0, 16)
WheelRight.Position = UDim2.new(1, -28, 1, -8)
WheelRight.BackgroundColor3 = Color3.fromRGB(20, 21, 30)
WheelRight.BorderSizePixel = 0
WheelRight.ZIndex = 131
WheelRight.Parent = FutureCar
Instance.new("UICorner", WheelRight).CornerRadius = UDim.new(1, 0)
local WRStroke = Instance.new("UIStroke")
WRStroke.Color = Color3.fromRGB(126, 232, 192)
WRStroke.Thickness = 2
WRStroke.Parent = WheelRight

-- Thanh tiến trình phim chạy xong
local ProgressTrack = Instance.new("Frame")
ProgressTrack.Size = UDim2.new(1, -36, 0, 8)
ProgressTrack.Position = UDim2.new(0, 18, 0, 322)
ProgressTrack.BackgroundColor3 = Color3.fromRGB(30, 32, 48)
ProgressTrack.BorderSizePixel = 0
ProgressTrack.ZIndex = 126
ProgressTrack.Parent = IntroFilmPane
Instance.new("UICorner", ProgressTrack).CornerRadius = UDim.new(1, 0)

local ProgressFill = Instance.new("Frame")
ProgressFill.Size = UDim2.new(0, 0, 1, 0)
ProgressFill.BackgroundColor3 = Color3.fromRGB(126, 232, 192)
ProgressFill.BorderSizePixel = 0
ProgressFill.ZIndex = 127
ProgressFill.Parent = ProgressTrack
Instance.new("UICorner", ProgressFill).CornerRadius = UDim.new(1, 0)

local IntroPercentLabel = Instance.new("TextLabel")
IntroPercentLabel.Size = UDim2.new(1, -36, 0, 22)
IntroPercentLabel.Position = UDim2.new(0, 18, 0, 338)
IntroPercentLabel.BackgroundTransparency = 1
IntroPercentLabel.Text = "Đang chiếu phim xe chạy... 0%"
IntroPercentLabel.TextColor3 = Color3.fromRGB(185, 182, 205)
IntroPercentLabel.TextSize = 11
IntroPercentLabel.Font = Enum.Font.Code
IntroPercentLabel.TextXAlignment = Enum.TextXAlignment.Left
IntroPercentLabel.ZIndex = 126
IntroPercentLabel.Parent = IntroFilmPane

local SkipIntroBtn = Instance.new("TextButton")
SkipIntroBtn.Size = UDim2.new(1, -36, 0, 38)
SkipIntroBtn.Position = UDim2.new(0, 18, 1, -56)
SkipIntroBtn.BackgroundColor3 = Color3.fromRGB(36, 38, 56)
SkipIntroBtn.TextColor3 = Color3.fromRGB(244, 240, 232)
SkipIntroBtn.Text = "Bỏ qua phim (Skip)"
SkipIntroBtn.TextSize = 12
SkipIntroBtn.Font = Enum.Font.GothamBold
SkipIntroBtn.ZIndex = 127
SkipIntroBtn.Parent = IntroFilmPane
Instance.new("UICorner", SkipIntroBtn).CornerRadius = UDim.new(0, 12)

-- --- TRANG TẠO TÀI KHOẢN & ĐĂNG NHẬP (HIỆN SAU KHI PHIM CHẠY XONG) ---
local AuthScrollPane = Instance.new("ScrollingFrame")
AuthScrollPane.Name = "AuthScrollPane"
AuthScrollPane.Size = UDim2.new(1, 0, 1, 0)
AuthScrollPane.Position = UDim2.new(0, 0, 0, 0)
AuthScrollPane.BackgroundTransparency = 1
AuthScrollPane.BorderSizePixel = 0
AuthScrollPane.CanvasSize = UDim2.new(0, 0, 0, 520)
AuthScrollPane.ScrollBarThickness = 4
AuthScrollPane.Visible = false
AuthScrollPane.ZIndex = 122
AuthScrollPane.Parent = BigRectFrame

-- Trang Tạo tài khoản mặc định khi phim chạy xong (có thể chuyển qua Đăng nhập ngay)
local CreateAccCard = Instance.new("Frame")
CreateAccCard.Name = "CreateAccountPane"
CreateAccCard.Size = UDim2.new(1, -36, 0, 444)
CreateAccCard.Position = UDim2.new(0, 18, 0, 18)
CreateAccCard.BackgroundColor3 = Color3.fromRGB(22, 24, 35)
CreateAccCard.BorderSizePixel = 0
CreateAccCard.ZIndex = 123
CreateAccCard.Parent = AuthScrollPane
Instance.new("UICorner", CreateAccCard).CornerRadius = UDim.new(0, 20)

local CreateTitle = Instance.new("TextLabel")
CreateTitle.Size = UDim2.new(1, -28, 0, 26)
CreateTitle.Position = UDim2.new(0, 14, 0, 14)
CreateTitle.BackgroundTransparency = 1
CreateTitle.Text = "✨ Tạo tài khoản mới"
CreateTitle.TextColor3 = Color3.fromRGB(244, 240, 232)
CreateTitle.TextSize = 17
CreateTitle.Font = Enum.Font.GothamBold
CreateTitle.TextXAlignment = Enum.TextXAlignment.Left
CreateTitle.ZIndex = 124
CreateTitle.Parent = CreateAccCard

local CreateSub = Instance.new("TextLabel")
CreateSub.Size = UDim2.new(1, -28, 0, 18)
CreateSub.Position = UDim2.new(0, 14, 0, 40)
CreateSub.BackgroundTransparency = 1
CreateSub.Text = "Thông tin lưu trữ ngay trong script & hiển thị ở Settings"
CreateSub.TextColor3 = Color3.fromRGB(160, 158, 178)
CreateSub.TextSize = 10
CreateSub.Font = Enum.Font.Gotham
CreateSub.TextXAlignment = Enum.TextXAlignment.Left
CreateSub.ZIndex = 124
CreateSub.Parent = CreateAccCard

local SignUpNameBox = Instance.new("TextBox")
SignUpNameBox.Size = UDim2.new(1, -28, 0, 38)
SignUpNameBox.Position = UDim2.new(0, 14, 0, 68)
SignUpNameBox.BackgroundColor3 = Color3.fromRGB(32, 34, 48)
SignUpNameBox.TextColor3 = Color3.fromRGB(244, 240, 232)
SignUpNameBox.PlaceholderColor3 = Color3.fromRGB(130, 128, 148)
SignUpNameBox.PlaceholderText = "Họ tên (Name)"
SignUpNameBox.Text = ""
SignUpNameBox.TextSize = 12
SignUpNameBox.Font = Enum.Font.Gotham
SignUpNameBox.ClearTextOnFocus = false
SignUpNameBox.ZIndex = 124
SignUpNameBox.Parent = CreateAccCard
Instance.new("UICorner", SignUpNameBox).CornerRadius = UDim.new(0, 11)

local SignUpEmailBox = Instance.new("TextBox")
SignUpEmailBox.Size = UDim2.new(1, -28, 0, 38)
SignUpEmailBox.Position = UDim2.new(0, 14, 0, 114)
SignUpEmailBox.BackgroundColor3 = Color3.fromRGB(32, 34, 48)
SignUpEmailBox.TextColor3 = Color3.fromRGB(244, 240, 232)
SignUpEmailBox.PlaceholderColor3 = Color3.fromRGB(130, 128, 148)
SignUpEmailBox.PlaceholderText = "Email (vd: ten@domain.com)"
SignUpEmailBox.Text = ""
SignUpEmailBox.TextSize = 12
SignUpEmailBox.Font = Enum.Font.Gotham
SignUpEmailBox.ClearTextOnFocus = false
SignUpEmailBox.ZIndex = 124
SignUpEmailBox.Parent = CreateAccCard
Instance.new("UICorner", SignUpEmailBox).CornerRadius = UDim.new(0, 11)

local SignUpPwBox = Instance.new("TextBox")
SignUpPwBox.Size = UDim2.new(1, -28, 0, 38)
SignUpPwBox.Position = UDim2.new(0, 14, 0, 160)
SignUpPwBox.BackgroundColor3 = Color3.fromRGB(32, 34, 48)
SignUpPwBox.TextColor3 = Color3.fromRGB(244, 240, 232)
SignUpPwBox.PlaceholderColor3 = Color3.fromRGB(130, 128, 148)
SignUpPwBox.PlaceholderText = "Mật khẩu (tối thiểu 6 ký tự)"
SignUpPwBox.Text = ""
SignUpPwBox.TextSize = 12
SignUpPwBox.Font = Enum.Font.Gotham
SignUpPwBox.ClearTextOnFocus = false
SignUpPwBox.ZIndex = 124
SignUpPwBox.Parent = CreateAccCard
Instance.new("UICorner", SignUpPwBox).CornerRadius = UDim.new(0, 11)

local SignUpPhoneBox = Instance.new("TextBox")
SignUpPhoneBox.Size = UDim2.new(1, -28, 0, 38)
SignUpPhoneBox.Position = UDim2.new(0, 14, 0, 206)
SignUpPhoneBox.BackgroundColor3 = Color3.fromRGB(32, 34, 48)
SignUpPhoneBox.TextColor3 = Color3.fromRGB(244, 240, 232)
SignUpPhoneBox.PlaceholderColor3 = Color3.fromRGB(130, 128, 148)
SignUpPhoneBox.PlaceholderText = "Số điện thoại (tuỳ chọn)"
SignUpPhoneBox.Text = ""
SignUpPhoneBox.TextSize = 12
SignUpPhoneBox.Font = Enum.Font.Gotham
SignUpPhoneBox.ClearTextOnFocus = false
SignUpPhoneBox.ZIndex = 124
SignUpPhoneBox.Parent = CreateAccCard
Instance.new("UICorner", SignUpPhoneBox).CornerRadius = UDim.new(0, 11)

local AgreeTermsBtn = Instance.new("TextButton")
AgreeTermsBtn.Size = UDim2.new(1, -28, 0, 26)
AgreeTermsBtn.Position = UDim2.new(0, 14, 0, 252)
AgreeTermsBtn.BackgroundTransparency = 1
AgreeTermsBtn.Text = "[✓] Lưu tài khoản vào script & đồng ý điều khoản"
AgreeTermsBtn.TextColor3 = Color3.fromRGB(126, 232, 192)
AgreeTermsBtn.TextSize = 11
AgreeTermsBtn.Font = Enum.Font.GothamBold
AgreeTermsBtn.TextXAlignment = Enum.TextXAlignment.Left
AgreeTermsBtn.ZIndex = 124
AgreeTermsBtn.Parent = CreateAccCard

local agreedTerms = true
onButtonClicked(AgreeTermsBtn, function()
    agreedTerms = not agreedTerms
    AgreeTermsBtn.Text = agreedTerms and "[✓] Lưu tài khoản vào script & đồng ý điều khoản" or "[ ] Lưu tài khoản vào script & đồng ý điều khoản"
    AgreeTermsBtn.TextColor3 = agreedTerms and Color3.fromRGB(126, 232, 192) or Color3.fromRGB(160, 158, 178)
end)

local SignUpErrLabel = Instance.new("TextLabel")
SignUpErrLabel.Size = UDim2.new(1, -28, 0, 20)
SignUpErrLabel.Position = UDim2.new(0, 14, 0, 282)
SignUpErrLabel.BackgroundTransparency = 1
SignUpErrLabel.Text = ""
SignUpErrLabel.TextColor3 = Color3.fromRGB(255, 125, 140)
SignUpErrLabel.TextSize = 11
SignUpErrLabel.Font = Enum.Font.GothamBold
SignUpErrLabel.TextXAlignment = Enum.TextXAlignment.Left
SignUpErrLabel.ZIndex = 124
SignUpErrLabel.Parent = CreateAccCard

local SignUpSubmitBtn = Instance.new("TextButton")
SignUpSubmitBtn.Size = UDim2.new(1, -28, 0, 44)
SignUpSubmitBtn.Position = UDim2.new(0, 14, 0, 308)
SignUpSubmitBtn.BackgroundColor3 = Color3.fromRGB(126, 232, 192)
SignUpSubmitBtn.TextColor3 = Color3.fromRGB(11, 12, 18)
SignUpSubmitBtn.Text = "Tạo tài khoản & Vào Script"
SignUpSubmitBtn.TextSize = 13
SignUpSubmitBtn.Font = Enum.Font.GothamBold
SignUpSubmitBtn.ZIndex = 124
SignUpSubmitBtn.Parent = CreateAccCard
Instance.new("UICorner", SignUpSubmitBtn).CornerRadius = UDim.new(0, 13)

local SwitchToLoginBtn = Instance.new("TextButton")
SwitchToLoginBtn.Size = UDim2.new(1, -28, 0, 32)
SwitchToLoginBtn.Position = UDim2.new(0, 14, 0, 362)
SwitchToLoginBtn.BackgroundTransparency = 1
SwitchToLoginBtn.Text = "Đã có tài khoản? Đăng nhập (Sign in)"
SwitchToLoginBtn.TextColor3 = Color3.fromRGB(64, 156, 255)
SwitchToLoginBtn.TextSize = 12
SwitchToLoginBtn.Font = Enum.Font.GothamBold
SwitchToLoginBtn.ZIndex = 124
SwitchToLoginBtn.Parent = CreateAccCard

-- Trang Đăng nhập (nếu muốn đăng nhập tài khoản đã tạo)
local LoginCard = Instance.new("Frame")
LoginCard.Name = "LoginCardPane"
LoginCard.Size = UDim2.new(1, -36, 0, 444)
LoginCard.Position = UDim2.new(0, 18, 0, 18)
LoginCard.BackgroundColor3 = Color3.fromRGB(22, 24, 35)
LoginCard.BorderSizePixel = 0
LoginCard.Visible = false
LoginCard.ZIndex = 123
LoginCard.Parent = AuthScrollPane
Instance.new("UICorner", LoginCard).CornerRadius = UDim.new(0, 20)

local LoginTitle = Instance.new("TextLabel")
LoginTitle.Size = UDim2.new(1, -28, 0, 26)
LoginTitle.Position = UDim2.new(0, 14, 0, 16)
LoginTitle.BackgroundTransparency = 1
LoginTitle.Text = "🔑 Đăng nhập tài khoản"
LoginTitle.TextColor3 = Color3.fromRGB(244, 240, 232)
LoginTitle.TextSize = 17
LoginTitle.Font = Enum.Font.GothamBold
LoginTitle.TextXAlignment = Enum.TextXAlignment.Left
LoginTitle.ZIndex = 124
LoginTitle.Parent = LoginCard

local LoginEmailBox = Instance.new("TextBox")
LoginEmailBox.Size = UDim2.new(1, -28, 0, 40)
LoginEmailBox.Position = UDim2.new(0, 14, 0, 62)
LoginEmailBox.BackgroundColor3 = Color3.fromRGB(32, 34, 48)
LoginEmailBox.TextColor3 = Color3.fromRGB(244, 240, 232)
LoginEmailBox.PlaceholderColor3 = Color3.fromRGB(130, 128, 148)
LoginEmailBox.PlaceholderText = "Email tài khoản"
LoginEmailBox.Text = SavedAccounts[1].Email
LoginEmailBox.TextSize = 12
LoginEmailBox.Font = Enum.Font.Gotham
LoginEmailBox.ClearTextOnFocus = false
LoginEmailBox.ZIndex = 124
LoginCard.Parent = AuthScrollPane
LoginEmailBox.Parent = LoginCard
Instance.new("UICorner", LoginEmailBox).CornerRadius = UDim.new(0, 11)

local LoginPwBox = Instance.new("TextBox")
LoginPwBox.Size = UDim2.new(1, -28, 0, 40)
LoginPwBox.Position = UDim2.new(0, 14, 0, 114)
LoginPwBox.BackgroundColor3 = Color3.fromRGB(32, 34, 48)
LoginPwBox.TextColor3 = Color3.fromRGB(244, 240, 232)
LoginPwBox.PlaceholderColor3 = Color3.fromRGB(130, 128, 148)
LoginPwBox.PlaceholderText = "Mật khẩu"
LoginPwBox.Text = ""
LoginPwBox.TextSize = 12
LoginPwBox.Font = Enum.Font.Gotham
LoginPwBox.ClearTextOnFocus = false
LoginPwBox.ZIndex = 124
LoginPwBox.Parent = LoginCard
Instance.new("UICorner", LoginPwBox).CornerRadius = UDim.new(0, 11)

local LoginErrLabel = Instance.new("TextLabel")
LoginErrLabel.Size = UDim2.new(1, -28, 0, 24)
LoginErrLabel.Position = UDim2.new(0, 14, 0, 162)
LoginErrLabel.BackgroundTransparency = 1
LoginErrLabel.Text = ""
LoginErrLabel.TextColor3 = Color3.fromRGB(255, 125, 140)
LoginErrLabel.TextSize = 11
LoginErrLabel.Font = Enum.Font.GothamBold
LoginErrLabel.TextXAlignment = Enum.TextXAlignment.Left
LoginErrLabel.ZIndex = 124
LoginErrLabel.Parent = LoginCard

local SignInBtn = Instance.new("TextButton")
SignInBtn.Size = UDim2.new(1, -28, 0, 44)
SignInBtn.Position = UDim2.new(0, 14, 0, 196)
SignInBtn.BackgroundColor3 = Color3.fromRGB(244, 240, 232)
SignInBtn.TextColor3 = Color3.fromRGB(11, 12, 18)
SignInBtn.Text = "Sign in"
SignInBtn.TextSize = 13
SignInBtn.Font = Enum.Font.GothamBold
SignInBtn.ZIndex = 124
SignInBtn.Parent = LoginCard
Instance.new("UICorner", SignInBtn).CornerRadius = UDim.new(0, 13)

local SwitchToCreateBtn = Instance.new("TextButton")
SwitchToCreateBtn.Size = UDim2.new(1, -28, 0, 32)
SwitchToCreateBtn.Position = UDim2.new(0, 14, 0, 250)
SwitchToCreateBtn.BackgroundTransparency = 1
SwitchToCreateBtn.Text = "Chưa có tài khoản? Tạo tài khoản"
SwitchToCreateBtn.TextColor3 = Color3.fromRGB(64, 156, 255)
SwitchToCreateBtn.TextSize = 12
SwitchToCreateBtn.Font = Enum.Font.GothamBold
SwitchToCreateBtn.ZIndex = 124
SwitchToCreateBtn.Parent = LoginCard

onButtonClicked(SwitchToLoginBtn, function()
    CreateAccCard.Visible = false
    LoginCard.Visible = true
    SignUpErrLabel.Text = ""
end)

onButtonClicked(SwitchToCreateBtn, function()
    LoginCard.Visible = false
    CreateAccCard.Visible = true
    LoginErrLabel.Text = ""
end)

-- Chạy phim xe chạy thời đại mới rồi mới hiện trang tạo tài khoản
local introFinished = false
local function finishCarIntro()
    if introFinished then return end
    introFinished = true
    IntroFilmPane.Visible = false
    AuthScrollPane.Visible = true
    CreateAccCard.Visible = true
    LoginCard.Visible = false
end

task.spawn(function()
    local totalDuration = 2.6
    local t0 = tick()
    while not introFinished do
        local elapsed = tick() - t0
        local ratio = math.clamp(elapsed / totalDuration, 0, 1)
        local pct = math.floor(ratio * 100)
        ProgressFill.Size = UDim2.new(ratio, 0, 1, 0)
        IntroPercentLabel.Text = string.format("Đang chiếu phim xe chạy... %d%%", pct)

        local stageW = math.max(120, FilmStage.AbsoluteSize.X)
        local carX = -95 + (stageW + 135) * ratio
        FutureCar.Position = UDim2.new(0, carX, 1, -68)

        local dash1X = stageW - ((elapsed * 260) % (stageW + 60))
        local dash2X = stageW - ((elapsed * 260 + 130) % (stageW + 60))
        DashLine1.Position = UDim2.new(0, dash1X, 1, -28)
        DashLine2.Position = UDim2.new(0, dash2X, 1, -28)

        if ratio >= 1 then
            finishCarIntro()
            break
        end
        task.wait(0.03)
    end
end)

onButtonClicked(SkipIntroBtn, function()
    finishCarIntro()
end)

-- ==========================================
-- DYNAMIC ISLAND (#459) - CAO TRÊN ĐẦU KHI QUAY NGANG
-- ==========================================
local DynamicIsland = Instance.new("Frame")
DynamicIsland.Name = "u459DynamicIsland"
DynamicIsland.AnchorPoint = Vector2.new(0.5, 0)
DynamicIsland.Position = UDim2.new(0.5, 0, 0, 4)
DynamicIsland.Size = UDim2.new(0, 206, 0, 36)
DynamicIsland.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
DynamicIsland.BorderSizePixel = 0
DynamicIsland.Visible = false
DynamicIsland.ZIndex = 80
DynamicIsland.Parent = ScreenGui
local IslandCorner = Instance.new("UICorner", DynamicIsland)
IslandCorner.CornerRadius = UDim.new(0, 18)

local IslandStroke = Instance.new("UIStroke")
IslandStroke.Color = Color3.fromRGB(255, 255, 255)
IslandStroke.Transparency = 0.86
IslandStroke.Thickness = 1
IslandStroke.Parent = DynamicIsland

local IslandCompactText = Instance.new("TextLabel")
IslandCompactText.Size = UDim2.new(1, -20, 1, 0)
IslandCompactText.Position = UDim2.new(0, 10, 0, 0)
IslandCompactText.BackgroundTransparency = 1
IslandCompactText.Text = "🟢 0 Pet • 00:00:00"
IslandCompactText.TextColor3 = Color3.fromRGB(255, 255, 255)
IslandCompactText.TextSize = 12
IslandCompactText.Font = Enum.Font.GothamBold
IslandCompactText.TextXAlignment = Enum.TextXAlignment.Center
IslandCompactText.ZIndex = 82
IslandCompactText.Parent = DynamicIsland

local IslandExpandedText = Instance.new("TextLabel")
IslandExpandedText.Size = UDim2.new(1, -24, 1, -12)
IslandExpandedText.Position = UDim2.new(0, 12, 0, 6)
IslandExpandedText.BackgroundTransparency = 1
IslandExpandedText.Text = ""
IslandExpandedText.TextColor3 = Color3.fromRGB(244, 240, 232)
IslandExpandedText.TextSize = 11
IslandExpandedText.Font = Enum.Font.Code
IslandExpandedText.TextWrapped = true
IslandExpandedText.TextXAlignment = Enum.TextXAlignment.Left
IslandExpandedText.TextYAlignment = Enum.TextYAlignment.Center
IslandExpandedText.Visible = false
IslandExpandedText.ZIndex = 82
IslandExpandedText.Parent = DynamicIsland

local IslandTapBtn = Instance.new("TextButton")
IslandTapBtn.Size = UDim2.new(1, 0, 1, 0)
IslandTapBtn.Position = UDim2.new(0, 0, 0, 0)
IslandTapBtn.BackgroundTransparency = 1
IslandTapBtn.Text = ""
IslandTapBtn.ZIndex = 85
IslandTapBtn.Parent = DynamicIsland

local isIslandExpanded = false

local function setIslandExpanded(expanded)
    isIslandExpanded = expanded
    if expanded then
        IslandCompactText.Visible = false
        IslandExpandedText.Visible = true
        TweenService:Create(DynamicIsland, TweenInfo.new(0.42, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 316, 0, 84)
        }):Play()
        TweenService:Create(IslandCorner, TweenInfo.new(0.42, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            CornerRadius = UDim.new(0, 24)
        }):Play()
    else
        IslandExpandedText.Visible = false
        IslandCompactText.Visible = true
        TweenService:Create(DynamicIsland, TweenInfo.new(0.38, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 206, 0, 36)
        }):Play()
        TweenService:Create(IslandCorner, TweenInfo.new(0.38, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            CornerRadius = UDim.new(0, 18)
        }):Play()
    end
end

onButtonClicked(IslandTapBtn, function()
    setIslandExpanded(not isIslandExpanded)
end)

local function updateLandscapeVisibility()
    local cam = workspace.CurrentCamera
    if not cam then return end
    local vp = cam.ViewportSize
    local isLandscape = vp.X > vp.Y
    DynamicIsland.Visible = isLandscape
    if not isLandscape and isIslandExpanded then
        isIslandExpanded = false
        IslandExpandedText.Visible = false
        IslandCompactText.Visible = true
        DynamicIsland.Size = UDim2.new(0, 206, 0, 36)
        IslandCorner.CornerRadius = UDim.new(0, 18)
    end
end

if workspace.CurrentCamera then
    workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(updateLandscapeVisibility)
end
workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
    if workspace.CurrentCamera then
        workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(updateLandscapeVisibility)
        updateLandscapeVisibility()
    end
end)
updateLandscapeVisibility()

-- --- TAB 1: WEBHOOK (CÓ THANH CUỘN) ---
local Tab1Content = Instance.new("ScrollingFrame")
Tab1Content.Size = UDim2.new(1, -16, 1, -70)
Tab1Content.Position = UDim2.new(0, 8, 0, 66)
Tab1Content.BackgroundTransparency = 1
Tab1Content.BorderSizePixel = 0
Tab1Content.CanvasSize = UDim2.new(0, 0, 0, 320)
Tab1Content.ScrollBarThickness = 4
Tab1Content.Visible = true
Tab1Content.Parent = MainFrame

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, -6, 0, 62)
StatusLabel.Position = UDim2.new(0, 0, 0, 0)
StatusLabel.BackgroundColor3 = Color3.fromRGB(32, 34, 46)
StatusLabel.TextColor3 = Color3.fromRGB(225, 225, 235)
StatusLabel.TextSize = 11
StatusLabel.Font = Enum.Font.Code
StatusLabel.TextWrapped = true
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
StatusLabel.TextYAlignment = Enum.TextYAlignment.Top
StatusLabel.Parent = Tab1Content
Instance.new("UICorner", StatusLabel).CornerRadius = UDim.new(0, 8)

local CustomMoneyInput = Instance.new("TextBox")
CustomMoneyInput.Size = UDim2.new(1, -76, 0, 28)
CustomMoneyInput.Position = UDim2.new(0, 0, 0, 70)
CustomMoneyInput.BackgroundColor3 = Color3.fromRGB(32, 34, 46)
CustomMoneyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
CustomMoneyInput.PlaceholderColor3 = Color3.fromRGB(155, 155, 170)
CustomMoneyInput.PlaceholderText = "💰 Tiền lưu/gửi (vd: 1M, 1B, 0)..."
CustomMoneyInput.Text = ""
CustomMoneyInput.TextSize = 10
CustomMoneyInput.Font = Enum.Font.Gotham
CustomMoneyInput.ClearTextOnFocus = false
CustomMoneyInput.Parent = Tab1Content
Instance.new("UICorner", CustomMoneyInput).CornerRadius = UDim.new(0, 6)

local SaveMoneyBtn = Instance.new("TextButton")
SaveMoneyBtn.Size = UDim2.new(0, 68, 0, 28)
SaveMoneyBtn.Position = UDim2.new(1, -74, 0, 70)
SaveMoneyBtn.BackgroundColor3 = Color3.fromRGB(61, 139, 255)
SaveMoneyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SaveMoneyBtn.TextSize = 10
SaveMoneyBtn.Font = Enum.Font.GothamBold
SaveMoneyBtn.Text = "💾 Lưu"
SaveMoneyBtn.Parent = Tab1Content
Instance.new("UICorner", SaveMoneyBtn).CornerRadius = UDim.new(0, 6)

local FilterDropdownBtn = Instance.new("TextButton")
FilterDropdownBtn.Size = UDim2.new(1, -6, 0, 28)
FilterDropdownBtn.Position = UDim2.new(0, 0, 0, 104)
FilterDropdownBtn.BackgroundColor3 = Color3.fromRGB(40, 42, 56)
FilterDropdownBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
FilterDropdownBtn.TextSize = 11
FilterDropdownBtn.Font = Enum.Font.GothamBold
FilterDropdownBtn.Text = "🔽 Lọc Lưu & Gửi: Tất cả (0)"
FilterDropdownBtn.Parent = Tab1Content
Instance.new("UICorner", FilterDropdownBtn).CornerRadius = UDim.new(0, 6)

local DropdownListFrame = Instance.new("ScrollingFrame")
DropdownListFrame.Size = UDim2.new(1, -6, 0, 90)
DropdownListFrame.Position = UDim2.new(0, 0, 0, 136)
DropdownListFrame.BackgroundColor3 = Color3.fromRGB(28, 30, 42)
DropdownListFrame.BorderSizePixel = 0
DropdownListFrame.Visible = false
DropdownListFrame.CanvasSize = UDim2.new(0, 0, 0, 200)
DropdownListFrame.ScrollBarThickness = 4
DropdownListFrame.Parent = Tab1Content
Instance.new("UICorner", DropdownListFrame).CornerRadius = UDim.new(0, 6)

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 3)
UIListLayout.Parent = DropdownListFrame

local isDropdownOpen = false

local function applyMinMoneyFilter(val, labelText)
    CURRENT_MIN_MONEY = math.max(0, tonumber(val) or 0)
    if CURRENT_MIN_MONEY == 0 then
        FilterDropdownBtn.Text = "🔽 Lọc Lưu & Gửi: Tất cả (0)"
    else
        FilterDropdownBtn.Text = "🔽 Lọc Lưu & Gửi: " .. (labelText or (formatBigNumber(CURRENT_MIN_MONEY) .. "+/s"))
    end
    isDropdownOpen = false
    DropdownListFrame.Visible = false
end

onButtonClicked(SaveMoneyBtn, function()
    local rawText = CustomMoneyInput.Text or ""
    if rawText:gsub("%s+", "") == "" then
        applyMinMoneyFilter(0, "Tất cả (0)")
        return
    end
    local parsedVal = parseRawMoneyToNumber(rawText)
    applyMinMoneyFilter(parsedVal, rawText .. "+")
end)

     local function createFilterOption(name, val)
    local optBtn = Instance.new("TextButton")
    optBtn.Size = UDim2.new(1, -4, 0, 24)
    optBtn.BackgroundColor3 = Color3.fromRGB(46, 48, 64)
    optBtn.TextColor3 = Color3.fromRGB(240, 240, 245)
    optBtn.TextSize = 11
    optBtn.Font = Enum.Font.Gotham
    optBtn.Text = name
    optBtn.Parent = DropdownListFrame
    Instance.new("UICorner", optBtn).CornerRadius = UDim.new(0, 4)

    onButtonClicked(optBtn, function()
        CustomMoneyInput.Text = val == 0 and "" or name
        applyMinMoneyFilter(val, name)
    end)
end

createFilterOption("Tất cả (Nhận hết)", 0)
createFilterOption("Từ 1M+ /s", 1e6)
createFilterOption("Từ 1B+ /s", 1e9)
createFilterOption("Từ 1T+ /s", 1e12)
createFilterOption("Từ 1Qa+ /s", 1e15)
createFilterOption("Từ 1spd+ /s", 1e54)

onButtonClicked(FilterDropdownBtn, function()
    isDropdownOpen = not isDropdownOpen
    DropdownListFrame.Visible = isDropdownOpen
    if isDropdownOpen then
        FilterDropdownBtn.Text = "🔼 Đóng bảng lọc tiền"
    else
        FilterDropdownBtn.Text = "🔽 Lọc Lưu & Gửi: " .. (CURRENT_MIN_MONEY == 0 and "Tất cả" or formatBigNumber(CURRENT_MIN_MONEY) .. "+")
    end
end)

local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(1, -6, 0, 36)
ToggleButton.Position = UDim2.new(0, 0, 0, 140)
ToggleButton.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 13
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.Text = "STOP SCRIPT"
ToggleButton.Parent = Tab1Content
Instance.new("UICorner", ToggleButton).CornerRadius = UDim.new(0, 8)

local FooterLabel = Instance.new("TextLabel")
FooterLabel.Size = UDim2.new(1, -6, 0, 30)
FooterLabel.Position = UDim2.new(0, 0, 0, 184)
FooterLabel.BackgroundTransparency = 1
FooterLabel.TextColor3 = Color3.fromRGB(165, 165, 180)
FooterLabel.TextSize = 11
FooterLabel.Font = Enum.Font.Gotham
FooterLabel.TextWrapped = true
FooterLabel.Text = "Đã gửi: 0 thú | Trạng thái: 🟢 Đang chạy"
FooterLabel.Parent = Tab1Content

DropdownListFrame:GetPropertyChangedSignal("Visible"):Connect(function()
    if DropdownListFrame.Visible then
        ToggleButton.Position = UDim2.new(0, 0, 0, 232)
        FooterLabel.Position = UDim2.new(0, 0, 0, 274)
    else
        ToggleButton.Position = UDim2.new(0, 0, 0, 140)
        FooterLabel.Position = UDim2.new(0, 0, 0, 184)
    end
end)

-- --- TAB 3: SETTINGS (THÔNG TIN TÀI KHOẢN + CHUYỂN TÀI KHOẢN + THANH CUỘN) ---
local Tab3Content = Instance.new("ScrollingFrame")
Tab3Content.Size = UDim2.new(1, -16, 1, -70)
Tab3Content.Position = UDim2.new(0, 8, 0, 66)
Tab3Content.BackgroundTransparency = 1
Tab3Content.BorderSizePixel = 0
Tab3Content.CanvasSize = UDim2.new(0, 0, 0, 340)
Tab3Content.ScrollBarThickness = 4
Tab3Content.Visible = false
Tab3Content.Parent = MainFrame

local ProfileCard = Instance.new("Frame")
ProfileCard.Size = UDim2.new(1, -6, 0, 104)
ProfileCard.Position = UDim2.new(0, 0, 0, 0)
ProfileCard.BackgroundColor3 = Color3.fromRGB(32, 34, 46)
ProfileCard.BorderSizePixel = 0
ProfileCard.Parent = Tab3Content
Instance.new("UICorner", ProfileCard).CornerRadius = UDim.new(0, 10)

local ProfileInfoLabel = Instance.new("TextLabel")
ProfileInfoLabel.Size = UDim2.new(1, -14, 1, -10)
ProfileInfoLabel.Position = UDim2.new(0, 7, 0, 5)
ProfileInfoLabel.BackgroundTransparency = 1
ProfileInfoLabel.Text = ""
ProfileInfoLabel.TextColor3 = Color3.fromRGB(244, 240, 232)
ProfileInfoLabel.TextSize = 11
ProfileInfoLabel.Font = Enum.Font.Code
ProfileInfoLabel.TextWrapped = true
ProfileInfoLabel.TextXAlignment = Enum.TextXAlignment.Left
ProfileInfoLabel.TextYAlignment = Enum.TextYAlignment.Top
ProfileInfoLabel.Parent = ProfileCard

local SwitchAccTitle = Instance.new("TextLabel")
SwitchAccTitle.Size = UDim2.new(1, -6, 0, 20)
SwitchAccTitle.Position = UDim2.new(0, 0, 0, 112)
SwitchAccTitle.BackgroundTransparency = 1
SwitchAccTitle.Text = "🔄 Tài khoản đã lưu trong script (Chuyển đổi):"
SwitchAccTitle.TextColor3 = Color3.fromRGB(183, 164, 255)
SwitchAccTitle.TextSize = 11
SwitchAccTitle.Font = Enum.Font.GothamBold
SwitchAccTitle.TextXAlignment = Enum.TextXAlignment.Left
SwitchAccTitle.Parent = Tab3Content

local SwitchAccList = Instance.new("Frame")
SwitchAccList.Size = UDim2.new(1, -6, 0, 120)
SwitchAccList.Position = UDim2.new(0, 0, 0, 134)
SwitchAccList.BackgroundTransparency = 1
SwitchAccList.Parent = Tab3Content
local SwitchAccLayout = Instance.new("UIListLayout")
SwitchAccLayout.SortOrder = Enum.SortOrder.LayoutOrder
SwitchAccLayout.Padding = UDim.new(0, 5)
SwitchAccLayout.Parent = SwitchAccList

local LogoutAuthBtn = Instance.new("TextButton")
LogoutAuthBtn.Size = UDim2.new(1, -6, 0, 34)
LogoutAuthBtn.Position = UDim2.new(0, 0, 0, 264)
LogoutAuthBtn.BackgroundColor3 = Color3.fromRGB(217, 58, 85)
LogoutAuthBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
LogoutAuthBtn.Text = "🚪 Đăng xuất / Mở trang Tạo tài khoản"
LogoutAuthBtn.TextSize = 11
LogoutAuthBtn.Font = Enum.Font.GothamBold
LogoutAuthBtn.Parent = Tab3Content
Instance.new("UICorner", LogoutAuthBtn).CornerRadius = UDim.new(0, 8)

local refreshProfileUI
local refreshAccountSwitcher

refreshProfileUI = function()
    ProfileInfoLabel.Text = string.format(
        "👤 Tên: %s\n✉️ Email: %s\n📱 SĐT: %s\n🏢 Nhóm: %s",
        ActiveAccount.Name or "User",
        ActiveAccount.Email or "N/A",
        ActiveAccount.Phone or "Không có",
        ActiveAccount.Workspace or "Default"
    )
end

refreshAccountSwitcher = function()
    for _, child in ipairs(SwitchAccList:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end
    for i, acc in ipairs(SavedAccounts) do
        local isCurrent = (acc == ActiveAccount)
        local itemBtn = Instance.new("TextButton")
        itemBtn.Size = UDim2.new(1, 0, 0, 28)
        itemBtn.BackgroundColor3 = isCurrent and Color3.fromRGB(46, 204, 113) or Color3.fromRGB(44, 46, 62)
        itemBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        itemBtn.TextSize = 10
        itemBtn.Font = Enum.Font.GothamBold
        itemBtn.Text = (isCurrent and "✓ " or "⇄ ") .. acc.Name .. " • " .. acc.Email
        itemBtn.LayoutOrder = i
        itemBtn.Parent = SwitchAccList
        Instance.new("UICorner", itemBtn).CornerRadius = UDim.new(0, 6)

        onButtonClicked(itemBtn, function()
            ActiveAccount = acc
            LoginEmailBox.Text = acc.Email
            refreshProfileUI()
            refreshAccountSwitcher()
        end)
    end
    local listH = math.max(32, #SavedAccounts * 33)
    SwitchAccList.Size = UDim2.new(1, -6, 0, listH)
    LogoutAuthBtn.Position = UDim2.new(0, 0, 0, 134 + listH + 10)
    Tab3Content.CanvasSize = UDim2.new(0, 0, 0, 134 + listH + 56)
end

refreshProfileUI()
refreshAccountSwitcher()

local function enterAuthenticatedSession(acc)
    ActiveAccount = acc
    isAuthenticated = true
    refreshProfileUI()
    refreshAccountSwitcher()
    BigRectFrame.Visible = false
    ToggleIconBtn.Visible = true
    MainFrame.Visible = true
    isMenuVisible = true
end

onButtonClicked(LogoutAuthBtn, function()
    isAuthenticated = false
    MainFrame.Visible = false
    ToggleIconBtn.Visible = false
    BigRectFrame.Visible = true
    IntroFilmPane.Visible = false
    AuthScrollPane.Visible = true
    CreateAccCard.Visible = true
    LoginCard.Visible = false
    LoginEmailBox.Text = ActiveAccount.Email or ""
    LoginPwBox.Text = ""
    LoginErrLabel.Text = ""
    SignUpErrLabel.Text = ""
end)

onButtonClicked(SignInBtn, function()
    local acc = findAccount(LoginEmailBox.Text, LoginPwBox.Text)
    if acc then
        LoginErrLabel.Text = ""
        enterAuthenticatedSession(acc)
    else
        LoginErrLabel.Text = "Sai email hoặc mật khẩu (mặc định: lumen2026)"
    end
end)

onButtonClicked(SignUpSubmitBtn, function()
    local nm = (SignUpNameBox.Text or ""):gsub("^%s+", ""):gsub("%s+$", "")
    local em = (SignUpEmailBox.Text or ""):gsub("^%s+", ""):gsub("%s+$", "")
    local pwVal = SignUpPwBox.Text or ""
    local ph = (SignUpPhoneBox.Text or ""):gsub("^%s+", ""):gsub("%s+$", "")

    if nm == "" then
        SignUpErrLabel.Text = "Vui lòng nhập họ tên"
        return
    end
    if not string.match(em, "^[^%s@]+@[^%s@]+%.[^%s@]+$") then
        SignUpErrLabel.Text = "Email không hợp lệ"
        return
    end
    if #pwVal < 6 then
        SignUpErrLabel.Text = "Mật khẩu tối thiểu 6 ký tự"
        return
    end
    if not agreedTerms then
        SignUpErrLabel.Text = "Vui lòng đồng ý lưu tài khoản"
        return
    end

    local existing = findAccountByEmail(em)
    if existing then
        existing.Name = nm
        existing.Password = pwVal
        existing.Phone = ph ~= "" and ph or existing.Phone
        enterAuthenticatedSession(existing)
    else
        local newAcc = {
            Name = nm,
            Email = em,
            Password = pwVal,
            Phone = ph ~= "" and ph or "Không có",
            Workspace = "New Era Account"
        }
        table.insert(SavedAccounts, newAcc)
        enterAuthenticatedSession(newAcc)
    end
end)

-- --- TAB 2: LỊCH SỬ + CHỌN NGUYÊN MỤC + XÁC NHẬN XOÁ (#436) ---
local HistoryRecords = {}
local historyFilterMode = "all"
local isSelectMode = false
local selectedIndices = {}
local refreshHistory

local HistorySearch = Instance.new("TextBox")
HistorySearch.Size = UDim2.new(0, 142, 0, 30)
HistorySearch.Position = UDim2.new(0, 10, 0, 68)
HistorySearch.BackgroundColor3 = Color3.fromRGB(32, 34, 46)
HistorySearch.TextColor3 = Color3.fromRGB(245, 245, 250)
HistorySearch.PlaceholderColor3 = Color3.fromRGB(155, 155, 170)
HistorySearch.PlaceholderText = "🔎 Tìm tên..."
HistorySearch.Text = ""
HistorySearch.TextSize = 10
HistorySearch.Font = Enum.Font.Gotham
HistorySearch.ClearTextOnFocus = false
HistorySearch.Parent = MainFrame
HistorySearch.Visible = false
Instance.new("UICorner", HistorySearch).CornerRadius = UDim.new(0, 6)

local HistoryFilterBtn = Instance.new("TextButton")
HistoryFilterBtn.Size = UDim2.new(0, 34, 0, 30)
HistoryFilterBtn.Position = UDim2.new(0, 158, 0, 68)
HistoryFilterBtn.BackgroundColor3 = Color3.fromRGB(40, 42, 56)
HistoryFilterBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
HistoryFilterBtn.Text = "☷"
HistoryFilterBtn.TextSize = 11
HistoryFilterBtn.Font = Enum.Font.GothamBold
HistoryFilterBtn.Parent = MainFrame
HistoryFilterBtn.Visible = false
Instance.new("UICorner", HistoryFilterBtn).CornerRadius = UDim.new(0, 6)

local HistorySelectBtn = Instance.new("TextButton")
HistorySelectBtn.Size = UDim2.new(0, 34, 0, 30)
HistorySelectBtn.Position = UDim2.new(0, 198, 0, 68)
HistorySelectBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
HistorySelectBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
HistorySelectBtn.Text = "🗑️"
HistorySelectBtn.TextSize = 11
HistorySelectBtn.Font = Enum.Font.GothamBold
HistorySelectBtn.Parent = MainFrame
HistorySelectBtn.Visible = false
Instance.new("UICorner", HistorySelectBtn).CornerRadius = UDim.new(0, 6)

local HistoryCountLabel = Instance.new("TextLabel")
HistoryCountLabel.Size = UDim2.new(0, 72, 0, 30)
HistoryCountLabel.Position = UDim2.new(0, 238, 0, 68)
HistoryCountLabel.BackgroundColor3 = Color3.fromRGB(32, 34, 46)
HistoryCountLabel.TextColor3 = Color3.fromRGB(46, 204, 113)
HistoryCountLabel.TextSize = 11
HistoryCountLabel.Font = Enum.Font.GothamBold
HistoryCountLabel.Text = "0"
HistoryCountLabel.TextXAlignment = Enum.TextXAlignment.Center
HistoryCountLabel.Parent = MainFrame
HistoryCountLabel.Visible = false
Instance.new("UICorner", HistoryCountLabel).CornerRadius = UDim.new(0, 6)

local DeleteActionBar = Instance.new("Frame")
DeleteActionBar.Size = UDim2.new(1, -20, 0, 30)
DeleteActionBar.Position = UDim2.new(0, 10, 1, -38)
DeleteActionBar.BackgroundColor3 = Color3.fromRGB(32, 34, 46)
DeleteActionBar.Visible = false
DeleteActionBar.Parent = MainFrame
Instance.new("UICorner", DeleteActionBar).CornerRadius = UDim.new(0, 6)

local DeleteSelectedBtn = Instance.new("TextButton")
DeleteSelectedBtn.Size = UDim2.new(0.48, 0, 1, -4)
DeleteSelectedBtn.Position = UDim2.new(0, 2, 0, 2)
DeleteSelectedBtn.BackgroundColor3 = Color3.fromRGB(220, 53, 69)
DeleteSelectedBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
DeleteSelectedBtn.TextSize = 10
DeleteSelectedBtn.Font = Enum.Font.GothamBold
DeleteSelectedBtn.Text = "Xóa đã chọn (0)"
DeleteSelectedBtn.Parent = DeleteActionBar
Instance.new("UICorner", DeleteSelectedBtn).CornerRadius = UDim.new(0, 4)

local DeleteAllBtn = Instance.new("TextButton")
DeleteAllBtn.Size = UDim2.new(0.48, 0, 1, -4)
DeleteAllBtn.Position = UDim2.new(0.52, -2, 0, 2)
DeleteAllBtn.BackgroundColor3 = Color3.fromRGB(100, 40, 40)
DeleteAllBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
DeleteAllBtn.TextSize = 10
DeleteAllBtn.Font = Enum.Font.GothamBold
DeleteAllBtn.Text = "Xóa tất cả"
DeleteAllBtn.Parent = DeleteActionBar
Instance.new("UICorner", DeleteAllBtn).CornerRadius = UDim.new(0, 4)

local HistoryFilterPopup = Instance.new("Frame")
HistoryFilterPopup.Size = UDim2.new(0, 130, 0, 88)
HistoryFilterPopup.Position = UDim2.new(0, 158, 0, 101)
HistoryFilterPopup.BackgroundColor3 = Color3.fromRGB(32, 34, 46)
HistoryFilterPopup.Visible = false
HistoryFilterPopup.ZIndex = 10
HistoryFilterPopup.Parent = MainFrame
Instance.new("UICorner", HistoryFilterPopup).CornerRadius = UDim.new(0, 6)

local function makeHistoryModeButton(label, mode, y)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -8, 0, 24)
    b.Position = UDim2.new(0, 4, 0, y)
    b.BackgroundColor3 = Color3.fromRGB(48, 50, 66)
    b.TextColor3 = Color3.fromRGB(245, 245, 250)
    b.TextSize = 10
    b.Font = Enum.Font.Gotham
    b.Text = label
    b.ZIndex = 11
    b.Parent = HistoryFilterPopup
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4)
    onButtonClicked(b, function()
        historyFilterMode = mode
        HistoryFilterPopup.Visible = false
        if refreshHistory then refreshHistory() end
    end)
end
makeHistoryModeButton("Tất cả", "all", 4)
makeHistoryModeButton("Lọc giá trị", "value", 30)
makeHistoryModeButton("Lọc độ hiếm", "rarity", 56)

onButtonClicked(HistoryFilterBtn, function()
    HistoryFilterPopup.Visible = not HistoryFilterPopup.Visible
end)

-- ==========================================
-- HỘP THOẠI XÁC NHẬN XOÁ (#436) CHO LỊCH SỬ
-- ==========================================
local ConfirmOverlay = Instance.new("Frame")
ConfirmOverlay.Name = "u436ConfirmOverlay"
ConfirmOverlay.Size = UDim2.new(1, 0, 1, 0)
ConfirmOverlay.Position = UDim2.new(0, 0, 0, 0)
ConfirmOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
ConfirmOverlay.BackgroundTransparency = 0.45
ConfirmOverlay.BorderSizePixel = 0
ConfirmOverlay.Visible = false
ConfirmOverlay.ZIndex = 50
ConfirmOverlay.Parent = MainFrame
Instance.new("UICorner", ConfirmOverlay).CornerRadius = UDim.new(0, 18)

local ConfirmCard = Instance.new("Frame")
ConfirmCard.Name = "u436-d"
ConfirmCard.Size = UDim2.new(0, 274, 0, 186)
ConfirmCard.Position = UDim2.new(0.5, -137, 0.5, -93)
ConfirmCard.BackgroundColor3 = Color3.fromRGB(30, 31, 40)
ConfirmCard.BorderSizePixel = 0
ConfirmCard.ZIndex = 51
ConfirmCard.Parent = ConfirmOverlay
Instance.new("UICorner", ConfirmCard).CornerRadius = UDim.new(0, 16)
local ConfirmStroke = Instance.new("UIStroke")
ConfirmStroke.Color = Color3.fromRGB(255, 255, 255)
ConfirmStroke.Transparency = 0.85
ConfirmStroke.Thickness = 1
ConfirmStroke.Parent = ConfirmCard

local BinIconBox = Instance.new("Frame")
BinIconBox.Size = UDim2.new(0, 42, 0, 42)
BinIconBox.Position = UDim2.new(0, 16, 0, 14)
BinIconBox.BackgroundColor3 = Color3.fromRGB(217, 58, 85)
BinIconBox.BackgroundTransparency = 0.85
BinIconBox.BorderSizePixel = 0
BinIconBox.ZIndex = 52
BinIconBox.Parent = ConfirmCard
Instance.new("UICorner", BinIconBox).CornerRadius = UDim.new(0, 12)

local BinLid = Instance.new("Frame")
BinLid.Size = UDim2.new(0, 22, 0, 3)
BinLid.Position = UDim2.new(0.5, -11, 0, 12)
BinLid.BackgroundColor3 = Color3.fromRGB(255, 125, 140)
BinLid.BorderSizePixel = 0
BinLid.ZIndex = 54
BinLid.Parent = BinIconBox
Instance.new("UICorner", BinLid).CornerRadius = UDim.new(0, 2)

local BinBody = Instance.new("Frame")
BinBody.Size = UDim2.new(0, 16, 0, 15)
BinBody.Position = UDim2.new(0.5, -8, 0, 16)
BinBody.BackgroundColor3 = Color3.fromRGB(255, 125, 140)
BinBody.BorderSizePixel = 0
BinBody.ZIndex = 53
BinBody.Parent = BinIconBox
Instance.new("UICorner", BinBody).CornerRadius = UDim.new(0, 3)

local DocSheet = Instance.new("Frame")
DocSheet.Size = UDim2.new(0, 9, 0, 11)
DocSheet.Position = UDim2.new(0.5, -4, 0, 2)
DocSheet.BackgroundColor3 = Color3.fromRGB(244, 240, 232)
DocSheet.BackgroundTransparency = 1
DocSheet.BorderSizePixel = 0
DocSheet.ZIndex = 53
DocSheet.Parent = BinIconBox
Instance.new("UICorner", DocSheet).CornerRadius = UDim.new(0, 1)

local ConfirmTitle = Instance.new("TextLabel")
ConfirmTitle.Size = UDim2.new(1, -80, 0, 24)
ConfirmTitle.Position = UDim2.new(0, 66, 0, 14)
ConfirmTitle.BackgroundTransparency = 1
ConfirmTitle.Text = "Xoá lịch sử pet?"
ConfirmTitle.TextColor3 = Color3.fromRGB(244, 240, 232)
ConfirmTitle.TextSize = 14
ConfirmTitle.Font = Enum.Font.GothamBold
ConfirmTitle.TextXAlignment = Enum.TextXAlignment.Left
ConfirmTitle.ZIndex = 52
ConfirmTitle.Parent = ConfirmCard

local ConfirmDesc = Instance.new("TextLabel")
ConfirmDesc.Size = UDim2.new(1, -32, 0, 46)
ConfirmDesc.Position = UDim2.new(0, 16, 0, 62)
ConfirmDesc.BackgroundTransparency = 1
ConfirmDesc.Text = "Các mục đã chọn sẽ bị xoá khỏi lịch sử và không thể hoàn tác."
ConfirmDesc.TextColor3 = Color3.fromRGB(195, 192, 205)
ConfirmDesc.TextSize = 11
ConfirmDesc.Font = Enum.Font.Gotham
ConfirmDesc.TextWrapped = true
ConfirmDesc.TextXAlignment = Enum.TextXAlignment.Left
ConfirmDesc.TextYAlignment = Enum.TextYAlignment.Top
ConfirmDesc.ZIndex = 52
ConfirmDesc.Parent = ConfirmCard

local CancelConfirmBtn = Instance.new("TextButton")
CancelConfirmBtn.Size = UDim2.new(0.5, -20, 0, 36)
CancelConfirmBtn.Position = UDim2.new(0, 16, 1, -50)
CancelConfirmBtn.BackgroundColor3 = Color3.fromRGB(48, 50, 62)
CancelConfirmBtn.TextColor3 = Color3.fromRGB(244, 240, 232)
CancelConfirmBtn.TextSize = 12
CancelConfirmBtn.Font = Enum.Font.GothamBold
CancelConfirmBtn.Text = "Cancel"
CancelConfirmBtn.ZIndex = 52
CancelConfirmBtn.Parent = ConfirmCard
Instance.new("UICorner", CancelConfirmBtn).CornerRadius = UDim.new(0, 10)

local OkConfirmBtn = Instance.new("TextButton")
OkConfirmBtn.Size = UDim2.new(0.5, -20, 0, 36)
OkConfirmBtn.Position = UDim2.new(0.5, 4, 1, -50)
OkConfirmBtn.BackgroundColor3 = Color3.fromRGB(217, 48, 74)
OkConfirmBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
OkConfirmBtn.TextSize = 12
OkConfirmBtn.Font = Enum.Font.GothamBold
OkConfirmBtn.Text = "Delete"
OkConfirmBtn.ZIndex = 52
OkConfirmBtn.Parent = ConfirmCard
Instance.new("UICorner", OkConfirmBtn).CornerRadius = UDim.new(0, 10)

local pendingDeleteMode = nil
local confirmBusy = false

local function resetTrashVisual()
    BinLid.Rotation = 0
    DocSheet.Position = UDim2.new(0.5, -4, 0, 2)
    DocSheet.BackgroundTransparency = 1
    ConfirmCard.Position = UDim2.new(0.5, -137, 0.5, -93)
    ConfirmOverlay.BackgroundTransparency = 0.45
end

local function closeConfirmDialog(afterFn)
    local outTween = TweenService:Create(ConfirmCard, TweenInfo.new(0.26, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Position = UDim2.new(0.5, -137, 0.5, -83)
    })
    local fadeTween = TweenService:Create(ConfirmOverlay, TweenInfo.new(0.26, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        BackgroundTransparency = 1
    })
    outTween:Play()
    fadeTween:Play()
    outTween.Completed:Once(function()
        ConfirmOverlay.Visible = false
        resetTrashVisual()
        confirmBusy = false
        pendingDeleteMode = nil
        if afterFn then afterFn() end
    end)
end

local function openConfirmDialog(mode)
    if confirmBusy then return end
    if mode == "selected" then
        local count = 0
        for _, v in pairs(selectedIndices) do
        if v then count = count + 1 end
        end
        if count == 0 then return end
        ConfirmTitle.Text = "Xoá mục đã chọn?"
        ConfirmDesc.Text = string.format("%d mục lịch sử sẽ bị xoá vĩnh viễn. Thao tác này không thể hoàn tác.", count)
    elseif mode == "all" then
        if #HistoryRecords == 0 then return end
        ConfirmTitle.Text = "Xoá toàn bộ lịch sử?"
        ConfirmDesc.Text = string.format("Toàn bộ %d mục trong lịch sử pet sẽ bị xoá. Thao tác này không thể hoàn tác.", #HistoryRecords)
    else
        return
    end

    pendingDeleteMode = mode
    resetTrashVisual()
    ConfirmOverlay.Visible = true
    ConfirmCard.Position = UDim2.new(0.5, -137, 0.5, -79)
    TweenService:Create(ConfirmCard, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.new(0.5, -137, 0.5, -93)
    }):Play()
end

onButtonClicked(CancelConfirmBtn, function()
    if confirmBusy then return end
    confirmBusy = true
    closeConfirmDialog()
end)

onButtonClicked(OkConfirmBtn, function()
    if confirmBusy or not pendingDeleteMode then return end
    confirmBusy = true

    TweenService:Create(BinLid, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Rotation = -38
    }):Play()
    DocSheet.BackgroundTransparency = 0
    DocSheet.Position = UDim2.new(0.5, -4, 0, 1)

    task.delay(0.25, function()
        if not ConfirmOverlay.Visible then return end
        local dropTween = TweenService:Create(DocSheet, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Position = UDim2.new(0.5, -4, 0, 18)
        })
        dropTween:Play()
        dropTween.Completed:Once(function()
            DocSheet.BackgroundTransparency = 1
            local lidClose = TweenService:Create(BinLid, TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Rotation = 0
            })
            lidClose:Play()
            lidClose.Completed:Once(function()
                local modeToRun = pendingDeleteMode
                closeConfirmDialog(function()
                    if modeToRun == "selected" then
                        local newRecords = {}
                        for idx, record in ipairs(HistoryRecords) do
                            if not selectedIndices[idx] then
                                table.insert(newRecords, record)
                            end
                        end
                        HistoryRecords = newRecords
                        selectedIndices = {}
                    elseif modeToRun == "all" then
                        HistoryRecords = {}
                        selectedIndices = {}
                    end
                    if refreshHistory then refreshHistory() end
                end)
            end)
        end)
    end)
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.Escape and ConfirmOverlay.Visible and not confirmBusy then
        confirmBusy = true
        closeConfirmDialog()
    end
end)

local Tab2Content = Instance.new("ScrollingFrame")
Tab2Content.Size = UDim2.new(1, -12, 1, -146)
Tab2Content.Position = UDim2.new(0, 6, 0, 104)
Tab2Content.BackgroundTransparency = 1
Tab2Content.Visible = false
Tab2Content.CanvasSize = UDim2.new(0, 0, 0, 0)
Tab2Content.ScrollBarThickness = 4
Tab2Content.Parent = MainFrame

local HistoryLayout = Instance.new("UIListLayout")
HistoryLayout.SortOrder = Enum.SortOrder.LayoutOrder
HistoryLayout.Padding = UDim.new(0, 5)
HistoryLayout.Parent = Tab2Content

local function updateSelectedCountText()
    local count = 0
    for _, v in pairs(selectedIndices) do
        if v then count = count + 1 end
    end
    DeleteSelectedBtn.Text = string.format("Xóa đã chọn (%d)", count)
end

refreshHistory = function()
    for _, child in ipairs(Tab2Content:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end
    local shown = 0
    local q = string.lower(HistorySearch.Text or "")
    for idx, record in ipairs(HistoryRecords) do
        local d = record.data
        local matchesName = (q == "" or string.find(string.lower(d.Name or ""), q, 1, true) ~= nil)

        local matchesFilter = true
        if historyFilterMode == "value" then
            matchesFilter = (q == "" or string.find(string.lower(tostring(d.MoneyPerSec or "")), q, 1, true) ~= nil)
        elseif historyFilterMode == "rarity" then
            matchesFilter = (q == "" or string.find(string.lower(tostring(d.Rarity or "")), q, 1, true) ~= nil)
        end

        local matches = (historyFilterMode == "all") and matchesName or (matchesName and matchesFilter)

        if matches then
            shown = shown + 1
            local isPicked = not not selectedIndices[idx]

            local itemFrame = Instance.new("Frame")
            itemFrame.Size = UDim2.new(1, -5, 0, 72)
            itemFrame.BackgroundColor3 = isPicked and Color3.fromRGB(60, 40, 45) or Color3.fromRGB(32, 34, 46)
            itemFrame.BorderSizePixel = 0
            itemFrame.LayoutOrder = shown
            itemFrame.Parent = Tab2Content
            Instance.new("UICorner", itemFrame).CornerRadius = UDim.new(0, 6)

            local descLabel = Instance.new("TextLabel")
            descLabel.Size = UDim2.new(1, -10, 1, 0)
            descLabel.Position = UDim2.new(0, 5, 0, 0)
            descLabel.BackgroundTransparency = 1
            descLabel.TextColor3 = Color3.fromRGB(230, 230, 240)
            descLabel.TextSize = 11
            descLabel.Font = Enum.Font.Code
            descLabel.TextXAlignment = Enum.TextXAlignment.Left
            descLabel.TextYAlignment = Enum.TextYAlignment.Center
            descLabel.TextWrapped = true
            descLabel.Text = string.format(
                "%s🐾 %s | ⚖️ %s\n✨ %s | 🧬 %s\n💸 %s\n⏰ %s",
                isSelectMode and (isPicked and "[✓] " or "[ ] ") or "",
                d.Name or "Pet",
                d.Weight or "Không rõ",
                d.Rarity or "Không rõ",
                d.Mutation or "Mặc định",
                d.MoneyPerSec or "Không rõ",
                record.time
            )
            descLabel.Parent = itemFrame

            if isSelectMode then
                local rowHitBtn = Instance.new("TextButton")
                rowHitBtn.Size = UDim2.new(1, 0, 1, 0)
                rowHitBtn.Position = UDim2.new(0, 0, 0, 0)
                rowHitBtn.BackgroundTransparency = 1
                rowHitBtn.Text = ""
                rowHitBtn.ZIndex = 5
                rowHitBtn.Parent = itemFrame

                onButtonClicked(rowHitBtn, function()
                    selectedIndices[idx] = not selectedIndices[idx]
                    local nowPicked = not not selectedIndices[idx]
                    itemFrame.BackgroundColor3 = nowPicked and Color3.fromRGB(60, 40, 45) or Color3.fromRGB(32, 34, 46)
                    descLabel.Text = string.format(
                        "%s🐾 %s | ⚖️ %s\n✨ %s | 🧬 %s\n💸 %s\n⏰ %s",
                        nowPicked and "[✓] " or "[ ] ",
                        d.Name or "Pet",
                        d.Weight or "Không rõ",
                        d.Rarity or "Không rõ",
                        d.Mutation or "Mặc định",
                        d.MoneyPerSec or "Không rõ",
                        record.time
                    )
                    updateSelectedCountText()
                end)
            end
        end
    end
    Tab2Content.CanvasSize = UDim2.new(0, 0, 0, shown * 77)
    HistoryCountLabel.Text = tostring(#HistoryRecords)
    updateSelectedCountText()
end

onButtonClicked(HistorySelectBtn, function()
    isSelectMode = not isSelectMode
    selectedIndices = {}
    DeleteActionBar.Visible = isSelectMode
    HistorySelectBtn.BackgroundColor3 = isSelectMode and Color3.fromRGB(241, 196, 15) or Color3.fromRGB(200, 50, 50)
    HistorySelectBtn.Text = isSelectMode and "✖" or "🗑️"
    Tab2Content.Size = isSelectMode and UDim2.new(1, -12, 1, -148) or UDim2.new(1, -12, 1, -112)
    refreshHistory()
end)

onButtonClicked(DeleteSelectedBtn, function()
    openConfirmDialog("selected")
end)

onButtonClicked(DeleteAllBtn, function()
    openConfirmDialog("all")
end)

HistorySearch:GetPropertyChangedSignal("Text"):Connect(function()
    refreshHistory()
end)

local function setActiveTabStyle(activeBtn)
    for _, b in ipairs({Tab1Btn, Tab2Btn, Tab3Btn}) do
        if b == activeBtn then
            b.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
            b.TextColor3 = Color3.fromRGB(255, 255, 255)
        else
            b.BackgroundColor3 = Color3.fromRGB(36, 38, 50)
            b.TextColor3 = Color3.fromRGB(180, 180, 195)
        end
    end
end

onButtonClicked(Tab1Btn, function()
    setActiveTabStyle(Tab1Btn)
    Tab1Content.Visible = true
    Tab2Content.Visible = false
    Tab3Content.Visible = false
    HistorySearch.Visible = false
    HistoryFilterBtn.Visible = false
    HistorySelectBtn.Visible = false
    HistoryCountLabel.Visible = false
    HistoryFilterPopup.Visible = false
    DeleteActionBar.Visible = false
    ConfirmOverlay.Visible = false
end)

onButtonClicked(Tab2Btn, function()
    setActiveTabStyle(Tab2Btn)
    Tab1Content.Visible = false
    Tab2Content.Visible = true
    Tab3Content.Visible = false
    HistorySearch.Visible = true
    HistoryFilterBtn.Visible = true
    HistorySelectBtn.Visible = true
    HistoryCountLabel.Visible = true
    DeleteActionBar.Visible = isSelectMode
    refreshHistory()
end)

onButtonClicked(Tab3Btn, function()
    setActiveTabStyle(Tab3Btn)
    Tab1Content.Visible = false
    Tab2Content.Visible = false
    Tab3Content.Visible = true
    HistorySearch.Visible = false
    HistoryFilterBtn.Visible = false
    HistorySelectBtn.Visible = false
    HistoryCountLabel.Visible = false
    HistoryFilterPopup.Visible = false
    DeleteActionBar.Visible = false
    ConfirmOverlay.Visible = false
    refreshProfileUI()
    refreshAccountSwitcher()
end)

-- ==========================================
-- HÀM QUÉT MÀU SẮC & THÔNG TIN THÚ
-- ==========================================
local function getPetRealColor(item, rarityStr)
    for key, val in pairs(item:GetAttributes()) do
        local k = string.lower(key)
        if (string.find(k, "color") or string.find(k, "colour") or string.find(k, "rgb")) and typeof(val) == "Color3" then
            return math.floor(val.R * 255) * 65536 + math.floor(val.G * 255) * 256 + math.floor(val.B * 255)
        end
    end
    for _, child in ipairs(item:GetDescendants()) do
        if child:IsA("BasePart") then
            local col = child.Color
            return math.floor(col.R * 255) * 65536 + math.floor(col.G * 255) * 256 + math.floor(col.B * 255)
        elseif child:IsA("Highlight") and child.FillColor then
            local col = child.FillColor
            return math.floor(col.R * 255) * 65536 + math.floor(col.G * 255) * 256 + math.floor(col.B * 255)
        end
    end
    local r = string.lower(tostring(rarityStr))
    if string.find(r, "sovereign") or string.find(r, "secret") then
        return 16711680
    elseif string.find(r, "mythic") then
        return 11141375
    elseif string.find(r, "legendary") then
        return 16766720
    elseif string.find(r, "epic") then
        return 10181046
    elseif string.find(r, "rare") then
        return 3447003
    else
        return 9807270
    end
end

local function extractPetInfo(item)
    task.wait(0.2)
    local info = {
        Name = item.Name,
        Rarity = "Thường (Common)",
        Mutation = "Mặc định (Normal)",
        RawMoney = nil,
        NumericMoney = 0,
        Weight = "Không rõ",
        NumericWeight = nil
    }

    local function parseWeightString(str)
        if type(str) ~= "string" and type(str) ~= "number" then return nil end
        local s = tostring(str)
        local numMatch = s:match("([%d%.,]+)")
        if numMatch then
            local cleanNum = numMatch:gsub(",", "")
            local num = tonumber(cleanNum)
            if num then
                local formatted = tostring(math.floor(num))
                local k
                repeat
                    formatted, k = formatted:gsub("^(-?%d+)(%d%d%d)", "%1,%2")
                until k == 0
                return formatted .. " kg", num
            end
        end
        return nil, nil
    end

    for key, val in pairs(item:GetAttributes()) do
        local k = string.lower(key)
        local vStr = tostring(val)
        if string.find(k, "weight") or string.find(k, "kg") then
            local formattedW, numW = parseWeightString(vStr)
            if numW then
                info.Weight = formattedW
                info.NumericWeight = numW
            end
        elseif string.find(k, "rarity") or string.find(k, "tier") or string.find(k, "grade") then
            info.Rarity = vStr
        elseif string.find(k, "mut") or string.find(k, "variant") or string.find(k, "rainbow") or string.find(k, "ruby") or string.find(k, "emerald") or string.find(k, "diamond") or string.find(k, "gold") then
            info.Mutation = vStr
        elseif string.find(k, "rate") or string.find(k, "income") or string.find(k, "cps") or string.find(k, "mps") or string.find(k, "sec") or string.find(k, "money") or string.find(k, "cash") or string.find(k, "earn") or string.find(k, "value") or string.find(k, "dps") then
            info.RawMoney = val
        end
    end

    for _, child in ipairs(item:GetDescendants()) do
        local k = string.lower(child.Name)
        if child:IsA("ValueBase") then
            local vStr = tostring(child.Value)
            if (string.find(k, "weight") or string.find(k, "kg")) and info.Weight == "Không rõ" then
                local formattedW, numW = parseWeightString(vStr)
                if numW then
                    info.Weight = formattedW
                    info.NumericWeight = numW
                end
            elseif (string.find(k, "rarity") or string.find(k, "tier")) and info.Rarity == "Thường (Common)" then
                info.Rarity = vStr
            elseif (string.find(k, "mut") or string.find(k, "variant")) and info.Mutation == "Mặc định (Normal)" then
                info.Mutation = vStr
            elseif (string.find(k, "rate") or string.find(k, "income") or string.find(k, "cps") or string.find(k, "sec") or string.find(k, "money") or string.find(k, "cash") or string.find(k, "earn")) and not info.RawMoney then
                info.RawMoney = child.Value
            end
        elseif child:IsA("TextLabel") and child.Text ~= "" then
            local txt = child.Text
            if info.Weight == "Không rõ" and string.find(string.lower(txt), "kg") then
                local formattedW, numW = parseWeightString(txt)
                if numW then
                    info.Weight = formattedW
                    info.NumericWeight = numW
                end
            end
            if string.find(txt, "/s") or string.find(txt, "%$") or string.find(txt, "spd") or string.find(txt, "nod") or string.find(txt, "vg") then
                info.RawMoney = txt
            end
        end
    end

    if info.RawMoney then
        info.NumericMoney = parseRawMoneyToNumber(info.RawMoney)
    end

    local finalMoney = "Không rõ"
    if info.RawMoney then
        finalMoney = formatBigNumber(info.RawMoney)
        if not string.find(finalMoney, "/s") then finalMoney = finalMoney .. "/s" end
    end
    info.MoneyPerSec = finalMoney
    info.EmbedColor = getPetRealColor(item, info.Rarity)
    return info
end

-- ==========================================
-- LỌC THÔNG MINH (CHỈ NHẬN PET)
-- ==========================================
local function isRealPet(item)
    if not item or not item.Parent then return false end
    
    local nameLower = string.lower(item.Name)
    if string.find(nameLower, "food") or string.find(nameLower, "bait") or 
       string.find(nameLower, "apple") or string.find(nameLower, "meat") or 
       string.find(nameLower, "seed") or string.find(nameLower, "treat") or
       string.find(nameLower, "potion") or string.find(nameLower, "egg") or
       string.find(nameLower, "hammer") or string.find(nameLower, "pickaxe") or
       string.find(nameLower, "rod") or string.find(nameLower, "bats") then
        return false
    end

    local hasPetStat = false
    for key, _ in pairs(item:GetAttributes()) do
        local k = string.lower(key)
        if string.find(k, "rate") or string.find(k, "income") or 
           string.find(k, "rarity") or string.find(k, "weight") then
            hasPetStat = true
            break
        end
    end

    if not hasPetStat then
        for _, child in ipairs(item:GetDescendants()) do
            if child:IsA("ValueBase") then
                local k = string.lower(child.Name)
                if string.find(k, "rate") or string.find(k, "income") or 
                   string.find(k, "rarity") or string.find(k, "weight") then
                    hasPetStat = true
                    break
                end
            end
        end
    end

    return hasPetStat
end

-- ==========================================
-- GỬI WEBHOOK & GHI LỊCH SỬ
-- ==========================================
local function sendDiscordWebhook(petData)
    if CURRENT_MIN_MONEY > 0 and petData.NumericMoney < CURRENT_MIN_MONEY then
        return
    end

    petsCaughtCount = petsCaughtCount + 1

    local vnTimeTable = os.date("!*t", os.time() + 25200)
    local vnTimeString = string.format("%02d:%02d:%02d - %02d/%02d/%d",
        vnTimeTable.hour, vnTimeTable.min, vnTimeTable.sec,
        vnTimeTable.day, vnTimeTable.month, vnTimeTable.year)

    table.insert(HistoryRecords, {data = petData, time = vnTimeString})
    if refreshHistory then refreshHistory() end

    if not isRunning then return end

    local playerName = LocalPlayer.Name
    local displayName = LocalPlayer.DisplayName
    local userId = tostring(LocalPlayer.UserId)
    local profileLink = "https://www.roblox.com/users/" .. userId .. "/profile"
    local avatarThumb = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. userId .. "&width=420&height=420&format=png"

    local payload = {
        ["content"] = "<@" .. DiscordUserID .. "> 🎉 Bạn vừa bắt được một sinh vật mới!",
        ["embeds"] = {{
            ["title"] = "🐾 BẮT ĐƯỢC THÚ MỚI: " .. petData.Name,
            ["color"] = petData.EmbedColor,
            ["thumbnail"] = { ["url"] = avatarThumb },
            ["fields"] = {
                { ["name"] = "✨ Độ hiếm (Rarity)", ["value"] = "`" .. petData.Rarity .. "`", ["inline"] = true },
                { ["name"] = "🧬 Đột biến (Mutation)", ["value"] = "`" .. petData.Mutation .. "`", ["inline"] = true },
                { ["name"] = "💸 Tiền / Giây (Income)", ["value"] = "`" .. petData.MoneyPerSec .. "`", ["inline"] = true },
                { ["name"] = "⚖️ Cân nặng", ["value"] = "`" .. (petData.Weight or "Không rõ") .. "`", ["inline"] = true },
                { ["name"] = "👤 Nhân vật Roblox", ["value"] = string.format("[%s (@%s)](%s)\n**ID:** `%s`", displayName, playerName, profileLink, userId), ["inline"] = false }
            },
            ["footer"] = { ["text"] = "Throw Food For Animals • Bắt lúc: " .. vnTimeString },
            ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ")
        }}
    }

    pcall(function()
        httpRequest({
            Url = WebhookURL,
            Method = "POST",
            Headers = { ["Content-Type"] = "application/json" },
            Body = HttpService:JSONEncode(payload)
        })
    end)
end

-- ==========================================
-- BỘ NHỚ ĐỆM & THEO DÕI TÚI ĐỒ / NHÂN VẬT
-- ==========================================
local function getItemUID(item)
    return item:GetAttribute("UUID") or item:GetAttribute("Id") or item:GetAttribute("ID") or item:GetDebugId() or (item.Name .. tostring(os.clock()))
end

local function handleNewItem(newItem)
    if not newItem or not newItem:IsA("Tool") then return end

    local itemUID = getItemUID(newItem)
    if processedItems[itemUID] then return end
    processedItems[itemUID] = true 

    task.wait(1.5)
    if not newItem.Parent then return end
    if not isRealPet(newItem) then return end

    local petInfo = extractPetInfo(newItem)
    sendDiscordWebhook(petInfo)
end

local function monitorContainer(container)
    if not container then return end
    for _, item in ipairs(container:GetChildren()) do
        if item:IsA("Tool") then
            processedItems[getItemUID(item)] = true
        end
    end
    container.ChildAdded:Connect(handleNewItem)
end

local function setupListeners()
    local bp = LocalPlayer:FindFirstChild("Backpack")
    if bp then monitorContainer(bp) end
    
    local char = LocalPlayer.Character
    if char then monitorContainer(char) end
end

setupListeners()

LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(1)
    monitorContainer(char)
    local bp = LocalPlayer:FindFirstChild("Backpack")
    if bp then monitorContainer(bp) end
end)

if LocalPlayer:FindFirstChild("Backpack") then
    LocalPlayer.Backpack.ChildAdded:Connect(handleNewItem)
end

-- ==========================================
-- START/STOP BUTTON
-- ==========================================
onButtonClicked(ToggleButton, function()
    isRunning = not isRunning
    if isRunning then
        ToggleButton.Text = "STOP SCRIPT"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
    else
        ToggleButton.Text = "START SCRIPT"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(224, 86, 36)
    end
end)

-- ==========================================
-- VÒNG LẶP CẬP NHẬT TRẠNG THÁI
-- ==========================================
local frameCount = 0
local lastFpsUpdate = tick()
local currentFps = 60

RunService.RenderStepped:Connect(function()
    frameCount = frameCount + 1
    if tick() - lastFpsUpdate >= 0.5 then
        currentFps = math.floor(frameCount / (tick() - lastFpsUpdate))
        frameCount = 0
        lastFpsUpdate = tick()
    end

    local vnTime = os.date("!*t", os.time() + 25200)
    local vnClockStr = string.format("%02d:%02d:%02d", vnTime.hour, vnTime.min, vnTime.sec)

    local ping = 0
    pcall(function()
        ping = math.floor(LocalPlayer:GetNetworkPing() * 1000)
    end)

    local elapsedSeconds = math.floor(tick() - startTime)
    local h = math.floor(elapsedSeconds / 3600)
    local m = math.floor((elapsedSeconds % 3600) / 60)
    local s = elapsedSeconds % 60
    local runTimeStr = string.format("%02d:%02d:%02d", h, m, s)

    StatusLabel.Text = string.format(
        " ⏱️ Đã chạy: %s | 🇻🇳 %s\n 🎮 Game: %s\n ⚡ FPS: %d | 📶 Ping: %dms",
        runTimeStr, vnClockStr, cachedGameName, currentFps, ping
    )

    if isRunning then
        FooterLabel.Text = string.format("Đã lưu/gửi: %d thú | Trạng thái: 🟢 Đang chạy", petsCaughtCount)
    else
        FooterLabel.Text = string.format("Đã lưu/gửi: %d thú | Trạng thái: 🔴 Đang tạm dừng gửi", petsCaughtCount)
    end

    if DynamicIsland.Visible and isAuthenticated then
        local statusIcon = isRunning and "🟢" or "🔴"
        IslandCompactText.Text = string.format("%s %d Pet • %s", statusIcon, #HistoryRecords, runTimeStr)
        if isIslandExpanded then
            local minMoneyStr = CURRENT_MIN_MONEY == 0 and "Tất cả" or (formatBigNumber(CURRENT_MIN_MONEY) .. "+/s")
            IslandExpandedText.Text = string.format(
                "%s %s | ⏱️ %s\n⚡ %d FPS | 📶 %dms | 💰 %s",
                statusIcon, isRunning and "Đang chạy" or "Tạm dừng", runTimeStr, currentFps, ping, minMoneyStr
            )
        end
    end
end)
