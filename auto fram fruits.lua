-- [[ BLOX FRUIT AUTO FARM, STORE, FILTER & PERSISTENT HOP MENU ]] --

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Blox Fruits - Auto Hop & Filter Fruit", "DarkTheme")

-- Biến toàn cục lưu trạng thái qua các Server
getgenv().AutoHopFruit = getgenv().AutoHopFruit or false
getgenv().SelectedFilter = getgenv().SelectedFilter or "Mythical & Legendary" -- Mặc định chỉ nhặt trái xịn

local MainTab = Window:NewTab("Main Menu")
local MainSection = MainTab:NewSection("Auto Farm Fruit & Filter")

-- Danh sách phân loại độ hiếm các trái trong Blox Fruits
local Rarities = {
    Mythical = {"Kitsune", "Dragon", "Leopard", "T-Rex", "Spirit", "Control", "Venom", "Shadow", "Dough", "Mammoth", "Gas", "Tiger", "Yeti", "Gravity"},
    Legendary = {"Portal", "Lightning", "Pain", "Blizzard", "Buddha", "Quake", "Love", "Creation", "Spider", "Sound", "Phoenix"},
    Rare = {"Light", "Rubber", "Ghost", "Magma"},
    Uncommon = {"Flame", "Ice", "Sand", "Dark", "Eagle", "Diamond"},
    Common = {"Rocket", "Spin", "Blade", "Spring", "Bomb", "Smoke", "Spike"}
}

-- Hàm kiểm tra độ hiếm của trái
local function GetFruitRarity(fruitName)
    for _, name in ipairs(Rarities.Mythical) do
        if string.find(fruitName, name) then return "Mythical" end
    end
    for _, name in ipairs(Rarities.Legendary) do
        if string.find(fruitName, name) then return "Legendary" end
    end
    for _, name in ipairs(Rarities.Rare) do
        if string.find(fruitName, name) then return "Rare" end
    end
    for _, name in ipairs(Rarities.Uncommon) do
        if string.find(fruitName, name) then return "Uncommon" end
    end
    for _, name in ipairs(Rarities.Common) do
        if string.find(fruitName, name) then return "Common" end
    end
    return "Unknown"
end

-- Hàm kiểm tra xem trái có thỏa mãn bộ lọc không
local function ShouldPickFruit(fruitName)
    local rarity = GetFruitRarity(fruitName)
    local filter = getgenv().SelectedFilter
    
    if filter == "Mythical & Legendary" then
        return rarity == "Mythical" or rarity == "Legendary"
    elseif filter == "Từ Rare trở lên" then
        return rarity == "Mythical" or rarity == "Legendary" or rarity == "Rare"
    elseif filter == "Tất cả các loại" then
        return true
    end
    return true
end

-- Hàm tìm Trái Ác Quỷ trong Workspace thỏa mãn bộ lọc
local function GetFruit()
    for _, v in pairs(workspace:GetDescendants()) do
        if (v:IsA("Tool") or v:IsA("Model")) and (string.find(v.Name, "Fruit") or v.Name == "Fruit ") then
            local playerParent = game.Players:GetPlayerFromCharacter(v.Parent)
            local humanoidParent = v.Parent and v.Parent:FindFirstChildOfClass("Humanoid")
            
            -- Đảm bảo không lấy nhầm trái của người chơi khác
            if not playerParent and not humanoidParent then
                if ShouldPickFruit(v.Name) then
                    if v:IsA("Tool") and v:FindFirstChild("Handle") then
                        return v
                    elseif v:IsA("Model") then
                        local part = v:FindFirstChild("Handle") or v.PrimaryPart or v:FindFirstChildOfClass("BasePart")
                        if part then
                            return v
                        end
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

-- Hàm Server Hop kèm duy trì trạng thái qua server mới
local function ServerHop()
    local TeleportService = game:GetService("TeleportService")
    local HttpService = game:GetService("HttpService")
    local PlaceId = game.PlaceId
    
    local queuetype = queue_on_teleport or (syn and syn.queue_on_teleport)
    if queuetype and getgenv().AutoHopFruit then
        queuetype([[
            getgenv().AutoHopFruit = true
            getgenv().SelectedFilter = "]] .. getgenv().SelectedFilter .. [["
            loadstring(game:HttpGet("ĐƯỜNG_LINK_SCRIPT_CỦA_BẠN"))()
        ]])
    end
    
    local success, Servers = pcall(function()
        return HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"))
    end)
    
    if success and Servers and Servers.data then
        for _, s in pairs(Servers.data) do
            if s.playing ~= s.maxPlayers and s.id ~= game.JobId then
                TeleportService:TeleportToPlaceInstance(PlaceId,
                    
