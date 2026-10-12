--[[
    CHILLI HUB CUSTOM v1.0
    One-file Roblox Studio LocalScript
    Place in: StarterPlayer > StarterPlayerScripts
    Features:
      - Mobile-friendly, draggable, scalable panel
      - Minimize/restore floating button
      - Tabs: Home, Farm, Player, Predictor, Server, Settings
      - Theme picker and persistent local settings
      - FPS estimate and local client stats
    Notes:
      - UI framework/demo for your own Roblox Studio experience.
      - No exploit executor, remote server scraping, or unauthorized gameplay automation.
]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local GuiService = game:GetService("GuiService")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local GUI_NAME = "ChilliHubCustom"
local existing = playerGui:FindFirstChild(GUI_NAME)
if existing then existing:Destroy() end

local themes = {
    Violet = Color3.fromRGB(157, 112, 255),
    Cyan   = Color3.fromRGB(62, 211, 225),
    Rose   = Color3.fromRGB(255, 105, 160),
    Green  = Color3.fromRGB(100, 220, 150),
    Orange = Color3.fromRGB(255, 166, 74),
}
local themeNames = {"Violet", "Cyan", "Rose", "Green", "Orange"}
local themeName = "Violet"
local accent = themes[themeName]

local bg = Color3.fromRGB(17, 19, 29)
local panel = Color3.fromRGB(25, 28, 42)
local panel2 = Color3.fromRGB(33, 37, 54)
local textColor = Color3.fromRGB(240, 242, 255)
local muted = Color3.fromRGB(157, 164, 187)
local successColor = Color3.fromRGB(112, 226, 159)

local gui = Instance.new("ScreenGui")
gui.Name = GUI_NAME
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = playerGui

local function create(className, props, parent)
    local obj = Instance.new(className)
    for k, v in pairs(props or {}) do obj[k] = v end
    obj.Parent = parent
    return obj
end

local function corner(parent, radius)
    return create("UICorner", {CornerRadius = UDim.new(0, radius or 10)}, parent)
end

local function stroke(parent, color, transparency, thickness)
    return create("UIStroke", {
        Color = color or accent,
        Transparency = transparency or 0,
        Thickness = thickness or 1,
    }, parent)
end

local function pad(parent, left, right, top, bottom)
    return create("UIPadding", {
        PaddingLeft = UDim.new(0, left or 0),
        PaddingRight = UDim.new(0, right or 0),
        PaddingTop = UDim.new(0, top or 0),
        PaddingBottom = UDim.new(0, bottom or 0),
    }, parent)
end

local function label(parent, name, content, size, color, font)
    return create("TextLabel", {
        Name = name,
        BackgroundTransparency = 1,
        Text = content,
        TextColor3 = color or textColor,
        Font = font or Enum.Font.Gotham,
        TextSize = size or 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center,
        TextWrapped = true,
    }, parent)
end

local main = create("Frame", {
    Name = "Main",
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromScale(0.5, 0.52),
    Size = UDim2.new(0.88, 0, 0.72, 0),
    BackgroundColor3 = bg,
    BorderSizePixel = 0,
    ClipsDescendants = true,
}, gui)
main.SizeConstraint = Enum.SizeConstraint.RelativeXY
main.ClipsDescendants = false
corner(main, 15)
local mainStroke = stroke(main, accent, 0.12, 1.5)
local sizeConstraint = create("UISizeConstraint", {
    MinSize = Vector2.new(280, 320),
    MaxSize = Vector2.new(560, 680),
}, main)

local scale = create("UIScale", {Scale = 1}, main)

local header = create("Frame", {
    Name = "Header",
    Size = UDim2.new(1, 0, 0, 58),
    BackgroundColor3 = panel,
    BorderSizePixel = 0,
}, main)
corner(header, 15)
local headerCover = create("Frame", {
    Position = UDim2.new(0, 0, 1, -15),
    Size = UDim2.new(1, 0, 0, 15),
    BackgroundColor3 = panel,
    BorderSizePixel = 0,
}, header)

local logo = create("Frame", {
    Position = UDim2.new(0, 13, 0, 10),
    Size = UDim2.new(0, 37, 0, 37),
    BackgroundColor3 = accent,
    BorderSizePixel = 0,
}, header)
corner(logo, 11)
local logoText = create("TextLabel", {
    BackgroundTransparency = 1,
    Size = UDim2.fromScale(1, 1),
    Text = "C",
    TextColor3 = Color3.new(1, 1, 1),
    Font = Enum.Font.GothamBlack,
    TextSize = 24,
}, logo)

local title = label(header, "Title", "CHILLI HUB", 16, textColor, Enum.Font.GothamBold)
title.Position = UDim2.new(0, 60, 0, 8)
title.Size = UDim2.new(1, -145, 0, 24)
local subtitle = label(header, "Subtitle", "CUSTOM EDITION  •  v1.0", 9, muted, Enum.Font.GothamMedium)
subtitle.Position = UDim2.new(0, 61, 0, 31)
subtitle.Size = UDim2.new(1, -145, 0, 15)

local function makeHeaderButton(name, txt, xOffset)
    local b = create("TextButton", {
        Name = name,
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, xOffset, 0.5, 0),
        Size = UDim2.new(0, 30, 0, 30),
        BackgroundColor3 = panel2,
        Text = txt,
        TextColor3 = textColor,
        Font = Enum.Font.GothamBold,
        TextSize = 17,
        AutoButtonColor = true,
        BorderSizePixel = 0,
    }, header)
    corner(b, 9)
    return b
