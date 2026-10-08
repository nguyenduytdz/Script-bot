--========================================================--
--          MODERN DUY DASHBOARD - FULL VERSION
--          Server Hop 1 Player Fixed
--========================================================--

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")

local LocalPlayer = Players.LocalPlayer

--========================================================--
-- REMOTES
--========================================================--

local Remotes = ReplicatedStorage:WaitForChild("DuyRemotes")

local GetServers = Remotes:WaitForChild("GetServers")
local JoinServer = Remotes:WaitForChild("JoinServer")
local TeleportPlayer = Remotes:FindFirstChild("TeleportPlayer")

--========================================================--
-- CONFIG
--========================================================--

local CONFIG = {
    MaxServerPlayers = 1,
    Theme = Color3.fromRGB(115,75,255)
}

--========================================================--
-- GUI
--========================================================--

local gui = Instance.new("ScreenGui")
gui.Name = "ModernDuyDashboard"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

--========================================================--
-- FUNCTIONS
--========================================================--

local function Corner(parent, radius)

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0,radius or 12)
    c.Parent = parent

end


local function Stroke(parent,color,transparency)

    local s = Instance.new("UIStroke")

    s.Color = color or Color3.fromRGB(70,70,90)
    s.Transparency = transparency or 0
    s.Thickness = 1

    s.Parent = parent

end


local function Label(parent,text,size,pos,font)

    local l = Instance.new("TextLabel")

    l.BackgroundTransparency = 1
    l.Text = text
    l.TextColor3 = Color3.fromRGB(235,235,245)

    l.TextSize = size or 14
    l.Font = font or Enum.Font.Gotham

    l.TextXAlignment = Enum.TextXAlignment.Left

    l.Position = pos or UDim2.new()

    l.Size = UDim2.new(1,0,0,24)

    l.Parent = parent

    return l

end


local function Button(parent,text,pos,size)

    local b = Instance.new("TextButton")

    b.Text = text
    b.Font = Enum.Font.GothamBold
    b.TextSize = 13

    b.TextColor3 = Color3.fromRGB(240,240,245)

    b.BackgroundColor3 = Color3.fromRGB(35,35,48)

    b.Position = pos
    b.Size = size

    b.AutoButtonColor = false

    b.Parent = parent

    Corner(b,10)

    Stroke(
        b,
        Color3.fromRGB(70,70,90),
        0.2
    )

    return b

end

--========================================================--
-- MAIN
--========================================================--

local main = Instance.new("Frame")

main.Size = UDim2.fromOffset(650,410)

main.Position =
    UDim2.new(
        0.5,
        -325,
        0.5,
        -205
    )

main.BackgroundColor3 =
    Color3.fromRGB(17,17,24)

main.Parent = gui

Corner(main,18)

Stroke(
    main,
    Color3.fromRGB(75,75,100),
    0.15
)

--========================================================--
-- DRAG MENU
--========================================================--

do

    local dragging = false
    local dragStart
    local startPos

    main.InputBegan:Connect(function(input)

        if input.UserInputType ==
            Enum.UserInputType.MouseButton1
            or
            input.UserInputType ==
            Enum.UserInputType.Touch
        then

            dragging = true

            dragStart = input.Position
            startPos = main.Position

            input.Changed:Connect(function()

                if input.UserInputState ==
                    Enum.UserInputState.End
                then

                    dragging = false

                end

            end)

        end

    end)


    UserInputService.InputChanged:Connect(function(input)

        if not dragging then
            return
        end

        if input.UserInputType ==
            Enum.UserInputType.MouseMovement
            or
            input.UserInputType ==
            Enum.UserInputType.Touch
        then

            local delta =
                input.Position - dragStart

            main.Position =
                UDim2.new(
                    startPos.X.Scale,
                    startPos.X.Offset + delta.X,
                    startPos.Y.Scale,
                    startPos.Y.Offset + delta.Y
                )

        end

    end)

end

--========================================================--
-- TOP BAR
--========================================================--

local top = Instance.new("Frame")

top.BackgroundTransparency = 1
top.Size = UDim2.new(1,0,0,62)

top.Parent = main


local avatar = Instance.new("ImageLabel")

avatar.BackgroundTransparency = 1

avatar.Size =
    UDim2.fromOffset(42,42)

avatar.Position =
    UDim2.fromOffset(16,10)

avatar.Parent = top

Corner(avatar,12)


