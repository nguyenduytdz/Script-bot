-- ==========================================
-- CẤU HÌNH THÔNG TIN CỦA BẠN
-- ==========================================
local WebhookURL = "https://discord.com/api/webhooks/1570446166754201803/pPCEG-HczkXcUA2fWQd6pYo62wgLmeBxf1ri812j1AO2W87wWCz1LzoF-6s8tgem5yEo"
local DiscordUserID = "1494250347731091497"

local CURRENT_MIN_MONEY = 0

-- Cấu hình Key:
-- isAdmin = true  -> Key Admin (mở toàn quyền tab Admin)
-- isAdmin = false -> Key thường (chỉ dùng script, không chỉnh/xóa key)
-- expireAt = nil  -> Vĩnh viễn; hoặc os.time() + số giây
local INITIAL_KEYS = {
    ["ADMIN-VIP"] = { expireAt = nil, isAdmin = true },
    ["LUMEN-2026"] = { expireAt = os.time() + 86400, isAdmin = true },
    ["USER-24H"] = { expireAt = os.time() + 86400, isAdmin = false },
    ["THROWFOOD-FREE"] = { expireAt = os.time() + 3600, isAdmin = false }
}

-- ==========================================
-- KHỞI TẠO DỊCH VỤ & BIẾN TRẠNG THÁI
-- ==========================================
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local MarketplaceService = game:GetService("MarketplaceService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local function getUiParent()
    local ok, cg = pcall(function()
        return game:GetService("CoreGui")
    end)
    if ok and cg then
        local testOk = pcall(function()
            local f = Instance.new("Folder")
            f.Parent = cg
            f:Destroy()
        end)
        if testOk then
            return cg
        end
    end
    return LocalPlayer:WaitForChild("PlayerGui")
end

local UiParent = getUiParent()

local httpRequest = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request

local isRunning = true
local startTime = tick()
local petsCaughtCount = 0
local processedItems = {}
local isKeyUnlocked = false

local KeyStore = {}
local RevokedKeys = {}
local ActiveKeyName = nil

for k, cfg in pairs(INITIAL_KEYS) do
    KeyStore[string.upper(k)] = {
        expireAt = cfg.expireAt,
        isAdmin = cfg.isAdmin == true,
        deviceInfo = nil,
        usedAt = nil
    }
end

local function isCurrentUserAdmin()
    if not ActiveKeyName or not KeyStore[ActiveKeyName] then
        return false
    end
    return KeyStore[ActiveKeyName].isAdmin == true
end

local function getDeviceSummary()
    local platformName = "Unknown"
    pcall(function()
        platformName = tostring(UserInputService:GetPlatform()):gsub("Enum%.Platform%.", "")
    end)
    local touchTag = UserInputService.TouchEnabled and "Touch" or "PC/Other"
    return string.format("%s (%s) • @%s [%d]", platformName, touchTag, LocalPlayer.Name, LocalPlayer.UserId)
end

local function getVnTimeString()
    local vnTimeTable = os.date("!*t", os.time() + 25200)
    return string.format("%02d:%02d:%02d - %02d/%02d/%d",
        vnTimeTable.hour, vnTimeTable.min, vnTimeTable.sec,
        vnTimeTable.day, vnTimeTable.month, vnTimeTable.year)
end

local function formatRemainingTime(expireAt)
    if expireAt == nil then
        return "♾️ Vĩnh viễn"
    end
    local rem = math.max(0, math.floor(expireAt - os.time()))
    if rem <= 0 then
        return "⛔ Hết hạn"
    end
    local d = math.floor(rem / 86400)
    local h = math.floor((rem % 86400) / 3600)
    local m = math.floor((rem % 3600) / 60)
    local s = rem % 60
    if d > 0 then
        return string.format("%dd %02d:%02d:%02d", d, h, m, s)
    end
    return string.format("%02d:%02d:%02d", h, m, s)
end

local function isKeyValid(keyCode)
    local k = string.upper((keyCode or ""):gsub("^%s+", ""):gsub("%s+$", ""))
    if k == "" or RevokedKeys[k] then
        return false, "Key đã bị xóa vĩnh viễn!"
    end
    local entry = KeyStore[k]
    if not entry then
        return false, "Key không tồn tại!"
    end
    if entry.expireAt ~= nil and os.time() >= entry.expireAt then
        return false, "Key đã hết thời gian sử dụng!"
    end
    return true, "Hợp lệ"
end

local cachedGameName = "Throw Food For Animals"
pcall(function()
    cachedGameName = MarketplaceService:GetProductInfo(game.PlaceId).Name
end)

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
-- TẠO GIAO DIỆN (UI) BAN ĐẦU
-- ==========================================
if UiParent:FindFirstChild("ThrowFoodAutoMenu") then
    UiParent.ThrowFoodAutoMenu:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ThrowFoodAutoMenu"
ScreenGui.DisplayOrder = 999
ScreenGui.IgnoreGuiInset = true
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = UiParent

local function onButtonClicked(btn, callback)
    btn.MouseButton1Click:Connect(callback)
end

local ToggleIconBtn = Instance.new("TextButton")
ToggleIconBtn.Name = "ToggleIconBtn"
ToggleIconBtn.Size = UDim2.new(0, 45, 0, 45)
ToggleIconBtn.Position = UDim2.new(0.05, 0, 0.14, 0)
ToggleIconBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
ToggleIconBtn.TextColor3 = Color3.fromRGB(255, 220, 50)
ToggleIconBtn.TextSize = 22
ToggleIconBtn.Font = Enum.Font.GothamBold
ToggleIconBtn.Text = "⚡"
ToggleIconBtn.Active = true
ToggleIconBtn.Visible = false
ToggleIconBtn.ZIndex = 20
ToggleIconBtn.Parent = ScreenGui
Instance.new("UICorner", ToggleIconBtn).CornerRadius = UDim.new(1, 0)
local IconStroke = Instance.new("UIStroke")
IconStroke.Color = Color3.fromRGB(224, 86, 36)
IconStroke.Thickness = 2
IconStroke.Parent = ToggleIconBtn

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 326, 0, 360)
MainFrame.Position = UDim2.new(0.05, 0, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(22, 24, 34)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = false
MainFrame.ZIndex = 10
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 18)
local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(123, 97, 255)
MainStroke.Transparency = 0.45
MainStroke.Thickness = 1.2
MainStroke.Parent = MainFrame

local isMenuVisible = true
onButtonClicked(ToggleIconBtn, function()
    if not isKeyUnlocked then return end
    isMenuVisible = not isMenuVisible
    MainFrame.Visible = isMenuVisible
    TweenService:Create(ToggleIconBtn, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Rotation = ToggleIconBtn.Rotation + 360
    }):Play()
end)

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -16, 0, 28)
TitleLabel.Position = UDim2.new(0, 8, 0, 4)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "🐾 Throw Food Auto Logger"
TitleLabel.TextColor3 = Color3.fromRGB(244, 240, 232)
TitleLabel.TextSize = 13
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.ZIndex = 11
TitleLabel.Parent = MainFrame

local TabContainer = Instance.new("Frame")
TabContainer.Size = UDim2.new(1, -16, 0, 28)
TabContainer.Position = UDim2.new(0, 8, 0, 34)
TabContainer.BackgroundTransparency = 1
TabContainer.ZIndex = 11
TabContainer.Parent = MainFrame

local Tab1Btn = Instance.new("TextButton")
Tab1Btn.Size = UDim2.new(0.24, 0, 1, 0)
Tab1Btn.Position = UDim2.new(0, 0, 0, 0)
Tab1Btn.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
Tab1Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
Tab1Btn.TextSize = 9
Tab1Btn.Font = Enum.Font.GothamBold
Tab1Btn.Text = "🚀 Webhook"
Tab1Btn.ZIndex = 12
Tab1Btn.Parent = TabContainer
Instance.new("UICorner", Tab1Btn).CornerRadius = UDim.new(0, 7)

local Tab2Btn = Instance.new("TextButton")
Tab2Btn.Size = UDim2.new(0.24, 0, 1, 0)
Tab2Btn.Position = UDim2.new(0.253, 0, 0, 0)
Tab2Btn.BackgroundColor3 = Color3.fromRGB(36, 38, 52)
Tab2Btn.TextColor3 = Color3.fromRGB(185, 185, 200)
Tab2Btn.TextSize = 9
Tab2Btn.Font = Enum.Font.GothamBold
Tab2Btn.Text = "📜 Lịch sử"
Tab2Btn.ZIndex = 12
Tab2Btn.Parent = TabContainer
Instance.new("UICorner", Tab2Btn).CornerRadius = UDim.new(0, 7)

