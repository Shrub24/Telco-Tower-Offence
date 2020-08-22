extends Node
class_name Tower

export var speeds = [1, 2, 3, 4]
export var bandwidths = [10000, 100000, 1000000, 5000000]
export var reach = [0, 1, 2, 3]
export var operation_cost = 100000.0
export var price = 1000
export var upgrade_cost = [100, 200, 400, 800]
export var tower_type = "3g"
export var sell_factor = 0.3

var speed_level = 0
var bandwidth_level = 0
var reach_level = 0
var max_level = 3


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func upgrade_tower(type):
	if type == "speed":
		if speed_level < max_level:
			speed_level += 1
	elif type == "bandwidth":
		if bandwidth_level < max_level:
			bandwidth_level += 1
	elif type == "reach":
		if reach_level < max_level:
			reach_level += 1

func get_reach():
	return reach[reach_level]
		
func get_bandwidth():
	return bandwidths[bandwidth_level]
	
func get_speed():
	return speeds[speed_level]

func get_next_bandwidth():
	if bandwidth_level < max_level:
		return bandwidths[bandwidth_level + 1]
	return false

func get_next_speed():
	if speed_level < max_level:
		return speeds[speed_level + 1]
	return false

func get_next_reach():
	if reach_level < max_level:
		return reach[reach_level + 1]
	return false

func get_upgrade_price(type):
	if type == "speed":
		return upgrade_cost[speed_level + 1]
	elif type == "bandwidth":
		return upgrade_cost[bandwidth_level + 1]
	elif type == "reach":
		return upgrade_cost[reach_level + 1]
	

func get_level(type):
	if type == "speed":
		return speed_level
	elif type == "bandwidth":
		return bandwidth_level
	elif type == "reach":
		return reach_level

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
