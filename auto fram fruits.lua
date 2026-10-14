-- [[ BLOX FRUIT AUTO FARM & HOP (ULTIMATE FIXED VERSION) ]] --

-- Bảo vệ load UI tránh lỗi chết script nếu mất kết nối
local SuccessUI, Fluent = pcall(function()
    return loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
end)

local Window
if SuccessUI and Fluent then
    Window = Fluent:CreateWindow({
        Title = "Blox Fruits - Auto Fruit & Hop",
        SubTitle = "Fixed Version",
        TabWidth = 160,
        Size = UDim2.fromOffset(550, 380),
        Theme = "Dark",
        MinimizeKey = Enum.KeyCode.RightControl -- Nhấn Right Ctrl để ẩn/hiện menu
    })
end

local Tabs = {}
if Window then
    Tabs.Main = Window:AddTab({ Title = "Trang Chính", Icon = "home" })
end

getgenv().AutoHopFruit = getgenv().AutoHopFruit or false
getgenv().FruitFilter = getgenv().FruitFilter or "Tất cả"

-- Danh sách toàn bộ tên Trái Ác Quỷ chuẩn trong Blox Fruits
local AllFruits = {
    "Rocket", "Spin", "Blade", "Spring", "Bomb", "Smoke", "Spike",
    "Flame", "Falcon", "Ice", "Sand", "Dark", "Diamond", "Light",
    "Rubber", "Barrier", "Ghost", "Magma", "Quake", "Buddha",
    "Love", "Spider", "Sound", "Phoenix", "Portal", "Rumble", "Pain", "Gravity",
    "Blizzard", "Mammoth", "T-Rex", "Dough", "Shadow", "Venom", "Control", "Spirit", "Leopard", "Kitsune", "Gas", "Yeti", "Dragon"
}

local MythicalFruits = {
    "Kitsune", "Leopard", "Dragon", "T-Rex", "Dough", "Spirit", 
    "Control", "Venom", "Shadow", "Mammoth", "Gas", "Yeti"
}

local LegendaryFruits = {
    "Buddha", "Portal", "Rumble", "Blizzard", "Phoenix", 
    "Sound", "Quake", "Pain", "Gravity", "Spider"
}

-- Kiểm tra xem tên vật thể có khớp với tên Trái Ác Quỷ thật không
local function IsValidFruitName(name)
    for _, fruit in ipairs(AllFruits) do
        if name == fruit or string.find(name, fruit) then
            return true
        end
    end
    return false
end

-- Bộ lọc độ hiếm
local function IsAllowedByFilter(name)
    local filter = getgenv().FruitFilter
    if filter == "Tất cả" then
        return true
    elseif filter == "Chỉ Mythical" then
        for _, m in ipairs(MythicalFruits) do
            if name == m or string.find(name, m) then return true end
        end
    elseif filter == "Mythical & Legendary" then
        for _, m in ipairs(MythicalFruits) do
            if name == m or string.find(name, m) then return true end
        end
        for _, l in ipairs(LegendaryFruits) do
            if name == l or string.find(name, l) then return true end
        end
    end
    return false
end

-- Hàm tìm Trái Ác Quỷ chính xác trong Map
local function GetFruit()
    for _, v in pairs(workspace:GetDescendants()) do
        if (v:IsA("Tool") or v:IsA("Model")) and IsValidFruitName(v.Name) then
            -- Tránh lấy nhầm trái đang ở trong balo/trên tay người chơi khác
            local playerParent = game.Players:GetPlayerFromCharacter(v.Parent)
            local humanoidParent = v.Parent and v.Parent:FindFirstChildOfClass("Humanoid")
            
            if not playerParent and not humanoidParent then
                if IsAllowedByFilter(v.Name) then
                    if v:IsA("Tool") and v:FindFirstChild("Handle") then
                        return v
                    elseif v:IsA("Model") then
                        local part = v:FindFirstChild("Handle") or v.PrimaryPart or v:FindFirstChildOfClass("BasePart")
                        if part then return v end
                    end
                end
            end
        end
    end
    return nil