local Tab3Btn = Instance.new("TextButton")
Tab3Btn.Size = UDim2.new(0.24, 0, 1, 0)
Tab3Btn.Position = UDim2.new(0.506, 0, 0, 0)
Tab3Btn.BackgroundColor3 = Color3.fromRGB(36, 38, 52)
Tab3Btn.TextColor3 = Color3.fromRGB(185, 185, 200)
Tab3Btn.TextSize = 9
Tab3Btn.Font = Enum.Font.GothamBold
Tab3Btn.Text = "⚙️ Settings"
Tab3Btn.ZIndex = 12
Tab3Btn.Parent = TabContainer
Instance.new("UICorner", Tab3Btn).CornerRadius = UDim.new(0, 7)

local Tab4Btn = Instance.new("TextButton")
Tab4Btn.Size = UDim2.new(0.24, 0, 1, 0)
Tab4Btn.Position = UDim2.new(0.76, 0, 0, 0)
Tab4Btn.BackgroundColor3 = Color3.fromRGB(36, 38, 52)
Tab4Btn.TextColor3 = Color3.fromRGB(185, 185, 200)
Tab4Btn.TextSize = 9
Tab4Btn.Font = Enum.Font.GothamBold
Tab4Btn.Text = "🛡️ Admin"
Tab4Btn.ZIndex = 12
Tab4Btn.Parent = TabContainer
Instance.new("UICorner", Tab4Btn).CornerRadius = UDim.new(0, 7)

-- ==========================================
-- DYNAMIC ISLAND TRÊN ĐẦU MÀN HÌNH
-- ==========================================
local DynamicIsland = Instance.new("Frame")
DynamicIsland.Name = "u459DynamicIsland"
DynamicIsland.AnchorPoint = Vector2.new(0.5, 0)
DynamicIsland.Position = UDim2.new(0.5, 0, 0, 6)
DynamicIsland.Size = UDim2.new(0, 210, 0, 34)
DynamicIsland.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
DynamicIsland.BorderSizePixel = 0
DynamicIsland.Visible = true
DynamicIsland.ZIndex = 80
DynamicIsland.Parent = ScreenGui
local IslandCorner = Instance.new("UICorner", DynamicIsland)
IslandCorner.CornerRadius = UDim.new(0, 17)

local IslandStroke = Instance.new("UIStroke")
IslandStroke.Color = Color3.fromRGB(255, 255, 255)
IslandStroke.Transparency = 0.85
IslandStroke.Thickness = 1
IslandStroke.Parent = DynamicIsland

local IslandCompactText = Instance.new("TextLabel")
IslandCompactText.Size = UDim2.new(1, -20, 1, 0)
IslandCompactText.Position = UDim2.new(0, 10, 0, 0)
IslandCompactText.BackgroundTransparency = 1
IslandCompactText.Text = "🟢 0 Pet • 00:00:00"
IslandCompactText.TextColor3 = Color3.fromRGB(255, 255, 255)
IslandCompactText.TextSize = 11
IslandCompactText.Font = Enum.Font.GothamBold
IslandCompactText.TextXAlignment = Enum.TextXAlignment.Center
IslandCompactText.ZIndex = 82
IslandCompactText.Parent = DynamicIsland

local IslandExpandedText = Instance.new("TextLabel")
IslandExpandedText.Size = UDim2.new(1, -24, 1, -10)
IslandExpandedText.Position = UDim2.new(0, 12, 0, 5)
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
            Size = UDim2.new(0, 326, 0, 78)
        }):Play()
        TweenService:Create(IslandCorner, TweenInfo.new(0.42, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            CornerRadius = UDim.new(0, 22)
        }):Play()
    else
        IslandExpandedText.Visible = false
        IslandCompactText.Visible = true
        TweenService:Create(DynamicIsland, TweenInfo.new(0.38, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 210, 0, 34)
        }):Play()
        TweenService:Create(IslandCorner, TweenInfo.new(0.38, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            CornerRadius = UDim.new(0, 17)
        }):Play()
    end
end

onButtonClicked(IslandTapBtn, function()
    setIslandExpanded(not isIslandExpanded)
end)

-- ==========================================
-- KHUNG CHỮ NHẬT NẰM NGANG CHỈ HIỆN KHI CHẠY INTRO
-- ==========================================
local IntroRectFrame = Instance.new("Frame")
IntroRectFrame.Name = "IntroHorizontalRect"
IntroRectFrame.AnchorPoint = Vector2.new(0.5, 0.5)
IntroRectFrame.Size = UDim2.new(0, 480, 0, 180)
IntroRectFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
IntroRectFrame.BackgroundColor3 = Color3.fromRGB(10, 16, 28)
IntroRectFrame.BorderSizePixel = 0
IntroRectFrame.ZIndex = 90
IntroRectFrame.Parent = ScreenGui
Instance.new("UICorner", IntroRectFrame).CornerRadius = UDim.new(0, 18)
local IntroStroke = Instance.new("UIStroke")
IntroStroke.Color = Color3.fromRGB(115, 195, 255)
IntroStroke.Thickness = 1.5
IntroStroke.Parent = IntroRectFrame

local IntroLabel = Instance.new("TextLabel")
IntroLabel.Size = UDim2.new(1, -24, 0, 20)
IntroLabel.Position = UDim2.new(0, 12, 0, 8)
IntroLabel.BackgroundTransparency = 1
IntroLabel.Text = "✦ INTRO ORBIT CORE"
IntroLabel.TextColor3 = Color3.fromRGB(165, 220, 255)
IntroLabel.TextSize = 11
IntroLabel.Font = Enum.Font.GothamBold
IntroLabel.TextXAlignment = Enum.TextXAlignment.Left
IntroLabel.ZIndex = 91
IntroLabel.Parent = IntroRectFrame

local IntroStage = Instance.new("Frame")
IntroStage.Size = UDim2.new(1, -24, 0, 102)
IntroStage.Position = UDim2.new(0, 12, 0, 30)
IntroStage.BackgroundColor3 = Color3.fromRGB(12, 22, 42)
IntroStage.BorderSizePixel = 0
IntroStage.ClipsDescendants = true
IntroStage.ZIndex = 91
IntroStage.Parent = IntroRectFrame
Instance.new("UICorner", IntroStage).CornerRadius = UDim.new(0, 12)

local OrbitCenter = Instance.new("Frame")
OrbitCenter.AnchorPoint = Vector2.new(0.5, 0.5)
OrbitCenter.Size = UDim2.new(0, 74, 0, 74)
OrbitCenter.Position = UDim2.new(0.5, 0, 0.5, 0)
OrbitCenter.BackgroundTransparency = 1
OrbitCenter.ZIndex = 93
OrbitCenter.Parent = IntroStage

local ringSpecs = {
    {w = 72, h = 24, rot = 0,   color = Color3.fromRGB(190, 230, 255)},
    {w = 72, h = 24, rot = 60,  color = Color3.fromRGB(120, 195, 255)},
    {w = 72, h = 24, rot = -60, color = Color3.fromRGB(150, 215, 255)},
    {w = 56, h = 56, rot = 30,  color = Color3.fromRGB(220, 245, 255)}
}

local orbitRings = {}
local orbitTips = {}
for i, spec in ipairs(ringSpecs) do
    local ring = Instance.new("Frame")
    ring.AnchorPoint = Vector2.new(0.5, 0.5)
    ring.Size = UDim2.new(0, spec.w, 0, spec.h)
    ring.Position = UDim2.new(0.5, 0, 0.5, 0)
    ring.Rotation = spec.rot
    ring.BackgroundTransparency = 1
    ring.ZIndex = 93
    ring.Parent = OrbitCenter

    local stroke = Instance.new("UIStroke")
    stroke.Color = spec.color
    stroke.Thickness = 1.6
    stroke.Transparency = 0.85
    stroke.Parent = ring
    table.insert(orbitRings, stroke)

    local tip = Instance.new("Frame")
    tip.AnchorPoint = Vector2.new(0.5, 0.5)
    tip.Size = UDim2.new(0, 7, 0, 7)
    tip.Position = UDim2.new(1, 0, 0.5, 0)
    tip.BackgroundColor3 = Color3.fromRGB(240, 250, 255)
    tip.BorderSizePixel = 0
    tip.ZIndex = 95
    tip.Parent = ring
    Instance.new("UICorner", tip).CornerRadius = UDim.new(1, 0)
    table.insert(orbitTips, tip)
