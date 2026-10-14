-- [[ BLOX FRUIT AUTO FARM - FIX TWEEN MOVEMENT ]] --

local SuccessUI, Fluent = pcall(function()
    return loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
end)

local Window = Fluent:CreateWindow({
    Title = "Blox Fruits - Smooth Tween Farm",
    SubTitle = "Fixed Standing Issue",
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
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CommF = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_")

-- Hàm Di Chuyển Trượt Mượt (Tween) Giống Các Bản Hub
local function TweenTo(targetCFrame, speed)
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    
    local hrp = char.HumanoidRootPart
    local distance = (hrp.Position - targetCFrame.Position).Magnitude
    local time = distance / (speed or 250)
    
    -- Tắt va chạm để không bị kẹt địa hình
    for _, part in pairs(char:GetChildren()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end
    
    local tweenInfo = TweenInfo.new(time, Enum.EasingStyle.Linear)
    local tween = TweenService:Create(hrp, tweenInfo, {CFrame = targetCFrame})
    tween:Play()
    return tween
end

-- Tự động lấy vũ khí
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

-- Vòng lặp Farm
task.spawn(function()
    while task.wait(0.1) do
        if getgenv().MasterAutoFarm then
            pcall(function()
                local char = LocalPlayer.Character
                if not char or not char:FindFirstChild("HumanoidRootPart") or char.Humanoid.Health <= 0 then return end
                
                local hrp = char.HumanoidRootPart
                local level = LocalPlayer.Data.Level.Value
                local isQuestActive = LocalPlayer.PlayerGui.Main.Quest.Visible
                
                -- Farm Bandit (Level 1 - 14)
                if level < 15 then
                    if not isQuestActive then
                        -- Bay trượt đến NPC nhận Quest
                        if (hrp.Position - Vector3.new(1059, 16, 1549)).Magnitude > 15 then
                            TweenTo(CFrame.new(1059, 16, 1549), 300)
                            task.wait(0.5)
                        end
                        CommF:InvokeServer("StartQuest", "BanditQuest1", 1)
                        task.wait(0.8) -- Đợi game đóng hội thoại NPC
                    else
                        -- Đã nhận Quest -> Trượt thẳng ra bãi quái Bandit
                        EquipWeapon()
                        local targetMob = nil
                        
                        for _, v in pairs(workspace.Enemies:GetChildren()) do
                            if (v.Name == "Bandit" or string.find(v.Name, "Bandit")) and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChildOfClass("Humanoid").Health > 0 then
                                targetMob = v
                                break
                            end
                        end
                        
                        if targetMob and targetMob:FindFirstChild("HumanoidRootPart") then
                            -- Bay đến trên đầu quái
                            local targetPos = targetMob.HumanoidRootPart.CFrame + Vector3.new(0, getgenv().SafeHeight, 0)
                            hrp.CFrame = targetPos
                            
                            -- Gom quái & Đánh
                            targetMob.HumanoidRootPart.CFrame = hrp.CFrame - Vector3.new(0, getgenv().SafeHeight, 0)
                            targetMob.HumanoidRootPart.CanCollide = false
                            
                            local tool = char:FindFirstChildOfClass("Tool")
                            if tool then tool:Activate() end
                        else
                            -- Nếu chưa thấy quái -> Trượt mượt ra bãi Bandit ngồi chờ
                            TweenTo(CFrame.new(1145, 20, 1634), 250)
                        end
                    end
                end
            end)
        end
    end
end)

-- Giao diện Toggle
local Toggle = Tabs.Main:AddToggle("MasterAutoFarmToggle", { Title = "🚀 BẬT AUTO FARM (TWEEN MOVEMENT)", Default = getgenv().MasterAutoFarm })
Toggle:OnChanged(function(Value)
    getgenv().MasterAutoFarm = Value
end)

Window:SelectTab(1)
