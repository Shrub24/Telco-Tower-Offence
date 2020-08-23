extends "res://Scripts/ISP.gd"

func get_advertising_price(town):
	var shop = load(shop_path)
	return shop.get_advertising_price(town.population)/4
