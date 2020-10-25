if not killicon.GetFont then
	local OldAddFont = killicon.AddFont
	local OldAdd = killicon.Add

	local storedfonts = {}
	local storedicons = {}

	function killicon.AddFont(sClass, sFont, sLetter, cColor)
		cColor = cColor or color_white
		storedfonts[sClass] = {sFont, sLetter, cColor}
		return OldAddFont(sClass, sFont, sLetter, cColor)
	end

	function killicon.Add(sClass, sTexture, cColor)
		cColor = cColor or color_white
		storedicons[sClass] = {sTexture, cColor}
		return OldAdd(sClass, sTexture, cColor)
	end

	function killicon.AddAlias(sClass, sBaseClass)
		if storedfonts[sBaseClass] then
			return killicon.AddFont(sClass, storedfonts[sBaseClass][1], storedfonts[sBaseClass][2], storedfonts[sBaseClass][3])
		elseif storedicons[sBaseClass] then
			return killicon.Add(sClass, storedicons[sBaseClass][1], storedicons[sBaseClass][2])
		end
	end

	function killicon.Get(sClass)
		return killicon.GetFont(sClass) or killicon.GetIcon(sClass)
	end

	function killicon.GetFont(sClass)
		return storedfonts[sClass]
	end

	function killicon.GetIcon(sClass)
		return storedicons[sClass]
	end
end

killicon.AddFont("weapon_swcs_glock", "zsdeathnoticecsgo", utf8.char(59775))
killicon.AddFont("weapon_swcs_usp_silencer_off", "zsdeathnoticecsgo", utf8.char(59775))
killicon.AddFont("weapon_swcs_usp_silencer", "zsdeathnoticecsgo", utf8.char(59776))
killicon.AddFont("weapon_swcs_p250", "zsdeathnoticecsgo", utf8.char(59750))
killicon.AddFont("weapon_swcs_elite", "zsdeathnoticecsgo", utf8.char(59677))
killicon.AddFont("weapon_swcs_cz75", "zsdeathnoticecsgo", utf8.char(59669))
killicon.AddFont("weapon_swcs_revolver", "zsdeathnoticecsgo", utf8.char(59756))
killicon.AddFont("weapon_swcs_deagle", "zsdeathnoticecsgo", utf8.char(59670))

killicon.AddFont("weapon_swcs_mac10", "zsdeathnoticecsgo", utf8.char(59740))
killicon.AddFont("weapon_swcs_nova", "zsdeathnoticecsgo", utf8.char(59748))
killicon.AddFont("weapon_swcs_mag7", "zsdeathnoticecsgo", utf8.char(59741))
killicon.AddFont("weapon_swcs_mp5sd", "zsdeathnoticecsgo", utf8.char(59744))
killicon.AddFont("weapon_swcs_bizon", "zsdeathnoticecsgo", utf8.char(59658))
killicon.AddFont("weapon_swcs_ssg08", "zsdeathnoticecsgo", utf8.char(59764))

killicon.AddFont("weapon_swcs_xm1014", "zsdeathnoticecsgo", utf8.char(59777))
killicon.AddFont("weapon_swcs_famas", "zsdeathnoticecsgo", utf8.char(59678))
killicon.AddFont("weapon_swcs_p90", "zsdeathnoticecsgo", utf8.char(59749))
killicon.AddFont("weapon_swcs_ak47", "zsdeathnoticecsgo", utf8.char(59648))

killicon.AddFont("weapon_swcs_m4a1_silencer", "zsdeathnoticecsgo", utf8.char(59737))
killicon.AddFont("weapon_swcs_m4a1_silencer_off", "zsdeathnoticecsgo", utf8.char(59736))
killicon.AddFont("weapon_swcs_aug", "zsdeathnoticecsgo", utf8.char(59654))

killicon.AddFont("weapon_swcs_awp", "zsdeathnoticecsgo", utf8.char(59655))
killicon.AddFont("weapon_swcs_scar20", "zsdeathnoticecsgo", utf8.char(59758))
killicon.AddFont("weapon_swcs_m249", "zsdeathnoticecsgo", utf8.char(59739))

killicon.AddFont("default", "zsdeathnoticecs", "C")
killicon.AddFont("suicide", "zsdeathnoticecs", "C")
killicon.AddFont("player", "zsdeathnoticecs", "C")
killicon.AddFont("worldspawn", "zsdeathnoticecs", "C")
killicon.AddFont("func_move_linear", "zsdeathnoticecs", "C")
killicon.AddFont("func_rotating", "zsdeathnoticecs", "C")
killicon.AddFont("trigger_hurt", "zsdeathnoticecs", "C")

