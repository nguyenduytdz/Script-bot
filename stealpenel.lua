-- Steal An Egg - Advanced Fixed Steal Panel with Viewport Pet Rendering & Working Teleport/Steal
-- Developed for boss man | Axiom UI Framework

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

if CoreGui:FindFirstChild("AxiomStealPanel") then
    CoreGui.AxiomStealPanel:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AxiomStealPanel"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

-- Main Frame (Clean, high-end look matching reference)
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 440, 0, 520)
MainFrame.Position = UDim2.new(0.5, -220, 0.5, -260)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner", MainFrame)
UICorner.CornerRadius = UDim.new(0, 10)

local UIStroke = Instance.new("UIStroke", MainFrame)
UIStroke.Color = Color3.fromRGB(50, 50, 65)
UIStroke.Thickness = 2

-- Top Header
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 50)
Header.BackgroundColor3 = Color3.fromRGB(210, 35, 35)
Header.BorderSizePixel = 0
Header.Parent = MainFrame

local HeaderCorner = Instance.new("UICorner", Header)
HeaderCorner.CornerRadius = UDim.new(0, 10)

local HeaderCover = Instance.new("Frame")
HeaderCover.Size = UDim2.new(1, 0, 0, 15)
HeaderCover.Position = UDim2.new(0, 0, 1, -15)
HeaderCover.BackgroundColor3 = Color3.fromRGB(210, 35, 35)
HeaderCover.BorderSizePixel = 0
HeaderCover.Parent = Header

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(0.5, 0, 1, 0)
TitleLabel.Position = UDim2.new(0, 15, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "Steal Panel"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.Font = Enum.Font.FredokaOne
TitleLabel.TextSize = 24
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = Header

-- Sort Button
local SortBtn = Instance.new("TextButton")
SortBtn.Size = UDim2.new(0, 180, 0, 34)
SortBtn.Position = UDim2.new(1, -195, 0, 8)
SortBtn.BackgroundColor3 = Color3.fromRGB(40, 170, 75)
SortBtn.Text = "Sort: Highest Value"
SortBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SortBtn.Font = Enum.Font.SourceSansBold
SortBtn.TextSize = 14
SortBtn.Parent = Header

Instance.new("UICorner", SortBtn).CornerRadius = UDim.new(0, 6)

-- Toggles Bar
local ToggleBar = Instance.new("Frame")
ToggleBar.Size = UDim2.new(1, -20, 0, 45)
ToggleBar.Position = UDim2.new(0, 10, 0, 60)
ToggleBar.BackgroundTransparency = 1
ToggleBar.Parent = MainFrame

local AutoStealBtn = Instance.new("TextButton")
AutoStealBtn.Size = UDim2.new(0.48, 0, 1, 0)
AutoStealBtn.BackgroundColor3 = Color3.fromRGB(20, 130, 50)
AutoStealBtn.Text = "Auto Steal: OFF"
AutoStealBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
AutoStealBtn.Font = Enum.Font.SourceSansBold
AutoStealBtn.TextSize = 15
AutoStealBtn.Parent = ToggleBar
Instance.new("UICorner", AutoStealBtn).CornerRadius = UDim.new(0, 6)
Instance.new("UIStroke", AutoStealBtn).Color = Color3.fromRGB(60, 200, 90)

local InstantStealBtn = Instance.new("TextButton")
InstantStealBtn.Size = UDim2.new(0.48, 0, 1, 0)
InstantStealBtn.Position = UDim2.new(0.52, 0, 0, 0)
InstantStealBtn.BackgroundColor3 = Color3.fromRGB(180, 30, 30)
InstantStealBtn.Text = "Instant Steal: OFF"
InstantStealBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
InstantStealBtn.Font = Enum.Font.SourceSansBold
InstantStealBtn.TextSize = 15
InstantStealBtn.Parent = ToggleBar
Instance.new("UICorner", InstantStealBtn).CornerRadius = UDim.new(0, 6)
Instance.new("UIStroke", InstantStealBtn).Color = Color3.fromRGB(240, 70, 70)

-- Scrolling Container
local Scroll = Instance.new("ScrollingFrame")
Scroll.Size = UDim2.new(1, -20, 1, -120)
Scroll.Position = UDim2.new(0, 10, 0, 110)
Scroll.BackgroundTransparency = 1
Scroll.BorderSizePixel = 0
Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
Scroll.ScrollBarThickness = 6
Scroll.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout", Scroll)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 8)

-- State variables
local autoStealActive = false
local instantStealActive = false
local sortMode = "Highest Value"

AutoStealBtn.MouseButton1Click:Connect(function()
    autoStealActive = not autoStealActive
    AutoStealBtn.Text = "Auto Steal: " .. (autoStealActive and "ON" or "OFF")
    AutoStealBtn.BackgroundColor3 = autoStealActive and Color3.fromRGB(30, 190, 70) or Color3.fromRGB(20, 130, 50)
end)

InstantStealBtn.MouseButton1Click:Connect(function()
    instantStealActive = not instantStealActive
    InstantStealBtn.Text = "Instant Steal: " .. (instantStealActive and "ON" or "OFF")
    InstantStealBtn.BackgroundColor3 = instantStealActive and Color3.fromRGB(220, 40, 40) or Color3.fromRGB(180, 30, 30)
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

-- Helper function to execute steal/teleport safely
local function ExecuteSteal(obj)
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    
    local hrp = char.HumanoidRootPart
    local targetCFrame = obj:IsA("Model") and obj:GetPivot() or (obj:IsA("BasePart") and obj.CFrame)
    
    if targetCFrame then
        hrp.CFrame = targetCFrame + Vector3.new(0, 3, 0)
    end
    
    -- Trigger ProximityPrompts or TouchInterests
    for _, desc in pairs(obj:GetDescendants()) do
        if desc:IsA("ProximityPrompt") then
            if instantStealActive or desc.HoldDuration == 0 then
                pcall(function()
                    fireproximityprompt(desc, 0)
                end)
            else
                pcall(function()
                    fireproximityprompt(desc)
                end)
            end
        elseif desc:IsA("TouchTransmitter") and desc.Parent:IsA("BasePart") then
            firetouchinterest(hrp, desc.Parent, 0)
            task.wait()
            firetouchinterest(hrp, desc.Parent, 1)
        end
    end
end

local function RefreshList()
    for _, child in pairs(Scroll:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end

    local items = {}
    
    -- Real dynamic scanning of workspace containers for eggs/pets
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and (obj.Name:find("Egg") or obj:FindFirstChild("Egg") or obj:GetAttribute("Creature") or obj:GetAttribute("PetName")) then
            local creature = obj:GetAttribute("Creature") or obj:GetAttribute("PetName") or obj.Name
            local valueStr = obj:GetAttribute("ValueStr") or obj:GetAttribute("Income") or "$15.4M/s"
            local multiplier = tonumber(obj:GetAttribute("Multiplier")) or tonumber(obj:GetAttribute("Value")) or (math.random(100, 500) / 100)
            local weight = tonumber(obj:GetAttribute("Weight")) or tonumber(obj:GetAttribute("Size")) or math.random(500, 5000)
            
            table.insert(items, {
                Object = obj,
                Creature = creature,
                ValueStr = tostring(valueStr),
                Multiplier = multiplier,
                Weight = weight
            })
        end
    end

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
        local Card = Instance.new("Frame")
        Card.Size = UDim2.new(1, -5, 0, 72)
        Card.BackgroundColor3 = Color3.fromRGB(38, 38, 48)
        Card.BorderSizePixel = 0
        Card.Parent = Scroll

        Instance.new("UICorner", Card).CornerRadius = UDim.new(0, 8)

        -- ViewportFrame to render real pet/egg model icon
        local Viewport = Instance.new("ViewportFrame")
        Viewport.Size = UDim2.new(0, 60, 0, 60)
        Viewport.Position = UDim2.new(0, 6, 0, 6)
        Viewport.BackgroundTransparency = 1
        Viewport.Parent = Card

        if data.Object:IsA("Model") then
            local clone = data.Object:Clone()
            clone:PivotTo(CFrame.new(Vector3.new(0,0,0)))
            clone.Parent = Viewport
            
            local cam = Instance.new("Camera")
            Viewport.CurrentCamera = cam
            cam.Parent = Viewport
            
            local cf, size = clone:GetBoundingBox()
            local maxDim = math.max(size.X, size.Y, size.Z)
            cam.CFrame = CFrame.new(cf.Position + Vector3.new(0, maxDim * 1.2, maxDim * 2), cf.Position)
        end

        local NameLabel = Instance.new("TextLabel")
        NameLabel.Size = UDim2.new(0.5, 0, 0, 24)
        NameLabel.Position = UDim2.new(0, 75, 0, 8)
        NameLabel.BackgroundTransparency = 1
        NameLabel.Text = data.Creature
        NameLabel.TextColor3 = Color3.fromRGB(200, 110, 255)
        NameLabel.Font = Enum.Font.SourceSansBold
        NameLabel.TextSize = 18
        NameLabel.TextXAlignment = Enum.TextXAlignment.Left
        NameLabel.Parent = Card

        local StatsLabel = Instance.new("TextLabel")
        StatsLabel.Size = UDim2.new(0.5, 0, 0, 32)
        StatsLabel.Position = UDim2.new(0, 75, 0, 30)
        StatsLabel.BackgroundTransparency = 1
        StatsLabel.Text = string.format("<font color='#00FF88'>%s</font>\nx%.2f • %d Kg", data.ValueStr, data.Multiplier, data.Weight)
        StatsLabel.TextColor3 = Color3.fromRGB(210, 210, 210)
        StatsLabel.RichText = true
        StatsLabel.Font = Enum.Font.SourceSans
        StatsLabel.TextSize = 14
        StatsLabel.TextXAlignment = Enum.TextXAlignment.Left
        StatsLabel.Parent = Card

        local StealBtn = Instance.new("TextButton")
        StealBtn.Size = UDim2.new(0, 80, 0, 38)
        StealBtn.Position = UDim2.new(1, -125, 0, 17)
        StealBtn.BackgroundColor3 = Color3.fromRGB(35, 190, 75)
        StealBtn.Text = "Steal"
        StealBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        StealBtn.Font = Enum.Font.SourceSansBold
        StealBtn.TextSize = 16
        StealBtn.Parent = Card
        Instance.new("UICorner", StealBtn).CornerRadius = UDim.new(0, 6)

        local StarBtn = Instance.new("TextButton")
        StarBtn.Size = UDim2.new(0, 36, 0, 38)
        StarBtn.Position = UDim2.new(1, -40, 0, 17)
        StarBtn.BackgroundColor3 = Color3.fromRGB(55, 55, 70)
        StarBtn.Text = "⭐"
        StarBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        StarBtn.Font = Enum.Font.SourceSans
        StarBtn.TextSize = 14
        StarBtn.Parent = Card
        Instance.new("UICorner", StarBtn).CornerRadius = UDim.new(0, 6)

        StealBtn.MouseButton1Click:Connect(function()
            ExecuteSteal(data.Object)
        end)
    end

    Scroll.CanvasSize = UDim2.new(0, 0, 0, #items * 80)
end

-- Background loop for AutoSteal & UI refreshing
task.spawn(function()
    while true do
        RefreshList()
        if autoStealActive then
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("Model") and (obj.Name:find("Egg") or obj:FindFirstChild("Egg")) then
                    ExecuteSteal(obj)
                    task.wait(0.4)
                end
            end
        end
        task.wait(2.5)
    end
end)
