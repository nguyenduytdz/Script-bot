--========================================================
-- MODERN DUY DASHBOARD
-- HOME / PLAYERS / SERVER HOP / TELE PLAYER / SETTINGS
--========================================================

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

--========================================================
-- CONFIG
--========================================================

local Theme = Color3.fromRGB(115, 75, 255)

local Colors = {
	Background = Color3.fromRGB(16,16,23),
	Panel = Color3.fromRGB(22,22,31),
	Panel2 = Color3.fromRGB(29,29,41),
	Text = Color3.fromRGB(240,240,248),
	SubText = Color3.fromRGB(140,140,160),
	Border = Color3.fromRGB(70,70,90)
}

--========================================================
-- REMOTES
-- Không WaitForChild để menu luôn hiện
--========================================================

local GetServers
local JoinServer
local TeleportPlayer

local function RefreshRemotes()
	local folder = ReplicatedStorage:FindFirstChild("DuyRemotes")

	if not folder then
		return false
	end

	GetServers = folder:FindFirstChild("GetServers")
	JoinServer = folder:FindFirstChild("JoinServer")
	TeleportPlayer = folder:FindFirstChild("TeleportPlayer")

	return true
end

RefreshRemotes()

ReplicatedStorage.ChildAdded:Connect(function(child)
	if child.Name == "DuyRemotes" then
		task.wait()
		RefreshRemotes()
	end
end)

--========================================================
-- GUI
--========================================================

local Old = PlayerGui:FindFirstChild("ModernDuyDashboard")
if Old then
	Old:Destroy()
end

local Gui = Instance.new("ScreenGui")
Gui.Name = "ModernDuyDashboard"
Gui.ResetOnSpawn = false
Gui.IgnoreGuiInset = true
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Gui.Parent = PlayerGui

--========================================================
-- HELPERS
--========================================================

local function Corner(obj, radius)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, radius or 10)
	c.Parent = obj
end

local function Border(obj, color, transparency)
	local s = Instance.new("UIStroke")
	s.Color = color or Colors.Border
	s.Transparency = transparency or 0
	s.Thickness = 1
	s.Parent = obj
end

local function MakeLabel(parent, text, size, pos, font)
	local l = Instance.new("TextLabel")
	l.BackgroundTransparency = 1
	l.Text = text
	l.TextColor3 = Colors.Text
	l.TextSize = size or 14
	l.Font = font or Enum.Font.Gotham
	l.TextXAlignment = Enum.TextXAlignment.Left
	l.Position = pos or UDim2.new()
	l.Size = UDim2.new(1,0,0,25)
	l.Parent = parent
	return l
end

local function MakeButton(parent, text, pos, size)
	local b = Instance.new("TextButton")
	b.Text = text
	b.TextColor3 = Colors.Text
	b.TextSize = 13
	b.Font = Enum.Font.GothamBold
	b.BackgroundColor3 = Colors.Panel2
	b.AutoButtonColor = false
	b.Position = pos
	b.Size = size
	b.Parent = parent

	Corner(b, 10)
	Border(b, Colors.Border, .25)

	b.MouseEnter:Connect(function()
		b.BackgroundColor3 = Theme
	end)

	b.MouseLeave:Connect(function()
		if b ~= SelectedNav then
			b.BackgroundColor3 = Colors.Panel2
		end
	end)

	return b
end

--========================================================
-- MAIN
--========================================================

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.fromOffset(700,440)
Main.Position = UDim2.new(.5,-350,.5,-220)
Main.BackgroundColor3 = Colors.Background
Main.Parent = Gui

Corner(Main,18)
Border(Main,Colors.Border,.15)

--========================================================
-- DRAG MAIN
--========================================================

do
	local dragging = false
	local startPos
	local startInput

	Main.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch then

			dragging = true
			startInput = input.Position
			startPos = Main.Position

			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if not dragging then return end

		if input.UserInputType == Enum.UserInputType.MouseMovement
			or input.UserInputType == Enum.UserInputType.Touch then

			local delta = input.Position - startInput

			Main.Position = UDim2.new(
				startPos.X.Scale,
				startPos.X.Offset + delta.X,
				startPos.Y.Scale,
				startPos.Y.Offset + delta.Y
			)
		end
	end)
