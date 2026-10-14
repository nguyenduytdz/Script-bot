-- [[ BLOX FRUIT - CUSTOM SCRIPT (FIXED LEVEL 1-29) ]] --

local SuccessUI, Fluent = pcall(function()
    return loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
end)

local Window = Fluent:CreateWindow({
    Title = "Blox Fruits - Pro Custom Farm",
    SubTitle = "Fixed Level 1-29 Logic",
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
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CommF = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_")

-- [[ 1. METAMETHOD HOOK BYPASS - CHẶN SERVER KHÓA CHUYỂN ĐỘNG ]] --
local rawmetatable = getrawmetatable(game)
local oldNamecall = rawmetatable.__namecall
setreadonly(rawmetatable, false)

rawmetatable.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    
    if tostring(method) == "FireServer" or tostring(method) == "InvokeServer" then
        if self.Name == "CommF_" and args[1] == "StartQuest" then
            task.spawn(function()
                task.wait(0.05)
                pcall(function()
                    if LocalPlayer.PlayerGui.Main:FindFirstChild("Dialogue") then
                        LocalPlayer.PlayerGui.Main.Dialogue.Visible = false
                    end
                end)
            end)
        end
    end
    return oldNamecall(self, ...)
end)
setreadonly(rawmetatable, true)

-- [[ 2. NOCLIP & MOVEMENT ENGINE ]] --
local NoclipConnection = nil
local function EnableNoclip()
    if not NoclipConnection then
        NoclipConnection = RunService.Stepped:Connect(function()
            if getgenv().AutoFarmEnabled and LocalPlayer.Character then
                for _, part in pairs(LocalPlayer.Character:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    end
end

local function DisableNoclip()
    if NoclipConnection then
        NoclipConnection:Disconnect()
        NoclipConnection = nil
    end
end

local function ApplyBodyVelocity(hrp)
    if not hrp:FindFirstChild("BananaVelocity") then
        local bv = Instance.new("BodyVelocity")
        bv.Name = "BananaVelocity"
        bv.Velocity = Vector3.new(0, 0, 0)
        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bv.Parent = hrp
    end
end

local currentTween = nil
local function BananaTween(targetCFrame, speed)
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local hrp = char.HumanoidRootPart
    
    ApplyBodyVelocity(hrp)
    EnableNoclip()
    
    local distance = (hrp.Position - targetCFrame.Position).Magnitude
    local duration = distance / (speed or 300)
    
    if currentTween then currentTween:Cancel() end
    
    local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear)
    currentTween = TweenService:Create(hrp, tweenInfo, {CFrame = targetCFrame})
    currentTween:Play()
    return currentTween
end

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

-- [[ 3. VÒNG LẶP AUTO FARM CHÍNH (ĐÃ THÊM MỐC LEVEL 15+) ]] --
task.spawn(function()
    while task.wait(0.05) do
        if getgenv().AutoFarmEnabled then
            pcall(function()
                local char = LocalPlayer.Character
                if not char or not char:FindFirstChild("HumanoidRootPart") or char.Humanoid.Health <= 0 then return end
                
                local hrp = char.HumanoidRootPart
                local level = LocalPlayer.Data.Level.Value
                local isQuestActive = LocalPlayer.PlayerGui.Main.Quest.Visible
                
                local questName, questLevel, npcPos, mobName, mobSpawnPos
                
                -- Phân chia nhiệm vụ theo Cấp độ
                if level >= 1 and level <= 14 then
                    questName, questLevel = "BanditQuest1", 1
                    npcPos = CFrame.new(1059, 16, 1549)
                    mobName = "Bandit"
                    mobSpawnPos = CFrame.new(1145, 25, 1634)
                elseif level >= 15 and level <= 29 then
                    questName, questLevel = "JungleQuest", 1
                    npcPos = CFrame.new(-1598, 36, 153)
                    mobName = "Monkey"
                    mobSpawnPos = CFrame.new(-1618, 22, 143)
                end
                
                if questName then
                    if not isQuestActive then
                        if (hrp.Position - npcPos.Position).Magnitude > 12 then
                            BananaTween(npcPos, 300)
                        else
                            if currentTween then currentTween:Cancel() end
                            CommF:InvokeServer("StartQuest", questName, questLevel)
                            
                            -- Đẩy vị trí đệm ra xa NPC để nhận nhiệm vụ thành công
                            hrp.CFrame = mobSpawnPos
                            task.wait(0.1)
                        end
                    else
                        EquipWeapon()
                        local targetMob = nil
                        for _, v in pairs(workspace.Enemies:GetChildren()) do
                            if (v.Name == mobName or string.find(v.Name, mobName)) and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChildOfClass("Humanoid").Health > 0 then
                                targetMob = v
                                break
                            end
                        end
                        
                        if targetMob and targetMob:FindFirstChild("HumanoidRootPart") then
                            ApplyBodyVelocity(hrp)
                            EnableNoclip()
                            if currentTween then currentTween:Cancel() end
                            
                            local safePos = targetMob.HumanoidRootPart.CFrame + Vector3.new(0, getgenv().SafeHeight, 0)
                            hrp.CFrame = safePos
                            
                            targetMob.HumanoidRootPart.CFrame = safePos - Vector3.new(0, getgenv().SafeHeight, 0)
                            targetMob.HumanoidRootPart.CanCollide = false
                            
                            local tool = char:FindFirstChildOfClass("Tool")
                            if tool then tool:Activate() end
                        else
                            BananaTween(mobSpawnPos, 280)
                        end
                    end
                end
            end)
        else
            DisableNoclip()
            if currentTween then currentTween:Cancel() end
        end
    end
end)

-- Toggle Menu
local Toggle = Tabs.Main:AddToggle("AutoFarmToggle", { Title = "🚀 BẬT AUTO FARM (FIXED LVL 15)", Default = getgenv().AutoFarmEnabled })
Toggle:OnChanged(function(Value)
    getgenv().AutoFarmEnabled = Value
end)

Window:SelectTab(1)
