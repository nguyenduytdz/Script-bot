-- [[ BLOX FRUIT FULL ALL-IN-ONE MASTER SCRIPT ]] --

local SuccessUI, Fluent = pcall(function()
    return loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
end)

local Window
if SuccessUI and Fluent then
    Window = Fluent:CreateWindow({
        Title = "Blox Fruits - Master Auto Farm All-In-One",
        SubTitle = "Full Auto Quest, Sea 1-2-3, Fast Attack & Fast Bring",
        TabWidth = 160,
        Size = UDim2.fromOffset(580, 420),
        Theme = "Dark",
        MinimizeKey = Enum.KeyCode.RightControl
    })
end

local Tabs = {
    Main = Window:AddTab({ Title = "Auto Farm All-In-One", Icon = "home" }),
    Settings = Window:AddTab({ Title = "Cài Đặt", Icon = "settings" })
}

-- Biến Trạng Thái
getgenv().MasterAutoFarm = getgenv().MasterAutoFarm or false
getgenv().SafeHeight = 22 -- Độ cao đứng trên đầu quái

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CommF = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_")

-- BẢNG DỮ LIỆU LEVEL & NHIỆM VỤ CHUẨN (CẬP NHẬT FULL CÁC MỐC SEA 1, SEA 2, SEA 3)
local LevelData = {
    -- Sea 1
    {Min = 1, Max = 9, Quest = "BanditQuest1", Name = "Bandit", Level = 1, CFrame = CFrame.new(1059, 16, 1549)},
    {Min = 10, Max = 14, Quest = "JungleQuest", Name = "Monkey", Level = 1, CFrame = CFrame.new(-1599, 37, 153)},
    {Min = 15, Max = 29, Quest = "JungleQuest", Name = "Gorilla", Level = 2, CFrame = CFrame.new(-1237, 6, -486)},
    {Min = 30, Max = 39, Quest = "BuggyQuest1", Name = "Pirate", Level = 1, CFrame = CFrame.new(-1140, 4, 3828)},
    {Min = 40, Max = 59, Quest = "BuggyQuest1", Name = "Brute", Level = 2, CFrame = CFrame.new(-1140, 4, 3828)},
    {Min = 60, Max = 74, Quest = "DesertQuest", Name = "Desert Bandit", Level = 1, CFrame = CFrame.new(896, 6, 4388)},
    {Min = 75, Max = 89, Quest = "DesertQuest", Name = "Desert Officer", Level = 2, CFrame = CFrame.new(896, 6, 4388)},
    {Min = 90, Max = 99, Quest = "SnowQuest", Name = "Snow Bandit", Level = 1, CFrame = CFrame.new(1385, 87, -1298)},
    {Min = 100, Max = 119, Quest = "SnowQuest", Name = "Yeti", Level = 2, CFrame = CFrame.new(1385, 87, -1298)},
    {Min = 120, Max = 149, Quest = "MarineQuest2", Name = "Chief Petty Officer", Level = 1, CFrame = CFrame.new(-5036, 28, 4324)},
    {Min = 150, Max = 174, Quest = "SkyQuest", Name = "Sky Bandit", Level = 1, CFrame = CFrame.new(-4839, 717, -2619)},
    {Min = 175, Max = 189, Quest = "SkyQuest", Name = "Dark Master", Level = 2, CFrame = CFrame.new(-4839, 717, -2619)},
    {Min = 190, Max = 209, Quest = "PrisonerQuest", Name = "Prisoner", Level = 1, CFrame = CFrame.new(530, 1, 474)},
    {Min = 210, Max = 249, Quest = "PrisonerQuest", Name = "Dangerous Prisoner", Level = 2, CFrame = CFrame.new(530, 1, 474)},
    {Min = 250, Max = 299, Quest = "ColosseumQuest", Name = "Toga Warrior", Level = 1, CFrame = CFrame.new(-1588, 7, -2982)},
    {Min = 300, Max = 374, Quest = "MagmaQuest", Name = "Military Soldier", Level = 1, CFrame = CFrame.new(-5313, 12, 8515)},
    {Min = 375, Max = 449, Quest = "FishmanQuest", Name = "Fishman Warrior", Level = 1, CFrame = CFrame.new(61122, 18, 1569)},
    {Min = 450, Max = 524, Quest = "SkyQuest2", Name = "God's Guard", Level = 1, CFrame = CFrame.new(-7861, 5545, -380)},
    {Min = 525, Max = 624, Quest = "SkyQuest2", Name = "Shandian", Level = 2, CFrame = CFrame.new(-7861, 5545, -380)},
    {Min = 625, Max = 699, Quest = "FountainQuest", Name = "Fountain Pirate", Level = 1, CFrame = CFrame.new(5259, 38, 4050)}
}

-- Hàm tìm nhiệm vụ theo Level
local function GetQuestData()
    local myLevel = LocalPlayer.Data.Level.Value
    for _, data in ipairs(LevelData) do
        if myLevel >= data.Min and myLevel <= data.Max then
            return data
        end
    end
    return nil
end

