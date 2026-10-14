-- [[ BLOX FRUIT - FIXED GORILLA & ANTI-FALL ENGINE ]] --

local SuccessUI, Fluent = pcall(function()
    return loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
end)

local Window = Fluent:CreateWindow({
    Title = "Blox Fruits - Fixed Banana Engine",
    SubTitle = "Fixed Level 21 Gorilla & Sea Fall",
    TabWidth = 160,
    Size = UDim2.fromOffset(520, 360),
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.RightControl
})

local Tabs = { Main = Window:AddTab({ Title = "Auto Farm", Icon = "home" }) }

getgenv().AutoFarmEnabled = getgenv().AutoFarmEnabled or false
getgenv().SelectWeapon = "Melee"
getgenv().SafeHeight = 10

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CommF = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_")

-- Anti AFK
LocalPlayer.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
end)

-- 1. Noclip Engine Độc Lập
local NoclipLoop = nil
local function StartPhysicsFix()
    if not NoclipLoop then
        NoclipLoop = RunService.Stepped:Connect(function()
            if getgenv().AutoFarmEnabled and LocalPlayer.Character then
                for _, part in pairs(LocalPlayer.Character:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
                
                local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local bv = hrp:FindFirstChild("BananaBV")
                    if not bv then
                        bv = Instance.new("BodyVelocity")
                        bv.Name = "BananaBV"
                        bv.Velocity = Vector3.new(0, 0, 0)
                        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                        bv.Parent = hrp
                    end
                end
            end
        end)
    end
end

local function StopPhysicsFix()
    if NoclipLoop then
        NoclipLoop:Disconnect()
        NoclipLoop = nil
    end
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local bv = LocalPlayer.Character.HumanoidRootPart:FindFirstChild("BananaBV")
        if bv then bv:Destroy() end
    end
end

-- 2. Di chuyển Smooth (Tránh văng biển)
local currentTween = nil
local function DirectMove(targetCFrame)
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local hrp = char.HumanoidRootPart
    
    StartPhysicsFix()
    
    local dist = (hrp.Position - targetCFrame.Position).Magnitude
    if dist < 5 then
        if currentTween then currentTween:Cancel() currentTween = nil end
        hrp.CFrame = targetCFrame
        return
    end
    
    local duration = dist / 300
    if currentTween then currentTween:Cancel() end
    
    currentTween = TweenService:Create(hrp, TweenInfo.new(duration, Enum.EasingStyle.Linear), {CFrame = targetCFrame})
    currentTween:Play()
end

-- 3. Tự cầm vũ khí
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

-- 4. Bảng Tọa Độ Chuẩn Xác Của Game (Đã fix bãi Gorilla)
local function GetCurrentQuest()
    local level = LocalPlayer.Data.Level.Value
    
    if level >= 1 and level <= 14 then
        return "BanditQuest1", 1, CFrame.new(1059, 16, 1549), "Bandit", CFrame.new(1145, 25, 1634)
    elseif level >= 15 and level <= 19 then
        return "JungleQuest", 1, CFrame.new(-1598, 36, 153), "Monkey", CFrame.new(-1618, 22, 143)
    elseif level >= 20 and level <= 29 then
        -- TOẠ ĐỘ GORILLA CHUẨN TRÊN ĐẢO KHỈ
        return "JungleQuest", 2, CFrame.new(-1598, 36, 153), "Gorilla", CFrame.new(-1230, 15, -490)
    elseif level >= 30 and level <= 59 then
        return "BuggyQuest1", 1, CFrame.new(-1140, 4, 3828), "Pirate", CFrame.new(-1215, 4, 3915)
    end
    return nil
end

-- 5. Loop Farm Chính
task.spawn(function()
    while task.wait(0.1) do
        if getgenv().AutoFarmEnabled then
            pcall(function()
                local char = LocalPlayer.Character
                if not char or not char:FindFirstChild("HumanoidRootPart") or char.Humanoid.Health <= 0 then return end
                
                local hrp = char.HumanoidRootPart
                local isQuestActive = LocalPlayer.PlayerGui.Main.Quest.Visible
                
                local qName, qLevel, qNPCPos, mobName, mobPos = GetCurrentQuest()
                
                if qName then
                    if not isQuestActive then
                        -- Bay đi nhận Quest
                        if (hrp.Position - qNPCPos.Position).Magnitude > 12 then
                            DirectMove(qNPCPos)
                        else
                            if currentTween then currentTween:Cancel() currentTween = nil end
                            CommF:InvokeServer("StartQuest", qName, qLevel)
                            task.wait(0.2)
                        end
                    else
                        -- Đã có Quest -> Bay đánh quái Gorilla
                        EquipWeapon()
                        
                        local targetMob = nil
                        for _, v in pairs(workspace.Enemies:GetChildren()) do
                            if (v.Name == mobName or string.find(v.Name, mobName)) and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChildOfClass("Humanoid").Health > 0 then
                                targetMob = v
                                break
                            end
                        end
                        
                        if targetMob and targetMob:FindFirstChild("HumanoidRootPart") then
                            StartPhysicsFix()
                            
                            local safePos = targetMob.HumanoidRootPart.CFrame * CFrame.new(0, getgenv().SafeHeight, 0)
                            
                            if (hrp.Position - safePos.Position).Magnitude > 8 then
                                DirectMove(safePos)
                            else
                                if currentTween then currentTween:Cancel() currentTween = nil end
                                hrp.CFrame = safePos
                                
                                -- Gom quái & Đánh
                                targetMob.HumanoidRootPart.CFrame = safePos * CFrame.new(0, -getgenv().SafeHeight, 0)
                                targetMob.HumanoidRootPart.CanCollide = false
                                
                                VirtualUser:Button1Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
                                local tool = char:FindFirstChildOfClass("Tool")
                                if tool then tool:Activate() end
                            end
                        else
                            -- Bay đến chờ ở bãi Gorilla
                            DirectMove(mobPos * CFrame.new(0, getgenv().SafeHeight, 0))
                        end
                    end
                end
            end)
        else
            StopPhysicsFix()
            if currentTween then currentTween:Cancel() currentTween = nil end
        end
    end
end)

-- UI
local WeaponDropdown = Tabs.Main:AddDropdown("WeaponSelect", {
    Title = "Chọn vũ khí",
    Values = {"Melee", "Sword", "Blox Fruit"},
    Default = "Melee",
    Callback = function(Value) getgenv().SelectWeapon = Value end
})

local Toggle = Tabs.Main:AddToggle("AutoFarmToggle", { Title = "🚀 BẬT AUTO FARM (FIX FALL SEA)", Default = getgenv().AutoFarmEnabled })
Toggle:OnChanged(function(Value) getgenv().AutoFarmEnabled = Value end)

Window:SelectTab(1)
