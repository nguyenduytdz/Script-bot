-- [[ BLOX FRUIT AUTO FARM, STORE & HOP - FLUENT UI ]] --

-- Tải thư viện Fluent UI (Hiện đại và ổn định hơn)
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Blox Fruits - Auto Fruit & Hop",
    SubTitle = "by AI Assistant",
    TabWidth = 160,
    Size = UDim2.fromOffset(500, 320),
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.RightControl -- Phím Right Ctrl để Ẩn/Hiện Menu
})

local Tabs = {
    Main = Window:AddTab({ Title = "Trang Chính", Icon = "home" })
}

getgenv().AutoHopFruit = getgenv().AutoHopFruit or false

-- Hàm tìm Trái Ác Quỷ trên bản đồ
local function GetFruit()
    for _, v in pairs(workspace:GetDescendants()) do
        if (v:IsA("Tool") or v:IsA("Model")) and (string.find(v.Name, "Fruit") or v.Name == "Fruit ") then
            local playerParent = game.Players:GetPlayerFromCharacter(v.Parent)
            local humanoidParent = v.Parent and v.Parent:FindFirstChildOfClass("Humanoid")
            
            if not playerParent and not humanoidParent then
                if v:IsA("Tool") and v:FindFirstChild("Handle") then
                    return v
                elseif v:IsA("Model") then
                    local part = v:FindFirstChild("Handle") or v.PrimaryPart or v:FindFirstChildOfClass("BasePart")
                    if part then return v end
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

-- Hàm Chuyển Server & Giữ trạng thái tự chạy
local function ServerHop()
    local TeleportService = game:GetService("TeleportService")
    local HttpService = game:GetService("HttpService")
    local PlaceId = game.PlaceId
    
    -- Tự động chạy lại script ở Server mới
    local queuetype = queue_on_teleport or (syn and syn.queue_on_teleport)
    if queuetype and getgenv().AutoHopFruit then
        queuetype([[
            getgenv().AutoHopFruit = true
            repeat task.wait() until game:IsLoaded()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))() -- Chờ game nạp xong
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
            -- Chờ nhân vật xuất hiện hoàn chỉnh
            local player = game.Players.LocalPlayer
            local character = player.Character or player.CharacterAdded:Wait()
            local hrp = character:WaitForChild("HumanoidRootPart", 5)
            
            local fruit = GetFruit()
            
            if fruit and hrp then
                local targetPart = fruit:IsA("Tool") and fruit:FindFirstChild("Handle") or (fruit:IsA("Model") and (fruit:FindFirstChild("Handle") or fruit.PrimaryPart or fruit:FindFirstChildOfClass("BasePart")))
                
                if targetPart then
                    hrp.CFrame = targetPart.CFrame + Vector3.new(0, 3, 0)
                end
                
                task.wait(2) -- Đợi nhặt trái vào Balo
                
                -- Thực hiện cất trái
                local stored = false
                local attempts = 0
                repeat
                    stored = AutoStoreFruits()
                    attempts = attempts + 1
                    task.wait(0.5)
                until stored or attempts > 5
                
                -- Cất xong mới hop sang server mới
                task.wait(1)
                ServerHop()
                task.wait(10)
            else
                -- Không có trái trong server -> Hop server
                ServerHop()
                task.wait(8)
            end
        end
    end
end)

-- Tạo nút Toggle Bật/Tắt trên Giao diện Fluent
local Toggle = Tabs.Main:AddToggle("AutoFruitHop", { Title = "Auto Nhặt Trái, Cất Kho & Hop Server", Default = getgenv().AutoHopFruit })

Toggle:OnChanged(function(Value)
    getgenv().AutoHopFruit = Value
    if Value then
        Fluent:Notify({ Title = "Blox Fruits", Content = "Đã BẬT Tự động nhặt & Hop Server!", Duration = 3 })
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

-- Mặc định chọn Tab Main khi khởi chạy
Window:SelectTab(1)
