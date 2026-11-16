-- Services
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Xóa GUI cũ nếu đã chạy trước đó để tránh trùng lặp
if PlayerGui:FindFirstChild("SafeUserJoinerMenu") then
	PlayerGui.SafeUserJoinerMenu:Destroy()
end

-- Tạo ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SafeUserJoinerMenu"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

-- Nút mở menu nổi trên màn hình (Floating Button)
local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "ToggleButton"
ToggleButton.Size = UDim2.new(0, 55, 0, 55)
ToggleButton.Position = UDim2.new(0, 20, 0.4, 0)
ToggleButton.BackgroundColor3 = Color3.fromRGB(50, 150, 250)
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.Text = "MENU"
ToggleButton.TextSize = 13
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.Active = true
ToggleButton.Draggable = true
ToggleButton.Parent = ScreenGui

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 28)
ToggleCorner.Parent = ToggleButton

-- Main Frame (Menu chính)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 320, 0, 420)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false -- Bật sẵn để test, bấm nút MENU để ẩn/hiện
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

-- Thanh tiêu đề (Header)
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, 0, 0, 40)
TitleLabel.BackgroundColor3 = Color3.fromRGB(45, 45, 52)
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 15
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.Text = "Menu Quét & Tìm Kiếm Người Chơi"
TitleLabel.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 12)
TitleCorner.Parent = TitleLabel

-- Nút Đóng (Close)
local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -35, 0, 5)
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.Text = "X"
CloseButton.TextSize = 14
CloseButton.Font = Enum.Font.SourceSansBold
CloseButton.Parent = TitleLabel

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 8)
CloseCorner.Parent = CloseButton

CloseButton.MouseButton1Click:Connect(function()
	MainFrame.Visible = false
end)

-- Ô nhập Tên người chơi cần tìm trong Server
local SearchBox = Instance.new("TextBox")
SearchBox.Size = UDim2.new(1, -95, 0, 35)
SearchBox.Position = UDim2.new(0, 10, 0, 48)
SearchBox.BackgroundColor3 = Color3.fromRGB(45, 45, 52)
SearchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
SearchBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
SearchBox.PlaceholderText = "Lọc tên trong server..."
SearchBox.Text = ""
SearchBox.TextSize = 14
SearchBox.Font = Enum.Font.SourceSans
SearchBox.ClearTextOnFocus = false
SearchBox.Parent = MainFrame

local SearchCorner = Instance.new("UICorner")
SearchCorner.CornerRadius = UDim.new(0, 8)
SearchCorner.Parent = SearchBox

-- Nút Làm mới (Refresh Button)
local RefreshBtn = Instance.new("TextButton")
RefreshBtn.Size = UDim2.new(0, 75, 0, 35)
RefreshBtn.Position = UDim2.new(1, -85, 0, 48)
RefreshBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 250)
RefreshBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
RefreshBtn.Text = "Reload"
RefreshBtn.TextSize = 13
RefreshBtn.Font = Enum.Font.SourceSansBold
RefreshBtn.Parent = MainFrame

local RefreshBtnCorner = Instance.new("UICorner")
RefreshBtnCorner.CornerRadius = UDim.new(0, 8)
RefreshBtnCorner.Parent = RefreshBtn

-- ScrollingFrame hiển thị danh sách
local ScrollingFrame = Instance.new("ScrollingFrame")
ScrollingFrame.Size = UDim2.new(1, -10, 1, -95)
ScrollingFrame.Position = UDim2.new(0, 5, 0, 90)
ScrollingFrame.BackgroundTransparency = 1
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollingFrame.ScrollBarThickness = 6
ScrollingFrame.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 6)
UIListLayout.Parent = ScrollingFrame

-- Sự kiện bấm nút Toggle để Bật / Tắt Menu
ToggleButton.MouseButton1Click:Connect(function()
	MainFrame.Visible = not MainFrame.Visible
end)

-- Hàm hiển thị danh sách người chơi trong server kèm trạng thái
local function LoadPlayerList(filter)
	for _, child in ipairs(ScrollingFrame:GetChildren()) do
		if child:IsA("Frame") then
			child:Destroy()
		end
	end

	filter = string.lower(filter or "")
	if string.sub(filter, 1, 1) == "@" then
		filter = string.sub(filter, 2)
	end

	local count = 0
	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= LocalPlayer then
			local name = string.lower(player.Name)
			local displayName = string.lower(player.DisplayName)

			if filter == "" or string.find(name, filter, 1, true) or string.find(displayName, filter, 1, true) then
				count += 1

				local ResultCard = Instance.new("Frame")
				ResultCard.Size = UDim2.new(1, -10, 0, 60)
				ResultCard.BackgroundColor3 = Color3.fromRGB(45, 45, 52)
				ResultCard.BorderSizePixel = 0
				ResultCard.Parent = ScrollingFrame

				local CardCorner = Instance.new("UICorner")
				CardCorner.CornerRadius = UDim.new(0, 8)
				CardCorner.Parent = ResultCard

				local NameLabel = Instance.new("TextLabel")
				NameLabel.Size = UDim2.new(0.6, 0, 0.5, 0)
				NameLabel.Position = UDim2.new(0, 10, 0, 5)
				NameLabel.BackgroundTransparency = 1
				NameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
				NameLabel.TextSize = 14
				NameLabel.Font = Enum.Font.SourceSansBold
				NameLabel.TextXAlignment = Enum.TextXAlignment.Left
				NameLabel.Text = "@" .. player.Name
				NameLabel.Parent = ResultCard

				local StatusLabel = Instance.new("TextLabel")
				StatusLabel.Size = UDim2.new(0.6, 0, 0.5, 0)
				StatusLabel.Position = UDim2.new(0, 10, 0.5, 0)
				StatusLabel.BackgroundTransparency = 1
				StatusLabel.TextColor3 = Color3.fromRGB(50, 205, 50)
				StatusLabel.TextSize = 12
				StatusLabel.Font = Enum.Font.SourceSans
				StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
				StatusLabel.Text = "Đang trong cùng Server"
				StatusLabel.Parent = ResultCard

				local InspectBtn = Instance.new("TextButton")
				InspectBtn.Size = UDim2.new(0, 80, 0, 30)
				InspectBtn.Position = UDim2.new(1, -90, 0.5, -15)
				InspectBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 90)
				InspectBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
				InspectBtn.Text = "Info"
				InspectBtn.TextSize = 13
				InspectBtn.Font = Enum.Font.SourceSansBold
				InspectBtn.Parent = ResultCard

				local BtnCorner = Instance.new("UICorner")
				BtnCorner.CornerRadius = UDim.new(0, 6)
				BtnCorner.Parent = InspectBtn
			end
		end
	end

	ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, count * 66)
end

SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
	LoadPlayerList(SearchBox.Text)
end)

RefreshBtn.MouseButton1Click:Connect(function()
	LoadPlayerList(SearchBox.Text)
end)

-- Tải lần đầu
LoadPlayerList("")
print("Safe Menu Loaded Successfully!")
