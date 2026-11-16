-- Services
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Xóa GUI cũ nếu đã chạy trước đó để tránh trùng lặp
if PlayerGui:FindFirstChild("AnyUserJoinerMenu") then
	PlayerGui.AnyUserJoinerMenu:Destroy()
end

-- Tạo ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AnyUserJoinerMenu"
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
MainFrame.Visible = false
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
TitleLabel.Text = "Tìm & Join Bất Kỳ Người Chơi"
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

-- Ô nhập Tên người chơi cần tìm
local SearchBox = Instance.new("TextBox")
SearchBox.Size = UDim2.new(1, -95, 0, 35)
SearchBox.Position = UDim2.new(0, 10, 0, 48)
SearchBox.BackgroundColor3 = Color3.fromRGB(45, 45, 52)
SearchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
SearchBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
SearchBox.PlaceholderText = "Nhập @username..."
SearchBox.Text = ""
SearchBox.TextSize = 14
SearchBox.Font = Enum.Font.SourceSans
SearchBox.ClearTextOnFocus = false
SearchBox.Parent = MainFrame

local SearchCorner = Instance.new("UICorner")
SearchCorner.CornerRadius = UDim.new(0, 8)
SearchCorner.Parent = SearchBox

-- Nút Tìm Kiếm (Search Button)
local SearchBtn = Instance.new("TextButton")
SearchBtn.Size = UDim2.new(0, 75, 0, 35)
SearchBtn.Position = UDim2.new(1, -85, 0, 48)
SearchBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 250)
SearchBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SearchBtn.Text = "Check"
SearchBtn.TextSize = 13
SearchBtn.Font = Enum.Font.SourceSansBold
SearchBtn.Parent = MainFrame

local SearchBtnCorner = Instance.new("UICorner")
SearchBtnCorner.CornerRadius = UDim.new(0, 8)
SearchBtnCorner.Parent = SearchBtn

-- ScrollingFrame hiển thị kết quả
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

-- Hàm hiển thị kết quả
local function DisplayResult(username, isOnline, statusText, placeId, gameId)
	for _, child in ipairs(ScrollingFrame:GetChildren()) do
		if child:IsA("Frame") then
			child:Destroy()
		end
	end

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
	NameLabel.Text = "@" .. username
	NameLabel.Parent = ResultCard

	local StatusLabel = Instance.new("TextLabel")
	StatusLabel.Size = UDim2.new(0.6, 0, 0.5, 0)
	StatusLabel.Position = UDim2.new(0, 10, 0.5, 0)
	StatusLabel.BackgroundTransparency = 1
	StatusLabel.TextColor3 = isOnline and Color3.fromRGB(50, 205, 50) or Color3.fromRGB(200, 80, 80)
	StatusLabel.TextSize = 12
	StatusLabel.Font = Enum.Font.SourceSans
	StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
	StatusLabel.Text = statusText
	StatusLabel.Parent = ResultCard

	local JoinBtn = Instance.new("TextButton")
	JoinBtn.Size = UDim2.new(0, 80, 0, 30)
	JoinBtn.Position = UDim2.new(1, -90, 0.5, -15)
	JoinBtn.TextSize = 13
	JoinBtn.Font = Enum.Font.SourceSansBold
	JoinBtn.Parent = ResultCard

	local JoinCorner = Instance.new("UICorner")
	JoinCorner.CornerRadius = UDim.new(0, 6)
	JoinCorner.Parent = JoinBtn

	if isOnline and placeId and placeId ~= 0 then
		JoinBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 90)
		JoinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
		JoinBtn.Text = "Join"
		JoinBtn.MouseButton1Click:Connect(function()
			TeleportService:TeleportToPlaceInstance(placeId, gameId, LocalPlayer)
		end)
	else
		JoinBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
		JoinBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
		JoinBtn.Text = "N/A"
	end

	ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 66)
end

-- Hàm tìm kiếm người chơi
local function SearchUser()
	local query = SearchBox.Text
	if query == "" then return end

	if string.sub(query, 1, 1) == "@" then
		query = string.sub(query, 2)
	end

	DisplayResult(query, false, "Đang tìm kiếm...", nil, nil)

	task.spawn(function()
		local success, targetUserId = pcall(function()
			return Players:GetUserIdFromNameAsync(query)
		end)

		if not success or not targetUserId then
			DisplayResult(query, false, "Không tìm thấy người chơi!", nil, nil)
			return
		end

		local presenceSuccess, placeId, gameId = pcall(function()
			local url = "https://presence.roblox.com/v1/presence/users"
			local data = HttpService:JSONEncode({ userIds = { targetUserId } })
			local response = HttpService:PostAsync(url, data)
			local decoded = HttpService:JSONDecode(response)
			
			if decoded and decoded.presenceStates and decoded.presenceStates[1] then
				local state = decoded.presenceStates[1]
				if state.userPresenceType == 2 then
					return state.rootPlaceId, state.gameId
				end
			end
			return nil, nil
		end)

		if presenceSuccess and placeId and placeId ~= 0 then
			DisplayResult(query, true, "Đang Online (Có thể Join)", placeId, gameId)
		else
			DisplayResult(query, false, "Offline hoặc Riêng tư", nil, nil)
		end
	end)
end

SearchBtn.MouseButton1Click:Connect(SearchUser)
SearchBox.FocusLost:Connect(function(enterPressed)
	if enterPressed then
		SearchUser()
	end
end)

print("Script Menu Loaded Successfully!")
