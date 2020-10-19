AddCSLuaFile()

-- register weps
do
    local strPrefab = [==[ "table" {
        "80"
        {
            "name"		"weapon_knife_ghost"
            "prefab"		"melee"
            "item_name"		"#SFUI_WPNHUD_Knife_Ghost"
            "item_description"		"#CSGO_Item_desc_Knife_Ghost"
            "item_quality"		"normal"
            "baseitem"		"0"
            "default_slot_item"		"1"
            "item_gear_slot"		"melee"
            "item_gear_slot_position"		"0"
            "item_sub_position"		"none"
            "model_player"		"models/weapons/v_knife_ghost.mdl"
            "model_world"		"models/weapons/w_knife_ghost.mdl"
            "used_by_classes"
            {
                "terrorists"		"1"
                "counter-terrorists"		"1"
            }
        }"500"
        {
            "name"		"weapon_bayonet"
            "prefab"		"melee_unusual"
            "item_name"		"#SFUI_WPNHUD_KnifeBayonet"
            "item_description"		"#CSGO_Item_Desc_Knife_Bayonet"
            "image_inventory"		"econ/weapons/base_weapons/weapon_bayonet"
            "icon_default_image"		"materials/icons/inventory_icon_weapon_bayonet.vtf"
            "model_player"		"models/weapons/v_knife_bayonet.mdl"
            "model_world"		"models/weapons/w_knife_bayonet.mdl"
            "used_by_classes"
            {
                "terrorists"		"1"
                "counter-terrorists"		"1"
            }
            "attributes"
            {
                "pedestal display model"		"models/weapons/v_knife_bayonet_inspect.mdl"
            }
            "paint_data"
            {
                "PaintableMaterial0"
                {
                    "Name"		"knife_bayonet"
                    "ViewmodelDim"		"2048"
                    "WorldDim"		"512"
                    "BaseTextureOverride"		"0"
                    "WeaponLength"		"14.518000"
                    "UVScale"		"0.505000"
                }
            }
        }
        "503"
        {
            "name"		"weapon_knife_css"
            "prefab"		"melee_unusual"
            "item_name"		"#SFUI_WPNHUD_KnifeCSS"
            "item_description"		"#CSGO_Item_Desc_Knife_CSS"
            "image_inventory"		"econ/weapons/base_weapons/weapon_knife_css"
            "icon_default_image"		"materials/icons/inventory_icon_weapon_knife_css.vtf"
            "model_player"		"models/weapons/v_knife_css.mdl"
            "model_world"		"models/weapons/w_knife_css.mdl"
            "used_by_classes"
            {
                "terrorists"		"1"
                "counter-terrorists"		"1"
            }
            "attributes"
            {
                "pedestal display model"		"models/weapons/v_knife_css_inspect.mdl"
            }
            "inventory_image_data"
            {
                "spot_light_key"
                {
                    "position"		"-45 50 35"
                    "color"		"0.55 0.55 0.56"
                    "lookat"		"0.0 0.0 0.0"
                    "inner_cone"		"0.500000"
                    "outer_cone"		"1.000000"
                }
                "camera_angles"		"30.0 -95.0 29.0"
                "camera_offset"		"7.0 1.5 -1.5"
            }
            "paint_data"
            {
                "PaintableMaterial0"
                {
                    "Name"		"knife_css"
                    "ViewmodelDim"		"2048"
                    "WorldDim"		"512"
                    "BaseTextureOverride"		"0"
                    "WeaponLength"		"12.570000"
                    "UVScale"		"0.360000"
                }
            }
        }
        "505"
        {
            "name"		"weapon_knife_flip"
            "prefab"		"melee_unusual"
            "item_name"		"#SFUI_WPNHUD_KnifeFlip"
            "item_description"		"#CSGO_Item_Desc_Knife_Flip"
            "image_inventory"		"econ/weapons/base_weapons/weapon_knife_flip"
            "icon_default_image"		"materials/icons/inventory_icon_weapon_knife_flip.vtf"
            "model_player"		"models/weapons/v_knife_flip.mdl"
            "model_world"		"models/weapons/w_knife_flip.mdl"
            "used_by_classes"
            {
                "terrorists"		"1"
                "counter-terrorists"		"1"
            }
            "attributes"
            {
                "pedestal display model"		"models/weapons/v_knife_flip_inspect.mdl"
            }
            "inventory_image_data"
            {
                "camera_angles"		"30.0 -95.0 29.0"
                "camera_offset"		"9.0 1.0 -1.5"
            }
            "paint_data"
            {
                "PaintableMaterial0"
                {
                    "Name"		"knife_flip"
                    "ViewmodelDim"		"2048"
                    "WorldDim"		"512"
                    "BaseTextureOverride"		"0"
                    "WeaponLength"		"12.900000"
                    "UVScale"		"0.411000"
                }
            }
        }
        "506"
        {
            "name"		"weapon_knife_gut"
            "prefab"		"melee_unusual"
            "item_name"		"#SFUI_WPNHUD_KnifeGut"
            "item_description"		"#CSGO_Item_Desc_Knife_Gut"
            "image_inventory"		"econ/weapons/base_weapons/weapon_knife_gut"
            "icon_default_image"		"materials/icons/inventory_icon_weapon_knife_gut.vtf"
            "model_player"		"models/weapons/v_knife_gut.mdl"
            "model_world"		"models/weapons/w_knife_gut.mdl"
            "used_by_classes"
            {
                "terrorists"		"1"
                "counter-terrorists"		"1"
            }
            "attributes"
            {
                "pedestal display model"		"models/weapons/v_knife_gut_inspect.mdl"
            }
            "inventory_image_data"
            {
                "camera_angles"		"30.0 -95.0 23.0"
                "camera_offset"		"10.0 1.2 -2"
            }
            "paint_data"
            {
                "PaintableMaterial0"
                {
                    "Name"		"knife_gut"
                    "OrigMat"		"knife_gut"
                    "ViewmodelDim"		"2048"
                    "WorldDim"		"512"
                    "BaseTextureOverride"		"0"
                    "WeaponLength"		"14.610000"
                    "UVScale"		"0.733000"
                }
            }
        }
        "507"
        {
            "name"		"weapon_knife_karambit"
            "prefab"		"melee_unusual"
            "item_name"		"#SFUI_WPNHUD_KnifeKaram"
            "item_description"		"#CSGO_Item_Desc_Knife_Karam"
            "image_inventory"		"econ/weapons/base_weapons/weapon_knife_karambit"
            "icon_default_image"		"materials/icons/inventory_icon_weapon_knife_karambit.vtf"
            "model_player"		"models/weapons/v_knife_karam.mdl"
            "model_world"		"models/weapons/w_knife_karam.mdl"
            "used_by_classes"
            {
                "terrorists"		"1"
                "counter-terrorists"		"1"
            }
            "attributes"
            {
                "pedestal display model"		"models/weapons/v_knife_karam_inspect.mdl"
            }
            "inventory_image_data"
            {
                "camera_angles"		"30.0 -95.0 -5.0"
                "camera_offset"		"10.0 1.5 -3.2"
            }
            "paint_data"
            {
                "PaintableMaterial0"
                {
                    "Name"		"knife_karam"
                    "OrigMat"		"karam"
                    "ViewmodelDim"		"2048"
                    "WorldDim"		"512"
                    "BaseTextureOverride"		"0"
                    "WeaponLength"		"9.813000"
                    "UVScale"		"0.438000"
                }
            }
        }
        "508"
        {
            "name"		"weapon_knife_m9_bayonet"
            "prefab"		"melee_unusual"
            "item_name"		"#SFUI_WPNHUD_KnifeM9"
            "item_description"		"#CSGO_Item_Desc_KnifeM9"
            "image_inventory"		"econ/weapons/base_weapons/weapon_knife_m9_bayonet"
            "icon_default_image"		"materials/icons/inventory_icon_weapon_knife_m9_bayonet.vtf"
            "model_player"		"models/weapons/v_knife_m9_bay.mdl"
            "model_world"		"models/weapons/w_knife_m9_bay.mdl"
            "used_by_classes"
            {
                "terrorists"		"1"
                "counter-terrorists"		"1"
            }
            "attributes"
            {
                "pedestal display model"		"models/weapons/v_knife_m9_bay_inspect.mdl"
            }
            "inventory_image_data"
            {
                "camera_angles"		"30.0 -95.0 29.0"
                "camera_offset"		"7.0 1.5 -1.5"
            }
            "paint_data"
            {
                "PaintableMaterial0"
                {
                    "Name"		"knife_m9_bay"
                    "ViewmodelDim"		"2048"
                    "WorldDim"		"512"
                    "BaseTextureOverride"		"0"
                    "WeaponLength"		"15.300000"
                    "UVScale"		"0.506000"
                }
            }
        }
        "509"
        {
            "name"		"weapon_knife_tactical"
            "prefab"		"melee_unusual"
            "item_name"		"#SFUI_WPNHUD_KnifeTactical"
            "item_description"		"#CSGO_Item_Desc_KnifeTactical"
            "image_inventory"		"econ/weapons/base_weapons/weapon_knife_tactical"
            "icon_default_image"		"materials/icons/inventory_icon_weapon_knife_tactical.vtf"
            "model_player"		"models/weapons/v_knife_tactical.mdl"
            "model_world"		"models/weapons/w_knife_tactical.mdl"
            "used_by_classes"
            {
                "terrorists"		"1"
                "counter-terrorists"		"1"
            }
            "attributes"
            {
                "pedestal display model"		"models/weapons/v_knife_tactical_inspect.mdl"
            }
            "inventory_image_data"
            {
                "camera_angles"		"30.0 -95.0 29.0"
                "camera_offset"		"7.0 1.5 -1.5"
            }
            "paint_data"
            {
                "PaintableMaterial0"
                {
                    "Name"		"knife_tactical"
                    "ViewmodelDim"		"2048"
                    "WorldDim"		"512"
                    "BaseTextureOverride"		"0"
                    "WeaponLength"		"15.300000"
                    "UVScale"		"0.506000"
                }
            }
            "tags"
            {
                "ItemSet"
                {
                    "tag_value"		"set_community_3"
                    "tag_text"		"#CSGO_set_community_3"
                    "tag_group"		"ItemSet"
                    "tag_group_text"		"#SFUI_InvTooltip_SetTag"
                }
            }
        }
        "512"
        {
            "name"		"weapon_knife_falchion"
            "prefab"		"melee_unusual"
            "item_name"		"#SFUI_WPNHUD_knife_falchion_advanced"
            "item_description"		"#CSGO_Item_Desc_knife_falchion_advanced"
            "image_inventory"		"econ/weapons/base_weapons/weapon_knife_falchion"
            "icon_default_image"		"materials/icons/inventory_icon_weapon_knife_falchion.vtf"
            "model_player"		"models/weapons/v_knife_falchion_advanced.mdl"
            "model_world"		"models/weapons/w_knife_falchion_advanced.mdl"
            "used_by_classes"
            {
                "terrorists"		"1"
                "counter-terrorists"		"1"
            }
            "attributes"
            {
                "pedestal display model"		"models/weapons/v_knife_falchion_advanced_inspect.mdl"
            }
            "inventory_image_data"
            {
                "camera_angles"		"0 0 0"
                "camera_offset"		"0 0 0"
            }
            "paint_data"
            {
                "PaintableMaterial0"
                {
                    "Name"		"knife_falchion_advanced"
                    "ViewmodelDim"		"2048"
                    "WorldDim"		"512"
                    "BaseTextureOverride"		"0"
                    "WeaponLength"		"12.570000"
                    "UVScale"		"0.360000"
                }
            }
            "tags"
            {
                "ItemSet"
                {
                    "tag_value"		"set_community_8"
                    "tag_text"		"#CSGO_set_community_8"
                    "tag_group"		"ItemSet"
                    "tag_group_text"		"#SFUI_InvTooltip_SetTag"
                }
            }
        }
        "514"
        {
            "name"		"weapon_knife_survival_bowie"
            "prefab"		"melee_unusual"
            "item_name"		"#SFUI_WPNHUD_knife_survival_bowie"
            "item_description"		"#CSGO_Item_Desc_knife_survival_bowie"
            "image_inventory"		"econ/weapons/base_weapons/weapon_knife_survival_bowie"
            "icon_default_image"		"materials/icons/inventory_icon_weapon_knife_survival_bowie.vtf"
            "model_player"		"models/weapons/v_knife_survival_bowie.mdl"
            "model_world"		"models/weapons/w_knife_survival_bowie.mdl"
            "model_dropped"		"models/weapons/w_knife_survival_bowie_dropped.mdl"
            "used_by_classes"
            {
                "terrorists"		"1"
                "counter-terrorists"		"1"
            }
            "attributes"
            {
                "pedestal display model"		"models/weapons/v_knife_survival_bowie_inspect.mdl"
            }
            "inventory_image_data"
            {
                "camera_angles"		"30.0 -95.0 29.0"
                "camera_offset"		"7.0 1.5 -1.5"
            }
            "paint_data"
            {
                "PaintableMaterial0"
                {
                    "Name"		"knife_survival_bowie"
                    "ViewmodelDim"		"2048"
                    "WorldDim"		"512"
                    "BaseTextureOverride"		"1"
                    "WeaponLength"		"18.434601"
                    "UVScale"		"0.461662"
                }
            }
            "tags"
            {
                "ItemSet"
                {
                    "tag_value"		"set_community_11"
                    "tag_text"		"#CSGO_set_community_11"
                    "tag_group"		"ItemSet"
                    "tag_group_text"		"#SFUI_InvTooltip_SetTag"
                }
            }
        }
        "515"
        {
            "name"		"weapon_knife_butterfly"
            "prefab"		"melee_unusual"
            "item_name"		"#SFUI_WPNHUD_Knife_Butterfly"
            "item_description"		"#CSGO_Item_Desc_Knife_Butterfly"
            "image_inventory"		"econ/weapons/base_weapons/weapon_knife_butterfly"
            "icon_default_image"		"materials/icons/inventory_icon_weapon_knife_butterfly.vtf"
            "model_player"		"models/weapons/v_knife_butterfly.mdl"
            "model_world"		"models/weapons/w_knife_butterfly.mdl"
            "used_by_classes"
            {
                "terrorists"		"1"
                "counter-terrorists"		"1"
            }
            "attributes"
            {
                "pedestal display model"		"models/weapons/v_knife_butterfly_inspect.mdl"
            }
            "inventory_image_data"
            {
                "camera_angles"		"30.0 -95.0 29.0"
                "camera_offset"		"9.0 1.5 -1.5"
                "spot_light_key"
                {
                    "position"		"-10 30 0"
                    "color"		"2.98 2.98 3"
                    "lookat"		"0.0 0.0 0.0"
                    "inner_cone"		"0.500000"
                    "outer_cone"		"1.000000"
                }
            }
            "paint_data"
            {
                "PaintableMaterial0"
                {
                    "Name"		"knife_butterfly"
                    "ViewmodelDim"		"2048"
                    "WorldDim"		"512"
                    "BaseTextureOverride"		"0"
                    "WeaponLength"		"15.300000"
                    "UVScale"		"0.506000"
                }
            }
            "tags"
            {
                "ItemSet"
                {
                    "tag_value"		"set_community_4"
                    "tag_text"		"#CSGO_set_community_4"
                    "tag_group"		"ItemSet"
                    "tag_group_text"		"#SFUI_InvTooltip_SetTag"
                }
            }
        }
        "516"
        {
            "name"		"weapon_knife_push"
            "prefab"		"melee_unusual"
            "item_name"		"#SFUI_WPNHUD_knife_push"
            "item_description"		"#CSGO_Item_Desc_knife_push"
            "image_inventory"		"econ/weapons/base_weapons/weapon_knife_push"
            "icon_default_image"		"materials/icons/inventory_icon_weapon_knife_push.vtf"
            "model_player"		"models/weapons/v_knife_push.mdl"
            "model_world"		"models/weapons/w_knife_push.mdl"
            "model_dropped"		"models/weapons/w_knife_push_dropped.mdl"
            "used_by_classes"
            {
                "terrorists"		"1"
                "counter-terrorists"		"1"
            }
            "attributes"
            {
                "pedestal display model"		"models/weapons/v_knife_push_inspect.mdl"
                "icon display model"		"models/weapons/w_knife_push_icon.mdl"
            }
            "inventory_image_data"
            {
                "spot_light_key"
                {
                    "position"		"0 -30 40"
                    "color"		"0.95 0.98 1"
                    "lookat"		"0.0 0.0 0.0"
                    "inner_cone"		"0.500000"
                    "outer_cone"		"1.000000"
                }
                "point_light_accent"
                {
                    "position"		"0 0 -50"
                    "color"		"1 1 1"
                }
            }
            "paint_data"
            {
                "PaintableMaterial0"
                {
                    "Name"		"knife_push"
                    "ViewmodelDim"		"2048"
                    "WorldDim"		"512"
                    "BaseTextureOverride"		"1"
                    "WeaponLength"		"5.884990"
                    "UVScale"		"0.583642"
                }
            }
            "tags"
            {
                "ItemSet"
                {
                    "tag_value"		"set_community_9"
                    "tag_text"		"#CSGO_set_community_9"
                    "tag_group"		"ItemSet"
                    "tag_group_text"		"#SFUI_InvTooltip_SetTag"
                }
            }
        }
        "517"
        {
            "name"		"weapon_knife_cord"
            "prefab"		"melee_unusual"
            "item_name"		"#SFUI_WPNHUD_knife_cord"
            "item_description"		"#CSGO_Item_Desc_knife_cord"
            "image_inventory"		"econ/weapons/base_weapons/weapon_knife_cord"
            "icon_default_image"		"materials/icons/inventory_icon_weapon_knife_cord.vtf"
            "model_player"		"models/weapons/v_knife_cord.mdl"
            "model_world"		"models/weapons/w_knife_cord.mdl"
            "model_dropped"		"models/weapons/w_knife_cord_dropped.mdl"
            "used_by_classes"
            {
                "terrorists"		"1"
                "counter-terrorists"		"1"
            }
            "attributes"
            {
                "pedestal display model"		"models/weapons/v_knife_cord_inspect.mdl"
            }
            "inventory_image_data"
            {
                "camera_angles"		"0 0 0"
                "camera_offset"		"0 0 0"
            }
            "paint_data"
            {
                "PaintableMaterial0"
                {
                    "Name"		"knife_cord"
                    "ViewmodelDim"		"2048"
                    "WorldDim"		"512"
                    "BaseTextureOverride"		"0"
                    "WeaponLength"		"12.570000"
                    "UVScale"		"0.360000"
                }
            }
        }
        "518"
        {
            "name"		"weapon_knife_canis"
            "prefab"		"melee_unusual"
            "item_name"		"#SFUI_WPNHUD_knife_canis"
            "item_description"		"#CSGO_Item_Desc_knife_canis"
            "image_inventory"		"econ/weapons/base_weapons/weapon_knife_canis"
            "icon_default_image"		"materials/icons/inventory_icon_weapon_knife_canis.vtf"
            "model_player"		"models/weapons/v_knife_canis.mdl"
            "model_world"		"models/weapons/w_knife_canis.mdl"
            "model_dropped"		"models/weapons/w_knife_canis_dropped.mdl"
            "used_by_classes"
            {
                "terrorists"		"1"
                "counter-terrorists"		"1"
            }
            "attributes"
            {
                "pedestal display model"		"models/weapons/v_knife_canis_inspect.mdl"
            }
            "inventory_image_data"
            {
                "camera_angles"		"0 0 0"
                "camera_offset"		"0 0 0"
            }
            "paint_data"
            {
                "PaintableMaterial0"
                {
                    "Name"		"knife_canis"
                    "ViewmodelDim"		"2048"
                    "WorldDim"		"512"
                    "BaseTextureOverride"		"0"
                    "WeaponLength"		"12.570000"
                    "UVScale"		"0.360000"
                }
            }
        }
        "519"
        {
            "name"		"weapon_knife_ursus"
            "prefab"		"melee_unusual"
            "item_name"		"#SFUI_WPNHUD_knife_ursus"
            "item_description"		"#CSGO_Item_Desc_knife_ursus"
            "image_inventory"		"econ/weapons/base_weapons/weapon_knife_ursus"
            "icon_default_image"		"materials/icons/inventory_icon_weapon_knife_ursus.vtf"
            "model_player"		"models/weapons/v_knife_ursus.mdl"
            "model_world"		"models/weapons/w_knife_ursus.mdl"
            "model_dropped"		"models/weapons/w_knife_ursus_dropped.mdl"
            "used_by_classes"
            {
                "terrorists"		"1"
                "counter-terrorists"		"1"
            }
            "attributes"
            {
                "pedestal display model"		"models/weapons/v_knife_ursus_inspect.mdl"
            }
            "inventory_image_data"
            {
                "spot_light_key"
                {
                    "position"		"-35 55 25"
                    "color"		"0.70 0.70 0.71"
                    "lookat"		"0.0 0.0 0.0"
                    "inner_cone"		"0.500000"
                    "outer_cone"		"2.000000"
                }
            }
            "paint_data"
            {
                "PaintableMaterial0"
                {
                    "Name"		"knife_ursus"
                    "ViewmodelDim"		"2048"
                    "WorldDim"		"512"
                    "BaseTextureOverride"		"0"
                    "WeaponLength"		"12.570000"
                    "UVScale"		"0.360000"
                }
            }
        }
        "520"
        {
            "name"		"weapon_knife_gypsy_jackknife"
            "prefab"		"melee_unusual"
            "item_name"		"#SFUI_WPNHUD_knife_gypsy_jackknife"
            "item_description"		"#CSGO_Item_Desc_knife_gypsy_jackknife"
            "image_inventory"		"econ/weapons/base_weapons/weapon_knife_gypsy_jackknife"
            "icon_default_image"		"materials/icons/inventory_icon_weapon_knife_gypsy_jackknife.vtf"
            "model_player"		"models/weapons/v_knife_gypsy_jackknife.mdl"
            "model_world"		"models/weapons/w_knife_gypsy_jackknife.mdl"
            "model_dropped"		"models/weapons/w_knife_gypsy_jackknife_dropped.mdl"
            "used_by_classes"
            {
                "terrorists"		"1"
                "counter-terrorists"		"1"
            }
            "attributes"
            {
                "pedestal display model"		"models/weapons/v_knife_gypsy_jackknife_inspect.mdl"
            }
            "inventory_image_data"
            {
                "spot_light_key"
                {
                    "position"		"-45 50 35"
                    "color"		"0.55 0.55 0.56"
                    "lookat"		"0.0 0.0 0.0"
                    "inner_cone"		"0.500000"
                    "outer_cone"		"1.000000"
                }
            }
            "paint_data"
            {
                "PaintableMaterial0"
                {
                    "Name"		"knife_gypsy_jack"
                    "ViewmodelDim"		"2048"
                    "WorldDim"		"512"
                    "BaseTextureOverride"		"0"
                    "WeaponLength"		"12.570000"
                    "UVScale"		"0.360000"
                }
            }
        }
        "521"
        {
            "name"		"weapon_knife_outdoor"
            "prefab"		"melee_unusual"
            "item_name"		"#SFUI_WPNHUD_knife_outdoor"
            "item_description"		"#CSGO_Item_Desc_knife_outdoor"
            "image_inventory"		"econ/weapons/base_weapons/weapon_knife_outdoor"
            "icon_default_image"		"materials/icons/inventory_icon_weapon_knife_outdoor.vtf"
            "model_player"		"models/weapons/v_knife_outdoor.mdl"
            "model_world"		"models/weapons/w_knife_outdoor.mdl"
            "model_dropped"		"models/weapons/w_knife_outdoor_dropped.mdl"
            "used_by_classes"
            {
                "terrorists"		"1"
                "counter-terrorists"		"1"
            }
            "attributes"
            {
                "pedestal display model"		"models/weapons/v_knife_outdoor_inspect.mdl"
            }
            "inventory_image_data"
            {
                "camera_angles"		"30.0 -95.0 29.0"
                "camera_offset"		"7.0 1.5 -1.5"
            }
            "paint_data"
            {
                "PaintableMaterial0"
                {
                    "Name"		"knife_outdoor"
                    "ViewmodelDim"		"2048"
                    "WorldDim"		"512"
                    "BaseTextureOverride"		"0"
                    "WeaponLength"		"12.570000"
                    "UVScale"		"0.360000"
                }
            }
        }
        "522"
        {
            "name"		"weapon_knife_stiletto"
            "prefab"		"melee_unusual"
            "item_name"		"#SFUI_WPNHUD_knife_stiletto"
            "item_description"		"#CSGO_Item_Desc_knife_stiletto"
            "image_inventory"		"econ/weapons/base_weapons/weapon_knife_stiletto"
            "icon_default_image"		"materials/icons/inventory_icon_weapon_knife_stiletto.vtf"
            "model_player"		"models/weapons/v_knife_stiletto.mdl"
            "model_world"		"models/weapons/w_knife_stiletto.mdl"
            "model_dropped"		"models/weapons/w_knife_stiletto_dropped.mdl"
            "used_by_classes"
            {
                "terrorists"		"1"
                "counter-terrorists"		"1"
            }
            "attributes"
            {
                "pedestal display model"		"models/weapons/v_knife_stiletto_inspect.mdl"
            }
            "inventory_image_data"
            {
                "spot_light_key"
                {
                    "position"		"-10 60 0"
                    "color"		"0.65 0.65 0.66"
                    "lookat"		"0.0 0.0 0.0"
                    "inner_cone"		"0.500000"
                    "outer_cone"		"1.500000"
                }
                "point_light_accent"
                {
                    "position"		"-85 60 65"
                    "color"		"0.65 0.65 0.66"
                }
            }
            "paint_data"
            {
                "PaintableMaterial0"
                {
                    "Name"		"knife_stiletto"
                    "ViewmodelDim"		"2048"
                    "WorldDim"		"512"
                    "BaseTextureOverride"		"0"
                    "WeaponLength"		"12.570000"
                    "UVScale"		"0.360000"
                }
            }
        }
        "523"
        {
            "name"		"weapon_knife_widowmaker"
            "prefab"		"melee_unusual"
            "item_name"		"#SFUI_WPNHUD_knife_widowmaker"
            "item_description"		"#CSGO_Item_Desc_knife_widowmaker"
            "image_inventory"		"econ/weapons/base_weapons/weapon_knife_widowmaker"
            "icon_default_image"		"materials/icons/inventory_icon_weapon_knife_widowmaker.vtf"
            "model_player"		"models/weapons/v_knife_widowmaker.mdl"
            "model_world"		"models/weapons/w_knife_widowmaker.mdl"
            "model_dropped"		"models/weapons/w_knife_widowmaker_dropped.mdl"
            "used_by_classes"
            {
                "terrorists"		"1"
                "counter-terrorists"		"1"
            }
            "attributes"
            {
                "pedestal display model"		"models/weapons/v_knife_widowmaker_inspect.mdl"
            }
            "inventory_image_data"
            {
                "camera_angles"		"0 0 0"
                "camera_offset"		"0 0 0"
            }
            "inventory_image_data"
            {
                "camera_angles"		"0 0 0"
                "camera_offset"		"0 0 0"
            }
            "paint_data"
            {
                "PaintableMaterial0"
                {
                    "Name"		"knife_widowmaker"
                    "ViewmodelDim"		"2048"
                    "WorldDim"		"512"
                    "BaseTextureOverride"		"0"
                    "WeaponLength"		"12.570000"
                    "UVScale"		"0.360000"
                }
            }
        }
        "525"
        {
            "name"		"weapon_knife_skeleton"
            "prefab"		"melee_unusual"
            "item_name"		"#SFUI_WPNHUD_knife_skeleton"
            "item_description"		"#CSGO_Item_Desc_knife_skeleton"
            "image_inventory"		"econ/weapons/base_weapons/weapon_knife_skeleton"
            "icon_default_image"		"materials/icons/inventory_icon_weapon_knife_skeleton.vtf"
            "model_player"		"models/weapons/v_knife_skeleton.mdl"
            "model_world"		"models/weapons/w_knife_skeleton.mdl"
            "model_dropped"		"models/weapons/w_knife_skeleton_dropped.mdl"
            "used_by_classes"
            {
                "terrorists"		"1"
                "counter-terrorists"		"1"
            }
            "attributes"
            {
                "pedestal display model"		"models/weapons/v_knife_skeleton_inspect.mdl"
            }
            "inventory_image_data"
            {
                "camera_angles"		"0 0 0"
                "camera_offset"		"0 0 0"
            }
            "paint_data"
            {
                "PaintableMaterial0"
                {
                    "Name"		"knife_skeleton"
                    "ViewmodelDim"		"2048"
                    "WorldDim"		"512"
                    "BaseTextureOverride"		"0"
                    "WeaponLength"		"12.570000"
                    "UVScale"		"0.360000"
                }
            }
        }
    }]==]
    local kvPrefab = util.KeyValuesToTable(strPrefab, true, false)
    local knives = {}

    for _, v in next, kvPrefab do
        v.name = v.name:gsub("weapon_", "weapon_swcs_")
        local vm = Model(v.model_player):gsub("weapons/", "weapons/csgo/")
        local wm = Model(v.model_dropped or "models/weapons/v_knife_default_t.mdl"):gsub("weapons/", "weapons/csgo/")
        local pm = Model(v.model_world):gsub("weapons/", "weapons/csgo/")

        knives[v.name] = {
            pn = v.item_name,
            wm = wm,
            vm = vm,
            pm = pm,
            dv = [=["visuals 08/31/2020" {
                "weapon_type" "knife"
            }]=],
            da = [=["attributes 08/31/2020" {
                "primary clip size" "-1"
                "is full auto" "1"
                "recoil seed" "0"
                "recoil angle variance" "0"
                "recoil magnitude" "0"
                "recoil magnitude variance" "0"
                "recoil angle variance alt" "0"
                "recoil magnitude alt" "0"
                "recoil magnitude variance alt" "0"
            }]=]
        }
    end

    knives["weapon_swcs_knife_push"].HoldType = "fist"

    for classname, t in next, knives do
        local SWEP = {
            Base = "weapon_swcs_knife",

            Primary = {},
            Secondary = {},
            Spawnable = true,

            PrintName = t.pn,
            WorldModel = t.wm,
            ViewModel = t.vm,
            WorldModelPlayer = t.pm,
            ItemDefVisuals = t.dv,
            ItemDefAttributes = t.da,

            Category = "SWCS Knives",
            IsKnife = true,
            IsSWCSWeapon = true,

            AutoSpawnable = false, -- ttt
        }

        if t.HoldType then
            SWEP.HoldType = t.HoldType
        end

        weapons.Register(SWEP, classname)
    end
