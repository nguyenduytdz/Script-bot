-- [[ BLOX FRUIT SMART HOP & AUTO FARM (FIXED HOP LOGIC) ]] --

local SuccessUI, Fluent = pcall(function()
    return loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
end)

local Window
if SuccessUI and Fluent then
    Window = Fluent:CreateWindow({
        Title = "Blox Fruits - Smart Hop Fruit",
        SubTitle = "Fast & Smart Server Search",
        TabWidth = 160,
        Size = UDim2.fromOffset(550, 380),
        Theme = "Dark",
        MinimizeKey = Enum.KeyCode.RightControl
    })
end

local Tabs = {}
if Window then
    Tabs.Main = Window:AddTab({ Title = "Trang Chính", Icon = "home" })
end

getgenv().AutoHopFruit = getgenv().AutoHopFruit or false

-- Lưu danh sách các Server đã từng vào để KHÔNG BỊ VÀO LẠI
getgenv().VisitedServers = getgenv().VisitedServers or {}
table.insert(getgenv().VisitedServers, game.JobId)

-- Danh sách trái rác bị BỎ QUA
local CommonBlacklist = { "Rocket", "Spin", "Chop", "Spring", "Bomb", "Smoke", "Spike" }

local function IsCommonFruit(fruitName)
    for _, name in ipairs(CommonBlacklist) do
        if fruitName == name or string.find(fruitName, name) then
            return true
        end
    end
    return false
end

local HasLoadedServer = false

-- Hàm tìm Trái Ác Quỷ (Bỏ trái rác)
local function GetFruit()
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Tool") and v:FindFirstChild("Handle") then
            local parent = v.Parent
            local isPlayerChar = game.Players:GetPlayerFromCharacter(parent)
            local isBackpack = parent and parent:IsA("Backpack")
            
            if not isPlayerChar and not isBackpack then
                if not IsCommonFruit(v.Name) then
                    return v
                end
            end
        end
    end
    return nil
end

-- Hàm cất trái vào kho
local function AutoStoreFruits()
    local player = game.Players.LocalPlayer
    local remote = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes") and game:GetService("ReplicatedStorage").Remotes:FindFirstChild("CommF_")
    if not remote then return false end
    
    local storedSuccessfully = false
    local function checkAndStore(container)
        if not container then return end
        for _, item in pairs(container:GetChildren()) do
            if item:IsA("Tool") and item:FindFirstChild("Handle") then
                pcall(function()
                    remote:InvokeServer("StoreFruit", item)
                end)
                storedSuccessfully = true
                task.wait(0.5)
            end
        end
    end
    
    checkAndStore(player:FindFirstChild("Backpack"))
    checkAndStore(player.Character)
    return storedSuccessfully
end