local thumbOK,thumb =
    pcall(function()

        return Players:GetUserThumbnailAsync(
            LocalPlayer.UserId,
            Enum.ThumbnailType.HeadShot,
            Enum.ThumbnailSize.Size100x100
        )

    end)

if thumbOK then
    avatar.Image = thumb
end


local nameText =
    Label(
        top,
        LocalPlayer.DisplayName,
        16,
        UDim2.fromOffset(70,9),
        Enum.Font.GothamBold
    )

nameText.Size =
    UDim2.new(1,-170,0,22)


local userText =
    Label(
        top,
        "@" .. LocalPlayer.Name,
        12,
        UDim2.fromOffset(70,31)
    )

userText.TextColor3 =
    Color3.fromRGB(145,145,165)


local close =
    Button(
        top,
        "×",
        UDim2.new(1,-54,0,13),
        UDim2.fromOffset(38,36)
    )

close.TextSize = 20

close.MouseButton1Click:Connect(function()

    main.Visible = false

end)

--========================================================--
-- SIDE MENU
--========================================================--

local side = Instance.new("Frame")

side.Position =
    UDim2.fromOffset(12,72)

side.Size =
    UDim2.fromOffset(130,320)

side.BackgroundColor3 =
    Color3.fromRGB(23,23,32)

side.Parent = main

Corner(side,14)


local content = Instance.new("Frame")

content.Position =
    UDim2.fromOffset(154,72)

content.Size =
    UDim2.new(1,-166,1,-86)

content.BackgroundColor3 =
    Color3.fromRGB(21,21,29)

content.Parent = main

Corner(content,14)

Stroke(
    content,
    Color3.fromRGB(55,55,75),
    0.35
)

--========================================================--
-- PAGES
--========================================================--

local Pages = {}

local function CreatePage(name)

    local page = Instance.new("Frame")

    page.Name = name

    page.Size =
        UDim2.new(1,-20,1,-20)

    page.Position =
        UDim2.fromOffset(10,10)

    page.BackgroundTransparency = 1

    page.Visible = false

    page.Parent = content

    Pages[name] = page

    return page

end


local Home =
    CreatePage("Home")

local PlayersPage =
    CreatePage("Players")

local HopPage =
    CreatePage("ServerHop")

local SettingsPage =
    CreatePage("Settings")


local CurrentPage

local NavButtons = {}

local function ShowPage(name)

    for pageName,page in pairs(Pages) do

        page.Visible =
            pageName == name

    end

    CurrentPage = name

    for pageName,button in pairs(NavButtons) do

        if pageName == name then

            button.BackgroundColor3 =
                CONFIG.Theme

        else

            button.BackgroundColor3 =
                Color3.fromRGB(30,30,42)

        end

    end

end

--========================================================--
-- NAVIGATION
--========================================================--

local function Nav(name,y,icon)

    local pageName = name

    if name == "Server Hop" then
        pageName = "ServerHop"
    end

    local b =
        Button(
            side,
            icon .. "  " .. name,
            UDim2.fromOffset(8,y),
            UDim2.new(1,-16,0,42)
        )

    b.TextXAlignment =
        Enum.TextXAlignment.Left

    b.TextSize = 12

    b.MouseButton1Click:Connect(function()

        ShowPage(pageName)

    end)

    NavButtons[pageName] = b

end


Nav("Home",12,"⌂")
Nav("Players",60,"♟")
Nav("Server Hop",108,"↻")
Nav("Settings",156,"⚙")

--========================================================--
-- HOME
--========================================================--

Label(
    Home,
    "DASHBOARD",
    21,
    UDim2.fromOffset(8,4),
    Enum.Font.GothamBold
)


local homeSub =
    Label(
        Home,
        "Thông tin phiên hiện tại",
        12,
        UDim2.fromOffset(8,32)
    )

homeSub.TextColor3 =
    Color3.fromRGB(140,140,160)


local FPSLabel =
    Label(
        Home,
        "FPS: ...",
        16,
        UDim2.fromOffset(8,78),
        Enum.Font.GothamBold
    )


local PingLabel =
    Label(
        Home,
        "MS: ...",
        16,
        UDim2.fromOffset(8,110),
        Enum.Font.GothamBold
    )


local PlayerCountLabel =
    Label(
        Home,
        "Players: 0",
        16,
        UDim2.fromOffset(8,142),
        Enum.Font.GothamBold
    )


local JobLabel =
    Label(
        Home,
        "Job ID: " ..
        string.sub(game.JobId,1,16) ..
        "...",
        12,
        UDim2.fromOffset(8,180)
    )