end

--========================================================
-- TOP PROFILE
--========================================================

local Avatar = Instance.new("ImageLabel")
Avatar.BackgroundTransparency = 1
Avatar.Size = UDim2.fromOffset(44,44)
Avatar.Position = UDim2.fromOffset(15,10)
Avatar.Parent = Main
Corner(Avatar,13)

pcall(function()
	Avatar.Image = Players:GetUserThumbnailAsync(
		LocalPlayer.UserId,
		Enum.ThumbnailType.HeadShot,
		Enum.ThumbnailSize.Size100x100
	)
end)

MakeLabel(
	Main,
	LocalPlayer.DisplayName,
	16,
	UDim2.fromOffset(70,8),
	Enum.Font.GothamBold
)

local UserNameLabel = MakeLabel(
	Main,
	"@" .. LocalPlayer.Name,
	11,
	UDim2.fromOffset(70,31)
)

UserNameLabel.TextColor3 = Colors.SubText

local Close = MakeButton(
	Main,
	"×",
	UDim2.new(1,-52,0,10),
	UDim2.fromOffset(38,38)
)

Close.TextSize = 21

--========================================================
-- SIDEBAR
--========================================================

local Sidebar = Instance.new("Frame")
Sidebar.Position = UDim2.fromOffset(12,70)
Sidebar.Size = UDim2.fromOffset(145,355)
Sidebar.BackgroundColor3 = Colors.Panel
Sidebar.Parent = Main
Corner(Sidebar,14)

--========================================================
-- CONTENT
--========================================================

local Content = Instance.new("Frame")
Content.Position = UDim2.fromOffset(168,70)
Content.Size = UDim2.new(1,-180,1,-82)
Content.BackgroundColor3 = Colors.Panel
Content.Parent = Main
Corner(Content,14)

--========================================================
-- PAGES
--========================================================

local Pages = {}

local function NewPage(name)
	local page = Instance.new("Frame")
	page.Name = name
	page.BackgroundTransparency = 1
	page.Size = UDim2.new(1,-20,1,-20)
	page.Position = UDim2.fromOffset(10,10)
	page.Visible = false
	page.Parent = Content

	Pages[name] = page

	return page
end

local Home = NewPage("Home")
local PlayersPage = NewPage("Players")
local ServerPage = NewPage("ServerHop")
local TelePage = NewPage("Teleport")
local SettingsPage = NewPage("Settings")

--========================================================
-- NAVIGATION
--========================================================

local NavButtons = {}
local SelectedNav

local function ShowPage(name)
	for pageName,page in pairs(Pages) do
		page.Visible = pageName == name
	end

	for pageName,button in pairs(NavButtons) do
		if pageName == name then
			button.BackgroundColor3 = Theme
			SelectedNav = button
		else
			button.BackgroundColor3 = Colors.Panel2
		end
	end
end

local function AddNav(name, icon, y, page)
	local b = MakeButton(
		Sidebar,
		icon .. "  " .. name,
		UDim2.fromOffset(8,y),
		UDim2.new(1,-16,0,43)
	)

	b.TextXAlignment = Enum.TextXAlignment.Left
	b.TextSize = 12

	NavButtons[page] = b

	b.MouseButton1Click:Connect(function()
		ShowPage(page)
	end)
end

AddNav("Home","⌂",10,"Home")
AddNav("Players","♟",60,"Players")
AddNav("Server Hop","↻",110,"ServerHop")
AddNav("Tele Player","➤",160,"Teleport")
AddNav("Settings","⚙",210,"Settings")

--========================================================
-- HOME
--========================================================

MakeLabel(
	Home,
	"HOME",
	22,
	UDim2.fromOffset(8,3),
	Enum.Font.GothamBold
)

local HomeSub = MakeLabel(
	Home,
	"Thông tin phiên hiện tại",
	12,
	UDim2.fromOffset(8,33)
)

HomeSub.TextColor3 = Colors.SubText

local AvatarHome = Instance.new("ImageLabel")
AvatarHome.BackgroundTransparency = 1
AvatarHome.Size = UDim2.fromOffset(80,80)
AvatarHome.Position = UDim2.fromOffset(8,72)
AvatarHome.Image = Avatar.Image
AvatarHome.Parent = Home
Corner(AvatarHome,20)

