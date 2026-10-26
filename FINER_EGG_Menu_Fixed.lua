--------------- DEOBFUSCADOR BY CEBOSCRIPTS ON TOP
-----------------------------------
repeat task.wait() until game:IsLoaded()

-------
--------------------------------------------------
local Players          = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService       = game:GetService("RunService")
local HttpService      = game:GetService("HttpService")
local TweenService     = game:GetService("TweenService")
local TeleportService  = game:GetService("TeleportService")
local SoundService     = game:GetService("SoundService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace        = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local isMobile    = UserInputService.TouchEnabled

-----------
-------------------------------------------------------------------
local function getGuiParent()
    local ok, result = pcall(function()
        if type(gethui) == "function" then
            return gethui()
        end
    end)
    if ok and result then return result end

    ok, result = pcall(function()
        return game:GetService("CoreGui")
    end)
    if ok and result then return result end

    return LocalPlayer:WaitForChild("PlayerGui")
end

local FIREBASE    = "https://aj-ea01c-default-rtdb.firebaseio.com"
local CONFIG_FILE = "175_AutoJoiner_Config.json"
local IMAGE_ID    = "rbxassetid://71320926153342" -- Asset must be public and approved for in-game use
local CREATOR_LINKS = { TikTok = "", YouTube = "", Discord = "" } -- Fill in your actual profile/invite URLs

local Config = {
    language        = "vi",
    autoJoin        = false,
    autoForce       = false,
    forceTime       = 10,
    threshold       = "500M",
    logSoundId      = "125621644257669",
    logSoundEnabled = true,
    logNotify       = true,
    antiGuard       = false,
    autoSteal       = false,
}

local function saveConfig()
    if not writefile then return end
    pcall(function()
        writefile(CONFIG_FILE, HttpService:JSONEncode(Config))
    end)
end

local function loadConfig()
    if not (readfile and isfile and isfile(CONFIG_FILE)) then return end
    pcall(function()
        local data = HttpService:JSONDecode(readfile(CONFIG_FILE))
        for k, v in pairs(data) do
            if Config[k] ~= nil then Config[k] = v end
        end
    end)
end

loadConfig()

local requestFn = (syn and syn.request) or (http and http.request) or http_request or request

local function httpGet(path)
    local url = FIREBASE .. path
    local body
    pcall(function()
        if requestFn then
            local res = requestFn({
                Url = url,
                Method = "GET",
                Headers = { ["Content-Type"] = "application/json" },
            })
            body = res and res.Body
        else
            body = game:HttpGet(url)
        end
    end)
    return body
end

local function httpPut(path, data)
    if not requestFn then return end
    pcall(function()
        requestFn({
            Url = FIREBASE .. path,
            Method = "PUT",
            Headers = { ["Content-Type"] = "application/json" },
            Body = HttpService:JSONEncode(data),
        })
    end)
end

local function reportEggToFirebase(eggData)
    if not eggData then return end
    local payload = {
        name    = tostring(eggData.name or "Unknown"),
        mps     = tostring(eggData.mps or "0"),
        jobId   = tostring(eggData.jobId or ""),
        placeId = tostring(eggData.placeId or ""),
        server  = tostring(game.JobId or ""),
        time    = os.time(),
    }
    task.spawn(function()
        httpPut("/eggs/" .. tostring(LocalPlayer.UserId) .. ".json", payload)
    end)
end

local function fetchEggsFromFirebase()
    local body = httpGet("/eggs.json")
    if not body or body == "null" then return {} end
    local ok, data = pcall(function()
        return HttpService:JSONDecode(body)
    end)
    if not ok or type(data) ~= "table" then return {} end
    local list = {}
    for _, entry in pairs(data) do
        if type(entry) == "table" and entry.name then
            table.insert(list, entry)
        end
    end
    -- Ordenar por tiempo más reciente
    table.sort(list, function(a, b)
        return (tonumber(a.time) or 0) > (tonumber(b.time) or 0)
    end)
    return list
end

local function parseValue(str)
    if not str then return 0 end
    local s = tostring(str):gsub("%s+", ""):lower()
    local n = tonumber(s:match("[%d%.]+")) or 0
    if s:find("q") then return n * 1e15 end
    if s:find("t") then return n * 1e12 end
    if s:find("b") then return n * 1e9 end
    if s:find("m") then return n * 1e6 end
    if s:find("k") then return n * 1e3 end
    return n
end

local function formatMPS(v)
    v = tonumber(v) or 0
    if v >= 1e15 then return ("$%.1fQ/s"):format(v / 1e15):gsub("%.0", "") end
    if v >= 1e12 then return ("$%.1fT/s"):format(v / 1e12):gsub("%.0", "") end
    if v >= 1e9  then return ("$%.1fB/s"):format(v / 1e9):gsub("%.0", "") end
    if v >= 1e6  then return ("$%.1fM/s"):format(v / 1e6):gsub("%.0", "") end
    if v >= 1e3  then return ("$%.1fK/s"):format(v / 1e3):gsub("%.0", "") end
    return "$" .. math.floor(v) .. "/s"
end

local function age(spawnedAt)
    local t = math.max(0, os.time() - (tonumber(spawnedAt) or os.time()))
    return ("%d:%02d"):format(math.floor(t / 60), t % 60)
end

local function meetsThreshold(mps)
    return (tonumber(mps) or 0) >= parseValue(Config.threshold)
end

local function getColor(mps)
    mps = tonumber(mps) or 0
    if mps >= 1e9 then return Color3.fromRGB(238, 245, 255) end
    if mps >= 1e8 then return Color3.fromRGB(255, 120, 120) end
    return Color3.fromRGB(180, 60, 60)
end

local function playSound(id, vol)
    task.spawn(function()
        pcall(function()
            local s = Instance.new("Sound")
            s.SoundId = "rbxassetid://" .. tostring(id)
            s.Volume = vol or 0.3
            s.Parent = SoundService
            s:Play()
            s.Ended:Wait()
            s:Destroy()
        end)
    end)
end

local WHITE    = Color3.fromRGB(238, 245, 255)
local GRAY     = Color3.fromRGB(145, 164, 193)
local DARK     = Color3.fromRGB(74, 110, 165)
local BG       = Color3.fromRGB(12, 17, 29)
local CARD     = Color3.fromRGB(25, 34, 52)
local CARD2    = Color3.fromRGB(20, 28, 44)
local SWITCH   = Color3.fromRGB(35, 47, 65)
local SWITCHON = Color3.fromRGB(57, 145, 235)

local FONT_BLACK = Enum.Font.GothamBlack
local FONT_BOLD  = Enum.Font.GothamBold
local FONT_MED   = Enum.Font.GothamMedium
local FONT_REG   = Enum.Font.Gotham

--------------------------------------------------------------------
-- UI HELPERS
--------------------------------------------------------------------
local gradients = {}

local function makeGradient(c1, c2)
    return ColorSequence.new({
        ColorSequenceKeypoint.new(0, c1),
        ColorSequenceKeypoint.new(0.25, c2),
        ColorSequenceKeypoint.new(0.5, c1),
        ColorSequenceKeypoint.new(0.75, c2),
        ColorSequenceKeypoint.new(1, c1),
    })
end

local function addCorner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius)
    c.Parent = parent
    return c
end

local function addStroke(parent, thickness, bright)
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = thickness or 1
    stroke.Color = WHITE
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = parent
    local grad = Instance.new("UIGradient")
    grad.Rotation = 45
    grad.Color = makeGradient(bright and WHITE or GRAY, DARK)
    grad.Parent = stroke
    table.insert(gradients, grad)
    return stroke, grad
end

local translations = {
    ["Logs"]="Nhật ký", ["History"]="Lịch sử", ["Firebase"]="Máy chủ", ["Settings"]="Cài đặt",
    ["Creator"]="Tác giả", ["Hide"]="Ẩn menu", ["SETTINGS"]="CÀI ĐẶT", ["LIVE FEED"]="DỮ LIỆU TRỰC TIẾP",
    ["HISTORY  (top eggs)"]="LỊCH SỬ (trứng tốt nhất)", ["Clear"]="Xóa", ["Refresh"]="Làm mới",
    ["JOIN"]="VÀO", ["Auto-Join"]="Tự động vào", ["Auto-Force"]="Tự động ép vào",
    ["Min Threshold"]="Giá trị tối thiểu", ["Force Time (s)"]="Thời gian ép (giây)",
    ["Log Sound"]="Âm thanh thông báo", ["Log Notifications"]="Thông báo nhật ký",
    ["Anti Guard"]="Chống bảo vệ", ["Auto Steal"]="Tự động lấy", ["Offline"]="Ngoại tuyến",
    ["Connected"]="Đã kết nối", ["Online"]="Trực tuyến", ["0 detected"]="Đã phát hiện: 0",
    ["NEW LOG"]="NHẬT KÝ MỚI", ["JOINING"]="ĐANG VÀO", ["SERVER HOP"]="CHUYỂN MÁY CHỦ",
    ["🔴 HUEVOS EN VIVO (Firebase)"]="🔴 TRỨNG TRỰC TIẾP (Firebase)",
    ["Sin huevos reportados aún"]="Chưa có trứng nào được báo cáo",
}
local language = Config.language == "en" and "en" or "vi"
local translatedObjects = {}
local function translateText(value)
    if language == "vi" then return translations[value] or value end
    return value
end
local function updateLanguage()
    for obj, original in pairs(translatedObjects) do
        if obj and obj.Parent then pcall(function() obj.Text = translateText(original) end) end
    end
end

local function create(class, props)
    local obj = Instance.new(class)
    for k, v in pairs(props or {}) do
        if k ~= "Parent" then obj[k] = v end
    end
    if (class == "TextLabel" or class == "TextButton") and props and type(props.Text) == "string" and translations[props.Text] then
        translatedObjects[obj] = props.Text
        obj.Text = translateText(props.Text)
    end
    if props and props.Parent then obj.Parent = props.Parent end
    return obj
end

local function tween(obj, props, time, style, dir)
    if not obj or not obj.Parent then return end
    pcall(function()
        TweenService:Create(obj, TweenInfo.new(
            time or 0.35,
            style or Enum.EasingStyle.Quint,
            dir or Enum.EasingDirection.Out
        ), props):Play()
    end)
end

local rot = 0
RunService.Heartbeat:Connect(function(dt)
    rot = (rot + dt * 40) % 360
    for i = #gradients, 1, -1 do
        local g = gradients[i]
        if not g or not g.Parent then
            table.remove(gradients, i)
        elseif i <= 20 then
            g.Rotation = (g.Parent:IsA("UIStroke") and (45 + rot) or rot) % 360
        end
    end
end)

--------------------------------------------------------------------
-- CLEAN OLD UI
--------------------------------------------------------------------
local GuiParent = getGuiParent()
for _, name in ipairs({"175_AutoJoiner_UI", "175_KeyPrompt", "CeboFinder_UI", "CeboFinder", "CeboEggFinder"}) do
    local old = GuiParent:FindFirstChild(name)
    if old then old:Destroy() end
