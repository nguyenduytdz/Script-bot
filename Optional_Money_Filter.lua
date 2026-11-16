-- ============================================================
-- ReplicatedStorage/FriendMenu  (Script — KHÔNG phải LocalScript)
-- Đặt RunContext = "Client" trong Properties
-- Gộp cả server logic (HTTP) và client logic (GUI) vào 1 file
-- ============================================================

local RunService      = game:GetService("RunService")
local Players         = game:GetService("Players")
local HttpService     = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local IS_SERVER = RunService:IsServer()
local IS_CLIENT = RunService:IsClient()

-- ============================================================
-- PHẦN SERVER: xử lý HTTP (chỉ server chạy được khi publish)
-- ============================================================
if IS_SERVER then
    local remote = ReplicatedStorage:FindFirstChild("SearchUser")
    if not remote then
        remote = Instance.new("RemoteFunction")
        remote.Name = "SearchUser"
        remote.Parent = ReplicatedStorage
    end

    local avatarRemote = ReplicatedStorage:FindFirstChild("GetAvatar")
    if not avatarRemote then
        avatarRemote = Instance.new("RemoteFunction")
        avatarRemote.Name = "GetAvatar"
        avatarRemote.Parent = ReplicatedStorage
    end

    local ENDPOINTS = {
        "https://users.roproxy.com/v1/users/search?keyword=%s&limit=10",
        "https://users.rprxy.xyz/v1/users/search?keyword=%s&limit=10",
    }

    remote.OnServerInvoke = function(player, username)
        if type(username) ~= "string" or #username == 0 then return nil end
        local now = os.clock()
        local last = player:GetAttribute("LastSearch") or 0
        if now - last < 1 then return { error = "rate_limit" } end
        player:SetAttribute("LastSearch", now)

        local encoded = HttpService:UrlEncode(username)
        for _, pattern in ipairs(ENDPOINTS) do
            local ok, res = pcall(function()
                return HttpService:GetAsync(string.format(pattern, encoded), true)
            end)
            if ok and res then
                local okJ, data = pcall(function() return HttpService:JSONDecode(res) end)
                if okJ and data and data.data then return data.data end
            end
        end
        return nil
    end

    avatarRemote.OnServerInvoke = function(player, userId)
        if type(userId) ~= "number" then return nil end
        local url = "https://thumbnails.roproxy.com/v1/users/avatar-headshot?userIds="
            .. tostring(userId) .. "&size=150x150&format=Png"
        local ok, res = pcall(function() return HttpService:GetAsync(url, true) end)
        if not ok or not res then return nil end
        local okJ, data = pcall(function() return HttpService:JSONDecode(res) end)
        if not okJ or not data or not data.data or not data.data[1] then return nil end
        return data.data[1].imageUrl
    end

    print("[FriendMenu] Server part ready.")
    return  -- Server không chạy phần GUI bên dưới
end

-- ============================================================
-- PHẦN CLIENT: GUI + tìm kiếm + join
-- ============================================================
if not IS_CLIENT then return end

local player = Players.LocalPlayer
local USE_LOCAL_HTTP = false  -- true nếu test Studio; false khi publish

local searchRemote = ReplicatedStorage:WaitForChild("SearchUser", 5)
local avatarRemote = ReplicatedStorage:WaitForChild("GetAvatar", 5)

-- ===== GUI =====
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FriendMenuGui"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.DisplayOrder = 999
screenGui.Parent = player:WaitForChild("PlayerGui")

local openBtn = Instance.new("TextButton")
openBtn.Size = UDim2.new(0, 130, 0, 40)
openBtn.Position = UDim2.new(0, 10, 0, 60)
openBtn.Text = "👥 Bạn Bè"
openBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
openBtn.TextColor3 = Color3.new(1, 1, 1)
openBtn.Font = Enum.Font.GothamBold
openBtn.ZIndex = 10
openBtn.Parent = screenGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 420, 0, 520)
mainFrame.Position = UDim2.new(0.5, -210, 0.5, -260)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.Visible = false
mainFrame.ZIndex = 5
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = "Danh Sách Bạn Bè"
title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.ZIndex = 6
title.Parent = mainFrame

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 5)
closeBtn.Text = "X"
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.ZIndex = 7
closeBtn.Parent = mainFrame

