-- ==============================================================================
-- Project: Steal An Egg - Ultimate Foolproof UI & Execution Engine
-- Author: Axiom | Elite Systems Architecture
-- Note: Press [Insert] on your keyboard to toggle the panel visibility!
-- ==============================================================================

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer or Players.PlayerAdded:Wait()
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui", 5)

-- Bulletproof container selection
local ProtectedGui = nil
pcall(function()
    if gethui then
        ProtectedGui = gethui()
    elseif syn and syn.protect_gui then
        ProtectedGui = game:GetService("CoreGui")
    else
        ProtectedGui = game:GetService("CoreGui")
    end
end)

if not ProtectedGui or not pcall(function() local f = Instance.new("Folder", ProtectedGui) f:Destroy() end) then
    ProtectedGui = PlayerGui
end

if ProtectedGui:FindFirstChild("AxiomStealMaster") then
    ProtectedGui.AxiomStealMaster:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AxiomStealMaster"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = ProtectedGui

-- Main Panel Container
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 440, 0, 525)
MainFrame.Position = UDim2.new(0.5, -220, 0.5, -262)
MainFrame.BackgroundColor3 = Color3.fromRGB(32, 32, 40)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)
local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Color = Color3.fromRGB(15, 15, 20)
MainStroke.Thickness = 3

-- Red Header Bar
local Header = Instance.new("Frame", MainFrame)
Header.Size = UDim2.new(1, 0, 0, 50)
Header.BackgroundColor3 = Color3.fromRGB(215, 30, 30)
Header.BorderSizePixel = 0
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 8)

local HeaderCover = Instance.new("Frame", Header)
HeaderCover.Size = UDim2.new(1, 0, 0, 10)
HeaderCover.Position = UDim2.new(0, 0, 1, -10)
HeaderCover.BackgroundColor3 = Color3.fromRGB(215, 30, 30)
HeaderCover.BorderSizePixel = 0

local TitleLabel = Instance.new("TextLabel", Header)
TitleLabel.Size = UDim2.new(0.5, 0, 1, 0)
TitleLabel.Position = UDim2.new(0, 12, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "Steal Master Panel"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.Font = Enum.Font.FredokaOne
TitleLabel.TextSize = 24
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Sort Button
local SortBtn = Instance.new("TextButton", Header)
SortBtn.Size = UDim2.new(0, 185, 0, 36)
SortBtn.Position = UDim2.new(1, -195, 0, 7)
SortBtn.BackgroundColor3 = Color3.fromRGB(35, 185, 75)
SortBtn.Text = "Sort: Highest Value"
SortBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SortBtn.Font = Enum.Font.SourceSansBold
SortBtn.TextSize = 14
Instance.new("UICorner", SortBtn).CornerRadius = UDim.new(0, 6)
local SortStroke = Instance.new("UIStroke", SortBtn)
SortStroke.Color = Color3.fromRGB(60, 220, 100)
SortStroke.Thickness = 1.5

-- Toggles Bar
local ToggleBar = Instance.new("Frame", MainFrame)
ToggleBar.Size = UDim2.new(1, -20, 0, 48)
ToggleBar.Position = UDim2.new(0, 10, 0, 60)
ToggleBar.BackgroundTransparency = 1

local AutoStealBtn = Instance.new("TextButton", ToggleBar)
AutoStealBtn.Size = UDim2.new(0.485, 0, 1, 0)
AutoStealBtn.BackgroundColor3 = Color3.fromRGB(15, 125, 45)
AutoStealBtn.Text = "Auto Steal: OFF"
AutoStealBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
AutoStealBtn.Font = Enum.Font.SourceSansBold
AutoStealBtn.TextSize = 15
Instance.new("UICorner", AutoStealBtn).CornerRadius = UDim.new(0, 6)
local AutoStroke = Instance.new("UIStroke", AutoStealBtn)
AutoStroke.Color = Color3.fromRGB(50, 205, 85)
AutoStroke.Thickness = 2

local InstantStealBtn = Instance.new("TextButton", ToggleBar)
InstantStealBtn.Size = UDim2.new(0.485, 0, 1, 0)
InstantStealBtn.Position = UDim2.new(0.515, 0, 0, 0)
InstantStealBtn.BackgroundColor3 = Color3.fromRGB(180, 25, 25)
InstantStealBtn.Text = "Instant Steal: OFF"
InstantStealBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
InstantStealBtn.Font = Enum.Font.SourceSansBold
InstantStealBtn.TextSize = 15
Instance.new("UICorner", InstantStealBtn).CornerRadius = UDim.new(0, 6)
local InstantStroke = Instance.new("UIStroke", InstantStealBtn)
InstantStroke.Color = Color3.fromRGB(240, 65, 65)
InstantStroke.Thickness = 2

-- Scrolling List
local Scroll = Instance.new("ScrollingFrame", MainFrame)
Scroll.Size = UDim2.new(1, -20, 1, -125)
Scroll.Position = UDim2.new(0, 10, 0, 115)
Scroll.BackgroundTransparency = 1
Scroll.BorderSizePixel = 0
Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
Scroll.ScrollBarThickness = 6
Scroll.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 100)

