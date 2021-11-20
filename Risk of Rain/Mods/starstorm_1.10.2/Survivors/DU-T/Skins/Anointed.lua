-- ANOINTED

local path = "Survivors/DU-T/Skins/Anointed/"

local survivor = Survivor.find("DU-T", "Starstorm")
local sprSelect = Sprite.load("ADU-TSelect", path.."Select", 18, 2, 0)
local ADut = SurvivorVariant.new(survivor, "Anointed DU-T", sprSelect, {
	idle = Sprite.load("ADU-T_Idle", path.."idle", 1, 7, 11),
	walk = Sprite.load("ADU-T_Walk", path.."walk", 8, 15, 11),
	jump = Sprite.load("ADU-T_Jump", path.."jump", 1, 7, 14),
	climb = Sprite.load("ADU-T_Climb", path.."climb", 2, 4, 10),
	death = Sprite.load("ADU-T_Death", path.."death", 10, 10, 14),
	decoy = Sprite.load("ADU-T_Decoy", path.."decoy", 1, 9, 14),
	
	shoot1_1 = Sprite.load("ADU-T_Shoot1_1", path.."shoot1_1", 3, 7, 11),
	shoot1_2 = Sprite.load("ADU-T_Shoot1_2", path.."shoot1_2", 3, 7, 11),
	shoot3 = Sprite.load("ADU-T_Shoot3", path.."shoot3", 7, 25, 26),
}, Color.fromHex(0xB5F7FF))
SurvivorVariant.setInfoStats(ADut, {{"Strength", 5}, {"Vitality", 2}, {"Toughness", 4}, {"Agility", 4}, {"Difficulty", 6}, {"Potential", 10}})
SurvivorVariant.setDescription(ADut, "")