MakeLabel(
	Home,
	LocalPlayer.DisplayName,
	17,
	UDim2.fromOffset(102,72),
	Enum.Font.GothamBold
)

local HomeUsername = MakeLabel(
	Home,
	"@" .. LocalPlayer.Name,
	12,
	UDim2.fromOffset(102,98)
)

HomeUsername.TextColor3 = Colors.SubText

local FPSLabel = MakeLabel(
	Home,
	"FPS: --",
	15,
	UDim2.fromOffset(8,175),
	Enum.Font.GothamBold
)

local PingLabel = MakeLabel(
	Home,
	"MS: --",
	15,
	UDim2.fromOffset(8,207),
	Enum.Font.GothamBold
)

local CountLabel = MakeLabel(
	Home,
	"Players: --",
	15,
	UDim2.fromOffset(8,239),
	Enum.Font.GothamBold
)

local UserIDLabel = MakeLabel(
	Home,
	"User ID: " .. LocalPlayer.UserId,
	11,
	UDim2.fromOffset(8,278)
)

UserIDLabel.TextColor3 = Colors.SubText

local JobLabel = MakeLabel(
	Home,
	"Job ID: " .. (game.JobId ~= "" and string.sub(game.JobId,1,22) .. "..." or "Studio"),
	11,
	UDim2.fromOffset(8,303)
)

JobLabel.TextColor3 = Colors.SubText

--========================================================
-- PLAYERS
--========================================================

MakeLabel(
	PlayersPage,
	"PLAYERS",
	21,
	UDim2.fromOffset(8,3),
	Enum.Font.GothamBold
)

local PlayerScroll = Instance.new("ScrollingFrame")
PlayerScroll.Position = UDim2.fromOffset(8,42)
PlayerScroll.Size = UDim2.new(1,-16,1,-50)
PlayerScroll.BackgroundTransparency = 1
PlayerScroll.ScrollBarThickness = 4
PlayerScroll.Parent = PlayersPage

local PlayerLayout = Instance.new("UIListLayout")
PlayerLayout.Padding = UDim.new(0,7)
PlayerLayout.Parent = PlayerScroll

local function BuildPlayers()
	for _,v in ipairs(PlayerScroll:GetChildren()) do
		if v:IsA("Frame") then
			v:Destroy()
		end
	end

	for _,player in ipairs(Players:GetPlayers()) do
		local Row = Instance.new("Frame")
		Row.Size = UDim2.new(1,-8,0,55)
		Row.BackgroundColor3 = Colors.Panel2
		Row.Parent = PlayerScroll
		Corner(Row,10)

		local Img = Instance.new("ImageLabel")
		Img.BackgroundTransparency = 1
		Img.Size = UDim2.fromOffset(41,41)
		Img.Position = UDim2.fromOffset(7,7)
		Img.Parent = Row
		Corner(Img,11)

		task.spawn(function()
			local ok,image = pcall(function()
				return Players:GetUserThumbnailAsync(
					player.UserId,
					Enum.ThumbnailType.HeadShot,
					Enum.ThumbnailSize.Size100x100
				)
			end)

			if ok then
				Img.Image = image
			end
		end)

		local N = MakeLabel(
			Row,
			player.DisplayName,
			13,
			UDim2.fromOffset(58,5),
			Enum.Font.GothamBold
		)

		N.Size = UDim2.new(1,-150,0,20)

		local U = MakeLabel(
			Row,
			"@" .. player.Name,
			10,
			UDim2.fromOffset(58,27)
		)

		U.TextColor3 = Colors.SubText

		local Tele = MakeButton(
			Row,
			"TELE",
			UDim2.new(1,-80,0,9),
			UDim2.fromOffset(70,37)
		)

		Tele.BackgroundColor3 = Theme

		Tele.MouseButton1Click:Connect(function()
			if TeleportPlayer then
				Tele.Text = "..."
				local ok = pcall(function()
					return TeleportPlayer:InvokeServer(player.UserId)
				end)

				if ok then
					Tele.Text = "TELE"
				else
					Tele.Text = "ERR"
					task.delay(1,function()
						if Tele.Parent then
							Tele.Text = "TELE"
						end
					end)
				end
			end
		end)
	end

	task.defer(function()
		PlayerScroll.CanvasSize = UDim2.fromOffset(
			0,
			PlayerLayout.AbsoluteContentSize.Y + 10
		)
	end)