end

local scaleFactor = isMobile and 0.82 or 1

--------------------------------------------------------------------
-- MAIN WINDOW
--------------------------------------------------------------------
local ScreenGui = create("ScreenGui", {
    Name = "175_AutoJoiner_UI",
    ResetOnSpawn = false,
    IgnoreGuiInset = true,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    Parent = GuiParent,
})

local Main = create("Frame", {
    Name = "Main",
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.new(0.5, 0, 0.5, 0),
    Size = isMobile and UDim2.new(0, 420, 0, 280) or UDim2.new(0, 520, 0, 340),
    BackgroundColor3 = BG,
    BackgroundTransparency = 0.02,
    BorderSizePixel = 0,
    ClipsDescendants = true,
    ZIndex = 1,
    Parent = ScreenGui,
})
addCorner(Main, 18)
local MainScale = create("UIScale", { Scale = scaleFactor, Parent = Main })
addStroke(Main, 1.5, true)

create("ImageLabel", {
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    Image = IMAGE_ID,
    ImageColor3 = Color3.fromRGB(255, 180, 180),
    ImageTransparency = 0.15,
    ScaleType = Enum.ScaleType.Crop,
    ZIndex = 0,
    Parent = Main,
})

local bg1 = create("ImageLabel", {
    Size = UDim2.new(1.5, 0, 1.5, 0),
    Position = UDim2.new(-0.25, 0, -0.25, 0),
    BackgroundTransparency = 1,
    Image = IMAGE_ID,
    ImageColor3 = Color3.fromRGB(255, 100, 100),
    ImageTransparency = 1,
    ScaleType = Enum.ScaleType.Fit,
    ZIndex = 1,
    Parent = Main,
})

local bg2 = create("ImageLabel", {
    Size = UDim2.new(1.2, 0, 1.2, 0),
    Position = UDim2.new(0.1, 0, 0.1, 0),
    BackgroundTransparency = 1,
    Image = IMAGE_ID,
    ImageColor3 = Color3.fromRGB(200, 40, 40),
    ImageTransparency = 1,
    ScaleType = Enum.ScaleType.Fit,
    ZIndex = 1,
    Parent = Main,
})

task.spawn(function()
    local a = 0
    while Main and Main.Parent do
        a = (a + 0.75) % 360
        bg1.Rotation = a
        bg2.Rotation = -a * 0.7
        task.wait(0.25)
    end
end)

--------------------------------------------------------------------
-- SIDEBAR
--------------------------------------------------------------------
local sideW = isMobile and 100 or 130

local Sidebar = create("Frame", {
    Size = UDim2.new(0, sideW, 1, 0),
    BackgroundColor3 = BG,
    BackgroundTransparency = 0.06,
    BorderSizePixel = 0,
    ZIndex = 2,
    Parent = Main,
})
addCorner(Sidebar, 18)

create("Frame", {
    Size = UDim2.new(0, 1, 0.9, 0),
    AnchorPoint = Vector2.new(0, 0.5),
    Position = UDim2.new(1, 0, 0.5, 0),
    BackgroundColor3 = WHITE,
    BackgroundTransparency = 0.7,
    BorderSizePixel = 0,
    ZIndex = 3,
    Parent = Sidebar,
})

local Content = create("Frame", {
    Size = UDim2.new(1, -(sideW + 4), 1, 0),
    Position = UDim2.new(0, sideW + 4, 0, 0),
    BackgroundTransparency = 1,
    ZIndex = 2,
    Parent = Main,
})

local SideHeader = create("Frame", {
    Size = UDim2.new(1, 0, 0, 60),
    BackgroundTransparency = 1,
    ZIndex = 3,
    Parent = Sidebar,
})

local Title = create("TextLabel", {
    Size = UDim2.new(1, -20, 0, 22),
    Position = UDim2.new(0, 14, 0, 10),
    BackgroundTransparency = 1,
    Text = "FINER EGG",
    TextColor3 = WHITE,
    TextSize = 14,
    Font = FONT_BLACK,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 4,
    Parent = SideHeader,
})
local titleGrad = Instance.new("UIGradient")
titleGrad.Color = makeGradient(WHITE, GRAY)
titleGrad.Parent = Title
table.insert(gradients, titleGrad)

local StatusDot = create("Frame", {
    Size = UDim2.new(0, 6, 0, 6),
    Position = UDim2.new(0, 16, 0, 44),
    BackgroundColor3 = DARK,
    BorderSizePixel = 0,
    ZIndex = 4,
    Parent = SideHeader,
})
addCorner(StatusDot, 1)

local StatusText = create("TextLabel", {
    Size = UDim2.new(1, -30, 0, 16),
    Position = UDim2.new(0, 28, 0, 39),
    BackgroundTransparency = 1,
    Text = "Offline",
    TextColor3 = DARK,
    TextSize = 11,
    Font = FONT_REG,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 4,
    Parent = SideHeader,
})

local lastLiveReport = 0
local SoundService = game:GetService("SoundService")
local statusSound = Instance.new("Sound")
statusSound.SoundId = "rbxassetid://12221967"
statusSound.Volume = 0.35
statusSound.Parent = SoundService
local statusOnline = nil
local function setStatus(online, text)
    local col = online and Color3.fromRGB(40, 255, 100) or Color3.fromRGB(255, 65, 65)
    if statusOnline ~= online then
        statusOnline = online
        pcall(function() statusSound:Play() end)
    end
    tween(StatusDot, { BackgroundColor3 = col })
    tween(StatusText, { TextColor3 = col })
    StatusText.Text = translateText(online and "Online" or "Offline")
end

--------------------------------------------------------------------
-- TABS
--------------------------------------------------------------------
local TabList = create("ScrollingFrame", {
    Size = UDim2.new(1, 0, 1, -132),
    Position = UDim2.new(0, 0, 0, 68),
    CanvasSize = UDim2.new(0, 0, 0, 210),
    ScrollBarThickness = 3,
    ScrollingDirection = Enum.ScrollingDirection.Y,
    BackgroundTransparency = 1,
    ZIndex = 3,
    Parent = Sidebar,
})
create("UIListLayout", {
    Padding = UDim.new(0, 4),
    HorizontalAlignment = Enum.HorizontalAlignment.Center,
    SortOrder = Enum.SortOrder.LayoutOrder,
    Parent = TabList,
})

local TabIndicator = create("Frame", {
    Size = UDim2.new(1, -16, 0, 36),
    Position = UDim2.new(0, 8, 0, 70),
    BackgroundColor3 = WHITE,
    BackgroundTransparency = 0.88,
    BorderSizePixel = 0,
    ZIndex = 2,
    Parent = Sidebar,
})
addCorner(TabIndicator, 8)
addStroke(TabIndicator, 1, true)

local Tabs, Pages = {}, {}
local currentTab = nil
local tabOrder = { "Logs", "History", "Firebase", "Settings", "Creator" }

local function switchTab(name)
    if name == currentTab then return end
    currentTab = name
    for tabName, btn in pairs(Tabs) do
        local active = (tabName == name)
        tween(btn, { TextColor3 = active and WHITE or GRAY })
        btn.Font = active and FONT_BOLD or FONT_MED
        if Pages[tabName] then
            Pages[tabName].Visible = active
            if active then
                Pages[tabName].GroupTransparency = 1
                tween(Pages[tabName], { GroupTransparency = 0 }, 0.3)
            end
        end
    end
    local idx = 0
    for i, t in ipairs(tabOrder) do
        if t == name then idx = i - 1 break end
    end
    tween(TabIndicator, {
        Position = UDim2.new(0, 8, 0, 70 + idx * 40),
        Size = UDim2.new(1, -16, 0, 36),
    }, 0.35)
end

for i, name in ipairs(tabOrder) do
    local btn = create("TextButton", {
        Size = UDim2.new(1, -20, 0, 36),
        BackgroundTransparency = 1,
        Text = translateText(name),
        TextColor3 = GRAY,
        TextSize = 12,
        Font = FONT_BOLD,
        AutoButtonColor = false,
        LayoutOrder = i,
        ZIndex = 4,
        Parent = TabList,
    })
    btn.MouseEnter:Connect(function()
        if name ~= currentTab then tween(btn, { TextColor3 = WHITE }) end
    end)
    btn.MouseLeave:Connect(function()
        if name ~= currentTab then tween(btn, { TextColor3 = GRAY }) end
    end)
    btn.MouseButton1Click:Connect(function() switchTab(name) end)
    translatedObjects[btn] = name
    Tabs[name] = btn
end

--------------------------------------------------------------------
-- HIDE / MINI
--------------------------------------------------------------------
local HideBtn = create("TextButton", {
    Size = UDim2.new(1, -24, 0, 30),
    Position = UDim2.new(0, 12, 1, -36),
    BackgroundColor3 = CARD,
    BackgroundTransparency = 0.4,
    Text = "Hide",
    TextColor3 = GRAY,
    TextSize = 12,
    Font = FONT_BOLD,
    AutoButtonColor = false,
    ZIndex = 4,
    Parent = Sidebar,
})
addCorner(HideBtn, 10)
addStroke(HideBtn, 1, false)
HideBtn.MouseEnter:Connect(function()
    tween(HideBtn, { BackgroundTransparency = 0.1, TextColor3 = WHITE })
end)
HideBtn.MouseLeave:Connect(function()
    tween(HideBtn, { BackgroundTransparency = 0.4, TextColor3 = GRAY })
end)

local Mini = create("Frame", {
    Size = UDim2.new(0, 56, 0, 56),
    AnchorPoint = Vector2.new(0, 0.5),
    Position = UDim2.new(0, 18, 0.58, 0),
    BackgroundColor3 = BG,
    BackgroundTransparency = 0.1,
    Visible = false,
    ClipsDescendants = true,
    ZIndex = 100,
    Parent = ScreenGui,
})
addCorner(Mini, 28)
addStroke(Mini, 2, true)

local MiniBtn = create("TextButton", {
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    Text = "",
    TextColor3 = WHITE,
    Font = FONT_BLACK,
    TextSize = 16,
    Parent = Mini,
})
create("ImageLabel", {
    Size = UDim2.new(0, 42, 0, 42), Position = UDim2.new(0.5, -21, 0.5, -21),
    BackgroundTransparency = 1, Image = IMAGE_ID, ScaleType = Enum.ScaleType.Fit,
    ZIndex = 102, Parent = Mini,
})
local miniGrad = Instance.new("UIGradient")
miniGrad.Color = makeGradient(WHITE, GRAY)
miniGrad.Parent = MiniBtn
table.insert(gradients, miniGrad)

HideBtn.MouseButton1Click:Connect(function()
    tween(MainScale, { Scale = 0 }, 0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In)
    task.delay(0.4, function()
        Main.Visible = false
        Mini.Visible = true
        Mini.Size = UDim2.new(0, 0, 0, 0)
        tween(Mini, { Size = UDim2.new(0, 56, 0, 56) }, 0.4, Enum.EasingStyle.Back)
    end)
end)

