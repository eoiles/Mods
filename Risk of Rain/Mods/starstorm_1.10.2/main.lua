-- Main
require("resources")
require("mainLibrary")
require("starstorm")

-- Enemies!
if not global.rormlflag.ss_no_enemies and not global.rormlflag.ss_disable_enemies then
	require("Actors.providence")
	require("Actors.suicider")
	require("Actors.gatekeeper")
	require("Actors.sandcrabking")
	require("Actors.monkey")
	require("Actors.ncommando")
	require("Actors.nenforcer")
	require("Actors.nbandit")
	require("Actors.nhuntress")
	require("Actors.nhand")
	require("Actors.nminer")
	require("Actors.nsniper")
	require("Actors.nexecutioner")
	require("Actors.squallelver")
	require("Actors.hive")
	require("Actors.goat")
	require("Actors.paul")
	require("Actors.eye")
	require("Actors.post")
	require("Actors.mimic")
	require("Actors.scrounger")
	require("Actors.dhack")
	require("Actors.dduplicator")
	require("Actors.dshock")
	require("Actors.totem")
	require("Actors.grub")
	
	require("Actors.arraign")
end

-- Elites!
require("Gameplay.elites")

-- Items!
require("Misc.itemRemoval")

if not global.rormlflag.ss_no_items and not global.rormlflag.ss_disable_items then
	require("Items.items")
end
if not global.rormlflag.ss_no_relics and not global.rormlflag.ss_disable_relics then
	require("Items.relic_items")
end

require("Misc.npcItemManager")

-- Survivors!
if not global.rormlflag.ss_no_survivors and not global.rormlflag.ss_disable_survivors then
	require("Survivors.Executioner.survivor")
	require("Survivors.MULE.survivor")
	require("Survivors.Cyborg.survivor")
	require("Survivors.Technician.survivor")
	require("Survivors.Nucleator.survivor")
	require("Survivors.Baroness.survivor")
	require("Survivors.Beastmaster.survivor")
	require("Survivors.Pyro.survivor")
	require("Survivors.DU-T.survivor")
	require("Survivors.Knight.survivor")
	require("Survivors.Seraph.survivor")
	-- February 2021 Poll Survivors
	require("Survivors.Scout.survivor")
	require("Survivors.Mortarman.survivor")
	require("Survivors.Duke.survivor")
	require("Survivors.Brawler.survivor")
	
	require("Survivors.Spectator.survivor")
	--require("Survivors.random") -- Doesn't quite work.
end

-- Stages!
require("Stages.stages")

-- Nemesis Manager!
require("Misc.nemesisManager")

-- Events!
require("Misc.eventManager")
require("Gameplay.events")

-- Interactables!
require("Misc.interactableManager")
require("Interactables.interactables")

-- Quests!
require("Misc.questManager")

-- Ethereal Teleporters (Difficulty +)
require("Gameplay.ethereals")

-- Artifacts!
if not global.rormlflag.ss_no_artifacts and not global.rormlflag.ss_disable_artifacts then
	require("Artifacts.artifacts")
end

-- Multiplayer Pinging!
require("Misc.multiplayerping")

-- Tab Menu!
require("Gameplay.tabmenu")

-- QOL changes!
require("Misc.qols")


-- Skins!
require("Misc.skinManager")
if not global.rormlflag.ss_no_submenu and not global.rormlflag.ss_disable_submenu then
	if not global.rormlflag.ss_no_skins and not global.rormlflag.ss_disable_skins then
		require("Gameplay.skins")
	end
end

-- Custom Rules!
require("Misc.settingsManager")

-- Achievements!
require("Misc.achievementManager")
if not global.rormlflag.ss_no_achievements and not global.rormlflag.ss_unlock_all then
	require("Misc.achievements")
end
