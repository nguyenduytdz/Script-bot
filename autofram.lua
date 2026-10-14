-- [[ BLOX FRUIT MASTER AUTO FARM FULL ALL-IN-ONE ]] --

local SuccessUI, Fluent = pcall(function()
    return loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
end)

local Window
if SuccessUI and Fluent then
    Window = Fluent:CreateWindow({
        Title = "Blox Fruits - Master Auto Farm FULL",
        SubTitle = "Auto Farm All Islands (Sea 1-2-3)",
        TabWidth = 160,
        Size = UDim2.fromOffset(550, 380),
        Theme = "Dark",
        MinimizeKey = Enum.KeyCode.RightControl
    })
end

local Tabs = { Main = Window:AddTab({ Title = "Trang Chính", Icon = "home" }) }

getgenv().MasterAutoFarm = getgenv().MasterAutoFarm or false
getgenv().SafeHeight = 15

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CommF = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_")

-- BẢNG DỮ LIỆU ĐẦY ĐỦ CÁC ĐẢO VÀ BÃI QUÁI (SEA 1)
local LevelData = {
    {Min = 1, Max = 9, Quest = "BanditQuest1", Name = "Bandit", Level = 1, QuestPos = CFrame.new(1059, 16, 1549), MobPos = CFrame.new(1145, 17, 1634)},
    {Min = 10, Max = 14, Quest = "JungleQuest", Name = "Monkey", Level = 1, QuestPos = CFrame.new(-1599, 37, 153), MobPos = CFrame.new(-1618, 22, 143)},
    {Min = 15, Max = 29, Quest = "JungleQuest", Name = "Gorilla", Level = 2, QuestPos = CFrame.new(-1599, 37, 153), MobPos = CFrame.new(-1237, 6, -486)},
    {Min = 30, Max = 39, Quest = "BuggyQuest1", Name = "Pirate", Level = 1, QuestPos = CFrame.new(-1140, 4, 3828), MobPos = CFrame.new(-1205, 4, 3915)},
    {Min = 40, Max = 59, Quest = "BuggyQuest1", Name = "Brute", Level = 2, QuestPos = CFrame.new(-1140, 4, 3828), MobPos = CFrame.new(-1370, 15, 4130)},
    {Min = 60, Max = 74, Quest = "DesertQuest", Name = "Desert Bandit", Level = 1, QuestPos = CFrame.new(896, 6, 4388), MobPos = CFrame.new(980, 6, 4420)},
    {Min = 75, Max = 89, Quest = "DesertQuest", Name = "Desert Officer", Level = 2, QuestPos = CFrame.new(896, 6, 4388), MobPos = CFrame.new(1550, 6, 4380)},
    {Min = 90, Max = 99, Quest = "SnowQuest", Name = "Snow Bandit", Level = 1, QuestPos = CFrame.new(1385, 87, -1298), MobPos = CFrame.new(1280, 105, -1380)},
    {Min = 100, Max = 119, Quest = "SnowQuest", Name = "Yeti", Level = 2, QuestPos = CFrame.new(1385, 87, -1298), MobPos = CFrame.new(1185, 105, -1520)},
    {Min = 120, Max = 149, Quest = "MarineQuest2", Name = "Chief Petty Officer", Level = 1, QuestPos = CFrame.new(-5036, 28, 4324), MobPos = CFrame.new(-4850, 20, 4260)},
    {Min = 150, Max = 174, Quest = "SkyQuest", Name = "Sky Bandit", Level = 1, QuestPos = CFrame.new(-4839, 717, -2619), MobPos = CFrame.new(-4975, 717, -2880)},
    {Min = 175, Max = 189, Quest = "SkyQuest", Name = "Dark Master", Level = 2, QuestPos = CFrame.new(-4839, 717, -2619), MobPos = CFrame.new(-5220, 388, -2260)},
    {Min = 190, Max = 209, Quest = "PrisonerQuest", Name = "Prisoner", Level = 1, QuestPos = CFrame.new(530, 1, 474), MobPos = CFrame.new(480, 1, 580)},
    {Min = 210, Max = 249, Quest = "PrisonerQuest", Name = "Dangerous Prisoner", Level = 2, QuestPos = CFrame.new(530, 1, 474), MobPos = CFrame.new(560, 1, 740)},
    {Min = 250, Max = 299, Quest = "ColosseumQuest", Name = "Toga Warrior", Level = 1, QuestPos = CFrame.new(-1588, 7, -2982), MobPos = CFrame.new(-1800, 7, -2850)},
    {Min = 300, Max = 374, Quest = "MagmaQuest", Name = "Military Soldier", Level = 1, QuestPos = CFrame.new(-5313, 12, 8515), MobPos = CFrame.new(-5400, 10, 8800)},
    {Min = 375, Max = 449, Quest = "FishmanQuest", Name = "Fishman Warrior", Level = 1, QuestPos = CFrame.new(61122, 18, 1569), MobPos = CFrame.new(60900, 18, 1500)},
    {Min = 450, Max = 524, Quest = "SkyQuest2", Name = "God's Guard", Level = 1, QuestPos = CFrame.new(-7861, 5545, -380), MobPos = CFrame.new(-7700, 5560, -450)},
    {Min = 525, Max = 624, Quest = "SkyQuest2", Name = "Shandian", Level = 2, QuestPos = CFrame.new(-7861, 5545, -380), MobPos = CFrame.new(-7800, 5600, -150)},
    {Min = 625, Max = 699, Quest = "FountainQuest", Name = "Fountain Pirate", Level = 1, QuestPos = CFrame.new(5259, 38, 4050), MobPos = CFrame.new(5500, 38, 4000)}
}

