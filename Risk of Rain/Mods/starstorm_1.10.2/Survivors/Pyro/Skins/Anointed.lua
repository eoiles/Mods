-- ANOINTED

local path = "Survivors/Pyro/Skins/Anointed/"

local survivor = Survivor.find("Pyro", "Starstorm")
local sprSelect = Sprite.load("APyroSelect", path.."Select", 14, 2, 0)
local ANucleator = SurvivorVariant.new(survivor, "Anointed Pyro", sprSelect, {
	idle = Sprite.load("APyroIdle", path.."idle", 5, 4, 6),
	walk = Sprite.load("APyroWalk", path.."walk", 8, 8, 6),
	walkShoot = Sprite.load("APyroWalkShoot", path.."walkShoot", 8, 8, 7),
	jump = Sprite.load("APyroJump", path.."jump", 5, 4, 6),
	climb = Sprite.load("APyroClimb", path.."climb", 2, 4, 7),
	death = Sprite.load("APyroDeath", path.."death", 9, 10, 14),
	decoy = Sprite.load("APyroDecoy", path.."decoy", 1, 9, 11),
	
	shoot1 = Sprite.load("APyroShoot1", path.."shoot1", 3, 7, 6),
	shoot3 = Sprite.load("APyroShoot3", path.."shoot3", 5, 11, 6),
	shoot4 = Sprite.load("APyroShoot4", path.."shoot4", 6, 10, 13),
	
	fire1 = Sprite.load("APyroFire1", path.."fire1", 6, 7, 10),
	fire2 = Sprite.load("APyroFire2", path.."fire2", 6, 7, 20),
	
	heatBar = Sprite.load("APyroBar", path.."heatBar", 2, 14, 10),
}, Color.fromHex(0xB5F7FF))
SurvivorVariant.setInfoStats(ANucleator, {{"Strength", 4}, {"Vitality", 4}, {"Toughness", 3}, {"Agility", 4}, {"Difficulty", 5}, {"Chill", 10}})
SurvivorVariant.setDescription(ANucleator, "")