end

local SweepBeam = Instance.new("Frame")
SweepBeam.AnchorPoint = Vector2.new(0.5, 0.5)
SweepBeam.Size = UDim2.new(0, 140, 0, 2)
SweepBeam.Position = UDim2.new(0.35, 0, 0.72, 0)
SweepBeam.Rotation = -22
SweepBeam.BackgroundColor3 = Color3.fromRGB(210, 240, 255)
SweepBeam.BorderSizePixel = 0
SweepBeam.ZIndex = 94
SweepBeam.Parent = IntroStage
Instance.new("UICorner", SweepBeam).CornerRadius = UDim.new(1, 0)

local CoreHalo = Instance.new("Frame")
CoreHalo.AnchorPoint = Vector2.new(0.5, 0.5)
CoreHalo.Size = UDim2.new(0, 10, 0, 10)
CoreHalo.Position = UDim2.new(0.5, 0, 0.5, 0)
CoreHalo.BackgroundColor3 = Color3.fromRGB(130, 200, 255)
CoreHalo.BackgroundTransparency = 0.7
CoreHalo.BorderSizePixel = 0
CoreHalo.ZIndex = 94
CoreHalo.Parent = IntroStage
Instance.new("UICorner", CoreHalo).CornerRadius = UDim.new(1, 0)

local CoreFlare = Instance.new("Frame")
CoreFlare.AnchorPoint = Vector2.new(0.5, 0.5)
CoreFlare.Size = UDim2.new(0, 6, 0, 6)
CoreFlare.Position = UDim2.new(0.5, 0, 0.5, 0)
CoreFlare.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
CoreFlare.BorderSizePixel = 0
CoreFlare.ZIndex = 97
CoreFlare.Parent = IntroStage
Instance.new("UICorner", CoreFlare).CornerRadius = UDim.new(1, 0)

local FlareRayH = Instance.new("Frame")
FlareRayH.AnchorPoint = Vector2.new(0.5, 0.5)
FlareRayH.Size = UDim2.new(0, 180, 0, 2)
FlareRayH.Position = UDim2.new(0.5, 0, 0.5, 0)
FlareRayH.BackgroundColor3 = Color3.fromRGB(215, 242, 255)
FlareRayH.BackgroundTransparency = 1
FlareRayH.BorderSizePixel = 0
FlareRayH.ZIndex = 96
FlareRayH.Parent = IntroStage

local FlareRayV = Instance.new("Frame")
FlareRayV.AnchorPoint = Vector2.new(0.5, 0.5)
FlareRayV.Size = UDim2.new(0, 2, 0, 92)
FlareRayV.Position = UDim2.new(0.5, 0, 0.5, 0)
FlareRayV.BackgroundColor3 = Color3.fromRGB(215, 242, 255)
FlareRayV.BackgroundTransparency = 1
FlareRayV.BorderSizePixel = 0
FlareRayV.ZIndex = 96
FlareRayV.Parent = IntroStage

local IntroBarBg = Instance.new("Frame")
IntroBarBg.Size = UDim2.new(1, -24, 0, 7)
IntroBarBg.Position = UDim2.new(0, 12, 0, 139)
IntroBarBg.BackgroundColor3 = Color3.fromRGB(20, 26, 40)
IntroBarBg.BorderSizePixel = 0
IntroBarBg.ZIndex = 91
IntroBarBg.Parent = IntroRectFrame
Instance.new("UICorner", IntroBarBg).CornerRadius = UDim.new(1, 0)

local IntroBarFill = Instance.new("Frame")
IntroBarFill.Size = UDim2.new(0, 0, 1, 0)
IntroBarFill.BackgroundColor3 = Color3.fromRGB(145, 215, 255)
IntroBarFill.BorderSizePixel = 0
IntroBarFill.ZIndex = 92
IntroBarFill.Parent = IntroBarBg
Instance.new("UICorner", IntroBarFill).CornerRadius = UDim.new(1, 0)

local IntroSubLabel = Instance.new("TextLabel")
IntroSubLabel.Size = UDim2.new(1, -24, 0, 18)
IntroSubLabel.Position = UDim2.new(0, 12, 0, 151)
IntroSubLabel.BackgroundTransparency = 1
IntroSubLabel.Text = "Đang chạy intro... 0%"
IntroSubLabel.TextColor3 = Color3.fromRGB(190, 215, 240)
IntroSubLabel.TextSize = 10
IntroSubLabel.Font = Enum.Font.Code
IntroSubLabel.TextXAlignment = Enum.TextXAlignment.Left
IntroSubLabel.ZIndex = 91
IntroSubLabel.Parent = IntroRectFrame

-- ==========================================
-- KHUNG NHẬP KEY CÓ HIỆU ỨNG TUYẾT RƠI
-- ==========================================
local KeyPanel = Instance.new("Frame")
KeyPanel.Name = "KeySystemPanel"
KeyPanel.AnchorPoint = Vector2.new(0.5, 0.5)
KeyPanel.Size = UDim2.new(0, 336, 0, 212)
KeyPanel.Position = UDim2.new(0.5, 0, 0.5, 10)
KeyPanel.BackgroundColor3 = Color3.fromRGB(16, 20, 34)
KeyPanel.BorderSizePixel = 0
KeyPanel.ClipsDescendants = true
KeyPanel.Active = true
KeyPanel.Draggable = true
KeyPanel.Visible = false
KeyPanel.ZIndex = 70
KeyPanel.Parent = ScreenGui
Instance.new("UICorner", KeyPanel).CornerRadius = UDim.new(0, 18)

local KeyStroke = Instance.new("UIStroke")
KeyStroke.Color = Color3.fromRGB(126, 232, 192)
KeyStroke.Thickness = 1.6
KeyStroke.Parent = KeyPanel

local FxLayer = Instance.new("Frame")
FxLayer.Size = UDim2.new(1, 0, 1, 0)
FxLayer.BackgroundTransparency = 1
FxLayer.ZIndex = 71
FxLayer.Parent = KeyPanel

local snowFlakes = {}
for i = 1, 24 do
    local flake = Instance.new("Frame")
    local sz = (i % 3 == 0) and 5 or ((i % 2 == 0) and 4 or 3)
    flake.Size = UDim2.new(0, sz, 0, sz)
    flake.Position = UDim2.new((i * 0.041) % 1, 0, (i * 0.13) % 1, 0)
    flake.BackgroundColor3 = (i % 4 == 0) and Color3.fromRGB(150, 225, 255) or Color3.fromRGB(245, 250, 255)
    flake.BackgroundTransparency = 0.25 + (i % 4) * 0.15
    flake.BorderSizePixel = 0
    flake.ZIndex = 71
    flake.Parent = FxLayer
    Instance.new("UICorner", flake).CornerRadius = UDim.new(1, 0)
    table.insert(snowFlakes, {
        obj = flake,
        xBase = (i * 0.041) % 1,
        yPos = (i * 0.13) % 1,
        speedY = 0.14 + (i % 5) * 0.045,
        swayAmp = 0.012 + (i % 3) * 0.006,
        swayFreq = 1.5 + (i % 4) * 0.5,
        phase = i * 0.7
    })
end

local KeyTitle = Instance.new("TextLabel")
KeyTitle.Size = UDim2.new(1, -24, 0, 28)
KeyTitle.Position = UDim2.new(0, 12, 0, 14)
KeyTitle.BackgroundTransparency = 1
KeyTitle.Text = "❄️ NHẬP KEY KÍCH HOẠT"
KeyTitle.TextColor3 = Color3.fromRGB(244, 240, 232)
KeyTitle.TextSize = 14
KeyTitle.Font = Enum.Font.GothamBold
KeyTitle.ZIndex = 73
KeyTitle.Parent = KeyPanel

local KeyInputBox = Instance.new("TextBox")
KeyInputBox.Size = UDim2.new(1, -32, 0, 38)
KeyInputBox.Position = UDim2.new(0, 16, 0, 52)
KeyInputBox.BackgroundColor3 = Color3.fromRGB(28, 34, 54)
KeyInputBox.BackgroundTransparency = 0.15
KeyInputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyInputBox.PlaceholderColor3 = Color3.fromRGB(145, 160, 190)
KeyInputBox.PlaceholderText = "Nhập key..."
KeyInputBox.Text = ""
KeyInputBox.TextSize = 12
KeyInputBox.Font = Enum.Font.GothamBold
KeyInputBox.ClearTextOnFocus = false
KeyInputBox.ZIndex = 73
KeyInputBox.Parent = KeyPanel
Instance.new("UICorner", KeyInputBox).CornerRadius = UDim.new(0, 10)
local KeyBoxStroke = Instance.new("UIStroke")
KeyBoxStroke.Color = Color3.fromRGB(90, 165, 255)
KeyBoxStroke.Thickness = 1.2
KeyBoxStroke.Parent = KeyInputBox

