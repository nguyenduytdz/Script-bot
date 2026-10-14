-- [[ BLOX FRUIT PROFESSIONAL STYLE AUTO FARM ]] --

local SuccessUI, Fluent = pcall(function()
    return loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
end)

local Window = Fluent:CreateWindow({
    Title = "Blox Fruits - Pro Custom Farm",
    SubTitle = "Smooth Tween & Safe Quest Logic",
    TabWidth = 160,
    Size = UDim2.fromOffset(520, 360),
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.RightControl
})

local Tabs = { Main = Window:AddTab({ Title = "Auto Farm", Icon = "home" }) }

getgenv().AutoFarmEnabled = getgenv().AutoFarmEnabled or false
getgenv().FastAttack = true
getgenv().SafeHeight = 20

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CommF = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_")

-- Biến lưu trữ tween hiện tại để có thể hủy khi cần đổi mục tiêu
local currentTween = nil

local function StopTween()
    if currentTween then
        currentTween:Cancel()
        currentTween = nil
    end
end

-- Hàm bay trượt mượt mà (Tween) không lo bị kẹt hay chống hack chặn
local function TweenTo(targetCFrame, speed)
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    
    local hrp = char.HumanoidRootPart
    local distance = (hrp.Position - targetCFrame.Position).Magnitude
    local travelTime = distance / (speed or 280) -- Tốc độ bay mượt
    
    StopTween()
    
    -- Tắt va chạm để xuyên tường, không bị kẹt địa hình
    for _, part in pairs(char:GetChildren()) do
        if part:IsA("BasePart") then part.CanCollide = false end
    end
    
    local tweenInfo = TweenInfo.new(travelTime, Enum.EasingStyle.Linear)
    currentTween = TweenService:Create(hrp, tweenInfo, {CFrame = targetCFrame})
    currentTween:Play()
    return currentTween
end

-- Tự động chọn và cầm vũ khí trong balo
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

-- BẢNG NHIỆM VỤ TIÊU CHUẨN (Bắt đầu từ Sea 1 - Bandit)
local function GetQuestInfo()
    local level = LocalPlayer.Data.Level.Value
    if level >= 1 and level <= 14 then
        return "BanditQuest1", 1, CFrame.new(1059, 16, 1549), "Bandit", CFrame.new(1145, 17, 1634)
    elseif level >= 15 and level <= 29 then
        return "JungleQuest", 1, CFrame.new(-1599, 37, 153), "Monkey", CFrame.new(-1618, 22, 143)
    end
    -- Bạn có thể mở rộng thêm các mốc level tiếp theo ở đây
    return nil
end

-- VÒNG LẶP CHÍNH AUTO FARM
task.spawn(function()
    while task.wait(0.1) do
        if getgenv().AutoFarmEnabled then
            pcall(function()
                local char = LocalPlayer.Character
                if not char or not char:FindFirstChild("HumanoidRootPart") or char.Humanoid.Health <= 0 then return end
                
                local hrp = char.HumanoidRootPart
                local questName, questLevel, questPos, mobName, mobPos = GetQuestInfo()
                
                if questName then
                    local isQuestActive = LocalPlayer.PlayerGui.Main.Quest.Visible
                    
                    -- TRƯỜNG HỢP 1: CHƯA CÓ NHIỆM VỤ -> BAY ĐẾN NPC NHẬN
                    if not isQuestActive then
                        if (hrp.Position - questPos.Position).Magnitude > 10 then
                            TweenTo(questPos, 300)
                        else
                            StopTween()
                            CommF:InvokeServer("StartQuest", questName, questLevel)
                            task.wait(0.5)
                        end
                    else
                        -- TRƯỜNG HỢP CÓ NHIỆM VỤ -> TÌM QUÁI VÀ ĐÁNH
                        EquipWeapon()
                        local targetMob = nil
                        
                        for _, v in pairs(workspace.Enemies:GetChildren()) do
                            if (v.Name == mobName or string.find(v.Name, mobName)) and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChildOfClass("Humanoid").Health > 0 then
                                targetMob = v
                                break
                            end
                        end
                        
                        if targetMob and targetMob:FindFirstChild("HumanoidRootPart") then
                            -- Bay lên đầu quái né đòn
                            local aboveMobCFrame = targetMob.HumanoidRootPart.CFrame + Vector3.new(0, getgenv().SafeHeight, 0)
                            hrp.CFrame = aboveMobCFrame
                            
                            -- Gom quái lại chân và kích hoạt đánh
                            targetMob.HumanoidRootPart.CFrame = aboveMobCFrame - Vector3.new(0, getgenv().SafeHeight, 0)
                            targetMob.HumanoidRootPart.CanCollide = false
                            
                            local tool = char:FindFirstChildOfClass("Tool")
                            if tool then tool:Activate() end
                        else
                            -- Nếu quái chưa ra -> Trượt mượt ra giữa bãi chờ
                            TweenTo(mobPos + Vector3.new(0, 15, 0), 250)
                        end
                    end
                end
            end)
        else
            StopTween()
        end
    end
end)

-- GIAO DIỆN MENU
local Toggle = Tabs.Main:AddToggle("AutoFarmToggle", { Title = "🚀 BẬT AUTO FARM (PRO TWEEN)", Default = getgenv().AutoFarmEnabled })
Toggle:OnChanged(function(Value)
    getgenv().AutoFarmEnabled = Value
    if not Value then StopTween() end
end)

Window:SelectTab(1)
