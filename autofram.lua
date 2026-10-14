-- [[ BLOX FRUIT - REDZ & BANANA REAL CORE ENGINE ]] --

local SuccessUI, Fluent = pcall(function()
    return loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
end)

local Window = Fluent:CreateWindow({
    Title = "Blox Fruits - Real Redz/Banana Core",
    SubTitle = "Fixed Standing NPC Issue",
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

-- [[ CORE ENGINE CỦA REDZ & BANANA HUB ]] --

-- 1. Bỏ qua hoàn toàn hiệu ứng đóng băng/khóa nhân vật của NPC (Dialogue Bypass)
local function ForceUnfreeze()
    pcall(function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = 16
            LocalPlayer.Character.Humanoid.PlatformStand = false
        end
        local mainGui = LocalPlayer.PlayerGui:FindFirstChild("Main")
        if mainGui then
            if mainGui:FindFirstChild("Dialogue") then mainGui.Dialogue.Visible = false end
            if mainGui:FindFirstChild("Interacted") then mainGui.Interacted.Value = false end
        end
    end)
end

-- 2. Hệ thống Giữ trọng lực lơ lửng & Tắt va chạm (Fly/Noclip)
local function ApplyBodyVelocity(hrp)
    if not hrp:FindFirstChild("RedzVelocity") then
        local bv = Instance.new("BodyVelocity")
        bv.Name = "RedzVelocity"
        bv.Velocity = Vector3.new(0, 0, 0)
        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bv.Parent = hrp
    end
    local char = LocalPlayer.Character
    if char then
        for _, v in pairs(char:GetChildren()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
end

local function RemoveBodyVelocity(hrp)
    if hrp and hrp:FindFirstChild("RedzVelocity") then
        hrp.RedzVelocity:Destroy()
    end
end

-- 3. Tween Engine chuẩn từ Banana Hub (Quản lý luồng bay mượt)
local currentTween = nil
local function RedzTween(targetCFrame, speed)
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local hrp = char.HumanoidRootPart
    
    ApplyBodyVelocity(hrp)
    
    local distance = (hrp.Position - targetCFrame.Position).Magnitude
    local time = distance / (speed or 300)
    
    if currentTween then currentTween:Cancel() end
    
    local tweenInfo = TweenInfo.new(time, Enum.EasingStyle.Linear)
    currentTween = TweenService:Create(hrp, tweenInfo, {CFrame = targetCFrame})
    currentTween:Play()
    return currentTween
end

-- 4. Trang bị vũ khí
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

-- [[ VÒNG LẶP FARM CHÍNH ]] --
task.spawn(function()
    while task.wait(0.05) do
        if getgenv().AutoFarmEnabled then
            pcall(function()
                local char = LocalPlayer.Character
                if not char or not char:FindFirstChild("HumanoidRootPart") or char.Humanoid.Health <= 0 then return end
                
                local hrp = char.HumanoidRootPart
                local level = LocalPlayer.Data.Level.Value
                local isQuestActive = LocalPlayer.PlayerGui.Main.Quest.Visible
                
                -- Level 1 - 14 (Bandit Island)
                if level < 15 then
                    if not isQuestActive then
                        -- Bước A: Bay tới sát vạch nhận Quest (Không đứng đè NPC)
                        local questNPCPos = CFrame.new(1059, 16, 1549)
                        if (hrp.Position - questNPCPos.Position).Magnitude > 15 then
                            RedzTween(questNPCPos, 300)
                        else
                            if currentTween then currentTween:Cancel() end
                            -- Bấm nhận Quest & Giải phóng trạng thái nhân vật tức thì
                            CommF:InvokeServer("StartQuest", "BanditQuest1", 1)
                            ForceUnfreeze()
                            
                            -- ĐẨY NHÂN VẬT RA BÃI QUÁI NGAY TẬP TRUNG KHÔNG ĐỢI GAME RESPONSE
                            hrp.CFrame = CFrame.new(1145, 25, 1634)
                            task.wait(0.2)
                        end
                    else
                        -- Bước B: Đã có Quest -> Giải phóng UI & Bay thẳng vào bãi đánh
                        ForceUnfreeze()
                        EquipWeapon()
                        
                        local targetMob = nil
                        for _, v in pairs(workspace.Enemies:GetChildren()) do
                            if (v.Name == "Bandit" or string.find(v.Name, "Bandit")) and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChildOfClass("Humanoid").Health > 0 then
                                targetMob = v
                                break
                            end
                        end
                        
                        if targetMob and targetMob:FindFirstChild("HumanoidRootPart") then
                            ApplyBodyVelocity(hrp)
                            if currentTween then currentTween:Cancel() end
                            
                            -- Bay lên không trung lơ lửng trên quái
                            local safeCFrame = targetMob.HumanoidRootPart.CFrame + Vector3.new(0, getgenv().SafeHeight, 0)
                            hrp.CFrame = safeCFrame
                            
                            -- Gom quái
                            targetMob.HumanoidRootPart.CFrame = safeCFrame - Vector3.new(0, getgenv().SafeHeight, 0)
                            targetMob.HumanoidRootPart.CanCollide = false
                            
                            -- Tự động đánh
                            local tool = char:FindFirstChildOfClass("Tool")
                            if tool then tool:Activate() end
                        else
                            -- Nếu chưa có quái -> Đứng lơ lửng chờ bãi quái
                            RedzTween(CFrame.new(1145, 25, 1634), 250)
                        end
                    end
                end
            end)
        else
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                RemoveBodyVelocity(LocalPlayer.Character.HumanoidRootPart)
            end
            if currentTween then currentTween:Cancel() end
        end
    end
end)

-- Menu Toggle
local Toggle = Tabs.Main:AddToggle("AutoFarmToggle", { Title = "🚀 BẬT AUTO FARM (REAL CORE)", Default = getgenv().AutoFarmEnabled })
Toggle:OnChanged(function(Value)
    getgenv().AutoFarmEnabled = Value
end)

Window:SelectTab(1)
