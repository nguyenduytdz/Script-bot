-- Services
local Players = game:GetService("Players")
local SocialService = game:GetService("SocialService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer

-- Tạo ScreenGui chứa UI dạng rounded-square gọn nhẹ cho mobile
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FriendJoinerMenu"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Main Frame (Menu chính)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 320, 0, 400)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

-- Bo tròn góc UI
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

-- Thanh tiêu đề (Header)
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, 0, 0, 40)
TitleLabel.BackgroundColor3 = Color3.fromRGB(45, 45, 52)
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 16
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.Text = "Danh Sách Bạn Bè & Join"
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

-- ScrollingFrame chứa danh sách bạn bè
local ScrollingFrame = Instance.new("ScrollingFrame")
ScrollingFrame.Size = UDim2.new(1, -10, 1, -50)
ScrollingFrame.Position = UDim2.new(0, 5, 0, 45)
ScrollingFrame.BackgroundTransparency = 1
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollingFrame.ScrollBarThickness = 6
ScrollingFrame.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 6)
UIListLayout.Parent = ScrollingFrame

-- Nút mở menu nổi trên màn hình (Floating Button)
local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "ToggleButton"
ToggleButton.Size = UDim2.new(0, 50, 0, 50)
ToggleButton.Position = UDim2.new(0, 20, 0.5, -25)
ToggleButton.BackgroundColor3 = Color3.fromRGB(50, 150, 250)
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.Text = "Friends"
ToggleButton.TextSize = 12
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.Parent = ScreenGui

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 25)
ToggleButton.Parent = ToggleButton

ToggleButton.MouseButton1Click:Connect(function()
	MainFrame.Visible = not MainFrame.Visible
end)

-- Hàm tải và hiển thị danh sách bạn bè
local function LoadFriends()
	-- Xóa các item cũ trong danh sách
	for _, child in ipairs(ScrollingFrame:GetChildren()) do
		if child:IsA("Frame") then
			child:Destroy()
		end
	end

	pcall(function()
		local pages = Players:GetFriendsAsync(LocalPlayer.UserId)
		local count = 0

		while true do
			local items = pages:GetCurrentPage()
			for _, friend in ipairs(items) do
				count += 1
				
				-- Tạo khung cho từng người bạn
				local FriendCard = Instance.new("Frame")
				FriendCard.Size = UDim2.new(1, -10, 0, 50)
				FriendCard.BackgroundColor3 = Color3.fromRGB(45, 45, 52)
				FriendCard.BorderSizePixel = 0
				FriendCard.Parent = ScrollingFrame

				local CardCorner = Instance.new("UICorner")
				CardCorner.CornerRadius = UDim.new(0, 8)
				CardCorner.Parent = FriendCard

				-- Tên hiển thị
				local NameLabel = Instance.new("TextLabel")
				NameLabel.Size = UDim2.new(0.6, 0, 0.5, 0)
				NameLabel.Position = UDim2.new(0, 10, 0, 5)
				NameLabel.BackgroundTransparency = 1
				NameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
				NameLabel.TextSize = 14
				NameLabel.Font = Enum.Font.SourceSansBold
				NameLabel.TextXAlignment = Enum.TextXAlignment.Left
				NameLabel.Text = friend.Username
				NameLabel.Parent = FriendCard

				-- Trạng thái (Game đang chơi hoặc Off)
				local StatusLabel = Instance.new("TextLabel")
				StatusLabel.Size = UDim2.new(0.6, 0, 0.5, 0)
				StatusLabel.Position = UDim2.new(0, 10, 0.5, 0)
				StatusLabel.BackgroundTransparency = 1
				StatusLabel.TextColor3 = Color3.fromRGB(170, 170, 170)
				StatusLabel.TextSize = 12
				StatusLabel.Font = Enum.Font.SourceSans
				StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
				
				local isOnline = friend.IsOnline
				local placeId = friend.PlaceId
				local gameId = friend.GameId

				if not isOnline then
					StatusLabel.Text = "Offline"
					StatusLabel.TextColor3 = Color3.fromRGB(120, 120, 120)
				else
					StatusLabel.Text = "Đang Online (Khác/Cùng Game)"
					StatusLabel.TextColor3 = Color3.fromRGB(50, 205, 50)
				end
				StatusLabel.Parent = FriendCard

				-- Nút Join Server
				local JoinBtn = Instance.new("TextButton")
				JoinBtn.Size = UDim2.new(0, 80, 0, 30)
				JoinBtn.Position = UDim2.new(1, -90, 0.5, -15)
				JoinBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 90)
				JoinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
				JoinBtn.Text = "Join"
				JoinBtn.TextSize = 13
				JoinBtn.Font = Enum.Font.SourceSansBold
				JoinBtn.Parent = FriendCard

				local JoinCorner = Instance.new("UICorner")
				JoinCorner.CornerRadius = UDim.new(0, 6)
				JoinCorner.Parent = JoinBtn

				-- Sự kiện khi bấm Join
				if isOnline and placeId and placeId ~= 0 then
					JoinBtn.MouseButton1Click:Connect(function()
						TeleportService:TeleportToPlaceInstance(placeId, gameId, LocalPlayer)
					end)
				else
					JoinBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
					JoinBtn.Text = "N/A"
				end
			end

			if pages.IsFinished then
				break
			else
				pages:AdvanceToNextPageAsync()
			end
		end

		ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, count * 56)
	end)
end

-- Tải danh sách bạn bè khi khởi chạy script
LoadFriends()