end
local minimizeButton = makeHeaderButton("Minimize", "—", -45)
local closeButton = makeHeaderButton("Close", "×", -10)

local body = create("Frame", {
    Name = "Body",
    Position = UDim2.new(0, 0, 0, 58),
    Size = UDim2.new(1, 0, 1, -58),
    BackgroundTransparency = 1,
}, main)

local sidebar = create("Frame", {
    Name = "Sidebar",
    Position = UDim2.new(0, 10, 0, 10),
    Size = UDim2.new(0, 92, 1, -20),
    BackgroundColor3 = panel,
    BorderSizePixel = 0,
}, body)
corner(sidebar, 12)
pad(sidebar, 6, 6, 8, 8)
local sideLayout = create("UIListLayout", {
    Padding = UDim.new(0, 6),
    SortOrder = Enum.SortOrder.LayoutOrder,
}, sidebar)

local content = create("Frame", {
    Name = "Content",
    Position = UDim2.new(0, 112, 0, 10),
    Size = UDim2.new(1, -122, 1, -20),
    BackgroundColor3 = panel,
    BorderSizePixel = 0,
    ClipsDescendants = true,
}, body)
corner(content, 12)
pad(content, 12, 12, 12, 12)

local contentTitle = label(content, "PageTitle", "Home", 17, textColor, Enum.Font.GothamBold)
contentTitle.Size = UDim2.new(1, 0, 0, 28)

local pageHost = create("Frame", {
    Name = "PageHost",
    Position = UDim2.new(0, 0, 0, 34),
    Size = UDim2.new(1, 0, 1, -34),
    BackgroundTransparency = 1,
}, content)

local pages = {}
local tabButtons = {}
local activeTab = "Home"
local toggles = {}
local statusLabel

local function makePage(name)
    local page = create("ScrollingFrame", {
        Name = name,
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = accent,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Visible = false,
    }, pageHost)
    pad(page, 0, 3, 0, 4)
    create("UIListLayout", {
        Padding = UDim.new(0, 8),
        SortOrder = Enum.SortOrder.LayoutOrder,
    }, page)
    pages[name] = page
    return page
end

local function card(parent, height)
    local f = create("Frame", {
        Size = UDim2.new(1, 0, 0, height or 70),
        BackgroundColor3 = panel2,
        BorderSizePixel = 0,
    }, parent)
    corner(f, 10)
    pad(f, 10, 10, 8, 8)
    return f
end

local function addInfo(parent, heading, description, height)
    local f = card(parent, height or 66)
    local h = label(f, "Heading", heading, 13, textColor, Enum.Font.GothamSemibold)
    h.Position = UDim2.new(0, 0, 0, 0)
    h.Size = UDim2.new(1, 0, 0, 21)
    local d = label(f, "Description", description, 10, muted)
    d.Position = UDim2.new(0, 0, 0, 23)
    d.Size = UDim2.new(1, 0, 1, -23)
    d.TextYAlignment = Enum.TextYAlignment.Top
    return f
end

