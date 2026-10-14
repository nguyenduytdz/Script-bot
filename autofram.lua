-- [[ AUTO FARM BLOX FRUIT - REDZ & BANANA LOGIC FIX ]] --

local SuccessUI, Fluent = pcall(function()
    return loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
end)

local Window = Fluent:CreateWindow({
    Title = "Blox Fruits - Pro Farm (Redz Engine)",
    SubTitle = "Fixed Quest Dialogue Freeze",
    TabWidth = 160,
    Size = UDim2.fromOffset(520, 360),
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.RightControl
})

local Tabs = { Main = Window:AddTab({ Title = "Auto Farm", Icon = "home" }) }

getgenv().AutoFarmEnabled = getgenv().AutoFarmEnabled or false
getgenv().SafeHeight = 15

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CommF = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_")

-- Giữ nhân vật lơ lửng không bị trọng lực ghì lại (Kỹ thuật từ Redz Hub)
local function EnableNoclipAndFly(hrp)
    if not hrp:FindFirstChild("FarmVelocity") then
        local bv = Instance.new("BodyVelocity")
        bv.Name = "FarmVelocity"
        bv.Velocity = Vector3.new(0, 0, 0)
        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bv.Parent = hrp
    end
    
    local char = LocalPlayer.Character
    if char then
        for _, part in pairs(char:GetChildren()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end

local function DisableNoclipAndFly(hrp)
    if hrp and hrp:FindFirstChild("FarmVelocity") then
        hrp.FarmVelocity:Destroy()
    end
end

-- Tự động giải phóng bảng hội thoại NPC
local function ClearDialogueUI()
    pcall(function()
        local mainGui = LocalPlayer.PlayerGui:FindFirstChild("Main")
        if mainGui then
            if mainGui:FindFirstChild("Dialogue") then
                mainGui.Dialogue.Visible = false
            end
        end
    end)
end

-- Hàm di chuyển Tween chuẩn Redz Hub
local currentTween = nil
local function TweenToPos(targetCFrame, speed)
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local hrp = char.HumanoidRootPart
    
    EnableNoclipAndFly(hrp)
    
    local distance = (hrp.Position - targetCFrame.Position).Magnitude
    local time = distance / (speed or 250)
    
    if currentTween then currentTween:Cancel() end
    
    local tweenInfo = TweenInfo.new(time, Enum.EasingStyle.Linear)
    currentTween = TweenService:Create(hrp, tweenInfo, {CFrame = targetCFrame})
    currentTween:Play()
    return currentTween
end

-- Trang bị vũ khí
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
        if getgenv().AutoFarmEnabled then
            pcall(function()
                local char = LocalPlayer.Character
                if not char or not char:FindFirstChild("HumanoidRootPart") or char.Humanoid.Health <= 0 then return end
                
                local hrp = char.HumanoidRootPart
                local level = LocalPlayer.Data.Level.Value
                local isQuestActive = LocalPlayer.PlayerGui.Main.Quest.Visible
                
                -- Level 1 - 14 (Bandit)
                if level < 15 then
                    if not isQuestActive then
                        -- Bay đến gần NPC (không đứng sát đè lên NPC)
                        local npcPos = CFrame.new(1059, 16, 1549)
                        if (hrp.Position - npcPos.Position).Magnitude > 12 then
                            TweenToPos(npcPos, 280)
                        else
                            if currentTween then currentTween:Cancel() end
                            -- Nhận quest & ép tắt giao diện thoại lập tức
                            CommF:InvokeServer("StartQuest", "BanditQuest1", 1)
                            ClearDialogueUI()
                            task.wait(0.3)
                        end
                    else
                        -- ĐÃ NHẬN QUEST -> Xóa thoại lần nữa & Bay thẳng ra bãi quái
                        ClearDialogueUI()
                        EquipWeapon()
                        
                        local targetMob = nil
                        for _, v in pairs(workspace.Enemies:GetChildren()) do
                            if (v.Name == "Bandit" or string.find(v.Name, "Bandit")) and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChildOfClass("Humanoid").Health > 0 then
                                targetMob = v
                                break
                            end
                        end
                        
                        if targetMob and targetMob:FindFirstChild("HumanoidRootPart") then
                            -- Bay lên đầu quái và gạt trọng lực
                            EnableNoclipAndFly(hrp)
                            if currentTween then currentTween:Cancel() end
                            
                            local safePos = targetMob.HumanoidRootPart.CFrame + Vector3.new(0, getgenv().SafeHeight, 0)
                            hrp.CFrame = safePos
                            
                            -- Gom quái & Đánh
                            targetMob.HumanoidRootPart.CFrame = safePos - Vector3.new(0, getgenv().SafeHeight, 0)
                            targetMob.HumanoidRootPart.CanCollide = false
                            
                            local tool = char:FindFirstChildOfClass("Tool")
                            if tool then tool:Activate() end
                        else
                            -- Nếu chưa có quái -> Bay trượt ra bãi Bandit đứng chờ lơ lửng
                            TweenToPos(CFrame.new(1145, 25, 1634), 250)
                        end
                    end
                end
            end)
        else
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                DisableNoclipAndFly(LocalPlayer.Character.HumanoidRootPart)
            end
            if currentTween then currentTween:Cancel() end
        end
    end
end)

-- Toggle Menu
local Toggle = Tabs.Main:AddToggle("AutoFarmToggle", { Title = "🚀 BẬT AUTO FARM (REDZ ENGINE)", Default = getgenv().AutoFarmEnabled })
Toggle:OnChanged(function(Value)
    getgenv().AutoFarmEnabled = Value
end)

Window:SelectTab(1)
