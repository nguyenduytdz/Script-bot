-- ============================================================
-- LocalScript — Tối ưu cho Mobile & PC
-- ============================================================
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local player = Players.LocalPlayer

-- ===== TẠO GUI TỔNG =====
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FriendMenuGui"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.DisplayOrder = 999
screenGui.Parent = player:WaitForChild("PlayerGui")

-- ===== NÚT BẬT MENU (Nằm giữa dưới màn hình) =====
local openBtn = Instance.new("TextButton")
openBtn.Size = UDim2.new(0, 150, 0, 45)
openBtn.Position = UDim2.new(0.5, 0, 0.9, 0) -- Giữa màn hình, cách đáy 10%
openBtn.AnchorPoint = Vector2.new(0.5, 0.5)
openBtn.Text = "👥 MỞ BẠN BÈ"
openBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
openBtn.TextColor3 = Color3.new(1, 1, 1)
openBtn.Font = Enum.Font.GothamBold
openBtn.TextSize = 16
openBtn.ZIndex = 10
openBtn.Parent = screenGui

-- ===== FRAME CHÍNH (Nằm giữa màn hình, tự co giãn) =====
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0.85, 0, 0.75, 0) -- Chiếm 85% rộng, 75% cao màn hình
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.Visible = false
mainFrame.ZIndex = 5
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

-- Viền cho đẹp
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = mainFrame

-- Nút Đóng
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 35, 0, 35)
closeBtn.Position = UDim2.new(1, -40, 0, 5)
closeBtn.Text = "X"
closeBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 18
closeBtn.ZIndex = 7
closeBtn.Parent = mainFrame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = closeBtn

-- Tiêu đề
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -50, 0, 40)
title.Position = UDim2.new(0, 10, 0, 5)
title.Text = "Danh Sách Bạn Bè"
title.TextXAlignment = Enum.TextXAlignment.Left
title.BackgroundTransparency = 1
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.ZIndex = 6
title.Parent = mainFrame

-- Ô tìm kiếm
local searchBox = Instance.new("TextBox")
searchBox.Size = UDim2.new(1, -20, 0, 40)
searchBox.Position = UDim2.new(0, 10, 0, 50)
searchBox.PlaceholderText = "Nhập @username để tìm..."
searchBox.Text = ""
searchBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
searchBox.TextColor3 = Color3.new(1, 1, 1)
searchBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
searchBox.Font = Enum.Font.Gotham
searchBox.TextSize = 15
searchBox.ZIndex = 6
searchBox.Parent = mainFrame

local searchCorner = Instance.new("UICorner")
searchCorner.CornerRadius = UDim.new(0, 6)
searchCorner.Parent = searchBox

-- Nút tìm kiếm
local searchBtn = Instance.new("TextButton")
searchBtn.Size = UDim2.new(1, -20, 0, 40)
searchBtn.Position = UDim2.new(0, 10, 0, 95)
searchBtn.Text = "🔍 Tìm Kiếm"
searchBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
searchBtn.TextColor3 = Color3.new(1, 1, 1)
searchBtn.Font = Enum.Font.GothamBold
searchBtn.TextSize = 15
searchBtn.ZIndex = 6
searchBtn.Parent = mainFrame

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 6)
btnCorner.Parent = searchBtn

-- Khung kết quả tìm kiếm
local searchResult = Instance.new("Frame")
searchResult.Size = UDim2.new(1, -20, 0, 80)
searchResult.Position = UDim2.new(0, 10, 0, 140)
searchResult.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
searchResult.Visible = false
searchResult.ZIndex = 6
searchResult.Parent = mainFrame

local resultCorner = Instance.new("UICorner")
resultCorner.CornerRadius = UDim.new(0, 6)
resultCorner.Parent = searchResult

-- Khu vực danh sách bạn bè (Tự động cuộn)
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, -20, 1, -230)
scrollFrame.Position = UDim2.new(0, 10, 0, 225)
scrollFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
scrollFrame.ScrollBarThickness = 6
scrollFrame.ZIndex = 6
scrollFrame.Parent = mainFrame

local scrollCorner = Instance.new("UICorner")
scrollCorner.CornerRadius = UDim.new(0, 6)
scrollCorner.Parent = scrollFrame

local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 5)
listLayout.Parent = scrollFrame

-- ===== HÀM HỖ TRỢ =====
local function clearGuiChildren(parent)
    for _, child in ipairs(parent:GetChildren()) do
        if child:IsA("GuiObject") then child:Destroy() end
    end
end

local function showMessage(parent, text, color)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -10, 1, -10)
    lbl.Position = UDim2.new(0, 5, 0, 5)
    lbl.Text = text
    lbl.TextColor3 = color or Color3.fromRGB(200, 200, 200)
    lbl.BackgroundTransparency = 1
    lbl.TextWrapped = true
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 14
    lbl.Parent = parent
    return lbl
end

