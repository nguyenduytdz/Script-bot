-- Chilli Hub Custom V2 - original mobile-friendly UI template
-- Use in YOUR OWN Roblox Studio experience as a LocalScript.
-- This recreates the general layout shown in the reference screenshots,
-- not Chilli Hub's proprietary code. Game automation is intentionally not
-- connected to third-party experiences.

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local old = playerGui:FindFirstChild("ChilliHubCustomV2")
if old then old:Destroy() end

local state = {
    toggles = {},
    filters = {Rarity = "All", Search = ""},
    selectedTab = "Cày Cuốc",
    accent = Color3.fromRGB(255, 25, 20),
}
local RED = Color3.fromRGB(255, 25, 20)
local DARK = Color3.fromRGB(16, 17, 23)
local PANEL = Color3.fromRGB(28, 30, 38)
local GREEN = Color3.fromRGB(0, 220, 35)
local WHITE = Color3.fromRGB(245, 245, 245)
local MUTED = Color3.fromRGB(165, 168, 180)

local gui = Instance.new("ScreenGui")
gui.Name = "ChilliHubCustomV2"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = playerGui

local function corner(obj, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 5)
    c.Parent = obj
end
local function stroke(obj, color, thickness)
    local s = Instance.new("UIStroke")
    s.Color = color or Color3.new(0,0,0)
    s.Thickness = thickness or 2
    s.Parent = obj
end
local function make(class, props, parent)
    local obj = Instance.new(class)
    for k,v in pairs(props or {}) do obj[k] = v end
    obj.Parent = parent
    return obj
end

local openButton = make("TextButton", {
    Name="OpenButton", Text="C", Font=Enum.Font.GothamBlack, TextSize=22,
    TextColor3=WHITE, BackgroundColor3=Color3.fromRGB(135,75,255),
    Size=UDim2.fromOffset(48,48), Position=UDim2.new(1,-68,1,-115),
    AutoButtonColor=true, ZIndex=20,
}, gui)
corner(openButton, 18)
stroke(openButton, Color3.fromRGB(30,20,45), 2)

local main = make("Frame", {
    Name="Main", Size=UDim2.new(0.88,0,0.76,0),
    Position=UDim2.new(0.06,0,0.12,0), BackgroundColor3=PANEL,
    BackgroundTransparency=0.08, BorderSizePixel=0,
}, gui)
main.ClipsDescendants = true
corner(main, 8)
stroke(main, Color3.fromRGB(0,0,0), 3)
make("UISizeConstraint", {MinSize=Vector2.new(300,300), MaxSize=Vector2.new(900,650)}, main)

local scale = make("UIScale", {Scale=1}, main)
local function updateScale()
    local cam = workspace.CurrentCamera
    if not cam then return end
    local v = cam.ViewportSize
    scale.Scale = math.clamp(math.min(v.X/720, v.Y/520), 0.62, 1)
end
updateScale()
if workspace.CurrentCamera then
    workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(updateScale)
end

local header = make("Frame", {
    Size=UDim2.new(1,0,0,48), BackgroundColor3=RED, BorderSizePixel=0,
}, main)
local title = make("TextLabel", {
    Size=UDim2.new(1,-100,1,0), Position=UDim2.fromOffset(12,0),
    BackgroundTransparency=1, Text="Chilli Hub Custom V2",
    Font=Enum.Font.GothamBlack, TextSize=22, TextColor3=WHITE,
    TextXAlignment=Enum.TextXAlignment.Left,
}, header)
local status = make("TextLabel", {
    Size=UDim2.fromOffset(74,26), Position=UDim2.new(1,-112,0.5,-13),
    BackgroundColor3=Color3.fromRGB(150,0,0), Text="CUSTOM",
    Font=Enum.Font.GothamBold, TextSize=11, TextColor3=WHITE,
}, header)
corner(status, 4)
local close = make("TextButton", {
    Size=UDim2.fromOffset(36,36), Position=UDim2.new(1,-42,0,6),
    BackgroundColor3=Color3.fromRGB(180,0,0), Text="X",
    Font=Enum.Font.GothamBlack, TextSize=22, TextColor3=WHITE,
}, header)
corner(close, 5)

