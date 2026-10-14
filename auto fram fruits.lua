-- [[ BLOX FRUIT AUTO FARM, STORE, RARITY FILTER & HOP - FLUENT UI ]] --

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Blox Fruits - Auto Fruit & Hop (Rarity Filter)",
    SubTitle = "by AI Assistant",
    TabWidth = 160,
    Size = UDim2.fromOffset(550, 380),
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.RightControl
})

local Tabs = {
    Main = Window:AddTab({ Title = "Trang Chính", Icon = "home" })
}

getgenv().AutoHopFruit = getgenv().AutoHopFruit or false
getgenv().FruitFilter = getgenv().FruitFilter or "Tất cả"

-- Danh sách phân loại độ hiếm trái ác quỷ trong Blox Fruits
local MythicalFruits = {
    "Kitsune", "Leopard", "Dragon", "T-Rex", "Dough", "Spirit", 
    "Control", "Venom", "Shadow", "Mammoth", "Gas", "Yeti"
}

local LegendaryFruits = {
    "Buddha", "Portal", "Rumble", "Blizzard", "Phoenix", 
    "Sound", "Quake", "Pain", "Gravity", "Spider"
}

-- Hàm kiểm tra độ hiếm của trái tìm được
local function IsAllowedFruit(fruitName)
    local filter = getgenv().FruitFilter
    
    if filter == "Tất cả" then
        return true
    elseif filter == "Chỉ Mythical" then
        for _, m in ipairs(MythicalFruits) do
            if string.find(fruitName, m) then return true end
        end
    elseif filter == "Mythical & Legendary" then
        for _, m in ipairs(MythicalFruits) do
            if string.find(fruitName, m) then return true end
        end
        for _, l in ipairs(LegendaryFruits) do
            if string.find(fruitName, l) then return true end
        end
    end
    return false
end

-- Hàm tìm Trái Ác Quỷ có lọc theo Rarity
local function GetFruit()
    for _, v in pairs(workspace:GetDescendants()) do
        if (v:IsA("Tool") or v:IsA("Model")) and (string.find(v.Name, "Fruit") or v.Name == "Fruit ") then
            local playerParent = game.Players:GetPlayerFromCharacter(v.Parent)
            local humanoidParent = v.Parent and v.Parent:FindFirstChildOfClass("Humanoid")
            
            if not playerParent and not humanoidParent then
                if IsAllowedFruit(v.Name) then
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

-- Hàm cất trái vào kho
local function AutoStoreFruits()
    local player = game.Players.LocalPlayer
    local remote = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes") and game:GetService("ReplicatedStorage").Remotes:FindFirstChild("CommF_")
    if not remote then return false end
    
    local storedSuccessfully = false
    local function checkAndStore(container)
        if not container then return end
        for _, item in pairs(container:GetChildren()) do
            if item:IsA("Tool") and (string.find(item.Name, "Fruit") or item.Name == "Fruit ") then
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

-- Hàm Chuyển Server & Giữ trạng thái
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

-- Vòng lặp chính
task.spawn(function()
    while task.wait(1) do
        if getgenv().AutoHopFruit then
            local player = game.Players.LocalPlayer
            local character = player.Character or player.CharacterAdded:Wait()
            local hrp = character:WaitForChild("HumanoidRootPart", 5)
            
            local fruit = GetFruit()
            
            if fruit and hrp then
                local targetPart = fruit:IsA("Tool") and fruit:FindFirstChild("Handle") or (fruit:IsA("Model") and (fruit:FindFirstChild("Handle"] or fruit.PrimaryPart or fruit:FindFirstChildOfClass("BasePart")))
                
                if targetPart then
                    hrp.CFrame = targetPart.CFrame + Vector3.new(0, 3, 0)
                end
                
                task.wait(2) -- Đợi nhặt trái vào Balo
                
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
                -- Không tìm thấy trái thỏa mãn điều kiện lọc -> Chuyển Server
                ServerHop()
                task.wait(8)
            end
        end
    end
end)

-- --- TẠO GIAO DIỆN MENU ---

-- 1. Dropdown Lọc Độ Hiếm
Tabs.Main:AddDropdown("RarityFilter", {
    Title = "Lọc Độ Hiếm Trái Ác Quỷ",
    Values = {"Tất cả", "Mythical & Legendary", "Chỉ Mythical"},
    Default = getgenv().FruitFilter,
    Callback = function(Value)
        getgenv().FruitFilter = Value
        Fluent:Notify({ Title = "Cài đặt", Content = "Đã đổi bộ lọc thành: " .. Value, Duration = 2 })
    end
})

-- 2. Toggle Bật/Tắt Auto
local Toggle = Tabs.Main:AddToggle("AutoFruitHop", { Title = "Auto Nhặt Trái Theo Bộ Lọc & Hop Server", Default = getgenv().AutoHopFruit })

Toggle:OnChanged(function(Value)
    getgenv().AutoHopFruit = Value
    if Value then
        Fluent:Notify({ Title = "Blox Fruits", Content = "Đã BẬT! Đang lọc theo: " .. getgenv().FruitFilter, Duration = 3 })
    else
        Fluent:Notify({ Title = "Blox Fruits", Content = "Đã TẮT!", Duration = 3 })
    end
end)

-- 3. Nút Hop Thủ Công
Tabs.Main:AddButton({
    Title = "Hop Server Ngay",
    Callback = function()
        ServerHop()
    end
})

Window:SelectTab(1)
    
