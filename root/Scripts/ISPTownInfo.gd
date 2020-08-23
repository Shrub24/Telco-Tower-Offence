extends Node

var connections_delta = 0
export var min_price = 1
export var max_price = 100
var connections = 0
var brand_loyalty = 0.0
var brand_image = 0.0
var tower
var aoe_neighbouring_towers = {}
var price = 5.0
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
var connection_loss = {}

const min_affluency = 1
const max_affluency = 99
var max_affluency_pricing = max_price
var min_affluency_pricing = min_price + 5
const affluency_dampening_factor = 40

export var base_starting_price = -15
export var max_share_factor = 12

var prev_connections_delta = 0
var prev_affluency_delta = 0

var rng = RandomNumberGenerator.new()

func _ready():
	shop = load("res://Resources/Shop.tres")
	rng.randomize()

func initialise(new_ISP, town, population):
	ISP = new_ISP
	ISP.add_town(town)
	town_population = population

func generate_starter(no_ISP_pop):
	shop = load("res://Resources/Shop.tres")
	connections = town_population - no_ISP_pop
	build_tower(shop.get_tower_3g())
	price = min_price * 5


func generate(share, no_ISP_pop, affluency):
	connections = int(share * (town_population - no_ISP_pop)/100)
	
	build_tower(calculate_starting_tower(affluency))
	
	# initial price for ISPs
	var affluency_pricing = (float(affluency-min_affluency)/(max_affluency-min_affluency))*(max_price-min_price) + min_price
	price = base_starting_price + affluency_pricing + (rng.randf_range(0, max_share_factor) * share/100)
	price = stepify(clamp(price, min_price, max_price), 0.5)

func get_bandwidth_used():
	return float(connections)/tower.get_bandwidth()
	
func get_connections_loss(ISPTownInfos):
	for other in ISPTownInfos:
		var considering_switch = brand_image * (1 - other.brand_loyalty) *  1/(1 + exp(-2 * ((other.price/price) - 1.25)))
		other.connection_loss[self] = considering_switch

func get_affluency_delta(affluency):
	var affluency_pricing = (float(affluency-min_affluency)/(max_affluency-min_affluency)) * (max_price - min_price) + min_price
	var x = affluency_pricing/price
	return affluency_dampening_factor * tanh(x-1)

func calculate_aoe_image():
	var aoe_image = 0
	for aoe_image_val in aoe_neighbouring_towers.values():
		aoe_image += aoe_image_val
	return aoe_image

func update_brand_image():
	var share = float(connections)/town_population
	var aoe_image = calculate_aoe_image()
	brand_image = float(share) + ((1 - float(share)/100) * get_advertising_mod()) * cyber_attack_mod + aoe_image
	brand_image = clamp(brand_image, 0.0, 1.0)

func update_brand_loyalty(max_speed):
	var bandwidth_used = get_bandwidth_used()
	brand_loyalty = loyalty_scale_factor * ISP.modifiers["brand_loyalty"] * (float(tower.get_speed())/max_speed) * 1/(1 + exp(6 * (2 * bandwidth_used - 1.9)))
	brand_loyalty = clamp(brand_loyalty, 0.0, 1.0)
 
func get_income():
	return connections * price

func get_connections_delta():
	normalise_connection_loss()
	update_connection_deltas()
	
func normalise_connection_loss():
	var loss_sum = 0.0
	for loss in connection_loss.values():
		 loss_sum += loss
	for ISP in connection_loss.keys():
		if loss_sum > 1:
			connection_loss[ISP] /= loss_sum

func update_turn(max_speed):
	if tower:
		update_brand_loyalty(max_speed)
		update_connections()
		price += delta_price
		delta_price = 0
	update_brand_image()
	cancel_all_cyber_attacks()
	update_advertising(0)


func calculate_starting_tower(affluency):
	shop = preload("res://Resources/Shop.tres")
	if connections > 150000 and affluency > 75:
		return shop.get_tower_5g()
	elif connections > 75000 or affluency > 40:
		return shop.get_tower_4g()
	else:
		return shop.get_tower_3g()

func cancel_all_cyber_attacks():
	if cyber_attack_target:
		cyber_attack_target = null
	cyber_attack = 0
	cyber_attack_mod = 0

func update_price(amount):
	price += amount

func update_connections():
	connections += connections_delta
	
	prev_connections_delta = connections_delta
	
	connections_delta = 0

func update_connection_deltas():
	for ISP in connection_loss.keys():
		ISP.connections_delta += int(connections * connection_loss[ISP])
		connections_delta -= int(connections * connection_loss[ISP])

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
		cyber_attack += 1

func get_cyber_attack():
	return cyber_attack_target

func cancel_cyber_attack():
	if cyber_attack != 0:
		cyber_attack -= 1
		return true
	return false

func update_delta_price(amount):
	delta_price += amount
	delta_price = clamp(delta_price, min_price - price, max_price - price)
	return delta_price

func upgrade_tower(type):
	tower.upgrade_tower(type)

func build_tower(new_tower):
	tower = new_tower
	
func remove_tower():
	tower = null

func get_delta_price():
	return delta_price
	
# add neighbouring towers and aoe to aoe_neighbouring_towers
func update_aoe_image(aoe_tower, aoe_image):
	if aoe_tower != tower:
		if !aoe_neighbouring_towers.has(aoe_tower) or aoe_image > aoe_neighbouring_towers[aoe_tower]:
			aoe_neighbouring_towers[aoe_tower] = aoe_image
	
func remove_aoe_image(aoe_tower):
	if aoe_neighbouring_towers.has(aoe_tower):
		aoe_neighbouring_towers.erase(aoe_tower)

func update_affluency_conns(affluency_delta):
	if affluency_delta >= 0:
		connections += affluency_delta
		
		prev_affluency_delta = affluency_delta
		return affluency_delta
	else:
		var delta = int(affluency_delta/100 * connections)
		connections += delta
		
		prev_affluency_delta = delta
		return delta
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
