-- Services
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

-- Tạo ScreenGui chứa UI dạng rounded-square gọn nhẹ cho mobile
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AnyUserJoinerMenu"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Main Frame (Menu chính)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 320, 0, 420)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -210)
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
TitleLabel.TextSize = 15
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.Text = "Tìm & Join Bất Kỳ Người Chơi Nào"
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

-- Ô nhập Tên người chơi cần tìm (Hỗ trợ gõ @username)
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

-- ScrollingFrame hiển thị kết quả tìm kiếm
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

-- Nút mở menu nổi trên màn hình (Floating Button)
local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "ToggleButton"
ToggleButton.Size = UDim2.new(0, 50, 0, 50)
ToggleButton.Position = UDim2.new(0, 20, 0.5, -25)
ToggleButton.BackgroundColor3 = Color3.fromRGB(50, 150, 250)
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.Text = "Search"
ToggleButton.TextSize = 12
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.Parent = ScreenGui

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 25)
ToggleButton.Parent = ToggleButton

ToggleButton.MouseButton1Click:Connect(function()
	MainFrame.Visible = not MainFrame.Visible
end)

-- Hàm hiển thị kết quả lên giao diện
local function DisplayResult(username, isOnline, statusText, placeId, gameId)
	-- Xóa kết quả cũ
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

	-- Tên người chơi
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

	-- Trạng thái
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

	-- Nút Join
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

-- Hàm xử lý tìm kiếm bất kỳ người chơi nào qua Roblox Web API / Player Search
local function SearchUser()
	local query = SearchBox.Text
	if query == "" then return end

	-- Lọc bỏ ký tự @ nếu có
	if string.sub(query, 1, 1) == "@" then
		query = string.sub(query, 2)
	end

	DisplayResult(query, false, "Đang tìm kiếm...", nil, nil)

	task.spawn(function()
		-- Bước 1: Lấy UserId từ Username thông qua HttpPost/HttpGet hoặc Players API
		local success, targetUserId = pcall(function()
			return Players:GetUserIdFromNameAsync(query)
		end)

		if not success or not targetUserId then
			DisplayResult(query, false, "Không tìm thấy người chơi!", nil, nil)
			return
		end

		-- Bước 2: Kiểm tra trạng thái hoạt động thông qua UserService hoặc Teleport API nếu công khai
		-- Sử dụng phương thức thông qua game presence API của Roblox
		local presenceSuccess, placeId, gameId = pcall(function()
			-- Yêu cầu lấy thông tin vị trí của user bất kỳ qua HttpService gọi API công khai của Roblox nếu game cho phép
			-- Hoặc kiểm tra qua SocialService/Player:IsFriendsWith (nếu cần thiết)
			-- Ở đây dùng cơ chế kiểm tra qua game instance chung hoặc API chỗ đứng hiện tại của user
			local Http = game:GetService("HttpService")
			local url = "https://presence.roblox.com/v1/presence/users"
			local data = Http:JSONEncode({ userIds = { targetUserId } })
			local response = Http:PostAsync(url, data)
			local decoded = Http:JSONDecode(response)
			
			if decoded and decoded.presenceStates and decoded.presenceStates[1] then
				local state = decoded.presenceStates[1]
				if state.userPresenceType == 2 then -- 2 nghĩa là đang trong game (InGame)
					return state.rootPlaceId, state.gameId
				end
			end
			return nil, nil
		end)

		if presenceSuccess and placeId and placeId ~= 0 then
			DisplayResult(query, true, "Đang Online (Có thể Join)", placeId, gameId)
		else
			-- Trường hợp họ bật chế độ riêng tư (Private) hoặc Offline
			DisplayResult(query, false, "Offline hoặc Riêng tư (Private)", nil, nil)
		end
	end)
end

-- Bắt sự kiện khi bấm nút Check hoặc nhấn Enter
SearchBtn.MouseButton1Click:Connect(SearchUser)
SearchBox.FocusLost:Connect(function(enterPressed)
	if enterPressed then
		SearchUser()
	end
end)