-- Lấy dữ liệu theo cấp độ hiện tại
local function GetCurrentLevelData()
    local myLevel = LocalPlayer.Data.Level.Value
    for _, data in ipairs(LevelData) do
        if myLevel >= data.Min and myLevel <= data.Max then
            return data
        end
    end
    return nil
end

-- Tự động lấy vũ khí ra tay
local function EquipWeapon()
    local char = LocalPlayer.Character
    if char and not char:FindFirstChildOfClass("Tool") then
        local backpack = LocalPlayer:FindFirstChild("Backpack")
        if backpack then
            for _, tool in pairs(backpack:GetChildren()) do
                if tool:IsA("Tool") and (tool.ToolTip == "Melee" or tool.ToolTip == "Blox Fruit" or tool.ToolTip == "Sword") then
                    char.Humanoid:EquipTool(tool)
                    break
                end
            end
        end
    end
end

-- Vòng lặp chính xử lý Auto Farm
task.spawn(function()
    while task.wait(0.1) do
        if getgenv().MasterAutoFarm then
            pcall(function()
                local char = LocalPlayer.Character
                if not char or not char:FindFirstChild("HumanoidRootPart") or char.Humanoid.Health <= 0 then return end
                
                local data = GetCurrentLevelData()
                local isQuestActive = LocalPlayer.PlayerGui.Main.Quest.Visible
                
                if data then
                    -- 1. Nếu chưa nhận Quest -> Bay đến NPC nhận Quest
                    if not isQuestActive then
                        char.HumanoidRootPart.CFrame = data.QuestPos
                        task.wait(0.5)
                        CommF:InvokeServer("StartQuest", data.Quest, data.Level)
                    else
                        -- 2. Đã nhận Quest -> Bay đến bãi quái và đánh
                        EquipWeapon()
                        local targetMob = nil
                        
                        for _, v in pairs(workspace.Enemies:GetChildren()) do
                            if (v.Name == data.Name or string.find(v.Name, data.Name)) and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChildOfClass("Humanoid").Health > 0 then
                                targetMob = v
                                break
                            end
                        end
                        
                        if targetMob then
                            -- Dịch chuyển lơ lửng trên đầu quái
                            char.HumanoidRootPart.CFrame = targetMob.HumanoidRootPart.CFrame + Vector3.new(0, getgenv().SafeHeight, 0)
                            
                            -- Kéo quái về chân và Đánh không delay
                            targetMob.HumanoidRootPart.CFrame = char.HumanoidRootPart.CFrame - Vector3.new(0, getgenv().SafeHeight, 0)
                            targetMob.HumanoidRootPart.CanCollide = false
                            
                            local tool = char:FindFirstChildOfClass("Tool")
                            if tool then tool:Activate() end
                        else
                            -- Nếu chưa có quái spawn -> Bay ra giữa bãi quái ngồi chờ
                            char.HumanoidRootPart.CFrame = data.MobPos + Vector3.new(0, 15, 0)
                        end
                    end
                end
            end)
        end
    end
end)

-- Tạo giao diện
if Window and Tabs.Main then
    local Toggle = Tabs.Main:AddToggle("MasterAutoFarmToggle", { Title = "🚀 BẬT AUTO FARM ALL-IN-ONE (FULL ĐẢO)", Default = getgenv().MasterAutoFarm })
    Toggle:OnChanged(function(Value)
        getgenv().MasterAutoFarm = Value
        if Value then
            Fluent:Notify({ Title = "Blox Fruits", Content = "Đã BẬT Auto Farm Full Cấp Độ!", Duration = 3 })
        else
            Fluent:Notify({ Title = "Blox Fruits", Content = "Đã TẮT!", Duration = 3 })
        end
    end)
    Window:SelectTab(1)
end