killicon.AddFont("prop_physics", "zsdeathnotice", "9")
killicon.AddFont("prop_physics_respawnable", "zsdeathnotice", "9")
killicon.AddFont("prop_physics_multiplayer", "zsdeathnotice", "9")
killicon.AddFont("func_physbox", "zsdeathnotice", "9")
killicon.AddFont("weapon_smg1", "zsdeathnotice", "/")
killicon.AddFont("weapon_357", "zsdeathnotice", ".")
killicon.AddFont("weapon_ar2", "zsdeathnotice", "2")
killicon.AddFont("crossbow_bolt", "zsdeathnotice", "1")
killicon.AddFont("weapon_shotgun", "zsdeathnotice", "0")
killicon.AddFont("rpg_missile", "zsdeathnotice", "3")
killicon.AddFont("npc_grenade_frag", "zsdeathnotice", "4")
killicon.AddFont("weapon_pistol", "zsdeathnotice", "-")
killicon.AddFont("prop_combine_ball", "zsdeathnotice", "8")
killicon.AddFont("grenade_ar2", "zsdeathnotice", "7")
killicon.AddFont("weapon_stunstick", "zsdeathnotice", "!")
killicon.AddFont("weapon_slam", "zsdeathnotice", "*")
killicon.AddFont("weapon_crowbar", "zsdeathnotice", "6")

killicon.Add("headshot", "zombiesurvival/killicons/zs_headshot")
killicon.Add("redeem", "killicon/redeem_v2")

