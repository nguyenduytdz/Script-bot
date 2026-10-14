-- [[ BLOX FRUIT AUTO FARM - FIX LỖI ĐỨNG YÊN TẠI NPC ]] --

local SuccessUI, Fluent = pcall(function()
    return loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
end)

local Window = Fluent:CreateWindow({
    Title = "Blox Fruits - Fix Movement Auto Farm",
    SubTitle = "Anti-Stuck NPC",
    TabWidth = 160,
    Size = UDim2.fromOffset(500, 320),
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.RightControl
})

local Tabs = { Main = Window:AddTab({ Title = "Trang Chính", Icon = "home" }) }

getgenv().MasterAutoFarm = getgenv().MasterAutoFarm or false
getgenv().SafeHeight = 15

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CommF = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_")

-- Tự động cầm vũ khí cận chiến
local function EquipWeapon()
    local char = LocalPlayer.Character
    if char and not char:FindFirstChildOfClass("Tool") then
        local backpack = LocalPlayer:FindFirstChild("Backpack")
        if backpack then
            for _, tool in pairs(backpack:GetChildren()) do
                if tool:IsA("Tool") and (tool.ToolTip == "Melee" or tool.ToolTip == "Blox Fruit" or tool.ToolTip == "Sword") then
                    char.Humanoid:EquipTool(tool)
                    break
                end
            end
        end
    end
end

-- Vòng lặp chính Auto Farm
task.spawn(function()
    while task.wait(0.1) do
        if getgenv().MasterAutoFarm then
            pcall(function()
                local char = LocalPlayer.Character
                if not char or not char:FindFirstChild("HumanoidRootPart") or char.Humanoid.Health <= 0 then return end
                
                local hrp = char.HumanoidRootPart
                local level = LocalPlayer.Data.Level.Value
                local isQuestActive = LocalPlayer.PlayerGui.Main.Quest.Visible
                
                -- Xử lý mốc Level 1 - 14 (Bandit - Đảo Khởi Đầu)
                if level < 15 then
                    if not isQuestActive then
                        -- Bước 1: Bay tới NPC nhận Quest
                        if (hrp.Position - Vector3.new(1059, 16, 1549)).Magnitude > 10 then
                            hrp.CFrame = CFrame.new(1059, 16, 1549)
                            task.wait(0.3)
                        end
                        -- Gửi lệnh nhận nhiệm vụ
                        CommF:InvokeServer("StartQuest", "BanditQuest1", 1)
                        task.wait(0.5)
                    else
                        -- Bước 2: Đã nhận quest -> Tự động lùi/bay thoát khỏi Safe Zone tới thẳng bãi Bandit
                        EquipWeapon()
                        
                        local targetMob = nil
                        for _, v in pairs(workspace.Enemies:GetChildren()) do
                            if (v.Name == "Bandit" or string.find(v.Name, "Bandit")) and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChildOfClass("Humanoid").Health > 0 then
                                targetMob = v
                                break
                            end
                        end
                        
                        if targetMob and targetMob:FindFirstChild("HumanoidRootPart") then
                            -- Dịch chuyển trực tiếp lên đầu quái Bandit
                            hrp.CFrame = targetMob.HumanoidRootPart.CFrame + Vector3.new(0, getgenv().SafeHeight, 0)
                            
                            -- Gom quái lại chân và thực hiện đánh
                            targetMob.HumanoidRootPart.CFrame = hrp.CFrame - Vector3.new(0, getgenv().SafeHeight, 0)
                            targetMob.HumanoidRootPart.CanCollide = false
                            
                            local tool = char:FindFirstChildOfClass("Tool")
                            if tool then tool:Activate() end
                        else
                            -- Nếu quái chưa xuất hiện -> Bắt buộc di chuyển ra khu vực bãi Bandit (nghiêm cấm đứng tại chỗ NPC)
                            hrp.CFrame = CFrame.new(1145, 25, 1634)
                        end
                    end
                end
            end)
        end
    end
end)

-- Giao diện Bật/Tắt
local Toggle = Tabs.Main:AddToggle("MasterAutoFarmToggle", { Title = "🚀 BẬT AUTO FARM (FIX ĐỨNG TẠI NPC)", Default = getgenv().MasterAutoFarm })
Toggle:OnChanged(function(Value)
    getgenv().MasterAutoFarm = Value
    if Value then
        Fluent:Notify({ Title = "Blox Fruits", Content = "Đã BẬT! Nhân vật sẽ tự thoát chỗ NPC đi đánh quái.", Duration = 3 })
    else
        Fluent:Notify({ Title = "Blox Fruits", Content = "Đã TẮT!", Duration = 3 })
    end
end)

Window:SelectTab(1)
