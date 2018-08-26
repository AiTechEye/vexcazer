minetest.register_craftitem("vexcazer:item", {
	description = "Item",
	stack_max=30000,
	inventory_image = "vexcazer_controler.png",
	groups = {not_in_creative_inventory=1}})

minetest.register_node("vexcazer:block", {
	description = "Block",
	tiles = {"default_cloud.png^[colorize:#19ffd6FF"},
	groups = {not_in_creative_inventory=1}})

minetest.register_craft({
	output = "vexcazer:mod",
	recipe = {{"vexcazer:mod"},},replacements = {{"vexcazer:mod", "vexcazer:controler"}}})

minetest.register_craft({
	output = "vexcazer:admin",
	recipe = {{"vexcazer:admin"},},replacements = {{"vexcazer:admin", "vexcazer:controler"}}})

minetest.register_craft({
	output = "vexcazer:world",
	recipe = {{"vexcazer:world"}},replacements = {{"vexcazer:world", "vexcazer:controler"}}})

minetest.register_craft({
	output = "vexcazer:world",
	recipe = {{"vexcazer:admin","vexcazer:controler"},},replacements = {{"vexcazer:world", "vexcazer:controler"}}})
