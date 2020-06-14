--[[
    GD50
    Final Fifty

    Author: Alejandro Mujica
    aledrums@gmail.com
]]


--
-- libraries
--

Class = require 'lib/class'
Event = require 'lib/knife.event'
push = require 'lib/push'
Timer = require 'lib/knife.timer'

require 'src/Util'
require 'src/Animation'
require 'src/constants'

--
-- world
--
require 'src/world/World'
require 'src/world/Region'
require 'src/world/TileMap'
require 'src/world/Tile'
require 'src/world/tile_ids'

--
-- entities
--
require 'src/entity/entity_defs'
require 'src/entity/Entity'
require 'src/entity/NPC'
require 'src/entity/Party'
require 'src/entity/BattleEntity'
require 'src/entity/Character'
require 'src/entity/Enemy'

--
-- state machine
--
require 'src/StateMachine'
require 'src/states/StateStack'
require 'src/states/BaseState'

--
-- entity states
--
require 'src/states/entity/EntityBaseState'
require 'src/states/entity/NPCIdleState'
require 'src/states/entity/CharacterIdleState'
require 'src/states/entity/CharacterWalkState'
require 'src/states/entity/PartyBaseState'
require 'src/states/entity/PartyIdleState'
require 'src/states/entity/PartyWalkState'
require 'src/states/entity/EnemyBattleState'

--
-- game states
--
require 'src/states/game/StartState'
require 'src/states/game/FadeInState'
require 'src/states/game/FadeOutState'
require 'src/states/game/ShowTextState'
require 'src/states/game/SelectCharacterState'
require 'src/states/game/GamePlayState'
require 'src/states/game/DialogueState'
require 'src/states/game/BattleState'
require 'src/states/game/BattleMessageState'
require 'src/states/game/BattleMenuState'
require 'src/states/game/StatsMenuState'
require 'src/states/game/TakeTurnState'
require 'src/states/game/SelectActionState'
require 'src/states/game/SelectTargetState'
require 'src/states/game/GameOverState'
require 'src/states/game/TheEndState'

--
-- gui
--
require 'src/gui/Textbox'
require 'src/gui/Panel'
require 'src/gui/Menu'
require 'src/gui/Selection'
require 'src/gui/ProgressBar'

gTextures = {
    ['tiles'] = love.graphics.newImage('graphics/sheet.png'),
    ['cursor-right'] = love.graphics.newImage('graphics/cursor_right.png'),
    ['cursor-up'] = love.graphics.newImage('graphics/cursor_up.png'),
    ['background'] = love.graphics.newImage('graphics/background.png'),
    ['healer-female'] = love.graphics.newImage('graphics/characters/healer_f.png'),
    ['healer-male'] = love.graphics.newImage('graphics/characters/healer_m.png'),
    ['mage-female'] = love.graphics.newImage('graphics/characters/mage_f.png'),
    ['mage-male'] = love.graphics.newImage('graphics/characters/mage_m.png'),
    ['warrior-female'] = love.graphics.newImage('graphics/characters/warrior_f.png'),
    ['warrior-male'] = love.graphics.newImage('graphics/characters/warrior_m.png'),
    ['ranger-female'] = love.graphics.newImage('graphics/characters/ranger_f.png'),
    ['ranger-male'] = love.graphics.newImage('graphics/characters/ranger_m.png'),
    ['npc-female'] = love.graphics.newImage('graphics/characters/townfolk_f.png'),
    ['npc-male'] = love.graphics.newImage('graphics/characters/townfolk_m.png'),
    ['slime'] = love.graphics.newImage('graphics/enemies/slime.png'),
    ['small-worm'] = love.graphics.newImage('graphics/enemies/small_worm.png'),
    ['snake'] = love.graphics.newImage('graphics/enemies/snake.png'),
    ['pumpking'] = love.graphics.newImage('graphics/enemies/pumpking.png'),
    ['man-eater-flower'] = love.graphics.newImage('graphics/enemies/man_eater_flower.png')
}

gFrames = {
    ['tiles'] = GenerateQuads(gTextures['tiles'], 16, 16),
    ['healer-female'] = GenerateQuads(gTextures['healer-female'], 16, 18),
    ['healer-male'] = GenerateQuads(gTextures['healer-male'], 16, 18),
    ['mage-female'] = GenerateQuads(gTextures['mage-female'], 16, 18),
    ['mage-male'] = GenerateQuads(gTextures['mage-male'], 16, 18),
    ['warrior-female'] = GenerateQuads(gTextures['warrior-female'], 16, 18),
    ['warrior-male'] = GenerateQuads(gTextures['warrior-male'], 16, 18),
    ['ranger-female'] = GenerateQuads(gTextures['ranger-female'], 16, 18),
    ['ranger-male'] = GenerateQuads(gTextures['ranger-male'], 16, 18),
    ['npc-female'] = GenerateQuads(gTextures['npc-female'], 16, 18),
    ['npc-male'] = GenerateQuads(gTextures['npc-male'], 16, 18),
    ['slime'] = GenerateQuads(gTextures['slime'], 16, 16),
    ['small-worm'] = GenerateQuads(gTextures['small-worm'], 16, 16),
    ['snake'] = GenerateQuads(gTextures['snake'], 16, 16),
    ['pumpking'] = GenerateQuads(gTextures['pumpking'], 23, 23),
    ['man-eater-flower'] = GenerateQuads(gTextures['man-eater-flower'], 30, 38)
}

gFonts = {
    ['small'] = love.graphics.newFont('fonts/font.ttf', 8),
    ['medium'] = love.graphics.newFont('fonts/font.ttf', 16),
    ['large'] = love.graphics.newFont('fonts/font.ttf', 32),
    ['ff'] = love.graphics.newFont('fonts/finalf.ttf', 48),
    ['ff-small'] = love.graphics.newFont('fonts/finalf.ttf', 24)
}

gSounds = {
    ['intro'] = love.audio.newSource('sounds/intro.mp3'),
    ['town'] = love.audio.newSource('sounds/town.mp3'),
    ['world'] = love.audio.newSource('sounds/world.mp3'),
    ['battle'] = love.audio.newSource('sounds/battle.mp3'),
    ['run'] = love.audio.newSource('sounds/run.wav'),
    ['blip'] = love.audio.newSource('sounds/blip.wav'),
    ['hit'] = love.audio.newSource('sounds/hit.wav'),
    ['powerup'] = love.audio.newSource('sounds/powerup.wav'),
    ['arrows'] = love.audio.newSource('sounds/arrows.wav'),
    ['flame'] = love.audio.newSource('sounds/flame.ogg'),
    ['game-over'] = love.audio.newSource('sounds/game_over.mp3'),
    ['victory'] = love.audio.newSource('sounds/victory.wav'),
    ['levelup'] = love.audio.newSource('sounds/levelup.wav'),
    ['exp'] = love.audio.newSource('sounds/exp.wav'),
    ['the-end'] = love.audio.newSource('sounds/the_end.mp3')
}
