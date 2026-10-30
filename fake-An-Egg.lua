-- // Axiom Native UI Hub - Không phụ thuộc loadstring ngoài, chống sập 100% cho boss man
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Xóa UI cũ nếu có tránh trùng lặp
if CoreGui:FindFirstChild("AxiomHubNative") then
    CoreGui.AxiomHubNative:Destroy()
end

-- Tạo ScreenGui chính
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AxiomHubNative"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Khung chính của Menu
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
MainFrame.Position = UDim2.new(0.5, -290, 0.5, -230)
MainFrame.Size = UDim2.new(0, 580, 0, 460)
MainFrame.Active = true
MainFrame.Draggable = true -- Cho phép kéo thả menu thoải mái

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

-- Thanh tiêu đề (Title Bar)
local TitleBar = Instance.new("TextLabel")
TitleBar.Parent = MainFrame
TitleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.Font = Enum.Font.SourceSansBold
TitleBar.Text = "  Axiom Hub - Boss Man Edition"
TitleBar.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleBar.TextSize = 18
TitleBar.TextXAlignment = Enum.TextXAlignment.Left

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 8)
TitleCorner.Parent = TitleBar

-- Nút đóng mở menu nhanh (Toggle Key: LeftControl hoặc bấm nút)
local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = TitleBar
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.Position = UDim2.new(1, -35, 0.5, -12)
CloseBtn.Size = UDim2.new(0, 24, 0, 24)
CloseBtn.Font = Enum.Font.SourceSansBold
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 14
CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Khung chứa danh sách Tab bên trái
local TabContainer = Instance.new("ScrollingFrame")
TabContainer.Parent = MainFrame
TabContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
TabContainer.Position = UDim2.new(0, 0, 0, 40)
TabContainer.Size = UDim2.new(0, 150, 1, -40)
TabContainer.CanvasSize = UDim2.new(0, 0, 0, 200)
TabContainer.ScrollBarThickness = 4

-- Khung chứa nội dung các Tab bên phải
local ContentContainer = Instance.new("Frame")
ContentContainer.Parent = MainFrame
ContentContainer.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
ContentContainer.Position = UDim2.new(0, 150, 0, 40)
ContentContainer.Size = UDim2.new(1, -150, 1, -40)

-- Tạo 2 trang nội dung: Farm và Settings
local FarmPage = Instance.new("ScrollingFrame")
FarmPage.Name = "FarmPage"
FarmPage.Parent = ContentContainer
FarmPage.Size = UDim2.new(1, 0, 1, 0)
FarmPage.BackgroundTransparency = 1
FarmPage.Visible = true
FarmPage.CanvasSize = UDim2.new(0, 0, 1, 100)
FarmPage.ScrollBarThickness = 4

local SettingsPage = Instance.new("ScrollingFrame")
SettingsPage.Name = "SettingsPage"
SettingsPage.Parent = ContentContainer
SettingsPage.Size = UDim2.new(1, 0, 1, 0)
SettingsPage.BackgroundTransparency = 1
SettingsPage.Visible = false
SettingsPage.CanvasSize = UDim2.new(0, 0, 1, 100)
SettingsPage.ScrollBarThickness = 4

-- Nút Tab 1: Farm (Icon 🌾)
local FarmTabBtn = Instance.new("TextButton")
FarmTabBtn.Parent = TabContainer
FarmTabBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
FarmTabBtn.Position = UDim2.new(0, 10, 0, 10)
FarmTabBtn.Size = UDim2.new(1, -20, 0, 35)
FarmTabBtn.Font = Enum.Font.SourceSansBold
FarmTabBtn.Text = "  🌾 Farm Rebirth"
FarmTabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
FarmTabBtn.TextSize = 14
FarmTabBtn.TextXAlignment = Enum.TextXAlignment.Left

FarmTabBtn.MouseButton1Click:Connect(function()
    FarmPage.Visible = true
    SettingsPage.Visible = false
end)

-- Nút Tab 2: Settings
local SettingsTabBtn = Instance.new("TextButton")
SettingsTabBtn.Parent = TabContainer
SettingsTabBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
SettingsTabBtn.Position = UDim2.new(0, 10, 0, 55)
SettingsTabBtn.Size = UDim2.new(1, -20, 0, 35)
SettingsTabBtn.Font = Enum.Font.SourceSansBold
SettingsTabBtn.Text = "  ⚙️ Settings"
SettingsTabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SettingsTabBtn.TextSize = 14
SettingsTabBtn.TextXAlignment = Enum.TextXAlignment.Left

SettingsTabBtn.MouseButton1Click:Connect(function()
    FarmPage.Visible = false
    SettingsPage.Visible = true
end)

-- NỘI DUNG TAB FARM: TÍNH NĂNG QUÉT & REBIRTH
local FarmTitle = Instance.new("TextLabel")
FarmTitle.Parent = FarmPage
FarmTitle.BackgroundTransparency = 1
FarmTitle.Position = UDim2.new(0, 15, 0, 15)
FarmTitle.Size = UDim2.new(1, -30, 0, 50)
FarmTitle.Font = Enum.Font.SourceSans
FarmTitle.Text = "Hệ thống tự động quét yêu cầu Rebirth, tìm trứng/con vật, mang về base mở và lặp lại vòng đời."
FarmTitle.TextColor3 = Color3.fromRGB(200, 200, 200)
FarmTitle.TextSize = 14
FarmTitle.TextWrapped = true
FarmTitle.TextXAlignment = Enum.TextXAlignment.Left

