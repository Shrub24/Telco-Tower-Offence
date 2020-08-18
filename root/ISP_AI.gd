extends Node

export (PackedScene) var ISP_scene
var ISP

# Called when the node enters the scene tree for the first time.
func _ready():
	#move to init if doesn't work
	ISP = ISP_scene.init()

func update_choices():
	var money_remaining = ISP.money
	var town_info = {}
	for town in ISP.towns:
		

func upgrade_tower(town, type):
	ISP.upgrade_tower(town, type)

func buy_advertising(town, val):
	ISP.buy_advertising(town, val)

func buy_cyber_attack(town, val):
	ISP.buy_cyber_attack(town, val)

func change_prices(town, val):
	ISP.change_price(town, val)