local KeyStatusLabel = Instance.new("TextLabel")
KeyStatusLabel.Size = UDim2.new(1, -32, 0, 22)
KeyStatusLabel.Position = UDim2.new(0, 16, 0, 96)
KeyStatusLabel.BackgroundTransparency = 1
KeyStatusLabel.Text = ""
KeyStatusLabel.TextColor3 = Color3.fromRGB(255, 125, 140)
KeyStatusLabel.TextSize = 10
KeyStatusLabel.Font = Enum.Font.GothamBold
KeyStatusLabel.ZIndex = 73
KeyStatusLabel.Parent = KeyPanel

local SubmitKeyBtn = Instance.new("TextButton")
SubmitKeyBtn.Size = UDim2.new(0.62, -20, 0, 38)
SubmitKeyBtn.Position = UDim2.new(0, 16, 0, 124)
SubmitKeyBtn.BackgroundColor3 = Color3.fromRGB(126, 232, 192)
SubmitKeyBtn.TextColor3 = Color3.fromRGB(14, 18, 28)
SubmitKeyBtn.Text = "✨ Xác nhận Key"
SubmitKeyBtn.TextSize = 12
SubmitKeyBtn.Font = Enum.Font.GothamBold
SubmitKeyBtn.ZIndex = 73
SubmitKeyBtn.Parent = KeyPanel
Instance.new("UICorner", SubmitKeyBtn).CornerRadius = UDim.new(0, 10)

local FxToggleBtn = Instance.new("TextButton")
FxToggleBtn.Size = UDim2.new(0.38, -16, 0, 38)
FxToggleBtn.Position = UDim2.new(0.62, 4, 0, 124)
FxToggleBtn.BackgroundColor3 = Color3.fromRGB(26, 32, 50)
FxToggleBtn.BackgroundTransparency = 0.2
FxToggleBtn.TextColor3 = Color3.fromRGB(165, 220, 255)
FxToggleBtn.Text = "❄️ Tuyết: BẬT"
FxToggleBtn.TextSize = 10
FxToggleBtn.Font = Enum.Font.GothamBold
FxToggleBtn.ZIndex = 73
FxToggleBtn.Parent = KeyPanel
Instance.new("UICorner", FxToggleBtn).CornerRadius = UDim.new(0, 10)

local snowEnabled = true
onButtonClicked(FxToggleBtn, function()
    snowEnabled = not snowEnabled
    FxLayer.Visible = snowEnabled
    FxToggleBtn.Text = snowEnabled and "❄️ Tuyết: BẬT" or "❄️ Tuyết: TẮT"
end)

local function lockToKeyScreen(reasonText)
    isKeyUnlocked = false
    MainFrame.Visible = false
    ToggleIconBtn.Visible = false
    KeyPanel.Visible = true
    KeyInputBox.Text = ""
    KeyStatusLabel.TextColor3 = Color3.fromRGB(255, 125, 140)
    KeyStatusLabel.Text = reasonText or "Key không còn hiệu lực!"
end

local refreshAdminView

local function unlockScriptWithKey(k)
    ActiveKeyName = k
    if KeyStore[k] then
        if not KeyStore[k].deviceInfo then
            KeyStore[k].deviceInfo = getDeviceSummary()
        end
        if not KeyStore[k].usedAt then
            KeyStore[k].usedAt = getVnTimeString()
        end
    end
    isKeyUnlocked = true
    KeyPanel.Visible = false
    ToggleIconBtn.Visible = true
    MainFrame.Visible = true
    isMenuVisible = true
    if refreshAdminView then
        refreshAdminView()
    end
end

onButtonClicked(SubmitKeyBtn, function()
    local entered = string.upper((KeyInputBox.Text or ""):gsub("^%s+", ""):gsub("%s+$", ""))
    local ok, msg = isKeyValid(entered)
    if ok then
        KeyStatusLabel.TextColor3 = Color3.fromRGB(126, 232, 192)
        KeyStatusLabel.Text = "Key hợp lệ! Đang mở menu..."
        task.wait(0.2)
        unlockScriptWithKey(entered)
    else
        KeyStatusLabel.TextColor3 = Color3.fromRGB(255, 125, 140)
        KeyStatusLabel.Text = msg
    end
end)

local introElapsed = 0
local introDuration = 3.2
local introConn
introConn = RunService.Heartbeat:Connect(function(dt)
    introElapsed = introElapsed + dt
    local ratio = math.clamp(introElapsed / introDuration, 0, 1)
    IntroBarFill.Size = UDim2.new(ratio, 0, 1, 0)
    IntroSubLabel.Text = string.format("Đang chạy intro... %d%%", math.floor(ratio * 100))

    local sweepP = math.clamp(ratio / 0.55, 0, 1)
    SweepBeam.Position = UDim2.new(0.28 + 0.22 * sweepP, 0, 0.75 - 0.25 * sweepP, 0)
    SweepBeam.BackgroundTransparency = sweepP > 0.85 and ((sweepP - 0.85) / 0.15) or 0

    local convergeP = math.clamp((ratio - 0.1) / 0.5, 0, 1)
    for i, stroke in ipairs(orbitRings) do
        stroke.Transparency = 0.85 - 0.65 * convergeP
        local tip = orbitTips[i]
        local angle = (introElapsed * (1.8 + i * 0.45)) + (i * 1.4)
        local rx = (0.35 - 0.15 * convergeP) * math.cos(angle)
        local ry = (0.35 - 0.15 * convergeP) * math.sin(angle)
        tip.Position = UDim2.new(0.5 + rx, 0, 0.5 + ry, 0)
    end

    local spinBoost = ratio > 0.55 and ((ratio - 0.55) * 4.5) or 0
    OrbitCenter.Rotation = (introElapsed * 65 + spinBoost * 30) % 360

    local flareP = math.clamp((ratio - 0.72) / 0.28, 0, 1)
    local haloSize = 10 + flareP * 78
    CoreHalo.Size = UDim2.new(0, haloSize, 0, haloSize)
    CoreHalo.BackgroundTransparency = 0.72 - 0.42 * flareP

    local coreSize = 6 + flareP * 18
    CoreFlare.Size = UDim2.new(0, coreSize, 0, coreSize)

    FlareRayH.BackgroundTransparency = 1 - flareP * 0.85
    FlareRayV.BackgroundTransparency = 1 - flareP * 0.85
    FlareRayH.Size = UDim2.new(0, 60 + flareP * 180, 0, 2)
    FlareRayV.Size = UDim2.new(0, 2, 0, 24 + flareP * 72)

    if ratio >= 1 then
        if introConn then introConn:Disconnect() end
        if IntroRectFrame then
            IntroRectFrame:Destroy()
        end
        KeyPanel.Visible = true
    end
end)

-- --- TAB 1: WEBHOOK (CÓ THANH CUỘN) ---
local Tab1Content = Instance.new("ScrollingFrame")
Tab1Content.Size = UDim2.new(1, -16, 1, -70)
Tab1Content.Position = UDim2.new(0, 8, 0, 66)
Tab1Content.BackgroundTransparency = 1
Tab1Content.BorderSizePixel = 0
Tab1Content.CanvasSize = UDim2.new(0, 0, 0, 310)
Tab1Content.ScrollBarThickness = 4
Tab1Content.Visible = true
Tab1Content.ZIndex = 12
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
StatusLabel.ZIndex = 13
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
CustomMoneyInput.ZIndex = 13
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
SaveMoneyBtn.ZIndex = 13
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
FilterDropdownBtn.ZIndex = 13
FilterDropdownBtn.Parent = Tab1Content
Instance.new("UICorner", FilterDropdownBtn).CornerRadius = UDim.new(0, 6)

local DropdownListFrame = Instance.new("ScrollingFrame")
DropdownListFrame.Size = UDim2.new(1, -6, 0, 90)
DropdownListFrame.Position = UDim2.new(0, 0, 0, 136)
DropdownListFrame.BackgroundColor3 = Color3.fromRGB(28, 30, 42)
DropdownListFrame.BorderSizePixel = 0
DropdownListFrame.Visible = false
DropdownListFrame.CanvasSize = UDim2.new(0, 0, 0, 175)
DropdownListFrame.ScrollBarThickness = 4
DropdownListFrame.ZIndex = 14
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
    optBtn.ZIndex = 15
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
end)

