-- [[ BLOX FRUIT AUTO FARM, STORE & HOP (FIXED JOIN DELAY) ]] --

local SuccessUI, Fluent = pcall(function()
    return loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
end)

local Window
if SuccessUI and Fluent then
    Window = Fluent:CreateWindow({
        Title = "Blox Fruits - Auto Fruit & Hop",
        SubTitle = "Fixed Server Load Delay",
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

-- Biến kiểm tra để đảm bảo vừa vào server mới sẽ đứng đợi load đồ xong mới quét
local HasLoadedServer = false

-- Hàm tìm Trái Ác Quỷ
local function GetFruit()
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Tool") and v:FindFirstChild("Handle") then
            local parent = v.Parent
            local isPlayerChar = game.Players:GetPlayerFromCharacter(parent)
            local isBackpack = parent and parent:IsA("Backpack")
            
            if not isPlayerChar and not isBackpack then
                return v
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

-- Đánh dấu trạng thái vừa vào game
task.spawn(function()
    repeat task.wait() until game:IsLoaded()
    task.wait(4) -- Đứng chờ 4 giây đầu tiên khi vừa vào server để map và đồ đạc load xong hoàn toàn
    HasLoadedServer = true
end)

-- Vòng lặp chính xử lý
task.spawn(function()
    while task.wait(1) do
        if getgenv().AutoHopFruit then
            -- Nếu chưa load xong server thì chưa làm gì cả, đứng đợi cho an toàn
            if not HasLoadedServer then continue end
            
            local player = game.Players.LocalPlayer
            local character = player.Character or player.CharacterAdded:Wait()
            local hrp = character:WaitForChild("HumanoidRootPart", 5)
            
            local fruit = GetFruit()
            
            if fruit and hrp and fruit:FindFirstChild("Handle") then
                local handle = fruit.Handle
                
                -- 1. Dịch chuyển tới trái ngay lập tức
                hrp.CFrame = handle.CFrame + Vector3.new(0, 3, 0)
                task.wait(0.5)
                
                -- 2. Ép nhặt
                pcall(function()
                    firetouchinterest(hrp, handle, 0)
                    firetouchinterest(hrp, handle, 1)
                end)
                
                task.wait(2)
                
                -- 3. Cất vào kho
                local stored = false
                local attempts = 0
                repeat
                    stored = AutoStoreFruits()
                    attempts = attempts + 1
                    task.wait(0.5)
                until stored or attempts > 5
                
                -- 4. Cất xong mới hop sang server mới
                task.wait(1)
                HasLoadedServer = false -- Reset lại cờ chờ cho server tiếp theo
                ServerHop()
                task.wait(10)
            else
                -- Đứng lại ở server này kiểm tra kỹ trong 4 giây, nếu không có trái mới cho phép Hop
                task.wait(4)
                if not GetFruit() then
                    HasLoadedServer = false
                    ServerHop()
                    task.wait(8)
                end
            end
        end
    end
end)

-- Giao diện Menu
if Window and Tabs.Main then
    local Toggle = Tabs.Main:AddToggle("AutoFruitHop", { Title = "Auto Nhặt Mọi Trái & Hop Server", Default = getgenv().AutoHopFruit })
    Toggle:OnChanged(function(Value)
        getgenv().AutoHopFruit = Value
        if Value then
            Fluent:Notify({ Title = "Blox Fruits", Content = "Đã BẬT! Sẵn sàng săn trái.", Duration = 3 })
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
