extends Node


export(String) var ISP_name
export(Color) var colour

var shop
export var modifiers = {"advertising":1.0, "cyber_attack_offense":1.0, "cyber_attack_defense":1.0, "brand_loyalty":1.0, "brand_image":1.0, "price":1.0}
export var money = 0
var towns = []
var connections = 0
var reserved_money = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$"../GameController".connect("turn_update", self, "turn_update")
	shop = load("res://Resources//Shop.tres")
	
func turn_update():
	pass

func spend_money(amount):
	if money - reserved_money >= amount:
		money -= amount
		return true
	return false

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

func add_town(town):
	if !towns.has(town):
		towns.append(town)
	
func change_price(town, amount):
	return town.ISPs[self].update_delta_price(amount)
	
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
	town.get_ISP_town_info(self).tower = temp_tower
	
func upgrade_tower(town, type):
	var tower = get_town_tower(town)
	tower.upgrade_tower(type)
	
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
	return town.get_ISP_town_info(ISP).do_cyber_attack(modifiers["cyber_attack_offense"])

func cancel_cyber_attack(town, ISP):
	return town.get_ISP_town_info(ISP).cancel_cyber_attack()

func get_cyber_attack(town, ISP):
	return town.get_ISP_town_info(ISP).get_cyber_attack_mod(modifiers["cyber_attack_offense"])




# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