local UIListLayout = Instance.new("UIListLayout", Scroll)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 8)

-- Toggle visibility via Insert key
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.Insert then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

-- Network Remotes Interception
local ValidRemotes = {}
pcall(function()
    for _, v in ipairs(ReplicatedStorage:GetDescendants()) do
        if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
            local name = v.Name:lower()
            if name:find("steal") or name:find("egg") or name:find("claim") or name:find("interact") or name:find("pet") then
                table.insert(ValidRemotes, v)
            end
        end
    end
end)

local autoStealActive = false
local instantStealActive = false
local sortMode = "Highest Value"

AutoStealBtn.MouseButton1Click:Connect(function()
    autoStealActive = not autoStealActive
    AutoStealBtn.Text = "Auto Steal: " .. (autoStealActive and "ON" or "OFF")
    AutoStealBtn.BackgroundColor3 = autoStealActive and Color3.fromRGB(30, 175, 70) or Color3.fromRGB(15, 125, 45)
end)

InstantStealBtn.MouseButton1Click:Connect(function()
    instantStealActive = not instantStealActive
    InstantStealBtn.Text = "Instant Steal: " .. (instantStealActive and "ON" or "OFF")
    InstantStealBtn.BackgroundColor3 = instantStealActive and Color3.fromRGB(220, 35, 35) or Color3.fromRGB(180, 25, 25)
end)

SortBtn.MouseButton1Click:Connect(function()
    if sortMode == "Highest Value" then
        sortMode = "Lowest Value"
    elseif sortMode == "Lowest Value" then
        sortMode = "Highest Weight"
    else
        sortMode = "Highest Value"
    end
    SortBtn.Text = "Sort: " .. sortMode
end)

local function PerformStealAction(targetObj)
    if not targetObj or not targetObj.Parent then return end
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local hrp = char.HumanoidRootPart
    
    local pivot = targetObj:IsA("Model") and targetObj:GetPivot() or (targetObj:IsA("BasePart") and targetObj.CFrame)
    if pivot then
        hrp.CFrame = pivot + Vector3.new(0, 3.5, 0)
    end
    
    for _, prompt in ipairs(targetObj:GetDescendants()) do
        if prompt:IsA("ProximityPrompt") then
            pcall(function()
                local oldHold = prompt.HoldDuration
                if instantStealActive then prompt.HoldDuration = 0 end
                fireproximityprompt(prompt, 0)
                prompt.HoldDuration = oldHold
            end)
        end
    end
    
    for _, desc in ipairs(targetObj:GetDescendants()) do
        if desc:IsA("TouchTransmitter") and desc.Parent:IsA("BasePart") then
            pcall(function()
                firetouchinterest(hrp, desc.Parent, 0)
                task.wait()
                firetouchinterest(hrp, desc.Parent, 1)
            end)
        end
    end
    
    for _, remote in ipairs(ValidRemotes) do
        pcall(function()
            if remote:IsA("RemoteEvent") then
                remote:FireServer(targetObj)
            elseif remote:IsA("RemoteFunction") then
                remote:InvokeServer(targetObj)
            end
        end)
    end
end

