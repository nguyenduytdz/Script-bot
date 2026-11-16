local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

print("=== TEST SEARCH ===")
print("HttpEnabled:", HttpService.HttpEnabled)

local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player:WaitForChild("PlayerGui")

local box = Instance.new("TextBox")
box.Size = UDim2.new(0, 200, 0, 40)
box.Position = UDim2.new(0, 10, 0, 100)
box.Text = ""
box.PlaceholderText = "Nhập username..."
box.BackgroundColor3 = Color3.new(1, 1, 1)
box.TextColor3 = Color3.new(0, 0, 0)
box.Parent = screenGui

local btn = Instance.new("TextButton")
btn.Size = UDim2.new(0, 200, 0, 40)
btn.Position = UDim2.new(0, 10, 0, 150)
btn.Text = "TÌM"
btn.BackgroundColor3 = Color3.new(0, 0.5, 0)
btn.TextColor3 = Color3.new(1, 1, 1)
btn.Parent = screenGui

local out = Instance.new("TextLabel")
out.Size = UDim2.new(0, 400, 0, 200)
out.Position = UDim2.new(0, 10, 0, 200)
out.BackgroundColor3 = Color3.new(0, 0, 0)
out.TextColor3 = Color3.new(0, 1, 0)
out.TextXAlignment = Enum.TextXAlignment.Left
out.TextYAlignment = Enum.TextYAlignment.Top
out.TextWrapped = true
out.Font = Enum.Font.Code
out.Text = "Chờ..."
out.Parent = screenGui

btn.MouseButton1Click:Connect(function()
    local name = box.Text
    if name:sub(1, 1) == "@" then name = name:sub(2) end
    out.Text = "Đang tìm: " .. name

    if not HttpService.HttpEnabled then
        out.Text = "❌ HTTP ĐANG TẮT!\nBật: Game Settings → Security → Allow HTTP Requests"
        return
    end

    local url = "https://users.roproxy.com/v1/users/search?keyword="
        .. HttpService:UrlEncode(name) .. "&limit=5"
    out.Text = "URL: " .. url

    local ok, res = pcall(function()
        return HttpService:GetAsync(url, true)
    end)

    if not ok then
        out.Text = "❌ LỖI HTTP:\n" .. tostring(res)
        warn("HTTP ERROR:", res)
        return
    end

    out.Text = "✅ RAW RESPONSE:\n" .. string.sub(res, 1, 300)
    print("RAW:", res)
end)
