extends Node


export(String) var ISP_name
export(Color) var colour


var modifiers = {"advertising":1.0, "cyber_attack_offense":1.0, "cyber_attack_defense":1.0, "brand_loyalty":1.0, "brand_image":1.0, "price":1.0}
var money = 0
var towns = []
var connections = 0
var reserved_money = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

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

func get_tower():
	pass

func buy_tower(tower):
	pass
	
func upgrade_tower(town, type):
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
