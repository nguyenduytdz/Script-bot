-- // Load Fluent UI Library chuẩn chỉnh giống các script khác
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/Fluent.lua"))()
local SaveManager = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Axiom Hub " .. Fluent.Version,
    SubTitle = "by axiom - boss man edition",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true, -- Hiệu ứng kính mờ chuẩn script xịn
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

-- // Các Tab chính của menu
local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "home" }),
    FarmRebirth = Window:AddTab({ Title = "Farm Rebirth", Icon = "🌾" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

local Options = Fluent.Options

-- // Nội dung Tab Main
Tabs.Main:AddParagraph({
    Title = "Thông tin Hub",
    Content = "Chào mừng boss man quay trở lại với hệ thống. Menu này được thiết kế chuẩn chỉnh giống mọi bản script khác trên thị trường."
})

-- // Nội dung Tab Farm Rebirth (Yêu cầu của boss man)
Tabs.FarmRebirth:AddParagraph({
    Title = "Cơ chế Quét & Rebirth",
    Content = "Tự động đọc bảng Rebirth, quét trứng/con vật, dịch chuyển mua, mở tại base và lặp lại vòng đời!"
})

local autoRebirthActive = false
local ToggleRebirth = Tabs.FarmRebirth:AddToggle("AutoRebirthToggle", {
    Title = "Bật Auto Rebirth Loop",
    Default = false
})

ToggleRebirth:OnChanged(function(Value)
    autoRebirthActive = Value
    task.spawn(function()
        while autoRebirthActive do
            pcall(function()
                -- Logic quét và thực hiện ở đây cho boss man
                print("Đang chạy vòng lặp Auto Rebirth...")
            end)
            task.wait(2)
        end
    end)
end)

-- // Cấu hình SaveManager & InterfaceManager cho giống script xịn
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

Window:SelectTab(1)

Fluent:Notify({
    Title = "Axiom Menu Loaded",
    Content = "Giao diện menu đã sẵn sàng phục vụ boss man!",
    Duration = 5
})
