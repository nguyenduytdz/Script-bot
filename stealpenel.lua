-- Steal An Egg - Advanced Egg Inspector & Stealer Panel
-- Developed for boss man | Axiom UI Framework

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

-- Clean up existing instance if re-executed
if CoreGui:FindFirstChild("AxiomEggInspector") then
    CoreGui.AxiomEggInspector:Destroy()
end

-- ScreenGui Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AxiomEggInspector"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

-- Main Panel
local Frame = Instance.new("Frame")
Frame.Name = "MainPanel"
Frame.Size = UDim2.new(0, 520, 0, 400)
Frame.Position = UDim2.new(0.5, -260, 0.5, -200)
Frame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true
Frame.Parent = ScreenGui

local UICorner = Instance.new("UICorner", Frame)
UICorner.CornerRadius = UDim.new(0, 10)

local UIStroke = Instance.new("UIStroke", Frame)
UIStroke.Color = Color3.fromRGB(85, 0, 255)
UIStroke.Thickness = 1.5

-- Header
local Header = Instance.new("TextLabel")
Header.Size = UDim2.new(1, -20, 0, 40)
Header.Position = UDim2.new(0, 10, 0, 5)
Header.BackgroundTransparency = 1
Header.Text = "AXIOM // STEAL AN EGG INSPECTOR"
Header.TextColor3 = Color3.fromRGB(220, 220, 255)
Header.Font = Enum.Font.FredokaOne
Header.TextSize = 18
Header.TextXAlignment = Enum.TextXAlignment.Left
Header.Parent = Frame

-- Refresh Button
local RefreshBtn = Instance.new("TextButton")
RefreshBtn.Size = UDim2.new(0, 100, 0, 28)
RefreshBtn.Position = UDim2.new(1, -110, 0, 10)
RefreshBtn.BackgroundColor3 = Color3.fromRGB(40, 20, 80)
RefreshBtn.Text = "REFRESH"
RefreshBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
RefreshBtn.Font = Enum.Font.SourceSansBold
RefreshBtn.TextSize = 14
RefreshBtn.Parent = Frame

local BtnCorner = Instance.new("UICorner", RefreshBtn)
BtnCorner.CornerRadius = UDim.new(0, 6)

-- Scroll Container
local Scroll = Instance.new("ScrollingFrame")
Scroll.Size = UDim2.new(1, -20, 1, -60)
Scroll.Position = UDim2.new(0, 10, 0, 50)
Scroll.BackgroundTransparency = 1
Scroll.BorderSizePixel = 0
Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
Scroll.ScrollBarThickness = 6
Scroll.ScrollBarImageColor3 = Color3.fromRGB(85, 0, 255)
Scroll.Parent = Frame

local UIListLayout = Instance.new("UIListLayout", Scroll)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 6)

-- Function to parse and detect eggs on map
local function ScanMapEggs()
    for _, child in pairs(Scroll:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end

    local eggCount = 0
    -- Scanning workspace containers for Egg nodes
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and (obj.Name:find("Egg") or obj:FindFirstChild("Egg")) then
            eggCount = eggCount + 1
            
            -- Extract data metrics dynamically from egg tags/attributes/children
            local creatureName = obj:GetAttribute("Creature") or obj:GetAttribute("Pet") or "Unknown Beast"
            local eggValue = obj:GetAttribute("Value") or obj:GetAttribute("Price") or "$???"
            local eggSize = obj:GetAttribute("Size") or string.format("%.1fx", obj:GetScale() or 1.0)
            
            -- Egg Card Frame
            local Card = Instance.new("Frame")
            Card.Size = UDim2.new(1, -10, 0, 50)
            Card.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
            Card.BorderSizePixel = 0
            Card.Parent = Scroll
            
            local CardCorner = Instance.new("UICorner", Card)
            CardCorner.CornerRadius = UDim.new(0, 6)
            
            -- Info Label
            local Info = Instance.new("TextLabel")
            Info.Size = UDim2.new(0.7, -10, 1, 0)
            Info.Position = UDim2.new(0, 10, 0, 0)
            Info.BackgroundTransparency = 1
            Info.Text = string.format("<b>%s</b> | Creature: <font color='#00FFCC'>%s</font>\nVal: <font color='#00FF88'>%s</font> | Size: <font color='#FFCC00'>%s</font>", 
                obj.Name, tostring(creatureName), tostring(eggValue), tostring(eggSize))
            Info.TextColor3 = Color3.fromRGB(200, 200, 200)
            Info.RichText = true
            Info.Font = Enum.Font.SourceSans
            Info.TextSize = 14
            Info.TextXAlignment = Enum.TextXAlignment.Left
            Info.Parent = Card
            
            -- Steal & Move Button
            local ActionBtn = Instance.new("TextButton")
            ActionBtn.Size = UDim2.new(0.28, 0, 0.7, 0)
            ActionBtn.Position = UDim2.new(0.7, 0, 0.15, 0)
            ActionBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
            ActionBtn.Text = "STEAL SAMPLE"
            ActionBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            ActionBtn.Font = Enum.Font.SourceSansBold
            ActionBtn.TextSize = 13
            ActionBtn.Parent = Card
            
            local ActCorner = Instance.new("UICorner", ActionBtn)
            ActCorner.CornerRadius = UDim.new(0, 4)
            
            ActionBtn.MouseButton1Click:Connect(function()
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local targetPos = obj:GetPivot()
                    -- Teleport cleanly onto egg position
                    LocalPlayer.Character.HumanoidRootPart.CFrame = targetPos * CFrame.new(0, 3, 0)
                    
                    -- Trigger interaction prompt if exists
                    for _, prompt in pairs(obj:GetDescendants()) do
                        if prompt:IsA("ProximityPrompt") then
                            fireproximityprompt(prompt)
                        end
                    end
                end
            end)
        end
    end
    
    Scroll.CanvasSize = UDim2.new(0, 0, 0, eggCount * 56)
end

RefreshBtn.MouseButton1Click:Connect(ScanMapEggs)

-- Initial Scan Execution
ScanMapEggs()