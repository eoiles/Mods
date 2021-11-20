--RoomManager.Import "Mod.lua"

-- --锤子正常刷新
-- Import("LootData")
-- table.insert(
--     RewardStoreData.RunProgress,
--     {
--         Name = "WeaponUpgrade",
--         GameStateRequirements = {}
--     }
-- )

-- --锤子相互兼容
-- Import("LootData")
-- Import("TraitData")

-- for i, trait in ipairs(LootData.WeaponUpgrade.Traits) do
--     TraitData[trait].RequiredFalseTraits = {}
-- end

-- --双祝福正常刷新
-- Import("LootData")
-- table.insert(
--     RewardStoreData.RunProgress,
--     {
--         Name = "Devotion",
--         Overrides = {
--             RewardPreviewIcon = "RoomElitePreview",
--             RewardBoostedAnimation = "RoomRewardAvailableRareSparkles"
--         },
--         GameStateRequirements = {

--         }
--     }
-- )

-- --狙击手动装弹300伤害 1弹匣
-- Import("TraitData")
-- TraitData.GunManualReloadTrait.PropertyChanges[1].BaseValue = 300 / 3

-- table.insert(
--     TraitData.GunManualReloadTrait.PropertyChanges,
--     {
--         WeaponNames = {"GunWeapon"},
--         WeaponProperty = "MaxAmmo",
--         BaseValue = -11 / 3,
--         AsInt = true,
--         ChangeType = "Add",
--         ExcludeLinked = true,
--         ExtractValue = {
--             ExtractAs = "TooltipAmmo"
--             --Format = "PercentDelta",
--         }
--     }
-- )

-- --大狙自动手动装弹
-- Import("Combat")
-- OnWeaponTriggerRelease {
--     function()
--         if HeroHasTrait("GunManualReloadTrait") then
--             ManualReload(CurrentRun.Hero)
--         end
--     end
-- }

-- --禁止刷新资源房间
-- Import("LootData")
-- RewardStoreData.MetaProgress = RewardStoreData.RunProgress

-- 不可以启用 需要手动修改
-- -- --无限狙击弹 手动调整
-- -- Combat.OnWeaponFired
-- -- delete:
-- -- if triggerArgs.name == "SniperGunWeapon" then
-- --     SwapWeapon({ Name = triggerArgs.name, SwapWeaponName = "GunWeapon", StompOriginalWeapon = true, DestinationId = CurrentRun.Hero.ObjectId, RequireCurrentControl = true })
-- -- elseif triggerArgs.name == "SniperGunWeaponDash" then
-- --     SwapWeapon({ Name = triggerArgs.name, SwapWeaponName = "GunWeapon", StompOriginalWeapon = true, DestinationId = CurrentRun.Hero.ObjectId, RequireCurrentControl = true })
-- -- end

-- --地狱模式专属热度
-- Import("MetaUpgradeData")
-- MetaUpgradeData.NoInvulnerabilityShrineUpgrade.GameStateRequirements = {}

-- --钓鱼完美判定
-- Import("FishingData")

-- FishingData.NumFakeDunks.Max = 0
-- FishingData.PerfectInterval = 34

-- --重开后物品不会消失 无法带到下一层
-- Import("RoomManager")
-- function ClearUpgrades()
-- 	CurrentRun.Hero.RecentTraits = {}
-- 	CurrentRun.Hero.OnFireWeapons = {}
-- 	CurrentRun.Hero.OnSlamWeapons = {}
-- 	CurrentRun.Hero.OnDamageWeapons = {}
-- 	CurrentRun.Hero.OnKillWeapons = {}
-- 	CurrentRun.Hero.LastStands = {}
-- 	CurrentRun.Hero.WeaponDataOverride = nil

-- 	if CurrentRun.Hero.OutgoingDamageModifiers ~= nil then
-- 		for i, modifier in pairs( CurrentRun.Hero.OutgoingDamageModifiers ) do
-- 			if modifier.Name and MetaUpgradeData[modifier.Name] == nil then
-- 				CurrentRun.Hero.OutgoingDamageModifiers[i] = nil
-- 			end
-- 		end
-- 	end
-- 	UpdateNumHiddenTraits()
-- end

