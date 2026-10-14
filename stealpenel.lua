-- ==============================================================================
-- Project: FE Universal Emotes Hub (Replicated Animation Engine)
-- Author: Axiom | Elite Systems Architecture
-- Note: Press [Insert] to toggle panel visibility.
-- ==============================================================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local PlayerGui = LocalPlayer:WaitForChild("PlayerGui", 5)
local ProtectedGui = (gethui and gethui()) or game:GetService("CoreGui")

if ProtectedGui:FindFirstChild("AxiomEmotesHub") then
    ProtectedGui.AxiomEmotesHub:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AxiomEmotesHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = ProtectedGui

-- Main Frame
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 360, 0, 450)
MainFrame.Position = UDim2.new(0.5, -180, 0.5, -225)
MainFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 36)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)
local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Color = Color3.fromRGB(50, 50, 70)
MainStroke.Thickness = 2

-- Header
local Header = Instance.new("Frame", MainFrame)
Header.Size = UDim2.new(1, 0, 0, 45)
Header.BackgroundColor3 = Color3.fromRGB(40, 40, 52)
Header.BorderSizePixel = 0
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 10)

local HeaderCover = Instance.new("Frame", Header)
HeaderCover.Size = UDim2.new(1, 0, 0, 10)
HeaderCover.Position = UDim2.new(0, 0, 1, -10)
HeaderCover.BackgroundColor3 = Color3.fromRGB(40, 40, 52)
HeaderCover.BorderSizePixel = 0

local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(1, -20, 1, 0)
Title.Position = UDim2.new(0, 12, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "⚡ FE Emotes Hub (Visible to All)"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.FredokaOne
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left

-- Stop Emote Button
local StopBtn = Instance.new("TextButton", MainFrame)
StopBtn.Size = UDim2.new(1, -20, 0, 36)
StopBtn.Position = UDim2.new(0, 10, 0, 55)
StopBtn.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
StopBtn.Text = "🛑 Stop Current Emote"
StopBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
StopBtn.Font = Enum.Font.SourceSansBold
StopBtn.TextSize = 15
Instance.new("UICorner", StopBtn).CornerRadius = UDim.new(0, 6)

-- Scrolling Frame for Emotes
local Scroll = Instance.new("ScrollingFrame", MainFrame)
Scroll.Size = UDim2.new(1, -20, 1, -105)
Scroll.Position = UDim2.new(0, 10, 0, 100)
Scroll.BackgroundTransparency = 1
Scroll.BorderSizePixel = 0
Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
Scroll.ScrollBarThickness = 5
Scroll.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 130)

local UIList = Instance.new("UIListLayout", Scroll)
UIList.SortOrder = Enum.SortOrder.LayoutOrder
UIList.Padding = UDim.new(0, 6)

-- Toggle via Insert
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.Insert then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

-- Animation Player Function
local currentTrack = nil
local function PlayEmote(id)
    local char = LocalPlayer.Character
    if not char then return end
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    local animator = humanoid:FindFirstChildOfClass("Animator") or Instance.new("Animator", humanoid)

    if currentTrack then
        pcall(function() currentTrack:Stop() end)
    end

    local anim = Instance.new("Animation")
    anim.AnimationId = "rbxassetid://" .. tostring(id)

    pcall(function()
        currentTrack = animator:LoadAnimation(anim)
        currentTrack.Priority = Enum.AnimationPriority.Action
        currentTrack:Play()
    end)
end

StopBtn.MouseButton1Click:Connect(function()
    if currentTrack then
        pcall(function() currentTrack:Stop() end)
        currentTrack = nil
    end
end)

-- Emote List (Name + ID)
local EmoteList = {
    {Name = "The Griddy", ID = 10142270011},
    {Name = "Laugh", ID = 5918726674},
    {Name = "LRAD / Arm Wave", ID = 3338044955},
    {Name = "Levitation", ID = 15495500473},
    {Name = "Headlock", ID = 13803155020},
    {Name = "Shuffle Dance", ID = 5918728444},
    {Name = "Clap", ID = 5918723920},
    {Name = "Bows / Salute", ID = 5918732353},
    {Name = "Point", ID = 5918728956},
    {Name = "Cheer", ID = 5918721314},
    {Name = "Wave", ID = 5918744047},
    {Name = "Stadium", ID = 13378700201},
}

for _, data in ipairs(EmoteList) do
    local Btn = Instance.new("TextButton", Scroll)
    Btn.Size = UDim2.new(1, -4, 0, 38)
    Btn.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
    Btn.Text = "  " .. data.Name
    Btn.TextColor3 = Color3.fromRGB(240, 240, 255)
    Btn.Font = Enum.Font.SourceSansBold
    Btn.TextSize = 15
    Btn.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)

    Btn.MouseButton1Click:Connect(function()
        PlayEmote(data.ID)
    end)
end

Scroll.CanvasSize = UDim2.new(0, 0, 0, #EmoteList * 44)
print("[AxiomEmotesHub] Loaded! Press [Insert] to toggle menu.")
