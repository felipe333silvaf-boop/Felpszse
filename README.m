-- ✅ AUTO FARM COM FAST ATTACK (ESPADA/FRUTA/COMBATE) | FUNCIONAL COM RONIX

_G.AutoFarmLevel = false
_G.FarmMode = "Espada" -- ou "Fruta", "Combate"
local farmModes = {"Espada", "Fruta", "Combate"}
local currentMode = 1

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local lp = Players.LocalPlayer
local currentTool = nil

-- FAST ATTACK FUNCTIONS
local function AttackTarget(target)
    local tool = lp.Character and lp.Character:FindFirstChildOfClass("Tool")
    if not tool then return end

    local attackFunc = getsenv(tool:FindFirstChild("Handle"):FindFirstChildWhichIsA("LocalScript", true)).attack
    local module = require(ReplicatedStorage.CombatFramework.RigLib)

    if attackFunc and module then
        local rig = lp.Character
        local pos = target.HumanoidRootPart.Position
        local result = {
            Victim = target,
            VictimPos = pos,
            Attacker = rig,
            AttackVelocity = Vector3.new(),
            Start = tick()
        }

        attackFunc(result)
        module.registerattack(rig, tool)
        module.registerhit(rig, tool, {target})
    end
end

-- EQUIPAR A ARMA CERTA
local function EquipWeapon()
    if _G.FarmMode == "Combate" then
        currentTool = nil
        return
    end

    if lp.Character:FindFirstChildOfClass("Tool") then return end

    for _, tool in pairs(lp.Backpack:GetChildren()) do
        if tool:IsA("Tool") then
            local name = tool.Name:lower()
            if _G.FarmMode == "Espada" and not name:find("fruit") and not name:find("gun") then
                currentTool = tool
                lp.Character.Humanoid:EquipTool(tool)
                return
            elseif _G.FarmMode == "Fruta" and name:find("fruit") then
                currentTool = tool
                lp.Character.Humanoid:EquipTool(tool)
                return
            end
        end
    end
end

-- NPCS DE MISSÃO
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
        local hrp = lp.Character:WaitForChild("HumanoidRootPart")
        local humanoid = lp.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid:MoveTo(pos.Position)
            humanoid.MoveToFinished:Wait()
            wait(1.5)
        end
    end
end

-- ACEITAR MISSÃO
local function AcceptQuest(questName, questPart)
    for i = 1, 5 do
        local success = pcall(function()
            return ReplicatedStorage.Remotes.CommF_:InvokeServer("StartQuest", questName, questPart)
        end)
        if success and lp.PlayerGui.Main.Quest.Visible then break end
        wait(1)
    end
end

-- VERIFICA MISSÃO ATIVA
local function IsQuestActive()
    return lp.PlayerGui:FindFirstChild("Main") and lp.PlayerGui.Main.Quest.Visible
end

