extends Node
class_name Tower

export var speeds = [1, 2, 3, 4]
export var bandwidths = [10000, 100000, 1000000, 5000000]
export var ranges = [0, 1, 2, 3]
export var operation_cost = 100000
export var price = 1000
export var upgrade_cost = [100, 200, 400, 800]

var speed_level = 0
var bandwidth_level = 0
var range_level = 0
var max_level = 3


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func upgrade_tower(type):
	if type == "speeds":
		if speed_level < max_level:
			speed_level += 1
	elif type == "bandwidths":
		if bandwidth_level < max_level:
			bandwidth_level += 1
	elif type == "range":
		if range_level < max_level:
			range_level += 1

func get_range():
	return ranges[range_level]
		
func get_bandwidth():
	return bandwidths[bandwidth_level]
	
func get_speed():
	return speeds[speed_level]

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
