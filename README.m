-- AUTO FARM LEVEL 1 A 700 - OPEN SOURCE

_G.AutoFarmLevel = false

local function EquipWeapon()
    for _, tool in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
        if tool:IsA("Tool") then
            game.Players.LocalPlayer.Character.Humanoid:EquipTool(tool)
            break
        end
    end
end

local function GetQuestData(level)
    if level <= 9 then
        return {
            QuestName = "BanditQuest1",
            QuestPart = 1,
            Mob = "Bandit",
            MobPos = CFrame.new(1060, 16, 1547)
        }
    elseif level <= 14 then
        return {
            QuestName = "JungleQuest",
            QuestPart = 1,
            Mob = "Monkey",
            MobPos = CFrame.new(-1603, 36, 154)
        }
    elseif level <= 29 then
        return {
            QuestName = "JungleQuest",
            QuestPart = 2,
            Mob = "Gorilla",
            MobPos = CFrame.new(-1239, 6, -504)
        }
    elseif level <= 39 then
        return {
            QuestName = "BuggyQuest1",
            QuestPart = 1,
            Mob = "Pirate",
            MobPos = CFrame.new(-1145, 5, 3827)
        }
    elseif level <= 59 then
        return {
            QuestName = "BuggyQuest1",
            QuestPart = 2,
            Mob = "Brute",
            MobPos = CFrame.new(-1320, 6, 4290)
        }
    elseif level <= 74 then
        return {
            QuestName = "BuggyQuest2",
            QuestPart = 1,
            Mob = "Chief Petty Officer",
            MobPos = CFrame.new(-4855, 20, 4308)
        }
    elseif level <= 89 then
        return {
            QuestName = "SkyQuest",
            QuestPart = 1,
            Mob = "Sky Bandit",
            MobPos = CFrame.new(-4951, 278, -2878)
        }
    elseif level <= 119 then
        return {
            QuestName = "SkyQuest",
            QuestPart = 2,
            Mob = "Dark Master",
            MobPos = CFrame.new(-5250, 390, -2285)
        }
    elseif level <= 149 then
        return {
            QuestName = "PrisonerQuest",
            QuestPart = 1,
            Mob = "Prisoner",
            MobPos = CFrame.new(5300, 0, 474)
        }
    elseif level <= 174 then
        return {
            QuestName = "PrisonerQuest",
            QuestPart = 2,
            Mob = "Dangerous Prisoner",
            MobPos = CFrame.new(5360, 0, 900)
        }
    elseif level <= 199 then
        return {
            QuestName = "ColosseumQuest",
            QuestPart = 1,
            Mob = "Toga Warrior",
            MobPos = CFrame.new(-1576, 7, -2986)
        }
    elseif level <= 224 then
        return {
            QuestName = "ColosseumQuest",
            QuestPart = 2,
            Mob = "Gladiator",
            MobPos = CFrame.new(-1320, 7, -3250)
        }
    elseif level <= 274 then
        return {
            QuestName = "MagmaQuest",
            QuestPart = 1,
            Mob = "Military Soldier",
            MobPos = CFrame.new(-5400, 10, 8460)
        }
    elseif level <= 299 then
        return {
            QuestName = "MagmaQuest",
            QuestPart = 2,
            Mob = "Military Spy",
            MobPos = CFrame.new(-5800, 10, 8800)
        }
    elseif level <= 324 then
        return {
            QuestName = "FishmanQuest",
            QuestPart = 1,
            Mob = "Fishman Warrior",
            MobPos = CFrame.new(61000, 10, 1800)
        }
    elseif level <= 374 then
        return {
            QuestName = "FishmanQuest",
            QuestPart = 2,
            Mob = "Fishman Commando",
            MobPos = CFrame.new(61800, 10, 1950)
        }
    elseif level <= 399 then
        return {
            QuestName = "SkyExp1Quest",
            QuestPart = 1,
            Mob = "God's Guard",
            MobPos = CFrame.new(-4698, 845, -1912)
        }
    elseif level <= 449 then
        return {
            QuestName = "SkyExp1Quest",
            QuestPart = 2,
            Mob = "Shanda",
            MobPos = CFrame.new(-4800, 845, -1850)
        }
    elseif level <= 474 then
        return {
            QuestName = "SkyExp2Quest",
            QuestPart = 1,
            Mob = "Royal Squad",
            MobPos = CFrame.new(-7680, 5606, -2325)
        }
    elseif level <= 524 then
        return {
            QuestName = "SkyExp2Quest",
            QuestPart = 2,
            Mob = "Royal Soldier",
            MobPos = CFrame.new(-7850, 5606, -2500)
        }
    elseif level <= 549 then
        return {
            QuestName = "FountainQuest",
            QuestPart = 1,
            Mob = "Galley Pirate",
            MobPos = CFrame.new(5585, 45, 3950)
        }
    elseif level <= 700 then
        return {
            QuestName = "FountainQuest",
            QuestPart = 2,
            Mob = "Galley Captain",
            MobPos = CFrame.new(5730, 45, 4100)
        }
    end
end

local function AutoFarm()
    while _G.AutoFarmLevel do
        pcall(function()
            local player = game.Players.LocalPlayer
            local level = player.Data.Level.Value
            local data = GetQuestData(level)

            if data then
                -- Coleta missão
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Quest", data.QuestName, data.QuestPart)
                wait(0.5)
                EquipWeapon()

                -- Atacar inimigos
                for _, enemy in pairs(workspace.Enemies:GetChildren()) do
                    if enemy.Name == data.Mob and enemy:FindFirstChild("HumanoidRootPart") and enemy.Humanoid.Health > 0 then
                        repeat
                            pcall(function()
                                player.Character.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame * CFrame.new(0, 0, 2)
                                enemy.Humanoid.Health = enemy.Humanoid.Health - 10
                            end)
                            wait()
                        until enemy.Humanoid.Health <= 0 or not _G.AutoFarmLevel
                    end
                end
            end
        end)
        wait(1)
    end
end

-- Interface simples de ativação
local gui = Instance.new("ScreenGui", game.CoreGui)
local button = Instance.new("TextButton", gui)

button.Size = UDim2.new(0, 160, 0, 40)
button.Position = UDim2.new(0, 20, 0, 100)
button.BackgroundColor3 = Color3.fromRGB(30, 120, 255)
button.Text = "Ativar Auto Farm"
button.TextColor3 = Color3.new(1, 1, 1)
button.TextScaled = true

button.MouseButton1Click:Connect(function()
    _G.AutoFarmLevel = not _G.AutoFarmLevel
    button.Text = _G.AutoFarmLevel and "Desativar Auto Farm" or "Ativar Auto Farm"
    if _G.AutoFarmLevel then
        AutoFarm()
    end
end)
