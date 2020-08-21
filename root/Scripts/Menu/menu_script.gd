extends Node

export (String) var instructions_scene_path
export (String) var ISP_select_scene_path

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Continue_pressed():
	pass # Replace with function body.


func _on_NewGame_pressed():
	get_tree().change_scene(ISP_select_scene_path)


func _on_Instructions_pressed():
	get_tree().change_scene(instructions_scene_path)


func _on_Quit_pressed():
	get_tree().quit()
