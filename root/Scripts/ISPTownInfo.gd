extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var connections = 0
var brand_loyalty = 0.0
var brand_image = 0.0
var tower
var neighbouring_towers = []
var price = 0.0
export(float) var base_advertising_mod
var advertising = 1
export(float) var base_cyber_attack_mod
var cyber_attack = 1
var ISP
var costs = 0


func calculate_costs():
	costs = advertising
	
func get_advertising_mod():
	return (base_advertising_mod * ISP.modifiers["advertising"]) ^ advertising

func update_advertising(amount):
	advertising += amount
	return [advertising, (get_advertising_mod() - 1) * 100]

func get_cyber_attack_mod(mod):
	return (base_cyber_attack_mod * mod * ISP.modifiers["cyber_attack_defense"]) ^ cyber_attack

func update_cyber_attack(amount, mod):
	cyber_attack += amount
	return [cyber_attack, (get_cyber_attack_mod(mod) - 1) * 100]

func upgrade_tower():
	pass
	
func build_tower():
	pass

func update():
	pass
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
