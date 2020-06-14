--[[
    GD50
    Final Fifty

    Author: Alejandro Mujica
    aledrums@gmail.com
]]

Character = Class{__includes = BattleEntity}

function Character:init(def)
    BattleEntity.init(self, def)

    self.HPIV = def.HPIV
    self.attackIV = def.attackIV
    self.defenseIV = def.defenseIV
    self.magicIV = def.magicIV
    self.currentExp = 0
    self.expToLevel = math.max(10, self.level * self.level * 5 * 0.75)
end

function Character:calculateStats()
    for i = 1, self.level do
        self:statsLevelUp()
    end
end

function Character:statsLevelUp()
    local HPIncrease = 0

    for j = 1, 3 do
        if math.random(6) <= self.HPIV then
            self.HP = self.HP + 1
            HPIncrease = HPIncrease + 1
        end
    end

    local attackIncrease = 0

    for j = 1, 3 do
        if math.random(6) <= self.attackIV then
            self.attack = self.attack + 1
            attackIncrease = attackIncrease + 1
        end
    end

    local defenseIncrease = 0

    for j = 1, 3 do
        if math.random(6) <= self.defenseIV then
            self.defense = self.defense + 1
            defenseIncrease = defenseIncrease + 1
        end
    end

    local magicIncrease = 0

    for j = 1, 3 do
        if math.random(6) <= self.magicIV then
            self.magic = self.magic + 1
            magicIncrease = magicIncrease + 1
        end
    end

    return HPIncrease, attackIncrease, defenseIncrease, magicIncrease
end

function Character:levelUp()
    self.level = self.level + 1
    self.expToLevel = self.level * self.level * 5 * 0.75

    return self:statsLevelUp()
end