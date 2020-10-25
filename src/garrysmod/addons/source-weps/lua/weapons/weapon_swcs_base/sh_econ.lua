AddCSLuaFile()

-- econ as in skins and shit ;)

-- adjust this to work with skins pls <3
--[[
local hands_sub = {
    --custom_mp5k = 5,
    --custom_ak5 = 2,
    --custom_cz52 = 2,
    --custom_hmg1 = 2,
    --custom_oicw = 0,
    --custom_remi870 = 0,
    custom_xm1014 = 2,
    custom_spas12 = 2,
    weapon_uzi = 0,
    weapon_alyxgun = 0,
    --weapon_sniperrifle = {1,5}
}
function SWEP:PreDrawViewModel(vm, wep, ply)
    local a = hands_sub[wep:GetClass()]
    if a then
        if istable(a) then
            for _,i in next, a do
                vm:SetSubMaterial(i, "engine/occlusionproxy")
            end
        else
            vm:SetSubMaterial(a, "engine/occlusionproxy")
        end

        self.UseHands = true
    end
end
function SWEP:PostDrawViewModel(vm, wep, ply)
    local a = hands_sub[wep:GetClass()]
    if a then
        if istable(a) then
            for _,i in next, a do
                vm:SetSubMaterial(i, "")
            end
        else
            vm:SetSubMaterial(a, "")
        end
    end
end
]]

local neon_rider = source_weps.GenerateEconTexture({
    basetexture = "models/weapons/customization/paints/custom/ak_neon_rider",
    wearvalue = 1
})
local ak_uv = source_weps.GenerateEconTexture({
    basetexture = "models/weapons/customization/uvs/weapon_ak47",
    wearvalue = 1
})

local css_uv = source_weps.GenerateEconTexture({
    basetexture = "models/weapons/customization/uvs/weapon_knife_css",
    wearvalue = 1
})

local awp_cat = source_weps.GenerateEconTexture({
    basetexture = "models/weapons/customization/paints/anodized_multi/workshop/awp_pawpaw",
    wearvalue = 1
})
local awp_medusa = source_weps.GenerateEconTexture({
    basetexture = "models/weapons/customization/paints/antiqued/medusa_awp",
    wearvalue = 1
})

local deagle_etched = source_weps.GenerateEconTexture({
    basetexture = "models/weapons/customization/paints/antiqued/etched_deagle",
    wearvalue = 1
})

local cz_etched = source_weps.GenerateEconTexture({
    basetexture = "models/weapons/customization/paints/antiqued/etched_cz75",
    normalmap = "models/weapons/customization/paints/antiqued/etched_cz75_normal",
    wearvalue = 1
})

local bayonet_future = source_weps.GenerateEconTexture({
    basetexture = "models/weapons/customization/paints/gunsmith/bayonet_future_alt",
    normalmap = "models/weapons/customization/paints/gunsmith/bayonet_future_alt_normal",
    wearvalue = 1
})

function SWEP:ApplyWeaponSkin(vm, owner)
    if SERVER then return end

    if not self.m_clSkinTexture then
        --local want_skin = owner:GetPData("swcs_skin")
        --if want_skin == nil then return end
        --print(vm, self.m_clSkinTexture, want_skin)

        self.m_clSkinTexture = "!" .. cz_etched
    end
    if not self.m_clSkinTexture then return end

    --vm:SetSubMaterial(0, self.m_clSkinTexture)
end

function SWEP:RemoveWeaponSkin(vm, owner)
    vm:SetSubMaterial(0)
end
