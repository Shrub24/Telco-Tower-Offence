extends Node

export (String) var menu_scene_path
export (String) var map_path
export (NodePath) var global_data_path = "/root/GlobalData"

var global_data

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	global_data = get_node(global_data_path)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func set_ISP(ISP):
	global_data.starting_ISP = ISP
	
func _on_Whoawei_pressed():
	set_ISP("Who-awei")
	get_tree().change_scene(map_path)

func _on_Alidada_pressed():
	set_ISP("Alidada")
	get_tree().change_scene(map_path)

func _on_Knockia_pressed():
	set_ISP("Knockia")
	get_tree().change_scene(map_path)

func _on_Xiaomy_pressed():
	set_ISP("Xiaomy")
	get_tree().change_scene(map_path)
	
func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().change_scene(menu_scene_path)