killicon.Add("weapon_zs_zombie", "zombiesurvival/killicons/zombie")
killicon.Add("weapon_zs_zombie_gore_blaster", "zombiesurvival/killicons/zombie", Color(255, 0, 0))
killicon.Add("weapon_zs_skeleton", "zombiesurvival/killicons/skeletal_walker")
killicon.Add("weapon_zs_skeletallurker", "zombiesurvival/killicons/skeletal_lurker")
killicon.Add("weapon_zs_freshdead", "zombiesurvival/killicons/fresh_dead")
killicon.Add("weapon_zs_agiledead", "zombiesurvival/killicons/fresh_dead")
killicon.Add("weapon_zs_classiczombie", "zombiesurvival/killicons/fresh_dead")
killicon.Add("weapon_zs_superzombie", "zombiesurvival/killicons/fresh_dead")
killicon.Add("weapon_zs_zombietorso", "zombiesurvival/killicons/torso")
killicon.Add("weapon_zs_fastzombietorso", "zombiesurvival/killicons/fast_torso")
killicon.Add("weapon_zs_fastzombietorso_slingshot", "zombiesurvival/killicons/fast_torso", Color(163, 94, 99))
killicon.Add("weapon_zs_shadowlurker", "zombiesurvival/killicons/skeletal_lurker", Color(20, 20, 20))
killicon.Add("weapon_zs_shadowwalker", "zombiesurvival/killicons/skeletal_walker", Color(50, 50, 50))
killicon.Add("weapon_zs_zombielegs", "zombiesurvival/killicons/legs")
killicon.Add("weapon_zs_fastzombielegs", "zombiesurvival/killicons/fast_legs")
killicon.Add("weapon_zs_asskicker", "zombiesurvival/killicons/legs")
killicon.Add("weapon_zs_shitslapper", "zombiesurvival/killicons/torso")
killicon.Add("weapon_zs_nightmare", "zombiesurvival/killicons/nightmare2")
killicon.Add("weapon_zs_anightmare", "zombiesurvival/killicons/ancient_nightmare")
killicon.Add("weapon_zs_pukepus", "zombiesurvival/killicons/pukepus")
killicon.Add("weapon_zs_ticklemonster", "zombiesurvival/killicons/tickle")
killicon.Add("weapon_zs_crow", "zombiesurvival/killicons/crow")
killicon.Add("weapon_zs_fastzombie", "zombiesurvival/killicons/fastzombie")
killicon.Add("weapon_zs_fastzombie_slingshot", "zombiesurvival/killicons/fastzombie", Color(163, 94, 99))
killicon.Add("weapon_zs_poisonzombie", "zombiesurvival/killicons/poisonzombie")
killicon.Add("weapon_zs_wildpoisonzombie", "zombiesurvival/killicons/poisonzombie", Color(190, 240, 0))
killicon.Add("weapon_zs_chemzombie", "zombiesurvival/killicons/chemzombie")
killicon.Add("weapon_zs_ghoul", "zombiesurvival/killicons/ghoul")
killicon.Add("weapon_zs_chilledghoul", "zombiesurvival/killicons/ghoul", Color(20, 20, 250))
killicon.Add("weapon_zs_elderghoul", "zombiesurvival/killicons/ghoul", Color(170, 220, 0))
killicon.Add("dummy_chemzombie", "zombiesurvival/killicons/chemzombie")
killicon.Add("weapon_zs_wraith", "zombiesurvival/killicons/wraithv2")
killicon.Add("weapon_zs_headcrab", "zombiesurvival/killicons/headcrab")
killicon.Add("weapon_zs_doomcrab", "zombiesurvival/killicons/headcrab", Color(25, 25, 25))
killicon.Add("weapon_zs_fastheadcrab", "zombiesurvival/killicons/fastheadcrab")
killicon.Add("weapon_zs_bloodsucker_headcrab", "zombiesurvival/killicons/fastheadcrab", Color(175, 100, 100))
killicon.Add("weapon_zs_poisonheadcrab", "zombiesurvival/killicons/poisonheadcrab")
killicon.Add("weapon_zs_barbedheadcrab", "zombiesurvival/killicons/poisonheadcrab", Color(236, 218, 0))
killicon.Add("projectile_poisonspit", "zombiesurvival/killicons/projectile_poisonspit")
killicon.Add("projectile_poisonflesh", "zombiesurvival/killicons/projectile_poisonflesh")
killicon.Add("projectile_poisonpuke", "zombiesurvival/killicons/pukepus")
killicon.Add("weapon_zs_special_wow", "sprites/glow04_noz")
killicon.Add("weapon_zs_coolwisp", "sprites/glow04_noz", Color(0, 180, 255))
killicon.Add("projectile_wispball", "sprites/glow04_noz")
killicon.Add("weapon_zs_fleshcreeper", "zombiesurvival/killicons/fleshcreeper")
killicon.Add("weapon_zs_bloatedzombie", "zombiesurvival/killicons/bloatedzombie")
killicon.Add("weapon_zs_vilebloatedzombie", "zombiesurvival/killicons/bloatedzombie", Color(10, 94, 0))
killicon.Add("weapon_zs_gigagorechild", "zombiesurvival/killicons/gigagorechild")
killicon.Add("weapon_zs_gorechild", "zombiesurvival/killicons/gorechild")
killicon.Add("weapon_zs_gigashadowchild", "zombiesurvival/killicons/gigagorechild", Color(0, 0, 0))
killicon.Add("weapon_zs_shadowgorechild", "zombiesurvival/killicons/gorechild", Color(0, 0, 0))
killicon.Add("weapon_zs_shade", "zombiesurvival/killicons/shadev2", Color(0, 50, 255))
killicon.Add("weapon_zs_bonemesh", "zombiesurvival/killicons/bonemesh")
killicon.Add("projectile_bonemesh", "zombiesurvival/killicons/projectile_bonemesh")
killicon.Add("projectile_doomcrab", "zombiesurvival/killicons/projectile_bonemesh", Color(30, 30, 30))
killicon.Add("weapon_zs_redmarrow", "zombiesurvival/killicons/skeletal_walker", Color(255,0,0))
killicon.Add("weapon_zs_lacerator", "zombiesurvival/killicons/lacerator")
killicon.Add("weapon_zs_lacerator_charging", "zombiesurvival/killicons/lacerator", Color(180, 45, 0))
killicon.Add("weapon_zs_devourer", "zombiesurvival/killicons/devourer")
killicon.Add("projectile_devourer", "zombiesurvival/killicons/devourer")
killicon.Add("weapon_zs_frostshade", "zombiesurvival/killicons/shadev2", Color(0, 190, 255))
killicon.Add("projectile_shadeice", "zombiesurvival/killicons/projectile_shadeice")
killicon.Add("status_frostshadeshield", "zombiesurvival/killicons/shadev2", Color(0, 190, 255))
killicon.Add("weapon_zs_eradicator", "zombiesurvival/killicons/poisonzombie", Color(66, 0, 0))
killicon.Add("weapon_zs_howler", "zombiesurvival/killicons/howler")
killicon.Add("weapon_zs_extinctioncrab", "zombiesurvival/killicons/fastheadcrab", Color(100, 20, 0))
killicon.Add("projectile_extinctioncrab", "zombiesurvival/killicons/fastheadcrab", Color(100, 20, 0))
killicon.Add("weapon_zs_frigidrevenant", "zombiesurvival/killicons/skeletal_walker", Color(50, 90, 135))
killicon.Add("weapon_zs_skelesham", "zombiesurvival/killicons/skeletal_walker", Color(220, 200, 150))
killicon.Add("weapon_zs_tormentedwraith", "zombiesurvival/killicons/wraithv2", Color(190, 255, 190))
killicon.Add("weapon_zs_noxiousghoul", "zombiesurvival/killicons/ghoul", Color(230, 130, 190))

