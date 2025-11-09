
print("made by @kylosilly to lazy to add knife/glove support")
local replicated_storage = game:GetService("ReplicatedStorage")
local local_player = game:GetService("Players").LocalPlayer

local ct_folder = local_player.SkinFolder.CTFolder
local t_folder = local_player.SkinFolder.TFolder
local skins = replicated_storage.Skins -- skins are stored here obv check with matcha dex

local ct_gun_skins = {
    ["M249"] = "Stock",
    ["UMP"] = "Stock",
    ["P2000"] = "Stock",
    ["R8"] = "Stock",
    ["FiveSeven"] = "Stock",
    ["DesertEagle"] = "Heat",
    ["XM"] = "Stock",
    ["Bizon"] = "Stock",
    ["USP"] = "Stock",
    ["MP7"] = "Stock",
    ["AUG"] = "Stock",
    ["P250"] = "Stock",
    ["AWP"] = "Stock",
    ["DualBerettas"] = "Stock",
    ["M4A1"] = "Stock",
    ["CZ"] = "Stock",
    ["G3SG1"] = "Stock",
    ["M4A4"] = "Stock",
    ["MP9"] = "Stock",
    ["P90"] = "Stock",
    ["Famas"] = "Stock",
    ["Scout"] = "Stock",
    ["MAG7"] = "Stock",
    ["MP7-SD"] = "Stock",
    ["Negev"] = "Stock",
    ["Nova"] = "Stock"
}

local t_gun_skins = {
    ["M249"] = "Stock",
    ["UMP"] = "Stock",
    ["R8"] = "Stock",
    ["Tec9"] = "Stock",
    ["SawedOff"] = "Stock",
    ["SG"] = "Stock",
    ["DesertEagle"] = "Heat",
    ["XM"] = "Stock",
    ["Bizon"] = "Stock",
    ["MAC10"] = "Stock",
    ["Glock"] = "Stock",
    ["MP7"] = "Stock",
    ["AK47"] = "Stock",
    ["Galil"] = "Stock",
    ["MP7-SD"] = "Stock",
    ["CZ"] = "Stock",
    ["P90"] = "Stock",
    ["AWP"] = "Stock",
    ["DualBerettas"] = "Stock",
    ["G3SG1"] = "Stock",
    ["Scout"] = "Stock",
    ["P250"] = "Stock",
    ["Nova"] = "Stock",
    ["Negev"] = "Stock"
}

function skin_exist(gun_name, skin_name)
    return skins:FindFirstChild(gun_name):FindFirstChild(skin_name)
end

for i, v in pairs(ct_gun_skins) do
    if (v == "Stock") then
        continue
    end
    if (skin_exist(i, v)) then
        ct_folder[i].Value = v
    end
end

for i, v in pairs(t_gun_skins) do
    if (v == "Stock") then
        continue
    end
    if (skin_exist(i, v)) then
        t_folder[i].Value = v
    end
end
