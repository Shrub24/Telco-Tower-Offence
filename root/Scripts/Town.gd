extends Node2D

export var population = 0
export(Array, String) var neighbours
export var shares = {"ISP1":0, "ISP2":0, "ISP3":0, "ISP4":0}
export var starter_town = false
export(String) var town_name


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
