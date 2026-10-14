-- [[ BLOX FRUIT AUTO FARM, STORE & HOP (ALL FRUITS: SPAWN & DROPPED) ]] --

local SuccessUI, Fluent = pcall(function()
    return loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
end)

local Window
if SuccessUI and Fluent then
    Window = Fluent:CreateWindow({
        Title = "Blox Fruits - Auto Fruit & Hop",
        SubTitle = "Catch Spawned & Dropped Fruits",
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
getgenv().FruitFilter = getgenv().FruitFilter or "Tất cả (Kể cả trái rác & trái thả)"

-- Phân loại độ hiếm
local CommonFruits = {"Rocket", "Spin", "Chop", "Spring", "Bomb", "Smoke", "Spike"}
local UncommonFruits = {"Flame", "Falcon", "Ice", "Sand", "Dark", "Ghost", "Diamond"}
local RareFruits = {"Light", "Rubber", "Barrier", "Magma", "Quake", "Love", "Spider"}
local LegendaryFruits = {"Portal", "Rumble", "Pain", "Gravity", "Blizzard", "Mammoth", "T-Rex", "Sound", "Phoenix"}
local MythicalFruits = {"Kitsune", "Leopard", "Dragon", "Gas", "Yeti", "Spirit", "Venom", "Shadow", "Dough", "Control"}

local function GetFruitRarity(name)
    for _, f in ipairs(CommonFruits) do if name == f or string.find(name, f) then return "Common" end end
    for _, f in ipairs(UncommonFruits) do if name == f or string.find(name, f) then return "Uncommon" end end
    for _, f in ipairs(RareFruits) do if name == f or string.find(name, f) then return "Rare" end end
    for _, f in ipairs(LegendaryFruits) do if name == f or string.find(name, f) then return "Legendary" end end
    for _, f in ipairs(MythicalFruits) do if name == f or string.find(name, f) then return "Mythical" end end
    return "Unknown"
end

local function IsAllowedByFilter(name)
    local filter = getgenv().FruitFilter
    local rarity = GetFruitRarity(name)
    
    if filter == "Tất cả (Kể cả trái rác & trái thả)" then
        return true
    elseif filter == "Chỉ Uncommon trở lên (Bỏ Common)" then
        return rarity ~= "Common"
    elseif filter == "Chỉ Rare trở lên (Rare, Legendary, Mythical)" then
        return rarity == "Rare" or rarity == "Legendary" or rarity == "Mythical" or rarity == "Unknown"
    elseif filter == "Chỉ Legendary & Mythical" then
        return rarity == "Legendary" or rarity == "Mythical"
    elseif filter == "Chỉ Mythical" then
        return rarity == "Mythical"
    end
    return true
end

-- Hàm quét tìm mọi loại trái (Cả trái spawn trên cây lẫn trái người chơi thả ra đất)
local function GetFruit()
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Tool") and v:FindFirstChild("Handle") then
            local parent = v.Parent
            local isPlayerChar = game.Players:GetPlayerFromCharacter(parent)
            local isBackpack = parent and parent:IsA("Backpack")
            
            -- Nếu nó nằm ngoài nhân vật và balo (tức là đang rơi trên đất / được thả ra)
            if not isPlayerChar and not isBackpack then
                if IsAllowedByFilter(v.Name) then
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

-- Hàm chuyển Server thông minh & giữ trạng thái
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
            
            if fruit and hrp and fruit:FindFirstChild("Handle") then
                local handle = fruit.Handle
                
                -- Bay đến vị trí trái (cả trái tự nhiên lẫn trái thả)
                hrp.CFrame = handle.CFrame + Vector3.new(0, 3, 0)
                task.wait(0.3)
                
                -- Ép nhặt
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
                
                task.wait(1)
                ServerHop()
                task.wait(10)
            else
                task.wait(3)
                ServerHop()
                task.wait(8)
            end
        end
    end
end)

-- Giao diện Menu
if Window and Tabs.Main then
    Tabs.Main:AddDropdown("RarityFilter", {
        Title = "Lọc Độ Hiếm Trái Ác Quỷ",
        Values = {
            "Tất cả (Kể cả trái rác & trái thả)",
            "Chỉ Uncommon trở lên (Bỏ Common)", 
            "Chỉ Rare trở lên (Rare, Legendary, Mythical)", 
            "Chỉ Legendary & Mythical", 
            "Chỉ Mythical"
        },
        Default = getgenv().FruitFilter,
        Callback = function(Value)
            getgenv().FruitFilter = Value
            Fluent:Notify({ Title = "Bộ Lọc", Content = "Đã chọn: " .. Value, Duration = 2 })
        end
    })

    local Toggle = Tabs.Main:AddToggle("AutoFruitHop", { Title = "Auto Nhặt Trái (Spawn + Thả) & Hop", Default = getgenv().AutoHopFruit })
    Toggle:OnChanged(function(Value)
        getgenv().AutoHopFruit = Value
        if Value then
            Fluent:Notify({ Title = "Blox Fruits", Content = "Đã BẬT! Sẵn sàng săn mọi loại trái.", Duration = 3 })
        else
            Fluent:Notify({ Title = "Blox Fruits", Content = "Đã TẮT!", Duration = 3 })
        end
    end)

    Tabs.Main:AddButton({
        Title = "Hop Server Ngay",
        Callback = function()
            ServerHop()
        end
    })

    Window:SelectTab(1)
end
