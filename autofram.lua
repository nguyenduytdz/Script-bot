-- [[ BLOX FRUIT AUTO FARM - FIX LỖI KẸT HỘI THOẠI UI ]] --

local SuccessUI, Fluent = pcall(function()
    return loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
end)

local Window = Fluent:CreateWindow({
    Title = "Blox Fruits - Fix Dialogue Freeze",
    SubTitle = "Auto Bypass Dialogue GUI",
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

-- Hàm tự động ẩn/đóng bảng hội thoại NPC của Blox Fruits
local function CloseDialogueUI()
    pcall(function()
        local mainGui = LocalPlayer.PlayerGui:FindFirstChild("Main")
        if mainGui then
            if mainGui:FindFirstChild("Dialogue") then
                mainGui.Dialogue.Visible = false
            end
            if mainGui:FindFirstChild("Interacted") then
                mainGui.Interacted.Value = false
            end
        end
    end)
end

-- Hàm di chuyển trượt mượt (Tween)
local function TweenTo(targetCFrame, speed)
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    
    local hrp = char.HumanoidRootPart
    local distance = (hrp.Position - targetCFrame.Position).Magnitude
    local time = distance / (speed or 250)
    
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

-- Tự động cầm vũ khí
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

-- Vòng lặp Farm chính
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
                        -- 1. Trượt tới NPC
                        if (hrp.Position - Vector3.new(1059, 16, 1549)).Magnitude > 12 then
                            TweenTo(CFrame.new(1059, 16, 1549), 300)
                            task.wait(0.3)
                        end
                        
                        -- 2. Gửi lệnh nhận Quest & Đóng bảng thoại ngay lập tức
                        CommF:InvokeServer("StartQuest", "BanditQuest1", 1)
                        CloseDialogueUI()
                        task.wait(0.3)
                    else
                        -- 3. Đã nhận Quest -> Ép đóng UI lần nữa & Trượt thẳng ra bãi Bandit
                        CloseDialogueUI()
                        EquipWeapon()
                        
                        local targetMob = nil
                        for _, v in pairs(workspace.Enemies:GetChildren()) do
                            if (v.Name == "Bandit" or string.find(v.Name, "Bandit")) and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChildOfClass("Humanoid").Health > 0 then
                                targetMob = v
                                break
                            end
                        end
                        
                        if targetMob and targetMob:FindFirstChild("HumanoidRootPart") then
                            -- Bay lên đầu quái
                            hrp.CFrame = targetMob.HumanoidRootPart.CFrame + Vector3.new(0, getgenv().SafeHeight, 0)
                            
                            -- Gom quái & Đánh
                            targetMob.HumanoidRootPart.CFrame = hrp.CFrame - Vector3.new(0, getgenv().SafeHeight, 0)
                            targetMob.HumanoidRootPart.CanCollide = false
                            
                            local tool = char:FindFirstChildOfClass("Tool")
                            if tool then tool:Activate() end
                        else
                            -- Nếu chưa có quái -> Trượt mượt ra bãi Bandit ngồi chờ
                            TweenTo(CFrame.new(1145, 20, 1634), 250)
                        end
                    end
                end
            end)
        end
    end
end)

-- Giao diện Toggle
local Toggle = Tabs.Main:AddToggle("MasterAutoFarmToggle", { Title = "🚀 BẬT AUTO FARM (FIX LỖI KẸT UI)", Default = getgenv().MasterAutoFarm })
Toggle:OnChanged(function(Value)
    getgenv().MasterAutoFarm = Value
end)

Window:SelectTab(1)
