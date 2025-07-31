-- SPEED HUB X REBUILD | AUTO FARM + FAST ATTACK + GUI MOBILE COMPATÍVEL

_G.AutoFarm = false
_G.FarmMode = "Espada" -- ou "Fruta", "Combate"
local lp = game.Players.LocalPlayer
local rs = game:GetService("ReplicatedStorage")
local enemies = workspace.Enemies

-- GUI
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "SpeedFarmGUI"

-- BOTÃO ESCONDER GUI
local visible = true
local toggleBtn = Instance.new("TextButton", gui)
toggleBtn.Size = UDim2.new(0, 100, 0, 30)
toggleBtn.Position = UDim2.new(0, 10, 0, 10)
toggleBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
toggleBtn.TextColor3 = Color3.new(1, 1, 1)
toggleBtn.Text = "Esconder GUI"
toggleBtn.TextScaled = true

toggleBtn.MouseButton1Click:Connect(function()
    visible = not visible
    for _, v in pairs(gui:GetChildren()) do
        if v:IsA("TextButton") and v ~= toggleBtn then
            v.Visible = visible
        end
    end
    toggleBtn.Text = visible and "Esconder GUI" or "Mostrar GUI"
end)

-- BOTÃO AUTO FARM
local farmBtn = Instance.new("TextButton", gui)
farmBtn.Size = UDim2.new(0, 160, 0, 40)
farmBtn.Position = UDim2.new(0, 20, 0, 60)
farmBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
farmBtn.TextColor3 = Color3.new(1, 1, 1)
farmBtn.TextScaled = true
farmBtn.Text = "Ativar Auto Farm"

farmBtn.MouseButton1Click:Connect(function()
    _G.AutoFarm = not _G.AutoFarm
    farmBtn.Text = _G.AutoFarm and "Desativar Auto Farm" or "Ativar Auto Farm"
end)

-- BOTÃO DE MODO
local modos = {"Espada", "Fruta", "Combate"}
local index = 1
local modeBtn = Instance.new("TextButton", gui)
modeBtn.Size = UDim2.new(0, 160, 0, 40)
modeBtn.Position = UDim2.new(0, 20, 0, 110)
modeBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
modeBtn.TextColor3 = Color3.new(1, 1, 1)
modeBtn.TextScaled = true
modeBtn.Text = "Modo: Espada"

modeBtn.MouseButton1Click:Connect(function()
    index += 1
    if index > #modos then index = 1 end
    _G.FarmMode = modos[index]
    modeBtn.Text = "Modo: " .. _G.FarmMode
end)

-- FAST ATTACK
local function FastAttack(target)
    local tool = lp.Character and lp.Character:FindFirstChildOfClass("Tool")
    if not tool then return end
    local atk = getsenv(tool:FindFirstChild("Handle"):FindFirstChildWhichIsA("LocalScript", true))
    local rig = lp.Character
    local module = require(rs.CombatFramework.RigLib)
    if atk and module then
        local data = {
            Victim = target,
            VictimPos = target.HumanoidRootPart.Position,
            Attacker = rig,
            AttackVelocity = Vector3.new(),
            Start = tick()
        }
        atk.attack(data)
        module.registerattack(rig, tool)
        module.registerhit(rig, tool, {target})
    end
end

-- EQUIPAR ARMA
local function Equip()
    if _G.FarmMode == "Combate" then return end
    for _, tool in pairs(lp.Backpack:GetChildren()) do
        if tool:IsA("Tool") then
            local name = tool.Name:lower()
            if (_G.FarmMode == "Espada" and not name:find("fruit")) or
               (_G.FarmMode == "Fruta" and name:find("fruit")) then
                lp.Character.Humanoid:EquipTool(tool)
                break
            end
        end
    end
end

-- MISSÃO
local function GetQuest()
    local lvl = lp.Data.Level.Value
    if lvl <= 9 then return {"BanditQuest1", 1, "Bandit"}
    elseif lvl <= 14 then return {"JungleQuest", 1, "Monkey"}
    elseif lvl <= 29 then return {"JungleQuest", 2, "Gorilla"}
    elseif lvl <= 39 then return {"BuggyQuest1", 1, "Pirate"}
    elseif lvl <= 59 then return {"BuggyQuest1", 2, "Brute"}
    elseif lvl <= 74 then return {"BuggyQuest2", 1, "Chief Petty Officer"}
    elseif lvl <= 89 then return {"SkyQuest", 1, "Sky Bandit"}
    elseif lvl <= 119 then return {"SkyQuest", 2, "Dark Master"}
    elseif lvl <= 149 then return {"PrisonerQuest", 1, "Prisoner"}
    elseif lvl <= 174 then return {"PrisonerQuest", 2, "Dangerous Prisoner"}
    elseif lvl <= 199 then return {"ColosseumQuest", 1, "Toga Warrior"}
    elseif lvl <= 224 then return {"ColosseumQuest", 2, "Gladiator"}
    elseif lvl <= 274 then return {"MagmaQuest", 1, "Military Soldier"}
    elseif lvl <= 299 then return {"MagmaQuest", 2, "Military Spy"}
    elseif lvl <= 324 then return {"FishmanQuest", 1, "Fishman Warrior"}
    elseif lvl <= 374 then return {"FishmanQuest", 2, "Fishman Commando"}
    elseif lvl <= 399 then return {"SkyExp1Quest", 1, "God's Guard"}
    elseif lvl <= 449 then return {"SkyExp1Quest", 2, "Shanda"}
    elseif lvl <= 474 then return {"SkyExp2Quest", 1, "Royal Squad"}
    elseif lvl <= 524 then return {"SkyExp2Quest", 2, "Royal Soldier"}
    elseif lvl <= 549 then return {"FountainQuest", 1, "Galley Pirate"}
    else return {"FountainQuest", 2, "Galley Captain"} end
end

-- ACEITAR MISSÃO
local function AcceptQuest(qName, qPart)
    for _ = 1, 5 do
        rs.Remotes.CommF_:InvokeServer("StartQuest", qName, qPart)
        wait(1)
        if lp.PlayerGui.Main.Quest.Visible then break end
    end
end

-- LOOP AUTO FARM
spawn(function()
    while wait() do
        if _G.AutoFarm then
            pcall(function()
                local q = GetQuest()
                local qName, qPart, mob = unpack(q)
                if not lp.PlayerGui.Main.Quest.Visible then
                    AcceptQuest(qName, qPart)
                end
                Equip()
                for _, npc in pairs(enemies:GetChildren()) do
                    if npc.Name == mob and npc:FindFirstChild("HumanoidRootPart") and npc.Humanoid.Health > 0 then
                        local myHRP = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
                        local enHRP = npc:FindFirstChild("HumanoidRootPart")
                        if myHRP and enHRP then
                            myHRP.CFrame = enHRP.CFrame * CFrame.new(0, 0, 2)
                            if (myHRP.Position - enHRP.Position).Magnitude <= 30 then
                                FastAttack(npc)
                            end
                        end
                        repeat wait() until npc.Humanoid.Health <= 0 or not _G.AutoFarm
                    end
                end
            end)
        end
    end
end)