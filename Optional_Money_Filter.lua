-- ===== GUI (đã sửa vị trí, không bị topbar che) =====
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FriendMenuGui"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true      -- bỏ qua vùng topbar
screenGui.DisplayOrder = 999
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Nút mở: đặt bên phải, dưới topbar, không bị che
local openBtn = Instance.new("TextButton")
openBtn.Size = UDim2.new(0, 130, 0, 40)
openBtn.Position = UDim2.new(1, -150, 0, 60)   -- góc phải trên
openBtn.AnchorPoint = Vector2.new(0, 0)
openBtn.Text = "👥 Bạn Bè"
openBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
openBtn.TextColor3 = Color3.new(1, 1, 1)
openBtn.Font = Enum.Font.GothamBold
openBtn.TextSize = 16
openBtn.ZIndex = 10
openBtn.Parent = screenGui

-- Frame chính: căn giữa màn hình, kích thước vừa phải
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 420, 0, 520)
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)   -- căn giữa chuẩn
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.Visible = false
mainFrame.ZIndex = 5
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

-- Tiêu đề: cao hơn, chữ to hơn
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -40, 0, 45)
title.Position = UDim2.new(0, 0, 0, 0)
title.Text = "Danh Sách Bạn Bè"
title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.ZIndex = 6
title.Parent = mainFrame

-- Nút đóng: to hơn, dễ bấm
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 40, 0, 40)
closeBtn.Position = UDim2.new(1, -45, 0, 2)
closeBtn.Text = "X"
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 18
closeBtn.ZIndex = 7
closeBtn.Parent = mainFrame

-- Ô tìm kiếm: chữ to, rõ
local searchBox = Instance.new("TextBox")
searchBox.Size = UDim2.new(1, -20, 0, 40)
searchBox.Position = UDim2.new(0, 10, 0, 55)
searchBox.PlaceholderText = "Nhập @username để tìm..."
searchBox.Text = ""
searchBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
searchBox.TextColor3 = Color3.new(1, 1, 1)
searchBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
searchBox.Font = Enum.Font.Gotham
searchBox.TextSize = 16
searchBox.ZIndex = 6
searchBox.Parent = mainFrame

-- Nút tìm kiếm
local searchBtn = Instance.new("TextButton")
searchBtn.Size = UDim2.new(1, -20, 0, 40)
searchBtn.Position = UDim2.new(0, 10, 0, 100)
searchBtn.Text = "🔍 Tìm Kiếm"
searchBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
searchBtn.TextColor3 = Color3.new(1, 1, 1)
searchBtn.Font = Enum.Font.GothamBold
searchBtn.TextSize = 16
searchBtn.ZIndex = 6
searchBtn.Parent = mainFrame

-- Khung kết quả tìm kiếm: cao hơn để đủ chỗ
local searchResult = Instance.new("Frame")
searchResult.Size = UDim2.new(1, -20, 0, 90)
searchResult.Position = UDim2.new(0, 10, 0, 145)
searchResult.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
searchResult.Visible = false
searchResult.ZIndex = 6
searchResult.Parent = mainFrame

-- Danh sách bạn bè cuộn
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, -20, 1, -250)
scrollFrame.Position = UDim2.new(0, 10, 0, 245)
scrollFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
scrollFrame.ScrollBarThickness = 8
scrollFrame.ZIndex = 6
scrollFrame.Parent = mainFrame

local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 6)
listLayout.Parent = scrollFrame
