extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var connections = 0
var brand_loyalty = 0.0
var brand_image = 0.0
var tower
var tower_built = false
var price = 0.0
export(float) var base_advertising_mod
var advertising_mod = 1.0
export(float) var base_cyber_attack_mod
var cyber_attack_mod = 1.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