killicon.Add("prop_gunturret", "zombiesurvival/killicons/weapon_zs_gunturret2")
killicon.Add("prop_gunturret_assault", "zombiesurvival/killicons/weapon_zs_assaultturret.png")
killicon.Add("prop_gunturret_buckshot", "zombiesurvival/killicons/weapon_zs_gunturret_buckshot")
killicon.Add("prop_gunturret_rocket", "zombiesurvival/killicons/weapon_zs_gunturret_rocket")
killicon.AddFont("weapon_zs_gunturretcontrol", "zsdeathnotice", "*")
killicon.Add("weapon_zs_gunturret", "zombiesurvival/killicons/weapon_zs_gunturret2")
killicon.Add("weapon_zs_gunturret_assault", "zombiesurvival/killicons/weapon_zs_assaultturret.png")
killicon.Add("weapon_zs_gunturret_buckshot", "zombiesurvival/killicons/weapon_zs_gunturret_buckshot")
killicon.Add("weapon_zs_gunturret_rocket", "zombiesurvival/killicons/weapon_zs_gunturret_rocket")
killicon.AddFont("projectile_zsgrenade", "zsdeathnotice", "4")
killicon.Add("projectile_proxymine", "zombiesurvival/killicons/weapon_zs_proxymine")
killicon.AddFont("weapon_zs_grenade", "zsdeathnotice", "4")
killicon.AddFont("weapon_zs_zegrenade", "zsdeathnotice", "4")
killicon.Add("weapon_zs_proxymine", "zombiesurvival/killicons/weapon_zs_proxymine")
killicon.Add("weapon_zs_detpack", "zombiesurvival/killicons/weapon_zs_detpack2")
killicon.Add("prop_detpack", "zombiesurvival/killicons/weapon_zs_detpack2")
killicon.Add("weapon_zs_detpackremote", "zombiesurvival/killicons/weapon_zs_detpack2")
killicon.Add("projectile_disc", "zombiesurvival/killicons/weapon_zs_spinfusor")
killicon.AddFont("weapon_zs_barricadekit", "zsdeathnotice", "3")
killicon.AddFont("projectile_arrow", "zsdeathnotice", "1")
killicon.AddFont("weapon_zs_swissarmyknife", "zsdeathnoticecs", "j")
killicon.AddFont("weapon_zs_zeknife", "zsdeathnoticecs", "j")
killicon.Add("weapon_zs_aspirant", "zombiesurvival/killicons/weapon_zs_aspirant2")
killicon.AddFont("weapon_zs_flashbomb", "zsdeathnoticecs", "P")
killicon.AddFont("projectile_flashbomb", "zsdeathnoticecs", "P")
killicon.Add("weapon_zs_molotov", "zombiesurvival/killicons/weapon_zs_molotov2")
killicon.Add("projectile_zsmolotov", "zombiesurvival/killicons/weapon_zs_molotov2")
killicon.Add("env_molotovflame", "zombiesurvival/killicons/weapon_zs_molotov2")
killicon.Add("projectile_impactmine", "zombiesurvival/killicons/impact_mine")
killicon.Add("weapon_zs_corgasgrenade", "zombiesurvival/killicons/weapon_zs_corgasgrenade2")
killicon.Add("projectile_corgasgrenade", "zombiesurvival/killicons/weapon_zs_corgasgrenade2")
killicon.Add("weapon_zs_crygasgrenade", "zombiesurvival/killicons/weapon_zs_corgasgrenade2", Color(0, 220, 220))
killicon.Add("projectile_crygasgrenade", "zombiesurvival/killicons/weapon_zs_corgasgrenade2", Color(0, 220, 220))
killicon.Add("weapon_zs_bloodshotbomb", "zombiesurvival/killicons/weapon_zs_corgasgrenade2", Color(220, 0, 0))
killicon.Add("weapon_zs_cosmos", "zombiesurvival/killicons/weapon_zs_cosmos2")
killicon.Add("weapon_zs_shroud", "zombiesurvival/killicons/weapon_zs_shroud2")