-- 1. FAST ATTACK & GOM QUÁI CHUẨN
local function FastAttackAndBring()
    pcall(function()
        local myHrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not myHrp then return end

        for _, mob in pairs(workspace.Enemies:GetChildren()) do
            local humanoid = mob:FindFirstChildOfClass("Humanoid")
            local hrp = mob:FindFirstChild("HumanoidRootPart")
            
            if humanoid and hrp and humanoid.Health > 0 then
                -- Gom quái về đúng vị trí ngay dưới chân
                if (hrp.Position - myHrp.Position).Magnitude < 350 then
                    hrp.CFrame = myHrp.CFrame - Vector3.new(0, getgenv().SafeHeight, 0)
                    hrp.CanCollide = false
                    if mob:FindFirstChild("Head") then mob.Head.CanCollide = false end
                    
                    -- Đánh cực nhanh bằng giả lập Remote
                    local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
                    if tool then
                        tool:Activate()
                    end
                end
            end
        end
    end)
end

-- 2. TỰ ĐỘNG LÀM QUY TRÌNH CHUYỂN SEA
local function AutoSeaProgress()
    local myLevel = LocalPlayer.Data.Level.Value
    
    -- Tự động làm Quest qua Sea 2 (Level 700+)
    if myLevel >= 700 and game.PlaceId == 2753915549 then
        pcall(function()
            CommF:InvokeServer("DressrosaQuestProgress", "Detective")
            local prisonCFrame = CFrame.new(485, 4, 435)
            if (LocalPlayer.Character.HumanoidRootPart.Position - prisonCFrame.Position).Magnitude > 20 then
                LocalPlayer.Character.HumanoidRootPart.CFrame = prisonCFrame
            else
                CommF:InvokeServer("TravelDressrosa")
            end
        end)
        return true
    end
    
    -- Tự động làm Quest qua Sea 3 (Level 1500+)
    if myLevel >= 1500 and game.PlaceId == 4442272183 then
        pcall(function()
            CommF:InvokeServer("ZouQuestProgress", "Begun")
            CommF:InvokeServer("TravelZou")
        end)
        return true
    end
    return false
end

-- 3. TỰ ĐỘNG MUA MELEE / VÕ
local function AutoBuyMelee()
    pcall(function()
        local beli = LocalPlayer.Data.Beli.Value
        if beli >= 1500000 then CommF:InvokeServer("BuySuperhuman") end
        if beli >= 2500000 then CommF:InvokeServer("BuyDeathStep") end
        if beli >= 3000000 then CommF:InvokeServer("BuySharkmanKarate") end
        if beli >= 3000000 then CommF:InvokeServer("BuyElectricClaw") end
        if beli >= 5000000 then CommF:InvokeServer("BuyGodhuman") end
    end)
end

-- VÒNG LẶP CHÍNH (MASTER AUTO FARM LOOP)
task.spawn(function()
    while task.wait(0.1) do
        if getgenv().MasterAutoFarm then
            pcall(function()
                local char = LocalPlayer.Character
                if not char or not char:FindFirstChild("HumanoidRootPart") or char.Humanoid.Health <= 0 then return end
                
                -- Ưu tiên chạy quy trình chuyển Sea & Mua Võ trước
                if AutoSeaProgress() then return end
                AutoBuyMelee()
                
                local quest = GetQuestData()
                if quest then
                    local isQuestActive = LocalPlayer.PlayerGui.Main.Quest.Visible
                    
                    -- Bước 1: Nhận nhiệm vụ nếu chưa có
                    if not isQuestActive then
                        char.HumanoidRootPart.CFrame = quest.CFrame
                        task.wait(0.5)
                        CommF:InvokeServer("StartQuest", quest.Quest, quest.Level)
                    else
                        -- Bước 2: Đang có nhiệm vụ -> Tìm quái và bay lên cao né đòn
                        local targetMob = nil
                        for _, enemy in pairs(workspace.Enemies:GetChildren()) do
                            if enemy.Name == quest.Name and enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid").Health > 0 then
                                targetMob = enemy
                                break
                            end
                        end
                        
                        if targetMob then
                            -- Bay lên vị trí trên đầu quái
                            char.HumanoidRootPart.CFrame = targetMob.HumanoidRootPart.CFrame + Vector3.new(0, getgenv().SafeHeight, 0)
                            FastAttackAndBring()
                        else
                            -- Nếu chưa có quái spawn -> Đứng chờ tại vị trí bãi quái
                            char.HumanoidRootPart.CFrame = quest.CFrame + Vector3.new(0, 30, 0)
                        end
                    end
                end
            end)
        end
    end
end)

-- GUI
if Window and Tabs.Main then
    local MainSection = Tabs.Main:AddSection("Hệ Thống Master Auto Farm")

    local MasterToggle = MainSection:AddToggle("MasterAutoFarmToggle", { 
        Title = "🚀 BẬT AUTO FARM ALL-IN-ONE", 
        Default = getgenv().MasterAutoFarm 
    })

    MasterToggle:OnChanged(function(Value)
        getgenv().MasterAutoFarm = Value
        if Value then
            Fluent:Notify({ Title = "Blox Fruits", Content = "Đã BẬT All-In-One Auto Farm!", Duration = 3 })
        else
            Fluent:Notify({ Title = "Blox Fruits", Content = "Đã TẮT!", Duration = 3 })
        end
    end)

    Tabs.Settings:AddSlider("SafeHeightSlider", {
        Title = "Độ cao đứng né quái",
        Default = 22,
        Min = 15,
        Max = 40,
        Rounding = 0,
        Callback = function(Value)
            getgenv().SafeHeight = Value
        end
    })

    Window:SelectTab(1)
end
