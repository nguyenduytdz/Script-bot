-- [[ BLOX FRUIT - FIXED RUBBERBAND & AUTO ATTACK ENGINE ]] --

local SuccessUI, Fluent = pcall(function()
    return loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
end)

local Window = Fluent:CreateWindow({
    Title = "Blox Fruits - Pro Farm Engine",
    SubTitle = "Fixed Rubberband & Auto Attack",
    TabWidth = 160,
    Size = UDim2.fromOffset(520, 360),
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.RightControl
})

local Tabs = { Main = Window:AddTab({ Title = "Auto Farm", Icon = "home" }) }

getgenv().AutoFarmEnabled = getgenv().AutoFarmEnabled or false
getgenv().SelectWeapon = "Melee"
getgenv().SafeHeight = 12

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CommF = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_")

-- [[ 1. GIẢ LẬP ĐÁNH LIÊN TỤC (PREVENT AFK & AUTO ATTACK) ]] --
LocalPlayer.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
end)

-- [[ 2. NOCLIP & KHÔNG TRỌNG LỰC CHUẨN BANANA HUB ]] --
local SteppedConnection = nil
local function StartNoclipEngine()
    if not SteppedConnection then
        SteppedConnection = RunService.Stepped:Connect(function()
            if getgenv().AutoFarmEnabled and LocalPlayer.Character then
                for _, part in pairs(LocalPlayer.Character:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
                
                local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local bv = hrp:FindFirstChild("FarmVelocity")
                    if not bv then
                        bv = Instance.new("BodyVelocity")
                        bv.Name = "FarmVelocity"
                        bv.Velocity = Vector3.new(0, 0, 0)
                        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                        bv.Parent = hrp
                    end
                end
            end
        end)
    end
end

local function StopNoclipEngine()
    if SteppedConnection then
        SteppedConnection:Disconnect()
        SteppedConnection = nil
    end
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local bv = LocalPlayer.Character.HumanoidRootPart:FindFirstChild("FarmVelocity")
        if bv then bv:Destroy() end
    end
end

-- [[ 3. TWEEN DI CHUYỂN KHÔNG BỊ GIẬT LÙI ]] --
local currentTween = nil
local function SmoothMove(targetCFrame, speed)
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local hrp = char.HumanoidRootPart
    
    StartNoclipEngine()
    
    local distance = (hrp.Position - targetCFrame.Position).Magnitude
    if distance < 8 then
        if currentTween then currentTween:Cancel() currentTween = nil end
        hrp.CFrame = targetCFrame
        return
    end
    
    local duration = distance / (speed or 300)
    if currentTween then currentTween:Cancel() end
    
    local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear)
    currentTween = TweenService:Create(hrp, tweenInfo, {CFrame = targetCFrame})
    currentTween:Play()
    return currentTween
end

local function EquipWeapon()
    local char = LocalPlayer.Character
    if not char then return end
    local currentTool = char:FindFirstChildOfClass("Tool")
    if not currentTool or (currentTool and currentTool.ToolTip ~= getgenv().SelectWeapon) then
        local backpack = LocalPlayer:FindFirstChild("Backpack")
        if backpack then
            for _, tool in pairs(backpack:GetChildren()) do
                if tool:IsA("Tool") and (tool.ToolTip == getgenv().SelectWeapon or string.find(tool.Name, getgenv().SelectWeapon)) then
                    char.Humanoid:EquipTool(tool)
                    break
                end
            end
        end
    end
end

-- [[ 4. BẢNG DỮ LIỆU CẤP ĐỘ FULL SEA 1 ]] --
local function GetQuestData()
    local level = LocalPlayer.Data.Level.Value
    
    if level >= 1 and level <= 14 then
        return "BanditQuest1", 1, CFrame.new(1059, 16, 1549), "Bandit", CFrame.new(1145, 25, 1634)
    elseif level >= 15 and level <= 19 then
        return "JungleQuest", 1, CFrame.new(-1598, 36, 153), "Monkey", CFrame.new(-1618, 22, 143)
    elseif level >= 20 and level <= 29 then
        return "JungleQuest", 2, CFrame.new(-1598, 36, 153), "Gorilla", CFrame.new(-1240, 6, -493)
    elseif level >= 30 and level <= 39 then
        return "BuggyQuest1", 1, CFrame.new(-1140, 4, 3828), "Pirate", CFrame.new(-1215, 4, 3915)
    elseif level >= 40 and level <= 59 then
        return "BuggyQuest1", 2, CFrame.new(-1140, 4, 3828), "Brute", CFrame.new(-1145, 15, 4350)
    elseif level >= 60 and level <= 89 then
        return "DesertQuest", 1, CFrame.new(894, 6, 4390), "Desert Bandit", CFrame.new(932, 6, 4485)
    elseif level >= 90 and level <= 99 then
        return "DesertQuest", 2, CFrame.new(894, 6, 4390), "Desert Officer", CFrame.new(1572, 10, 4374)
    elseif level >= 100 and level <= 119 then
        return "SnowQuest", 1, CFrame.new(1385, 87, -1298), "Snow Bandit", CFrame.new(1285, 105, -1342)
    elseif level >= 120 and level <= 149 then
        return "SnowQuest", 2, CFrame.new(1385, 87, -1298), "Snowman", CFrame.new(1285, 105, -1342)
    elseif level >= 150 and level <= 189 then
        return "MarineQuest2", 1, CFrame.new(-5030, 20, 4322), "Chief Petty Officer", CFrame.new(-4850, 20, 4300)
    elseif level >= 190 and level <= 249 then
        return "SkyQuest", 1, CFrame.new(-4840, 717, -2620), "Sky Bandit", CFrame.new(-4980, 717, -2830)
    elseif level >= 250 and level <= 299 then
        return "PrisonerQuest", 1, CFrame.new(530, 1, 475), "Prisoner", CFrame.new(500, 1, 600)
    elseif level >= 300 and level <= 374 then
        return "ColosseumQuest", 1, CFrame.new(-1580, 7, -2980), "Toga Warrior", CFrame.new(-1800, 7, -2900)
    elseif level >= 375 and level <= 449 then
        return "MagmaQuest", 1, CFrame.new(-5230, 8, 8450), "Military Soldier", CFrame.new(-5400, 8, 8500)
    elseif level >= 450 and level <= 524 then
        return "UnderwaterQuest", 1, CFrame.new(61160, 18, 1560), "Fishman Warrior", CFrame.new(61100, 18, 1400)
    elseif level >= 525 and level <= 624 then
        return "SkyQuest2", 1, CFrame.new(-7900, 5545, -380), "God's Guard", CFrame.new(-7700, 5545, -400)
    elseif level >= 625 and level <= 699 then
        return "FountainQuest", 1, CFrame.new(5250, 38, 4050), "Galley Pirate", CFrame.new(5500, 38, 3950)
    end
    return nil