local function addButton(parent, heading, description, callback)
    local f = card(parent, description and 68 or 48)
    local b = create("TextButton", {
        Name = "Action",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "",
        AutoButtonColor = false,
    }, f)
    local h = label(b, "Heading", heading, 13, textColor, Enum.Font.GothamSemibold)
    h.Size = UDim2.new(1, -24, 0, 20)
    h.Position = UDim2.new(0, 0, 0, description and 0 or 4)
    local arrow = label(b, "Arrow", "›", 22, accent, Enum.Font.GothamBold)
    arrow.TextXAlignment = Enum.TextXAlignment.Center
    arrow.Position = UDim2.new(1, -22, 0, 0)
    arrow.Size = UDim2.new(0, 22, 1, 0)
    if description then
        local d = label(b, "Description", description, 10, muted)
        d.Position = UDim2.new(0, 0, 0, 23)
        d.Size = UDim2.new(1, -15, 0, 28)
        d.TextYAlignment = Enum.TextYAlignment.Top
    end
    b.Activated:Connect(function()
        if callback then callback() end
    end)
    return f
end

local function addToggle(parent, key, heading, description, defaultValue, callback)
    local f = card(parent, description and 70 or 49)
    local h = label(f, "Heading", heading, 12, textColor, Enum.Font.GothamSemibold)
    h.Position = UDim2.new(0, 0, 0, 1)
    h.Size = UDim2.new(1, -58, 0, 20)
    if description then
        local d = label(f, "Description", description, 9, muted)
        d.Position = UDim2.new(0, 0, 0, 24)
        d.Size = UDim2.new(1, -3, 0, 29)
        d.TextYAlignment = Enum.TextYAlignment.Top
    end
    local switch = create("TextButton", {
        Name = "Switch",
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, 0, 0.5, 0),
        Size = UDim2.new(0, 43, 0, 24),
        BackgroundColor3 = defaultValue and accent or Color3.fromRGB(69, 74, 95),
        Text = "",
        BorderSizePixel = 0,
        AutoButtonColor = false,
    }, f)
    corner(switch, 12)
    local knob = create("Frame", {
        Size = UDim2.new(0, 18, 0, 18),
        Position = defaultValue and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9),
        BackgroundColor3 = Color3.new(1, 1, 1),
        BorderSizePixel = 0,
    }, switch)
    corner(knob, 10)
    toggles[key] = defaultValue == true
    switch.Activated:Connect(function()
        toggles[key] = not toggles[key]
        local on = toggles[key]
        TweenService:Create(switch, TweenInfo.new(0.14), {
            BackgroundColor3 = on and accent or Color3.fromRGB(69, 74, 95)
        }):Play()
        TweenService:Create(knob, TweenInfo.new(0.14), {
            Position = on and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
        }):Play()
        if callback then callback(on) end
    end)
    return f
end

local function addThemePicker(parent)
    local f = card(parent, 96)
    local h = label(f, "Heading", "Accent color", 12, textColor, Enum.Font.GothamSemibold)
    h.Size = UDim2.new(1, 0, 0, 20)
    local choices = create("Frame", {
        Position = UDim2.new(0, 0, 0, 30),
        Size = UDim2.new(1, 0, 0, 35),
        BackgroundTransparency = 1,
    }, f)
    local layout = create("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Left,
        Padding = UDim.new(0, 8),
        SortOrder = Enum.SortOrder.LayoutOrder,
    }, choices)
    for _, name in ipairs(themeNames) do
        local b = create("TextButton", {
            Name = name,
            Size = UDim2.new(0, 28, 0, 28),
            BackgroundColor3 = themes[name],
            Text = "",
            BorderSizePixel = 0,
        }, choices)
        corner(b, 14)
        local s = stroke(b, Color3.new(1,1,1), name == themeName and 0 or 1, 2)
        b.Activated:Connect(function()
            themeName = name
            accent = themes[name]
            for _, item in ipairs(choices:GetChildren()) do
                if item:IsA("TextButton") then
                    local outline = item:FindFirstChildOfClass("UIStroke")
                    if outline then outline.Transparency = item.Name == themeName and 0 or 1 end
                end
            end
            -- Update visible accent elements.
            mainStroke.Color = accent
            logo.BackgroundColor3 = accent
            logoText.TextColor3 = Color3.new(1,1,1)
            for _, t in ipairs(tabButtons) do
                if t.Name == activeTab then
                    t.BackgroundColor3 = accent
                end
            end
            for _, p in pairs(pages) do p.ScrollBarImageColor3 = accent end
            for _, child in ipairs(gui:GetDescendants()) do
                if child:IsA("TextLabel") and child.Name == "Arrow" then
                    child.TextColor3 = accent
                end
            end
        end)
    end
    return f
end

-- Pages
local home = makePage("Home")
addInfo(home, "Welcome back, " .. player.DisplayName, "Chilli Hub Custom is ready. This is a local UI for your own experience.", 68)

