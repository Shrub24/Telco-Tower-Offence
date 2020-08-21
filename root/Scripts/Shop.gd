extends Resource
export(PackedScene) var tower_3g
export(PackedScene) var tower_4g
export(PackedScene) var tower_5g
export var advertising_cost = 1
export var cyber_attack_cost = 15
export var tower_3g_upgrade_costs = {"speed":[1000, 2000, 3000, 4000], "bandwidth":[10000, 20000, 30000, 40000], "reach":[100000, 200000, 300000, 400000]}
export var tower_4g_upgrade_costs = {"speed":[10000, 20000, 30000, 40000], "bandwidth":[10000, 20000, 30000, 40000], "reach":[10000, 20000, 30000, 40000]}
export var tower_5g_upgrade_costs = {"speed":[100000, 200000, 300000, 400000], "bandwidth":[100000, 200000, 300000, 400000], "reach":[100000, 200000, 300000, 400000]}

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

