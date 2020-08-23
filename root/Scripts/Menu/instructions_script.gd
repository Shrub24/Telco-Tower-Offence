extends Node

export (String) var menu_scene_path

export var text_path = "res://real assets/instruction_pictures/"
export var max_scene = 31
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var cur_scene = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().change_scene(menu_scene_path)
	elif event.is_action_pressed("ui_select"):
		cur_scene += 1
		if cur_scene > max_scene:
			cur_scene = 0
		self.texture = load(text_path + "Slide" + str(cur_scene) + ".png")
