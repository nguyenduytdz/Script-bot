-- ==========================================
-- HOP SEVER STANDALONE SCRIPT (MOBILE UI)
-- ==========================================
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local SoundService = game:GetService("SoundService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local FONT_HEAVY = Enum.Font.GothamBlack

local function getUiParent()
    local ok, cg = pcall(function()
        return game:GetService("CoreGui")
    end)
    if ok and cg then
        local testOk = pcall(function()
            local f = Instance.new("Folder")
            f.Parent = cg
            f:Destroy()
        end)
        if testOk then
            return cg
        end
    end
    return LocalPlayer:WaitForChild("PlayerGui")
end

local UiParent = getUiParent()
local httpRequest = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request

-- Âm thanh click
local clickSound = Instance.new("Sound")
clickSound.Name = "HopClickSound"
clickSound.SoundId = "rbxassetid://6895079853"
clickSound.Volume = 0.45
clickSound.Parent = SoundService

local function playClick(pitch)
    pcall(function()
        clickSound.PlaybackSpeed = pitch or 1.0
        clickSound:Play()
    end)
end

local function onClick(btn, fn, pitch)
    btn.MouseButton1Click:Connect(function()
        playClick(pitch or 1.0)
        fn()
    end)
end

local function attachDrag(target, handle)
    handle = handle or target
    handle.Active = true
    local dragging = false
    local activeInput = nil
    local startPos = Vector2.zero
    local originUiPos = UDim2.new()

    handle.InputBegan:Connect(function(input)
        if dragging then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            activeInput = input
            startPos = input.Position
            originUiPos = target.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End and input == activeInput then
                    dragging = false
                    activeInput = nil
                end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if not dragging or input ~= activeInput then return end
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            local delta = input.Position - startPos
            target.Position = UDim2.new(
                originUiPos.X.Scale,
                originUiPos.X.Offset + delta.X,
                originUiPos.Y.Scale,
                originUiPos.Y.Offset + delta.Y
            )
        end
    end)
end

-- Xóa bản cũ nếu chạy lại
if UiParent:FindFirstChild("StandaloneHopSeverUI") then
    UiParent.StandaloneHopSeverUI:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "StandaloneHopSeverUI"
ScreenGui.DisplayOrder = 1000
ScreenGui.IgnoreGuiInset = true
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = UiParent

-- Nút nổi bật/tắt menu Hop
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Name = "HopToggleBtn"
ToggleBtn.Size = UDim2.new(0, 40, 0, 40)
ToggleBtn.Position = UDim2.new(0.04, 0, 0.16, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(28, 32, 48)
ToggleBtn.TextColor3 = Color3.fromRGB(90, 220, 255)
ToggleBtn.TextSize = 18
ToggleBtn.Font = FONT_HEAVY
ToggleBtn.Text = "🌐"
ToggleBtn.ZIndex = 20
ToggleBtn.Parent = ScreenGui
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1, 0)
local ToggleStroke = Instance.new("UIStroke")
ToggleStroke.Color = Color3.fromRGB(90, 220, 255)
ToggleStroke.Thickness = 2
ToggleStroke.Parent = ToggleBtn
attachDrag(ToggleBtn, ToggleBtn)

-- Khung chính Hop Server
local HopFrame = Instance.new("Frame")
HopFrame.Name = "HopMainFrame"
HopFrame.Size = UDim2.new(0, 266, 0, 268)
HopFrame.Position = UDim2.new(0.04, 0, 0.23, 0)
HopFrame.BackgroundColor3 = Color3.fromRGB(20, 22, 32)
HopFrame.BorderSizePixel = 0
HopFrame.ZIndex = 10
HopFrame.Parent = ScreenGui
Instance.new("UICorner", HopFrame).CornerRadius = UDim.new(0, 15)
local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(75, 195, 255)
MainStroke.Thickness = 1.5
MainStroke.Parent = HopFrame
attachDrag(HopFrame)

local isVisible = true
onClick(ToggleBtn, function()
    isVisible = not isVisible
    HopFrame.Visible = isVisible
end, 1.05)

local HeaderLbl = Instance.new("TextLabel")
HeaderLbl.Size = UDim2.new(1, -12, 0, 22)
HeaderLbl.Position = UDim2.new(0, 6, 0, 4)
HeaderLbl.BackgroundTransparency = 1
HeaderLbl.Text = "🌐 HOP SEVER TOOL"
HeaderLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
HeaderLbl.TextSize = 11
HeaderLbl.Font = FONT_HEAVY
HeaderLbl.ZIndex = 11
HeaderLbl.Parent = HopFrame

local StatusLbl = Instance.new("TextLabel")
StatusLbl.Size = UDim2.new(1, -12, 0, 28)
StatusLbl.Position = UDim2.new(0, 6, 0, 28)
StatusLbl.BackgroundColor3 = Color3.fromRGB(32, 34, 48)
StatusLbl.TextColor3 = Color3.fromRGB(255, 240, 140)
StatusLbl.TextSize = 9
StatusLbl.Font = FONT_HEAVY
StatusLbl.TextWrapped = true
StatusLbl.TextXAlignment = Enum.TextXAlignment.Left
StatusLbl.Text = " 🔍 CHỌN LOẠI SEVER ĐỂ TÌM"
StatusLbl.ZIndex = 12
StatusLbl.Parent = HopFrame
Instance.new("UICorner", StatusLbl).CornerRadius = UDim.new(0, 7)

local function setStatus(msg)
    StatusLbl.Text = " " .. tostring(msg)
end

local OnePlrBtn = Instance.new("TextButton")
OnePlrBtn.Size = UDim2.new(0.32, -5, 0, 25)
OnePlrBtn.Position = UDim2.new(0, 6, 0, 60)
OnePlrBtn.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
OnePlrBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
OnePlrBtn.TextSize = 8
OnePlrBtn.Font = FONT_HEAVY
OnePlrBtn.Text = "👤 1 NGƯỜI"
OnePlrBtn.ZIndex = 12
OnePlrBtn.Parent = HopFrame
Instance.new("UICorner", OnePlrBtn).CornerRadius = UDim.new(0, 6)

local LowPingBtn = Instance.new("TextButton")
LowPingBtn.Size = UDim2.new(0.32, -5, 0, 25)
LowPingBtn.Position = UDim2.new(0.34, -1, 0, 60)
LowPingBtn.BackgroundColor3 = Color3.fromRGB(61, 139, 255)
LowPingBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
LowPingBtn.TextSize = 8
LowPingBtn.Font = FONT_HEAVY
LowPingBtn.Text = "⚡ PING THẤP"
LowPingBtn.ZIndex = 12
LowPingBtn.Parent = HopFrame
Instance.new("UICorner", LowPingBtn).CornerRadius = UDim.new(0, 6)

local OldSrvBtn = Instance.new("TextButton")
OldSrvBtn.Size = UDim2.new(0.32, -5, 0, 25)
OldSrvBtn.Position = UDim2.new(0.68, -2, 0, 60)
OldSrvBtn.BackgroundColor3 = Color3.fromRGB(155, 89, 182)
OldSrvBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
OldSrvBtn.TextSize = 8
OldSrvBtn.Font = FONT_HEAVY
OldSrvBtn.Text = "🕰️ SEVER CŨ"
OldSrvBtn.ZIndex = 12
OldSrvBtn.Parent = HopFrame
Instance.new("UICorner", OldSrvBtn).CornerRadius = UDim.new(0, 6)

local CopyJobBtn = Instance.new("TextButton")
CopyJobBtn.Size = UDim2.new(1, -12, 0, 22)
CopyJobBtn.Position = UDim2.new(0, 6, 0, 89)
CopyJobBtn.BackgroundColor3 = Color3.fromRGB(230, 126, 34)
CopyJobBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CopyJobBtn.TextSize = 8
CopyJobBtn.Font = FONT_HEAVY
CopyJobBtn.Text = "📋 COPY JOBID SEVER HIỆN TẠI"
CopyJobBtn.ZIndex = 12
CopyJobBtn.Parent = HopFrame
Instance.new("UICorner", CopyJobBtn).CornerRadius = UDim.new(0, 6)

local JobInput = Instance.new("TextBox")
JobInput.Size = UDim2.new(1, -68, 0, 24)
JobInput.Position = UDim2.new(0, 6, 0, 115)
JobInput.BackgroundColor3 = Color3.fromRGB(32, 34, 48)
JobInput.TextColor3 = Color3.fromRGB(255, 255, 255)
JobInput.PlaceholderColor3 = Color3.fromRGB(185, 192, 215)
JobInput.PlaceholderText = "📌 DÁN JOBID..."
JobInput.Text = ""
JobInput.TextSize = 9
JobInput.Font = FONT_HEAVY
JobInput.ClearTextOnFocus = false
JobInput.ZIndex = 12
JobInput.Parent = HopFrame
Instance.new("UICorner", JobInput).CornerRadius = UDim.new(0, 6)

local JoinBtn = Instance.new("TextButton")
JoinBtn.Size = UDim2.new(0, 52, 0, 24)
JoinBtn.Position = UDim2.new(1, -58, 0, 115)
JoinBtn.BackgroundColor3 = Color3.fromRGB(31, 184, 154)
JoinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
JoinBtn.TextSize = 9
JoinBtn.Font = FONT_HEAVY
JoinBtn.Text = "🚀 JOIN"
JoinBtn.ZIndex = 12
JoinBtn.Parent = HopFrame
Instance.new("UICorner", JoinBtn).CornerRadius = UDim.new(0, 6)

local ListScroll = Instance.new("ScrollingFrame")
ListScroll.Size = UDim2.new(1, -12, 0, 112)
ListScroll.Position = UDim2.new(0, 6, 0, 144)
ListScroll.BackgroundColor3 = Color3.fromRGB(24, 26, 38)
ListScroll.BorderSizePixel = 0
ListScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
ListScroll.ScrollBarThickness = 3
ListScroll.ZIndex = 12
ListScroll.Parent = HopFrame
Instance.new("UICorner", ListScroll).CornerRadius = UDim.new(0, 7)

local ListLayout = Instance.new("UIListLayout")
ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
ListLayout.Padding = UDim.new(0, 4)
ListLayout.Parent = ListScroll

local isBusy = false

local function rawGet(url)
    if httpRequest then
        local ok, res = pcall(function()
            return httpRequest({
                Url = url,
                Method = "GET",
                Headers = {
                    ["Accept"] = "application/json",
                    ["User-Agent"] = "Roblox/WinInet"
                }
            })
        end)
        if ok and type(res) == "table" and type(res.Body) == "string" and res.Body ~= "" then
            return res.Body
        end
    end
    local gOk, gBody = pcall(function()
        return HttpService:GetAsync(url, false)
    end)
    if gOk and type(gBody) == "string" and gBody ~= "" then
        return gBody
    end
    return nil
end

local function fetchServers(maxPages, sortOrder)
    local result = {}
    local cursor = ""
    local page = 0
    while page < (maxPages or 4) do
        page = page + 1
        local url = string.format(
            "https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=%s&limit=100%s",
            game.PlaceId,
            sortOrder or "Asc",
            cursor ~= "" and ("&cursor=" .. HttpService:UrlEncode(cursor)) or ""
        )
        local body = rawGet(url)
        if not body then
            if #result > 0 then break end
            return nil, "KHÔNG KẾT NỐI ĐƯỢC MÁY CHỦ"
        end
        local clean = body:match("%b{}") or body
        local ok, decoded = pcall(function()
            return HttpService:JSONDecode(clean)
        end)
        if ok and type(decoded) == "table" then
            if type(decoded.data) == "table" then
                for _, srv in ipairs(decoded.data) do
                    if type(srv) == "table" and srv.id and tostring(srv.id) ~= tostring(game.JobId) then
                        table.insert(result, srv)
                    end
                end
            end
            if type(decoded.nextPageCursor) == "string" and decoded.nextPageCursor ~= "" then
                cursor = decoded.nextPageCursor
            else
                break
            end
        else
            if #result > 0 then break end
            return nil, "DỮ LIỆU SEVER CHƯA SẴN SÀNG"
        end
    end
    return result, nil
end

local function joinJob(jobId, tag)
    local cleanId = tostring(jobId or ""):gsub("^%s+", ""):gsub("%s+$", "")
    if cleanId == "" then
        setStatus("⚠️ HÃY DÁN JOBID TRƯỚC KHI JOIN!")
        return
    end
    setStatus("🔄 ĐANG JOIN " .. tostring(tag or cleanId:sub(1, 12)) .. "...")
    local ok, err = pcall(function()
        TeleportService:TeleportToPlaceInstance(game.PlaceId, cleanId, LocalPlayer)
    end)
    if not ok then
        setStatus("❌ LỖI JOIN: " .. tostring(err))
    end
end

local function renderRows(rows, prefix)
    for _, ch in ipairs(ListScroll:GetChildren()) do
        if ch:IsA("Frame") then ch:Destroy() end
    end
    for i, srv in ipairs(rows) do
        local row = Instance.new("Frame")
        row.Size = UDim2.new(1, -6, 0, 34)
        row.BackgroundColor3 = Color3.fromRGB(38, 42, 60)
        row.BorderSizePixel = 0
        row.LayoutOrder = i
        row.ZIndex = 13
        row.Parent = ListScroll
        Instance.new("UICorner", row).CornerRadius = UDim.new(0, 6)

        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, -54, 1, 0)
        lbl.Position = UDim2.new(0, 6, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
        lbl.TextSize = 9
        lbl.Font = FONT_HEAVY
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.TextWrapped = true
        lbl.Text = string.format(
            "SEVER %d: %s NGƯỜI | %sMS\nID: %s",
            i,
            tostring(srv.playing or "?"),
            tostring(srv.ping or "?"),
            tostring(srv.id):sub(1, 12) .. "..."
        )
        lbl.ZIndex = 14
        lbl.Parent = row

        local b = Instance.new("TextButton")
        b.Size = UDim2.new(0, 44, 0, 22)
        b.Position = UDim2.new(1, -48, 0.5, -11)
        b.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
        b.TextColor3 = Color3.fromRGB(255, 255, 255)
        b.TextSize = 9
        b.Font = FONT_HEAVY
        b.Text = "JOIN"
        b.ZIndex = 14
        b.Parent = row
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 5)

        local srvId = tostring(srv.id)
        onClick(b, function()
            JobInput.Text = srvId
            joinJob(srvId, "SEVER " .. i)
        end, 1.1)
    end
    ListScroll.CanvasSize = UDim2.new(0, 0, 0, #rows * 38 + 6)
    setStatus(string.format("%s: TÌM THẤY %d SEVER", prefix, #rows))
end

local function loadMode(mode)
    if isBusy then return end
    isBusy = true
    setStatus("🔍 ĐANG TÌM DANH SÁCH SEVER...")
    task.spawn(function()
        local order = (mode == "old") and "Desc" or "Asc"
        local servers, err = fetchServers(4, order)
        if not servers then
            setStatus("⚠️ " .. tostring(err))
            isBusy = false
            return
        end

        local out = {}
        if mode == "one" then
            for _, s in ipairs(servers) do
                if (tonumber(s.playing) or 999) == 1 then
                    table.insert(out, s)
                end
            end
            if #out == 0 then
                table.sort(servers, function(a, b)
                    return (tonumber(a.playing) or 999) < (tonumber(b.playing) or 999)
                end)
                for i = 1, math.min(15, #servers) do table.insert(out, servers[i]) end
            end
            renderRows(out, "👤 1 NGƯỜI")
        elseif mode == "ping" then
            for _, s in ipairs(servers) do
                if s.ping ~= nil then table.insert(out, s) end
            end
            table.sort(out, function(a, b)
                return (tonumber(a.ping) or 9999) < (tonumber(b.ping) or 9999)
            end)
            local top = {}
            for i = 1, math.min(20, #out) do table.insert(top, out[i]) end
            renderRows(top, "⚡ PING THẤP")
        else
            for i = 1, math.min(20, #servers) do table.insert(out, servers[i]) end
            renderRows(out, "🕰️ SEVER CŨ")
        end

        isBusy = false
    end)
end

onClick(OnePlrBtn, function() loadMode("one") end)
onClick(LowPingBtn, function() loadMode("ping") end)
onClick(OldSrvBtn, function() loadMode("old") end)

onClick(CopyJobBtn, function()
    local cur = tostring(game.JobId ~= "" and game.JobId or "Studio / Local")
    local okCopy = false
    if setclipboard then
        pcall(function() setclipboard(cur); okCopy = true end)
    elseif toclipboard then
        pcall(function() toclipboard(cur); okCopy = true end)
    end
    JobInput.Text = cur
    setStatus(okCopy and ("📋 ĐÃ COPY JOBID: " .. cur:sub(1, 16)) or ("📌 ĐÃ ĐIỀN JOBID: " .. cur:sub(1, 16)))
end)

onClick(JoinBtn, function()
    joinJob(JobInput.Text, "JOBID")
end)