local dragging, dragStart, startPos, moved
MiniBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging, moved = true, false
        dragStart, startPos = input.Position, Mini.Position
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if not dragging then return end
    if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then return end
    local delta = input.Position - dragStart
    if delta.Magnitude > 10 then
        moved = true
        Mini.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
MiniBtn.MouseButton1Click:Connect(function()
    if moved then return end
    tween(Mini, { Size = UDim2.new(0, 0, 0, 0) }, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In)
    task.delay(0.3, function()
        Mini.Visible = false
        Main.Visible = true
        tween(MainScale, { Scale = scaleFactor }, 0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    end)
end)

local dragBar = create("TextButton", {
    Size = UDim2.new(1, 0, 0, 30),
    BackgroundTransparency = 1,
    Text = "",
    ZIndex = 10,
    Parent = Main,
})
local mainDragging, mainStart, mainPos
dragBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        mainDragging, mainStart, mainPos = true, input.Position, Main.Position
    end
end)
dragBar.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        mainDragging = false
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if not mainDragging then return end
    if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then return end
    local delta = (input.Position - mainStart) / MainScale.Scale
    Main.Position = UDim2.new(mainPos.X.Scale, mainPos.X.Offset + delta.X, mainPos.Y.Scale, mainPos.Y.Offset + delta.Y)
end)

--------------------------------------------------------------------
-- SWITCH
--------------------------------------------------------------------
local function createSwitch(parent, y, label, configKey)
    local frame = create("Frame", {
        Size = UDim2.new(1, 0, 0, 48),
        Position = UDim2.new(0, 0, 0, y),
        BackgroundColor3 = CARD2,
        BackgroundTransparency = 0.3,
        BorderSizePixel = 0,
        ZIndex = 3,
        Parent = parent,
    })
    addCorner(frame, 10)
    addStroke(frame, 1, true)

    create("TextLabel", {
        Size = UDim2.new(1, -70, 1, 0),
        Position = UDim2.new(0, 14, 0, 0),
        BackgroundTransparency = 1,
        Text = label,
        TextColor3 = WHITE,
        TextSize = 12,
        Font = FONT_BOLD,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 4,
        Parent = frame,
    })

    local bg = create("TextButton", {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -12, 0.5, 0),
        Size = UDim2.new(0, 46, 0, 24),
        BackgroundColor3 = SWITCH,
        BorderSizePixel = 0,
        Text = "",
        AutoButtonColor = false,
        ZIndex = 4,
        Parent = frame,
    })
    addCorner(bg, 12)
    local _, grad = addStroke(bg, 1, false)

    local knob = create("Frame", {
        Size = UDim2.new(0, 18, 0, 18),
        Position = UDim2.new(0, 3, 0.5, -9),
        BackgroundColor3 = WHITE,
        BorderSizePixel = 0,
        ZIndex = 5,
        Parent = bg,
    })
    addCorner(knob, 9)

    local function update()
        local on = Config[configKey]
        tween(bg, { BackgroundColor3 = on and SWITCHON or SWITCH }, 0.25)
        tween(knob, { Position = on and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9) }, 0.28, Enum.EasingStyle.Quint)
        if grad then grad.Color = makeGradient(on and WHITE or GRAY, DARK) end
    end
    update()

    bg.MouseButton1Click:Connect(function()
        Config[configKey] = not Config[configKey]
        update()
        saveConfig()
    end)
    return frame
end

--------------------------------------------------------------------
-- PAGE: LOGS
--------------------------------------------------------------------
local LogsPage = create("CanvasGroup", {
    Size = UDim2.new(1, -32, 1, -32),
    Position = UDim2.new(0, 16, 0, 16),
    BackgroundTransparency = 1,
    ZIndex = 2,
    Parent = Content,
})
Pages.Logs = LogsPage

local togglesRow = create("Frame", {
    Size = UDim2.new(1, 0, 0, 44),
    BackgroundTransparency = 1,
    ZIndex = 3,
    Parent = LogsPage,
})

local aj = createSwitch(togglesRow, 0, "Auto-Join", "autoJoin")
aj.Size = UDim2.new(0.48, 0, 0, 44)

local af = createSwitch(togglesRow, 0, "Auto-Force", "autoForce")
af.Size = UDim2.new(0.48, 0, 0, 44)
af.Position = UDim2.new(0.52, 0, 0, 0)

local feedHeader = create("Frame", {
    Size = UDim2.new(1, 0, 0, 20),
    Position = UDim2.new(0, 0, 0, 52),
    BackgroundTransparency = 1,
    ZIndex = 3,
    Parent = LogsPage,
})

local feedTitle = create("TextLabel", {
    Size = UDim2.new(0, 80, 1, 0),
    BackgroundTransparency = 1,
    Text = "LIVE FEED",
    TextColor3 = WHITE,
    TextSize = 11,
    Font = FONT_BOLD,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 4,
    Parent = feedHeader,
})
local ftGrad = Instance.new("UIGradient")
ftGrad.Color = makeGradient(WHITE, GRAY)
ftGrad.Parent = feedTitle
table.insert(gradients, ftGrad)

local detectedLabel = create("TextLabel", {
    AnchorPoint = Vector2.new(1, 0),
    Position = UDim2.new(1, -56, 0, 0),
    Size = UDim2.new(0, 80, 1, 0),
    BackgroundTransparency = 1,
    Text = "0 detected",
    TextColor3 = DARK,
    TextSize = 11,
    Font = FONT_REG,
    TextXAlignment = Enum.TextXAlignment.Right,
    ZIndex = 4,
    Parent = feedHeader,
})

local clearBtn = create("TextButton", {
    AnchorPoint = Vector2.new(1, 0.5),
    Position = UDim2.new(1, 0, 0.5, 0),
    Size = UDim2.new(0, 48, 0, 20),
    BackgroundColor3 = SWITCH,
    BackgroundTransparency = 0.3,
    Text = "Clear",
    TextColor3 = WHITE,
    TextSize = 10,
    Font = FONT_BOLD,
    AutoButtonColor = false,
    ZIndex = 4,
    Parent = feedHeader,
})
addCorner(clearBtn, 6)

local feedBg = create("Frame", {
    Size = UDim2.new(1, 0, 1, -76),
    Position = UDim2.new(0, 0, 0, 76),
    BackgroundColor3 = BG,
    BackgroundTransparency = 0.5,
    BorderSizePixel = 0,
    ZIndex = 2,
    Parent = LogsPage,
})
addCorner(feedBg, 12)
addStroke(feedBg, 1, false)

local feedScroll = create("ScrollingFrame", {
    Size = UDim2.new(1, -8, 1, -8),
    Position = UDim2.new(0, 4, 0, 4),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    CanvasSize = UDim2.new(0, 0, 0, 0),
    AutomaticCanvasSize = Enum.AutomaticSize.Y,
    ScrollingDirection = Enum.ScrollingDirection.Y,
    ScrollBarThickness = 4,
    ScrollBarImageColor3 = WHITE,
    ZIndex = 3,
    Parent = feedBg,
})
create("UIListLayout", {
    Padding = UDim.new(0, 8),
    SortOrder = Enum.SortOrder.LayoutOrder,
    Parent = feedScroll,
})
create("UIPadding", {
    PaddingTop = UDim.new(0, 4),
    PaddingBottom = UDim.new(0, 4),
    PaddingLeft = UDim.new(0, 4),
    PaddingRight = UDim.new(0, 4),
    Parent = feedScroll,
})

--------------------------------------------------------------------
-- PAGE: HISTORY
--------------------------------------------------------------------
local HistoryPage = create("CanvasGroup", {
    Size = UDim2.new(1, -32, 1, -32),
    Position = UDim2.new(0, 16, 0, 16),
    BackgroundTransparency = 1,
    Visible = false,
    ZIndex = 2,
    Parent = Content,
})
Pages.History = HistoryPage

create("TextLabel", {
    Size = UDim2.new(1, 0, 0, 20),
    BackgroundTransparency = 1,
    Text = "HISTORY  (top eggs)",
    TextColor3 = WHITE,
    TextSize = 11,
    Font = FONT_BOLD,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 4,
    Parent = HistoryPage,
})

local histBg = create("Frame", {
    Size = UDim2.new(1, 0, 1, -28),
    Position = UDim2.new(0, 0, 0, 28),
    BackgroundColor3 = BG,
    BackgroundTransparency = 0.5,
    BorderSizePixel = 0,
    ZIndex = 2,
    Parent = HistoryPage,
})
addCorner(histBg, 12)
addStroke(histBg, 1, false)

local histScroll = create("ScrollingFrame", {
    Size = UDim2.new(1, -8, 1, -8),
    Position = UDim2.new(0, 4, 0, 4),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    CanvasSize = UDim2.new(0, 0, 0, 0),
    AutomaticCanvasSize = Enum.AutomaticSize.Y,
    ScrollingDirection = Enum.ScrollingDirection.Y,
    ScrollBarThickness = 4,
    ScrollBarImageColor3 = WHITE,
    ZIndex = 3,
    Parent = histBg,
})
create("UIListLayout", {
    Padding = UDim.new(0, 6),
    SortOrder = Enum.SortOrder.LayoutOrder,
    Parent = histScroll,
})
create("UIPadding", {
    PaddingTop = UDim.new(0, 4),
    PaddingBottom = UDim.new(0, 4),
    PaddingLeft = UDim.new(0, 4),
    PaddingRight = UDim.new(0, 4),
    Parent = histScroll,
})

local historyData = {}

