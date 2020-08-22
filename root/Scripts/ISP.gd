extends Node


export(String) var ISP_name
export(Color) var primary_colour
export(Color) var secondary_colour

var shop_path = "res://Resources/Shop.tres"
export var modifiers = {"advertising":1.0, "cyber_attack_offense":1.0, "cyber_attack_defense":1.0, "brand_loyalty":1.0, "brand_image":1.0, "price":1.0}
export var money = 100000000000
var towns = []
var reserved_money = 0
export var money_round = 0.5
var connections = 0
export var is_player = false
	
func update_turn():
	money -= reserved_money
	reserved_money = 0
	for town in towns:
		money += town.get_ISP_town_info(self).get_income()

func spend_money(amount):
	if money - reserved_money >= amount:
		money -= amount
		return true
	return false
	
func increase_money(amount):
	money += amount

func force_reserve_money(amount):
	reserved_money += amount

func reserve_money(amount):
	if money - reserved_money >= amount:
		reserved_money += amount
		return true
	return false

func unreserve_money(amount):
	if reserved_money >= amount:
		reserved_money -= amount
		return true
	return false

func get_available_money():
	return money - reserved_money

func get_reserved_money():
	return reserved_money
	
func update_connections():
	for town in towns:
		connections += town.get_ISP_town_info(self).connections
	return connections

func add_town(town):
	if !towns.has(town):
		towns.append(town)
	
func change_price(town, amount):
	amount = stepify(amount, 0.5)
	return town.get_ISP_town_info(self).update_delta_price(amount)

func get_delta_price(town):
	return town.get_ISP_town_info(self).get_delta_price()

func get_price(town):
	return town.get_ISP_town_info(self).price
	
func get_tower(type):
	var shop = load(shop_path)
	if type == "3g":
		return shop.get_tower_3g()
	elif type == "4g":
		return shop.get_tower_4g()
	elif type == "5g":
		return shop.get_tower_5g()

func get_tower_price(type):
	return get_tower(type).price

func get_town_tower(town):
	return town.get_ISP_town_info(self).tower

func build_tower(town, type):
	var temp_tower = get_tower(type)
	town.build_tower(self, temp_tower)
	
func sell_tower(town):
	town.sell_tower(self)
	
func upgrade_tower(town, type):
	town.upgrade_tower(self, type)
	var tower = get_town_tower(town)
	
func get_tower_upgrade_level(town, type):
	var tower = get_town_tower(town)
	return tower.get_level(type)

func get_tower_max_upgrade_level(town):
	var tower = get_town_tower(town)
	return tower.max_level

func get_tower_upgrade_price(town, type):
	var shop = load(shop_path)
	var tower = get_town_tower(town)
	var tower_type = tower.tower_type
	if tower_type == "3g":
		return shop.get_tower_3g_upgrade_price(type, tower.get_level(type))
	elif tower_type == "4g":
		return shop.get_tower_4g_upgrade_price(type, tower.get_level(type))
	elif tower_type == "5g":
		return shop.get_tower_5g_upgrade_price(type, tower.get_level(type))

func get_advertising_price(town):
	var shop = load(shop_path)
	return shop.get_advertising_price(town.population)

func set_advertising(town, value):
	return town.get_ISP_town_info(self).update_advertising(value)

func get_advertising(town):
	return town.get_ISP_town_info(self).get_advertising()

func get_cyber_attack_price(town):
	var shop = load(shop_path)
	return shop.get_cyber_attack_price(town.population)

func do_cyber_attack(town, ISP):
	if !town.get_ISP_town_info(ISP):
		return false
	town.get_ISP_town_info(self).cyber_attack_target = ISP
	town.get_ISP_town_info(ISP).do_cyber_attack(modifiers["cyber_attack_offense"])
	return true

func cancel_cyber_attack(town, ISP):
	if !town.get_ISP_town_info(ISP):
		return false
	town.get_ISP_town_info(self).cyber_attack_target = null
	return town.get_ISP_town_info(ISP).cancel_cyber_attack()

func get_cyber_attack_target(town):
	return town.get_ISP_town_info(self).cyber_attack_target

func get_max_advertising(town):
	return town.get_ISP_town_info(self).max_advertising
	
func get_operation_cost(town):
	return town.get_ISP_town_info(self).tower.operation_cost

func get_total_operation_cost():
	var total = 0.0
	for town in towns:
		if get_town_tower(town):
			total += get_operation_cost(town)
	return total