local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(1, -6, 0, 36)
ToggleButton.Position = UDim2.new(0, 0, 0, 140)
ToggleButton.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 13
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.Text = "STOP SCRIPT"
ToggleButton.ZIndex = 13
ToggleButton.Parent = Tab1Content
Instance.new("UICorner", ToggleButton).CornerRadius = UDim.new(0, 8)

local FooterLabel = Instance.new("TextLabel")
FooterLabel.Size = UDim2.new(1, -6, 0, 28)
FooterLabel.Position = UDim2.new(0, 0, 0, 184)
FooterLabel.BackgroundTransparency = 1
FooterLabel.TextColor3 = Color3.fromRGB(165, 165, 180)
FooterLabel.TextSize = 11
FooterLabel.Font = Enum.Font.Gotham
FooterLabel.TextWrapped = true
FooterLabel.Text = "Đã gửi: 0 thú | Trạng thái: 🟢 Đang chạy"
FooterLabel.ZIndex = 13
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

-- --- TAB 3: SETTINGS (CÓ THANH CUỘN) ---
local Tab3Content = Instance.new("ScrollingFrame")
Tab3Content.Size = UDim2.new(1, -16, 1, -70)
Tab3Content.Position = UDim2.new(0, 8, 0, 66)
Tab3Content.BackgroundTransparency = 1
Tab3Content.BorderSizePixel = 0
Tab3Content.CanvasSize = UDim2.new(0, 0, 0, 210)
Tab3Content.ScrollBarThickness = 4
Tab3Content.Visible = false
Tab3Content.ZIndex = 12
Tab3Content.Parent = MainFrame

local SettingsInfoLabel = Instance.new("TextLabel")
SettingsInfoLabel.Size = UDim2.new(1, -6, 0, 140)
SettingsInfoLabel.Position = UDim2.new(0, 0, 0, 0)
SettingsInfoLabel.BackgroundColor3 = Color3.fromRGB(32, 34, 46)
SettingsInfoLabel.TextColor3 = Color3.fromRGB(225, 225, 235)
SettingsInfoLabel.TextSize = 11
SettingsInfoLabel.Font = Enum.Font.Code
SettingsInfoLabel.TextWrapped = true
SettingsInfoLabel.TextXAlignment = Enum.TextXAlignment.Left
SettingsInfoLabel.TextYAlignment = Enum.TextYAlignment.Top
SettingsInfoLabel.Text = " ⚙️ Cài đặt nâng cao:\n • Tự động quét Backpack & Character\n • Hỗ trợ lọc hậu tố tiền K, M, B, T, Qa, spd...\n • Lưu lịch sử thú bắt được kèm giờ Việt Nam"
SettingsInfoLabel.ZIndex = 13
SettingsInfoLabel.Parent = Tab3Content
Instance.new("UICorner", SettingsInfoLabel).CornerRadius = UDim.new(0, 8)

-- --- TAB 4: ADMIN (DANH SÁCH THIẾT BỊ/KEY -> DÒNG CHI TIẾT -> TRANG TÙY CHỈNH KEY) ---
local Tab4Content = Instance.new("Frame")
Tab4Content.Size = UDim2.new(1, -16, 1, -70)
Tab4Content.Position = UDim2.new(0, 8, 0, 66)
Tab4Content.BackgroundTransparency = 1
Tab4Content.Visible = false
Tab4Content.ZIndex = 12
Tab4Content.Parent = MainFrame

local AdminListPage = Instance.new("Frame")
AdminListPage.Size = UDim2.new(1, 0, 1, 0)
AdminListPage.BackgroundTransparency = 1
AdminListPage.Visible = true
AdminListPage.ZIndex = 12
AdminListPage.Parent = Tab4Content

local AdminRoleBanner = Instance.new("TextLabel")
AdminRoleBanner.Size = UDim2.new(1, -6, 0, 22)
AdminRoleBanner.Position = UDim2.new(0, 0, 0, 0)
AdminRoleBanner.BackgroundColor3 = Color3.fromRGB(28, 30, 42)
AdminRoleBanner.TextColor3 = Color3.fromRGB(126, 232, 192)
AdminRoleBanner.TextSize = 10
AdminRoleBanner.Font = Enum.Font.GothamBold
AdminRoleBanner.Text = "Đang tải quyền..."
AdminRoleBanner.ZIndex = 13
AdminRoleBanner.Parent = AdminListPage
Instance.new("UICorner", AdminRoleBanner).CornerRadius = UDim.new(0, 6)

local AdminKeyScroll = Instance.new("ScrollingFrame")
AdminKeyScroll.Size = UDim2.new(1, -6, 0, 132)
AdminKeyScroll.Position = UDim2.new(0, 0, 0, 26)
AdminKeyScroll.BackgroundColor3 = Color3.fromRGB(26, 28, 40)
AdminKeyScroll.BorderSizePixel = 0
AdminKeyScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
AdminKeyScroll.ScrollBarThickness = 4
AdminKeyScroll.ZIndex = 13
AdminKeyScroll.Parent = AdminListPage
Instance.new("UICorner", AdminKeyScroll).CornerRadius = UDim.new(0, 8)

local AdminKeyLayout = Instance.new("UIListLayout")
AdminKeyLayout.SortOrder = Enum.SortOrder.LayoutOrder
AdminKeyLayout.Padding = UDim.new(0, 5)
AdminKeyLayout.Parent = AdminKeyScroll

-- Dòng chi tiết hiện ra khi ấn vào 1 key trên danh sách; ấn tiếp vào dòng chi tiết để mở trang tùy chỉnh key
local KeyDetailRowBtn = Instance.new("TextButton")
KeyDetailRowBtn.Size = UDim2.new(1, -6, 0, 96)
KeyDetailRowBtn.Position = UDim2.new(0, 0, 0, 164)
KeyDetailRowBtn.BackgroundColor3 = Color3.fromRGB(34, 38, 56)
KeyDetailRowBtn.TextColor3 = Color3.fromRGB(240, 245, 255)
KeyDetailRowBtn.TextSize = 10
KeyDetailRowBtn.Font = Enum.Font.Code
KeyDetailRowBtn.TextWrapped = true
KeyDetailRowBtn.TextXAlignment = Enum.TextXAlignment.Left
KeyDetailRowBtn.TextYAlignment = Enum.TextYAlignment.Top
KeyDetailRowBtn.Visible = false
KeyDetailRowBtn.Text = ""
KeyDetailRowBtn.ZIndex = 14
KeyDetailRowBtn.Parent = AdminListPage
Instance.new("UICorner", KeyDetailRowBtn).CornerRadius = UDim.new(0, 8)
local DetailRowStroke = Instance.new("UIStroke")
DetailRowStroke.Color = Color3.fromRGB(90, 165, 255)
DetailRowStroke.Thickness = 1.2
DetailRowStroke.Parent = KeyDetailRowBtn

-- Trang tùy chỉnh key riêng biệt
local KeyEditPage = Instance.new("ScrollingFrame")
KeyEditPage.Size = UDim2.new(1, -6, 1, 0)
KeyEditPage.Position = UDim2.new(0, 0, 0, 0)
KeyEditPage.BackgroundTransparency = 1
KeyEditPage.BorderSizePixel = 0
KeyEditPage.CanvasSize = UDim2.new(0, 0, 0, 290)
KeyEditPage.ScrollBarThickness = 4
KeyEditPage.Visible = false
KeyEditPage.ZIndex = 13
KeyEditPage.Parent = Tab4Content

local BackToAdminListBtn = Instance.new("TextButton")
BackToAdminListBtn.Size = UDim2.new(1, 0, 0, 26)
BackToAdminListBtn.Position = UDim2.new(0, 0, 0, 0)
BackToAdminListBtn.BackgroundColor3 = Color3.fromRGB(52, 73, 94)
BackToAdminListBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
BackToAdminListBtn.Text = "⬅️ Quay lại danh sách Key & Thiết bị"
BackToAdminListBtn.TextSize = 10
BackToAdminListBtn.Font = Enum.Font.GothamBold
BackToAdminListBtn.ZIndex = 14
BackToAdminListBtn.Parent = KeyEditPage
Instance.new("UICorner", BackToAdminListBtn).CornerRadius = UDim.new(0, 6)

