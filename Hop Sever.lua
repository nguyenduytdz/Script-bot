-- ============================================================
-- GUI Menu Bạn Bè + Tìm Kiếm Người Chơi (LocalScript)
-- Đặt trong StarterPlayerScripts hoặc một ScreenGui
-- ============================================================

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local player = Players.LocalPlayer

-- ========== TẠO GUI ==========
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FriendMenuGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Nút mở menu
local openBtn = Instance.new("TextButton")
openBtn.Size = UDim2.new(0, 120, 0, 40)
openBtn.Position = UDim2.new(0, 10, 0, 10)
openBtn.Text = "👥 Bạn Bè"
openBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
openBtn.TextColor3 = Color3.new(1, 1, 1)
openBtn.Parent = screenGui

-- Frame chính
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 400, 0, 500)
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -250)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.Visible = false
mainFrame.Parent = screenGui
mainFrame.Active = true
mainFrame.Draggable = true

-- Tiêu đề
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = "Danh Sách Bạn Bè"
title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
title.TextColor3 = Color3.new(1, 1, 1)
title.Parent = mainFrame

-- Nút đóng
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 5)
closeBtn.Text = "X"
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.Parent = mainFrame

-- Ô tìm kiếm
local searchBox = Instance.new("TextBox")
searchBox.Size = UDim2.new(1, -20, 0, 35)
searchBox.Position = UDim2.new(0, 10, 0, 50)
searchBox.PlaceholderText = "Nhập @username để tìm..."
searchBox.Text = ""
searchBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
searchBox.TextColor3 = Color3.new(1, 1, 1)
searchBox.Parent = mainFrame

-- Nút tìm kiếm
local searchBtn = Instance.new("TextButton")
searchBtn.Size = UDim2.new(1, -20, 0, 35)
searchBtn.Position = UDim2.new(0, 10, 0, 90)
searchBtn.Text = "🔍 Tìm Kiếm"
searchBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
searchBtn.TextColor3 = Color3.new(1, 1, 1)
searchBtn.Parent = mainFrame

-- Khu vực kết quả tìm kiếm
local searchResult = Instance.new("Frame")
searchResult.Size = UDim2.new(1, -20, 0, 80)
searchResult.Position = UDim2.new(0, 10, 0, 135)
searchResult.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
searchResult.Visible = false
searchResult.Parent = mainFrame

-- Danh sách cuộn bạn bè
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, -20, 1, -230)
scrollFrame.Position = UDim2.new(0, 10, 0, 225)
scrollFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
scrollFrame.ScrollBarThickness = 6
scrollFrame.Parent = mainFrame

local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 5)
listLayout.Parent = scrollFrame

-- ========== HÀM TIỆN ÍCH ==========
local function clearChildren(parent, keepLayout)
    for _, child in ipairs(parent:GetChildren()) do
        if child:IsA("GuiObject") then
            child:Destroy()
        end
    end
end

-- ========== LẤY BẠN BÈ TRỰC TUYẾN ==========
local function refreshFriendsList()
    clearChildren(scrollFrame)

    local success, friends = pcall(function()
        return player:GetFriendsOnline()
    end)

    if not success or not friends or #friends == 0 then
        local emptyLabel = Instance.new("TextLabel")
        emptyLabel.Size = UDim2.new(1, 0, 0, 30)
        emptyLabel.Text = "Không có bạn bè trực tuyến"
        emptyLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
        emptyLabel.BackgroundTransparency = 1
        emptyLabel.Parent = scrollFrame
        return
    end

    for _, friendData in ipairs(friends) do
        -- friendData chứa: Id, Username, DisplayName, PlaceId, GameInstanceId, LastLocation...
        local row = Instance.new("Frame")
        row.Size = UDim2.new(1, 0, 0, 50)
        row.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        row.Parent = scrollFrame

        -- Tên hiển thị
        local nameLabel = Instance.new("TextLabel")
        nameLabel.Size = UDim2.new(0.5, 0, 1, 0)
        nameLabel.Position = UDim2.new(0, 10, 0, 0)
        nameLabel.Text = (friendData.DisplayName or friendData.Username) .. " (@" .. friendData.Username .. ")"
        nameLabel.TextXAlignment = Enum.TextXAlignment.Left
        nameLabel.TextColor3 = Color3.new(1, 1, 1)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Parent = row

        -- Nút Join
        local joinBtn = Instance.new("TextButton")
        joinBtn.Size = UDim2.new(0, 80, 0, 35)
        joinBtn.Position = UDim2.new(1, -90, 0.5, -17)
        joinBtn.Text = "Join"
        joinBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
        joinBtn.TextColor3 = Color3.new(1, 1, 1)
        joinBtn.Parent = row

        -- Chỉ hiển thị nút Join khi bạn bè đang ở trong game (có PlaceId)
        local inGame = friendData.PlaceId ~= nil and friendData.PlaceId > 0
        joinBtn.Visible = inGame

        joinBtn.MouseButton1Click:Connect(function()
            if not inGame then return end
            -- Lưu ý: cần GameInstanceId (JobId) để join chính xác
            -- friendData thường không trả về GameInstanceId trực tiếp, cần lấy qua Presence API
            -- Ở đây minh họa: nếu có PlaceId, thử teleport đến place đó (sẽ vào server ngẫu nhiên)
            pcall(function()
                TeleportService:Teleport(friendData.PlaceId, player)
            end)
        end)
    end
