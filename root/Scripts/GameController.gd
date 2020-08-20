extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var player_ISP_options = {"Who-awei":0, "Xiaomy":1, "Alidada":2, "Knockia":3}
export(Array, PackedScene) var player_ISP_scenes
export(NodePath) onready var player = get_node(player) if player else null

export(Array, PackedScene) var AI_scenes
var ISPs = []
var AIs = []
export(NodePath) onready var map = get_node(map) if map else null
var towns = []

export(Array, NodePath) var AI_paths

# Called when the node enters the scene tree for the first time.
func _ready():
	for town in map.get_children():
		towns.append(town)
	for path in AI_paths:
		var AI = get_node(path)
		AIs.append(AI)
		ISPs.append(AI.ISP)
	ISPs.append(player.ISP)

func choose_player_ISP(ISP):
	var player_ISP = player_ISP_scenes[player_ISP_options[ISP].instance()]
	player.init_ISP(player_ISP)

func game_start():
	for scene in AI_scenes:
		var instance = scene.instance()
		AIs.append(instance)
		
	for town in towns:
		town.init_town_ISPs(AIs, player)

func on_NextTurn_button_down():
	if player.ISP.get_available_money() < 0:
		emit_signal("bankruptcy_query")
	else:
		next_turn() 

func next_turn():
	for AI in AIs:
		AI.update_actions()
	for ISP in ISPs:
		ISP.update_turn()
		emit_signal("update_advertising", 0)
		emit_signal("untarget_cyber_attack", null)
	for town in towns:
		town.update_turn()
	player.update_turn()