killicon.Add("weapon_zs_axe", "zombiesurvival/killicons/weapon_zs_axe")
killicon.Add("weapon_zs_sawhack", "zombiesurvival/killicons/weapon_zs_sawhack.png")
killicon.Add("weapon_zs_keyboard", "zombiesurvival/killicons/weapon_zs_keyboard")
killicon.Add("weapon_zs_sledgehammer", "zombiesurvival/killicons/weapon_zs_sledgehammer")
killicon.Add("weapon_zs_megamasher", "zombiesurvival/killicons/weapon_zs_megamasher2")
killicon.Add("weapon_zs_fryingpan", "zombiesurvival/killicons/weapon_zs_fryingpan")
killicon.Add("weapon_zs_pot", "zombiesurvival/killicons/weapon_zs_pot")
killicon.Add("weapon_zs_plank", "zombiesurvival/killicons/weapon_zs_plank")
killicon.Add("weapon_zs_hammer", "zombiesurvival/killicons/weapon_zs_hammer2")
killicon.Add("weapon_zs_shovel", "zombiesurvival/killicons/weapon_zs_shovel")
killicon.Add("weapon_zs_hook", "zombiesurvival/killicons/weapon_zs_hook2")
killicon.Add("weapon_zs_meattenderizer", "zombiesurvival/killicons/weapon_zs_meattenderizer2")
killicon.Add("weapon_zs_lamp", "zombiesurvival/killicons/weapon_zs_lamp")
killicon.Add("weapon_zs_pipe", "zombiesurvival/killicons/weapon_zs_pipe")
killicon.Add("weapon_zs_wrench", "zombiesurvival/killicons/weapon_zs_wrench")
killicon.AddFont("weapon_zs_crowbar", "zsdeathnotice", "6")
killicon.AddFont("weapon_zs_stunbaton", "zsdeathnotice", "!")
killicon.Add("weapon_zs_bust", "zombiesurvival/killicons/weapon_zs_bust2")
killicon.Add("weapon_zs_butcherknife", "zombiesurvival/killicons/weapon_zs_butcherknife2")
killicon.Add("weapon_zs_butcherknifez", "zombiesurvival/killicons/butcher")
killicon.Add("weapon_zs_electrohammer", "zombiesurvival/killicons/weapon_zs_electrohammer")
killicon.Add("prop_meathook", "zombiesurvival/killicons/weapon_zs_hook2")
killicon.Add("weapon_zs_kongolaxe", "zombiesurvival/killicons/weapon_zs_kongolaxe2")
killicon.Add("weapon_zs_fists", "zombiesurvival/killicons/weapon_zs_fists")
killicon.Add("weapon_zs_harpoon", "zombiesurvival/killicons/weapon_zs_harpoon2")
killicon.Add("weapon_zs_harpoon_te", "zombiesurvival/killicons/weapon_zs_harpoon2")
killicon.Add("prop_harpoon", "zombiesurvival/killicons/weapon_zs_harpoon2")
killicon.Add("projectile_harpoon", "zombiesurvival/killicons/weapon_zs_harpoon2")
killicon.Add("projectile_harpoon_te", "zombiesurvival/killicons/weapon_zs_harpoon2")
killicon.Add("weapon_zs_frotchet", "zombiesurvival/killicons/weapon_zs_frotchet")
killicon.Add("env_protrusionspike", "zombiesurvival/killicons/env_protrusionspike")
killicon.Add("weapon_zs_longsword", "zombiesurvival/killicons/weapon_zs_longsword2")
killicon.Add("weapon_zs_rebarmace", "zombiesurvival/killicons/weapon_zs_rebarmace2")
killicon.Add("weapon_zs_executioner", "zombiesurvival/killicons/weapon_zs_executioner2")
killicon.Add("weapon_zs_brassknuckles", "zombiesurvival/killicons/weapon_zs_brassknuckles")
killicon.Add("weapon_zs_powerfists", "zombiesurvival/killicons/weapon_zs_powerfist.png")
killicon.Add("weapon_zs_ladel", "zombiesurvival/killicons/weapon_zs_ladel")
killicon.Add("weapon_zs_glassbottle", "zombiesurvival/killicons/glass_bottle")
killicon.Add("weapon_zs_crackedbottle", "zombiesurvival/killicons/glass_bottle")
killicon.Add("weapon_zs_graveshovel", "zombiesurvival/killicons/weapon_zs_graveshovel")
killicon.Add("weapon_zs_graveshovelz", "zombiesurvival/killicons/butcher", Color(100, 0, 220)) -- temp killicon
killicon.Add("weapon_zs_pushbroom", "zombiesurvival/killicons/weapon_zs_broom")
killicon.Add("weapon_zs_scythe", "zombiesurvival/killicons/weapon_zs_scythe2")