-- Drag by header; works with mouse and touch.
do
    local dragging, startInput, startPos, dragInput
    header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; startInput = input.Position; startPos = main.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    header.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input == dragInput or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - startInput
            main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

local body = make("Frame", {
    Position=UDim2.fromOffset(0,48), Size=UDim2.new(1,0,1,-48),
    BackgroundTransparency=1,
}, main)
local nav = make("ScrollingFrame", {
    Size=UDim2.new(0,118,1,-12), Position=UDim2.fromOffset(6,6),
    BackgroundColor3=Color3.fromRGB(38,38,43), BorderSizePixel=0,
    ScrollBarThickness=4, CanvasSize=UDim2.new(0,0,0,0),
}, body)
corner(nav, 5)
local navLayout = make("UIListLayout", {
    Padding=UDim.new(0,6), SortOrder=Enum.SortOrder.LayoutOrder,
}, nav)
make("UIPadding", {PaddingTop=UDim.new(0,7), PaddingLeft=UDim.new(0,6), PaddingRight=UDim.new(0,6)}, nav)

local content = make("Frame", {
    Position=UDim2.new(0,132,0,6), Size=UDim2.new(1,-140,1,-12),
    BackgroundColor3=Color3.fromRGB(20,21,26), BackgroundTransparency=0.15,
    BorderSizePixel=0,
}, body)
corner(content, 5)

local tabNames = {"Cày Cuốc","Người Chơi","Dự Đoán","Duy Đoán","Tiện Ích","Máy Chủ","Khác","Tùy Chỉnh","Filter"}
local navButtons = {}
local function clearContent()
    for _, child in ipairs(content:GetChildren()) do
        if not child:IsA("UICorner") then child:Destroy() end
    end
end
local function makeScroll()
    local sc = make("ScrollingFrame", {
        Size=UDim2.new(1,-10,1,-10), Position=UDim2.fromOffset(5,5),
        BackgroundTransparency=1, BorderSizePixel=0, ScrollBarThickness=5,
        ScrollBarImageColor3=RED, CanvasSize=UDim2.new(0,0,0,0),
    }, content)
    local layout = make("UIListLayout", {Padding=UDim.new(0,7), SortOrder=Enum.SortOrder.LayoutOrder}, sc)
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        sc.CanvasSize = UDim2.new(0,0,0,layout.AbsoluteContentSize.Y+10)
    end)
    return sc
end
local function heading(parent, text)
    return make("TextLabel", {
        Size=UDim2.new(1,-4,0,30), BackgroundColor3=RED,
        Text=text, Font=Enum.Font.GothamBlack, TextSize=16, TextColor3=WHITE,
        TextXAlignment=Enum.TextXAlignment.Left,
    }, parent)
end
local function note(parent, text)
    return make("TextLabel", {
        Size=UDim2.new(1,-4,0,34), BackgroundTransparency=1,
        Text=text, TextWrapped=true, Font=Enum.Font.Gotham,
        TextSize=12, TextColor3=MUTED, TextXAlignment=Enum.TextXAlignment.Left,
    }, parent)
end
local function toggleRow(parent, name, description, defaultValue)
    local row = make("Frame", {
        Size=UDim2.new(1,-4,0,description and 64 or 46),
        BackgroundColor3=Color3.fromRGB(35,37,45), BackgroundTransparency=0.08,
        BorderSizePixel=0,
    }, parent)
    corner(row, 4); stroke(row, Color3.new(0,0,0), 1)
    make("TextLabel", {
        Size=UDim2.new(1,-76,0,description and 30 or 46),
        Position=UDim2.fromOffset(10, description and 2 or 0),
        BackgroundTransparency=1, Text=name, Font=Enum.Font.GothamBold,
        TextSize=14, TextColor3=WHITE, TextXAlignment=Enum.TextXAlignment.Left,
    }, row)
    if description then
        make("TextLabel", {
            Size=UDim2.new(1,-78,0,26), Position=UDim2.fromOffset(10,31),
            BackgroundTransparency=1, Text=description, TextWrapped=true,
            Font=Enum.Font.Gotham, TextSize=10, TextColor3=MUTED,
            TextXAlignment=Enum.TextXAlignment.Left,
        }, row)
    end
    local on = defaultValue == true
    local btn = make("TextButton", {
        Size=UDim2.fromOffset(48,28), Position=UDim2.new(1,-58,0.5,-14),
        BackgroundColor3=on and GREEN or Color3.fromRGB(75,77,84),
        Text=on and "ON" or "OFF", Font=Enum.Font.GothamBlack,
        TextSize=11, TextColor3=WHITE,
    }, row)
    corner(btn, 4)
    state.toggles[name] = on
    btn.Activated:Connect(function()
        on = not on; state.toggles[name] = on
        btn.BackgroundColor3 = on and GREEN or Color3.fromRGB(75,77,84)
        btn.Text = on and "ON" or "OFF"
    end)
    return row