local function addHistory(data)
    table.insert(historyData, 1, data)
    if #historyData > 50 then table.remove(historyData) end

    local row = create("Frame", {
        Size = UDim2.new(1, 0, 0, 36),
        BackgroundColor3 = CARD2,
        BackgroundTransparency = 0.3,
        BorderSizePixel = 0,
        ZIndex = 4,
        Parent = histScroll,
    })
    addCorner(row, 8)

    create("TextLabel", {
        Size = UDim2.new(0.5, -10, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text = (data.name or "Unknown") .. "  [" .. formatMPS(data.mps) .. "]",
        TextColor3 = getColor(data.mps),
        TextSize = 12,
        Font = FONT_BOLD,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        ZIndex = 5,
        Parent = row,
    })
    create("TextLabel", {
        Size = UDim2.new(0.3, 0, 1, 0),
        Position = UDim2.new(0.5, 0, 0, 0),
        BackgroundTransparency = 1,
        Text = data.time or "",
        TextColor3 = GRAY,
        TextSize = 11,
        Font = FONT_REG,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 5,
        Parent = row,
    })
end

--------------------------------------------------------------------
-- PAGE: SETTINGS
--------------------------------------------------------------------
local SettingsPage = create("CanvasGroup", {
    Size = UDim2.new(1, -32, 1, -32),
    Position = UDim2.new(0, 16, 0, 16),
    BackgroundTransparency = 1,
    Visible = false,
    ZIndex = 2,
    Parent = Content,
})
Pages.Settings = SettingsPage

create("TextLabel", {
    Size = UDim2.new(1, 0, 0, 20),
    BackgroundTransparency = 1,
    Text = "SETTINGS",
    TextColor3 = WHITE,
    TextSize = 11,
    Font = FONT_BOLD,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 4,
    Parent = SettingsPage,
})

-- Scroll para que quepan todas las opciones
local SettingsScroll = create("ScrollingFrame", {
    Size = UDim2.new(1, 0, 1, -24),
    Position = UDim2.new(0, 0, 0, 24),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    CanvasSize = UDim2.new(0, 0, 0, 470),
    ScrollBarThickness = 4,
    ScrollBarImageColor3 = WHITE,
    ScrollingDirection = Enum.ScrollingDirection.Y,
    ZIndex = 3,
    Parent = SettingsPage,
})

local function makeSettingRow(y, label, defaultText, onCommit)
    local frame = create("Frame", {
        Size = UDim2.new(1, -8, 0, 44),
        Position = UDim2.new(0, 0, 0, y),
        BackgroundColor3 = CARD2,
        BackgroundTransparency = 0.3,
        BorderSizePixel = 0,
        ZIndex = 3,
        Parent = SettingsScroll,
    })
    addCorner(frame, 10)
    addStroke(frame, 1, true)
    create("TextLabel", {
        Size = UDim2.new(0.4, 0, 1, 0),
        Position = UDim2.new(0, 14, 0, 0),
        BackgroundTransparency = 1,
        Text = label,
        TextColor3 = WHITE,
        TextSize = 12,
        Font = FONT_BOLD,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 4,
        Parent = frame,
    })
    local box = create("TextBox", {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -14, 0.5, 0),
        Size = UDim2.new(0, 100, 0, 28),
        BackgroundColor3 = SWITCH,
        Text = defaultText,
        TextColor3 = WHITE,
        TextSize = 12,
        Font = FONT_BOLD,
        ClearTextOnFocus = false,
        ZIndex = 4,
        Parent = frame,
    })
    addCorner(box, 8)
    box.FocusLost:Connect(function() onCommit(box) end)
    return box
end

makeSettingRow(0, "Min Threshold", Config.threshold, function(box)
    if box.Text ~= "" then
        Config.threshold = box.Text
        saveConfig()
    else
        box.Text = Config.threshold
    end
end)

makeSettingRow(52, "Force Time (s)", tostring(Config.forceTime), function(box)
    local n = tonumber(box.Text)
    if n and n > 0 then
        Config.forceTime = math.floor(n)
        box.Text = tostring(Config.forceTime)
        saveConfig()
    else
        box.Text = tostring(Config.forceTime)
    end
end)

createSwitch(SettingsScroll, 112, "Log Sound", "logSoundEnabled")
createSwitch(SettingsScroll, 162, "Log Notifications", "logNotify")
createSwitch(SettingsScroll, 212, "Anti Guard", "antiGuard")
createSwitch(SettingsScroll, 262, "Auto Steal", "autoSteal")

-- Language selection
local languageLabel = create("TextLabel", {
    Size = UDim2.new(1, -8, 0, 24), Position = UDim2.new(0, 4, 0, 318),
    BackgroundTransparency = 1, Text = language == "vi" and "Ngôn ngữ / Language" or "Language / Ngôn ngữ",
    TextColor3 = WHITE, TextSize = 12, Font = FONT_BOLD,
    TextXAlignment = Enum.TextXAlignment.Left, Parent = SettingsScroll,
})
for i, code in ipairs({"vi", "en"}) do
    local choice = create("TextButton", {
        Size = UDim2.new(0.48, 0, 0, 36), Position = UDim2.new((i-1)*0.51, 0, 0, 350),
        BackgroundColor3 = CARD2, Text = code == "vi" and "Tiếng Việt" or "English",
        TextColor3 = WHITE, Font = FONT_BOLD, TextSize = 12, Parent = SettingsScroll,
    })
    addCorner(choice, 9)
    choice.MouseButton1Click:Connect(function()
        language = code
        Config.language = code
        saveConfig()
        updateLanguage()
        languageLabel.Text = code == "vi" and "Ngôn ngữ / Language" or "Language / Ngôn ngữ"
    end)
end

-- Creator contact page. Supply actual links above; do not use placeholder links.
local CreatorPage = create("CanvasGroup", {
    Size = UDim2.new(1, -32, 1, -32), Position = UDim2.new(0, 16, 0, 16),
    BackgroundTransparency = 1, Visible = false, ZIndex = 2, Parent = Content,
})
Pages.Creator = CreatorPage
create("TextLabel", {
    Size = UDim2.new(1, 0, 0, 30), BackgroundTransparency = 1,
    Text = "CREATOR • @kit_n67", TextColor3 = WHITE, TextSize = 15,
    Font = FONT_BOLD, TextXAlignment = Enum.TextXAlignment.Left, Parent = CreatorPage,
})
for i, platform in ipairs({"TikTok", "YouTube", "Discord"}) do
    local y = 40 + (i-1)*63
    local row = create("Frame", {
        Size = UDim2.new(1, 0, 0, 56), Position = UDim2.new(0, 0, 0, y),
        BackgroundColor3 = CARD2, Parent = CreatorPage,
    })
    addCorner(row, 10)
    create("TextLabel", {
        Size = UDim2.new(0.48, 0, 1, 0), Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1, Text = platform, TextColor3 = WHITE,
        Font = FONT_BOLD, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, Parent = row,
    })
    local copy = create("TextButton", {
        Size = UDim2.new(0.44, 0, 0, 34), Position = UDim2.new(0.54, 0, 0.5, -17),
        BackgroundColor3 = BG, Text = language == "vi" and "Sao chép link" or "Copy link",
        TextColor3 = WHITE, TextSize = 11, Font = FONT_BOLD, Parent = row,
    })
    addCorner(copy, 8)
    copy.MouseButton1Click:Connect(function()
        local url = CREATOR_LINKS[platform]
        if url and url ~= "" and type(setclipboard) == "function" then
            pcall(setclipboard, url)
            copy.Text = language == "vi" and "Đã sao chép!" or "Copied!"
        else
            copy.Text = language == "vi" and "Chưa có link" or "No link set"
        end
        task.delay(2, function()
            if copy.Parent then copy.Text = language == "vi" and "Sao chép link" or "Copy link" end
        end)
    end)
end

-- Drag the invisible bottom-right corner to resize smoothly.
-- No visible resize button; touch and mouse are both supported.
local ResizeHandle = create("Frame", {
    Size = UDim2.new(0, 34, 0, 34), AnchorPoint = Vector2.new(1, 1),
    Position = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1,
    Active = true, ZIndex = 30, Parent = Main,
})
local resizing, resizeStart, originalScale = false, nil, scaleFactor
ResizeHandle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        resizing = true
        resizeStart = input.Position
        originalScale = MainScale.Scale
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if not resizing or not resizeStart then return end
    if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then return end
    local delta = input.Position - resizeStart
    local base = Main.AbsoluteSize
    local desired = math.min((base.X + delta.X) / math.max(base.X, 1), (base.Y + delta.Y) / math.max(base.Y, 1))
    scaleFactor = math.clamp(originalScale * desired, 0.55, 1.55)
    MainScale.Scale = scaleFactor
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        resizing = false
    end
end)

--------------------------------------------------------------------
-- PAGE: FIREBASE
--------------------------------------------------------------------
local FirebasePage = create("CanvasGroup", {
    Size = UDim2.new(1, -32, 1, -32),
    Position = UDim2.new(0, 16, 0, 16),
    BackgroundTransparency = 1,
    ZIndex = 2,
    Visible = false,
    Parent = Content,
})
Pages.Firebase = FirebasePage

local fbHeader = create("TextLabel", {
    Size = UDim2.new(1, 0, 0, 20),
    BackgroundTransparency = 1,
    Text = "🔴 HUEVOS EN VIVO (Firebase)",
    TextColor3 = WHITE,
    TextSize = 11,
    Font = FONT_BOLD,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 3,
    Parent = FirebasePage,
})
local fbGrad = Instance.new("UIGradient")
fbGrad.Color = makeGradient(WHITE, GRAY)
fbGrad.Parent = fbHeader
table.insert(gradients, fbGrad)

local fbRefreshBtn = create("TextButton", {
    AnchorPoint = Vector2.new(1, 0),
    Position = UDim2.new(1, 0, 0, 0),
    Size = UDim2.new(0, 70, 0, 20),
    BackgroundColor3 = Color3.fromRGB(57, 145, 235),
    Text = "Refresh",
    TextColor3 = WHITE,
    TextSize = 11,
    Font = FONT_BOLD,
    AutoButtonColor = false,
    ZIndex = 3,
    Parent = FirebasePage,
})
addCorner(fbRefreshBtn, 6)

local ServerCard = create("Frame", {
    Size = UDim2.new(1, 0, 1, -24), Position = UDim2.new(0, 0, 0, 24),
    BackgroundColor3 = CARD2, BackgroundTransparency = 0.15,
    BorderSizePixel = 0, Parent = FirebasePage,
})
addCorner(ServerCard, 12)
local fbScroll = create("ScrollingFrame", {
    Size = UDim2.new(1, -16, 1, -16),
    Position = UDim2.new(0, 8, 0, 8),
    BackgroundTransparency = 1,
    ScrollBarThickness = 3,
    ScrollBarImageColor3 = GRAY,
    CanvasSize = UDim2.new(),
    AutomaticCanvasSize = Enum.AutomaticSize.Y,
    ZIndex = 3,
    Parent = ServerCard,
})
create("UIListLayout", {
    Padding = UDim.new(0, 5),
    SortOrder = Enum.SortOrder.LayoutOrder,
    Parent = fbScroll,
})

local function clearFbScroll()
    for _, c in ipairs(fbScroll:GetChildren()) do
        if not c:IsA("UIListLayout") then c:Destroy() end
    end
end

