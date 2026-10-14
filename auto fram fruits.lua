-- [[ BLOX FRUIT AUTO FARM, STORE & PERSISTENT HOP MENU (FINAL FIXED) ]] --

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Blox Fruits - Auto Hop & Store Fruit", "DarkTheme")

getgenv().AutoHopFruit = getgenv().AutoHopFruit or false

local MainTab = Window:NewTab("Main Menu")
local MainSection = MainTab:NewSection("Auto Farm Fruit")

-- Hàm tìm Trái Ác Quỷ sâu bên trong Workspace (Quét toàn bộ Map)
local function GetFruit()
    for _, v in pairs(workspace:GetDescendants()) do
        if (v:IsA("Tool") or v:IsA("Model")) and (string.find(v.Name, "Fruit") or v.Name == "Fruit ") then
            -- Đảm bảo không lấy nhầm item đang nằm trên người người chơi khác
            local playerParent = game.Players:GetPlayerFromCharacter(v.Parent)
            local humanoidParent = v.Parent and v.Parent:FindFirstChildOfClass("Humanoid")
            
            if not playerParent and not humanoidParent then
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

-- Hàm Server Hop kèm duy trì trạng thái
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

-- Vòng lặp xử lý chính
task.spawn(function()
    while task.wait(1) do
        if getgenv().AutoHopFruit then
            local fruit = GetFruit()
            local hrp = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            
            if fruit and hrp then
                -- Lấy phần cơ sở để bay đến chính xác vị trí trái
                local targetPart = nil
                if fruit:IsA("Tool") then
                    targetPart = fruit:FindFirstChild("Handle")
                elseif fruit:IsA("Model") then
                    targetPart = fruit:FindFirstChild("Handle") or fruit.PrimaryPart or fruit:FindFirstChildOfClass("BasePart")
                end
                
                if targetPart then
                    -- Dịch chuyển ngay lập tức tới trái (cộng thêm chút độ cao để nhận diện va chạm tốt hơn)
                    hrp.CFrame = targetPart.CFrame + Vector3.new(0, 3, 0)
                end
                
                -- Đợi game xác nhận nhặt vào balo
                task.wait(2)
                
                -- Tiến hành cất vào kho
                local stored = false
                local attempts = 0
                repeat
                    stored = AutoStoreFruits()
                    attempts = attempts + 1
                    task.wait(0.5)
                until stored or attempts > 5
                
                -- Cất xong xuôi mới chuyển Server khác
                task.wait(1)
                ServerHop()
                task.wait(10)
            else
                -- Không tìm thấy trái trong map -> Chuyển sang Server mới ngay
                ServerHop()
                task.wait(8)
            end
        end
    end
end)

-- Giao diện Toggle
MainSection:NewToggle("Auto Fruit, Store & Hop", "Tự động nhặt, cất kho, tự chạy lại khi đổi server", function(state)
    getgenv().AutoHopFruit = state
    if state then
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Blox Fruits",
            Text = "Đã BẬT! Sẵn sàng săn trái ác quỷ.",
            Duration = 3
        })
    else
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Blox Fruits",
            Text = "Đã TẮT!",
            Duration = 3
        })
    end
end)

MainSection:NewButton("Hop Server Ngay", "Chuyển server thủ công", function()
    ServerHop()
end)

local ConfigTab = Window:NewTab("Cài Đặt")
local ConfigSection = ConfigTab:NewSection("Phím Tắt")
ConfigSection:NewKeybind("Bật/Tắt Menu", "Ẩn hiện giao diện", Enum.KeyCode.RightControl, function()
    Library:ToggleUI()
end)