-- Hàm Smart Hop Server (Tìm Server Ngẫu Nhiên + Chưa Vào Bao Giờ + Số Người Vừa Phải)
local function SmartServerHop()
    local TeleportService = game:GetService("TeleportService")
    local HttpService = game:GetService("HttpService")
    local PlaceId = game.PlaceId
    
    -- Lưu script chạy lại khi sang server mới
    local queuetype = queue_on_teleport or (syn and syn.queue_on_teleport)
    if queuetype and getgenv().AutoHopFruit then
        local visitedStr = "{"
        for _, id in ipairs(getgenv().VisitedServers) do
            visitedStr = visitedStr .. '"' .. id .. '",'
        end
        visitedStr = visitedStr .. "}"
        
        queuetype([[
            getgenv().AutoHopFruit = true
            getgenv().VisitedServers = ]] .. visitedStr .. [[
            repeat task.wait() until game:IsLoaded()
            loadstring(game:HttpGet("ĐƯỜNG_LINK_SCRIPT_CỦA_BẠN"))()
        ]])
    end

    -- Tìm danh sách server
    local cursor = ""
    local foundServer = false
    
    for page = 1, 3 do -- Duyệt qua 3 trang danh sách server để tìm server mới
        local url = "https://games.roblox.com/v1/games/" .. PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
        if cursor ~= "" then url = url .. "&cursor=" .. cursor end
        
        local success, response = pcall(function()
            return HttpService:JSONDecode(game:HttpGet(url))
        end)
        
        if success and response and response.data then
            cursor = response.nextPageCursor or ""
            
            -- Xáo trộn danh sách server để chọn ngẫu nhiên, không bị vào trùng
            local servers = response.data
            for i = #servers, 2, -1 do
                local j = math.random(i)
                servers[i], servers[j] = servers[j], servers[i]
            end
            
            for _, s in pairs(servers) do
                -- Điều kiện: Không phải server hiện tại, chưa từng vào, và server còn chỗ
                local isVisited = false
                for _, visitedId in ipairs(getgenv().VisitedServers) do
                    if s.id == visitedId then isVisited = true break end
                end
                
                if not isVisited and s.playing < s.maxPlayers and s.id ~= game.JobId then
                    table.insert(getgenv().VisitedServers, s.id)
                    foundServer = true
                    TeleportService:TeleportToPlaceInstance(PlaceId, s.id, game.Players.LocalPlayer)
                    break
                end
            end
        end
        
        if foundServer or cursor == "" then break end
    end
end

-- Chờ 3 giây load map khi vừa đổi server
task.spawn(function()
    repeat task.wait() until game:IsLoaded()
    task.wait(3)
    HasLoadedServer = true
end)

-- Vòng lặp chính
task.spawn(function()
    while task.wait(1) do
        if getgenv().AutoHopFruit then
            if not HasLoadedServer then continue end
            
            local player = game.Players.LocalPlayer
            local character = player.Character or player.CharacterAdded:Wait()
            local hrp = character:WaitForChild("HumanoidRootPart", 5)
            
            local fruit = GetFruit()
            
            if fruit and hrp and fruit:FindFirstChild("Handle") then
                local handle = fruit.Handle
                
                -- Phát hiện trái xịn -> Bay tới nhặt ngay
                hrp.CFrame = handle.CFrame + Vector3.new(0, 3, 0)
                task.wait(0.5)
                
                pcall(function()
                    firetouchinterest(hrp, handle, 0)
                    firetouchinterest(hrp, handle, 1)
                end)
                
                task.wait(2)
                
                -- Cất vào kho
                local stored = false
                local attempts = 0
                repeat
                    stored = AutoStoreFruits()
                    attempts = attempts + 1
                    task.wait(0.5)
                until stored or attempts > 5
                
                -- Cất xong -> Nhảy tiếp server mới
                task.wait(1)
                HasLoadedServer = false
                SmartServerHop()
                task.wait(10)
            else
                -- Không có trái xịn -> Lập tức Smart Hop sang server khác chỉ sau 2 giây
                task.wait(2)
                HasLoadedServer = false
                SmartServerHop()
                task.wait(8)
            end
        end
    end
end)

-- Giao diện Menu
if Window and Tabs.Main then
    local Toggle = Tabs.Main:AddToggle("AutoFruitHop", { Title = "Auto Smart Hop & Nhặt Trái Xịn", Default = getgenv().AutoHopFruit })
    Toggle:OnChanged(function(Value)
        getgenv().AutoHopFruit = Value
        if Value then
            Fluent:Notify({ Title = "Blox Fruits", Content = "Bắt đầu Smart Hop tìm server có trái...", Duration = 3 })
        else
            Fluent:Notify({ Title = "Blox Fruits", Content = "Đã TẮT!", Duration = 3 })
        end
    end)

    Tabs.Main:AddButton({
        Title = "Smart Hop Ngay (Đổi Server Ngẫu Nhiên)",
        Callback = function()
            SmartServerHop()
        end
    })

    Window:SelectTab(1)
end