end

Players.PlayerAdded:Connect(BuildPlayers)
Players.PlayerRemoving:Connect(BuildPlayers)

BuildPlayers()

--========================================================
-- SERVER HOP
--========================================================

MakeLabel(
	ServerPage,
	"SERVER HOP",
	21,
	UDim2.fromOffset(8,3),
	Enum.Font.GothamBold
)

local ServerStatus = MakeLabel(
	ServerPage,
	"Tìm server có tối đa 1 người",
	11,
	UDim2.fromOffset(8,33)
)

ServerStatus.TextColor3 = Colors.SubText

local SearchServer = MakeButton(
	ServerPage,
	"⌕  TÌM SERVER",
	UDim2.fromOffset(8,63),
	UDim2.fromOffset(180,43)
)

SearchServer.BackgroundColor3 = Theme

local ServerScroll = Instance.new("ScrollingFrame")
ServerScroll.Position = UDim2.fromOffset(8,118)
ServerScroll.Size = UDim2.new(1,-16,1,-126)
ServerScroll.BackgroundTransparency = 1
ServerScroll.ScrollBarThickness = 4
ServerScroll.Parent = ServerPage

local ServerLayout = Instance.new("UIListLayout")
ServerLayout.Padding = UDim.new(0,7)
ServerLayout.Parent = ServerScroll

local Searching = false
local CachedServers = {}

local function ClearServers()
	for _,v in ipairs(ServerScroll:GetChildren()) do
		if v:IsA("Frame") then
			v:Destroy()
		end
	end
end

local function DisplayServers(servers)
	ClearServers()

	CachedServers = servers or {}

	if #CachedServers == 0 then
		ServerStatus.Text = "Không tìm thấy server."
		return
	end

	ServerStatus.Text = "Tìm thấy " .. #CachedServers .. " server."

	for _,server in ipairs(CachedServers) do
		local Row = Instance.new("Frame")
		Row.Size = UDim2.new(1,-8,0,58)
		Row.BackgroundColor3 = Colors.Panel2
		Row.Parent = ServerScroll
		Corner(Row,10)

		local Info = MakeLabel(
			Row,
			"Server  •  " ..
				tostring(server.playing) ..
				"/" ..
				tostring(server.maxPlayers),
			13,
			UDim2.fromOffset(12,6),
			Enum.Font.GothamBold
		)

		Info.Size = UDim2.new(1,-130,0,21)

		local ID = MakeLabel(
			Row,
			string.sub(server.id,1,20) .. "...",
			10,
			UDim2.fromOffset(12,30)
		)

		ID.TextColor3 = Colors.SubText

		local Join = MakeButton(
			Row,
			"JOIN",
			UDim2.new(1,-92,0,10),
			UDim2.fromOffset(80,38)
		)

		Join.BackgroundColor3 = Theme

		Join.MouseButton1Click:Connect(function()
			RefreshRemotes()

			if not JoinServer then
				ServerStatus.Text = "DuyServer chưa được kết nối."
				return
			end

			Join.Text = "..."

			local ok,result = pcall(function()
				return JoinServer:InvokeServer(server.id)
			end)

			if not ok or not result or not result.ok then
				Join.Text = "JOIN"
				ServerStatus.Text =
					(result and result.error)
					or "Không thể vào server."
			end
		end)
	end

	task.defer(function()
		ServerScroll.CanvasSize = UDim2.fromOffset(
			0,
			ServerLayout.AbsoluteContentSize.Y + 10
		)
	end)
end