end
local function actionRow(parent, name, actionText, callback)
    local row = make("Frame", {Size=UDim2.new(1,-4,0,46), BackgroundColor3=Color3.fromRGB(35,37,45), BorderSizePixel=0}, parent)
    corner(row,4)
    make("TextLabel", {Size=UDim2.new(1,-105,1,0), Position=UDim2.fromOffset(10,0), BackgroundTransparency=1, Text=name, Font=Enum.Font.GothamBold, TextSize=13, TextColor3=WHITE, TextXAlignment=Enum.TextXAlignment.Left}, row)
    local b = make("TextButton", {Size=UDim2.fromOffset(88,30), Position=UDim2.new(1,-96,0.5,-15), BackgroundColor3=RED, Text=actionText, Font=Enum.Font.GothamBold, TextSize=12, TextColor3=WHITE}, row)
    corner(b,4); b.Activated:Connect(callback)
end

local function buildTab(tab)
    state.selectedTab = tab
    clearContent()
    for name, button in pairs(navButtons) do
        button.BackgroundColor3 = (name == tab) and RED or Color3.fromRGB(28,29,35)
    end
    local sc = makeScroll()
    if tab == "Cày Cuốc" then
        heading(sc, "FARM / CÀY CUỐC")
        note(sc, "Các công tắc bên dưới lưu trạng thái trong giao diện. Hãy nối chúng với cơ chế trong game do bạn tự phát triển.")
        toggleRow(sc, "Tự Động Cướp Trứng", "Bật/tắt tuỳ chọn tự động trong dự án của bạn", false)
        toggleRow(sc, "Cướp Siêu Tốc", "Cấu hình tốc độ thao tác", false)
        toggleRow(sc, "Cướp Siêu Tốc V2", nil, false)
        toggleRow(sc, "Teleport To Egg", "Tuỳ chọn dịch chuyển trong game của bạn", false)
        toggleRow(sc, "Cướp Siêu Tốc Zones", "Chọn vùng hợp lệ do game của bạn định nghĩa", false)
        toggleRow(sc, "Khu Vực Mục Tiêu", nil, false)
        toggleRow(sc, "Min Rarity", "Dùng bộ lọc độ hiếm ở tab Filter", false)
        toggleRow(sc, "Auto Hatch & Equip", nil, false)
        toggleRow(sc, "Auto Place Egg", nil, false)
        toggleRow(sc, "Auto Sell", nil, false)
        toggleRow(sc, "Auto Fuse", nil, false)
        toggleRow(sc, "Auto Butterfly Bloom", nil, false)
        toggleRow(sc, "Auto Craft Essence", nil, false)
        toggleRow(sc, "Auto Wisp", nil, false)
        toggleRow(sc, "Auto Mech Boss", nil, false)
    elseif tab == "Filter" then
        heading(sc, "FILTER FEATURES")
        note(sc, "Lọc cục bộ trong giao diện; chưa gửi lệnh tới server game.")
        local search = make("TextBox", {
            Size=UDim2.new(1,-4,0,40), BackgroundColor3=Color3.fromRGB(40,42,50),
            PlaceholderText="Tìm tên item...", Text=state.filters.Search,
            ClearTextOnFocus=false, Font=Enum.Font.Gotham, TextSize=14, TextColor3=WHITE,
            PlaceholderColor3=MUTED,
        }, sc)
        corner(search,4)
        search:GetPropertyChangedSignal("Text"):Connect(function() state.filters.Search = search.Text end)
        make("TextLabel", {Size=UDim2.new(1,-4,0,30), BackgroundTransparency=1, Text="Độ hiếm tối thiểu", Font=Enum.Font.GothamBold, TextSize=14, TextColor3=WHITE, TextXAlignment=Enum.TextXAlignment.Left}, sc)
        local rarities = {"All","Common","Uncommon","Rare","Epic","Legendary","Mythic"}
        local rarityButton = make("TextButton", {Size=UDim2.new(1,-4,0,40), BackgroundColor3=RED, Text="Độ hiếm: "..state.filters.Rarity.."  ▼", Font=Enum.Font.GothamBold, TextSize=14, TextColor3=WHITE}, sc)
        corner(rarityButton,4)
        rarityButton.Activated:Connect(function()
            local idx = table.find(rarities, state.filters.Rarity) or 1
            idx = idx % #rarities + 1
            state.filters.Rarity = rarities[idx]
            rarityButton.Text = "Độ hiếm: "..state.filters.Rarity.."  ▼"
        end)
        heading(sc, "FILTER PREVIEW")
        local preview = make("TextLabel", {Size=UDim2.new(1,-4,0,65), BackgroundColor3=Color3.fromRGB(35,37,45), TextWrapped=true, Text="Từ khoá: "..(state.filters.Search ~= "" and state.filters.Search or "(trống)").."\nĐộ hiếm: "..state.filters.Rarity, Font=Enum.Font.Gotham, TextSize=13, TextColor3=WHITE}, sc)
        corner(preview,4)
        local refresh = make("TextButton", {Size=UDim2.new(1,-4,0,38), BackgroundColor3=GREEN, Text="Cập nhật xem trước", Font=Enum.Font.GothamBold, TextSize=13, TextColor3=Color3.new(0,0,0)}, sc)
        corner(refresh,4)
        refresh.Activated:Connect(function()
            preview.Text = "Từ khoá: "..(state.filters.Search ~= "" and state.filters.Search or "(trống)").."\nĐộ hiếm: "..state.filters.Rarity
        end)
    elseif tab == "Người Chơi" then
        heading(sc, "PLAYER")
        note(sc, "Các tiện ích chỉ áp dụng cho trải nghiệm bạn sở hữu và các cơ chế được phép.")
        toggleRow(sc, "Hiện thông tin người chơi", nil, false)
        toggleRow(sc, "Hiện tên trên giao diện", nil, false)
        toggleRow(sc, "Theo dõi người chơi được chọn", nil, false)
        local box = make("TextBox", {Size=UDim2.new(1,-4,0,40), BackgroundColor3=Color3.fromRGB(40,42,50), PlaceholderText="Nhập username...", Text="", ClearTextOnFocus=true, Font=Enum.Font.Gotham, TextSize=14, TextColor3=WHITE}, sc)
        corner(box,4)
        actionRow(sc, "Kiểm tra người chơi trong server hiện tại", "Kiểm tra", function()
            local found = false
            for _, p in ipairs(Players:GetPlayers()) do
                if p.Name:lower() == box.Text:lower() or p.DisplayName:lower() == box.Text:lower() then found = true end
            end
            box.Text = found and "Đang ở server này" or "Không thấy trong server"
        end)
    elseif tab == "Dự Đoán" or tab == "Duy Đoán" then
        heading(sc, tab:upper())
        note(sc, "Khu vực dành cho bảng dự đoán/hiển thị dữ liệu của game do bạn phát triển.")
        toggleRow(sc, "Hiện bảng dự đoán", nil, false)
        toggleRow(sc, "Cập nhật tự động giao diện", nil, false)
        actionRow(sc, "Làm mới bảng hiển thị", "Làm mới", function() end)
    elseif tab == "Tiện Ích" then
        heading(sc, "TIỆN ÍCH")
        toggleRow(sc, "Hiện FPS", nil, true)
        toggleRow(sc, "Hiện thông tin phiên", nil, false)
        actionRow(sc, "Đưa giao diện về giữa màn hình", "Căn giữa", function()
            main.Position = UDim2.new(0.06,0,0.12,0)
        end)
    elseif tab == "Máy Chủ" then
        heading(sc, "MÁY CHỦ")
        note(sc, "Thông tin server hiện tại; không tự động nhảy server.")
        local place = make("TextLabel", {Size=UDim2.new(1,-4,0,40), BackgroundColor3=Color3.fromRGB(35,37,45), Text="PlaceId: "..tostring(game.PlaceId), Font=Enum.Font.Gotham, TextSize=13, TextColor3=WHITE}, sc)
        corner(place,4)
        local job = make("TextLabel", {Size=UDim2.new(1,-4,0,54), BackgroundColor3=Color3.fromRGB(35,37,45), TextWrapped=true, Text="JobId: "..(game.JobId ~= "" and game.JobId or "Không có trong Studio"), Font=Enum.Font.Gotham, TextSize=11, TextColor3=WHITE}, sc)
        corner(job,4)
        actionRow(sc, "Làm mới thông tin", "Làm mới", function()
            place.Text = "PlaceId: "..tostring(game.PlaceId)
            job.Text = "JobId: "..(game.JobId ~= "" and game.JobId or "Không có trong Studio")
        end)
    elseif tab == "Khác" then
        heading(sc, "MISC")
        toggleRow(sc, "Hiện thông báo trong UI", nil, true)
        toggleRow(sc, "Chế độ giao diện gọn", nil, false)
        actionRow(sc, "Ẩn / hiện menu", "Ẩn menu", function() main.Visible = false; openButton.Visible = true end)
    elseif tab == "Tùy Chỉnh" then
        heading(sc, "SETTINGS / CONFIG")
        note(sc, "Tuỳ chỉnh màu nhấn và kích thước. Trạng thái chỉ được giữ trong phiên hiện tại.")
        local colors = {
            {"Đỏ", Color3.fromRGB(255,25,20)}, {"Xanh lá", Color3.fromRGB(0,220,35)},
            {"Xanh dương", Color3.fromRGB(0,145,255)}, {"Tím", Color3.fromRGB(145,70,255)},
            {"Cam", Color3.fromRGB(255,125,0)},
        }
        for _, entry in ipairs(colors) do
            local label, color = entry[1], entry[2]
            actionRow(sc, "Màu "..label, "Áp dụng", function()
                state.accent = color
                header.BackgroundColor3 = color
                status.BackgroundColor3 = color
                for _, b in pairs(navButtons) do
                    if b.Name == "Tab_"..state.selectedTab then b.BackgroundColor3 = color end
                end
            end)
        end
        actionRow(sc, "Đặt lại vị trí menu", "Đặt lại", function() main.Position = UDim2.new(0.06,0,0.12,0) end)
        actionRow(sc, "Đóng giao diện", "Đóng", function() main.Visible = false; openButton.Visible = true end)
    end
