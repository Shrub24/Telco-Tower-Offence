extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var min_price = 1
export var max_price = 250
var delta_connections = 0
var connections = 0
var brand_loyalty = 0.0
var brand_image = 0.0
var tower
var aoe_neighbouring_towers = {}
var price = 0.0
var delta_price = 0.0
export(float) var base_advertising_mod
var advertising = 0.0
export(float) var base_cyber_attack_mod
var cyber_attack_mod = 0.0
var cyber_attack = 0.0
var max_advertising = 5
var max_cyber_attack = 1
var ISP
var costs = 0
var shop
export var loyalty_scale_factor = 1
export var tower_max_speed = 5000
var town_population = 0
var cyber_attack_target

func _ready():
	shop = load("res://Resources//Shop.tres")

func initialise(new_ISP, town):
	ISP = new_ISP
	ISP.add_town(town)
	

func generate_starter(population):
	town_population = population
	connections = town_population
	
	tower = shop.get_tower_3g()
	price = min_price * 5
	
	update_brand_image()
	update_brand_loyalty()
	
	
func generate(share, population, affluency):
	town_population = population
	connections = int(share * town_population/100)

	tower = calculate_starting_tower(affluency)
	
	update_brand_image()
	update_brand_loyalty()
	price = affluency * share/100 * brand_loyalty
	
	
func get_bandwidth_used():
	return float(connections)/tower.get_bandwidth()
	
func calculate_affluency_decay(affluency):
	#todo
	pass
	
func get_connections_delta(ISPTownInfos):
	for other in ISPTownInfos:
		var considering_switch = int(brand_image * (1 - other.brand_loyalty) * other.connections *  1/(1 + exp(-2 * ((other.price/price) - 1.25))))
		other.delta_connections -= considering_switch

func calculate_aoe_image():
	var aoe_image = 0
	for aoe_image_val in aoe_neighbouring_towers.values():
		aoe_image += aoe_image_val
	return aoe_image

func update_brand_image():
	var share = float(connections)/town_population
	var aoe_image = calculate_aoe_image()
	brand_image = float(share)/100 + ((1 - float(share)/100) * get_advertising_mod()) * cyber_attack_mod + aoe_image
	brand_image = clamp(brand_image, 0.0, 1.0)

func update_brand_loyalty():
	var bandwidth_used = get_bandwidth_used()
	brand_loyalty = loyalty_scale_factor * ISP.modifiers["brand_loyalty"] * (float(tower.get_speed())/tower_max_speed) * 1/(1 + exp(6 * (2 * bandwidth_used - 1.9)))
	brand_loyalty = clamp(brand_loyalty, 0.0, 1.0)
	
func get_income():
	return connections * price

func update_turn():
	update_brand_image()
	update_brand_loyalty()
	connections += delta_connections
	price += delta_price

func calculate_starting_tower(affluency):
	if connections > 1000000 and affluency > 75:
		tower = shop.get_tower_5g()
	elif connections > 75000 or affluency > 40:
		tower = shop.get_tower_4g()
	else:
		tower = shop.get_tower_3g()

func calculate_costs():
	costs = tower.operation_costs

func get_advertising_mod():
	return (base_advertising_mod * ISP.modifiers["advertising"]) * advertising

func get_advertising():
	return advertising

func update_advertising(amount):
	advertising = amount
	return [advertising, get_advertising_mod() * 100]

func get_cyber_attack_mod(mod):
	return base_cyber_attack_mod * mod * ISP.modifiers["cyber_attack_defense"]

func do_cyber_attack(mod):
	if get_cyber_attack_mod(mod) > cyber_attack_mod:
		cyber_attack_mod = get_cyber_attack_mod(mod)
		return true
	return false

func get_cyber_attack():
	return cyber_attack_target

	
func cancel_cyber_attack():
	if cyber_attack != 0:
		cyber_attack = 0
		return true
	return false

func update_delta_price(amount):
	delta_price += amount
	delta_price = clamp(delta_price, min_price - price, max_price - price)
	return delta_price

func upgrade_tower():
	pass

func build_tower(new_tower):
	tower = new_tower

func update():
	pass
# Called when the node enters the scene tree for the first time.
	
# add neighbouring towers and aoe to aoe_neighbouring_towers
func update_aoe_image(aoe_tower, aoe_image):
	if aoe_tower != tower:
		if !aoe_neighbouring_towers.has(aoe_tower) or aoe_image > aoe_neighbouring_towers[aoe_tower]:
			aoe_neighbouring_towers[aoe_tower] = aoe_image
	
func remove_aoe_image(aoe_tower):
	if aoe_neighbouring_towers.has(aoe_tower):
		aoe_neighbouring_towers.erase(aoe_tower)

# todo affluency?

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