killicon.Add("weapon_zs_stone", "zombiesurvival/killicons/weapon_zs_stone")
killicon.Add("projectile_stone", "zombiesurvival/killicons/weapon_zs_stone")
killicon.Add("projectile_shaderock", "zombiesurvival/killicons/weapon_zs_stone")
killicon.Add("weapon_zs_medicalkit", "zombiesurvival/killicons/weapon_zs_medkit")
killicon.Add("weapon_zs_arsenalcrate", "zombiesurvival/killicons/weapon_zs_arsenalcrate")
killicon.Add("weapon_zs_remantler", "zombiesurvival/killicons/weapon_zs_remantler2.png")
killicon.Add("weapon_zs_tv", "zombiesurvival/killicons/weapon_zs_tv.png")
killicon.Add("weapon_zs_barricadekit", "zombiesurvival/killicons/weapon_zs_barricadekit")
killicon.Add("weapon_zs_boardpack", "zombiesurvival/killicons/weapon_zs_boardpack")
killicon.Add("weapon_zs_manhack", "zombiesurvival/killicons/weapon_zs_manhack")
killicon.Add("prop_manhack", "zombiesurvival/killicons/weapon_zs_manhack")
killicon.AddFont("weapon_zs_manhackcontrol", "zsdeathnotice", "*")
killicon.Add("weapon_zs_manhack_saw", "zombiesurvival/killicons/weapon_zs_manhack_saw")
killicon.Add("prop_manhack_saw", "zombiesurvival/killicons/weapon_zs_manhack_saw")
killicon.AddFont("weapon_zs_manhackcontrol_saw", "zsdeathnotice", "*")
killicon.Add("weapon_zs_messagebeacon", "zombiesurvival/killicons/weapon_zs_messagebeacon")
killicon.Add("prop_messagebeacon", "zombiesurvival/killicons/weapon_zs_messagebeacon")
killicon.Add("weapon_zs_oxygentank", "zombiesurvival/killicons/weapon_zs_oxygentank")
killicon.Add("weapon_zs_resupplybox", "zombiesurvival/killicons/weapon_zs_resupplybox")
killicon.Add("weapon_zs_spotlamp", "zombiesurvival/killicons/weapon_zs_spotlamp")
killicon.Add("prop_spotlamp", "zombiesurvival/killicons/weapon_zs_spotlamp")
killicon.Add("prop_drone", "zombiesurvival/killicons/weapon_zs_drone3.png")
killicon.Add("weapon_zs_drone", "zombiesurvival/killicons/weapon_zs_drone3.png")
killicon.Add("prop_drone_hauler", "zombiesurvival/killicons/weapon_zs_haulerdrone.png")
killicon.Add("weapon_zs_drone_hauler", "zombiesurvival/killicons/weapon_zs_haulerdrone.png")
killicon.Add("prop_drone_pulse", "zombiesurvival/killicons/weapon_zs_drone_pulse.png")
killicon.Add("weapon_zs_drone_pulse", "zombiesurvival/killicons/weapon_zs_drone_pulse.png")
killicon.Add("prop_rollermine", "zombiesurvival/killicons/weapon_zs_rollermine.png")
killicon.Add("weapon_zs_rollermine", "zombiesurvival/killicons/weapon_zs_rollermine.png")
killicon.AddFont("weapon_zs_dronecontrol", "zsdeathnotice", "*")
killicon.AddFont("weapon_zs_rollerminecontrol", "zsdeathnotice", "*")
killicon.Add("weapon_zs_mediccloudbomb", "zombiesurvival/killicons/weapon_zs_mediccloudbomb")
killicon.Add("weapon_zs_nanitecloudbomb", "zombiesurvival/killicons/weapon_zs_mediccloudbomb", Color(255, 50, 255))
killicon.Add("weapon_zs_repairfield", "zombiesurvival/killicons/weapon_zs_repairfield")
killicon.Add("weapon_zs_ffemitter", "zombiesurvival/killicons/weapon_zs_ffemitter")
killicon.Add("weapon_zs_zapper", "zombiesurvival/killicons/weapon_zs_zapper")
killicon.Add("prop_zapper", "zombiesurvival/killicons/weapon_zs_zapper")
killicon.Add("weapon_zs_zapper_arc", "zombiesurvival/killicons/weapon_zs_dynamo")
killicon.Add("prop_zapper_arc", "zombiesurvival/killicons/weapon_zs_dynamo")
killicon.Add("weapon_zs_f_banana", "zombiesurvival/killicons/food")
killicon.Add("weapon_zs_f_water", "zombiesurvival/killicons/food")
killicon.Add("weapon_zs_f_milk", "zombiesurvival/killicons/food")
killicon.Add("weapon_zs_f_orange", "zombiesurvival/killicons/food")
killicon.Add("weapon_zs_f_soda", "zombiesurvival/killicons/food")
killicon.Add("weapon_zs_f_watermelon", "zombiesurvival/killicons/food")
killicon.Add("weapon_zs_f_takeout", "zombiesurvival/killicons/food")
killicon.Add("weapon_zs_sigilfragment", "zombiesurvival/killicons/sigil_fragment")
killicon.Add("weapon_zs_corruptedfragment", "zombiesurvival/killicons/sigil_fragment", Color(50, 255, 50))
killicon.Add("weapon_zs_trinket", "zombiesurvival/killicons/weapon_zs_trinket")
killicon.Add("weapon_zs_craftables", "zombiesurvival/killicons/weapon_zs_craftables")
killicon.Add("weapon_zs_craftingpack", "zombiesurvival/killicons/weapon_zs_craftables")
killicon.Add("weapon_zs_camera", "zombiesurvival/killicons/weapon_zs_camera")

