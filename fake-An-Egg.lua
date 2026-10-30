-- // Axiom Fixed UI Script - Đảm bảo hiện menu 100% cho boss man
local success, err = pcall(function()
    local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/Fluent.lua"))()
    local SaveManager = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/SaveManager.lua"))()
    local InterfaceManager = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/InterfaceManager.lua"))()

    local Window = Fluent:CreateWindow({
        Title = "Axiom Hub - Fixed Edition",
        SubTitle = "boss man edition",
        TabWidth = 160,
        Size = UDim2.fromOffset(580, 460),
        Acrylic = true,
        Theme = "Dark",
        MinimizeKey = Enum.KeyCode.LeftControl
    })

    local Tabs = {
        Farm = Window:AddTab({ Title = "Farm", Icon = "🌾" }),
        Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
    }

    local Options = Fluent.Options
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local Workspace = game:GetService("Workspace")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local farmRunning = false

    local function tpTo(targetCF)
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = targetCF
        end
    end

    Tabs.Farm:AddParagraph({
        Title = "Hệ thống Farm Rebirth Tự Động",
        Content = "Bật công tắc bên dưới để script tự động quét yêu cầu Rebirth, lùng mua mục tiêu, đem về base mở và lặp lại vòng đời."
    })

    local ToggleFarm = Tabs.Farm:AddToggle("AutoFarmRebirthToggle", {
        Title = "Bật Auto Farm Rebirth Loop",
        Default = false
    })

    ToggleFarm:OnChanged(function(Value)
        farmRunning = Value
        
        task.spawn(function()
            while farmRunning do
                pcall(function()
                    local requiredTarget = nil
                    local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
                    if playerGui then
                        for _, gui in pairs(playerGui:GetDescendants()) do
                            if gui:IsA("TextLabel") and (gui.Text:lower():find("egg") or gui.Text:lower():find("hydra") or gui.Text:lower():find("wolf")) then
                                requiredTarget = gui.Text
                                break
                            end
                        end
                    end

                    local targetObj = nil
                    for _, obj in pairs(Workspace:GetDescendants()) do
                        if not farmRunning then break end
                        if obj:IsA("Model") and requiredTarget and obj.Name:lower():find(requiredTarget:lower()) then
                            if obj:PrimaryPart() or obj:FindFirstChildWhichIsA("BasePart") then
                                targetObj = obj
                                break
                            end
                        end
                    end

                    if targetObj then
                        local part = targetObj.PrimaryPart or targetObj:FindFirstChildWhichIsA("BasePart")
                        if part then
                            tpTo(part.CFrame + Vector3.new(0, 3, 0))
                            task.wait(0.4)
                            for _, prompt in pairs(targetObj:GetDescendants()) do
                                if prompt:IsA("ProximityPrompt") then
                                    fireproximityprompt(prompt)
                                end
                            end
                            task.wait(0.5)
                        end
                    end

                    local bases = Workspace:FindFirstChild("Bases")
                    if bases then
                        local myBase = bases:FindFirstChild(LocalPlayer.Name)
                        if myBase and myBase:FindFirstChild("PrimaryPart") then
                            tpTo(myBase.PrimaryPart.CFrame + Vector3.new(0, 5, 0))
                            task.wait(0.8)
                        end
                    end

                    for _, obj in pairs(Workspace:GetDescendants()) do
                        if obj:IsA("Model") and (obj.Name:lower():find("egg") or obj.Name:lower():find("pet")) then
                            local prompt = obj:FindFirstChildWhichIsA("ProximityPrompt", true)
                            if prompt then
                                fireproximityprompt(prompt)
                            end
                        end
                    end
                    task.wait(1)

                    local rebirthRemote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("Rebirth")
                    if rebirthRemote then
                        rebirthRemote:FireServer()
                    end
                end)
                task.wait(1.5)
            end
        end)
    end)

    SaveManager:SetLibrary(Fluent)
    InterfaceManager:SetLibrary(Fluent)
    SaveManager:IgnoreThemeSettings()
    SaveManager:SetIgnoreIndexes({})
    InterfaceManager:BuildInterfaceSection(Tabs.Settings)
    SaveManager:BuildConfigSection(Tabs.Settings)

    Window:SelectTab(1)

    Fluent:Notify({
        Title = "Axiom Hub Loaded!",
        Content = "Menu đã hiện lên thành công cho boss man!",
        Duration = 5
    })
end)

if not success then
    warn("Axiom Hub Error: " .. tostring(err))
end
