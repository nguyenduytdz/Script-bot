-- [[ BLOX FRUIT AUTO FARM, STORE & PERSISTENT HOP MENU ]] --

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Blox Fruits - Auto Hop & Store Fruit", "DarkTheme")

-- Sử dụng getgenv() để lưu trạng thái xuyên suốt các Server khi Teleport
getgenv().AutoHopFruit = getgenv().AutoHopFruit or false

local MainTab = Window:NewTab("Main Menu")
local MainSection = MainTab:NewSection("Auto Farm Fruit")

-- Hàm tìm Trái Ác Quỷ trong Workspace
local function GetFruit()
    for _, v in pairs(workspace:GetChildren()) do
        if v:IsA("Tool") and string.find(v.Name, "Fruit") then
            return v
        end
    end
    return nil
end

-- Hàm cất trái vào kho và trả về kết quả thành công
local function AutoStoreFruits()
    local player = game.Players.LocalPlayer
    local remote = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes") and game:GetService("ReplicatedStorage").Remotes:FindFirstChild("CommF_")
    
    if not remote then return false end
    
    local storedSuccessfully = false
    
    local function checkAndStore(container)
        if not container then return end
        for _, item in pairs(container:GetChildren()) do
            if item:IsA("Tool") and string.find(item.Name, "Fruit") then
                pcall(function()
                    remote:InvokeServer("StoreFruit", item)
                end)
                storedSuccessfully = true
                task.wait(1)
            end
        end
    end
    
    -- Kiểm tra trong Balo và trên Nhân vật
    checkAndStore(player:FindFirstChild("Backpack"))
    checkAndStore(player.Character)
    
    return storedSuccessfully
end

-- Hàm Server Hop kèm theo lệnh tự động chạy lại script ở server mới (Queue on Teleport)
local function ServerHop()
    local TeleportService = game:GetService("TeleportService")
    local HttpService = game:GetService("HttpService")
    local PlaceId = game.PlaceId
    
    -- Tự động lưu trạng thái bật script cho Server tiếp theo
    local queuetype = queue_on_teleport or (syn and syn.queue_on_teleport)
    if queuetype and getgenv().AutoHopFruit then
        queuetype([[
            getgenv().AutoHopFruit = true
            -- Script sẽ tự động chạy lại mã nguồn này ở server tiếp theo
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

-- Vòng lặp chính với logic tuần tự nghiêm ngặt
task.spawn(function()
    while task.wait(1) do
        if getgenv().AutoHopFruit then
            local fruit = GetFruit()
            local hrp = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            
            if fruit and hrp then
                -- 1. Bay/Dịch chuyển đến vị trí trái ác quỷ
                if fruit:FindFirstChild("Handle") then
                    hrp.CFrame = fruit.Handle.CFrame
                else
                    hrp.CFrame = fruit:GetModelCFrame()
                end
                
                -- Đợi game xác nhận nhặt trái vào balo
                task.wait(1.5)
                
                -- 2. Tiến hành cất trái vào kho (Lặp lại cho đến khi cất thành công hoàn toàn)
                local stored = false
                local attempts = 0
                repeat
                    stored = AutoStoreFruits()
                    attempts = attempts + 1
                    task.wait(0.5)
                until stored or attempts > 6
                
                -- 3. Đảm bảo đã lưu xong xuôi mới gọi lệnh chuyển sang Server khác
                if stored then
                    task.wait(1)
                    ServerHop()
                    task.wait(10)
                end
            else
                -- Không có trái trong server -> Lập tức Hop sang Server khác tìm tiếp
                ServerHop()
                task.wait(8)
            end
        end
    end
end)

-- Giao diện Toggle Bật/Tắt
MainSection:NewToggle("Auto Fruit, Store & Hop", "Tự động nhặt, cất kho, duy trì khi đổi server", function(state)
    getgenv().AutoHopFruit = state
    if state then
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Blox Fruits",
            Text = "Đã BẬT! Script sẽ tự duy trì qua các Server.",
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

-- Nút Chuyển Server Thủ Công
MainSection:NewButton("Hop Server Ngay", "Chuyển server thủ công", function()
    ServerHop()
end)

local ConfigTab = Window:NewTab("Cài Đặt")
local ConfigSection = ConfigTab:NewSection("Phím Tắt")
ConfigSection:NewKeybind("Bật/Tắt Menu", "Ẩn hiện giao diện", Enum.KeyCode.RightControl, function()
    Library:ToggleUI()
end)