-- ===== DANH SÁCH BẠN BÈ =====
local function refreshFriendsList()
    clearGuiChildren(scrollFrame)
    local ok, friends = pcall(function() return player:GetFriendsOnline() end)
    
    if not ok or not friends or #friends == 0 then
        showMessage(scrollFrame, "Không có bạn bè trực tuyến", Color3.fromRGB(150, 150, 150))
        return
    end

    for _, friendData in ipairs(friends) do
        local row = Instance.new("Frame")
        row.Size = UDim2.new(1, -10, 0, 50)
        row.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
        row.Parent = scrollFrame
        
        local rowCorner = Instance.new("UICorner")
        rowCorner.CornerRadius = UDim.new(0, 6)
        rowCorner.Parent = row

        local dn = friendData.DisplayName or friendData.Username or "?"
        local un = friendData.Username or "?"

        local nameLabel = Instance.new("TextLabel")
        nameLabel.Size = UDim2.new(1, -80, 1, 0)
        nameLabel.Position = UDim2.new(0, 10, 0, 0)
        nameLabel.Text = dn .. " (@" .. un .. ")"
        nameLabel.TextXAlignment = Enum.TextXAlignment.Left
        nameLabel.TextColor3 = Color3.new(1, 1, 1)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Font = Enum.Font.Gotham
        nameLabel.TextSize = 14
        nameLabel.TextTruncate = Enum.TextTruncate.AtEnd
        nameLabel.Parent = row

        local joinBtn = Instance.new("TextButton")
        joinBtn.Size = UDim2.new(0, 60, 0, 35)
        joinBtn.Position = UDim2.new(1, -70, 0.5, -17.5)
        joinBtn.Text = "Join"
        joinBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
        joinBtn.TextColor3 = Color3.new(1, 1, 1)
        joinBtn.Font = Enum.Font.GothamBold
        joinBtn.TextSize = 14
        joinBtn.Parent = row
        
        local joinCorner = Instance.new("UICorner")
        joinCorner.CornerRadius = UDim.new(0, 6)
        joinCorner.Parent = joinBtn

        local placeId = friendData.PlaceId
        local inGame = placeId ~= nil and placeId > 0
        joinBtn.Visible = inGame

        joinBtn.MouseButton1Click:Connect(function()
            if not inGame then return end
            joinBtn.Text = "..."
            joinBtn.Active = false
            local success, err = pcall(function()
                TeleportService:Teleport(placeId, player)
            end)
            if not success then
                joinBtn.Text = "Lỗi"
                task.wait(2)
                joinBtn.Text = "Join"
                joinBtn.Active = true
            end
        end)
    end
end

-- ===== TÌM KIẾM NGƯỜI CHƠI =====
local function searchUser(username)
    clearGuiChildren(searchResult)
    searchResult.Visible = false
    if username == "" then return end

    searchResult.Visible = true
    local loading = showMessage(searchResult, "Đang tìm...", Color3.fromRGB(180, 180, 180))

    if not HttpService.HttpEnabled then
        loading:Destroy()
        showMessage(searchResult, "Lỗi: Chưa bật HTTP trong Game Settings!", Color3.fromRGB(255, 100, 100))
        return
    end

    local url = "https://users.roproxy.com/v1/users/search?keyword=" .. HttpService:UrlEncode(username) .. "&limit=1"
    local ok, res = pcall(function() return HttpService:GetAsync(url, true) end)
    loading:Destroy()

    if not ok or not res then
        showMessage(searchResult, "Lỗi mạng hoặc proxy chết.", Color3.fromRGB(255, 100, 100))
        return
    end

    local okJ, data = pcall(function() return HttpService:JSONDecode(res) end)
    if not okJ or not data or not data.data or #data.data == 0 then
        showMessage(searchResult, "Không tìm thấy: @" .. username, Color3.fromRGB(255, 100, 100))
        return
    end

    local u = data.data[1]
    
    -- Hiển thị kết quả
    local avatarFrame = Instance.new("Frame")
    avatarFrame.Size = UDim2.new(0, 50, 0, 50)
    avatarFrame.Position = UDim2.new(0, 10, 0, 15)
    avatarFrame.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    avatarFrame.Parent = searchResult
    
    local avCorner = Instance.new("UICorner")
    avCorner.CornerRadius = UDim.new(1, 0)
    avCorner.Parent = avatarFrame

    -- Load Avatar
    task.spawn(function()
        local thumbUrl = "https://thumbnails.roproxy.com/v1/users/avatar-headshot?userIds=" .. tostring(u.id) .. "&size=150x150&format=Png"
        local tOk, tRes = pcall(function() return HttpService:GetAsync(thumbUrl, true) end)
        if tOk and tRes then
            local tData = HttpService:JSONDecode(tRes)
            if tData.data and tData.data[1] and tData.data[1].imageUrl then
                local img = Instance.new("ImageLabel")
                img.Size = UDim2.new(1, 0, 1, 0)
                img.BackgroundTransparency = 1
                img.Image = tData.data[1].imageUrl
                img.Parent = avatarFrame
                
                local imgCorner = Instance.new("UICorner")
                imgCorner.CornerRadius = UDim.new(1, 0)
                imgCorner.Parent = img
            end
        end
    end)

    local infoLabel = Instance.new("TextLabel")
    infoLabel.Size = UDim2.new(1, -70, 1, 0)
    infoLabel.Position = UDim2.new(0, 70, 0, 0)
    infoLabel.Text = (u.displayName or u.name) .. "\n@" .. u.name
    infoLabel.TextXAlignment = Enum.TextXAlignment.Left
    infoLabel.TextColor3 = Color3.new(1, 1, 1)
    infoLabel.BackgroundTransparency = 1
    infoLabel.Font = Enum.Font.Gotham
    infoLabel.TextSize = 14
    infoLabel.TextWrapped = true
    infoLabel.Parent = searchResult
end

-- ===== SỰ KIỆN =====
openBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
    if mainFrame.Visible then refreshFriendsList() end
end)

closeBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
end)

searchBtn.MouseButton1Click:Connect(function()
    local input = searchBox.Text
    if input:sub(1, 1) == "@" then input = input:sub(2) end
    input = input:gsub("^%s+", ""):gsub("%s+$", "")
    searchUser(input)
end)

searchBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local input = searchBox.Text
        if input:sub(1, 1) == "@" then input = input:sub(2) end
        input = input:gsub("^%s+", ""):gsub("%s+$", "")
        searchUser(input)
    end
end)