killicon.Add("status_bleed", "zombiesurvival/killicons/bleed", Color(255, 0, 0))
killicon.Add("status_poison", "zombiesurvival/killicons/projectile_poisonflesh")
killicon.Add("env_fire", "zombiesurvival/killicons/burn")
killicon.Add("entityflame", "zombiesurvival/killicons/burn")

killicon.Add("ammo_pistol", "zombiesurvival/killicons/pistol_ammo_icon", Color(255, 255, 200))
killicon.Add("ammo_shotgun", "zombiesurvival/killicons/shotgun_ammo_icon", Color(255, 140, 120))
killicon.Add("ammo_pulse", "zombiesurvival/killicons/pulse_ammo_icon", Color(150, 200, 255))
killicon.Add("ammo_rifle", "zombiesurvival/killicons/rifle_ammo_icon_2", Color(200, 200, 155))
killicon.Add("ammo_scrap", "zombiesurvival/killicons/scrap_ammo_icon", Color(150, 150, 150))
killicon.Add("ammo_smg", "zombiesurvival/killicons/smg_ammo_icon_2", Color(180, 180, 255))
killicon.Add("ammo_explosive", "zombiesurvival/killicons/explosive_ammo_icon_2", Color(250, 150, 50))
killicon.Add("ammo_chemical", "zombiesurvival/killicons/chemical_ammo_icon", Color(170, 250, 90))
killicon.Add("ammo_assault", "zombiesurvival/killicons/assault_rifle_ammo_icon", Color(200, 250, 200))
killicon.Add("ammo_bolts", "zombiesurvival/killicons/bolts_ammo_icon_2", Color(230, 230, 100))
killicon.Add("ammo_medpower", "zombiesurvival/killicons/medpower_ammo_icon")
killicon.Add("ammo_nail", "zombiesurvival/killicons/nail_ammo_icon_2")

net.Receive("zs_crow_kill_crow", function(length)
	local victim = net.ReadString()
	local attacker = net.ReadString()

	GAMEMODE:TopNotify(attacker, " ", {killicon = "weapon_zs_crow"}, " ", victim)
end)

