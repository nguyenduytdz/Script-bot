-- Tạo ScreenGui chứa toàn bộ giao diện
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Tránh tạo trùng lặp nếu chạy lại script
if CoreGui:FindFirstChild("CustomF9Console") then
    CoreGui.CustomF9Console:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CustomF9Console"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

-- 1. Nút bấm bật/tắt menu trên màn hình (Floating Button)
local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "ToggleButton"
ToggleButton.Parent = ScreenGui
ToggleButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
ToggleButton.Position = UDim2.new(0, 20, 0.5, -25)
ToggleButton.Size = UDim2.new(0, 50, 0, 50)
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.Text = "F9"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 18

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 12)
ToggleCorner.Parent = ToggleButton

-- 2. Ô vuông to bo góc chứa nội dung (Console Frame)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BackgroundTransparency = 0.15 -- Làm mờ nhẹ nền
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
MainFrame.Size = UDim2.new(0, 400, 0, 300)
MainFrame.Visible = false -- Mặc định ẩn, bấm nút F9 để mở

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 16) -- Bo góc to đẹp mắt
MainCorner.Parent = MainFrame

-- Thanh tiêu đề (Title Bar) để kéo thả hoặc hiện tên
local TitleBar = Instance.new("TextLabel")
TitleBar.Parent = MainFrame
TitleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
TitleBar.Size = UDim2.new(1, 0, 0, 35)
TitleBar.Font = Enum.Font.SourceSansBold
TitleBar.Text = " Developer Console (F9 Emulator)"
TitleBar.TextColor3 = Color3.fromRGB(220, 220, 220)
TitleBar.TextSize = 14
TitleBar.TextXAlignment = Enum.TextXAlignment.Left

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 16)
TitleCorner.Parent = TitleBar

-- Nút đóng cửa sổ (X)
local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = TitleBar
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.Position = UDim2.new(1, -30, 0.5, -10)
CloseBtn.Size = UDim2.new(0, 20, 0, 20)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 12
local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 4)
CloseCorner.Parent = CloseBtn

-- 3. Khung cuộn chứa các dòng code/log chạy
local ScrollingFrame = Instance.new("ScrollingFrame")
ScrollingFrame.Parent = MainFrame
ScrollingFrame.BackgroundTransparency = 1
ScrollingFrame.Position = UDim2.new(0, 5, 0, 40)
ScrollingFrame.Size = UDim2.new(1, -10, 1, -45)
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollingFrame.ScrollBarThickness = 6

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = ScrollingFrame
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 3)

-- Hàm thêm dòng log mới vào bảng
local function AddLog(message, msgType)
    local TextLabel = Instance.new("TextLabel")
    TextLabel.Parent = ScrollingFrame
    TextLabel.BackgroundTransparency = 1
    TextLabel.Size = UDim2.new(1, 0, 0, 20)
    TextLabel.Font = Enum.Font.Code -- Font chữ giống code/console trên PC
    TextLabel.TextSize = 13
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel.TextWrapped = true
    TextLabel.Text = "[" .. os.Hms or "Log" .. "] " .. tostring(message)
    
    -- Phân loại màu sắc giống F9 thật (Print: Trắng, Warn: Vàng, Error: Đỏ)
    if msgType == Enum.MessageType.MessageOutput then
        TextLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
    elseif msgType == Enum.MessageType.MessageWarning then
        TextLabel.TextColor3 = Color3.fromRGB(255, 220, 50)
    elseif msgType == Enum.MessageType.MessageError then
        TextLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
    else
        TextLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    end
    
    -- Tự động cập nhật kích thước cuộn
    ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y)
    ScrollingFrame.CanvasPosition = Vector2.new(0, ScrollingFrame.CanvasSize.Y)
end

-- Bắt sự kiện log từ hệ thống game (LogService)
local LogService = game:GetService("LogService")
LogService.MessageOut:Connect(function(message, messageType)
    AddLog(message, messageType)
end)

-- Xử lý bật/tắt giao diện khi bấm nút
local function ToggleUI()
    MainFrame.Visible = not MainFrame.Visible
end

ToggleButton.MouseButton1Click:Connect(ToggleUI)
CloseBtn.MouseButton1Click:Connect(ToggleUI)

-- Thông báo mẫu khi bật script thành công
AddLog("--- Đã khởi động Console F9 giả lập trên Mobile ---", Enum.MessageType.MessageOutput)
