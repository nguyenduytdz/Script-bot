-- ============================================================
-- LocalScript — Đặt trong StarterPlayerScripts
-- ============================================================

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local player = Players.LocalPlayer

-- ===== GUI =====
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FriendMenuGui"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true          -- 🔧 quan trọng: tránh bị topbar che
screenGui.DisplayOrder = 999
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Nút mở (đặt xa topbar)
local openBtn = Instance.new("TextButton")
openBtn.Size = UDim2.new(0, 120, 0, 40)
openBtn.Position = UDim2.new(0, 10, 0, 60)   -- 🔧 hạ xuống dưới topbar
openBtn.Text = "👥 Bạn Bè"
openBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
openBtn.TextColor3 = Color3.new(1, 1, 1)
openBtn.ZIndex = 10
openBtn.Parent = screenGui

-- Frame chính
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 400, 0, 500)
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -250)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.Visible = false
mainFrame.ZIndex = 5
mainFrame.Parent = screenGui
mainFrame.Active = true
mainFrame.Draggable = true

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = "Danh Sách Bạn Bè"
title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
title.TextColor3 = Color3.new(1, 1, 1)
title.ZIndex = 6
title.Parent = mainFrame

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 5)
closeBtn.Text = "X"
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.ZIndex = 7
closeBtn.Parent = mainFrame

local searchBox = Instance.new("TextBox")
searchBox.Size = UDim2.new(1, -20, 0, 35)
searchBox.Position = UDim2.new(0, 10, 0, 50)
searchBox.PlaceholderText = "Nhập @username để tìm..."
searchBox.Text = ""
searchBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
searchBox.TextColor3 = Color3.new(1, 1, 1)
searchBox.ZIndex = 6
searchBox.Parent = mainFrame

local searchBtn = Instance.new("TextButton")
searchBtn.Size = UDim2.new(1, -20, 0, 35)
searchBtn.Position = UDim2.new(0, 10, 0, 90)
searchBtn.Text = "🔍 Tìm Kiếm"
searchBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
searchBtn.TextColor3 = Color3.new(1, 1, 1)
searchBtn.ZIndex = 6
searchBtn.Parent = mainFrame

local searchResult = Instance.new("Frame")
searchResult.Size = UDim2.new(1, -20, 0, 80)
searchResult.Position = UDim2.new(0, 10, 0, 135)
searchResult.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
searchResult.Visible = false
searchResult.ZIndex = 6
searchResult.Parent = mainFrame

local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, -20, 1, -230)
scrollFrame.Position = UDim2.new(0, 10, 0, 225)
scrollFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
scrollFrame.ScrollBarThickness = 6
scrollFrame.ZIndex = 6
scrollFrame.Parent = mainFrame

local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 5)
listLayout.Parent = scrollFrame

-- ===== Helpers =====
local function clearGuiChildren(parent)
    for _, child in ipairs(parent:GetChildren()) do
        if child:IsA("GuiObject") then
            child:Destroy()
        end
    end
end

-- ===== Friends list =====
local function refreshFriendsList()
    clearGuiChildren(scrollFrame)

    local ok, friends = pcall(function()
        return player:GetFriendsOnline()
    end)

    if not ok or not friends or #friends == 0 then
        local emptyLabel = Instance.new("TextLabel")
        emptyLabel.Size = UDim2.new(1, 0, 0, 30)
        emptyLabel.Text = "Không có bạn bè trực tuyến"
        emptyLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
        emptyLabel.BackgroundTransparency = 1
        emptyLabel.Parent = scrollFrame
        return
    end

    for _, friendData in ipairs(friends) do
        local row = Instance.new("Frame")
        row.Size = UDim2.new(1, 0, 0, 50)
        row.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        row.Parent = scrollFrame

        local nameLabel = Instance.new("TextLabel")
        nameLabel.Size = UDim2.new(0.5, 0, 1, 0)
        nameLabel.Position = UDim2.new(0, 10, 0, 0)
        local dn = friendData.DisplayName or friendData.Username or "?"
        local un = friendData.Username or "?"
        nameLabel.Text = dn .. " (@" .. un .. ")"
        nameLabel.TextXAlignment = Enum.TextXAlignment.Left
        nameLabel.TextColor3 = Color3.new(1, 1, 1)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Parent = row

        local joinBtn = Instance.new("TextButton")
        joinBtn.Size = UDim2.new(0, 80, 0, 35)
        joinBtn.Position = UDim2.new(1, -90, 0.5, -17)
        joinBtn.Text = "Join"
        joinBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
        joinBtn.TextColor3 = Color3.new(1, 1, 1)
        joinBtn.Parent = row

        local placeId = friendData.PlaceId
        local inGame = placeId ~= nil and placeId > 0
        joinBtn.Visible = inGame

        joinBtn.MouseButton1Click:Connect(function()
            if not inGame then return end
            pcall(function()
                TeleportService:Teleport(placeId, player)
            end)
        end)
    end