-- MISSÕES POR LEVEL
local function GetQuestData(level)
    if level <= 9 then return {QuestName = "BanditQuest1", QuestPart = 1, Mob = "Bandit"}
    elseif level <= 14 then return {QuestName = "JungleQuest", QuestPart = 1, Mob = "Monkey"}
    elseif level <= 29 then return {QuestName = "JungleQuest", QuestPart = 2, Mob = "Gorilla"}
    elseif level <= 39 then return {QuestName = "BuggyQuest1", QuestPart = 1, Mob = "Pirate"}
    elseif level <= 59 then return {QuestName = "BuggyQuest1", QuestPart = 2, Mob = "Brute"}
    elseif level <= 74 then return {QuestName = "BuggyQuest2", QuestPart = 1, Mob = "Chief Petty Officer"}
    elseif level <= 89 then return {QuestName = "SkyQuest", QuestPart = 1, Mob = "Sky Bandit"}
    elseif level <= 119 then return {QuestName = "SkyQuest", QuestPart = 2, Mob = "Dark Master"}
    elseif level <= 149 then return {QuestName = "PrisonerQuest", QuestPart = 1, Mob = "Prisoner"}
    elseif level <= 174 then return {QuestName = "PrisonerQuest", QuestPart = 2, Mob = "Dangerous Prisoner"}
    elseif level <= 199 then return {QuestName = "ColosseumQuest", QuestPart = 1, Mob = "Toga Warrior"}
    elseif level <= 224 then return {QuestName = "ColosseumQuest", QuestPart = 2, Mob = "Gladiator"}
    elseif level <= 274 then return {QuestName = "MagmaQuest", QuestPart = 1, Mob = "Military Soldier"}
    elseif level <= 299 then return {QuestName = "MagmaQuest", QuestPart = 2, Mob = "Military Spy"}
    elseif level <= 324 then return {QuestName = "FishmanQuest", QuestPart = 1, Mob = "Fishman Warrior"}
    elseif level <= 374 then return {QuestName = "FishmanQuest", QuestPart = 2, Mob = "Fishman Commando"}
    elseif level <= 399 then return {QuestName = "SkyExp1Quest", QuestPart = 1, Mob = "God's Guard"}
    elseif level <= 449 then return {QuestName = "SkyExp1Quest", QuestPart = 2, Mob = "Shanda"}
    elseif level <= 474 then return {QuestName = "SkyExp2Quest", QuestPart = 1, Mob = "Royal Squad"}
    elseif level <= 524 then return {QuestName = "SkyExp2Quest", QuestPart = 2, Mob = "Royal Soldier"}
    elseif level <= 549 then return {QuestName = "FountainQuest", QuestPart = 1, Mob = "Galley Pirate"}
    elseif level <= 700 then return {QuestName = "FountainQuest", QuestPart = 2, Mob = "Galley Captain"}
    end
end

-- LOOP FARM
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
                            local hrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
                            local ehrp = enemy:FindFirstChild("HumanoidRootPart")
                            if hrp and ehrp then
                                local dist = (hrp.Position - ehrp.Position).Magnitude
                                if dist > 5 then
                                    hrp.CFrame = ehrp.CFrame * CFrame.new(0, 0, 2)
                                end
                                if dist <= 30 then
                                    EquipWeapon()
                                    if _G.FarmMode == "Combate" or (currentTool and not currentTool.Parent:IsA("Model")) then
                                        if currentTool then
                                            lp.Character.Humanoid:EquipTool(currentTool)
                                        end
                                        AttackTarget(enemy)
                                    end
                                end
                            end
                            wait(0.2)
                        until enemy.Humanoid.Health <= 0 or not _G.AutoFarmLevel
                    end
                end
            end
        end)
        wait(1)
    end
end

-- GUI
local gui = Instance.new("ScreenGui", game.CoreGui)

-- Botão Auto Farm
local farmBtn = Instance.new("TextButton", gui)
farmBtn.Size = UDim2.new(0, 160, 0, 40)
farmBtn.Position = UDim2.new(0, 20, 0, 100)
farmBtn.BackgroundColor3 = Color3.fromRGB(30, 120, 255)
farmBtn.TextColor3 = Color3.new(1, 1, 1)
farmBtn.TextScaled = true
farmBtn.Text = "Ativar Auto Farm"

farmBtn.MouseButton1Click:Connect(function()
    _G.AutoFarmLevel = not _G.AutoFarmLevel
    farmBtn.Text = _G.AutoFarmLevel and "Desativar Auto Farm" or "Ativar Auto Farm"
    if _G.AutoFarmLevel then
        AutoFarm()
    end
end)

-- Botão Modo
local modeBtn = Instance.new("TextButton", gui)
modeBtn.Size = UDim2.new(0, 160, 0, 40)
modeBtn.Position = UDim2.new(0, 20, 0, 150)
modeBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
modeBtn.TextColor3 = Color3.new(1, 1, 1)
modeBtn.TextScaled = true
modeBtn.Text = "Modo: Espada"

modeBtn.MouseButton1Click:Connect(function()
    currentMode = currentMode + 1
    if currentMode > #farmModes then currentMode = 1 end
    _G.FarmMode = farmModes[currentMode]
    modeBtn.Text = "Modo: " .. _G.FarmMode
end)
