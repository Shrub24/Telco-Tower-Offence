extends Resource
export(PackedScene) var tower_3g
export(PackedScene) var tower_4g
export(PackedScene) var tower_5g
var advertising_cost = 10
var cyber_attack_cost = 20
var tower_3g_upgrade_costs = {"speed":[25000, 50000, 100000, 200000], "bandwidth":[25000, 50000, 100000, 200000], "reach":[25000, 50000, 100000, 200000]}
var tower_4g_upgrade_costs = {"speed":[100000, 200000, 400000, 600000], "bandwidth":[100000, 200000, 400000, 600000], "reach":[100000, 200000, 400000, 600000]}
var tower_5g_upgrade_costs = {"speed":[300000, 500000, 700000, 900000], "bandwidth":[300000, 500000, 700000, 900000], "reach":[300000, 500000, 700000, 900000]}

func get_tower_3g():
	return tower_3g.instance()
	
func get_tower_4g():
	return tower_4g.instance()
	
func get_tower_5g():
	return tower_5g.instance()

func get_advertising_price(population):
	return advertising_cost * population

func get_cyber_attack_price(population):
	return cyber_attack_cost * population

func get_tower_3g_upgrade_price(type, level):
	return tower_3g_upgrade_costs[type][level-1]

func get_tower_4g_upgrade_price(type, level):
	return tower_4g_upgrade_costs[type][level-1]

func get_tower_5g_upgrade_price(type, level):
	return tower_5g_upgrade_costs[type][level-1]