-- -- 无限召唤伙伴
-- Import("AssistScripts")
-- function CanFireAssist()
-- 	do return true end
-- end

-- --解锁全部成就
-- Import("AchievementData")
-- for key, achievement in pairs(GameData.AchievementData) do
--     GameData.AchievementData[key].CompleteGameStateRequirements = {}
-- end

-- --按键添加猎酒爱全攻击祝福
-- OnControlPressed {
--     "Assist",
--     function()

--         quality="Common"

--         AddTrait(CurrentRun.Hero, "DionysusWeaponTrait", quality)
--         AddTrait(CurrentRun.Hero, "AphroditeWeaponTrait", quality)
--         AddTrait(CurrentRun.Hero, "ArtemisWeaponTrait", quality)

--         AddTrait(CurrentRun.Hero, "DionysusSecondaryTrait", quality)
--         AddTrait(CurrentRun.Hero, "AphroditeSecondaryTrait", quality)
--         AddTrait(CurrentRun.Hero, "ArtemisSecondaryTrait", quality)

--         AddTrait(CurrentRun.Hero, "DionysusRangedTrait", quality)
--         AddTrait(CurrentRun.Hero, "AphroditeRangedTrait", quality)
--         AddTrait(CurrentRun.Hero, "ArtemisRangedTrait", quality)

--         AddTrait(CurrentRun.Hero, "DionysusRushTrait", quality)
--         AddTrait(CurrentRun.Hero, "AphroditeRushTrait", quality)
--         AddTrait(CurrentRun.Hero, "ArtemisRushTrait", quality)
--     end
-- }

-- --按键添加全祝福
-- OnControlPressed {
--     "Assist",
--     function()

--         quality="Common"

--         for traitname, traitdata in pairs(TraitData) do
--             if "IncreasedWrathStockTrait" ~= traitname then
--                 if  string.find(traitname,"WeaponTrait")  then
--                     AddTrait(CurrentRun.Hero, traitname, quality)
--                 end
--             end

--         end
--     end
-- }

-- --按键添加全普攻祝福
-- OnControlPressed {
--     "Assist",
--     function()
--         local quality = "Common"

--         AddTrait(CurrentRun.Hero, "DionysusWeaponTrait", quality)
--         AddTrait(CurrentRun.Hero, "AphroditeWeaponTrait", quality)
--         AddTrait(CurrentRun.Hero, "ArtemisWeaponTrait", quality)

--         AddTrait(CurrentRun.Hero, "ZeusWeaponTrait", quality)
--         AddTrait(CurrentRun.Hero, "AthenaWeaponTrait", quality)

--         AddTrait(CurrentRun.Hero, "PoseidonWeaponTrait", quality)
--         AddTrait(CurrentRun.Hero, "AresWeaponTrait", quality)
--         AddTrait(CurrentRun.Hero, "DemeterWeaponTrait", quality)
--     end
-- }

-- --按键添加全特殊攻击攻祝福
-- OnControlPressed {
--     "Assist",
--     function()
--         local quality = "Common"

--         AddTrait(CurrentRun.Hero, "DionysusSecondaryTrait", quality)
--         AddTrait(CurrentRun.Hero, "AphroditeSecondaryTrait", quality)
--         AddTrait(CurrentRun.Hero, "ArtemisSecondaryTrait", quality)

--         AddTrait(CurrentRun.Hero, "ZeusSecondaryTrait", quality)
--         AddTrait(CurrentRun.Hero, "AthenaSecondaryTrait", quality)

--         AddTrait(CurrentRun.Hero, "PoseidonSecondaryTrait", quality)
--         AddTrait(CurrentRun.Hero, "AresSecondaryTrait", quality)
--         AddTrait(CurrentRun.Hero, "DemeterSecondaryTrait", quality)
--     end
-- }

-- --钓上所有鱼
-- Import("FishingData")
-- OnControlPressed {
--     "Assist",
--     function ()

--         for fishname,fishdata in pairs(FishingData.BiomeFish) do

--             RecordFish(GetFish(fishname, "Good"))
--             RecordFish(GetFish(fishname, "Perfect"))

--         end
--     end

-- }