end

-- ===== Search =====
local function searchUser(username)
    clearGuiChildren(searchResult)
    searchResult.Visible = false
    if username == "" then return end

    local url = "https://users.roproxy.com/v1/usernames/users"
    local body = HttpService:JSONEncode({
        usernames = { username },
        excludeBannedUsers = true
    })

    local ok, response = pcall(function()
        return HttpService:PostAsync(url, body, Enum.HttpContentType.ApplicationJson)
    end)

    if not ok then
        warn("Lỗi tìm kiếm: " .. tostring(response))
        return
    end

    local data = HttpService:JSONDecode(response)
    if not data.data or #data.data == 0 then
        local notFound = Instance.new("TextLabel")
        notFound.Size = UDim2.new(1, -20, 1, -20)
        notFound.Position = UDim2.new(0, 10, 0, 10)
        notFound.Text = "Không tìm thấy: @" .. username
        notFound.TextColor3 = Color3.fromRGB(200, 100, 100)
        notFound.BackgroundTransparency = 1
        notFound.Parent = searchResult
        searchResult.Visible = true
        return
    end

    local u = data.data[1]
    searchResult.Visible = true

    local avatarFrame = Instance.new("Frame")
    avatarFrame.Size = UDim2.new(0, 60, 0, 60)
    avatarFrame.Position = UDim2.new(0, 10, 0, 10)
    avatarFrame.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    avatarFrame.Parent = searchResult

    local thumbUrl = "https://thumbnails.roproxy.com/v1/users/avatar-headshot?userIds=" .. tostring(u.id) .. "&size=150x150&format=Png"
    local tOk, tData = pcall(function() return HttpService:GetAsync(thumbUrl) end)
    if tOk then
        local tj = HttpService:JSONDecode(tData)
        if tj.data and tj.data[1] and tj.data[1].imageUrl then
            local img = Instance.new("ImageLabel")
            img.Size = UDim2.new(1, 0, 1, 0)
            img.Image = tj.data[1].imageUrl
            img.Parent = avatarFrame
        end
    end

    local infoLabel = Instance.new("TextLabel")
    infoLabel.Size = UDim2.new(0, 200, 0, 60)
    infoLabel.Position = UDim2.new(0, 80, 0, 10)
    infoLabel.Text = (u.displayName or u.name) .. " (@ " .. u.name .. ")"
    infoLabel.TextXAlignment = Enum.TextXAlignment.Left
    infoLabel.TextColor3 = Color3.new(1, 1, 1)
    infoLabel.BackgroundTransparency = 1
    infoLabel.Parent = searchResult

    local hint = Instance.new("TextLabel")
    hint.Size = UDim2.new(1, -20, 0, 20)
    hint.Position = UDim2.new(0, 10, 0, 60)
    hint.Text = "Chỉ có thể join server của bạn bè."
    hint.TextColor3 = Color3.fromRGB(255, 200, 100)
    hint.BackgroundTransparency = 1
    hint.TextXAlignment = Enum.TextXAlignment.Left
    hint.Parent = searchResult
end

-- ===== Events =====
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
    if input:sub(1, 1) == "@" then input = input:sub(2) end
    searchUser(input)
end)

searchBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local input = searchBox.Text
        if input:sub(1, 1) == "@" then input = input:sub(2) end
        searchUser(input)
    end
end)

-- Refresh định kỳ
task.spawn(function()
    while true do
        task.wait(30)
        if mainFrame.Visible then
            refreshFriendsList()
        end
    end
end)