local searchBox = Instance.new("TextBox")
searchBox.Size = UDim2.new(1, -20, 0, 35)
searchBox.Position = UDim2.new(0, 10, 0, 50)
searchBox.PlaceholderText = "Nhập @username để tìm..."
searchBox.Text = ""
searchBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
searchBox.TextColor3 = Color3.new(1, 1, 1)
searchBox.Font = Enum.Font.Gotham
searchBox.ZIndex = 6
searchBox.Parent = mainFrame

local searchBtn = Instance.new("TextButton")
searchBtn.Size = UDim2.new(1, -20, 0, 35)
searchBtn.Position = UDim2.new(0, 10, 0, 90)
searchBtn.Text = "🔍 Tìm Kiếm"
searchBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
searchBtn.TextColor3 = Color3.new(1, 1, 1)
searchBtn.Font = Enum.Font.GothamBold
searchBtn.ZIndex = 6
searchBtn.Parent = mainFrame

local searchResult = Instance.new("Frame")
searchResult.Size = UDim2.new(1, -20, 0, 90)
searchResult.Position = UDim2.new(0, 10, 0, 135)
searchResult.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
searchResult.Visible = false
searchResult.ZIndex = 6
searchResult.Parent = mainFrame

local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, -20, 1, -240)
scrollFrame.Position = UDim2.new(0, 10, 0, 235)
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
        if child:IsA("GuiObject") then child:Destroy() end
    end
end

local function showMessage(parent, text, color)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -20, 0, 30)
    lbl.Position = UDim2.new(0, 10, 0, 10)
    lbl.Text = text
    lbl.TextColor3 = color or Color3.fromRGB(200, 200, 200)
    lbl.BackgroundTransparency = 1
    lbl.TextWrapped = true
    lbl.Font = Enum.Font.Gotham
    lbl.Parent = parent
    return lbl
end

local function fetchUsers(username)
    if USE_LOCAL_HTTP and HttpService.HttpEnabled then
        local endpoints = {
            "https://users.roproxy.com/v1/users/search?keyword=" .. HttpService:UrlEncode(username) .. "&limit=10",
            "https://users.rprxy.xyz/v1/users/search?keyword=" .. HttpService:UrlEncode(username) .. "&limit=10",
        }
        for _, url in ipairs(endpoints) do
            local ok, res = pcall(function() return HttpService:GetAsync(url, true) end)
            if ok and res then
                local okJ, data = pcall(function() return HttpService:JSONDecode(res) end)
                if okJ and data and data.data then return data.data end
            end
        end
        return nil
    end
    if searchRemote then
        local ok, result = pcall(function() return searchRemote:InvokeServer(username) end)
        if ok and type(result) == "table" then
            if result.error then return nil, result.error end
            return result
        end
    end
    return nil
end

local function fetchAvatar(userId)
    if USE_LOCAL_HTTP and HttpService.HttpEnabled then
        local url = "https://thumbnails.roproxy.com/v1/users/avatar-headshot?userIds="
            .. tostring(userId) .. "&size=150x150&format=Png"
        local ok, res = pcall(function() return HttpService:GetAsync(url, true) end)
        if ok and res then
            local okJ, data = pcall(function() return HttpService:JSONDecode(res) end)
            if okJ and data and data.data and data.data[1] then return data.data[1].imageUrl end
        end
        return nil
    end
    if avatarRemote then
        local ok, url = pcall(function() return avatarRemote:InvokeServer(userId) end)
        if ok then return url end
    end
    return nil
end