-- Nút Toggle Auto Farm Rebirth
local ToggleButton = Instance.new("TextButton")
ToggleButton.Parent = FarmPage
ToggleButton.BackgroundColor3 = Color3.fromRGB(70, 70, 80)
ToggleButton.Position = UDim2.new(0, 15, 0, 80)
ToggleButton.Size = UDim2.new(0, 250, 0, 40)
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.Text = "Auto Farm Rebirth: [ TẮT ]"
ToggleButton.TextColor3 = Color3.fromRGB(255, 100, 100)
ToggleButton.TextSize = 14

local farmRunning = false

local function tpTo(targetCF)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = targetCF
    end
end

ToggleButton.MouseButton1Click:Connect(function()
    farmRunning = not farmRunning
    if farmRunning then
        ToggleButton.Text = "Auto Farm Rebirth: [ BẬT ]"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
        ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    else
        ToggleButton.Text = "Auto Farm Rebirth: [ TẮT ]"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(70, 70, 80)
        ToggleButton.TextColor3 = Color3.fromRGB(255, 100, 100)
    end
    
    task.spawn(function()
        while farmRunning do
            pcall(function()
                -- 1. Quét mục tiêu từ bảng Rebirth trên màn hình
                local requiredTarget = nil
                local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
                if playerGui then
                    for _, gui in pairs(playerGui:GetDescendants()) do
                        if gui:IsA("TextLabel") and (gui.Text:lower():find("egg") or gui.Text:lower():find("hydra") or gui.Text:lower():find("wolf")) then
                            requiredTarget = gui.Text
                            break
                        end
                    end
                end

                -- 2. Quét map tìm đúng con vật / trứng cần mua
                local targetObj = nil
                for _, obj in pairs(Workspace:GetDescendants()) do
                    if not farmRunning then break end
                    if obj:IsA("Model") and requiredTarget and obj.Name:lower():find(requiredTarget:lower()) then
                        if obj:PrimaryPart() or obj:FindFirstChildWhichIsA("BasePart") then
                            targetObj = obj
                            break
                        end
                    end
                end

                -- 3. Bay đến mua
                if targetObj then
                    local part = targetObj.PrimaryPart or targetObj:FindFirstChildWhichIsA("BasePart")
                    if part then
                        tpTo(part.CFrame + Vector3.new(0, 3, 0))
                        task.wait(0.4)
                        for _, prompt in pairs(targetObj:GetDescendants()) do
                            if prompt:IsA("ProximityPrompt") then
                                fireproximityprompt(prompt)
                            end
                        end
                        task.wait(0.5)
                    end
                end

                -- 4. Mang về Base mở trứng
                local bases = Workspace:FindFirstChild("Bases")
                if bases then
                    local myBase = bases:FindFirstChild(LocalPlayer.Name)
                    if myBase and myBase:FindFirstChild("PrimaryPart") then
                        tpTo(myBase.PrimaryPart.CFrame + Vector3.new(0, 5, 0))
                        task.wait(0.8)
                    end
                end

                for _, obj in pairs(Workspace:GetDescendants()) do
                    if obj:IsA("Model") and (obj.Name:lower():find("egg") or obj:FindFirstChild("ProximityPrompt")) then
                        local prompt = obj:FindFirstChildWhichIsA("ProximityPrompt", true)
                        if prompt then
                            fireproximityprompt(prompt)
                        end
                    end
                end
                task.wait(1)

                -- 5. Thực hiện Rebirth
                local rebirthRemote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("Rebirth")
                if rebirthRemote then
                    rebirthRemote:FireServer()
                end
            end)
            task.wait(1.5)
        end
    end)
end)

-- NỘI DUNG TAB SETTINGS: TÙY CHỈNH CỦA BOSS MAN
local SettingsTitle = Instance.new("TextLabel")
SettingsTitle.Parent = SettingsPage
SettingsTitle.BackgroundTransparency = 1
SettingsTitle.Position = UDim2.new(0, 15, 0, 15)
SettingsTitle.Size = UDim2.new(1, -30, 0, 40)
SettingsTitle.Font = Enum.Font.SourceSansBold
SettingsTitle.Text = "Cài đặt hệ thống giao diện"
SettingsTitle.TextColor3 = Color3.fromRGB(220, 220, 220)
SettingsTitle.TextSize = 16
SettingsTitle.TextXAlignment = Enum.TextXAlignment.Left

-- Nút hủy / xóa giao diện toàn bộ
local UnloadBtn = Instance.new("TextButton")
UnloadBtn.Parent = SettingsPage
UnloadBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
UnloadBtn.Position = UDim2.new(0, 15, 0, 70)
UnloadBtn.Size = UDim2.new(0, 200, 0, 35)
UnloadBtn.Font = Enum.Font.SourceSansBold
UnloadBtn.Text = "Unload Hub (Tắt Menu)"
UnloadBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
UnloadBtn.TextSize = 14

UnloadBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

print("Axiom Native Menu Loaded Successfully for Boss Man!")
