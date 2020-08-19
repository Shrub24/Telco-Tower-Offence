extends Node

signal tech_learnt(tech)

const tech_tree_prereq = {"advertising_double": []}
#modifiers["advertising"]
const tech_tree_effect = {"advertising_double": ["advertising", "*", 2]}

var ISP
var tech_tree_learnt = {"advertising_double": false}
var techs_remaining = 3

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# todo connect signals to functions
#todo emit signals
func _on_TowerBuyButton_buy_tower(town, tower_type):
	if ISP.get_town_tower(town).tower:
		if ISP.get_town_tower(town).tower.tower_type == "tower_type":
			emit_signal("query_sell_tower")
		else:
			emit_signal("query_change_tower")
	else:
		var price = ISP.get_tower_price(tower_type)
		if ISP.spend_money(price):
			ISP.build_tower(town, tower_type)
			emit_signal("ui_update_tower", town)
		else:
			emit_signal("not_enough_money")

	
func _on_TowerUpgradeButton_upgrade_tower(town, type):
	var curr_level = ISP.get_tower_upgrade_level(town, type)
	var max_level = ISP.get_tower_max_upgrade_level(town)

	if curr_level < max_level:
		var price = ISP.get_tower_upgrade_price(town, type)
		if ISP.spend_money(price):
			ISP.upgrade_tower(town, type)
			emit_signal("ui_update_tower", town)
		else:
			emit_signal("not_enough_money")
	else:
			emit_signal("at_max_level")


func _on_AdvertisingButtonUp_buy_advertising(town):
	var max_advertising = ISP.get_max_advertising(town)
	var advertising = ISP.get_advertising(town)
	if advertising < max_advertising:
		var price = ISP.get_advertising_price(town)
		if ISP.reserve_money(price):
			ISP.set_advertising(town, advertising + 1)
			emit_signal("ui_update_advertising", advertising + 1)
		else:
			emit_signal("not_enough_money")
	else:
		emit_signal("at_max_level")

func _on_AdvertisingButtonDown_buy_advertising(town):
	var min_advertising = 0
	var advertising = ISP.get_advertising(town)
	if advertising > min_advertising:
		var price = ISP.get_advertising_price(town)
		if ISP.unreserve_money(price):
			ISP.set_advertising(town, advertising - 1)
			emit_signal("ui_update_advertising", advertising - 1)
	else:
		emit_signal("at_min_level")

func _on_CyberAttack_target(town, target):
	var prev_target = ISP.get_cyber_attack_target(town)
	var price = ISP.get_cyber_attack_price(town)
	if !prev_target:
		if ISP.reserve_money(price):
			ISP.do_cyber_attack(town, target)
			emit_signal("ui_target_cyber_attack", target)
	else:
		ISP.cancel_cyber_attack(town, prev_target)
		emit_signal("ui_untarget_cyber_attack", prev_target)
		if prev_target == target:
			ISP.unreserve_money(price)
		else:
			ISP.do_cyber_attack(town, target)
			emit_signal("ui_target_cyber_attack", target)


# redo based on price ui
func _on_PriceButtonUp_change_price(town):
	ISP.change_price(town, 0.5)

func _on_PriceButtonDown_change_price(town):
	ISP.change_price(town, -0.5)

func _on_TechTreeButton_new_tech(tech):
	if techs_remaining > 0 and learn_tech(tech):
		techs_remaining -= 1
		emit_signal("tech_learnt", tech)		
	
func apply_tech_tree(effect):
	var effect_param = tech_tree_effect["effect"]
	if effect_param[1] == "*":
		ISP.modifiers[effect_param[0]] *= effect_param[3]
	elif effect_param[1] == "+":
		ISP.modifiers[effect_param[0]] += effect_param[3]

func learn_tech(effect):
	for prereq in tech_tree_prereq[effect]:
		if !tech_tree_learnt[prereq]:
			return false
	tech_tree_learnt[effect] = true
	apply_tech_tree(effect)
	return true