end

-- language strs
if CLIENT then
    local strEnglish = [==[ "english" {
        "SFUI_WPNHUD_Knife"			"Knife"
        "SFUI_WPNHUD_Knife_T"		"Knife"
        "SFUI_WPNHUD_Knife_GG"		"Gold Knife"
        "SFUI_WPNHUD_Knife_Ghost"	"Spectral Shiv"
        "SFUI_WPNHUD_KnifeBayonet"	"Bayonet"
        "SFUI_WPNHUD_KnifeFlip"		"Flip Knife"
        "SFUI_WPNHUD_KnifeGut"		"Gut Knife"
        "SFUI_WPNHUD_KnifeCSS"		"Classic Knife"
        "SFUI_WPNHUD_KnifeM9"		"M9 Bayonet"
        "SFUI_WPNHUD_KnifeKaram"	"Karambit"
        "SFUI_WPNHUD_KnifeTactical" "Huntsman Knife"
        "SFUI_WPNHUD_Knife_Butterfly" "Butterfly Knife"
        "SFUI_WPNHUD_knife_falchion_advanced" "Falchion Knife"
        "SFUI_WPNHUD_knife_push" "Shadow Daggers"
        "SFUI_WPNHUD_knife_survival_bowie" "Bowie Knife"
        "SFUI_WPNHUD_knife_cord"	"Paracord Knife"
        "SFUI_WPNHUD_knife_canis"	"Survival Knife"
        "SFUI_WPNHUD_knife_ursus"	"Ursus Knife"
        "SFUI_WPNHUD_knife_gypsy_jackknife" "Navaja Knife"
        "SFUI_WPNHUD_knife_outdoor" "Nomad Knife"
        "SFUI_WPNHUD_knife_widowmaker" "Talon Knife"
        "SFUI_WPNHUD_knife_stiletto" "Stiletto Knife"
        "SFUI_WPNHUD_knife_skeleton" "Skeleton Knife"
    }]==]
    local kvEnglish = util.KeyValuesToTable(strEnglish, true, true)

    for key, str in next, kvEnglish do
        language.Add(key, str)
    end