local function buildFbList()
    clearFbScroll()
    local eggs = fetchEggsFromFirebase()
    if #eggs == 0 then
        create("TextLabel", {
            Size = UDim2.new(1, 0, 0, 30),
            BackgroundTransparency = 1,
            Text = "Sin huevos reportados aún",
            TextColor3 = GRAY,
            TextSize = 11,
            Font = FONT_REG,
            TextXAlignment = Enum.TextXAlignment.Center,
            ZIndex = 4,
            Parent = fbScroll,
        })
        return
    end
    for idx, egg in ipairs(eggs) do
        local col = getColor(tonumber(egg.mps) or 0)
        local card = create("Frame", {
            Size = UDim2.new(1, -4, 0, 54),
            BackgroundColor3 = CARD2,
            BackgroundTransparency = 0.15,
            LayoutOrder = idx,
            ZIndex = 4,
            Parent = fbScroll,
        })
        addCorner(card, 8)
        -- Barra de color
        create("Frame", {
            Size = UDim2.new(0, 4, 1, -10),
            Position = UDim2.new(0, 4, 0, 5),
            BackgroundColor3 = col,
            BorderSizePixel = 0,
            ZIndex = 5,
            Parent = card,
        })
        -- Nombre del huevo
        create("TextLabel", {
            Size = UDim2.new(1, -130, 0, 20),
            Position = UDim2.new(0, 14, 0, 6),
            BackgroundTransparency = 1,
            Text = tostring(egg.name or "?"),
            TextColor3 = WHITE,
            TextSize = 13,
            Font = FONT_BOLD,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTruncate = Enum.TextTruncate.AtEnd,
            ZIndex = 5,
            Parent = card,
        })
        -- MPS
        local mpsLbl = create("TextLabel", {
            Size = UDim2.new(0, 90, 0, 16),
            Position = UDim2.new(0, 14, 0, 27),
            BackgroundColor3 = Color3.fromRGB(80, 15, 15),
            BackgroundTransparency = 0.3,
            Text = "  " .. formatMPS(tonumber(egg.mps) or 0),
            TextColor3 = col,
            TextSize = 11,
            Font = FONT_BOLD,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 5,
            Parent = card,
        })
        addCorner(mpsLbl, 5)
        -- Hace cuanto
        local timeAgo = math.floor(os.time() - (tonumber(egg.time) or os.time()))
        local timeStr = timeAgo < 60 and (timeAgo .. "s ago") or (math.floor(timeAgo/60) .. "m ago")
        create("TextLabel", {
            Size = UDim2.new(0, 60, 0, 14),
            Position = UDim2.new(0, 110, 0, 29),
            BackgroundTransparency = 1,
            Text = timeStr,
            TextColor3 = GRAY,
            TextSize = 10,
            Font = FONT_REG,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 5,
            Parent = card,
        })
        -- Botón JOIN
        local jBtn = create("TextButton", {
            AnchorPoint = Vector2.new(1, 0.5),
            Position = UDim2.new(1, -8, 0.5, 0),
            Size = UDim2.new(0, 62, 0, 30),
            BackgroundColor3 = Color3.fromRGB(200, 40, 40),
            Text = "JOIN",
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextSize = 12,
            Font = FONT_BLACK,
            AutoButtonColor = false,
            ZIndex = 6,
            Parent = card,
        })
        addCorner(jBtn, 7)
        addStroke(jBtn, 1.5, true)
        jBtn.MouseButton1Click:Connect(function()
            local eData = { name=egg.name, mps=egg.mps, jobId=egg.jobId, placeId=egg.placeId }
            notify("JOINING (Firebase)", tostring(egg.name), formatMPS(tonumber(egg.mps) or 0), col)
            if Config.autoForce then
                doForceJoin(egg.jobId, egg.placeId)
            else
                doJoin(egg.jobId, egg.placeId)
            end
        end)
    end
end

fbRefreshBtn.MouseButton1Click:Connect(function()
    task.spawn(buildFbList)
end)

-- Auto refresh cuando se abre la pestaña Firebase
task.spawn(function()
    while ScreenGui and ScreenGui.Parent do
        task.wait(5)
        if currentTab == "Firebase" then
            task.spawn(buildFbList)
        end
    end
end)

--------------------------------------------------------------------
-- NOTIFICATIONS
--------------------------------------------------------------------
local NotifContainer = create("Frame", {
    AnchorPoint = Vector2.new(1, 0),
    Position = UDim2.new(1, -12, 0, 18),
    Size = UDim2.new(0, 220, 1, -40),
    BackgroundTransparency = 1,
    ZIndex = 220,
    Parent = ScreenGui,
})
create("UIListLayout", {
    VerticalAlignment = Enum.VerticalAlignment.Top,
    HorizontalAlignment = Enum.HorizontalAlignment.Right,
    SortOrder = Enum.SortOrder.LayoutOrder,
    Padding = UDim.new(0, 8),
    Parent = NotifContainer,
})

local notifCount = 0