local EditTargetSummary = Instance.new("TextLabel")
EditTargetSummary.Size = UDim2.new(1, 0, 0, 68)
EditTargetSummary.Position = UDim2.new(0, 0, 0, 32)
EditTargetSummary.BackgroundColor3 = Color3.fromRGB(32, 34, 46)
EditTargetSummary.TextColor3 = Color3.fromRGB(235, 240, 255)
EditTargetSummary.TextSize = 10
EditTargetSummary.Font = Enum.Font.Code
EditTargetSummary.TextWrapped = true
EditTargetSummary.TextXAlignment = Enum.TextXAlignment.Left
EditTargetSummary.TextYAlignment = Enum.TextYAlignment.Top
EditTargetSummary.Text = ""
EditTargetSummary.ZIndex = 14
EditTargetSummary.Parent = KeyEditPage
Instance.new("UICorner", EditTargetSummary).CornerRadius = UDim.new(0, 8)

local AddHoursBox = Instance.new("TextBox")
AddHoursBox.Size = UDim2.new(0.46, -3, 0, 28)
AddHoursBox.Position = UDim2.new(0, 0, 0, 106)
AddHoursBox.BackgroundColor3 = Color3.fromRGB(32, 34, 46)
AddHoursBox.TextColor3 = Color3.fromRGB(255, 255, 255)
AddHoursBox.PlaceholderColor3 = Color3.fromRGB(150, 155, 175)
AddHoursBox.PlaceholderText = "Số giờ (vd: 24)"
AddHoursBox.Text = "24"
AddHoursBox.TextSize = 10
AddHoursBox.Font = Enum.Font.GothamBold
AddHoursBox.ClearTextOnFocus = false
AddHoursBox.ZIndex = 14
AddHoursBox.Parent = KeyEditPage
Instance.new("UICorner", AddHoursBox).CornerRadius = UDim.new(0, 6)

local AddTimeBtn = Instance.new("TextButton")
AddTimeBtn.Size = UDim2.new(0.27, -3, 0, 28)
AddTimeBtn.Position = UDim2.new(0.46, 2, 0, 106)
AddTimeBtn.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
AddTimeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
AddTimeBtn.Text = "+ Thêm"
AddTimeBtn.TextSize = 10
AddTimeBtn.Font = Enum.Font.GothamBold
AddTimeBtn.ZIndex = 14
AddTimeBtn.Parent = KeyEditPage
Instance.new("UICorner", AddTimeBtn).CornerRadius = UDim.new(0, 6)

local SubTimeBtn = Instance.new("TextButton")
SubTimeBtn.Size = UDim2.new(0.27, -2, 0, 28)
SubTimeBtn.Position = UDim2.new(0.73, 1, 0, 106)
SubTimeBtn.BackgroundColor3 = Color3.fromRGB(230, 126, 34)
SubTimeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SubTimeBtn.Text = "- Bớt"
SubTimeBtn.TextSize = 10
SubTimeBtn.Font = Enum.Font.GothamBold
SubTimeBtn.ZIndex = 14
SubTimeBtn.Parent = KeyEditPage
Instance.new("UICorner", SubTimeBtn).CornerRadius = UDim.new(0, 6)

local Quick1hBtn = Instance.new("TextButton")
Quick1hBtn.Size = UDim2.new(0.32, -3, 0, 26)
Quick1hBtn.Position = UDim2.new(0, 0, 0, 140)
Quick1hBtn.BackgroundColor3 = Color3.fromRGB(52, 73, 94)
Quick1hBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
Quick1hBtn.Text = "+1 Giờ"
Quick1hBtn.TextSize = 10
Quick1hBtn.Font = Enum.Font.GothamBold
Quick1hBtn.ZIndex = 14
Quick1hBtn.Parent = KeyEditPage
Instance.new("UICorner", Quick1hBtn).CornerRadius = UDim.new(0, 6)

local Quick7dBtn = Instance.new("TextButton")
Quick7dBtn.Size = UDim2.new(0.32, -3, 0, 26)
Quick7dBtn.Position = UDim2.new(0.34, 0, 0, 140)
Quick7dBtn.BackgroundColor3 = Color3.fromRGB(52, 73, 94)
Quick7dBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
Quick7dBtn.Text = "+7 Ngày"
Quick7dBtn.TextSize = 10
Quick7dBtn.Font = Enum.Font.GothamBold
Quick7dBtn.ZIndex = 14
Quick7dBtn.Parent = KeyEditPage
Instance.new("UICorner", Quick7dBtn).CornerRadius = UDim.new(0, 6)

local PermKeyBtn = Instance.new("TextButton")
PermKeyBtn.Size = UDim2.new(0.32, -1, 0, 26)
PermKeyBtn.Position = UDim2.new(0.68, 0, 0, 140)
PermKeyBtn.BackgroundColor3 = Color3.fromRGB(61, 139, 255)
PermKeyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
PermKeyBtn.Text = "♾️ Vĩnh viễn"
PermKeyBtn.TextSize = 10
PermKeyBtn.Font = Enum.Font.GothamBold
PermKeyBtn.ZIndex = 14
PermKeyBtn.Parent = KeyEditPage
Instance.new("UICorner", PermKeyBtn).CornerRadius = UDim.new(0, 6)

local DeleteForeverKeyBtn = Instance.new("TextButton")
DeleteForeverKeyBtn.Size = UDim2.new(1, 0, 0, 32)
DeleteForeverKeyBtn.Position = UDim2.new(0, 0, 0, 172)
DeleteForeverKeyBtn.BackgroundColor3 = Color3.fromRGB(192, 57, 43)
DeleteForeverKeyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
DeleteForeverKeyBtn.Text = "🗑️ XÓA VĨNH VIỄN KEY NÀY"
DeleteForeverKeyBtn.TextSize = 10
DeleteForeverKeyBtn.Font = Enum.Font.GothamBold
DeleteForeverKeyBtn.ZIndex = 14
DeleteForeverKeyBtn.Parent = KeyEditPage
Instance.new("UICorner", DeleteForeverKeyBtn).CornerRadius = UDim.new(0, 6)

local AdminActionStatus = Instance.new("TextLabel")
AdminActionStatus.Size = UDim2.new(1, 0, 0, 34)
AdminActionStatus.Position = UDim2.new(0, 0, 0, 210)
AdminActionStatus.BackgroundColor3 = Color3.fromRGB(28, 30, 42)
AdminActionStatus.TextColor3 = Color3.fromRGB(126, 232, 192)
AdminActionStatus.TextSize = 10
AdminActionStatus.Font = Enum.Font.Code
AdminActionStatus.TextWrapped = true
AdminActionStatus.Text = ""
AdminActionStatus.ZIndex = 14
AdminActionStatus.Parent = KeyEditPage
Instance.new("UICorner", AdminActionStatus).CornerRadius = UDim.new(0, 6)

local selectedAdminKey = nil

local function buildKeyDetailSummary(k)
    if not k or k == "" then return "" end
    local entry = KeyStore[k]
    if entry then
        local roleStr = entry.isAdmin and "Admin" or "Key thường"
        local remStr = formatRemainingTime(entry.expireAt)
        local devStr = entry.deviceInfo or "Chưa có thiết bị nhập"
        local timeStr = entry.usedAt or "Chưa kích hoạt"
        return string.format(
            "🔑 Key: %s [%s]\n📱 Thiết bị: %s\n⏳ Còn lại: %s | 🕒 %s\n👉 Ấn vào đây để mở trang tùy chỉnh key",
            k, roleStr, devStr, remStr, timeStr
        )
    elseif RevokedKeys[k] then
        return string.format("🔑 Key: %s\n🗑️ Trạng thái: Đã xóa vĩnh viễn", k)
    end
    return ""
end

local function openKeyEditPage(k)
    if not k or k == "" then return end
    selectedAdminKey = k
    AdminListPage.Visible = false
    KeyEditPage.Visible = true
    EditTargetSummary.Text = buildKeyDetailSummary(k)
end