-- ===== Friends =====
local function refreshFriendsList()
    clearGuiChildren(scrollFrame)
    local ok, friends = pcall(function() return player:GetFriendsOnline() end)
    if not ok or not friends or #friends == 0 then
        showMessage(scrollFrame, "Không có bạn bè trực tuyến", Color3.fromRGB(150, 150, 150))
        return
    end
    for _, friendData in ipairs(friends) do
        local row = Instance.new("Frame")
        row.Size = UDim2.new(1, 0, 0, 50)
        row.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        row.Parent = scrollFrame

        local dn = friendData.DisplayName or friendData.Username or "?"
        local un = friendData.Username or "?"

        local nameLabel = Instance.new("TextLabel")
        nameLabel.Size = UDim2.new(1, -110, 1, 0)
        nameLabel.Position = UDim2.new(0, 10, 0, 0)
        nameLabel.Text = dn .. " (@" .. un .. ")"
        nameLabel.TextXAlignment = Enum.TextXAlignment.Left
        nameLabel.TextColor3 = Color3.new(1, 1, 1)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Font = Enum.Font.Gotham
        nameLabel.TextTruncate = Enum.TextTruncate.AtEnd
        nameLabel.Parent = row

        local joinBtn = Instance.new("TextButton")
        joinBtn.Size = UDim2.new(0, 80, 0, 35)
        joinBtn.Position = UDim2.new(1, -90, 0.5, -17)
        joinBtn.Text = "Join"
        joinBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
        joinBtn.TextColor3 = Color3.new(1, 1, 1)
        joinBtn.Font = Enum.Font.GothamBold
        joinBtn.Parent = row

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
                warn("Join fail: " .. tostring(err))
                joinBtn.Text = "Lỗi"
                task.wait(2)
                joinBtn.Text = "Join"
                joinBtn.Active = true
            end
        end)
    end
end

-- ===== Search =====
local function searchUser(username)
    print("[SEARCH] Gọi searchUser với:", username)
    clearGuiChildren(searchResult)
    searchResult.Visible = false
    if username == "" then
        searchResult.Visible = true
        showMessage(searchResult, "Vui lòng nhập @username", Color3.fromRGB(255, 200, 100))
        return
    end
    searchResult.Visible = true
    local loadingLbl = showMessage(searchResult, "Đang tìm...", Color3.fromRGB(180, 180, 180))

    local results, errType = fetchUsers(username)
    loadingLbl:Destroy()

    if not results then
        local msg = "Không tìm thấy: @" .. username
        if errType == "rate_limit" then
            msg = "Chờ 1 giây rồi thử lại."
        elseif not USE_LOCAL_HTTP and not searchRemote then
            msg = "Thiếu SearchServer (xem hướng dẫn)."
        end
        showMessage(searchResult, msg, Color3.fromRGB(200, 100, 100))
        return
    end

    local exact
    for _, u in ipairs(results) do
        if string.lower(u.name) == string.lower(username) then
            exact = u
            break
        end
    end
    local u = exact or results[1]

    local avatarFrame = Instance.new("Frame")
    avatarFrame.Size = UDim2.new(0, 60, 0, 60)
    avatarFrame.Position = UDim2.new(0, 10, 0, 15)
    avatarFrame.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    avatarFrame.Parent = searchResult

    task.spawn(function()
        local imgUrl = fetchAvatar(u.id)
        if imgUrl then
            local img = Instance.new("ImageLabel")
            img.Size = UDim2.new(1, 0, 1, 0)
            img.BackgroundTransparency = 1
            img.Image = imgUrl
            img.Parent = avatarFrame
        end
    end)

    local infoLabel = Instance.new("TextLabel")
    infoLabel.Size = UDim2.new(0, 300, 0, 40)
    infoLabel.Position = UDim2.new(0, 80, 0, 15)
    infoLabel.Text = (u.displayName or u.name) .. "\n@ " .. u.name
    infoLabel.TextXAlignment = Enum.TextXAlignment.Left
    infoLabel.TextYAlignment = Enum.TextYAlignment.Top
    infoLabel.TextColor3 = Color3.new(1, 1, 1)
    infoLabel.BackgroundTransparency = 1
    infoLabel.Font = Enum.Font.Gotham
    infoLabel.TextWrapped = true
    infoLabel.Parent = searchResult

    local hint = Instance.new("TextLabel")
    hint.Size = UDim2.new(1, -20, 0, 20)
    hint.Position = UDim2.new(0, 10, 0, 65)
    hint.Text = "Chỉ có thể join server của bạn bè."
    hint.TextColor3 = Color3.fromRGB(255, 200, 100)
    hint.BackgroundTransparency = 1
    hint.TextXAlignment = Enum.TextXAlignment.Left
    hint.Font = Enum.Font.Gotham
    hint.Parent = searchResult
end

-- ===== Events =====
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

task.spawn(function()
    while true do
        task.wait(30)
        if mainFrame.Visible then refreshFriendsList() end
    end
end)

print("[FriendMenu] Client part ready. USE_LOCAL_HTTP =", USE_LOCAL_HTTP,
    "| HttpEnabled =", HttpService.HttpEnabled,
    "| searchRemote =", searchRemote ~= nil)
