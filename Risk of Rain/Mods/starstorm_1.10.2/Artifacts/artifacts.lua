
-- All artifact data

local path = "Artifacts/Resources/"

require("Artifacts.prestige")

require("Artifacts.multitude")

require("Artifacts.adversity")

require("Artifacts.gathering")

require("Artifacts.cognation")

require("Artifacts.eminence")

require("Artifacts.havoc")

--require("Artifacts.starstorm")

if global.rormlflag.ss_unlock_all then
	ar.Prestige.unlocked = true
	ar.Multitude.unlocked = true
	ar.Adversity.unlocked = true
	ar.Gathering.unlocked = true
	ar.Cognation.unlocked = true
	ar.Eminence.unlocked = true
	ar.Havoc.unlocked = true
end