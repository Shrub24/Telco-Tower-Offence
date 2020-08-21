extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var player_ISP_options = {"Who-awei":0, "Xiaomy":1, "Alidada":2, "Knockia":3}
export(Array, PackedScene) var player_ISP_scenes
export(NodePath) onready var player = get_node(player) if player else null

var ISP_name_dict = {}
var ISPs = []
var AIs = []
export(NodePath) onready var map = get_node(map) if map else null
export(NodePath) onready var UI_controller = get_node(UI_controller) if UI_controller else null
var towns = []
var selected_town

export(Array, NodePath) var AI_paths

func connect_town(town):
	town.connect("clicked", self, "town_clicked")

func town_clicked(town):
	if selected_town == town:
		town.deselect()
		selected_town = null
		UI_controller.hide_town_UI()
	else:
		if selected_town:
			selected_town.deselect()
		selected_town = town
		town.select()
		UI_controller.show_town_UI(town)
		update_town_UI(town)
		
func update_town_UI(town):
	pass
	
func ui_update_delta_price(delta_price):
	UI_controller.update_delta_price(delta_price)

func ui_update_price(price):
	UI_controller.update_price(price)
	
func ui_update_ISP(loyalty, image, price, ISP):
	if ISP == player.ISP:
		UI_controller.update_player_image(image)
		UI_controller.update_player_loyalty(loyalty)
		ui_update_price(price)
	else:
		pass

func ui_update_tower():
	UI_controller.update_tower_buy()
	UI_controller.update_tower_upgrade()

func ui_update_advertising(value):
	UI_controller.update_advertising(value)
	
func ui_update_cyber_attack(ISP, value):
	UI_controller.update_cyber_attack(ISP, value)

# Called when the node enters the scene tree for the first time.
func _ready():
	for town in map.get_children():
		if !(town is TileMap): 
			towns.append(town)
			connect_town(town)
	for path in AI_paths:
		var AI = get_node(path)
		ISP_name_dict[AI.ISP.ISP_name] = AI.ISP
		AIs.append(AI)
		ISPs.append(AI.ISP)
	choose_player_ISP("Who-awei")
	ISPs.append(player.ISP)
	game_start()

func choose_player_ISP(ISP):
	var player_ISP = player_ISP_scenes[player_ISP_options[ISP]].instance()
	player.ISP = player_ISP

func game_start():
	for town in towns:
		town.init_town_ISPs(AIs, player)
		for neighbour in town.neighbours:
			for town2 in towns:
				if town2.town_name in town.neighbours:
					town.neighbour_towns.append(town2)

func next_turn():
	for AI in AIs:
		AI.update_actions()
	for ISP in ISPs:
		if selected_town and selected_town.Player_ISPTownInfo:
			ui_update_cyber_attack(selected_town.Player_ISPTownInfo.get_cyber_attack(), false)
			ui_update_advertising(selected_town.Player_ISPTownInfo.get_advertising())
		ISP.update_turn()


	for town in towns:
		town.update_turn()
	player.update_turn()


func _on_UI_advertising_buy_pressed():
	player.buy_advertising(selected_town)


func _on_UI_advertising_sell_pressed():
	player.sell_advertising(selected_town)


func _on_UI_buy_tower_pressed(type):
	player.buy_tower(selected_town, type)


func _on_UI_cyber_attack_pressed(target_name):
	player.cyber_attack_target(selected_town, ISP_name_dict[target_name])


func _on_UI_price_down_pressed():
	player.price_down(selected_town)


func _on_UI_price_up_pressed():
	player.price_up(selected_town)


func _on_UI_next_turn_pressed():
	if player.ISP.get_available_money() < 0:
		emit_signal("bankruptcy_query")
	else:
		next_turn() 
