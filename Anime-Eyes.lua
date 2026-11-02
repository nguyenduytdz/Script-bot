- // Axiom Clean Win Teleporter (Loại bỏ hoàn toàn quái vật, chỉ dịch chuyển đến bục Win)
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local Workspace = game:GetService("Workspace")

if CoreGui:FindFirstChild("AxiomSmartWinHub") then
    CoreGui.AxiomSmartWinHub:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AxiomSmartWinHub"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
MainFrame.Position = UDim2.new(0.5, -160, 0.4, -60)
MainFrame.Size = UDim2.new(0, 320, 0, 160)
MainFrame.Active = true
MainFrame.Draggable = true

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

local TopBar = Instance.new("Frame")
TopBar.Parent = MainFrame
TopBar.BackgroundTransparency = 1
TopBar.Size = UDim2.new(1, 0, 0, 30)

local StatusDot = Instance.new("Frame")
StatusDot.Parent = TopBar
StatusDot.BackgroundColor3 = Color3.fromRGB(50, 220, 100)
StatusDot.Position = UDim2.new(0, 12, 0.5, -4)
StatusDot.Size = UDim2.new(0, 8, 0, 8)
local DotCorner = Instance.new("UICorner")
DotCorner.CornerRadius = UDim.new(1, 0)
DotCorner.Parent = StatusDot

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Parent = TopBar
TitleLabel.BackgroundTransparency = 1
TitleLabel.Position = UDim2.new(0, 28, 0, 0)
TitleLabel.Size = UDim2.new(0, 240, 1, 0)
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.Text = "Smart Win - No Mobs"
TitleLabel.TextColor3 = Color3.fromRGB(230, 230, 230)
TitleLabel.TextSize = 13
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = TopBar
CloseBtn.BackgroundTransparency = 1
CloseBtn.Position = UDim2.new(1, -28, 0, 2)
CloseBtn.Size = UDim2.new(0, 26, 1, 0)
CloseBtn.Font = Enum.Font.SourceSansBold
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(160, 160, 160)
CloseBtn.TextSize = 14

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

local StatsContainer = Instance.new("Frame")
StatsContainer.Parent = MainFrame
StatsContainer.BackgroundTransparency = 1
StatsContainer.Position = UDim2.new(0, 10, 0, 35)
StatsContainer.Size = UDim2.new(1, -20, 0, 42)

local function createStatBox(name, xPos)
    local box = Instance.new("Frame")
    box.Parent = StatsContainer
    box.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
    box.Position = UDim2.new(xPos, 0, 0, 0)
    box.Size = UDim2.new(0.31, 0, 1, 0)
    
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 6)
    c.Parent = box
    
    local nameLbl = Instance.new("TextLabel")
    nameLbl.Parent = box
    nameLbl.BackgroundTransparency = 1
    nameLbl.Position = UDim2.new(0, 0, 0, 3)
    nameLbl.Size = UDim2.new(1, 0, 0, 12)
    nameLbl.Font = Enum.Font.SourceSansBold
    nameLbl.Text = name
    nameLbl.TextColor3 = Color3.fromRGB(130, 130, 140)
    nameLbl.TextSize = 10
    nameLbl.TextXAlignment = Enum.TextXAlignment.Center
    
    local valLbl = Instance.new("TextLabel")
    valLbl.Name = "Value"
    valLbl.Parent = box
    valLbl.BackgroundTransparency = 1
    valLbl.Position = UDim2.new(0, 0, 0, 15)
    valLbl.Size = UDim2.new(1, 0, 0, 22)
    valLbl.Font = Enum.Font.SourceSansBold
    valLbl.Text = "0"
    valLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    valLbl.TextSize = 14
    valLbl.TextXAlignment = Enum.TextXAlignment.Center
    
    return valLbl
end

local PingVal = createStatBox("PING", 0)
local FpsVal = createStatBox("FPS", 0.345)
local TimeVal = createStatBox("TIME", 0.69)

local AutoWinBtn = Instance.new("TextButton")
AutoWinBtn.Parent = MainFrame
AutoWinBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
AutoWinBtn.Position = UDim2.new(0, 10, 0, 84)
AutoWinBtn.Size = UDim2.new(1, -20, 0, 35)
AutoWinBtn.Font = Enum.Font.SourceSansBold
AutoWinBtn.Text = "AUTO WIN: [ TẮT ]"
AutoWinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
AutoWinBtn.TextSize = 14

local BtnCorner = Instance.new("UICorner")
BtnCorner.CornerRadius = UDim.new(0, 6)
BtnCorner.Parent = AutoWinBtn

local FooterLabel = Instance.new("TextLabel")
FooterLabel.Parent = MainFrame
FooterLabel.BackgroundTransparency = 1
FooterLabel.Position = UDim2.new(0, 12, 0, 125)
FooterLabel.Size = UDim2.new(1, -24, 0, 20)
FooterLabel.Font = Enum.Font.SourceSans
FooterLabel.Text = "created by axiom - boss man edition"
FooterLabel.TextColor3 = Color3.fromRGB(100, 100, 115)
FooterLabel.TextSize = 11
FooterLabel.TextXAlignment = Enum.TextXAlignment.Left

local smartWinActive = false

AutoWinBtn.MouseButton1Click:Connect(function()
    smartWinActive = not smartWinActive
    if smartWinActive then
        AutoWinBtn.Text = "AUTO WIN: [ BẬT ]"
        AutoWinBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
    else
        AutoWinBtn.Text = "AUTO WIN: [ TẮT ]"
        AutoWinBtn.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
    end
    
    task.spawn(function()
        while smartWinActive do
            pcall(function()
                local targetPad = nil
                
                -- Quét chuẩn xác, loại trừ hoàn toàn các đối tượng là quái vật (Mobs/Enemies)
                for _, obj in pairs(Workspace:GetDescendants()) do
                    if not smartWinActive then break end
                    if obj:IsA("Model") then
                        local nameLower = obj.Name:lower()
                        -- Chỉ nhận bục Win, tuyệt đối bỏ qua quái
                        if (nameLower:find("win") or nameLower:find("pad") or nameLower:find("reward")) and not nameLower:find("mob") and not nameLower:find("enemy") and not obj:FindFirstChild("Humanoid") then
                            local part = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
                            if part then
                                targetPad = part
                                break
                            end
                        end
                    end
                end

                -- Nếu tìm thấy bục Win chuẩn xác, dịch chuyển thẳng chân
                if targetPad and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    LocalPlayer.Character.HumanoidRootPart.CFrame = targetPad.CFrame + Vector3.new(0, 3, 0)
                end
            end)
            task.wait(0.5)
        end
    end)
end)

local startTime = tick()
local frameCount = 0
local lastUpdate = tick()
local currentFps = 60

RunService.RenderStepped:Connect(function()
    frameCount = frameCount + 1
    local now = tick()
    if now - lastUpdate >= 1 then
        currentFps = math.floor(frameCount / (now - lastUpdate))
        frameCount = 0
        lastUpdate = now
    end
    
    local ping = 0
    pcall(function()
        ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
    end)
    
    local elapsed = math.floor(now - startTime)
    local hours = math.floor(elapsed / 3600)
    local minutes = math.floor((elapsed % 3600) / 60)
    local seconds = elapsed % 60
    local timeStr = string.format("%d:%d:%d", hours, minutes, seconds)
    
    PingVal.Text = tostring(ping)
    FpsVal.Text = tostring(currentFps)
    TimeVal.Text = timeStr
end)