end

-- [[ 5. VÒNG LẶP CHÍNH CÓ KIỂM SOÁT TỐC ĐỘ ]] --
task.spawn(function()
    while task.wait(0.1) do
        if getgenv().AutoFarmEnabled then
            pcall(function()
                local char = LocalPlayer.Character
                if not char or not char:FindFirstChild("HumanoidRootPart") or char.Humanoid.Health <= 0 then return end
                
                local hrp = char.HumanoidRootPart
                local isQuestActive = LocalPlayer.PlayerGui.Main.Quest.Visible
                
                local questName, questLevel, npcPos, mobName, mobSpawnPos = GetQuestData()
                
                if questName then
                    if not isQuestActive then
                        -- Bay từ từ tới NPC nhận Quest
                        if (hrp.Position - npcPos.Position).Magnitude > 12 then
                            SmoothMove(npcPos, 300)
                        else
                            if currentTween then currentTween:Cancel() currentTween = nil end
                            CommF:InvokeServer("StartQuest", questName, questLevel)
                            task.wait(0.2)
                        end
                    else
                        -- Đã có Quest -> Bay tới bãi quái & Đánh
                        EquipWeapon()
                        
                        local targetMob = nil
                        for _, v in pairs(workspace.Enemies:GetChildren()) do
                            if (v.Name == mobName or string.find(v.Name, mobName)) and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChildOfClass("Humanoid").Health > 0 then
                                targetMob = v
                                break
                            end
                        end
                        
                        if targetMob and targetMob:FindFirstChild("HumanoidRootPart") then
                            StartNoclipEngine()
                            
                            local safePos = targetMob.HumanoidRootPart.CFrame * CFrame.new(0, getgenv().SafeHeight, 0)
                            
                            -- Nếu cách xa quái thì bay lại gần, nếu đã gần thì khóa vị trí lơ lửng
                            if (hrp.Position - safePos.Position).Magnitude > 10 then
                                SmoothMove(safePos, 320)
                            else
                                if currentTween then currentTween:Cancel() currentTween = nil end
                                hrp.CFrame = safePos
                                
                                -- Gom quái
                                targetMob.HumanoidRootPart.CFrame = safePos * CFrame.new(0, -getgenv().SafeHeight, 0)
                                targetMob.HumanoidRootPart.CanCollide = false
                                
                                -- Kích hoạt đòn đánh (Virtual Click)
                                VirtualUser:Button1Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
                                local tool = char:FindFirstChildOfClass("Tool")
                                if tool then tool:Activate() end
                            end
                        else
                            -- Nếu chưa có quái -> Bay lơ lửng ở bãi quái chờ quái hồi sinh
                            SmoothMove(mobSpawnPos * CFrame.new(0, getgenv().SafeHeight, 0), 280)
                        end
                    end
                end
            end)
        else
            StopNoclipEngine()
            if currentTween then currentTween:Cancel() currentTween = nil end
        end
    end
end)

-- UI CONTROLS
local WeaponDropdown = Tabs.Main:AddDropdown("WeaponSelect", {
    Title = "Chọn vũ khí",
    Values = {"Melee", "Sword", "Blox Fruit"},
    Default = "Melee",
    Callback = function(Value) getgenv().SelectWeapon = Value end
})

local Toggle = Tabs.Main:AddToggle("AutoFarmToggle", { Title = "🚀 BẬT AUTO FARM FIXED", Default = getgenv().AutoFarmEnabled })
Toggle:OnChanged(function(Value) getgenv().AutoFarmEnabled = Value end)

Window:SelectTab(1)
