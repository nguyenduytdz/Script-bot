-- [[ BLOX FRUIT AUTO FARM, STORE & HOP - NO COMMON FRUITS ]] --

local SuccessUI, Fluent = pcall(function()
    return loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
end)

local Window
if SuccessUI and Fluent then
    Window = Fluent:CreateWindow({
        Title = "Blox Fruits - Auto Hop (No Common)",
        SubTitle = "Bỏ Trái Rác (Rocket, Spin...)",
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

-- Danh sách các trái RÁC (Common) bị cấm nhặt
local CommonBlacklist = {
    "Rocket", "Spin", "Chop", "Spring", "Bomb", "Smoke", "Spike"
}

-- Kiểm tra xem trái có phải trái rác không
local function IsCommonFruit(fruitName)
    for _, name in ipairs(CommonBlacklist) do
        if fruitName == name or string.find(fruitName, name) then
            return true
        end
    end
    return false
end

local HasLoadedServer = false

-- Hàm tìm Trái Ác Quỷ (Loại trừ trái rác và trái người chơi đang cầm)
local function GetFruit()
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Tool") and v:FindFirstChild("Handle") then
            local parent = v.Parent
            local isPlayerChar = game.Players:GetPlayerFromCharacter(parent)
            local isBackpack = parent and parent:IsA("Backpack")
            
            if not isPlayerChar and not isBackpack then
                -- BỎ QUA TRÁI RÁC!
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

-- Hàm chuyển Server
local function ServerHop()
    local TeleportService = game:GetService("TeleportService")
    local HttpService = game:GetService("HttpService")
    local PlaceId = game.PlaceId
    
    local queuetype = queue_on_teleport or (syn and syn.queue_on_teleport)
    if queuetype and getgenv().AutoHopFruit then
        queuetype([[
            getgenv().AutoHopFruit = true
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

-- Đứng chờ 4s đầu khi vừa đổi server
task.spawn(function()
    repeat task.wait() until game:IsLoaded()
    task.wait(4)
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
                
                -- Bay tới nhặt trái xịn
                hrp.CFrame = handle.CFrame + Vector3.new(0, 3, 0)
                task.wait(0.5)
                
                pcall(function()
                    firetouchinterest(hrp, handle, 0)
                    firetouchinterest(hrp, handle, 1)
                end)
                
                task.wait(2)
                
                -- Cất kho
                local stored = false
                local attempts = 0
                repeat
                    stored = AutoStoreFruits()
                    attempts = attempts + 1
                    task.wait(0.5)
                until stored or attempts > 5
                
                -- Cất xong hop tiếp
                task.wait(1)
                HasLoadedServer = false
                ServerHop()
                task.wait(10)
            else
                -- Thấy trái rác hoặc không có trái -> Hop server ngay!
                task.wait(2)
                HasLoadedServer = false
                ServerHop()
                task.wait(8)
            end
        end
    end
end)

-- Giao diện Menu
if Window and Tabs.Main then
    local Toggle = Tabs.Main:AddToggle("AutoFruitHop", { Title = "Auto Nhặt Trái Xịn (Bỏ Rocket, Spin...) & Hop", Default = getgenv().AutoHopFruit })
    Toggle:OnChanged(function(Value)
        getgenv().AutoHopFruit = Value
        if Value then
            Fluent:Notify({ Title = "Blox Fruits", Content = "Đã BẬT! Bỏ qua toàn bộ trái rác Common.", Duration = 3 })
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
