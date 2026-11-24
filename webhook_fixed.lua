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
-- LƯU TRỮ TÀI KHOẢN TRONG SCRIPT (#062 / #244 / #037 / #408)
-- ==========================================
local SavedAccounts = {
    {
        Name = "Seoyeon Kim",
        Email = "seoyeon@example.com",
        Password = "lumen2026",
        Phone = "Không có",
        Workspace = "Lumen Design"
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
MainFrame.Size = UDim2.new(0, 310, 0, 365)
MainFrame.Position = UDim2.new(0.05, 0, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = false
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 14)

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
TitleLabel.Size = UDim2.new(1, 0, 0, 32)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "🐾 Throw Food Auto Logger"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 13
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Parent = MainFrame

local TabContainer = Instance.new("Frame")
TabContainer.Size = UDim2.new(1, -20, 0, 30)
TabContainer.Position = UDim2.new(0, 10, 0, 32)
TabContainer.BackgroundTransparency = 1
TabContainer.Parent = MainFrame

local Tab1Btn = Instance.new("TextButton")
Tab1Btn.Size = UDim2.new(0.48, 0, 1, 0)
Tab1Btn.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
Tab1Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
Tab1Btn.TextSize = 11
Tab1Btn.Font = Enum.Font.GothamBold
Tab1Btn.Text = "🚀 Gửi Webhook"
Tab1Btn.Parent = TabContainer
Instance.new("UICorner", Tab1Btn).CornerRadius = UDim.new(0, 6)

local Tab2Btn = Instance.new("TextButton")
Tab2Btn.Size = UDim2.new(0.48, 0, 1, 0)
Tab2Btn.Position = UDim2.new(0.52, 0, 0, 0)
Tab2Btn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
Tab2Btn.TextColor3 = Color3.fromRGB(180, 180, 180)
Tab2Btn.TextSize = 11
Tab2Btn.Font = Enum.Font.GothamBold
Tab2Btn.Text = "📜 Lịch sử Pet"
Tab2Btn.Parent = TabContainer
Instance.new("UICorner", Tab2Btn).CornerRadius = UDim.new(0, 6)

-- ==========================================
-- MÀN HÌNH ĐĂNG NHẬP (#062) & TẠO TÀI KHOẢN (#244)
-- ==========================================
local AuthContainer = Instance.new("Frame")
AuthContainer.Name = "AuthScreens"
AuthContainer.Size = UDim2.new(0, 320, 0, 440)
AuthContainer.Position = UDim2.new(0.5, -160, 0.5, -220)
AuthContainer.BackgroundColor3 = Color3.fromRGB(19, 20, 28)
AuthContainer.BorderSizePixel = 0
AuthContainer.Active = true
AuthContainer.Draggable = true
AuthContainer.ZIndex = 120
AuthContainer.Parent = ScreenGui
Instance.new("UICorner", AuthContainer).CornerRadius = UDim.new(0, 26)
local AuthStroke = Instance.new("UIStroke")
AuthStroke.Color = Color3.fromRGB(255, 255, 255)
AuthStroke.Transparency = 0.88
AuthStroke.Thickness = 1
AuthStroke.Parent = AuthContainer

-- --- LOGIN PANE (#062) ---
local LoginPane = Instance.new("Frame")
LoginPane.Name = "u062LoginPane"
LoginPane.Size = UDim2.new(1, 0, 1, 0)
LoginPane.BackgroundTransparency = 1
LoginPane.ZIndex = 121
LoginPane.Parent = AuthContainer

local LoginLogo = Instance.new("Frame")
LoginLogo.Size = UDim2.new(0, 42, 0, 42)
LoginLogo.Position = UDim2.new(0, 22, 0, 22)
LoginLogo.BackgroundColor3 = Color3.fromRGB(123, 97, 255)
LoginLogo.BorderSizePixel = 0
LoginLogo.ZIndex = 122
LoginLogo.Parent = LoginPane
Instance.new("UICorner", LoginLogo).CornerRadius = UDim.new(0, 13)

local LoginTitle = Instance.new("TextLabel")
LoginTitle.Size = UDim2.new(1, -44, 0, 28)
LoginTitle.Position = UDim2.new(0, 22, 0, 74)
LoginTitle.BackgroundTransparency = 1
LoginTitle.Text = "Welcome back"
LoginTitle.TextColor3 = Color3.fromRGB(244, 240, 232)
LoginTitle.TextSize = 21
LoginTitle.Font = Enum.Font.GothamBold
LoginTitle.TextXAlignment = Enum.TextXAlignment.Left
LoginTitle.ZIndex = 122
LoginTitle.Parent = LoginPane

local LoginSub = Instance.new("TextLabel")
LoginSub.Size = UDim2.new(1, -44, 0, 20)
LoginSub.Position = UDim2.new(0, 22, 0, 102)
LoginSub.BackgroundTransparency = 1
LoginSub.Text = "Đăng nhập tài khoản để mở Script"
LoginSub.TextColor3 = Color3.fromRGB(165, 162, 178)
LoginSub.TextSize = 12
LoginSub.Font = Enum.Font.Gotham
LoginSub.TextXAlignment = Enum.TextXAlignment.Left
LoginSub.ZIndex = 122
LoginSub.Parent = LoginPane

local LoginEmailLabel = Instance.new("TextLabel")
LoginEmailLabel.Size = UDim2.new(1, -44, 0, 18)
LoginEmailLabel.Position = UDim2.new(0, 22, 0, 134)
LoginEmailLabel.BackgroundTransparency = 1
LoginEmailLabel.Text = "Email"
LoginEmailLabel.TextColor3 = Color3.fromRGB(210, 207, 220)
LoginEmailLabel.TextSize = 12
LoginEmailLabel.Font = Enum.Font.GothamBold
LoginEmailLabel.TextXAlignment = Enum.TextXAlignment.Left
LoginEmailLabel.ZIndex = 122
LoginEmailLabel.Parent = LoginPane

local LoginEmailBox = Instance.new("TextBox")
LoginEmailBox.Size = UDim2.new(1, -44, 0, 44)
LoginEmailBox.Position = UDim2.new(0, 22, 0, 155)
LoginEmailBox.BackgroundColor3 = Color3.fromRGB(28, 30, 40)
LoginEmailBox.TextColor3 = Color3.fromRGB(244, 240, 232)
LoginEmailBox.PlaceholderColor3 = Color3.fromRGB(125, 122, 140)
LoginEmailBox.PlaceholderText = "Nhập email..."
LoginEmailBox.Text = SavedAccounts[1].Email
LoginEmailBox.TextSize = 13
LoginEmailBox.Font = Enum.Font.Gotham
LoginEmailBox.ClearTextOnFocus = false
LoginEmailBox.ZIndex = 122
LoginEmailBox.Parent = LoginPane
Instance.new("UICorner", LoginEmailBox).CornerRadius = UDim.new(0, 13)

local LoginPwLabel = Instance.new("TextLabel")
LoginPwLabel.Size = UDim2.new(1, -44, 0, 18)
LoginPwLabel.Position = UDim2.new(0, 22, 0, 208)
LoginPwLabel.BackgroundTransparency = 1
LoginPwLabel.Text = "Password"
LoginPwLabel.TextColor3 = Color3.fromRGB(210, 207, 220)
LoginPwLabel.TextSize = 12
LoginPwLabel.Font = Enum.Font.GothamBold
LoginPwLabel.TextXAlignment = Enum.TextXAlignment.Left
LoginPwLabel.ZIndex = 122
LoginPwLabel.Parent = LoginPane

local LoginPwBox = Instance.new("TextBox")
LoginPwBox.Size = UDim2.new(1, -92, 0, 44)
LoginPwBox.Position = UDim2.new(0, 22, 0, 229)
LoginPwBox.BackgroundColor3 = Color3.fromRGB(28, 30, 40)
LoginPwBox.TextColor3 = Color3.fromRGB(244, 240, 232)
LoginPwBox.PlaceholderColor3 = Color3.fromRGB(125, 122, 140)
LoginPwBox.PlaceholderText = "Nhập mật khẩu..."
LoginPwBox.Text = ""
LoginPwBox.TextSize = 13
LoginPwBox.Font = Enum.Font.Gotham
LoginPwBox.ClearTextOnFocus = false
LoginPwBox.ZIndex = 122
LoginPwBox.Parent = LoginPane
Instance.new("UICorner", LoginPwBox).CornerRadius = UDim.new(0, 13)

local LoginEyeBtn = Instance.new("TextButton")
LoginEyeBtn.Size = UDim2.new(0, 44, 0, 44)
LoginEyeBtn.Position = UDim2.new(1, -66, 0, 229)
LoginEyeBtn.BackgroundColor3 = Color3.fromRGB(36, 38, 52)
LoginEyeBtn.TextColor3 = Color3.fromRGB(183, 164, 255)
LoginEyeBtn.Text = "👁"
LoginEyeBtn.TextSize = 14
LoginEyeBtn.Font = Enum.Font.GothamBold
LoginEyeBtn.ZIndex = 122
LoginEyeBtn.Parent = LoginPane
Instance.new("UICorner", LoginEyeBtn).CornerRadius = UDim.new(0, 13)

local showLoginPw = true
onButtonClicked(LoginEyeBtn, function()
    showLoginPw = not showLoginPw
    LoginEyeBtn.Text = showLoginPw and "👁" or "🙈"
end)

local LoginErrLabel = Instance.new("TextLabel")
LoginErrLabel.Size = UDim2.new(1, -44, 0, 22)
LoginErrLabel.Position = UDim2.new(0, 22, 0, 278)
LoginErrLabel.BackgroundTransparency = 1
LoginErrLabel.Text = ""
LoginErrLabel.TextColor3 = Color3.fromRGB(255, 125, 140)
LoginErrLabel.TextSize = 11
LoginErrLabel.Font = Enum.Font.GothamBold
LoginErrLabel.TextXAlignment = Enum.TextXAlignment.Left
LoginErrLabel.ZIndex = 122
LoginErrLabel.Parent = LoginPane

local SignInBtn = Instance.new("TextButton")
SignInBtn.Size = UDim2.new(1, -44, 0, 46)
SignInBtn.Position = UDim2.new(0, 22, 0, 308)
SignInBtn.BackgroundColor3 = Color3.fromRGB(244, 240, 232)
SignInBtn.TextColor3 = Color3.fromRGB(11, 12, 18)
SignInBtn.Text = "Sign in"
SignInBtn.TextSize = 14
SignInBtn.Font = Enum.Font.GothamBold
SignInBtn.ZIndex = 122
SignInBtn.Parent = LoginPane
Instance.new("UICorner", SignInBtn).CornerRadius = UDim.new(0, 15)

-- Mục tạo tài khoản nằm dưới nút Sign in, chữ màu xanh
local OpenSignUpBtn = Instance.new("TextButton")
OpenSignUpBtn.Size = UDim2.new(1, -44, 0, 28)
OpenSignUpBtn.Position = UDim2.new(0, 22, 0, 362)
OpenSignUpBtn.BackgroundTransparency = 1
OpenSignUpBtn.Text = "Chưa có tài khoản? Tạo tài khoản"
OpenSignUpBtn.TextColor3 = Color3.fromRGB(64, 156, 255)
OpenSignUpBtn.TextSize = 12
OpenSignUpBtn.Font = Enum.Font.GothamBold
OpenSignUpBtn.ZIndex = 122
OpenSignUpBtn.Parent = LoginPane

-- --- SIGN UP PANE (#244) ---
local SignUpPane = Instance.new("Frame")
SignUpPane.Name = "u244SignUpPane"
SignUpPane.Size = UDim2.new(1, 0, 1, 0)
SignUpPane.BackgroundTransparency = 1
SignUpPane.Visible = false
SignUpPane.ZIndex = 121
SignUpPane.Parent = AuthContainer

local SignUpTitle = Instance.new("TextLabel")
SignUpTitle.Size = UDim2.new(1, -44, 0, 24)
SignUpTitle.Position = UDim2.new(0, 22, 0, 18)
SignUpTitle.BackgroundTransparency = 1
SignUpTitle.Text = "Tạo tài khoản (Sign up)"
SignUpTitle.TextColor3 = Color3.fromRGB(244, 240, 232)
SignUpTitle.TextSize = 18
SignUpTitle.Font = Enum.Font.GothamBold
SignUpTitle.TextXAlignment = Enum.TextXAlignment.Left
SignUpTitle.ZIndex = 122
SignUpTitle.Parent = SignUpPane

local SignUpNameBox = Instance.new("TextBox")
SignUpNameBox.Size = UDim2.new(1, -44, 0, 38)
SignUpNameBox.Position = UDim2.new(0, 22, 0, 52)
SignUpNameBox.BackgroundColor3 = Color3.fromRGB(28, 30, 40)
SignUpNameBox.TextColor3 = Color3.fromRGB(244, 240, 232)
SignUpNameBox.PlaceholderColor3 = Color3.fromRGB(125, 122, 140)
SignUpNameBox.PlaceholderText = "Họ tên (Name)"
SignUpNameBox.Text = ""
SignUpNameBox.TextSize = 12
SignUpNameBox.Font = Enum.Font.Gotham
SignUpNameBox.ClearTextOnFocus = false
SignUpNameBox.ZIndex = 122
SignUpNameBox.Parent = SignUpPane
Instance.new("UICorner", SignUpNameBox).CornerRadius = UDim.new(0, 11)

local SignUpEmailBox = Instance.new("TextBox")
SignUpEmailBox.Size = UDim2.new(1, -44, 0, 38)
SignUpEmailBox.Position = UDim2.new(0, 22, 0, 98)
SignUpEmailBox.BackgroundColor3 = Color3.fromRGB(28, 30, 40)
SignUpEmailBox.TextColor3 = Color3.fromRGB(244, 240, 232)
SignUpEmailBox.PlaceholderColor3 = Color3.fromRGB(125, 122, 140)
SignUpEmailBox.PlaceholderText = "Email (vd: ten@domain.com)"
SignUpEmailBox.Text = ""
SignUpEmailBox.TextSize = 12
SignUpEmailBox.Font = Enum.Font.Gotham
SignUpEmailBox.ClearTextOnFocus = false
SignUpEmailBox.ZIndex = 122
SignUpEmailBox.Parent = SignUpPane
Instance.new("UICorner", SignUpEmailBox).CornerRadius = UDim.new(0, 11)

local SignUpPwBox = Instance.new("TextBox")
SignUpPwBox.Size = UDim2.new(1, -44, 0, 38)
SignUpPwBox.Position = UDim2.new(0, 22, 0, 144)
SignUpPwBox.BackgroundColor3 = Color3.fromRGB(28, 30, 40)
SignUpPwBox.TextColor3 = Color3.fromRGB(244, 240, 232)
SignUpPwBox.PlaceholderColor3 = Color3.fromRGB(125, 122, 140)
SignUpPwBox.PlaceholderText = "Mật khẩu (ít nhất 6 ký tự)"
SignUpPwBox.Text = ""
SignUpPwBox.TextSize = 12
SignUpPwBox.Font = Enum.Font.Gotham
SignUpPwBox.ClearTextOnFocus = false
SignUpPwBox.ZIndex = 122
SignUpPwBox.Parent = SignUpPane
Instance.new("UICorner", SignUpPwBox).CornerRadius = UDim.new(0, 11)

local SignUpPhoneBox = Instance.new("TextBox")
SignUpPhoneBox.Size = UDim2.new(1, -44, 0, 38)
SignUpPhoneBox.Position = UDim2.new(0, 22, 0, 190)
SignUpPhoneBox.BackgroundColor3 = Color3.fromRGB(28, 30, 40)
SignUpPhoneBox.TextColor3 = Color3.fromRGB(244, 240, 232)
SignUpPhoneBox.PlaceholderColor3 = Color3.fromRGB(125, 122, 140)
SignUpPhoneBox.PlaceholderText = "Số điện thoại (tuỳ chọn)"
SignUpPhoneBox.Text = ""
SignUpPhoneBox.TextSize = 12
SignUpPhoneBox.Font = Enum.Font.Gotham
SignUpPhoneBox.ClearTextOnFocus = false
SignUpPhoneBox.ZIndex = 122
SignUpPhoneBox.Parent = SignUpPane
Instance.new("UICorner", SignUpPhoneBox).CornerRadius = UDim.new(0, 11)

local AgreeTermsBtn = Instance.new("TextButton")
AgreeTermsBtn.Size = UDim2.new(1, -44, 0, 28)
AgreeTermsBtn.Position = UDim2.new(0, 22, 0, 236)
AgreeTermsBtn.BackgroundTransparency = 1
AgreeTermsBtn.Text = "[✓] Tôi đồng ý điều khoản & lưu trong script"
AgreeTermsBtn.TextColor3 = Color3.fromRGB(126, 232, 192)
AgreeTermsBtn.TextSize = 11
AgreeTermsBtn.Font = Enum.Font.GothamBold
AgreeTermsBtn.TextXAlignment = Enum.TextXAlignment.Left
AgreeTermsBtn.ZIndex = 122
AgreeTermsBtn.Parent = SignUpPane

local agreedTerms = true
onButtonClicked(AgreeTermsBtn, function()
    agreedTerms = not agreedTerms
    AgreeTermsBtn.Text = agreedTerms and "[✓] Tôi đồng ý điều khoản & lưu trong script" or "[ ] Tôi đồng ý điều khoản & lưu trong script"
    AgreeTermsBtn.TextColor3 = agreedTerms and Color3.fromRGB(126, 232, 192) or Color3.fromRGB(165, 162, 178)
end)

local SignUpErrLabel = Instance.new("TextLabel")
SignUpErrLabel.Size = UDim2.new(1, -44, 0, 22)
SignUpErrLabel.Position = UDim2.new(0, 22, 0, 268)
SignUpErrLabel.BackgroundTransparency = 1
SignUpErrLabel.Text = ""
SignUpErrLabel.TextColor3 = Color3.fromRGB(255, 125, 140)
SignUpErrLabel.TextSize = 11
SignUpErrLabel.Font = Enum.Font.GothamBold
SignUpErrLabel.TextXAlignment = Enum.TextXAlignment.Left
SignUpErrLabel.ZIndex = 122
SignUpErrLabel.Parent = SignUpPane

local SignUpSubmitBtn = Instance.new("TextButton")
SignUpSubmitBtn.Size = UDim2.new(1, -44, 0, 44)
SignUpSubmitBtn.Position = UDim2.new(0, 22, 0, 296)
SignUpSubmitBtn.BackgroundColor3 = Color3.fromRGB(126, 232, 192)
SignUpSubmitBtn.TextColor3 = Color3.fromRGB(11, 12, 18)
SignUpSubmitBtn.Text = "Tạo & Đăng nhập"
SignUpSubmitBtn.TextSize = 13
SignUpSubmitBtn.Font = Enum.Font.GothamBold
SignUpSubmitBtn.ZIndex = 122
SignUpSubmitBtn.Parent = SignUpPane
Instance.new("UICorner", SignUpSubmitBtn).CornerRadius = UDim.new(0, 13)

local BackToLoginBtn = Instance.new("TextButton")
BackToLoginBtn.Size = UDim2.new(1, -44, 0, 28)
BackToLoginBtn.Position = UDim2.new(0, 22, 0, 350)
BackToLoginBtn.BackgroundTransparency = 1
BackToLoginBtn.Text = "Đã có tài khoản? Đăng nhập"
BackToLoginBtn.TextColor3 = Color3.fromRGB(64, 156, 255)
BackToLoginBtn.TextSize = 12
BackToLoginBtn.Font = Enum.Font.GothamBold
BackToLoginBtn.ZIndex = 122
BackToLoginBtn.Parent = SignUpPane

onButtonClicked(OpenSignUpBtn, function()
    LoginPane.Visible = false
    SignUpPane.Visible = true
    LoginErrLabel.Text = ""
end)

onButtonClicked(BackToLoginBtn, function()
    SignUpPane.Visible = false
    LoginPane.Visible = true
    SignUpErrLabel.Text = ""
end)

-- ==========================================
-- MENU SIDEBAR (#417) + CHUYỂN TÀI KHOẢN (#037) + SETTING (#408)
-- ==========================================
local SidebarFrame = Instance.new("Frame")
SidebarFrame.Name = "u417Sidebar"
SidebarFrame.Size = UDim2.new(0, 132, 0, 226)
SidebarFrame.Position = UDim2.new(1, 8, 0, 65)
SidebarFrame.BackgroundColor3 = Color3.fromRGB(19, 20, 28)
SidebarFrame.BorderSizePixel = 0
SidebarFrame.ZIndex = 40
SidebarFrame.Parent = MainFrame
Instance.new("UICorner", SidebarFrame).CornerRadius = UDim.new(0, 14)
local SidebarStroke = Instance.new("UIStroke")
SidebarStroke.Color = Color3.fromRGB(255, 255, 255)
SidebarStroke.Transparency = 0.9
SidebarStroke.Thickness = 1
SidebarStroke.Parent = SidebarFrame

local SidebarHeader = Instance.new("TextLabel")
SidebarHeader.Size = UDim2.new(1, -12, 0, 26)
SidebarHeader.Position = UDim2.new(0, 8, 0, 4)
SidebarHeader.BackgroundTransparency = 1
SidebarHeader.Text = "⚡ Menu"
SidebarHeader.TextColor3 = Color3.fromRGB(183, 164, 255)
SidebarHeader.TextSize = 12
SidebarHeader.Font = Enum.Font.GothamBold
SidebarHeader.TextXAlignment = Enum.TextXAlignment.Left
SidebarHeader.ZIndex = 41
SidebarHeader.Parent = SidebarFrame

local SidebarCollapseBtn = Instance.new("TextButton")
SidebarCollapseBtn.Size = UDim2.new(0, 22, 0, 22)
SidebarCollapseBtn.Position = UDim2.new(1, -26, 0, 6)
SidebarCollapseBtn.BackgroundColor3 = Color3.fromRGB(36, 37, 48)
SidebarCollapseBtn.TextColor3 = Color3.fromRGB(244, 240, 232)
SidebarCollapseBtn.Text = "‹"
SidebarCollapseBtn.TextSize = 14
SidebarCollapseBtn.Font = Enum.Font.GothamBold
SidebarCollapseBtn.ZIndex = 42
SidebarCollapseBtn.Parent = SidebarFrame
Instance.new("UICorner", SidebarCollapseBtn).CornerRadius = UDim.new(1, 0)

local SidebarPill = Instance.new("Frame")
SidebarPill.Name = "u417Pill"
SidebarPill.Size = UDim2.new(1, -12, 0, 32)
SidebarPill.Position = UDim2.new(0, 6, 0, 34)
SidebarPill.BackgroundColor3 = Color3.fromRGB(37, 38, 50)
SidebarPill.BorderSizePixel = 0
SidebarPill.ZIndex = 41
SidebarPill.Parent = SidebarFrame
Instance.new("UICorner", SidebarPill).CornerRadius = UDim.new(0, 10)

local InboxBadge = Instance.new("TextLabel")
InboxBadge.Size = UDim2.new(0, 18, 0, 16)
InboxBadge.Position = UDim2.new(1, -24, 0.5, -8)
InboxBadge.BackgroundColor3 = Color3.fromRGB(183, 164, 255)
InboxBadge.TextColor3 = Color3.fromRGB(11, 12, 18)
InboxBadge.Text = "0"
InboxBadge.TextSize = 9
InboxBadge.Font = Enum.Font.GothamBold
InboxBadge.ZIndex = 44
InboxBadge.Parent = SidebarFrame
Instance.new("UICorner", InboxBadge).CornerRadius = UDim.new(1, 0)

-- --- PANEL SETTING (#408) & CHUYỂN TÀI KHOẢN (#037) ---
local SettingPane = Instance.new("Frame")
SettingPane.Name = "u408SettingPane"
SettingPane.Size = UDim2.new(1, -20, 1, -70)
SettingPane.Position = UDim2.new(0, 10, 0, 65)
SettingPane.BackgroundTransparency = 1
SettingPane.Visible = false
SettingPane.ZIndex = 20
SettingPane.Parent = MainFrame

local ProfileCard = Instance.new("Frame")
ProfileCard.Size = UDim2.new(1, 0, 0, 108)
ProfileCard.Position = UDim2.new(0, 0, 0, 0)
ProfileCard.BackgroundColor3 = Color3.fromRGB(35, 36, 46)
ProfileCard.BorderSizePixel = 0
ProfileCard.ZIndex = 21
ProfileCard.Parent = SettingPane
Instance.new("UICorner", ProfileCard).CornerRadius = UDim.new(0, 12)

local ProfileInfoLabel = Instance.new("TextLabel")
ProfileInfoLabel.Size = UDim2.new(1, -16, 1, -12)
ProfileInfoLabel.Position = UDim2.new(0, 8, 0, 6)
ProfileInfoLabel.BackgroundTransparency = 1
ProfileInfoLabel.Text = ""
ProfileInfoLabel.TextColor3 = Color3.fromRGB(244, 240, 232)
ProfileInfoLabel.TextSize = 11
ProfileInfoLabel.Font = Enum.Font.Code
ProfileInfoLabel.TextWrapped = true
ProfileInfoLabel.TextXAlignment = Enum.TextXAlignment.Left
ProfileInfoLabel.TextYAlignment = Enum.TextYAlignment.Top
ProfileInfoLabel.ZIndex = 22
ProfileInfoLabel.Parent = ProfileCard

local SwitchAccToggleBtn = Instance.new("TextButton")
SwitchAccToggleBtn.Size = UDim2.new(1, 0, 0, 32)
SwitchAccToggleBtn.Position = UDim2.new(0, 0, 0, 116)
SwitchAccToggleBtn.BackgroundColor3 = Color3.fromRGB(106, 87, 242)
SwitchAccToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SwitchAccToggleBtn.Text = "🔄 Chuyển đổi tài khoản (#037)"
SwitchAccToggleBtn.TextSize = 11
SwitchAccToggleBtn.Font = Enum.Font.GothamBold
SwitchAccToggleBtn.ZIndex = 22
SwitchAccToggleBtn.Parent = SettingPane
Instance.new("UICorner", SwitchAccToggleBtn).CornerRadius = UDim.new(0, 8)

local SwitchAccList = Instance.new("ScrollingFrame")
SwitchAccList.Size = UDim2.new(1, 0, 0, 96)
SwitchAccList.Position = UDim2.new(0, 0, 0, 154)
SwitchAccList.BackgroundColor3 = Color3.fromRGB(30, 31, 40)
SwitchAccList.BorderSizePixel = 0
SwitchAccList.Visible = false
SwitchAccList.CanvasSize = UDim2.new(0, 0, 0, 0)
SwitchAccList.ScrollBarThickness = 4
SwitchAccList.ZIndex = 25
SwitchAccList.Parent = SettingPane
Instance.new("UICorner", SwitchAccList).CornerRadius = UDim.new(0, 8)
local SwitchAccLayout = Instance.new("UIListLayout")
SwitchAccLayout.SortOrder = Enum.SortOrder.LayoutOrder
SwitchAccLayout.Padding = UDim.new(0, 4)
SwitchAccLayout.Parent = SwitchAccList

local LogoutAuthBtn = Instance.new("TextButton")
LogoutAuthBtn.Size = UDim2.new(1, 0, 0, 32)
LogoutAuthBtn.Position = UDim2.new(0, 0, 1, -34)
LogoutAuthBtn.BackgroundColor3 = Color3.fromRGB(217, 58, 85)
LogoutAuthBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
LogoutAuthBtn.Text = "🚪 Đăng xuất / Màn hình Login"
LogoutAuthBtn.TextSize = 11
LogoutAuthBtn.Font = Enum.Font.GothamBold
LogoutAuthBtn.ZIndex = 22
LogoutAuthBtn.Parent = SettingPane
Instance.new("UICorner", LogoutAccBtn or LogoutAuthBtn).CornerRadius = UDim.new(0, 8)

local refreshProfileUI
local refreshAccountSwitcher

refreshProfileUI = function()
    ProfileInfoLabel.Text = string.format(
        "👤 Tên: %s\n✉️ Email: %s\n📱 SĐT: %s\n🏢 Workspace: %s",
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
        itemBtn.Size = UDim2.new(1, -6, 0, 28)
        itemBtn.BackgroundColor3 = isCurrent and Color3.fromRGB(46, 204, 113) or Color3.fromRGB(48, 50, 64)
        itemBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        itemBtn.TextSize = 10
        itemBtn.Font = Enum.Font.GothamBold
        itemBtn.Text = (isCurrent and "✓ " or "") .. acc.Name .. " (" .. acc.Email .. ")"
        itemBtn.LayoutOrder = i
        itemBtn.ZIndex = 26
        itemBtn.Parent = SwitchAccList
        Instance.new("UICorner", itemBtn).CornerRadius = UDim.new(0, 6)

        onButtonClicked(itemBtn, function()
            ActiveAccount = acc
            LoginEmailBox.Text = acc.Email
            refreshProfileUI()
            refreshAccountSwitcher()
        end)
    end
    SwitchAccList.CanvasSize = UDim2.new(0, 0, 0, #SavedAccounts * 32)
end

refreshProfileUI()
refreshAccountSwitcher()

onButtonClicked(SwitchAccToggleBtn, function()
    SwitchAccList.Visible = not SwitchAccList.Visible
    if SwitchAccList.Visible then
        refreshAccountSwitcher()
    end
end)

local function enterAuthenticatedSession(acc)
    ActiveAccount = acc
    isAuthenticated = true
    refreshProfileUI()
    refreshAccountSwitcher()
    AuthContainer.Visible = false
    ToggleIconBtn.Visible = true
    MainFrame.Visible = true
    isMenuVisible = true
end

onButtonClicked(LogoutAuthBtn, function()
    isAuthenticated = false
    MainFrame.Visible = false
    ToggleIconBtn.Visible = false
    SwitchAccList.Visible = false
    LoginPane.Visible = true
    SignUpPane.Visible = false
    LoginEmailBox.Text = ActiveAccount.Email or ""
    LoginPwBox.Text = ""
    LoginErrLabel.Text = ""
    AuthContainer.Visible = true
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
        SignUpErrLabel.Text = "Vui lòng đồng ý điều khoản"
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
            Workspace = "Custom Account"
        }
        table.insert(SavedAccounts, newAcc)
        enterAuthenticatedSession(newAcc)
    end
end)

local isSidebarRail = false
local sidebarButtons = {}

local function setSidebarActive(btn, index)
    for _, b in ipairs(sidebarButtons) do
        b.TextColor3 = Color3.fromRGB(155, 152, 168)
    end
    btn.TextColor3 = Color3.fromRGB(244, 240, 232)
    TweenService:Create(SidebarPill, TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.new(0, 6, 0, 34 + (index - 1) * 36)
    }):Play()
end

local function makeSidebarItem(labelText, index, onSelect)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -12, 0, 32)
    b.Position = UDim2.new(0, 6, 0, 34 + (index - 1) * 36)
    b.BackgroundTransparency = 1
    b.Text = labelText
    b.TextColor3 = index == 1 and Color3.fromRGB(244, 240, 232) or Color3.fromRGB(155, 152, 168)
    b.TextSize = 11
    b.Font = Enum.Font.GothamBold
    b.TextXAlignment = Enum.TextXAlignment.Left
    b.ZIndex = 43
    b.Parent = SidebarFrame
    table.insert(sidebarButtons, b)

    onButtonClicked(b, function()
        setSidebarActive(b, index)
        if onSelect then onSelect() end
    end)
    return b
end

local switchToWebhookTab
local switchToSettingTab

local sbHomeBtn = makeSidebarItem("  🏠 Home", 1, function()
    if switchToWebhookTab then switchToWebhookTab() end
end)

local sbInboxBtn = makeSidebarItem("  📥 Inbox", 2, function()
    if switchToWebhookTab then switchToWebhookTab() end
end)

local sbProjectsBtn = makeSidebarItem("  📁 Projects", 3, function()
    if switchToWebhookTab then switchToWebhookTab() end
end)

local sbCalendarBtn = makeSidebarItem("  📅 Calendar", 4, function()
    if switchToWebhookTab then switchToWebhookTab() end
end)

local sbSettingsBtn = makeSidebarItem("  ⚙️ Settings", 5, function()
    if switchToSettingTab then switchToSettingTab() end
end)

onButtonClicked(SidebarCollapseBtn, function()
    isSidebarRail = not isSidebarRail
    local targetWidth = isSidebarRail and 46 or 132
    TweenService:Create(SidebarFrame, TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, targetWidth, 0, 226)
    }):Play()
    SidebarHeader.Visible = not isSidebarRail
    SidebarCollapseBtn.Text = isSidebarRail and "›" or "‹"
    InboxBadge.Visible = not isSidebarRail
    sbHomeBtn.Text = isSidebarRail and " 🏠" or "  🏠 Home"
    sbInboxBtn.Text = isSidebarRail and " 📥" or "  📥 Inbox"
    sbProjectsBtn.Text = isSidebarRail and " 📁" or "  📁 Projects"
    sbCalendarBtn.Text = isSidebarRail and " 📅" or "  📅 Calendar"
    sbSettingsBtn.Text = isSidebarRail and " ⚙️" or "  ⚙️ Settings"
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

-- --- TAB 1 ---
local Tab1Content = Instance.new("Frame")
Tab1Content.Size = UDim2.new(1, 0, 1, -70)
Tab1Content.Position = UDim2.new(0, 0, 0, 65)
Tab1Content.BackgroundTransparency = 1
Tab1Content.Visible = true
Tab1Content.Parent = MainFrame

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, -20, 0, 65)
StatusLabel.Position = UDim2.new(0, 10, 0, 0)
StatusLabel.BackgroundColor3 = Color3.fromRGB(38, 38, 46)
StatusLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
StatusLabel.TextSize = 11
StatusLabel.Font = Enum.Font.Code
StatusLabel.TextWrapped = true
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
StatusLabel.TextYAlignment = Enum.TextYAlignment.Top
StatusLabel.Parent = Tab1Content
Instance.new("UICorner", StatusLabel).CornerRadius = UDim.new(0, 8)

local CustomMoneyInput = Instance.new("TextBox")
CustomMoneyInput.Size = UDim2.new(1, -92, 0, 28)
CustomMoneyInput.Position = UDim2.new(0, 10, 0, 72)
CustomMoneyInput.BackgroundColor3 = Color3.fromRGB(38, 38, 46)
CustomMoneyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
CustomMoneyInput.PlaceholderColor3 = Color3.fromRGB(155, 155, 165)
CustomMoneyInput.PlaceholderText = "💰 Tiền lưu/gửi (vd: 1M, 1B, 0)..."
CustomMoneyInput.Text = ""
CustomMoneyInput.TextSize = 10
CustomMoneyInput.Font = Enum.Font.Gotham
CustomMoneyInput.ClearTextOnFocus = false
CustomMoneyInput.Parent = Tab1Content
Instance.new("UICorner", CustomMoneyInput).CornerRadius = UDim.new(0, 6)

local SaveMoneyBtn = Instance.new("TextButton")
SaveMoneyBtn.Size = UDim2.new(0, 66, 0, 28)
SaveMoneyBtn.Position = UDim2.new(1, -76, 0, 72)
SaveMoneyBtn.BackgroundColor3 = Color3.fromRGB(52, 152, 219)
SaveMoneyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SaveMoneyBtn.TextSize = 10
SaveMoneyBtn.Font = Enum.Font.GothamBold
SaveMoneyBtn.Text = "💾 Lưu"
SaveMoneyBtn.Parent = Tab1Content
Instance.new("UICorner", SaveMoneyBtn).CornerRadius = UDim.new(0, 6)

local FilterDropdownBtn = Instance.new("TextButton")
FilterDropdownBtn.Size = UDim2.new(1, -20, 0, 28)
FilterDropdownBtn.Position = UDim2.new(0, 10, 0, 106)
FilterDropdownBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
FilterDropdownBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
FilterDropdownBtn.TextSize = 11
FilterDropdownBtn.Font = Enum.Font.GothamBold
FilterDropdownBtn.Text = "🔽 Lọc Lưu & Gửi: Tất cả (0)"
FilterDropdownBtn.Parent = Tab1Content
Instance.new("UICorner", FilterDropdownBtn).CornerRadius = UDim.new(0, 6)

local DropdownListFrame = Instance.new("ScrollingFrame")
DropdownListFrame.Size = UDim2.new(1, -20, 0, 90)
DropdownListFrame.Position = UDim2.new(0, 10, 0, 138)
DropdownListFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
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
    optBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    optBtn.TextColor3 = Color3.fromRGB(240, 240, 240)
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
ToggleButton.Size = UDim2.new(1, -20, 0, 36)
ToggleButton.Position = UDim2.new(0, 10, 0, 142)
ToggleButton.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 13
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.Text = "STOP SCRIPT"
ToggleButton.Parent = Tab1Content
Instance.new("UICorner", ToggleButton).CornerRadius = UDim.new(0, 8)

local FooterLabel = Instance.new("TextLabel")
FooterLabel.Size = UDim2.new(1, -20, 0, 30)
FooterLabel.Position = UDim2.new(0, 10, 0, 232)
FooterLabel.BackgroundTransparency = 1
FooterLabel.TextColor3 = Color3.fromRGB(160, 160, 170)
FooterLabel.TextSize = 11
FooterLabel.Font = Enum.Font.Gotham
FooterLabel.TextWrapped = true
FooterLabel.Text = "Đã gửi: 0 thú | Trạng thái: 🟢 Đang chạy"
FooterLabel.Parent = Tab1Content

DropdownListFrame:GetPropertyChangedSignal("Visible"):Connect(function()
    if DropdownListFrame.Visible then
        ToggleButton.Position = UDim2.new(0, 10, 0, 233)
        FooterLabel.Position = UDim2.new(0, 10, 0, 272)
    else
        ToggleButton.Position = UDim2.new(0, 10, 0, 142)
        FooterLabel.Position = UDim2.new(0, 10, 0, 232)
    end
end)

-- --- TAB 2: LỊCH SỬ + CHỌN NGUYÊN MỤC + XÁC NHẬN XOÁ (#436) ---
local HistoryRecords = {}
local historyFilterMode = "all"
local isSelectMode = false
local selectedIndices = {}
local refreshHistory

local HistorySearch = Instance.new("TextBox")
HistorySearch.Size = UDim2.new(0, 130, 0, 30)
HistorySearch.Position = UDim2.new(0, 10, 0, 66)
HistorySearch.BackgroundColor3 = Color3.fromRGB(38, 38, 46)
HistorySearch.TextColor3 = Color3.fromRGB(245, 245, 245)
HistorySearch.PlaceholderColor3 = Color3.fromRGB(155, 155, 165)
HistorySearch.PlaceholderText = "🔎 Tìm tên..."
HistorySearch.Text = ""
HistorySearch.TextSize = 10
HistorySearch.Font = Enum.Font.Gotham
HistorySearch.ClearTextOnFocus = false
HistorySearch.Parent = MainFrame
HistorySearch.Visible = false
Instance.new("UICorner", HistorySearch).CornerRadius = UDim.new(0, 6)

local HistoryFilterBtn = Instance.new("TextButton")
HistoryFilterBtn.Size = UDim2.new(0, 32, 0, 30)
HistoryFilterBtn.Position = UDim2.new(0, 145, 0, 66)
HistoryFilterBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
HistoryFilterBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
HistoryFilterBtn.Text = "☷"
HistoryFilterBtn.TextSize = 11
HistoryFilterBtn.Font = Enum.Font.GothamBold
HistoryFilterBtn.Parent = MainFrame
HistoryFilterBtn.Visible = false
Instance.new("UICorner", HistoryFilterBtn).CornerRadius = UDim.new(0, 6)

local HistorySelectBtn = Instance.new("TextButton")
HistorySelectBtn.Size = UDim2.new(0, 32, 0, 30)
HistorySelectBtn.Position = UDim2.new(0, 182, 0, 66)
HistorySelectBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
HistorySelectBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
HistorySelectBtn.Text = "🗑️"
HistorySelectBtn.TextSize = 11
HistorySelectBtn.Font = Enum.Font.GothamBold
HistorySelectBtn.Parent = MainFrame
HistorySelectBtn.Visible = false
Instance.new("UICorner", HistorySelectBtn).CornerRadius = UDim.new(0, 6)

local HistoryCountLabel = Instance.new("TextLabel")
HistoryCountLabel.Size = UDim2.new(0, 70, 0, 30)
HistoryCountLabel.Position = UDim2.new(0, 219, 0, 66)
HistoryCountLabel.BackgroundColor3 = Color3.fromRGB(38, 38, 46)
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
DeleteActionBar.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
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
HistoryFilterPopup.Position = UDim2.new(0, 145, 0, 99)
HistoryFilterPopup.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
HistoryFilterPopup.Visible = false
HistoryFilterPopup.ZIndex = 10
HistoryFilterPopup.Parent = MainFrame
Instance.new("UICorner", HistoryFilterPopup).CornerRadius = UDim.new(0, 6)

local function makeHistoryModeButton(label, mode, y)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -8, 0, 24)
    b.Position = UDim2.new(0, 4, 0, y)
    b.BackgroundColor3 = Color3.fromRGB(52, 52, 64)
    b.TextColor3 = Color3.fromRGB(245, 245, 245)
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
Instance.new("UICorner", ConfirmOverlay).CornerRadius = UDim.new(0, 14)

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
Tab2Content.Size = UDim2.new(1, -10, 1, -145)
Tab2Content.Position = UDim2.new(0, 5, 0, 102)
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
            itemFrame.BackgroundColor3 = isPicked and Color3.fromRGB(60, 40, 45) or Color3.fromRGB(35, 35, 42)
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
                    itemFrame.BackgroundColor3 = nowPicked and Color3.fromRGB(60, 40, 45) or Color3.fromRGB(35, 35, 42)
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
    InboxBadge.Text = tostring(#HistoryRecords)
    updateSelectedCountText()
end

onButtonClicked(HistorySelectBtn, function()
    isSelectMode = not isSelectMode
    selectedIndices = {}
    DeleteActionBar.Visible = isSelectMode
    HistorySelectBtn.BackgroundColor3 = isSelectMode and Color3.fromRGB(241, 196, 15) or Color3.fromRGB(200, 50, 50)
    HistorySelectBtn.Text = isSelectMode and "✖" or "🗑️"
    Tab2Content.Size = isSelectMode and UDim2.new(1, -10, 1, -148) or UDim2.new(1, -10, 1, -110)
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

switchToWebhookTab = function()
    SettingPane.Visible = false
    Tab1Content.Visible = true
    Tab2Content.Visible = false
    HistorySearch.Visible = false
    HistoryFilterBtn.Visible = false
    HistorySelectBtn.Visible = false
    HistoryCountLabel.Visible = false
    HistoryFilterPopup.Visible = false
    DeleteActionBar.Visible = false
    ConfirmOverlay.Visible = false
    Tab1Btn.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
    Tab1Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Tab2Btn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    Tab2Btn.TextColor3 = Color3.fromRGB(180, 180, 180)
end

switchToSettingTab = function()
    Tab1Content.Visible = false
    Tab2Content.Visible = false
    HistorySearch.Visible = false
    HistoryFilterBtn.Visible = false
    HistorySelectBtn.Visible = false
    HistoryCountLabel.Visible = false
    HistoryFilterPopup.Visible = false
    DeleteActionBar.Visible = false
    ConfirmOverlay.Visible = false
    SettingPane.Visible = true
    refreshProfileUI()
    refreshAccountSwitcher()
end

onButtonClicked(Tab1Btn, function()
    switchToWebhookTab()
    setSidebarActive(sbHomeBtn, 1)
end)

onButtonClicked(Tab2Btn, function()
    SettingPane.Visible = false
    Tab1Content.Visible = false
    Tab2Content.Visible = true
    HistorySearch.Visible = true
    HistoryFilterBtn.Visible = true
    HistorySelectBtn.Visible = true
    HistoryCountLabel.Visible = true
    DeleteActionBar.Visible = isSelectMode
    Tab2Btn.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
    Tab2Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Tab1Btn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    Tab1Btn.TextColor3 = Color3.fromRGB(180, 180, 180)
    refreshHistory()
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
