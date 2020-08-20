extends Node


export(String) var ISP_name
export(Color) var colour

onready var shop = load("res://Resources//Shop.tres")
export var modifiers = {"advertising":1.0, "cyber_attack_offense":1.0, "cyber_attack_defense":1.0, "brand_loyalty":1.0, "brand_image":1.0, "price":1.0}
export var money = 0
var towns = []
var reserved_money = 0
export var money_round = 0.5
var connections = 0
	
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
	
func get_price(town):
	return town.get_ISP_town_info(self).get_delta_price()
	
func get_tower(type):
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

func upgrade_tower(town, type):
	town.upgrade_tower(self, town, type)

func get_tower_upgrade_level(town, type):
	var tower = get_town_tower(town)
	if type == "speed":
		return tower.speed_level
	elif type == "bandwidth":
		return tower.bandwidth_level
	elif type == "reach":
		return tower.reach_level

func get_tower_max_upgrade_level(town):
	var tower = get_town_tower(town)
	return tower.max_level

func get_tower_upgrade_price(town, type, level):
	var tower = get_town_tower(town)
	var tower_type = tower.tower_type
	if type == "3g":
		return shop.get_tower_3g_upgrade_price(type, level)
	elif type == "4g":
		return shop.get_tower_4g_upgrade_price(type, level)
	elif type == "5g":
		return shop.get_tower_5g_upgrade_price(type, level)

func get_advertising_price(town):
	return shop.get_advertising_price(town.population)

func set_advertising(town, value):
	return town.get_ISP_town_info(self).update_advertising(value)

func get_advertising(town):
	return town.get_ISP_town_info(self).advertising

func get_cyber_attack_price(town):
	return shop.get_cyber_attack_price(town.population)

func do_cyber_attack(town, ISP):
	town.get_ISP_town_info(self).cyber_attack_target = ISP
	return town.get_ISP_town_info(ISP).do_cyber_attack(modifiers["cyber_attack_offense"])

func cancel_cyber_attack(town, ISP):
	return town.get_ISP_town_info(ISP).cancel_cyber_attack()

func get_cyber_attack_target(town):
	return town.get_ISP_town_info(self).get_cyber_attack_target()

func get_max_advertising(town):
	return town.get_ISP_town_info(self).advertising_max
	
func get_operation_cost(town):
	town.get_ISP_town_info(self).tower.operation_cost

func get_total_operation_cost():
	for town in towns:
		get_operation_cost(town)
