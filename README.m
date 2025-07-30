-- AUTO FARM LEVEL 1–700 COM MISSÃO FUNCIONAL E AUTO ATAQUE DE ESPADA

_G.AutoFarmLevel = false

local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local lp = Players.LocalPlayer

-- Equipa arma
local function EquipWeapon()
    for _, tool in pairs(lp.Backpack:GetChildren()) do
        if tool:IsA("Tool") then
            lp.Character.Humanoid:EquipTool(tool)
            break
        end
    end
end

-- Ir até o NPC da missão usando MoveTo
local function GoToQuestNpc(questName)
    local npcPositions = {
        BanditQuest1 = CFrame.new(1060, 16, 1547),
        JungleQuest = CFrame.new(-1602, 36, 151),
        BuggyQuest1 = CFrame.new(-1145, 5, 3827),
        BuggyQuest2 = CFrame.new(-1190, 5, 3930),
        SkyQuest = CFrame.new(-5000, 280, -2900),
        PrisonerQuest = CFrame.new(5200, 0, 600),
        ColosseumQuest = CFrame.new(-1576, 8, -2986),
        MagmaQuest = CFrame.new(-5315, 10, 8460),
        FishmanQuest = CFrame.new(61163, 11, 1569),
        SkyExp1Quest = CFrame.new(-4629, 877, -1934),
        SkyExp2Quest = CFrame.new(-7900, 5635, -2300),
        FountainQuest = CFrame.new(5250, 40, 4050)
    }

    local pos = npcPositions[questName]
    if pos then
        local char = lp.Character
        local hrp = char:WaitForChild("HumanoidRootPart")
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid:MoveTo(pos.Position)
            humanoid.MoveToFinished:Wait()
            wait(1.5)
        end
    end
end

-- Aceita missão com comando correto: StartQuest
local function AcceptQuest(questName, questPart)
    for i = 1, 5 do
        local success = pcall(function()
            return ReplicatedStorage.Remotes.CommF_:InvokeServer("StartQuest", questName, questPart)
        end)
        if success and lp.PlayerGui.Main.Quest.Visible then
            break
        end
        wait(1)
    end
end

-- Verifica se missão foi ativada
local function IsQuestActive()
    return lp.PlayerGui:FindFirstChild("Main") and lp.PlayerGui.Main.Quest.Visible
end

-- Dados da missão por level
local function GetQuestData(level)
    if level <= 9 then return {QuestName = "BanditQuest1", QuestPart = 1, Mob = "Bandit", MobPos = CFrame.new(1060, 16, 1547)}
    elseif level <= 14 then return {QuestName = "JungleQuest", QuestPart = 1, Mob = "Monkey", MobPos = CFrame.new(-1603, 36, 154)}
    elseif level <= 29 then return {QuestName = "JungleQuest", QuestPart = 2, Mob = "Gorilla", MobPos = CFrame.new(-1239, 6, -504)}
    elseif level <= 39 then return {QuestName = "BuggyQuest1", QuestPart = 1, Mob = "Pirate", MobPos = CFrame.new(-1145, 5, 3827)}
    elseif level <= 59 then return {QuestName = "BuggyQuest1", QuestPart = 2, Mob = "Brute", MobPos = CFrame.new(-1320, 6, 4290)}
    elseif level <= 74 then return {QuestName = "BuggyQuest2", QuestPart = 1, Mob = "Chief Petty Officer", MobPos = CFrame.new(-4855, 20, 4308)}
    elseif level <= 89 then return {QuestName = "SkyQuest", QuestPart = 1, Mob = "Sky Bandit", MobPos = CFrame.new(-4951, 278, -2878)}
    elseif level <= 119 then return {QuestName = "SkyQuest", QuestPart = 2, Mob = "Dark Master", MobPos = CFrame.new(-5250, 390, -2285)}
    elseif level <= 149 then return {QuestName = "PrisonerQuest", QuestPart = 1, Mob = "Prisoner", MobPos = CFrame.new(5300, 0, 474)}
    elseif level <= 174 then return {QuestName = "PrisonerQuest", QuestPart = 2, Mob = "Dangerous Prisoner", MobPos = CFrame.new(5360, 0, 900)}
    elseif level <= 199 then return {QuestName = "ColosseumQuest", QuestPart = 1, Mob = "Toga Warrior", MobPos = CFrame.new(-1576, 7, -2986)}
    elseif level <= 224 then return {QuestName = "ColosseumQuest", QuestPart = 2, Mob = "Gladiator", MobPos = CFrame.new(-1320, 7, -3250)}
    elseif level <= 274 then return {QuestName = "MagmaQuest", QuestPart = 1, Mob = "Military Soldier", MobPos = CFrame.new(-5400, 10, 8460)}
    elseif level <= 299 then return {QuestName = "MagmaQuest", QuestPart = 2, Mob = "Military Spy", MobPos = CFrame.new(-5800, 10, 8800)}
    elseif level <= 324 then return {QuestName = "FishmanQuest", QuestPart = 1, Mob = "Fishman Warrior", MobPos = CFrame.new(61000, 10, 1800)}
    elseif level <= 374 then return {QuestName = "FishmanQuest", QuestPart = 2, Mob = "Fishman Commando", MobPos = CFrame.new(61800, 10, 1950)}
    elseif level <= 399 then return {QuestName = "SkyExp1Quest", QuestPart = 1, Mob = "God's Guard", MobPos = CFrame.new(-4698, 845, -1912)}
    elseif level <= 449 then return {QuestName = "SkyExp1Quest", QuestPart = 2, Mob = "Shanda", MobPos = CFrame.new(-4800, 845, -1850)}
    elseif level <= 474 then return {QuestName = "SkyExp2Quest", QuestPart = 1, Mob = "Royal Squad", MobPos = CFrame.new(-7680, 5606, -2325)}
    elseif level <= 524 then return {QuestName = "SkyExp2Quest", QuestPart = 2, Mob = "Royal Soldier", MobPos = CFrame.new(-7850, 5606, -2500)}
    elseif level <= 549 then return {QuestName = "FountainQuest", QuestPart = 1, Mob = "Galley Pirate", MobPos = CFrame.new(5585, 45, 3950)}
    elseif level <= 700 then return {QuestName = "FountainQuest", QuestPart = 2, Mob = "Galley Captain", MobPos = CFrame.new(5730, 45, 4100)}
    end
end

-- AutoFarm principal
local function AutoFarm()
    while _G.AutoFarmLevel do
        pcall(function()
            local level = lp.Data.Level.Value
            local data = GetQuestData(level)
            if data then
                GoToQuestNpc(data.QuestName)
                AcceptQuest(data.QuestName, data.QuestPart)
                wait(1)
                if not IsQuestActive() then return end
                EquipWeapon()
                for _, enemy in pairs(workspace.Enemies:GetChildren()) do
                    if enemy.Name == data.Mob and enemy:FindFirstChild("HumanoidRootPart") and enemy.Humanoid.Health > 0 then
                        repeat
                            lp.Character.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame * CFrame.new(0, 0, 2)
                            EquipWeapon()
                            VirtualUser:Button1Down(Vector2.new(), workspace.CurrentCamera.CFrame)
                            wait(0.3)
                        until enemy.Humanoid.Health <= 0 or not _G.AutoFarmLevel
                    end
                end
            end
        end)
        wait(1)
    end
end

-- Interface: botão ativar/desativar
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
