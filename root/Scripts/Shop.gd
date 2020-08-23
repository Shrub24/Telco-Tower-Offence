extends Resource
export(PackedScene) var tower_3g
export(PackedScene) var tower_4g
export(PackedScene) var tower_5g
var advertising_cost = [5, 10, 20, 40, 80]
var cyber_attack_cost = 20
var tower_3g_upgrade_costs = {"speed":[30000, 55000, 75000, 100000], "bandwidth":[30000, 55000, 75000, 100000], "reach":[30000, 55000, 75000, 100000]}
var tower_4g_upgrade_costs = {"speed":[150000, 450000, 600000, 1000000], "bandwidth":[150000, 450000, 600000, 1000000], "reach":[150000, 450000, 600000, 1000000]}
var tower_5g_upgrade_costs = {"speed":[1500000, 3500000, 5500000, 7500000], "bandwidth":[1500000, 3500000, 5500000, 7500000], "reach":[1500000, 3500000, 5500000, 7500000]}

func get_tower_3g():
	return tower_3g.instance()
	
func get_tower_4g():
	return tower_4g.instance()
	
func get_tower_5g():
	return tower_5g.instance()

func get_advertising_price(population, level):
	return advertising_cost[level-1] * population

func get_cyber_attack_price(population):
	return cyber_attack_cost * population

func get_tower_3g_upgrade_price(type, level):
	return tower_3g_upgrade_costs[type][level-1]

func get_tower_4g_upgrade_price(type, level):
	return tower_4g_upgrade_costs[type][level-1]

func get_tower_5g_upgrade_price(type, level):
	return tower_5g_upgrade_costs[type][level-1]

