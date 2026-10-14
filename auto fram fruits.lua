-- [[ BLOX FRUIT AUTO FARM, STORE & HOP (CLEAN VERSION) ]] --

local SuccessUI, Fluent = pcall(function()
    return loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
end)

local Window
if SuccessUI and Fluent then
    Window = Fluent:CreateWindow({
        Title = "Blox Fruits - Auto Fruit & Hop",
        SubTitle = "Simple & Fast",
        TabWidth = 160,
        Size = UDim2.fromOffset(500, 320),
        Theme = "Dark",
        MinimizeKey = Enum.KeyCode.RightControl -- Nhấn Right Ctrl để ẩn/hiện menu
    })
end

local Tabs = {}
if Window then
    Tabs.Main = Window:AddTab({ Title = "Trang Chính", Icon = "home" })
end

getgenv().AutoHopFruit = getgenv().AutoHopFruit or false

-- Hàm tìm Trái Ác Quỷ (Bất kỳ trái nào rơi trên map có Handle và không nằm trong người chơi khác)
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

-- Hàm cất toàn bộ trái trong người vào kho (Storage)
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

-- Hàm chuyển Server thông minh & duy trì trạng thái
local function ServerHop()
    local TeleportService = game:GetService("TeleportService")
    local HttpService = game:GetService("HttpService")
    local PlaceId = game.PlaceId
    
    local queuetype = queue_on_teleport or (syn and syn.queue_on_teleport)
    if queuetype and getgenv().AutoHopFruit then
        queuetype([[
            getgenv().AutoHopFruit = true
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

-- Vòng lặp chính thực hiện quy trình
task.spawn(function()
    while task.wait(1) do
        if getgenv().AutoHopFruit then
            local player = game.Players.LocalPlayer
            local character = player.Character or player.CharacterAdded:Wait()
            local hrp = character:WaitForChild("HumanoidRootPart", 5)
            
            local fruit = GetFruit()
            
            if fruit and hrp and fruit:FindFirstChild("Handle") then
                local handle = fruit.Handle
                
                -- 1. Dịch chuyển ngay lập tức tới vị trí trái
                hrp.CFrame = handle.CFrame + Vector3.new(0, 3, 0)
                task.wait(0.3)
                
                -- 2. Ép buộc va chạm để nhặt trái vào balo
                pcall(function()
                    firetouchinterest(hrp, handle, 0)
                    firetouchinterest(hrp, handle, 1)
                end)
                
                task.wait(2) -- Chờ nhận diện nhặt
                
                -- 3. Tiến hành cất vào kho
                local stored = false
                local attempts = 0
                repeat
                    stored = AutoStoreFruits()
                    attempts = attempts + 1
                    task.wait(0.5)
                until stored or attempts > 5
                
                -- 4. Cất xong xuôi mới hop sang server tiếp theo
                task.wait(1)
                ServerHop()
                task.wait(10)
            else
                -- Không thấy trái -> Chờ map load ổn định 3s rồi hop tìm server mới
                task.wait(3)
                ServerHop()
                task.wait(8)
            end
        end
    end
end)

-- Giao diện Menu tối giản (Chỉ còn Toggle Bật/Tắt và nút Hop thủ công)
if Window and Tabs.Main then
    local Toggle = Tabs.Main:AddToggle("AutoFruitHop", { Title = "Auto Nhặt Mọi Trái & Hop Server", Default = getgenv().AutoHopFruit })
    Toggle:OnChanged(function(Value)
        getgenv().AutoHopFruit = Value
        if Value then
            Fluent:Notify({ Title = "Blox Fruits", Content = "Đã BẬT! Bắt đầu săn trái.", Duration = 3 })
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