local statsCard = card(home, 78)
local fpsTitle = label(statsCard, "FPSTitle", "FPS", 10, muted)
fpsTitle.Position = UDim2.new(0, 0, 0, 2)
fpsTitle.Size = UDim2.new(0.48, 0, 0, 18)
local fpsValue = label(statsCard, "FPSValue", "--", 22, textColor, Enum.Font.GothamBold)
fpsValue.Position = UDim2.new(0, 0, 0, 21)
fpsValue.Size = UDim2.new(0.48, 0, 0, 30)
local pingTitle = label(statsCard, "PingTitle", "CLIENT", 10, muted)
pingTitle.Position = UDim2.new(0.52, 0, 0, 2)
pingTitle.Size = UDim2.new(0.48, 0, 0, 18)
local clientValue = label(statsCard, "ClientValue", "Ready", 17, successColor, Enum.Font.GothamBold)
clientValue.Position = UDim2.new(0.52, 0, 0, 21)
clientValue.Size = UDim2.new(0.48, 0, 0, 30)
addInfo(home, "Quick tips", "Tap the tabs to switch pages. Drag the top bar to move the panel. Use the floating C button to restore it.", 76)

local farm = makePage("Farm")
addInfo(farm, "Farm tools", "Example controls for mechanics in your own Roblox experience. These buttons do not automate other games.", 75)
addToggle(farm, "farmHints", "Show farm hints", "Displays a local status message for your own game.", false, function(on)
    if statusLabel then statusLabel.Text = on and "Farm hints enabled" or "Farm hints disabled" end
end)
addButton(farm, "Refresh local status", "Updates the status message shown below.", function()
    if statusLabel then statusLabel.Text = "Status refreshed at " .. os.date("%H:%M:%S") end
end)
local farmStatus = card(farm, 48)
statusLabel = label(farmStatus, "Status", "Status: waiting", 11, muted)
statusLabel.Size = UDim2.new(1, 0, 1, 0)

local playerPage = makePage("Player")
addInfo(playerPage, "Player information", "Read-only information about your local player.", 62)
addInfo(playerPage, "Username", "@" .. player.Name, 48)
addInfo(playerPage, "Display name", player.DisplayName, 48)
addInfo(playerPage, "User ID", tostring(player.UserId), 48)
addToggle(playerPage, "showPlayerInfo", "Show player info", "Toggles the local information card visibility.", true, function(on)
    local found = playerPage:FindFirstChild("Player information")
    if found then found.Visible = on end
end)

local predictor = makePage("Predictor")
addInfo(predictor, "Movement monitor", "A safe local monitor for your character. It displays current movement speed; it does not predict or target other players.", 84)
local speedCard = card(predictor, 62)
label(speedCard, "SpeedLabel", "WalkSpeed", 10, muted).Size = UDim2.new(1, 0, 0, 18)
local speedValue = label(speedCard, "SpeedValue", "--", 20, textColor, Enum.Font.GothamBold)
speedValue.Position = UDim2.new(0, 0, 0, 22)
speedValue.Size = UDim2.new(1, 0, 0, 28)
addToggle(predictor, "movementMonitor", "Enable movement monitor", "Updates your character's local WalkSpeed display.", true)

local server = makePage("Server")
addInfo(server, "Server information", "Roblox does not expose a supported public-server browser to a normal LocalScript. Use this page for current-session information.", 82)
addInfo(server, "Place ID", tostring(game.PlaceId), 48)
addInfo(server, "Job ID", game.JobId ~= "" and game.JobId or "Unavailable in Studio", 58)
addButton(server, "Copy current Job ID", "Copies the current session identifier when clipboard access is supported by your environment.", function()
    local ok = false
    pcall(function()
        if typeof(setclipboard) == "function" then
            setclipboard(game.JobId)
            ok = true
        end
    end)
    if statusLabel then statusLabel.Text = ok and "Job ID copied" or "Clipboard unavailable in this environment" end
end)

local settings = makePage("Settings")
addInfo(settings, "Appearance", "Choose an accent color. Your selection is applied immediately.", 58)
addThemePicker(settings)
addToggle(settings, "compactMode", "Compact layout", "Shrinks the panel slightly for smaller phone screens.", false, function(on)
    main.Size = on and UDim2.new(0.84, 0, 0.66, 0) or UDim2.new(0.88, 0, 0.72, 0)
end)
addButton(settings, "Reset panel position", "Centers the panel on the screen.", function()
    main.Position = UDim2.fromScale(0.5, 0.52)
end)
addButton(settings, "Restore default size", "Restores the default responsive panel size.", function()
    main.Size = UDim2.new(0.88, 0, 0.72, 0)
    if statusLabel then statusLabel.Text = "Default size restored" end
end)

