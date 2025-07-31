-- SPEED HUB X | AUTO FARM OPEN SOURCE RECONSTRUÍDO
_G.AutoFarm = true
_G.FarmMode = "Espada" -- ou "Fruta", "Combate"

local lp = game.Players.LocalPlayer
local rs = game:GetService("ReplicatedStorage")
local enemies = workspace.Enemies

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

-- DADOS DE MISSÃO
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

-- LOOP DE AUTO FARM
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
                        local hrp = lp.Character:FindFirstChild("HumanoidRootPart")
                        local ehrp = npc:FindFirstChild("HumanoidRootPart")
                        if hrp and ehrp then
                            hrp.CFrame = ehrp.CFrame * CFrame.new(0, 0, 2)
                            if (hrp.Position - ehrp.Position).Magnitude <= 30 then
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

print("🟢 Auto Farm do Speed Hub X reconstruído. Ative/desative com: _G.AutoFarm = true / false")