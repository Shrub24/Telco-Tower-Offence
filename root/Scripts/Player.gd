extends Node

signal tech_learnt(tech)

const tech_tree_prereq = {"advertising_double": []}
#modifiers["advertising"]
const tech_tree_effect = {"advertising_double": ["advertising", "*", 2]}

var ISP
var tech_tree_learnt = {"advertising_double": false}
var techs_remaining = 3

signal query_sell_tower(tower_type)
signal query_change_tower(tower_type)
signal ui_update_tower(tower_type)
signal not_enough_money
signal at_max_level
signal at_min_level
signal ui_update_advertising(value)
signal ui_update_cyber_attack
signal ui_update_delta_price(price)


# todo connect signals to functions
#todo emit signals

func buy_tower(town, tower_type):
	if ISP.get_town_tower(town):
		if ISP.get_town_tower(town).tower_type == "tower_type":
			emit_signal("query_sell_tower", tower_type)
		else:
			emit_signal("query_change_tower", tower_type)
	else:
		var price = ISP.get_tower_price(tower_type)
		if ISP.spend_money(price):
			ISP.build_tower(town, tower_type)
			emit_signal("ui_update_tower", tower_type)
		else:
			emit_signal("not_enough_money")

func sell_tower(town, tower_type):	
	var price = ISP.get_tower_price(tower_type)
	

func upgrade_tower(town, type):
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


func buy_advertising(town):
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

func sell_advertising(town):
	var min_advertising = 0
	var advertising = ISP.get_advertising(town)
	if advertising > min_advertising:
		var price = ISP.get_advertising_price(town)
		if ISP.unreserve_money(price):
			ISP.set_advertising(town, advertising - 1)
			emit_signal("ui_update_advertising", advertising - 1)
	else:
		emit_signal("at_min_level")

func cyber_attack_target(town, target):
	var prev_target = ISP.get_cyber_attack_target(town)
	var price = ISP.get_cyber_attack_price(town)
	if !prev_target:
		if ISP.reserve_money(price):
			if ISP.do_cyber_attack(town, target):
				emit_signal("ui_update_cyber_attack", target, true)
	else:
		ISP.cancel_cyber_attack(town, prev_target)
		emit_signal("ui_update_cyber_attack", prev_target, false)
		if prev_target == target:
			ISP.unreserve_money(price)
		else:
			ISP.do_cyber_attack(town, target)
			emit_signal("ui_update_cyber_attack", target, true)

func price_up(town):
	ISP.change_price(town, 0.5)
	emit_signal("ui_update_delta_price", ISP.get_delta_price(town))

func price_down(town):
	ISP.change_price(town, -0.5)
	emit_signal("ui_update_delta_price", ISP.get_delta_price(town))

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

func update_turn():
	var cost = ISP.get_total_operation_cost()
	ISP.force_reserve_money(cost)
	emit_signal("update_money", ISP.money, ISP.get_reserved_money())
	emit_signal("update_connections", ISP.update_connections())