SearchServer.MouseButton1Click:Connect(function()
	if Searching then return end

	Searching = true
	SearchServer.Text = "ĐANG TÌM..."
	ServerStatus.Text = "Đang tìm server..."

	RefreshRemotes()

	if not GetServers then
		ServerStatus.Text = "DuyServer chưa được kết nối."
		SearchServer.Text = "⌕  TÌM SERVER"
		Searching = false
		return
	end

	local ok,result = pcall(function()
		return GetServers:InvokeServer(1)
	end)

	if not ok or not result then
		ServerStatus.Text = "Lỗi kết nối."
	else
		if result.ok then
			DisplayServers(result.servers or {})
		else
			ServerStatus.Text = result.error or "Không tìm thấy server."
		end
	end

	SearchServer.Text = "⌕  TÌM SERVER"
	Searching = false
end)

--========================================================
-- TELE PLAYER
--========================================================

MakeLabel(
	TelePage,
	"TELE ĐẾN NGƯỜI CHƠI",
	21,
	UDim2.fromOffset(8,3),
	Enum.Font.GothamBold
)

local TeleInfo = MakeLabel(
	TelePage,
	"Nhập username dạng @username",
	11,
	UDim2.fromOffset(8,35)
)

TeleInfo.TextColor3 = Colors.SubText

local UserBox = Instance.new("TextBox")
UserBox.PlaceholderText = "@username"
UserBox.Text = ""
UserBox.ClearTextOnFocus = false
UserBox.TextColor3 = Colors.Text
UserBox.PlaceholderColor3 = Colors.SubText
UserBox.TextSize = 13
UserBox.Font = Enum.Font.Gotham
UserBox.BackgroundColor3 = Colors.Panel2
UserBox.Position = UDim2.fromOffset(8,67)
UserBox.Size = UDim2.new(1,-16,0,44)
UserBox.Parent = TelePage
Corner(UserBox,10)
Border(UserBox,Colors.Border,.2)

local FindPlayerButton = MakeButton(
	TelePage,
	"TÌM NGƯỜI CHƠI",
	UDim2.fromOffset(8,120),
	UDim2.fromOffset(170,42)
)

FindPlayerButton.BackgroundColor3 = Theme

local TargetFrame = Instance.new("Frame")
TargetFrame.Position = UDim2.fromOffset(8,175)
TargetFrame.Size = UDim2.new(1,-16,0,90)
TargetFrame.BackgroundColor3 = Colors.Panel2
TargetFrame.Parent = TelePage
Corner(TargetFrame,12)

local TargetAvatar = Instance.new("ImageLabel")
TargetAvatar.BackgroundTransparency = 1
TargetAvatar.Size = UDim2.fromOffset(65,65)
TargetAvatar.Position = UDim2.fromOffset(12,12)
TargetAvatar.Parent = TargetFrame
Corner(TargetAvatar,16)

local TargetName = MakeLabel(
	TargetFrame,
	"Chưa chọn người chơi",
	15,
	UDim2.fromOffset(92,18),
	Enum.Font.GothamBold
)

local TargetUser = MakeLabel(
	TargetFrame,
	"",
	11,
	UDim2.fromOffset(92,44)
)

TargetUser.TextColor3 = Colors.SubText

local TeleTargetButton = MakeButton(
	TargetFrame,
	"TELE",
	UDim2.new(1,-92,0,25),
	UDim2.fromOffset(80,40)
)

TeleTargetButton.BackgroundColor3 = Theme

local TargetPlayer = nil

local function FindTarget()
	local text = UserBox.Text:gsub("%s+","")

	if text:sub(1,1) == "@" then
		text = text:sub(2)
	end

	if text == "" then
		TargetName.Text = "Nhập username trước"
		TargetPlayer = nil
		return
	end

	for _,player in ipairs(Players:GetPlayers()) do
		if string.lower(player.Name) == string.lower(text) then
			TargetPlayer = player
			TargetName.Text = player.DisplayName
			TargetUser.Text = "@" .. player.Name

			pcall(function()
				TargetAvatar.Image = Players:GetUserThumbnailAsync(
					player.UserId,
					Enum.ThumbnailType.HeadShot,
					Enum.ThumbnailSize.Size100x100
				)
			end)

			return
		end
	end

	TargetPlayer = nil
	TargetName.Text = "Không tìm thấy người chơi"
	TargetUser.Text = ""
end

FindPlayerButton.MouseButton1Click:Connect(FindTarget)

