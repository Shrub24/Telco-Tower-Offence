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

func init_ISP(start_ISP):
	ISP = start_ISP

# todo connect signals to functions
func _on_TowerBuyButton_buy_tower(town, tower_type):
	ISP.buy_tower(town, tower_type)
	
func _on_TowerUpgradeButton_upgrade_tower(town, type):
	ISP.upgrade_tower(town, type)

func _on_AdvertisingButtonUp_buy_advertising(town):
	ISP.buy_advertising(town, 1)

func _on_AdvertisingButtonDown_buy_advertising(town):
	ISP.buy_advertising(town, -1)
	
func _on_CyberAttackButtonUp_buy_cyber_attack(town):
	ISP.buy_cyber_attack(town, 1)

func _on_CyberAttackButtonDown_buy_cyber_attack(town):
	ISP.buy_cyber_attack(town, -1)
	
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
