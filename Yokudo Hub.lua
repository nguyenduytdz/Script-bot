-- =================================================================
-- YOKUDO HUB - LITE VERSION (Farm, Survival & Anti-Cheat Bypass)
-- =================================================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

-- Global Toggles
getgenv().Config = {
    AutoFarm = false,
    AutoAttack = false,
    GodMode = false,
    AntiTrap = false,
    AntiAFK = true
}

-- -----------------------------------------------------------------
-- 1. CHỐNG AFK (Anti-AFK)
-- -----------------------------------------------------------------
LocalPlayer.Idled:Connect(function()
    if getgenv().Config.AntiAFK then
        VirtualUser:Button2Down(Vector2.new(0, 0), Workspace.CurrentCamera.CFrame)
        task.wait(1)
        VirtualUser:Button2Up(Vector2.new(0, 0), Workspace.CurrentCamera.CFrame)
    end
end)

-- -----------------------------------------------------------------
-- 2. VƯỢT CHỐNG GIAN LẬN & BẤT TỬ (Bypass Anti-Cheat & God Mode)
-- -----------------------------------------------------------------
local function ApplyGodMode(character)
    if not character then return end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        -- Bypass Anti-Cheat & Bất tử cơ bản bằng cách khóa Máu & Trạng thái
        humanoid.SetStateEnabled(humanoid, Enum.HumanoidStateType.Dead, false)
        humanoid.Health = humanoid.MaxHealth
        humanoid:GetPropertyChangedSignal("Health"):Connect(function()
            if getgenv().Config.GodMode then
                humanoid.Health = humanoid.MaxHealth
            end
        end)
    end
end

LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(1)
    if getgenv().Config.GodMode then
        ApplyGodMode(char)
    end
end)

-- -----------------------------------------------------------------
-- 3. CHỐNG BẪY (Anti-Trap / Clear Debris)
-- -----------------------------------------------------------------
task.spawn(function()
    while task.wait(0.5) do
        if getgenv().Config.AntiTrap then
            for _, obj in pairs(Workspace:GetChildren()) do
                if obj.Name:find("Trap") or obj.Name:find("Debris") or obj.Name:find("__DEBRIS") then
                    obj:Destroy()
                end
            end
        end
    end
end)

-- -----------------------------------------------------------------
-- 4. HỆ THỐNG FARM TỰ ĐỘNG (Auto Farm & Auto Attack)
-- -----------------------------------------------------------------
local function GetClosestEgg()
    local closest, minDst = nil, math.huge
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end

    -- Tìm các vật thể Trứng trong Workspace (Tùy chỉnh Folder Trứng của Game)
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and (obj.Name:lower():find("egg") or obj.Parent.Name:lower():find("egg")) then
            local dist = (hrp.Position - obj.Position).Magnitude
            if dist < minDst then
                minDst = dist
                closest = obj
            end
        end
    end
    return closest
end

-- Vòng lặp Auto Farm & Auto Attack
task.spawn(function()
    while task.wait(0.1) do
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        
        -- Auto Farm Trứng
        if getgenv().Config.AutoFarm and hrp then
            local targetEgg = GetClosestEgg()
            if targetEgg then
                hrp.CFrame = targetEgg.CFrame + Vector3.new(0, 3, 0)
            end
        end

        -- Auto Attack (Tự đánh/dùng vũ khí)
        if getgenv().Config.AutoAttack and char then
            local tool = char:FindFirstChildOfClass("Tool") or LocalPlayer.Backpack:FindFirstChildOfClass("Tool")
            if tool then
                if tool.Parent ~= char then
                    char.Humanoid:EquipTool(tool)
                end
                tool:Activate()
            end
        end
    end
end)

-- -----------------------------------------------------------------
-- 5. GIAO DIỆN MENU (GUI Simple Interface)
-- -----------------------------------------------------------------
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local UIListLayout = Instance.new("UIListLayout")

ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ResetOnSpawn = false

MainFrame.Name = "YokudoHub_Lite"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.Position = UDim2.new(0.1, 0, 0.2, 0)
MainFrame.Size = UDim2.new(0, 220, 0, 260)
MainFrame.Active = true
MainFrame.Draggable = true

Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Title.Text = "YOKUDO HUB - LITE"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 14
Title.Font = Enum.Font.SourceSansBold

UIListLayout.Parent = MainFrame
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim2.new(0, 5)

-- Hàm tạo nút Bật/Tắt (Toggle)
local function CreateToggle(name, configKey)
    local Button = Instance.new("TextButton")
    Button.Parent = MainFrame
    Button.Size = UDim2.new(1, -10, 0, 35)
    Button.Position = UDim2.new(0, 5, 0, 0)
    Button.BackgroundColor3 = getgenv().Config[configKey] and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(170, 0, 0)
    Button.Text = name .. ": " .. (getgenv().Config[configKey] and "ON" or "OFF")
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.Font = Enum.Font.SourceSans

    Button.MouseButton1Click:Connect(function()
        getgenv().Config[configKey] = not getgenv().Config[configKey]
        Button.BackgroundColor3 = getgenv().Config[configKey] and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(170, 0, 0)
        Button.Text = name .. ": " .. (getgenv().Config[configKey] and "ON" or "OFF")

        -- Kích hoạt Bất tử ngay khi bật
        if configKey == "GodMode" and getgenv().Config.GodMode then
            ApplyGodMode(LocalPlayer.Character)
        end
    end)
end

-- Khởi tạo các nút chức năng trên Menu
CreateToggle("Auto Farm Egg", "AutoFarm")
CreateToggle("Auto Attack", "AutoAttack")
CreateToggle("God Mode (Bất Tử)", "GodMode")
CreateToggle("Anti Trap (Chống Bẫy)", "AntiTrap")
CreateToggle("Anti AFK", "AntiAFK")
