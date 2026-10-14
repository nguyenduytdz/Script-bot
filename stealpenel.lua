-- Steal An Egg - Advanced Steal Panel (UI Replica & Enhancements)
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

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 420, 0, 500)
MainFrame.Position = UDim2.new(0.5, -210, 0.5, -250)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner", MainFrame)
UICorner.CornerRadius = UDim.new(0, 8)

local UIStroke = Instance.new("UIStroke", MainFrame)
UIStroke.Color = Color3.fromRGB(60, 60, 75)
UIStroke.Thickness = 2

-- Top Header
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 45)
Header.BackgroundColor3 = Color3.fromRGB(180, 30, 30)
Header.BorderSizePixel = 0
Header.Parent = MainFrame

local HeaderCorner = Instance.new("UICorner", Header)
HeaderCorner.CornerRadius = UDim.new(0, 8)

local HeaderCover = Instance.new("Frame")
HeaderCover.Size = UDim2.new(1, 0, 0, 10)
HeaderCover.Position = UDim2.new(0, 0, 1, -10)
HeaderCover.BackgroundColor3 = Color3.fromRGB(180, 30, 30)
HeaderCover.BorderSizePixel = 0
HeaderCover.Parent = Header

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(0.5, 0, 1, 0)
TitleLabel.Position = UDim2.new(0, 10, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "Steal Panel"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.Font = Enum.Font.FredokaOne
TitleLabel.TextSize = 22
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = Header

-- Sort Button
local SortBtn = Instance.new("TextButton")
SortBtn.Size = UDim2.new(0, 170, 0, 32)
SortBtn.Position = UDim2.new(1, -180, 0, 6.5)
SortBtn.BackgroundColor3 = Color3.fromRGB(50, 180, 80)
SortBtn.Text = "Sort: Highest Value"
SortBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SortBtn.Font = Enum.Font.SourceSansBold
SortBtn.TextSize = 14
SortBtn.Parent = Header

local SortCorner = Instance.new("UICorner", SortBtn)
SortCorner.CornerRadius = UDim.new(0, 6)

-- Toggles Bar
local ToggleBar = Instance.new("Frame")
ToggleBar.Size = UDim2.new(1, -20, 0, 40)
ToggleBar.Position = UDim2.new(0, 10, 0, 55)
ToggleBar.BackgroundTransparency = 1
ToggleBar.Parent = MainFrame

local AutoStealBtn = Instance.new("TextButton")
AutoStealBtn.Size = UDim2.new(0.48, 0, 1, 0)
AutoStealBtn.BackgroundColor3 = Color3.fromRGB(30, 120, 50)
AutoStealBtn.Text = "Auto Steal: OFF"
AutoStealBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
AutoStealBtn.Font = Enum.Font.SourceSansBold
AutoStealBtn.TextSize = 14
AutoStealBtn.Parent = ToggleBar
Instance.new("UICorner", AutoStealBtn).CornerRadius = UDim.new(0, 6)
Instance.new("UIStroke", AutoStealBtn).Color = Color3.fromRGB(80, 220, 100)

local InstantStealBtn = Instance.new("TextButton")
InstantStealBtn.Size = UDim2.new(0.48, 0, 1, 0)
InstantStealBtn.Position = UDim2.new(0.52, 0, 0, 0)
InstantStealBtn.BackgroundColor3 = Color3.fromRGB(150, 30, 30)
InstantStealBtn.Text = "Instant Steal: OFF"
InstantStealBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
InstantStealBtn.Font = Enum.Font.SourceSansBold
InstantStealBtn.TextSize = 14
InstantStealBtn.Parent = ToggleBar
Instance.new("UICorner", InstantStealBtn).CornerRadius = UDim.new(0, 6)
Instance.new("UIStroke", InstantStealBtn).Color = Color3.fromRGB(220, 80, 80)

-- Scrolling Container
local Scroll = Instance.new("ScrollingFrame")
Scroll.Size = UDim2.new(1, -20, 1, -110)
Scroll.Position = UDim2.new(0, 10, 0, 100)
Scroll.BackgroundTransparency = 1
Scroll.BorderSizePixel = 0
Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
Scroll.ScrollBarThickness = 6
Scroll.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout", Scroll)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 6)

-- State variables
local autoStealActive = false
local instantStealActive = false
local sortMode = "Highest Value"

AutoStealBtn.MouseButton1Click:Connect(function()
    autoStealActive = not autoStealActive
    AutoStealBtn.Text = "Auto Steal: " .. (autoStealActive and "ON" or "OFF")
    AutoStealBtn.BackgroundColor3 = autoStealActive and Color3.fromRGB(40, 180, 70) or Color3.fromRGB(30, 120, 50)
end)

InstantStealBtn.MouseButton1Click:Connect(function()
    instantStealActive = not instantStealActive
    InstantStealBtn.Text = "Instant Steal: " .. (instantStealActive and "ON" or "OFF")
    InstantStealBtn.BackgroundColor3 = instantStealActive and Color3.fromRGB(200, 40, 40) or Color3.fromRGB(150, 30, 30)
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

local function RefreshList()
    for _, child in pairs(Scroll:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end

    local items = {}
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and (obj.Name:find("Egg") or obj:FindFirstChild("Egg") or obj:GetAttribute("Creature")) then
            local creature = obj:GetAttribute("Creature") or obj.Name
            local valStr = obj:GetAttribute("ValueStr") or "$10.0M/s"
            local mult = obj:GetAttribute("Multiplier") or 1.5
            local weight = obj:GetAttribute("Weight") or 1200
            table.insert(items, {
                Object = obj,
                Creature = creature,
                ValueStr = valStr,
                Multiplier = mult,
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

    for i, data in ipairs(items) do
        local Card = Instance.new("Frame")
        Card.Size = UDim2.new(1, -5, 0, 65)
        Card.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
        Card.BorderSizePixel = 0
        Card.Parent = Scroll

        Instance.new("UICorner", Card).CornerRadius = UDim.new(0, 6)

        local IconBox = Instance.new("Frame")
        IconBox.Size = UDim2.new(0, 55, 0, 55)
        IconBox.Position = UDim2.new(0, 5, 0, 5)
        IconBox.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
        IconBox.Parent = Card
        Instance.new("UICorner", IconBox).CornerRadius = UDim.new(0, 4)

        local NameLabel = Instance.new("TextLabel")
        NameLabel.Size = UDim2.new(0.5, 0, 0, 22)
        NameLabel.Position = UDim2.new(0, 68, 0, 5)
        NameLabel.BackgroundTransparency = 1
        NameLabel.Text = data.Creature
        NameLabel.TextColor3 = Color3.fromRGB(180, 100, 255)
        NameLabel.Font = Enum.Font.SourceSansBold
        NameLabel.TextSize = 18
        NameLabel.TextXAlignment = Enum.TextXAlignment.Left
        NameLabel.Parent = Card

        local StatsLabel = Instance.new("TextLabel")
        StatsLabel.Size = UDim2.new(0.5, 0, 0, 30)
        StatsLabel.Position = UDim2.new(0, 68, 0, 27)
        StatsLabel.BackgroundTransparency = 1
        StatsLabel.Text = string.format("<font color='#00FF88'>%s</font>\nx%.2f • %d Kg", data.ValueStr, data.Multiplier, data.Weight)
        StatsLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        StatsLabel.RichText = true
        StatsLabel.Font = Enum.Font.SourceSans
        StatsLabel.TextSize = 14
        StatsLabel.TextXAlignment = Enum.TextXAlignment.Left
        StatsLabel.Parent = Card

        local StealBtn = Instance.new("TextButton")
        StealBtn.Size = UDim2.new(0, 75, 0, 35)
        StealBtn.Position = UDim2.new(1, -115, 0, 15)
        StealBtn.BackgroundColor3 = Color3.fromRGB(40, 190, 70)
        StealBtn.Text = "Steal"
        StealBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        StealBtn.Font = Enum.Font.SourceSansBold
        StealBtn.TextSize = 16
        StealBtn.Parent = Card
        Instance.new("UICorner", StealBtn).CornerRadius = UDim.new(0, 6)

        local StarBtn = Instance.new("TextButton")
        StarBtn.Size = UDim2.new(0, 32, 0, 35)
        StarBtn.Position = UDim2.new(1, -37, 0, 15)
        StarBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 75)
        StarBtn.Text = "⭐"
        StarBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        StarBtn.Font = Enum.Font.SourceSans
        StarBtn.TextSize = 14
        StarBtn.Parent = Card
        Instance.new("UICorner", StarBtn).CornerRadius = UDim.new(0, 6)

        StealBtn.MouseButton1Click:Connect(function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = data.Object:GetPivot() * CFrame.new(0, 3, 0)
                for _, prompt in pairs(data.Object:GetDescendants()) do
                    if prompt:IsA("ProximityPrompt") then
                        if instantStealActive then
                            fireproximityprompt(prompt, 0)
                        else
                            fireproximityprompt(prompt)
                        end
                    end
                end
            end
        end)
    end

    Scroll.CanvasSize = UDim2.new(0, 0, 0, #items * 71)
end

task.spawn(function()
    while true do
        RefreshList()
        if autoStealActive then
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("Model") and (obj.Name:find("Egg") or obj:FindFirstChild("Egg")) then
                    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        LocalPlayer.Character.HumanoidRootPart.CFrame = obj:GetPivot() * CFrame.new(0, 3, 0)
                        for _, prompt in pairs(obj:GetDescendants()) do
                            if prompt:IsA("ProximityPrompt") then
                                fireproximityprompt(prompt, instantStealActive and 0 or nil)
                            end
                        end
                    end
                    task.wait(0.5)
                end
            end
        end
        task.wait(2)
    end
end)