TeleTargetButton.MouseButton1Click:Connect(function()
	if not TargetPlayer then
		TargetName.Text = "Hãy tìm người chơi trước"
		return
	end

	RefreshRemotes()

	if not TeleportPlayer then
		TargetName.Text = "Teleport chưa được bật"
		return
	end

	TeleTargetButton.Text = "..."

	local ok,result = pcall(function()
		return TeleportPlayer:InvokeServer(TargetPlayer.UserId)
	end)

	if ok and result and result.ok then
		TeleTargetButton.Text = "TELE"
	else
		TeleTargetButton.Text = "ERR"

		task.delay(1,function()
			if TeleTargetButton.Parent then
				TeleTargetButton.Text = "TELE"
			end
		end)
	end
end)

--========================================================
-- SETTINGS
--========================================================

MakeLabel(
	SettingsPage,
	"SETTINGS",
	21,
	UDim2.fromOffset(8,3),
	Enum.Font.GothamBold
)

MakeLabel(
	SettingsPage,
	"Màu giao diện",
	13,
	UDim2.fromOffset(8,42),
	Enum.Font.GothamBold
)

local ThemeList = {
	{"Tím",Color3.fromRGB(115,75,255)},
	{"Xanh",Color3.fromRGB(35,145,255)},
	{"Đỏ",Color3.fromRGB(225,65,75)},
	{"Xanh lá",Color3.fromRGB(45,190,105)},
	{"Cam",Color3.fromRGB(245,135,45)},
	{"Hồng",Color3.fromRGB(235,70,155)}
}

local function ApplyTheme(color)
	Theme = color

	SearchServer.BackgroundColor3 = Theme
	FindPlayerButton.BackgroundColor3 = Theme
	TeleTargetButton.BackgroundColor3 = Theme

	for _,button in pairs(NavButtons) do
		if button == SelectedNav then
			button.BackgroundColor3 = Theme
		end
	end
end

for i,data in ipairs(ThemeList) do
	local name,color = data[1],data[2]

	local b = MakeButton(
		SettingsPage,
		name,
		UDim2.fromOffset(
			8 + ((i-1)%3)*112,
			72 + math.floor((i-1)/3)*50
		),
		UDim2.fromOffset(102,40)
	)

	b.MouseButton1Click:Connect(function()
		ApplyTheme(color)
	end)
end

--========================================================
-- FLOATING AVATAR BUTTON
--========================================================

local Floating = Instance.new("ImageButton")
Floating.Name = "FloatingAvatar"
Floating.Size = UDim2.fromOffset(60,60)
Floating.Position = UDim2.new(1,-76,1,-80)
Floating.BackgroundColor3 = Theme
Floating.Image = Avatar.Image
Floating.Parent = Gui
Corner(Floating,18)
Border(Floating,Color3.fromRGB(255,255,255),.45)

Close.MouseButton1Click:Connect(function()
	Main.Visible = false
end)

Floating.MouseButton1Click:Connect(function()
	Main.Visible = not Main.Visible
end)

--========================================================
-- DRAG FLOATING BUTTON
--========================================================

do
	local dragging = false
	local startInput
	local startPos

	Floating.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch then

			dragging = true
			startInput = input.Position
			startPos = Floating.Position

			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if not dragging then return end

		if input.UserInputType == Enum.UserInputType.MouseMovement
			or input.UserInputType == Enum.UserInputType.Touch then

			local delta = input.Position - startInput

			Floating.Position = UDim2.new(
				startPos.X.Scale,
				startPos.X.Offset + delta.X,
				startPos.Y.Scale,
				startPos.Y.Offset + delta.Y
			)
		end
	end)
end

--========================================================
-- FPS / PING
--========================================================

local frames = 0
local last = os.clock()

RunService.RenderStepped:Connect(function()
	frames += 1

	if os.clock() - last >= 1 then
		FPSLabel.Text = "FPS: " .. frames
		CountLabel.Text = "Players: " .. #Players:GetPlayers()

		local ping = 0

		pcall(function()
			ping = math.floor(
				Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
			)
		end)

		PingLabel.Text = "MS: " .. ping

		frames = 0
		last = os.clock()
	end
end)

--========================================================
-- START
--========================================================

ShowPage("Home")
Main.Visible = true
Floating.Visible = true
