extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var player_ISP_options = {"Who-awei":0, "Xiaomy":1, "Alidada":2, "Knockia":3}
export(Array, PackedScene) var player_ISP_scenes
export(PackedScene) var player_scene
export(Array, PackedScene) var AI_scenes
var ISPs = []
var AIs = []

var player

signal init_town_ISPs(AIs, player)
signal turn_update()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
	

func choose_player_ISP(ISP):
	player = player_scene.instance()
	var player_ISP = player_ISP_scenes[player_ISP_options[ISP].instance()]
	player.init_ISP(player_ISP)
	

func game_start():
	for scene in AI_scenes:
		var instance = scene.instance()
		AIs.append(instance)
	emit_signal("init_town_ISPs", AIs, player)

func next_turn():
	for AI in AIs:
		AI.update_actions()
	emit_signal("turn_update")
	