JobLabel.TextColor3 =
    Color3.fromRGB(145,145,165)


local UserIDLabel =
    Label(
        Home,
        "User ID: " ..
        tostring(LocalPlayer.UserId),
        12,
        UDim2.fromOffset(8,210)
    )

UserIDLabel.TextColor3 =
    Color3.fromRGB(145,145,165)

--========================================================--
-- PLAYERS
--========================================================--

Label(
    PlayersPage,
    "PLAYERS",
    21,
    UDim2.fromOffset(8,4),
    Enum.Font.GothamBold
)


local PlayerList =
    Instance.new("ScrollingFrame")

PlayerList.Position =
    UDim2.fromOffset(8,42)

PlayerList.Size =
    UDim2.new(1,-16,1,-50)

PlayerList.BackgroundTransparency = 1

PlayerList.ScrollBarThickness = 4

PlayerList.CanvasSize =
    UDim2.new()

PlayerList.Parent =
    PlayersPage


local PlayerLayout =
    Instance.new("UIListLayout")

PlayerLayout.Padding =
    UDim.new(0,7)

PlayerLayout.Parent =
    PlayerList


local function RebuildPlayers()

    for _,object in
        ipairs(PlayerList:GetChildren())
    do

        if object:IsA("Frame") then

            object:Destroy()

        end

    end


    for _,player in
        ipairs(Players:GetPlayers())
    do

        local row =
            Instance.new("Frame")

        row.Size =
            UDim2.new(1,-8,0,54)

        row.BackgroundColor3 =
            Color3.fromRGB(30,30,42)

        row.Parent =
            PlayerList

        Corner(row,10)


        local image =
            Instance.new("ImageLabel")

        image.BackgroundTransparency = 1

        image.Size =
            UDim2.fromOffset(40,40)

        image.Position =
            UDim2.fromOffset(7,7)

        image.Parent =
            row

        Corner(image,10)


        task.spawn(function()

            local ok,url =
                pcall(function()

                    return Players:GetUserThumbnailAsync(
                        player.UserId,
                        Enum.ThumbnailType.HeadShot,
                        Enum.ThumbnailSize.Size100x100
                    )

                end)

            if ok then
                image.Image = url
            end

        end)


        local display =
            Label(
                row,
                player.DisplayName,
                13,
                UDim2.fromOffset(56,5),
                Enum.Font.GothamBold
            )

        display.Size =
            UDim2.new(1,-145,0,20)


        local username =
            Label(
                row,
                "@" .. player.Name,
                11,
                UDim2.fromOffset(56,27)
            )

        username.TextColor3 =
            Color3.fromRGB(140,140,160)


        -- TELE chỉ hoạt động nếu game của bạn có TeleportPlayer RemoteFunction
        if TeleportPlayer then

            local Tele =
                Button(
                    row,
                    "TELE",
                    UDim2.new(1,-76,0,9),
                    UDim2.fromOffset(66,36)
                )

            Tele.MouseButton1Click:Connect(function()

                local ok,result =
                    pcall(function()

                        return TeleportPlayer:InvokeServer(
                            player.UserId
                        )

                    end)

                if not ok or
                    not result or
                    not result.ok
                then

                    Tele.Text = "ERR"

                    task.delay(
                        1.2,
                        function()

                            if Tele.Parent then
                                Tele.Text = "TELE"
                            end

                        end
                    )

                end

            end)

        end

    end


    task.defer(function()

        PlayerList.CanvasSize =
            UDim2.fromOffset(
                0,
                PlayerLayout.AbsoluteContentSize.Y + 8
            )

    end)

end


Players.PlayerAdded:Connect(
    RebuildPlayers
)

Players.PlayerRemoving:Connect(
    RebuildPlayers
)

RebuildPlayers()

--========================================================--
-- SERVER HOP
--========================================================--

Label(
    HopPage,
    "SERVER HOP",
    21,
    UDim2.fromOffset(8,4),
    Enum.Font.GothamBold
)


local HopStatus =
    Label(
        HopPage,
        "Tìm server ≤ 1 người",
        12,
        UDim2.fromOffset(8,34)
    )

HopStatus.TextColor3 =
    Color3.fromRGB(145,145,165)


local SearchButton =
    Button(
        HopPage,
        "⌕  TÌM SERVER",
        UDim2.fromOffset(8,68),
        UDim2.fromOffset(170,44)
    )

SearchButton.BackgroundColor3 =
    CONFIG.Theme