net.Receive("zs_pl_kill_pl", function(length)
	local victim = net.ReadEntity()
	local attacker = net.ReadEntity()

	local inflictor = net.ReadString()

	local victimteam = net.ReadUInt(8)
	local attackerteam = net.ReadUInt(8)

	local headshot = net.ReadBit() == 1

	if victim:IsValid() and attacker:IsValid() then
		local attackername = attacker:Name()
		local victimname = victim:Name()

		if victim == MySelf then
			if victimteam == TEAM_HUMAN then
				gamemode.Call("LocalPlayerDied", attackername)
			end
		elseif attacker == MySelf then
			if attacker:Team() == TEAM_UNDEAD then
				gamemode.Call("FloatingScore", victim, "floatingscore_und", 1, 0)
			end
		end

		victim:CallZombieFunction5("OnKilled", attacker, attacker, attacker == victim, headshot, DamageInfo())

		MsgC(team.GetColor(attackerteam), attackername, color_white, " killed ", team.GetColor(victimteam), victimname, color_white, " with ", COLOR_YELLOW, inflictor, "\n")

		GAMEMODE:TopNotify(attacker, " ", {killicon = inflictor, headshot = headshot}, " ", victim)
	end
end)

net.Receive("zs_pls_kill_pl", function(length)
	local victim = net.ReadEntity()
	local attacker = net.ReadEntity()
	local assister = net.ReadEntity()

	local inflictor = net.ReadString()

	local victimteam = net.ReadUInt(8)
	local attackerteam = net.ReadUInt(8)

	local headshot = net.ReadBit() == 1

	if victim:IsValid() and attacker:IsValid() and assister:IsValid() then
		local victimname = victim:Name()
		local attackername = attacker:Name()
		local assistername = assister:Name()

		if victim == MySelf and victimteam == TEAM_HUMAN then
			gamemode.Call("LocalPlayerDied", attackername.." and "..assistername)
		end

		victim:CallZombieFunction5("OnKilled", attacker, attacker, attacker == victim, headshot, DamageInfo())

		MsgC(team.GetColor(attackerteam), attackername, " and ", team.GetColor(attackerteam), assistername, color_white, " killed ", team.GetColor(victimteam), victimname, color_white, " with ", COLOR_YELLOW, inflictor, "\n")

		GAMEMODE:TopNotify(attacker, " and ", assister, " ", {killicon = inflictor, headshot = headshot}, " ", victim)
	end
end)

net.Receive("zs_pl_kill_self", function(length)
	local victim = net.ReadEntity()
	local victimteam = net.ReadUInt(8)

	if victim:IsValid() then
		if victim == MySelf and victimteam == TEAM_HUMAN then
			gamemode.Call("LocalPlayerDied")
		end

		victim:CallZombieFunction5("OnKilled", victim, victim, true, false, DamageInfo())

		local victimname = victim:Name()

		MsgC(team.GetColor(victimteam), victimname, color_white, " killed themself", "\n")

		GAMEMODE:TopNotify({killicon = "suicide"}, " ", victim)
	end
end)

net.Receive("zs_playerredeemed", function(length)
	local pl = net.ReadEntity()

	if pl:IsValid() then
		GAMEMODE:TopNotify(translate.Format("x_redeemed", pl:Name()), " ", {killicon = "redeem"})

		if pl == MySelf then
			GAMEMODE:CenterNotify(COLOR_CYAN, translate.Get("you_redeemed"))

			util.WhiteOut(3)
		end
	end
end)

net.Receive("zs_death", function(length)
	local victim = net.ReadEntity()
	local inflictor = net.ReadString()
	local attacker = "#" .. net.ReadString()
	local victimteam = net.ReadUInt(8)

	if victim:IsValid() then
		if victim == MySelf and victimteam == TEAM_HUMAN then
			gamemode.Call("LocalPlayerDied")
		end

		victim:CallZombieFunction5("OnKilled", attacker, NULL, attacker == victim, false, DamageInfo())

		local victimname = victim:Name()

		MsgC(team.GetColor(victimteam), victimname, color_white, " was killed by ", COLOR_YELLOW, attacker, color_white, " with ", COLOR_YELLOW, inflictor, "\n")

		GAMEMODE:TopNotify(COLOR_RED, attacker, " ", {deathicon = inflictor}, " ", victim)
	end
end)