end

for i, tab in ipairs(tabNames) do
    local b = make("TextButton", {
        Name="Tab_"..tab, Size=UDim2.new(1,0,0,42), LayoutOrder=i,
        BackgroundColor3=(tab=="Cày Cuốc") and RED or Color3.fromRGB(28,29,35),
        Text=tab, Font=Enum.Font.GothamBlack, TextSize=13, TextColor3=WHITE,
        TextWrapped=true,
    }, nav)
    corner(b,4); stroke(b,Color3.new(0,0,0),1)
    navButtons[tab] = b
    b.Activated:Connect(function() buildTab(tab) end)
end
navLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    nav.CanvasSize = UDim2.new(0,0,0,navLayout.AbsoluteContentSize.Y+14)
end)

close.Activated:Connect(function() main.Visible=false; openButton.Visible=true end)
openButton.Activated:Connect(function() main.Visible=true; openButton.Visible=false end)

-- Tiny FPS indicator inside the panel.
local fpsLabel = make("TextLabel", {
    Size=UDim2.fromOffset(100,18), Position=UDim2.new(1,-108,1,-20),
    BackgroundTransparency=1, Text="FPS: --", Font=Enum.Font.GothamBold,
    TextSize=10, TextColor3=GREEN, TextXAlignment=Enum.TextXAlignment.Right,
}, main)
local frames, elapsed = 0, 0
RunService.RenderStepped:Connect(function(dt)
    frames += 1; elapsed += dt
    if elapsed >= 1 then
        fpsLabel.Text = "FPS: "..tostring(math.floor(frames/elapsed))
        frames, elapsed = 0, 0
    end
end)

buildTab("Cày Cuốc")
