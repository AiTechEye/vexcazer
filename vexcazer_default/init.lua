--Enable this mod to enable the default / for players


vexcazer.enable_default=true
minetest.override_item("vexcazer:default",{groups = {not_in_creative_inventory=0}})

minetest.register_craft({
	output = "vexcazer:default",
	recipe = {{"vexcazer:default","default:mese_crystal"}}})

minetest.register_craft({
	output = "vexcazer:default",
	recipe = {
		{"default:meselamp","default:diamondblock","default:steelblock"},
		{"","default:mese_crystal_fragment","default:obsidian_shard"}}})

minetest.register_craft({
	output = "vexcazer:controler",
	recipe = {
	{"default:diamond","default:mese_crystal"},
}})