end

-- Hàm cất trái vào kho (Storage)
local function AutoStoreFruits()
    local player = game.Players.LocalPlayer
    local remote = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes") and game:GetService("ReplicatedStorage").Remotes:FindFirstChild("CommF_")
    if not remote then return false end
    
    local storedSuccessfully = false
    local function checkAndStore(container)
        if not container then return end
        for _, item in pairs(container:GetChildren()) do
            if item:IsA("Tool") and IsValidFruitName(item.Name) then
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

-- Hàm chuyển Server thông minh
local function ServerHop()
    local TeleportService = game:GetService("TeleportService")
    local HttpService = game:GetService("HttpService")
    local PlaceId = game.PlaceId
    
    local queuetype = queue_on_teleport or (syn and syn.queue_on_teleport)
    if queuetype and getgenv().AutoHopFruit then
        queuetype([[
            getgenv().AutoHopFruit = true
            getgenv().FruitFilter = "]] .. getgenv().FruitFilter .. [["
            repeat task.wait() until game:IsLoaded()
            loadstring(game:HttpGet("ĐƯỜNG_LINK_SCRIPT_CỦA_BẠN"))()
        ]])
    end
    
    local success, Servers = pcall(function()
        return HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"))
    end)
    
    if success and Servers and Servers.data then
        for _, s in pairs(Servers.data) do
            if s.playing ~= s.maxPlayers and s.id ~= game.JobId then
                TeleportService:TeleportToPlaceInstance(PlaceId, s.id, game.Players.LocalPlayer)
                break
            end
        end
    end
end

-- Vòng lặp xử lý chính
task.spawn(function()
    while task.wait(1) do
        if getgenv().AutoHopFruit then
            local player = game.Players.LocalPlayer
            local character = player.Character or player.CharacterAdded:Wait()
            local hrp = character:WaitForChild("HumanoidRootPart", 5)
            
            local fruit = GetFruit()
            
            if fruit and hrp then
                local targetPart = fruit:IsA("Tool") and fruit:FindFirstChild("Handle") or (fruit:IsA("Model") and (fruit:FindFirstChild("Handle") or fruit.PrimaryPart or fruit:FindFirstChildOfClass("BasePart")))
                
                if targetPart then
                    hrp.CFrame = targetPart.CFrame + Vector3.new(0, 3, 0) -- Bay đến vị trí trái
                end
                
                task.wait(2) -- Chờ để nhặt vào balo
                
                -- Cất vào kho
                local stored = false
                local attempts = 0
                repeat
                    stored = AutoStoreFruits()
                    attempts = attempts + 1
                    task.wait(0.5)
                until stored or attempts > 5
                
                task.wait(1)
                ServerHop()
                task.wait(10)
            else
                -- Chờ 3 giây ở server mới để map load dữ liệu xong rồi mới tìm trái / hop tiếp
                task.wait(3)
                ServerHop()
                task.wait(8)
            end
        end
    end
end)

-- Tạo giao diện menu nếu load thành công
if Window and Tabs.Main then
    Tabs.Main:AddDropdown("RarityFilter", {
        Title = "Lọc Độ Hiếm Trái Ác Quỷ",
        Values = {"Tất cả", "Mythical & Legendary", "Chỉ Mythical"},
        Default = getgenv().FruitFilter,
        Callback = function(Value)
            getgenv().FruitFilter = Value
        end
    })

    local Toggle = Tabs.Main:AddToggle("AutoFruitHop", { Title = "Auto Nhặt Trái & Hop Server", Default = getgenv().AutoHopFruit })
    Toggle:OnChanged(function(Value)
        getgenv().AutoHopFruit = Value
    end)

    Tabs.Main:AddButton({
        Title = "Hop Server Ngay",
        Callback = function()
            ServerHop()
        end
    })

    Window:SelectTab(1)
end
                