refreshAdminView = function()
    local canManage = isCurrentUserAdmin()
    if canManage then
        AdminRoleBanner.TextColor3 = Color3.fromRGB(126, 232, 192)
        AdminRoleBanner.Text = "🛡️ Quyền ADMIN • Ấn key -> xem chi tiết -> ấn chi tiết để tùy chỉnh"
    else
        AdminRoleBanner.TextColor3 = Color3.fromRGB(255, 180, 90)
        AdminRoleBanner.Text = "👤 Key thường • Chỉ xem danh sách & chi tiết (khóa chỉnh/xóa)"
    end

    AddHoursBox.Active = canManage
    AddTimeBtn.Active = canManage
    SubTimeBtn.Active = canManage
    Quick1hBtn.Active = canManage
    Quick7dBtn.Active = canManage
    PermKeyBtn.Active = canManage
    DeleteForeverKeyBtn.Active = canManage

    local alpha = canManage and 0 or 0.55
    AddTimeBtn.BackgroundTransparency = alpha
    SubTimeBtn.BackgroundTransparency = alpha
    Quick1hBtn.BackgroundTransparency = alpha
    Quick7dBtn.BackgroundTransparency = alpha
    PermKeyBtn.BackgroundTransparency = alpha
    DeleteForeverKeyBtn.BackgroundTransparency = alpha

    for _, child in ipairs(AdminKeyScroll:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end

    local keysList = {}
    for k, entry in pairs(KeyStore) do
        table.insert(keysList, { code = k, entry = entry })
    end
    table.sort(keysList, function(a, b)
        local aUsed = a.entry.deviceInfo ~= nil
        local bUsed = b.entry.deviceInfo ~= nil
        if aUsed ~= bUsed then return aUsed end
        return a.code < b.code
    end)

    for idx, item in ipairs(keysList) do
        local k = item.code
        local entry = item.entry
        local isSelected = (selectedAdminKey == k)

        local rowBtn = Instance.new("TextButton")
        rowBtn.Size = UDim2.new(1, -6, 0, 40)
        rowBtn.BackgroundColor3 = isSelected and Color3.fromRGB(48, 56, 84) or Color3.fromRGB(34, 36, 50)
        rowBtn.TextColor3 = Color3.fromRGB(240, 242, 250)
        rowBtn.TextSize = 10
        rowBtn.Font = Enum.Font.Code
        rowBtn.TextXAlignment = Enum.TextXAlignment.Left
        rowBtn.TextWrapped = true
        rowBtn.LayoutOrder = idx
        rowBtn.ZIndex = 14

        local devShort = entry.deviceInfo or "Chưa gắn thiết bị"
        local roleTag = entry.isAdmin and "ADMIN" or "THƯỜNG"
        rowBtn.Text = string.format(" 🔑 %s [%s] • ⏳ %s\n 📱 %s", k, roleTag, formatRemainingTime(entry.expireAt), devShort)
        rowBtn.Parent = AdminKeyScroll
        Instance.new("UICorner", rowBtn).CornerRadius = UDim.new(0, 6)

        onButtonClicked(rowBtn, function()
            selectedAdminKey = k
            KeyDetailRowBtn.Visible = true
            KeyDetailRowBtn.Text = buildKeyDetailSummary(k)
            refreshAdminView()
        end)
    end

    AdminKeyScroll.CanvasSize = UDim2.new(0, 0, 0, #keysList * 45)

    if selectedAdminKey and (KeyStore[selectedAdminKey] or RevokedKeys[selectedAdminKey]) then
        KeyDetailRowBtn.Visible = true
        KeyDetailRowBtn.Text = buildKeyDetailSummary(selectedAdminKey)
        if KeyEditPage.Visible then
            EditTargetSummary.Text = buildKeyDetailSummary(selectedAdminKey)
        end
    else
        selectedAdminKey = nil
        KeyDetailRowBtn.Visible = false
        if KeyEditPage.Visible then
            KeyEditPage.Visible = false
            AdminListPage.Visible = true
        end
    end
end

onButtonClicked(KeyDetailRowBtn, function()
    if selectedAdminKey then
        openKeyEditPage(selectedAdminKey)
    end
end)

onButtonClicked(BackToAdminListBtn, function()
    KeyEditPage.Visible = false
    AdminListPage.Visible = true
    refreshAdminView()
end)

local function adjustKeySeconds(deltaSec)
    if not isCurrentUserAdmin() then
        AdminActionStatus.TextColor3 = Color3.fromRGB(255, 180, 90)
        AdminActionStatus.Text = "Key hiện tại là KEY THƯỜNG (không có quyền chỉnh sửa)."
        return
    end
    local k = selectedAdminKey
    if not k or k == "" then
        AdminActionStatus.TextColor3 = Color3.fromRGB(255, 125, 140)
        AdminActionStatus.Text = "Chưa chọn key nào."
        return
    end
    if RevokedKeys[k] or not KeyStore[k] then
        AdminActionStatus.TextColor3 = Color3.fromRGB(255, 125, 140)
        AdminActionStatus.Text = "Key " .. k .. " không tồn tại hoặc đã bị xóa vĩnh viễn!"
        return
    end
    local baseTime = KeyStore[k].expireAt or os.time()
    if baseTime < os.time() then baseTime = os.time() end
    KeyStore[k].expireAt = math.max(os.time(), baseTime + deltaSec)
    AdminActionStatus.TextColor3 = Color3.fromRGB(126, 232, 192)
    AdminActionStatus.Text = string.format("Đã cập nhật %s -> Còn: %s", k, formatRemainingTime(KeyStore[k].expireAt))
    refreshAdminView()
end

onButtonClicked(AddTimeBtn, function()
    local hrs = tonumber(AddHoursBox.Text) or 0
    if hrs <= 0 then
        AdminActionStatus.TextColor3 = Color3.fromRGB(255, 125, 140)
        AdminActionStatus.Text = "Nhập số giờ lớn hơn 0."
        return
    end
    adjustKeySeconds(hrs * 3600)
end)

onButtonClicked(SubTimeBtn, function()
    local hrs = tonumber(AddHoursBox.Text) or 0
    if hrs <= 0 then
        AdminActionStatus.TextColor3 = Color3.fromRGB(255, 125, 140)
        AdminActionStatus.Text = "Nhập số giờ lớn hơn 0."
        return
    end
    adjustKeySeconds(-hrs * 3600)
end)

onButtonClicked(Quick1hBtn, function()
    adjustKeySeconds(3600)
end)

onButtonClicked(Quick7dBtn, function()
    adjustKeySeconds(7 * 86400)
end)

onButtonClicked(PermKeyBtn, function()
    if not isCurrentUserAdmin() then
        AdminActionStatus.TextColor3 = Color3.fromRGB(255, 180, 90)
        AdminActionStatus.Text = "Key hiện tại là KEY THƯỜNG (không có quyền chỉnh sửa)."
        return
    end
    local k = selectedAdminKey
    if not k or RevokedKeys[k] or not KeyStore[k] then return end
    KeyStore[k].expireAt = nil
    AdminActionStatus.TextColor3 = Color3.fromRGB(126, 232, 192)
    AdminActionStatus.Text = "Đã đặt key " .. k .. " thành Vĩnh viễn!"
    refreshAdminView()
end)

onButtonClicked(DeleteForeverKeyBtn, function()
    if not isCurrentUserAdmin() then
        AdminActionStatus.TextColor3 = Color3.fromRGB(255, 180, 90)
        AdminActionStatus.Text = "Key hiện tại là KEY THƯỜNG (không có quyền xóa)."
        return
    end
    local k = selectedAdminKey
    if not k or k == "" then return end
    RevokedKeys[k] = true
    KeyStore[k] = nil
    AdminActionStatus.TextColor3 = Color3.fromRGB(255, 125, 140)
    AdminActionStatus.Text = "🗑️ Đã xóa vĩnh viễn key: " .. k
    if ActiveKeyName == k then
        ActiveKeyName = nil
        task.wait(0.25)
        lockToKeyScreen("Key " .. k .. " đã bị xóa vĩnh viễn!")
        return
    end
    refreshAdminView()
end)

-- --- TAB 2: LỊCH SỬ ---
local HistoryRecords = {}
local historyFilterMode = "all"
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
HistorySearch.Visible = false
HistorySearch.ZIndex = 13
HistorySearch.Parent = MainFrame
Instance.new("UICorner", HistorySearch).CornerRadius = UDim.new(0, 6)

local HistoryFilterBtn = Instance.new("TextButton")
HistoryFilterBtn.Size = UDim2.new(0, 34, 0, 30)
HistoryFilterBtn.Position = UDim2.new(0, 158, 0, 68)
HistoryFilterBtn.BackgroundColor3 = Color3.fromRGB(40, 42, 56)
HistoryFilterBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
HistoryFilterBtn.Text = "☷"
HistoryFilterBtn.TextSize = 11
HistoryFilterBtn.Font = Enum.Font.GothamBold
HistoryFilterBtn.Visible = false
HistoryFilterBtn.ZIndex = 13
HistoryFilterBtn.Parent = MainFrame
Instance.new("UICorner", HistoryFilterBtn).CornerRadius = UDim.new(0, 6)

local HistoryClearBtn = Instance.new("TextButton")
HistoryClearBtn.Size = UDim2.new(0, 34, 0, 30)
HistoryClearBtn.Position = UDim2.new(0, 198, 0, 68)
HistoryClearBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
HistoryClearBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
HistoryClearBtn.Text = "🗑️"
HistoryClearBtn.TextSize = 11
HistoryClearBtn.Font = Enum.Font.GothamBold
HistoryClearBtn.Visible = false
HistoryClearBtn.ZIndex = 13
HistoryClearBtn.Parent = MainFrame
Instance.new("UICorner", HistoryClearBtn).CornerRadius = UDim.new(0, 6)

local HistoryCountLabel = Instance.new("TextLabel")
HistoryCountLabel.Size = UDim2.new(0, 72, 0, 30)
HistoryCountLabel.Position = UDim2.new(0, 238, 0, 68)
HistoryCountLabel.BackgroundColor3 = Color3.fromRGB(32, 34, 46)
HistoryCountLabel.TextColor3 = Color3.fromRGB(46, 204, 113)
HistoryCountLabel.TextSize = 11
HistoryCountLabel.Font = Enum.Font.GothamBold
HistoryCountLabel.Text = "0"
HistoryCountLabel.TextXAlignment = Enum.TextXAlignment.Center
HistoryCountLabel.Visible = false
HistoryCountLabel.ZIndex = 13
HistoryCountLabel.Parent = MainFrame
Instance.new("UICorner", HistoryCountLabel).CornerRadius = UDim.new(0, 6)

local HistoryFilterPopup = Instance.new("Frame")
HistoryFilterPopup.Size = UDim2.new(0, 130, 0, 88)
HistoryFilterPopup.Position = UDim2.new(0, 158, 0, 101)
HistoryFilterPopup.BackgroundColor3 = Color3.fromRGB(32, 34, 46)
HistoryFilterPopup.Visible = false
HistoryFilterPopup.ZIndex = 25
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
    b.ZIndex = 26
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

onButtonClicked(HistoryClearBtn, function()
    HistoryRecords = {}
    if refreshHistory then refreshHistory() end
end)

local Tab2Content = Instance.new("ScrollingFrame")
Tab2Content.Size = UDim2.new(1, -12, 1, -110)
Tab2Content.Position = UDim2.new(0, 6, 0, 104)
Tab2Content.BackgroundTransparency = 1
Tab2Content.Visible = false
Tab2Content.CanvasSize = UDim2.new(0, 0, 0, 0)
Tab2Content.ScrollBarThickness = 4
Tab2Content.ZIndex = 12
Tab2Content.Parent = MainFrame

local HistoryLayout = Instance.new("UIListLayout")
HistoryLayout.SortOrder = Enum.SortOrder.LayoutOrder
HistoryLayout.Padding = UDim.new(0, 5)
HistoryLayout.Parent = Tab2Content

refreshHistory = function()
    for _, child in ipairs(Tab2Content:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end
    local shown = 0
    local q = string.lower(HistorySearch.Text or "")
    for _, record in ipairs(HistoryRecords) do
        local d = record.data
        local matchesName = (q == "" or string.find(string.lower(d.Name or ""), q, 1, true) ~= nil)
        local matchesFilter = true
        if historyFilterMode == "value" then
            matchesFilter = (q == "" or string.find(string.lower(tostring(d.MoneyPerSec or "")), q, 1, true) ~= nil)
        elseif historyFilterMode == "rarity" then
            matchesFilter = (q == "" or string.find(string.lower(tostring(d.Rarity or "")), q, 1, true) ~= nil)
        end
        if (historyFilterMode == "all" and matchesName) or (matchesName and matchesFilter) then
            shown = shown + 1
            local itemFrame = Instance.new("Frame")
            itemFrame.Size = UDim2.new(1, -5, 0, 68)
            itemFrame.BackgroundColor3 = Color3.fromRGB(32, 34, 46)
            itemFrame.BorderSizePixel = 0
            itemFrame.LayoutOrder = shown
            itemFrame.ZIndex = 13
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
                "🐾 %s | ⚖️ %s\n✨ %s | 🧬 %s\n💸 %s | ⏰ %s",
                d.Name or "Pet",
                d.Weight or "Không rõ",
                d.Rarity or "Không rõ",
                d.Mutation or "Mặc định",
                d.MoneyPerSec or "Không rõ",
                record.time
            )
            descLabel.ZIndex = 14
            descLabel.Parent = itemFrame
        end
    end
    Tab2Content.CanvasSize = UDim2.new(0, 0, 0, shown * 73)
    HistoryCountLabel.Text = tostring(#HistoryRecords)
end

HistorySearch:GetPropertyChangedSignal("Text"):Connect(function()
    refreshHistory()
end)

local function setActiveTabStyle(activeBtn)
    for _, b in ipairs({Tab1Btn, Tab2Btn, Tab3Btn, Tab4Btn}) do
        if b == activeBtn then
            b.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
            b.TextColor3 = Color3.fromRGB(255, 255, 255)
        else
            b.BackgroundColor3 = Color3.fromRGB(36, 38, 52)
            b.TextColor3 = Color3.fromRGB(185, 185, 200)
        end
    end
end

onButtonClicked(Tab1Btn, function()
    setActiveTabStyle(Tab1Btn)
    Tab1Content.Visible = true
    Tab2Content.Visible = false
    Tab3Content.Visible = false
    Tab4Content.Visible = false
    HistorySearch.Visible = false
    HistoryFilterBtn.Visible = false
    HistoryClearBtn.Visible = false
    HistoryCountLabel.Visible = false
    HistoryFilterPopup.Visible = false
end)

onButtonClicked(Tab2Btn, function()
    setActiveTabStyle(Tab2Btn)
    Tab1Content.Visible = false
    Tab2Content.Visible = true
    Tab3Content.Visible = false
    Tab4Content.Visible = false
    HistorySearch.Visible = true
    HistoryFilterBtn.Visible = true
    HistoryClearBtn.Visible = true
    HistoryCountLabel.Visible = true
    refreshHistory()
end)

onButtonClicked(Tab3Btn, function()
    setActiveTabStyle(Tab3Btn)
    Tab1Content.Visible = false
    Tab2Content.Visible = false
    Tab3Content.Visible = true
    Tab4Content.Visible = false
    HistorySearch.Visible = false
    HistoryFilterBtn.Visible = false
    HistoryClearBtn.Visible = false
    HistoryCountLabel.Visible = false
    HistoryFilterPopup.Visible = false
end)

onButtonClicked(Tab4Btn, function()
    setActiveTabStyle(Tab4Btn)
    Tab1Content.Visible = false
    Tab2Content.Visible = false
    Tab3Content.Visible = false
    Tab4Content.Visible = true
    HistorySearch.Visible = false
    HistoryFilterBtn.Visible = false
    HistoryClearBtn.Visible = false
    HistoryCountLabel.Visible = false
    HistoryFilterPopup.Visible = false
    AdminListPage.Visible = true
    KeyEditPage.Visible = false
    refreshAdminView()
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
    local vnTimeString = getVnTimeString()

    table.insert(HistoryRecords, {data = petData, time = vnTimeString})
    if refreshHistory then refreshHistory() end

    if not isRunning or not httpRequest then return end

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
-- VÒNG LẶP CẬP NHẬT TRẠNG THÁI, ADMIN & TUYẾT
-- ==========================================
local frameCount = 0
local lastFpsUpdate = tick()
local currentFps = 60

RunService.RenderStepped:Connect(function(dt)
    if KeyPanel.Visible and snowEnabled then
        local hue = (tick() * 0.14) % 1
        KeyStroke.Color = Color3.fromHSV(hue, 0.55, 1)
        KeyBoxStroke.Color = Color3.fromHSV((hue + 0.25) % 1, 0.65, 1)

        local t = tick()
        for _, f in ipairs(snowFlakes) do
            f.yPos = f.yPos + f.speedY * dt
            if f.yPos > 1.05 then
                f.yPos = -0.05
            end
            local swayX = math.sin(t * f.swayFreq + f.phase) * f.swayAmp
            local xClamped = math.clamp(f.xBase + swayX, 0.02, 0.98)
            f.obj.Position = UDim2.new(xClamped, 0, f.yPos, 0)
        end
    end

    if isKeyUnlocked and ActiveKeyName then
        local ok, reason = isKeyValid(ActiveKeyName)
        if not ok then
            ActiveKeyName = nil
            lockToKeyScreen(reason)
        end
    end

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

    if DynamicIsland.Visible then
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
