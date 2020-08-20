extends Node

# scale greedy factor by size of ISP 
export (float) var greedy_factor = 0.0
onready var ISP = $"ISP"
onready var shop = load("res://Resources//Shop.tres")

const max_price_change = 3
const jerk_factor = 3

const advertising_offset = 1000
const advertising_proportion = 4
const advertising_share_proportion = 30

# scale saftey range buy current $$
const saftey_range = 500

const bandwidth_cutoff = 0.8

var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	#move to init if doesn't work
	rng.randomize()

func update_choices():
	var money = ISP.get_avaliable_money()
	var revenue = 0
	var operational_costs = 0
	# scales with current money
	
	# get revenue and operational costs
	for town in ISP.towns:
		var town_info = town.ISPs[ISP]
		revenue += town_info.connections * town_info.price
		operational_costs += town_info.costs
		
	var action_budget = get_action_budget(money, revenue - operational_costs)
		
	do_actions(action_budget)
		
	set_town_prices(action_budget, revenue, operational_costs)

func set_town_prices(action_budget, revenue, operational_costs):
	var price_changes = {}
	var town_inc = 0
	for town in ISP.towns:
		var town_info = town.ISPs[ISP]
		price_changes[town] = get_price_change(float(town_info.delta_connections)/town.population)
	
	var deficit = (revenue - operational_costs - action_budget - saftey_range) * -1
	if deficit > 0:
		# check is float
		town_inc = float(deficit)/len(ISP.towns)
	
	for town in price_changes.keys():
		change_prices(town, price_changes[town] + town_inc)

func do_actions(action_budget):
	# pass by ref?
	
	var delta_conns = []
	#sort by lowest delta_connections
	for town in ISP.towns:
		#refactor to use getter
		var town_info = town.ISPs[ISP]
		delta_conns.append([town_info.delta_connections, town])
		
	delta_conns.sort_custom(self, "first_element_sorter")
		
	for town_deltas in delta_conns:
		var town = town_deltas[1]
		var town_info = town.ISPs[ISP]
		# todo use town get share isp function
		var share = float(town_info.connections)/town.population
		
		# todo check current adverising
		# decisions of actions
		if share <= advertising_share_proportion:
			var ad_money = do_advertising(action_budget, town)
			if ad_money:
				action_budget -= ad_money
			else:
				break
		else:
			var upgrade_money = do_tower_upgrade(action_budget, town)
			if upgrade_money:
				action_budget -= upgrade_money
			elif len(town.get_ISP_shares().values()) > 1:
				var cyber_money = do_cybersecurity_attack(action_budget, town)
				if cyber_money:
					action_budget -= cyber_money
				else:
					break
			#isptowninfo get bandwidth used

# kinda random xD
func do_advertising(action_budget, town):
	var price = ISP.get_advertising_price(town)
	var max_num = floor(action_budget/price)
	var amt = min(max_num, rng.randi_range(1, 5))
	if amt > 0:
		set_advertising(town, amt, amt * price)
		return amt * price
	else:
		return false

func do_tower_upgrade(action_budget, town):
	var bandwidth_used = town.ISPs[ISP].get_bandwidth_used
	var max_level = ISP.get_tower_max_upgrade_levels(town)
	var bandwidth_level = ISP.tower_upgrade_level(town, "bandwidth")
	var speed_level = ISP.tower_upgrade_level(town, "speed")
	var price
	var upgrade
	if bandwidth_used >= bandwidth_cutoff and bandwidth_level < max_level:
		price = ISP.get_tower_upgrade_price(town, "bandwidth", bandwidth_level + 1)
		upgrade = "bandwidth"
	elif speed_level < max_level:
		price = ISP.get_tower_upgrade_price(town, "speed", speed_level + 1)
		upgrade = "speed"
	else:
		return false
	
	if price <= action_budget:
		upgrade_tower(town, upgrade, price)
	else:
		return false
		
func do_cybersecurity_attack(action_budget, town):
	var price = ISP.get_cyber_attack_price(town)
	if price <= action_budget:
		var shares = town.get_ISP_shares()
		if shares.has(town):
			shares.erase(town)
		do_cyber_attack(town, get_max_key(shares), price)
			
	else:
		return false
		
func first_element_sorter(a, b):
	return a[0] < b[0]

func upgrade_tower(town, type, price):
	if ISP.spend_money(price):
		ISP.upgrade_tower(town, type)

func set_advertising(town, val, price):
	if ISP.spend_money(price):
		ISP.set_advertising(town, val)

func do_cyber_attack(town, target, price):
	if ISP.spend_money(price):
		ISP.do_cyber_attack(town, target)

func change_prices(town, val):
	ISP.change_price(town, val)

# town affluency?
func get_price_change(connection_change):
	return clamp(max_price_change * tanh(connection_change/jerk_factor) + greedy_factor, -1 * max_price_change, max_price_change)

func get_action_budget(money, profit):
	var x = float(money + profit) 
	return ((x-advertising_offset)/advertising_proportion)

func get_max_key(dict):
	var max_key
	var max_val = null
	for key in dict.keys():
		if max_val == null or dict[key] > max_val:
			max_key = key
			max_val = dict[key]
	return max_key