end

-- ========== TÌM KIẾM NGƯỜI CHƠI ==========
local function searchUser(username)
    -- Xóa kết quả cũ
    clearChildren(searchResult)
    searchResult.Visible = false

    if username == "" then return end

    -- Sử dụng roproxy để tránh giới hạn domain của HttpService
    local url = "https://users.roproxy.com/v1/usernames/users"
    local body = HttpService:JSONEncode({
        usernames = { username },
        excludeBannedUsers = true
    })

    local success, response = pcall(function()
        return HttpService:PostAsync(url, body, Enum.HttpContentType.ApplicationJson)
    end)

    if not success then
        warn("Lỗi tìm kiếm: " .. tostring(response))
        return
    end

    local data = HttpService:JSONDecode(response)
    if not data.data or #data.data == 0 then
        -- Không tìm thấy
        local notFound = Instance.new("TextLabel")
        notFound.Size = UDim2.new(1, -20, 1, -20)
        notFound.Position = UDim2.new(0, 10, 0, 10)
        notFound.Text = "Không tìm thấy người chơi: @" .. username
        notFound.TextColor3 = Color3.fromRGB(200, 100, 100)
        notFound.BackgroundTransparency = 1
        notFound.Parent = searchResult
        searchResult.Visible = true
        return
    end

    local userInfo = data.data[1]
    local userId = userInfo.id
    local displayName = userInfo.displayName
    local userName = userInfo.name

    -- Hiển thị kết quả
    searchResult.Visible = true

    local avatarFrame = Instance.new("Frame")
    avatarFrame.Size = UDim2.new(0, 60, 0, 60)
    avatarFrame.Position = UDim2.new(0, 10, 0, 10)
    avatarFrame.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    avatarFrame.Parent = searchResult

    -- Tải avatar (sử dụng thumbnail API)
    local thumbUrl = "https://thumbnails.roproxy.com/v1/users/avatar-headshot?userIds=" .. userId .. "&size=150x150&format=Png"
    local thumbSuccess, thumbData = pcall(function()
        return HttpService:GetAsync(thumbUrl)
    end)
    if thumbSuccess then
        local thumbJson = HttpService:JSONDecode(thumbData)
        if thumbJson.data and thumbJson.data[1] and thumbJson.data[1].imageUrl then
            local img = Instance.new("ImageLabel")
            img.Size = UDim2.new(1, 0, 1, 0)
            img.Image = thumbJson.data[1].imageUrl
            img.Parent = avatarFrame
        end
    end

    local infoLabel = Instance.new("TextLabel")
    infoLabel.Size = UDim2.new(0, 200, 0, 60)
    infoLabel.Position = UDim2.new(0, 80, 0, 10)
    infoLabel.Text = displayName .. " (@ " .. userName .. ")"
    infoLabel.TextXAlignment = Enum.TextXAlignment.Left
    infoLabel.TextColor3 = Color3.new(1, 1, 1)
    infoLabel.BackgroundTransparency = 1
    infoLabel.Parent = searchResult

    -- Nút Join (chỉ join nếu người đó đang ở trong game mà bạn có thể join)
    local joinBtn = Instance.new("TextButton")
    joinBtn.Size = UDim2.new(0, 80, 0, 35)
    joinBtn.Position = UDim2.new(1, -90, 0.5, -17)
    joinBtn.Text = "Join"
    joinBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
    joinBtn.TextColor3 = Color3.new(1, 1, 1)
    joinBtn.Parent = searchResult

    -- Kiểm tra trạng thái trực tuyến thông qua Presence API (tùy chọn)
    -- Đơn giản hóa: nhấn join sẽ thử teleport nếu có thể
    joinBtn.MouseButton1Click:Connect(function()
        -- Trong thực tế cần lấy PlaceId và JobId của người đó
        -- Nếu không phải bạn bè, Roblox không cho phép join trực tiếp server của họ
        -- Script này chỉ minh họa giao diện, không thể vượt qua giới hạn quyền riêng tư
        local hint = Instance.new("TextLabel")
        hint.Size = UDim2.new(1, -20, 0, 30)
        hint.Position = UDim2.new(0, 10, 0, 65)
        hint.Text = "Chỉ có thể join server của bạn bè."
        hint.TextColor3 = Color3.fromRGB(255, 200, 100)
        hint.BackgroundTransparency = 1
        hint.Parent = searchResult
        task.delay(3, function() hint:Destroy() end)
    end)
end

-- ========== KẾT NỐI SỰ KIỆN ==========
openBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
    if mainFrame.Visible then
        refreshFriendsList()
    end
end)

closeBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
end)

searchBtn.MouseButton1Click:Connect(function()
    local input = searchBox.Text
    -- Loại bỏ @ nếu người dùng nhập
    if input:sub(1, 1) == "@" then
        input = input:sub(2)
    end
    searchUser(input)
end)

searchBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local input = searchBox.Text
        if input:sub(1, 1) == "@" then
            input = input:sub(2)
        end
        searchUser(input)
    end
end)

-- Làm mới danh sách bạn bè định kỳ
task.spawn(function()
    while true do
        task.wait(30)
        if mainFrame.Visible then
            refreshFriendsList()
        end
    end
end)
