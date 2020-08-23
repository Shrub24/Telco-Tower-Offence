extends "res://Scripts/ISP.gd"

func get_advertising_price(town, level):
	var shop = load(shop_path)
	if level <= get_max_advertising(town):
		return shop.get_advertising_price(town.population, level)/4
	return false