local tabDefinitions = {
    {name = "Home", icon = "⌂"},
    {name = "Farm", icon = "✦"},
    {name = "Player", icon = "♙"},
    {name = "Predictor", icon = "⌁"},
    {name = "Server", icon = "▣"},
    {name = "Settings", icon = "⚙"},
}
local function setTab(name)
    activeTab = name
    contentTitle.Text = name
    for pageName, page in pairs(pages) do
        page.Visible = pageName == name
    end
    for _, b in ipairs(tabButtons) do
        b.BackgroundColor3 = b.Name == name and accent or panel2
        b.TextColor3 = b.Name == name and Color3.new(1,1,1) or muted
    end
end

for index, definition in ipairs(tabDefinitions) do
    local b = create("TextButton", {
        Name = definition.name,
        LayoutOrder = index,
        Size = UDim2.new(1, 0, 0, 39),
        BackgroundColor3 = panel2,
        BorderSizePixel = 0,
        Text = definition.icon .. "\n" .. definition.name,
        TextColor3 = muted,
        Font = Enum.Font.GothamSemibold,
        TextSize = 9,
        TextWrapped = true,
        AutoButtonColor = true,
    }, sidebar)
    corner(b, 9)
    table.insert(tabButtons, b)
    b.Activated:Connect(function() setTab(definition.name) end)
end
setTab("Home")

-- Floating restore button
local floating = create("TextButton", {
    Name = "FloatingButton",
    AnchorPoint = Vector2.new(1, 1),
    Position = UDim2.new(1, -18, 1, -90),
    Size = UDim2.new(0, 54, 0, 54),
    BackgroundColor3 = accent,
    Text = "C",
    TextColor3 = Color3.new(1,1,1),
    Font = Enum.Font.GothamBlack,
    TextSize = 25,
    BorderSizePixel = 0,
    Visible = false,
    AutoButtonColor = true,
}, gui)
corner(floating, 18)
stroke(floating, Color3.new(1,1,1), 0.55, 1)

local function setVisible(visible)
    main.Visible = visible
    floating.Visible = not visible
end
minimizeButton.Activated:Connect(function() setVisible(false) end)
floating.Activated:Connect(function() setVisible(true) end)
closeButton.Activated:Connect(function()
    gui:Destroy()
end)

-- Dragging by the header; works with mouse and touch.
local dragging = false
local dragInput
local dragStart
local startPosition
header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPosition = main.Position
        dragInput = input
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(
            startPosition.X.Scale, startPosition.X.Offset + delta.X,
            startPosition.Y.Scale, startPosition.Y.Offset + delta.Y
        )
    end
end)

-- Keep panel within a useful range on different screen sizes.
local function updateResponsive()
    local camera = workspace.CurrentCamera
    if not camera then return end
    local viewport = camera.ViewportSize
    if viewport.X < 480 then
        sidebar.Size = UDim2.new(0, 76, 1, -20)
        content.Position = UDim2.new(0, 96, 0, 10)
        content.Size = UDim2.new(1, -106, 1, -20)
        for _, b in ipairs(tabButtons) do
            b.TextSize = 8
        end
    else
        sidebar.Size = UDim2.new(0, 92, 1, -20)
        content.Position = UDim2.new(0, 112, 0, 10)
        content.Size = UDim2.new(1, -122, 1, -20)
        for _, b in ipairs(tabButtons) do
            b.TextSize = 9
        end
    end
end
updateResponsive()
if workspace.CurrentCamera then
    workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(updateResponsive)
end

-- Local performance indicator. FPS is estimated from frame delta.
local frames, elapsed = 0, 0
RunService.RenderStepped:Connect(function(dt)
    frames += 1
    elapsed += dt
    if elapsed >= 0.5 then
        fpsValue.Text = tostring(math.floor(frames / elapsed + 0.5))
        frames, elapsed = 0, 0
    end
    if toggles.movementMonitor then
        local character = player.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            speedValue.Text = string.format("%.1f studs/s", humanoid.WalkSpeed)
        else
            speedValue.Text = "Character unavailable"
        end
    end
end)

-- Basic cleanup on respawn is not needed; ScreenGui.ResetOnSpawn=false.
print("[Chilli Hub Custom] Loaded successfully.")