end

-- soundscripts
do
    local strSounds = string.gsub([==["sounds"  {
        // Butterfly Knife
        "ButterflyKnife.backstab01"
        {
            "channel"		"CHAN_ITEM"
            "volume"		"0.4"
            "pitch"			"PITCH_NORM"
            "soundlevel"  	"SNDLVL_65dB"
            "wave"			"~weapons/bknife/bknife_backstab01.wav"
            "soundentry_version" "2"
            "operator_stacks"
            {
                "start_stack"
                {
                    "import_stack" "CS_limit_start"
                }

                "update_stack"
                {
                    "import_stack" "CS_update_foley"
                    "mixer"
                    {
                        "mixgroup" "FoleyWeapons"
                    }
                }
            }
        }
        "ButterflyKnife.backstab02"
        {
            "channel"		"CHAN_ITEM"
            "volume"		"0.4"
            "pitch"			"PITCH_NORM"
            "soundlevel"  	"SNDLVL_65dB"
            "wave"			"~weapons/bknife/bknife_backstab02.wav"
            "soundentry_version" "2"
            "operator_stacks"
            {
                "start_stack"
                {
                    "import_stack" "CS_limit_start"
                }

                "update_stack"
                {
                    "import_stack" "CS_update_foley"
                    "mixer"
                    {
                        "mixgroup" "FoleyWeapons"
                    }
                }
            }
        }
        "ButterflyKnife.draw01"
        {
            "channel"		"CHAN_ITEM"
            "volume"		"0.3" //.draw
            "pitch"			"PITCH_NORM"
            "soundlevel"  	"SNDLVL_65dB"
            "wave"			"~weapons/bknife/bknife_draw01.wav"
            "soundentry_version" "2"
            "operator_stacks"
            {
                "start_stack"
                {
                    "import_stack" "CS_limit_start"
                }

                "update_stack"
                {
                    "import_stack" "CS_update_foley"
                    "mixer"
                    {
                        "mixgroup" "FoleyWeapons"
                    }
                }
            }
        }
        "ButterflyKnife.draw02"
        {
            "channel"		"CHAN_ITEM"
            "volume"		"0.3" //.draw
            "pitch"			"PITCH_NORM"
            "soundlevel"  	"SNDLVL_65dB"
            "wave"			"~weapons/bknife/bknife_draw02.wav"
            "soundentry_version" "2"
            "operator_stacks"
            {
                "start_stack"
                {
                    "import_stack" "CS_limit_start"
                }

                "update_stack"
                {
                    "import_stack" "CS_update_foley"
                    "mixer"
                    {
                        "mixgroup" "FoleyWeapons"
                    }
                }
            }
        }
        "ButterflyKnife.look01_a"
        {
            "channel"		"CHAN_ITEM"
            "volume"		"0.4"
            "pitch"			"PITCH_NORM"
            "soundlevel"  	"SNDLVL_65dB"
            "wave"			"weapons/bknife/bknife_look01_a.wav"
            "soundentry_version" "2"
            "operator_stacks"
            {
                "start_stack"
                {
                    "import_stack" "CS_limit_start"
                }

                "update_stack"
                {
                    "import_stack" "CS_update_foley"
                    "mixer"
                    {
                        "mixgroup" "FoleyWeapons"
                    }
                }
            }
        }
        "ButterflyKnife.look01_b"
        {
            "channel"		"CHAN_ITEM"
            "volume"		"0.4"
            "pitch"			"PITCH_NORM"
            "soundlevel"  	"SNDLVL_65dB"
            "wave"			"weapons/bknife/bknife_look01_b.wav"
            "soundentry_version" "2"
            "operator_stacks"
            {
                "start_stack"
                {
                    "import_stack" "CS_limit_start"
                }

                "update_stack"
                {
                    "import_stack" "CS_update_foley"
                    "mixer"
                    {
                        "mixgroup" "FoleyWeapons"
                    }
                }
            }
        }
        "ButterflyKnife.look02_a"
        {
            "channel"		"CHAN_ITEM"
            "volume"		"0.4"
            "pitch"			"PITCH_NORM"
            "soundlevel"  	"SNDLVL_65dB"
            "wave"			"weapons/bknife/bknife_look02_a.wav"
            "soundentry_version" "2"
            "operator_stacks"
            {
                "start_stack"
                {
                    "import_stack" "CS_limit_start"
                }

                "update_stack"
                {
                    "import_stack" "CS_update_foley"
                    "mixer"
                    {
                        "mixgroup" "FoleyWeapons"
                    }
                }
            }
        }
        "ButterflyKnife.look02_b"
        {
            "channel"		"CHAN_ITEM"
            "volume"		"0.4"
            "pitch"			"PITCH_NORM"
            "soundlevel"  	"SNDLVL_65dB"
            "wave"			"weapons/bknife/bknife_look02_b.wav"
            "soundentry_version" "2"
            "operator_stacks"
            {
                "start_stack"
                {
                    "import_stack" "CS_limit_start"
                }

                "update_stack"
                {
                    "import_stack" "CS_update_foley"
                    "mixer"
                    {
                        "mixgroup" "FoleyWeapons"
                    }
                }
            }
        }
        "ButterflyKnife.look03_a"
        {
            "channel"		"CHAN_ITEM"
            "volume"		"0.4"
            "pitch"			"PITCH_NORM"
            "soundlevel"  	"SNDLVL_65dB"
            "wave"			"weapons/bknife/bknife_look03_a.wav"
            "soundentry_version" "2"
            "operator_stacks"
            {
                "start_stack"
                {
                    "import_stack" "CS_limit_start"
                }

                "update_stack"
                {
                    "import_stack" "CS_update_foley"
                    "mixer"
                    {
                        "mixgroup" "FoleyWeapons"
                    }
                }
            }
        }
        "ButterflyKnife.look03_b"
        {
            "channel"		"CHAN_ITEM"
            "volume"		"0.4"
            "pitch"			"PITCH_NORM"
            "soundlevel"  	"SNDLVL_65dB"
            "wave"			"weapons/bknife/bknife_look03_b.wav"
            "soundentry_version" "2"
            "operator_stacks"
            {
                "start_stack"
                {
                    "import_stack" "CS_limit_start"
                }

                "update_stack"
                {
                    "import_stack" "CS_update_foley"
                    "mixer"
                    {
                        "mixgroup" "FoleyWeapons"
                    }
                }
            }
        }

        "KnifeFalchion.inspect"
        {
            "channel"		"CHAN_STATIC"
            "volume"		"1"
            "pitch"			"PITCH_NORM"
            "soundlevel"  	"SNDLVL_65dB"
            "wave"			")weapons/knife_falchion/knife_falchion_inspect.wav"
            "soundentry_version" "2"
            "operator_stacks"
            {
                "start_stack"
                {
                    "import_stack" "CS_limit_start"
                }

                "update_stack"
                {
                    "import_stack" "CS_update_foley"
                    "mixer"
                    {
                        "mixgroup" "FoleyWeapons"
                    }
                }
            }
        }

        "KnifeFalchion.draw"
        {
            "channel"		"CHAN_STATIC"
            "volume"		"0.3" //.draw
            "pitch"			"97, 105"
            "soundlevel"  	"SNDLVL_65dB"
            "wave"			")weapons/knife_falchion/knife_falchion_draw.wav"
            "soundentry_version" "2"
            "operator_stacks"
            {
                "start_stack"
                {
                    "import_stack" "CS_limit_start"
                }

                "update_stack"
                {
                    "import_stack" "CS_update_foley"
                    "mixer"
                    {
                        "mixgroup" "FoleyWeapons"
                    }
                }
            }
        }

        "KnifeFalchion.Catch"
        {
            "channel"		"CHAN_STATIC"
            "volume"		"0.3, 0.7"
            "pitch"			"97, 105"
            "soundlevel"  	"SNDLVL_65dB"
            "wave"			")weapons/knife_falchion/knife_falchion_catch.wav"
            "soundentry_version" "2"
            "operator_stacks"
            {
                "start_stack"
                {
                    "import_stack" "CS_limit_start"
                }

                "update_stack"
                {
                    "import_stack" "CS_update_foley"
                    "mixer"
                    {
                        "mixgroup" "FoleyWeapons"
                    }
                }
            }
        }


        "KnifeFalchion.Idlev2"
        {
            "channel"		"CHAN_STATIC"
            "volume"		"1"
            "pitch"			"PITCH_NORM"
            "soundlevel"  	"SNDLVL_65dB"
            "wave"			")weapons/knife_falchion/knife_falchion_idle.wav"
            "soundentry_version" "2"
            "operator_stacks"
            {
                "start_stack"
                {
                    "import_stack" "CS_limit_start"
                }

                "update_stack"
                {
                    "import_stack" "CS_update_foley"
                    "mixer"
                    {
                        "mixgroup" "FoleyWeapons"
                    }
                }
            }
        }

        "KnifeBowie.draw"
        {
            "channel"		"CHAN_STATIC"
            "volume"		"0.3" //.draw
            "pitch"			"99, 100"
            "soundlevel"  	"SNDLVL_65dB"
            "wave"			")weapons/knife_bowie/knife_bowie_draw.wav"
            "soundentry_version" "2"
            "operator_stacks"
            {
                "start_stack"
                {
                    "import_stack" "CS_limit_start"
                }

                "update_stack"
                {
                    "import_stack" "CS_update_foley"
                    "mixer"
                    {
                        "mixgroup" "FoleyWeapons"
                    }
                }
            }
        }

        "KnifeBowie.LookAtStart"
        {
            "channel"		"CHAN_STATIC"
            "volume"		"0.2, 0.2"
            "pitch"			"99, 100"
            "soundlevel"  	"SNDLVL_65dB"
            "wave"			")weapons/knife_bowie/knife_bowie_inspect_start.wav"
            "soundentry_version" "2"
            "operator_stacks"
            {
                "start_stack"
                {
                    "import_stack" "CS_limit_start"
                }

                "update_stack"
                {
                    "import_stack" "CS_update_foley"
                    "mixer"
                    {
                        "mixgroup" "FoleyWeapons"
                    }
                }
            }
        }

        "KnifeBowie.LookAtEnd"
        {
            "channel"		"CHAN_STATIC"
            "volume"		"0.2, 0.3"
            "pitch"			"99, 101"
            "soundlevel"  	"SNDLVL_65dB"
            "wave"			")weapons/knife_bowie/knife_bowie_inspect_end.wav"
            "soundentry_version" "2"
            "operator_stacks"
            {
                "start_stack"
                {
                    "import_stack" "CS_limit_start"
                }

                "update_stack"
                {
                    "import_stack" "CS_update_foley"
                    "mixer"
                    {
                        "mixgroup" "FoleyWeapons"
                    }
                }
            }
        }

        "KnifePush.Draw"
        {
            "channel"		"CHAN_STATIC"
            "volume"		"0.3" //.draw
            "pitch"			"100"
            "soundlevel"  	"SNDLVL_65dB"
            "wave"			")weapons/knife_push/knife_push_draw.wav"
            "soundentry_version" "2"
            "operator_stacks"
            {
                "start_stack"
                {
                    "import_stack" "CS_limit_start"
                }

                "update_stack"
                {
                    "import_stack" "CS_update_foley"
                    "mixer"
                    {
                        "mixgroup" "FoleyWeapons"
                    }
                }
            }
        }

        "KnifePush.Attack1Heavy"
        {
            "channel"		"CHAN_STATIC"
            "volume"		"0.1, 0.2"
            "pitch"			"98, 105"
            "soundlevel"  	"SNDLVL_65dB"
            "rndwave"
            {
                "wave"		")weapons/knife_push/knife_push_attack1_heavy_01.wav"
                "wave"		")weapons/knife_push/knife_push_attack1_heavy_02.wav"
                "wave"		")weapons/knife_push/knife_push_attack1_heavy_03.wav"
                "wave"		")weapons/knife_push/knife_push_attack1_heavy_04.wav"
            }
            "soundentry_version" "2"
            "operator_stacks"
            {
                "start_stack"
                {
                    "import_stack" "CS_limit_start"
                }

                "update_stack"
                {
                    "import_stack" "CS_update_foley"
                    "mixer"
                    {
                        "mixgroup" "FoleyWeapons"
                    }
                }
            }
        }

        "KnifePush.LookAtStart"
        {
            "channel"		"CHAN_STATIC"
            "volume"		"0.2"
            "pitch"			"100"
            "soundlevel"  	"SNDLVL_65dB"
            "wave"			")weapons/knife_push/knife_push_lookat_start.wav"
            "soundentry_version" "2"
            "operator_stacks"
            {
                "start_stack"
                {
                    "import_stack" "CS_limit_start"
                }

                "update_stack"
                {
                    "import_stack" "CS_update_foley"
                    "mixer"
                    {
                        "mixgroup" "FoleyWeapons"
                    }
                }
            }
        }

        "KnifePush.LookAtEnd"
        {
            "channel"		"CHAN_STATIC"
            "volume"		"0.2"
            "pitch"			"100"
            "soundlevel"  	"SNDLVL_65dB"
            "wave"			")weapons/knife_push/knife_push_lookat_end.wav"
            "soundentry_version" "2"
            "operator_stacks"
            {
                "start_stack"
                {
                    "import_stack" "CS_limit_start"
                }

                "update_stack"
                {
                    "import_stack" "CS_update_foley"
                    "mixer"
                    {
                        "mixgroup" "FoleyWeapons"
                    }
                }
            }
        }

        "Knife.Ursus.Catch.01"
        {
            "channel"		"CHAN_ITEM"
            "volume"		"0.3" //.draw
            "pitch"			"PITCH_NORM"
            "soundlevel"  	"SNDLVL_65dB"
            "wave"			"~)weapons\knife_ursus\ursus_catch_01.wav"
            "soundentry_version" "2"
            "operator_stacks"
            {
                "start_stack"
                {
                    "import_stack" "CS_limit_start"
                }

                "update_stack"
                {
                    "import_stack" "CS_update_foley"
                    "mixer"
                    {
                        "mixgroup" "FoleyWeapons"
                    }
                }
            }
        }

        "Knife.Ursus.Flip.Loop"
        {
            "channel"		"CHAN_ITEM"
            "volume"		"0.3" //.draw
            "pitch"			"PITCH_NORM"
            "soundlevel"  	"SNDLVL_65dB"
            
            "rndwave"
            {
                "wave"			"~)weapons\knife_ursus\ursus_flip_01.wav"
                "wave"			"~)weapons\knife_ursus\ursus_flip_02.wav"
                "wave"			"~)weapons\knife_ursus\ursus_flip_03.wav"
                "wave"			"~)weapons\knife_ursus\ursus_flip_04.wav"
                "wave"			"~)weapons\knife_ursus\ursus_flip_04.wav"
            }
            
            "soundentry_version" "2"
            "operator_stacks"
            {
                "start_stack"
                {
                    "import_stack" "CS_limit_start"
                }

                "update_stack"
                {
                    "import_stack" "CS_update_foley"
                    "mixer"
                    {
                        "mixgroup" "FoleyWeapons"
                    }
                }
            }
        }

        "Knife.Ursus.Flip.01"
        {
            "channel"		"CHAN_ITEM"
            "volume"		"0.3" //.draw
            "pitch"			"PITCH_NORM"
            "soundlevel"  	"SNDLVL_65dB"
            "wave"			"~)weapons\knife_ursus\ursus_flip_01.wav"
            "soundentry_version" "2"
            "operator_stacks"
            {
                "start_stack"
                {
                    "import_stack" "CS_limit_start"
                }

                "update_stack"
                {
                    "import_stack" "CS_update_foley"
                    "mixer"
                    {
                        "mixgroup" "FoleyWeapons"
                    }
                }
            }
        }

        "Knife.Ursus.Flip.02"
        {
            "channel"		"CHAN_ITEM"
            "volume"		"0.3" //.draw
            "pitch"			"PITCH_NORM"
            "soundlevel"  	"SNDLVL_65dB"
            "wave"			"~)weapons\knife_ursus\ursus_flip_02.wav"
            "soundentry_version" "2"
            "operator_stacks"
            {
                "start_stack"
                {
                    "import_stack" "CS_limit_start"
                }

                "update_stack"
                {
                    "import_stack" "CS_update_foley"
                    "mixer"
                    {
                        "mixgroup" "FoleyWeapons"
                    }
                }
            }
        }

        "Knife.Ursus.Flip.03"
        {
            "channel"		"CHAN_ITEM"
            "volume"		"0.3" //.draw
            "pitch"			"PITCH_NORM"
            "soundlevel"  	"SNDLVL_65dB"
            "wave"			"~)weapons\knife_ursus\ursus_flip_03.wav"
            "soundentry_version" "2"
            "operator_stacks"
            {
                "start_stack"
                {
                    "import_stack" "CS_limit_start"
                }

                "update_stack"
                {
                    "import_stack" "CS_update_foley"
                    "mixer"
                    {
                        "mixgroup" "FoleyWeapons"
                    }
                }
            }
        }

        "Knife.Ursus.Flip.04"
        {
            "channel"		"CHAN_ITEM"
            "volume"		"0.3" //.draw
            "pitch"			"PITCH_NORM"
            "soundlevel"  	"SNDLVL_65dB"
            "wave"			"~)weapons\knife_ursus\ursus_flip_04.wav"
            "soundentry_version" "2"
            "operator_stacks"
            {
                "start_stack"
                {
                    "import_stack" "CS_limit_start"
                }

                "update_stack"
                {
                    "import_stack" "CS_update_foley"
                    "mixer"
                    {
                        "mixgroup" "FoleyWeapons"
                    }
                }
            }
        }

        "Knife.Ursus.Flip.05"
        {
            "channel"		"CHAN_ITEM"
            "volume"		"0.3" //.draw
            "pitch"			"PITCH_NORM"
            "soundlevel"  	"SNDLVL_65dB"
            "wave"			"~)weapons\knife_ursus\ursus_flip_05.wav"
            "soundentry_version" "2"
            "operator_stacks"
            {
                "start_stack"
                {
                    "import_stack" "CS_limit_start"
                }

                "update_stack"
                {
                    "import_stack" "CS_update_foley"
                    "mixer"
                    {
                        "mixgroup" "FoleyWeapons"
                    }
                }
            }
        }

        "Knife.Widow.Deploy.01"
        {
            "channel"		"CHAN_ITEM"
            "volume"		"0.3" //.draw
            "pitch"			"PITCH_NORM"
            "soundlevel"  	"SNDLVL_65dB"
            "wave"			"~)weapons\knife_widow\widow_deploy_01.wav"
            "soundentry_version" "2"
            "operator_stacks"
            {
                "start_stack"
                {
                    "import_stack" "CS_limit_start"
                }

                "update_stack"
                {
                    "import_stack" "CS_update_foley"
                    "mixer"
                    {
                        "mixgroup" "FoleyWeapons"
                    }
                }
            }
        }

        "Knife.Widow.LookAt2.Start"
        {
            "channel"		"CHAN_ITEM"
            "volume"		"0.3" //.draw
            "pitch"			"PITCH_NORM"
            "soundlevel"  	"SNDLVL_65dB"
            "wave"			"~)weapons\knife_widow\widow_lookat2_start.wav"
            "soundentry_version" "2"
            "operator_stacks"
            {
                "start_stack"
                {
                    "import_stack" "CS_limit_start"
                }

                "update_stack"
                {
                    "import_stack" "CS_update_foley"
                    "mixer"
                    {
                        "mixgroup" "FoleyWeapons"
                    }
                }
            }
        }

        "Knife.Widow.LookAt2.End"
        {
            "channel"		"CHAN_ITEM"
            "volume"		"0.2" //.draw
            "pitch"			"PITCH_NORM"
            "soundlevel"  	"SNDLVL_65dB"
            "wave"			"~)weapons\knife_widow\widow_lookat2_end.wav"
            "soundentry_version" "2"
            "operator_stacks"
            {
                "start_stack"
                {
                    "import_stack" "CS_limit_start"
                }

                "update_stack"
                {
                    "import_stack" "CS_update_foley"
                    "mixer"
                    {
                        "mixgroup" "FoleyWeapons"
                    }
                }
            }
        }

        "Knife.Widow.LookAt2.Loop"
        {
            "channel"		"CHAN_ITEM"
            "volume"		"0.2, 0.3" //.draw
            "pitch"			"99, 101"
            "soundlevel"  	"SNDLVL_65dB"
            "rndwave"
            {
                "wave"			"~)weapons\knife_widow\widow_lookat2_loop_02.wav"
                "wave"			"~)weapons\knife_widow\widow_lookat2_loop_03.wav"
                "wave"			"~)weapons\knife_widow\widow_lookat2_loop_04.wav"
                "wave"			"~)weapons\knife_widow\widow_lookat2_loop_05.wav"
            }
            "soundentry_version" "2"
            "operator_stacks"
            {
                "start_stack"
                {
                    "import_stack" "CS_limit_start"
                }

                "update_stack"
                {
                    "import_stack" "CS_update_foley"
                    "mixer"
                    {
                        "mixgroup" "FoleyWeapons"
                    }
                }
            }
        }

        "Knife.Stilleto.Draw.01"
        {
            "channel"		"CHAN_ITEM"
            "volume"		"0.3" //.draw
            "pitch"			"PITCH_NORM"
            "soundlevel"  	"SNDLVL_65dB"
            "wave"			"~)weapons\knife_stilleto\stilletto_draw_01.wav"
            "soundentry_version" "2"
            "operator_stacks"
            {
                "start_stack"
                {
                    "import_stack" "CS_limit_start"
                }

                "update_stack"
                {
                    "import_stack" "CS_update_foley"
                    "mixer"
                    {
                        "mixgroup" "FoleyWeapons"
                    }
                }
            }
        }

        "Knife.Stilleto.Flip.Loop"
        {
            "channel"		"CHAN_STATIC"
            "volume"		"0.2" //.draw
            "pitch"			"98, 102"
            "soundlevel"  	"SNDLVL_65dB"
            
            "rndwave"
            {
                "wave"			"~)weapons\knife_stilleto\stilletto_flip_02.wav"
                "wave"			"~)weapons\knife_stilleto\stilletto_flip_03.wav"
                "wave"			"~)weapons\knife_stilleto\stilletto_flip_04.wav"
            }
            
            "soundentry_version" "2"
            "operator_stacks"
            {
                "start_stack"
                {
                    "import_stack" "CS_limit_start"
                }

                "update_stack"
                {
                    "import_stack" "CS_update_foley"
                    "mixer"
                    {
                        "mixgroup" "FoleyWeapons"
                    }
                }
            }
        }

        "Knife.Stilleto.Flip.01"
        {
            "channel"		"CHAN_ITEM"
            "volume"		"0.2" //.draw
            "pitch"			"PITCH_NORM"
            "soundlevel"  	"SNDLVL_65dB"
            "wave"			"~)weapons\knife_stilleto\stilletto_flip_01.wav"
            "soundentry_version" "2"
            "operator_stacks"
            {
                "start_stack"
                {
                    "import_stack" "CS_limit_start"
                }

                "update_stack"
                {
                    "import_stack" "CS_update_foley"
                    "mixer"
                    {
                        "mixgroup" "FoleyWeapons"
                    }
                }
            }
        }

        "Knife.Stilleto.Flip.02"
        {
            "channel"		"CHAN_ITEM"
            "volume"		"0.2" //.draw
            "pitch"			"PITCH_NORM"
            "soundlevel"  	"SNDLVL_65dB"
            "wave"			"~)weapons\knife_stilleto\stilletto_flip_02.wav"
            "soundentry_version" "2"
            "operator_stacks"
            {
                "start_stack"
                {
                    "import_stack" "CS_limit_start"
                }

                "update_stack"
                {
                    "import_stack" "CS_update_foley"
                    "mixer"
                    {
                        "mixgroup" "FoleyWeapons"
                    }
                }
            }
        }

        "Knife.Stilleto.Flip.03"
        {
            "channel"		"CHAN_ITEM"
            "volume"		"0.3" //.draw
            "pitch"			"PITCH_NORM"
            "soundlevel"  	"SNDLVL_65dB"
            "wave"			"~)weapons\knife_stilleto\stilletto_flip_03.wav"
            "soundentry_version" "2"
            "operator_stacks"
            {
                "start_stack"
                {
                    "import_stack" "CS_limit_start"
                }

                "update_stack"
                {
                    "import_stack" "CS_update_foley"
                    "mixer"
                    {
                        "mixgroup" "FoleyWeapons"
                    }
                }
            }
        }

        "Knife.Stilleto.Flip.04"
        {
            "channel"		"CHAN_ITEM"
            "volume"		"0.3" //.draw
            "pitch"			"PITCH_NORM"
            "soundlevel"  	"SNDLVL_65dB"
            "wave"			"~)weapons\knife_stilleto\stilletto_flip_04.wav"
            "soundentry_version" "2"
            "operator_stacks"
            {
                "start_stack"
                {
                    "import_stack" "CS_limit_start"
                }

                "update_stack"
                {
                    "import_stack" "CS_update_foley"
                    "mixer"
                    {
                        "mixgroup" "FoleyWeapons"
                    }
                }
            }
        }

        "Knife.Gypsy.Draw.01"
        {
            "channel"		"CHAN_ITEM"
            "volume"		"0.3" //.draw
            "pitch"			"PITCH_NORM"
            "soundlevel"  	"SNDLVL_65dB"
            "wave"			"~)weapons\knife_gypsy\gypsy_draw_01.wav"
            "soundentry_version" "2"
            "operator_stacks"
            {
                "start_stack"
                {
                    "import_stack" "CS_limit_start"
                }

                "update_stack"
                {
                    "import_stack" "CS_update_foley"
                    "mixer"
                    {
                        "mixgroup" "FoleyWeapons"
                    }
                }
            }
        }
    }]==], "\\", "\\\\")
    --local kvSounds = util.KeyValuesToTable(strSounds, true, false)
    local kvoSounds = util.KeyValuesToTablePreserveOrder(strSounds, true, false)

    local soundData = {}
    for _, kv in next, kvoSounds do
        local name = kv.Key
        local t = table.CollapseKeyValue(kv.Value)

        soundData.name = name

        local sndLevel = t.soundlevel
        sndLevel = tonumber(sndLevel:match("%d+"))
        soundData.level = sndLevel or 85 -- SNDLVL_NORM

        if tonumber(t.volume) then
            soundData.volume = tonumber(t.volume)
        elseif isstring(t.volume) then
            local tVolume = t.volume:Split(",")
            local volData = {}

            for k,v in next, tVolume do
                if tonumber(v) then
                    table.insert(volData, tonumber(v))
                end
            end

            soundData.volume = volData
        end

        soundData.channel = _G[t.channel]
        soundData.pitch = 100 -- do with sound data pls

        if isstring(t.wave) then
            soundData.sound = Sound(t.wave:gsub("weapons\\", "weapons\\csgo\\"):gsub("weapons/", "weapons/csgo/"):gsub("~",""))
        elseif istable(t.rndwave) then
            local waveData = {}

            for _, kv2 in next, kv.Value do
                if kv2.Key == "rndwave" then
                    for _, kv3 in next, kv2.Value do
                        table.insert(waveData, Sound(kv3.Value:gsub("weapons\\", "weapons\\csgo\\"):gsub("weapons/", "weapons/csgo/"):gsub("~","")))
                    end
                end
            end

            soundData.sound = waveData
        end

        sound.Add(soundData)
    end

end