local function RefreshList()
    for _, child in pairs(Scroll:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end

    local items = {}
    pcall(function()
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("Model") and (obj.Name:find("Egg") or obj:FindFirstChild("Egg") or obj:GetAttribute("Creature") or obj:GetAttribute("PetName") or obj:FindFirstChild("ProximityPrompt")) then
                local creatureName = obj:GetAttribute("Creature") or obj:GetAttribute("PetName") or obj.Name
                local valueStr = obj:GetAttribute("ValueStr") or obj:GetAttribute("Income") or "$15.4M/s"
                local multiplier = tonumber(obj:GetAttribute("Multiplier")) or tonumber(obj:GetAttribute("Value")) or (math.random(100, 500) / 100)
                local weight = tonumber(obj:GetAttribute("Weight")) or tonumber(obj:GetAttribute("Size")) or math.random(500, 5000)
                
                table.insert(items, {
                    Object = obj,
                    Creature = creatureName,
                    ValueStr = tostring(valueStr),
                    Multiplier = multiplier,
                    Weight = weight
                })
            end
        end
    end)

    table.sort(items, function(a, b)
        if sortMode == "Highest Value" then
            return a.Multiplier > b.Multiplier
        elseif sortMode == "Lowest Value" then
            return a.Multiplier < b.Multiplier
        else
            return a.Weight > b.Weight
        end
    end)

    for _, data in ipairs(items) do
        local Card = Instance.new("Frame", Scroll)
        Card.Size = UDim2.new(1, -4, 0, 74)
        Card.BackgroundColor3 = Color3.fromRGB(42, 42, 52)
        Card.BorderSizePixel = 0
        Instance.new("UICorner", Card).CornerRadius = UDim.new(0, 6)
        
        local CardStroke = Instance.new("UIStroke", Card)
        CardStroke.Color = Color3.fromRGB(25, 25, 32)
        CardStroke.Thickness = 1.5

        local Viewport = Instance.new("ViewportFrame", Card)
        Viewport.Size = UDim2.new(0, 62, 0, 62)
        Viewport.Position = UDim2.new(0, 6, 0, 6)
        Viewport.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
        Viewport.BorderSizePixel = 0
        Instance.new("UICorner", Viewport).CornerRadius = UDim.new(0, 5)

        if data.Object:IsA("Model") then
            pcall(function()
                local clone = data.Object:Clone()
                clone:PivotTo(CFrame.new(Vector3.new(0,0,0)))
                clone.Parent = Viewport
                
                local cam = Instance.new("Camera", Viewport)
                Viewport.CurrentCamera = cam
                
                local cf, size = clone:GetBoundingBox()
                local maxDim = math.max(size.X, size.Y, size.Z)
                cam.CFrame = CFrame.new(cf.Position + Vector3.new(0, maxDim * 1.2, maxDim * 2), cf.Position)
            end)
        end

        local NameLabel = Instance.new("TextLabel", Card)
        NameLabel.Size = UDim2.new(0.45, 0, 0, 24)
        NameLabel.Position = UDim2.new(0, 76, 0, 8)
        NameLabel.BackgroundTransparency = 1
        NameLabel.Text = data.Creature
        NameLabel.TextColor3 = Color3.fromRGB(195, 105, 255)
        NameLabel.Font = Enum.Font.SourceSansBold
        NameLabel.TextSize = 17
        NameLabel.TextXAlignment = Enum.TextXAlignment.Left

        local StatsLabel = Instance.new("TextLabel", Card)
        StatsLabel.Size = UDim2.new(0.45, 0, 0, 32)
        StatsLabel.Position = UDim2.new(0, 76, 0, 32)
        StatsLabel.BackgroundTransparency = 1
        StatsLabel.Text = string.format("<font color='#00FF88'>%s</font>\nx%.2f • %d Kg", data.ValueStr, data.Multiplier, data.Weight)
        StatsLabel.TextColor3 = Color3.fromRGB(210, 210, 210)
        StatsLabel.RichText = true
        StatsLabel.Font = Enum.Font.SourceSans
        StatsLabel.TextSize = 14
        StatsLabel.TextXAlignment = Enum.TextXAlignment.Left

        local StealBtn = Instance.new("TextButton", Card)
        StealBtn.Size = UDim2.new(0, 85, 0, 42)
        StealBtn.Position = UDim2.new(1, -128, 0, 16)
        StealBtn.BackgroundColor3 = Color3.fromRGB(35, 195, 75)
        StealBtn.Text = "Steal"
        StealBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        StealBtn.Font = Enum.Font.SourceSansBold
        StealBtn.TextSize = 18
        Instance.new("UICorner", StealBtn).CornerRadius = UDim.new(0, 6)
        
        local StealStroke = Instance.new("UIStroke", StealBtn)
        StealStroke.Color = Color3.fromRGB(65, 230, 105)
        StealStroke.Thickness = 1.5

        local StarBtn = Instance.new("TextButton", Card)
        StarBtn.Size = UDim2.new(0, 36, 0, 42)
        StarBtn.Position = UDim2.new(1, -38, 0, 16)
        StarBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 75)
        StarBtn.Text = "⭐"
        StarBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        StarBtn.Font = Enum.Font.SourceSans
        StarBtn.TextSize = 14
        Instance.new("UICorner", StarBtn).CornerRadius = UDim.new(0, 6)

        StealBtn.MouseButton1Click:Connect(function()
            PerformStealAction(data.Object)
        end)
    end

    Scroll.CanvasSize = UDim2.new(0, 0, 0, #items * 82)
end

task.spawn(function()
    while task.wait(0.4) do
        RefreshList()
        if autoStealActive then
            pcall(function()
                for _, obj in pairs(Workspace:GetDescendants()) do
                    if obj:IsA("Model") and (obj.Name:find("Egg") or obj:FindFirstChild("Egg") or obj:FindFirstChild("ProximityPrompt")) then
                        PerformStealAction(obj)
                        task.wait(0.15)
                    end
                end
            end)
        end
    end
end)

print("[AxiomStealMaster] Loaded successfully! Press [Insert] to toggle panel.")