local function notify(title, body, sub, color)
    notifCount = notifCount + 1
    local order = notifCount
    color = color or WHITE
    local hasSub = sub and sub ~= ""
    local h = hasSub and 68 or 54

    local wrapper = create("Frame", {
        Size = UDim2.new(0, 220, 0, h),
        BackgroundTransparency = 1,
        ZIndex = 220,
        LayoutOrder = -order,
        Parent = NotifContainer,
    })

    local card = create("Frame", {
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, 60, 0, 0),
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = BG,
        BackgroundTransparency = 0.05,
        BorderSizePixel = 0,
        ZIndex = 220,
        Parent = wrapper,
    })
    addCorner(card, 12)
    local stroke = addStroke(card, 1.5, true)

    create("Frame", {
        Size = UDim2.new(0, 4, 1, -16),
        Position = UDim2.new(0, 10, 0, 8),
        BackgroundColor3 = color,
        BorderSizePixel = 0,
        ZIndex = 221,
        Parent = card,
    })
    create("TextLabel", {
        Size = UDim2.new(1, -32, 0, 14),
        Position = UDim2.new(0, 22, 0, 10),
        BackgroundTransparency = 1,
        Text = tostring(title or ""),
        TextColor3 = color,
        TextSize = 11,
        Font = FONT_BOLD,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 221,
        Parent = card,
    })
    create("TextLabel", {
        Size = UDim2.new(1, -32, 0, 18),
        Position = UDim2.new(0, 22, 0, 26),
        BackgroundTransparency = 1,
        Text = tostring(body or "Unknown"),
        TextColor3 = WHITE,
        TextSize = 14,
        Font = FONT_BOLD,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        ZIndex = 221,
        Parent = card,
    })
    if hasSub then
        create("TextLabel", {
            Size = UDim2.new(1, -32, 0, 14),
            Position = UDim2.new(0, 22, 0, 47),
            BackgroundTransparency = 1,
            Text = tostring(sub),
            TextColor3 = color,
            TextSize = 12,
            Font = FONT_MED,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTruncate = Enum.TextTruncate.AtEnd,
            ZIndex = 221,
            Parent = card,
        })
    end

    tween(card, { Position = UDim2.new(1, 0, 0, 0) }, 0.4, Enum.EasingStyle.Back)
    task.delay(3.5, function()
        tween(card, { Position = UDim2.new(1, 60, 0, 0), BackgroundTransparency = 1 }, 0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
        tween(stroke, { Transparency = 1 }, 0.35)
        tween(wrapper, { Size = UDim2.new(0, 280, 0, 0) }, 0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
        task.delay(0.4, function()
            if wrapper and wrapper.Parent then wrapper:Destroy() end
        end)
    end)
end

--------------------------------------------------------------------
-- JOIN
--------------------------------------------------------------------
local lastJob, lastTime = nil, 0

--------------------------------------------------------------------
--------------------------------------------------------------------
-- SERVER HOP (si el JobId es el mismo servidor actual)
--------------------------------------------------------------------
local hopVisited = {}
hopVisited[tostring(game.JobId)] = true
local hopBusy = false
local hopLastAt = 0

local function httpGetBody(url)
    -- Prefer executor request (más fiable que HttpGet en algunos)
    if requestFn then
        local ok, res = pcall(function()
            return requestFn({
                Url = url,
                Method = "GET",
                Headers = { ["User-Agent"] = "Mozilla/5.0", ["Accept"] = "application/json" },
            })
        end)
        if ok and res then
            local body = res.Body or res.body
            if type(body) == "string" and #body > 2 then
                return body
            end
        end
    end
    local ok2, body2 = pcall(function() return game:HttpGet(url) end)
    if ok2 and type(body2) == "string" then return body2 end
    return nil
end

local function getHopServers(placeId)
    placeId = tonumber(placeId) or game.PlaceId
    local results = {}
    local cursor = ""
    local pages = 0
    local current = tostring(game.JobId)
    repeat
        local url = "https://games.roblox.com/v1/games/"
            .. tostring(placeId)
            .. "/servers/Public?sortOrder=Asc&limit=100"
            .. (cursor ~= "" and ("&cursor=" .. cursor) or "")
        local response = httpGetBody(url)
        if not response then break end
        local ok2, data = pcall(function()
            return HttpService:JSONDecode(response)
        end)
        if not ok2 or type(data) ~= "table" or type(data.data) ~= "table" then break end
        for _, server in ipairs(data.data) do
            local sid = tostring(server.id or "")
            local playing = tonumber(server.playing) or 99
            local maxP = tonumber(server.maxPlayers) or 0
            if sid ~= "" and sid ~= current and not hopVisited[sid] then
                if maxP <= 0 or playing < maxP then
                    results[#results + 1] = server
                end
            end
        end
        cursor = data.nextPageCursor or ""
        pages = pages + 1
        if #results >= 40 then break end
    until cursor == "" or pages >= 6
    table.sort(results, function(a, b)
        return (tonumber(a.playing) or 99) < (tonumber(b.playing) or 99)
    end)
    return results
end

local function serverHopAway(placeId, reason)
    if hopBusy and (os.clock() - hopLastAt) < 3 then return false end
    hopBusy = true
    hopLastAt = os.clock()
    placeId = tonumber(placeId) or game.PlaceId
    local current = tostring(game.JobId)
    hopVisited[current] = true

    task.spawn(function()
        pcall(function()
            if type(notify) == "function" then
                notify("SERVER HOP", reason or "Mismo servidor", "Buscando otro...", Color3.fromRGB(255, 180, 80))
            end
        end)

        local servers = getHopServers(placeId)
        if #servers == 0 then
            hopVisited = {}
            hopVisited[current] = true
            servers = getHopServers(placeId)
        end

        if #servers == 0 then
            -- Último recurso: teleport random al place (Roblox elige server)
            pcall(function()
                if type(notify) == "function" then
                    notify("SERVER HOP", "Lista vacía", "Teleport random...", Color3.fromRGB(255, 150, 50))
                end
            end)
            pcall(function()
                TeleportService:Teleport(placeId, LocalPlayer)
            end)
            task.wait(2)
            hopBusy = false
            return
        end

        -- Probar varios servers si falla
        for i = 1, math.min(5, #servers) do
            local best = servers[i]
            local sid = tostring(best.id)
            if sid == tostring(game.JobId) then
                -- sigue en el mismo, siguiente
            else
                hopVisited[sid] = true
                pcall(function()
                    if type(notify) == "function" then
                        notify("SERVER HOP", "→ otro server",
                            tostring(best.playing or "?") .. " players",
                            Color3.fromRGB(80, 255, 120))
                    end
                end)
                local ok = pcall(function()
                    TeleportService:TeleportToPlaceInstance(placeId, sid, LocalPlayer)
                end)
                task.wait(1.8)
                -- si aún estamos en el mismo JobId, probar el siguiente
                if tostring(game.JobId) ~= current then
                    hopBusy = false
                    return
                end
            end
        end

        -- Fallback random
        pcall(function()
            TeleportService:Teleport(placeId, LocalPlayer)
        end)
        task.wait(1.5)
        hopBusy = false
    end)
    return true
end

local function isSameServer(jobId)
    if not jobId then return false end
    local a = tostring(jobId):gsub("%s+", "")
    local b = tostring(game.JobId):gsub("%s+", "")
    if a == "" or a == "0" then return false end
    return a == b
end

local function doJoin(jobId, placeId)
    if not jobId or jobId == "" or jobId == "0" then return end
    placeId = tonumber(placeId) or game.PlaceId

    -- MISMO servidor → hop obligatorio
    if isSameServer(jobId) then
        serverHopAway(placeId, "Mismo JobId · hop automático")
        return
    end

    if jobId == lastJob and os.clock() - lastTime < 8 then return end
    lastJob, lastTime = jobId, os.clock()

    pcall(function()
        TeleportService:TeleportToPlaceInstance(placeId, tostring(jobId), LocalPlayer)
    end)

    -- Si tras un momento seguimos en el mismo server (join falló / ya estábamos), hop
    task.delay(2.5, function()
        if isSameServer(jobId) or tostring(game.JobId) == tostring(lastJob) then
            -- solo hop si el target era este o no cambió de server
        end
        -- Si intentamos ir a jobId y seguimos en current y current==jobId
        if isSameServer(jobId) then
            serverHopAway(placeId, "Join falló · mismo server")
        end
    end)
end

local function doForceJoin(jobId, placeId)
    if not jobId or jobId == "" or jobId == "0" then return end
    placeId = tonumber(placeId) or game.PlaceId

    if isSameServer(jobId) then
        serverHopAway(placeId, "Force · mismo JobId")
        return
    end

    local endAt = os.clock() + (Config.forceTime or 10)
    task.spawn(function()
        while os.clock() < endAt do
            if isSameServer(jobId) then
                serverHopAway(placeId, "Force · ya estás en ese server")
                return
            end
            pcall(function()
                TeleportService:TeleportToPlaceInstance(placeId, tostring(jobId), LocalPlayer)
            end)
            task.wait(2.2)
            -- si después del teleport seguimos igual y el jobId era otro, Roblox nos dejó aquí
            if isSameServer(jobId) then
                serverHopAway(placeId, "Force · sigue el mismo JobId")
                return
            end
        end
    end)
end

-- EGG ENTRIES
--------------------------------------------------------------------
local entries, entryData, seenKeys = {}, {}, {}
local needsSort = false

local function updateDetected()
    local count = 0
    for _, e in pairs(entries) do
        if e.wrapper and e.wrapper.Parent and e.wrapper.Visible then
            count = count + 1
        end
    end
    detectedLabel.Text = count .. " detected"
end

local function sortEntries()
    local list = {}
    for _, child in ipairs(feedScroll:GetChildren()) do
        if child.Name == "EntryWrapper" and entryData[child] then
            table.insert(list, child)
        end
    end
    table.sort(list, function(a, b)
        local da = entryData[a] or {}
        local db = entryData[b] or {}
        local ma = tonumber(da.mps) or 0
        local mb = tonumber(db.mps) or 0
        -- mayor precio primero
        if ma ~= mb then return ma > mb end
        local na = tostring(da.name or "")
        local nb = tostring(db.name or "")
        return na < nb
    end)
    for i, w in ipairs(list) do w.LayoutOrder = i end
end

local function removeEntry(wrapper)
    if not wrapper then return end
    tween(wrapper, { Size = UDim2.new(1, 0, 0, 0) }, 0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
    task.delay(0.26, function()
        if wrapper.Parent then wrapper:Destroy() end
    end)
end

clearBtn.MouseButton1Click:Connect(function()
    for _, child in ipairs(feedScroll:GetChildren()) do
        if child:IsA("Frame") and child.Name == "EntryWrapper" then
            removeEntry(child)
        end
    end
    table.clear(entries)
    table.clear(entryData)
    detectedLabel.Text = "0 detected"
end)

local function makeEntry(data)
    local uid = data.eggUid and tostring(data.eggUid)
    if uid and entries[uid] and entries[uid].wrapper and entries[uid].wrapper.Parent then return end
    if not meetsThreshold(data.mps) then return end

    local col = getColor(data.mps)
    local mps = tonumber(data.mps) or 0

    if mps >= 1e7 then
        addHistory({ name = data.name, mps = data.mps, time = os.date("%H:%M:%S") })
    end
    if not data.silent and Config.logSoundEnabled then
        playSound(Config.logSoundId, 0.3)
    end
    if Config.logNotify and not data.silent then
        notify("NEW LOG", (data.name or "Unknown") .. "  [" .. formatMPS(data.mps) .. "]",
            (data.players or "?") .. "/" .. (data.maxPlayers or "?"), col)
    end

    local wrapper = create("Frame", {
        Name = "EntryWrapper",
        Size = UDim2.new(1, 0, 0, 0),
        BackgroundTransparency = 1,
        ClipsDescendants = true,
        Parent = feedScroll,
    })
    entryData[wrapper] = data

    local card = create("Frame", {
        Size = UDim2.new(1, -2, 1, 0),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = CARD2,
        BackgroundTransparency = 0.15,
        ZIndex = 4,
        Parent = wrapper,
    })
    addCorner(card, 8)

    -- Barra de color
    create("Frame", {
        Size = UDim2.new(0, 4, 1, -10),
        Position = UDim2.new(0, 4, 0, 5),
        BackgroundColor3 = col,
        BorderSizePixel = 0,
        ZIndex = 5,
        Parent = card,
    })

    -- Icono
    local photo = create("Frame", {
        Size = UDim2.new(0, 40, 0, 40),
        Position = UDim2.new(0, 14, 0.5, -20),
        BackgroundTransparency = 1,
        ZIndex = 5,
        Parent = card,
    })
    addCorner(photo, 8)
    local iconId = tostring(data.icon or "")
    -- Si es solo número, convertir a rbxassetid
    if tonumber(iconId) then
        iconId = "rbxassetid://" .. iconId
    end
    create("ImageLabel", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Image = iconId,
        ScaleType = Enum.ScaleType.Fit,
        ZIndex = 6,
        Parent = photo,
    })

    -- Nombre del huevo
    local nameLabel = create("TextLabel", {
        Size = UDim2.new(1, -175, 0, 20),
        Position = UDim2.new(0, 60, 0, 6),
        BackgroundTransparency = 1,
        Text = tostring(data.name or "Unknown"),
        TextColor3 = WHITE,
        TextSize = 13,
        Font = FONT_BOLD,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        ZIndex = 5,
        Parent = card,
    })

    -- Cuánto genera (MPS) al lado del nombre
    local genLabel = create("TextLabel", {
        Size = UDim2.new(0, 90, 0, 18),
        Position = UDim2.new(0, 60, 0, 26),
        BackgroundColor3 = Color3.fromRGB(80, 15, 15),
        BackgroundTransparency = 0.3,
        Text = "  " .. formatMPS(data.mps),
        TextColor3 = col,
        TextSize = 12,
        Font = FONT_BOLD,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 5,
        Parent = card,
    })
    addCorner(genLabel, 6)

    local subParts = { (data.players or "?") .. "/" .. (data.maxPlayers or "?") }
    if data.mutation and data.mutation ~= "" and data.mutation ~= "—" then
        table.insert(subParts, tostring(data.mutation))
    end
    if data.spawnedAt then table.insert(subParts, age(data.spawnedAt)) end

    local subLabel = create("TextLabel", {
        Size = UDim2.new(1, -175, 0, 14),
        Position = UDim2.new(0, 155, 0, 28),
        BackgroundTransparency = 1,
        Text = table.concat(subParts, " • "),
        TextColor3 = GRAY,
        TextSize = 10,
        Font = FONT_REG,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        ZIndex = 5,
        Parent = card,
    })

    -- Botón Join más grande y visible
    local joinBtn = create("TextButton", {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -8, 0.5, 0),
        Size = UDim2.new(0, 72, 0, 34),
        BackgroundColor3 = Color3.fromRGB(200, 40, 40),
        Text = "JOIN",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 13,
        Font = FONT_BLACK,
        AutoButtonColor = false,
        ZIndex = 6,
        Parent = card,
    })
    addCorner(joinBtn, 8)
    addStroke(joinBtn, 1.5, true)
    joinBtn.MouseEnter:Connect(function()
        tween(joinBtn, { BackgroundColor3 = Color3.fromRGB(255, 70, 70), Size = UDim2.new(0, 76, 0, 36) })
    end)
    joinBtn.MouseLeave:Connect(function()
        tween(joinBtn, { BackgroundColor3 = Color3.fromRGB(200, 40, 40), Size = UDim2.new(0, 72, 0, 34) })
    end)
    joinBtn.MouseButton1Click:Connect(function()
        notify("JOINING", data.name or "Unknown", formatMPS(data.mps), col)
        if Config.autoForce then doForceJoin(data.jobId, data.placeId) else doJoin(data.jobId, data.placeId) end
    end)

    tween(wrapper, { Size = UDim2.new(1, 0, 0, 56) }, 0.3, Enum.EasingStyle.Quint)

    if uid then
        entries[uid] = { wrapper = wrapper, data = data, name = nameLabel, sub = subLabel, gen = genLabel }
    end
    needsSort = true

    -- Reportar al Firebase para que otros lo vean
    reportEggToFirebase(data)

    if Config.autoSteal then
        doAutoSteal(data)
    elseif Config.autoJoin then
        notify("JOINING", data.name or "Unknown", formatMPS(data.mps), col)
        if Config.autoForce then doForceJoin(data.jobId, data.placeId) else doJoin(data.jobId, data.placeId) end
    end
end

--------------------------------------------------------------------
-- EGG POLLING
--------------------------------------------------------------------
local lastSignature, useOrdered = "", true
local queue, queueRunning = {}, false

local function parseEgg(raw)
    return {
        -- compatibilidad con yslemEgg (name/icon/mps) y formato viejo (eggName/eggIcon/value)
        name       = tostring(raw.name or raw.eggName or "Unknown"),
        icon       = tostring(raw.icon or raw.eggIcon or ""),
        mps        = tonumber(raw.mps or raw.value) or 0,
        jobId      = tostring(raw.jobId or ""),
        placeId    = tonumber(raw.placeId) or game.PlaceId,
        players    = tonumber(raw.players),
        maxPlayers = tonumber(raw.maxPlayers),
        spawnedAt  = tonumber(raw.spawnedAt),
        mutation   = tostring(raw.mutation or raw.rarityName or ""),
        eggUid     = tostring(raw.eggUid or ""),
        silent     = false,
    }
end

local function signature(egg)
    return table.concat({
        tostring(egg.eggUid or ""),
        tostring(math.floor(tonumber(egg.mps) or 0)),
        tostring(egg.mutation or ""),
        tostring(egg.name or ""),
    }, "|")
end

local function cleanRemoved(active)
    local changed = false
    for uid, e in pairs(entries) do
        if not active[uid] then
            entries[uid], seenKeys[uid] = nil, nil
            removeEntry(e.wrapper)
            changed = true
        end
    end
    return changed
end

local function fetchEggs()
    if useOrdered then
        local body = httpGet("/eggs.json?orderBy=%22lastSeen%22&startAt=" .. tostring(os.time() - 55))
        if body == nil then return nil end
        if body:find('"error"', 1, true) then useOrdered = false else return body end
    end
    return httpGet("/eggs.json")
end

local function processQueue()
    if queueRunning then return end
    queueRunning = true
    task.spawn(function()
        while #queue > 0 and ScreenGui and ScreenGui.Parent do
            local egg = table.remove(queue, 1)
            if egg then pcall(makeEntry, egg) end
        end
        queueRunning = false
    end)
end

local function pollEggs()
    local body = fetchEggs()
    if body == nil then setStatus(os.time() - lastLiveReport < 120) return end

    if body == "null" or body == "" then
        setStatus(os.time() - lastLiveReport < 120)
        if lastSignature ~= "empty" then
            lastSignature = "empty"
            if cleanRemoved({}) then needsSort = true end
        end
        return
    end

    local ok, data = pcall(function() return HttpService:JSONDecode(body) end)
    if not ok or type(data) ~= "table" then setStatus(false, "Error") return end

    local now = os.time()
    local active, parsed, sigParts = {}, {}, {}

    for _, raw in pairs(data) do
        if type(raw) == "table" and raw.eggUid then
            local uid = tostring(raw.eggUid)
            if now - (tonumber(raw.lastSeen) or 0) <= 45 then
                active[uid] = true
                local egg = parseEgg(raw)
                parsed[uid] = egg
                table.insert(sigParts, signature(egg))
            end
        end
    end

    if next(active) ~= nil then lastLiveReport = now end
    setStatus(now - lastLiveReport < 120)
    table.sort(sigParts)
    local sig = table.concat(sigParts, ";")

    if sig == lastSignature then
        for uid, egg in pairs(parsed) do
            local e = entries[uid]
            if e and e.data then
                e.data.players, e.data.maxPlayers = egg.players, egg.maxPlayers
            end
        end
        return
    end

    lastSignature = sig
    local changed, newOnes = false, {}

    for uid, egg in pairs(parsed) do
        local e = entries[uid]
        if e and e.wrapper and e.wrapper.Parent then
            local same = e.data and signature(e.data) == signature(egg)
            e.data, entryData[e.wrapper] = egg, egg
            if not same then
                e.name.Text = egg.name
                e.name.TextColor3 = WHITE
                if e.gen then
                    e.gen.Text = "  " .. formatMPS(egg.mps)
                    e.gen.TextColor3 = getColor(egg.mps)
                end
                local parts = { (egg.players or "?") .. "/" .. (egg.maxPlayers or "?") }
                if egg.mutation ~= "" and egg.mutation ~= "—" then table.insert(parts, egg.mutation) end
                if egg.spawnedAt then table.insert(parts, age(egg.spawnedAt)) end
                e.sub.Text = table.concat(parts, " • ")
                changed = true
            end
        elseif not seenKeys[uid] then
            seenKeys[uid] = now
            local secKey = table.concat({
                tostring(egg.jobId or ""),
                tostring(egg.name or ""),
                tostring(math.floor((egg.mps or 0) / 1e5)),
            }, "|")
            if not seenKeys["sec:" .. secKey] then
                seenKeys["sec:" .. secKey] = now
                table.insert(newOnes, egg)
                changed = true
            end
        end
    end

    if #newOnes > 0 then
        table.sort(newOnes, function(a, b) return (tonumber(a.mps) or 0) > (tonumber(b.mps) or 0) end)
        for _, egg in ipairs(newOnes) do table.insert(queue, egg) end
        processQueue()
    end

    if cleanRemoved(active) or changed then needsSort = true end
    if needsSort then
        needsSort = false
        sortEntries()
        updateDetected()
    pcall(sortEntries)
    needsSort = false
    end
end

task.spawn(function()
    while ScreenGui and ScreenGui.Parent do
        pcall(pollEggs)
        task.wait(0.5)
    end
end)

--------------------------------------------------------------------
-- SCAN LOCAL - Lógica exacta del yslemEgg para sacar icono, nombre y valor
--------------------------------------------------------------------
local scanNet = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Networking")
local scanAssets   = nil
local scanMuts     = nil
local scanLastPublish = 0

pcall(function() scanAssets = require(ReplicatedStorage.Client.EggState) end)
pcall(function() scanAssets = require(ReplicatedStorage.Data.Assets) end)
pcall(function() scanMuts   = require(ReplicatedStorage.Shared.Modules.Mutations) end)

-- Igual que describe() del yslemEgg
local function ysDescribe(record)
    local directory = type(scanAssets) == "table" and scanAssets.Directory or nil
    local entry = type(directory) == "table" and directory[tostring(record.AssetCategory)] or nil
    local info = {
        Uid    = record.Uid,
        Name   = tostring(record.AssetCategory),
        Icon   = "",
        Rarity = 0,
        Value  = 0,
    }
    if type(entry) == "table" then
        info.Name = tostring(entry.DisplayName or record.AssetCategory)
        local icon = entry.Icon
        if icon ~= nil and tostring(icon) ~= "" then
            icon = tostring(icon)
            info.Icon = tonumber(icon) and ("rbxassetid://" .. icon) or icon
        end
        if type(entry.Rarity) == "table" then
            info.Rarity = tonumber(entry.Rarity.RarityNumber or entry.Rarity.Rank) or 0
        end
        -- Precio real: EarningRate base (sin inflar x19). Scale suave solo si > 1.
        local base = tonumber(entry.EarningRate) or 0
        local scale = tonumber(record.AssetScale) or 1
        if scale < 0.1 then scale = 1 end
        local factor = 1
        if scale > 1.01 then
            -- escala moderada (NO el factor loco de ~19x)
            factor = scale ^ 1.15
        end
        local mutation = 1
        if type(scanMuts) == "table" and type(scanMuts.EarningsFor) == "function" then
            local okM, resM = pcall(scanMuts.EarningsFor, type(record.Mutations) == "table" and record.Mutations or {})
            if okM and type(resM) == "number" and resM > 0 then mutation = resM end
        end
        info.Value = base * factor * mutation
    end
    return info
end

-- Igual que snapshot() del yslemEgg
local function ysSnapshot()
    local list = {}
    local ok, result = pcall(function()
        return scanNet:FindFirstChild("RF/EggWorld/AskFieldEggSnapshot"):InvokeServer()
    end)
    local records = ok and type(result) == "table" and result.Records or nil
    if type(records) ~= "table" then return list end
    for _, record in pairs(records) do
        if type(record) == "table" and type(record.Uid) == "string"
            and (record.State == "Slot" or record.State == "Dropped")
            and typeof(record.BottomCFrame) == "CFrame" then
            list[#list + 1] = record
        end
    end
    return list
end

-- Publica los huevos al Firebase y los muestra en el feed
local function ysPublishEggs()
    if os.clock() - scanLastPublish < 5 then return end
    scanLastPublish = os.clock()

    local records = ysSnapshot()
    for _, record in ipairs(records) do
        local info = ysDescribe(record)
        -- Clave segura para Firebase (igual que yslemEgg)
        local rawKey = tostring(game.JobId) .. "_" .. tostring(info.Uid)
        local key = string.gsub(rawKey, "[^%w_%-]", "_")

        local payload = {
            eggUid     = tostring(info.Uid),
            name       = tostring(info.Name),
            icon       = tostring(info.Icon),
            mps        = tonumber(info.Value) or 0,
            jobId      = tostring(game.JobId),
            placeId    = tostring(game.PlaceId),
            players    = #Players:GetPlayers(),
            maxPlayers = Players.MaxPlayers,
            lastSeen   = os.time(),
            spawnedAt  = os.time(),
            mutation   = "",
            rarityName = tostring(info.Rarity),
        }

        -- Mandar al Firebase
        task.spawn(function()
            httpPut("/eggs/" .. key .. ".json", payload)
        end)

        -- Mostrar en el feed local del AJ (precio real, sin forzar threshold)
        local displayMps = tonumber(info.Value) or 0
        local eggData = {
            name       = info.Name,
            icon       = info.Icon,
            mps        = displayMps,
            jobId      = tostring(game.JobId),
            placeId    = tostring(game.PlaceId),
            players    = tostring(#Players:GetPlayers()),
            maxPlayers = tostring(Players.MaxPlayers),
            eggUid     = info.Uid,
            spawnedAt  = os.time(),
            mutation   = "",
            silent     = false,
        }
        pcall(makeEntry, eggData)
    end
end

task.spawn(function()
    while ScreenGui and ScreenGui.Parent do
        task.wait(5)
        pcall(ysPublishEggs)
    end
end)

task.spawn(function()
    local idx = 1
    while ScreenGui and ScreenGui.Parent do
        task.wait(1)
        local list = {}
        for _, e in pairs(entries) do
            if e.sub and e.data and e.wrapper and e.wrapper.Parent and e.wrapper.Visible then
                table.insert(list, e)
            end
        end
        if #list == 0 then
            idx = 1
        else
            for _ = 1, math.min(3, #list) do
                if idx > #list then idx = 1 end
                local e = list[idx]
                if e.data.spawnedAt then
                    local parts = { (e.data.players or "?") .. "/" .. (e.data.maxPlayers or "?") }
                    if e.data.mutation and e.data.mutation ~= "" and e.data.mutation ~= "—" then
                        table.insert(parts, e.data.mutation)
                    end
                    table.insert(parts, age(e.data.spawnedAt))
                    e.sub.Text = table.concat(parts, " • ")
                end
                idx = idx + 1
            end
        end
    end
end)


--------------------------------------------------------------------
-- AUTO STEAL
--------------------------------------------------------------------
local autoStealBusy = false

-- Busca la zona segura (doña segura) en el workspace
local function findSafeZone()
    local names = {"SafeZone", "Safezone", "safe_zone", "DonaSegura", "SafeArea", "Home", "Base"}
    -- Buscar por nombre exacto primero
    for _, name in ipairs(names) do
        local found = Workspace:FindFirstChild(name, true)
        if found and found:IsA("BasePart") then return found end
        if found and found:IsA("Model") then
            local part = found.PrimaryPart or found:FindFirstChildWhichIsA("BasePart")
            if part then return part end
        end
    end
    -- Buscar por atributo SafeZone
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            local ok, val = pcall(function() return obj:GetAttribute("SafeZone") end)
            if ok and val then return obj end
        end
    end
    return nil
end

-- Busca el huevo en el workspace (el objeto a robar)
local function findEggInWorkspace(eggName)
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj.Name == eggName or (obj:IsA("Model") and obj.Name:lower():find(eggName:lower())) then
            local part = obj:IsA("BasePart") and obj or (obj:IsA("Model") and (obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")))
            if part then return part end
        end
    end
    -- Buscar por atributo EggName
    for _, obj in ipairs(Workspace:GetDescendants()) do
        local ok, val = pcall(function() return obj:GetAttribute("EggName") end)
        if ok and val and tostring(val):lower():find(eggName:lower()) then
            local part = obj:IsA("BasePart") and obj or (obj:IsA("Model") and (obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")))
            if part then return part end
        end
    end
    return nil
end

-- Teleporta al jugador a una posición de forma rápida
local function fastTP(targetPart, offsetY)
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hrp or not targetPart then return false end
    pcall(function()
        if hum then hum.PlatformStand = false end
        hrp.CFrame = CFrame.new(targetPart.Position + Vector3.new(0, offsetY or 3, 0))
        hrp.AssemblyLinearVelocity = Vector3.zero
        hrp.AssemblyAngularVelocity = Vector3.zero
    end)
    return true
end

-- Activa el ProximityPrompt del huevo si existe
local function activateEggPrompt(eggPart)
    if not eggPart then return false end
    local model = eggPart:IsAncestorOf(eggPart) and eggPart or eggPart.Parent
    -- Buscar ProximityPrompt en el modelo del huevo
    for _, obj in ipairs(model:GetDescendants()) do
        if obj:IsA("ProximityPrompt") then
            pcall(function()
                local event = ReplicatedStorage:FindFirstChild("Packages")
                if event then
                    event = event:FindFirstChild("Net")
                end
                -- Disparar el prompt directamente
                fireproximityprompt(obj)
            end)
            return true
        end
    end
    -- Buscar en el padre
    if eggPart.Parent then
        for _, obj in ipairs(eggPart.Parent:GetDescendants()) do
            if obj:IsA("ProximityPrompt") then
                pcall(function() fireproximityprompt(obj) end)
                return true
            end
        end
    end
    return false
end

-- Lógica principal del Auto Steal
local function doAutoSteal(eggData)
    if autoStealBusy then return end
    if not Config.autoSteal then return end
    autoStealBusy = true

    task.spawn(function()
        local success = pcall(function()
            local char = LocalPlayer.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end

            notify("AUTO STEAL", "Buscando: " .. (eggData.name or "?"), formatMPS(eggData.mps), Color3.fromRGB(255, 200, 50))

            -- Paso 1: Buscar el huevo en el workspace
            local eggPart = findEggInWorkspace(eggData.name or "")

            if eggPart then
                -- Paso 2: TP al huevo
                fastTP(eggPart, 3)
                task.wait(0.2)

                -- Paso 3: Intentar activar el prompt del huevo (robarlo)
                activateEggPrompt(eggPart)
                task.wait(0.5)

                -- Paso 4: Buscar zona segura y TP rápido
                local safeZone = findSafeZone()
                if safeZone then
                    -- TP rápido a la zona segura
                    fastTP(safeZone, 5)
                    task.wait(0.15)
                    -- Segunda TP para asegurar llegada
                    fastTP(safeZone, 5)
                    notify("AUTO STEAL", "¡Entregado en zona segura!", eggData.name or "?", Color3.fromRGB(80, 255, 120))
                else
                    -- Si no encuentra zona segura, buscar spawn del jugador
                    local spawnLoc = Workspace:FindFirstChild("SpawnLocation") or Workspace:FindFirstChildWhichIsA("SpawnLocation")
                    if spawnLoc then
                        fastTP(spawnLoc, 5)
                    end
                    notify("AUTO STEAL", "Zona segura no encontrada", "Revisa manualmente", Color3.fromRGB(255, 150, 50))
                end
            else
                -- El huevo no está en este servidor, intentar join al servidor del huevo
                notify("AUTO STEAL", "Huevo no local, uniendo servidor...", eggData.name or "?", Color3.fromRGB(255, 200, 50))
                if Config.autoForce then
                    doForceJoin(eggData.jobId, eggData.placeId)
                else
                    doJoin(eggData.jobId, eggData.placeId)
                end
            end
        end)

        task.wait(2)
        autoStealBusy = false
    end)
end

--------------------------------------------------------------------
-- ANTI GUARD (simplificado, basado en Chilli Hub)
--------------------------------------------------------------------
local guardHighlights = {}
local antiGuardBusy = false
local lastGuardNotify = 0

local function clearGuardHighlights()
    for _, h in pairs(guardHighlights) do
        pcall(function() if h then h:Destroy() end end)
    end
    table.clear(guardHighlights)
end

local function findGuardAreas()
    local world = Workspace:FindFirstChild("World") or Workspace:FindFirstChild("__OBJECTS")
    if not world then return nil end
    local areas = world:FindFirstChild("Areas")
    if not areas then return nil end
    return areas:FindFirstChild("GuardAreas")
end

local function isGuardSleeping(guard)
    if not guard then return false end
    local ok, state = pcall(function()
        return guard:GetAttribute("GuardState")
    end)
    return ok and state == "Sleeping"
end

local function getGuardRoot(guard)
    if not guard then return nil end
    if guard:IsA("BasePart") then return guard end
    local hrp = guard:FindFirstChild("HumanoidRootPart")
        or guard:FindFirstChild("RootPart")
        or guard:FindFirstChildWhichIsA("BasePart")
    return hrp
end

local function highlightGuard(guard)
    if not guard or guardHighlights[guard] then return end
    local h = Instance.new("Highlight")
    h.Name = "175_GuardHL"
    h.Adornee = guard
    h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    h.FillTransparency = 0.55
    h.OutlineTransparency = 0
    local sleeping = isGuardSleeping(guard)
    if sleeping then
        h.FillColor = Color3.fromRGB(80, 220, 120)
        h.OutlineColor = Color3.fromRGB(80, 220, 120)
    else
        h.FillColor = Color3.fromRGB(255, 60, 60)
        h.OutlineColor = Color3.fromRGB(255, 100, 80)
    end
    h.Parent = guard
    guardHighlights[guard] = h
end

local function tryForestStrike(guard)
    local char = LocalPlayer.Character
    if not char then return end
    -- Buscar remote típico del juego
    local paths = {
        {"RE", "GuardPatrol", "ForestStrike"},
        {"Remotes", "GuardPatrol", "ForestStrike"},
    }
    local remote = nil
    for _, path in ipairs(paths) do
        local node = ReplicatedStorage
        local ok = true
        for _, name in ipairs(path) do
            if not node then ok = false break end
            node = node:FindFirstChild(name)
        end
        if ok and node and (node:IsA("RemoteEvent") or node:IsA("RemoteFunction")) then
            remote = node
            break
        end
    end
    -- Búsqueda profunda por nombre
    if not remote then
        for _, d in ipairs(ReplicatedStorage:GetDescendants()) do
            if d.Name == "ForestStrike" and (d:IsA("RemoteEvent") or d:IsA("RemoteFunction")) then
                remote = d
                break
            end
        end
    end
    if not remote then return end
    local root = getGuardRoot(guard)
    if not root then return end
    pcall(function()
        remote:FireServer({
            GuardCFrame = root.CFrame,
        })
    end)
end

local function pushAwayFromGuard(guard)
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local groot = getGuardRoot(guard)
    if not hrp or not groot then return end

    local dir = hrp.Position - groot.Position
    dir = Vector3.new(dir.X, 0, dir.Z)
    if dir.Magnitude < 0.1 then
        dir = Vector3.new(1, 0, 0)
    end
    dir = dir.Unit

    local dest = hrp.Position + dir * 18 + Vector3.new(0, 4, 0)
    pcall(function()
        if hum then hum.PlatformStand = false end
        hrp.CFrame = CFrame.new(dest)
        hrp.AssemblyLinearVelocity = Vector3.zero
        hrp.AssemblyAngularVelocity = Vector3.zero
    end)
end

local function antiGuardTick()
    if not Config.antiGuard then
        clearGuardHighlights()
        return
    end

    local areas = findGuardAreas()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local nearAwake = nil
    local nearDist = 45

    if areas then
        for _, area in ipairs(areas:GetChildren()) do
            local guard = area:FindFirstChild("Guard") or area:FindFirstChildWhichIsA("Model")
            if guard then
                highlightGuard(guard)
                local hl = guardHighlights[guard]
                if hl then
                    local sleeping = isGuardSleeping(guard)
                    if sleeping then
                        hl.FillColor = Color3.fromRGB(80, 220, 120)
                        hl.OutlineColor = Color3.fromRGB(80, 220, 120)
                    else
                        hl.FillColor = Color3.fromRGB(255, 60, 60)
                        hl.OutlineColor = Color3.fromRGB(255, 100, 80)
                    end
                end
                if not isGuardSleeping(guard) then
                    local groot = getGuardRoot(guard)
                    if groot then
                        local dist = (groot.Position - hrp.Position).Magnitude
                        if dist < nearDist then
                            nearDist = dist
                            nearAwake = guard
                        end
                    end
                end
            end
        end
    else
        -- Fallback: buscar cualquier modelo llamado Guard
        for _, d in ipairs(Workspace:GetDescendants()) do
            if d.Name == "Guard" and d:IsA("Model") then
                highlightGuard(d)
                if not isGuardSleeping(d) then
                    local groot = getGuardRoot(d)
                    if groot then
                        local dist = (groot.Position - hrp.Position).Magnitude
                        if dist < nearDist then
                            nearDist = dist
                            nearAwake = d
                        end
                    end
                end
            end
        end
    end

    -- Si hay guard despierto cerca
    if nearAwake and nearDist < 35 then
        if os.clock() - lastGuardNotify > 4 then
            lastGuardNotify = os.clock()
            notify("ANTI GUARD", "Guard cerca (" .. math.floor(nearDist) .. "m)", "ESP activo", Color3.fromRGB(255, 80, 80))
        end
        -- Si está muy cerca, intentar strike + alejarse
        if nearDist < 14 and not antiGuardBusy then
            antiGuardBusy = true
            task.spawn(function()
                tryForestStrike(nearAwake)
                task.wait(0.15)
                pushAwayFromGuard(nearAwake)
                task.wait(1.2)
                antiGuardBusy = false
            end)
        end
    end
end

-- Loop Anti Guard
task.spawn(function()
    while ScreenGui and ScreenGui.Parent do
        pcall(antiGuardTick)
        task.wait(0.35)
    end
    clearGuardHighlights()
end)

-- Limpiar highlights si se desactiva
task.spawn(function()
    local was = Config.antiGuard
    while ScreenGui and ScreenGui.Parent do
        task.wait(0.5)
        if was and not Config.antiGuard then
            clearGuardHighlights()
        end
        was = Config.antiGuard
    end
end)


--------------------------------------------------------------------
-- START
--------------------------------------------------------------------
setStatus(false, "Offline")
switchTab("Logs")

Main.BackgroundTransparency = 1
MainScale.Scale = 0
tween(Main, { BackgroundTransparency = 0.55 }, 0.3)
tween(MainScale, { Scale = scaleFactor }, 0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

if LocalPlayer.Name:lower() == "kit_n67" then
    notify("ADMIN • @kit_n67", language == "vi" and "Chào mừng admin trở lại!" or "Welcome back, admin!", "FINER EGG", WHITE)
else
    notify("FINER EGG", language == "vi" and "Chào mừng bạn đến với script, chúc bạn chơi vui vẻ!" or "Welcome to the script! Have fun!", "", WHITE)
end
print("[FINER EGG] Loaded")