local HopButton =
    Button(
        HopPage,
        "↻  HOP SERVER",
        UDim2.fromOffset(188,68),
        UDim2.fromOffset(170,44)
    )

HopButton.BackgroundColor3 =
    CONFIG.Theme


local ServerList =
    Instance.new("ScrollingFrame")

ServerList.Position =
    UDim2.fromOffset(8,124)

ServerList.Size =
    UDim2.new(1,-16,1,-132)

ServerList.BackgroundTransparency = 1

ServerList.ScrollBarThickness = 4

ServerList.Parent =
    HopPage


local ServerLayout =
    Instance.new("UIListLayout")

ServerLayout.Padding =
    UDim.new(0,7)

ServerLayout.Parent =
    ServerList


local CachedServers = {}

local Searching = false


local function ClearServerRows()

    for _,object in
        ipairs(ServerList:GetChildren())
    do

        if object:IsA("Frame") then

            object:Destroy()

        end

    end

end


local function RenderServers(servers)

    ClearServerRows()

    CachedServers = servers or {}


    if #CachedServers == 0 then

        HopStatus.Text =
            "Không tìm thấy server 1 người."

        return

    end


    HopStatus.Text =
        "Tìm thấy " ..
        tostring(#CachedServers) ..
        " server 1 người."


    for _,server in
        ipairs(CachedServers)
    do

        local row =
            Instance.new("Frame")

        row.Size =
            UDim2.new(1,-8,0,55)

        row.BackgroundColor3 =
            Color3.fromRGB(30,30,42)

        row.Parent =
            ServerList

        Corner(row,10)


        local info =
            Label(
                row,
                "Server • " ..
                tostring(server.playing) ..
                "/" ..
                tostring(server.maxPlayers),
                13,
                UDim2.fromOffset(12,7),
                Enum.Font.GothamBold
            )

        info.Size =
            UDim2.new(1,-125,0,22)


        local id =
            Label(
                row,
                string.sub(
                    server.id,
                    1,
                    18
                ) .. "...",
                10,
                UDim2.fromOffset(12,29)
            )

        id.TextColor3 =
            Color3.fromRGB(120,120,140)


        local Join =
            Button(
                row,
                "JOIN",
                UDim2.new(1,-95,0,9),
                UDim2.fromOffset(82,37)
            )

        Join.BackgroundColor3 =
            CONFIG.Theme


        Join.MouseButton1Click:Connect(function()

            Join.Text = "..."

            local ok,result =
                pcall(function()

                    return JoinServer:InvokeServer(
                        server.id
                    )

                end)


            if not ok or
                not result or
                not result.ok
            then

                Join.Text = "ERR"

                HopStatus.Text =
                    (
                        result
                        and result.error
                    )
                    or
                    "Không thể vào server."


                task.delay(
                    1.2,
                    function()

                        if Join.Parent then
                            Join.Text = "JOIN"
                        end

                    end
                )

            end

        end)

    end


    task.defer(function()

        ServerList.CanvasSize =
            UDim2.fromOffset(
                0,
                ServerLayout.AbsoluteContentSize.Y + 8
            )

    end)

end


--========================================================--
-- FIND SERVER 1 PLAYER
--========================================================--

local function FindServers()

    if Searching then
        return
    end

    Searching = true

    SearchButton.Text =
        "ĐANG TÌM..."

    HopStatus.Text =
        "Đang tìm server ≤ 1 người..."


    local success,result =
        pcall(function()

            return GetServers:InvokeServer(1)

        end)


    if not success or not result then

        HopStatus.Text =
            "Không kết nối được ServerScript."

        SearchButton.Text =
            "⌕  TÌM SERVER"

        Searching = false

        return

    end


    if not result.ok then

        HopStatus.Text =
            result.error
            or
            "Không tìm thấy server."

        ClearServerRows()

        SearchButton.Text =
            "⌕  TÌM SERVER"

        Searching = false

        return

    end


    local found = {}


    for _,server in
        ipairs(result.servers or {})
    do

        local players =
            tonumber(server.playing)
            or 0


        if players <= 1 then

            table.insert(
                found,
                server
            )

        end

    end


    table.sort(
        found,
        function(a,b)

            return a.playing <
                b.playing

        end
    )


    RenderServers(found)


    SearchButton.Text =
        "⌕  TÌM SERVER"

    Searching = false

end


SearchButton.MouseButton1Click:Connect(
    FindServers
)

--========================================================--
-- HOP SERVER
--========================================================--

HopButton.MouseButton1Click:Connect(function()

    if Searching then
        return
    end


    FindServers()


    task.spawn(function()

        local timeout =
            os.clock() + 8


        while Searching
            and os.clock() < timeout
        do

            task.wait(0.1)

        end


        if CachedServers[1] then

            JoinServer:InvokeServer(
                CachedServers[1].id
            )

        end

    end)

end)

--========================================================--
-- SETTINGS
--========================================================--

Label(
    SettingsPage,
    "SETTINGS",
    21,
    UDim2.fromOffset(8,4),
    Enum.Font.GothamBold
)


Label(
    SettingsPage,
    "Màu giao diện",
    13,
    UDim2.fromOffset(8,45),
    Enum.Font.GothamBold
)


local Themes = {

    {
        "Tím",
        Color3.fromRGB(115,75,255)
    },

    {
        "Xanh",
        Color3.fromRGB(35,145,255)
    },

    {
        "Đỏ",
        Color3.fromRGB(230,65,75)
    },

    {
        "Xanh lá",
        Color3.fromRGB(50,190,105)
    },

    {
        "Cam",
        Color3.fromRGB(245,135,45)
    }

}


for i,theme in
    ipairs(Themes)
do

    local b =
        Button(
            SettingsPage,
            theme[1],
            UDim2.fromOffset(
                8 + ((i-1)%3)*110,
                78 + math.floor((i-1)/3)*50
            ),
            UDim2.fromOffset(100,40)
        )


    b.MouseButton1Click:Connect(function()

        CONFIG.Theme =
            theme[2]


        SearchButton.BackgroundColor3 =
            CONFIG.Theme

        HopButton.BackgroundColor3 =
            CONFIG.Theme


        for pageName,button in
            pairs(NavButtons)
        do

            if pageName ==
                CurrentPage
            then

                button.BackgroundColor3 =
                    CONFIG.Theme

            end

        end

    end)

end

--========================================================--
-- FLOATING ICON
--========================================================--

local OpenButton =
    Instance.new("ImageButton")

OpenButton.Name =
    "OpenButton"

OpenButton.Size =
    UDim2.fromOffset(58,58)

OpenButton.Position =
    UDim2.new(1,-76,1,-78)

OpenButton.BackgroundColor3 =
    CONFIG.Theme

OpenButton.Image =
    avatar.Image

OpenButton.Parent =
    gui

Corner(OpenButton,18)

Stroke(
    OpenButton,
    Color3.fromRGB(255,255,255),
    0.45
)


OpenButton.MouseButton1Click:Connect(function()

    main.Visible =
        not main.Visible

end)

--========================================================--
-- DRAG FLOATING ICON
--========================================================--

do

    local dragging = false
    local dragStart
    local startPos


    OpenButton.InputBegan:Connect(function(input)

        if input.UserInputType ==
            Enum.UserInputType.MouseButton1
            or
            input.UserInputType ==
            Enum.UserInputType.Touch
        then

            dragging = true

            dragStart =
                input.Position

            startPos =
                OpenButton.Position


            input.Changed:Connect(function()

                if input.UserInputState ==
                    Enum.UserInputState.End
                then

                    dragging = false

                end

            end)

        end

    end)


    UserInputService.InputChanged:Connect(function(input)

        if not dragging then
            return
        end


        if input.UserInputType ==
            Enum.UserInputType.MouseMovement
            or
            input.UserInputType ==
            Enum.UserInputType.Touch
        then

            local delta =
                input.Position -
                dragStart


            OpenButton.Position =
                UDim2.new(
                    startPos.X.Scale,
                    startPos.X.Offset + delta.X,
                    startPos.Y.Scale,
                    startPos.Y.Offset + delta.Y
                )

        end

    end)

end

--========================================================--
-- FPS + PING
--========================================================--

local Frames = 0
local LastTime = os.clock()


RunService.RenderStepped:Connect(function()

    Frames += 1

    local now =
        os.clock()


    if now - LastTime >= 1 then

        FPSLabel.Text =
            "FPS: " ..
            tostring(Frames)

        Frames = 0
        LastTime = now


        local ping = 0


        pcall(function()

            ping =
                math.floor(
                    Stats
                    .Network
                    .ServerStatsItem
                    ["Data Ping"]
                    :GetValue()
                )

        end)


        PingLabel.Text =
            "MS: " ..
            tostring(ping)


        PlayerCountLabel.Text =
            "Players: " ..
            tostring(
                #Players:GetPlayers()
            )

    end

end)

--========================================================--
-- START
--========================================================--

ShowPage("Home")
