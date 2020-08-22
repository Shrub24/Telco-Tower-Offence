extends Node


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
var starter_town

export(Array, NodePath) var AI_paths
export (NodePath) onready var camera = get_node(camera) if camera else null
export (NodePath) var global_data_path = "/root/GlobalData"
var global_data
var starting_ISP

export var initial_camera_locations = {"Who-awei": [-1460, -448], "Xiaomy": [130, 1472], "Alidada": [2440, -320], "Knockia": [200, -290]}
export var initial_starting_towns = {"Who-awei": "Deltora", "Xiaomy": "Sholto Farms", "Alidada": "Kyanim", "Knockia": "Phlight"}

# Called when the node enters the scene tree for the first time.
func _ready():
	for town in map.get_node("towns").get_children():
		if !(town is TileMap): 
			towns.append(town)
			connect_town(town)
	for path in AI_paths:
		var AI = get_node(path)
		ISP_name_dict[AI.ISP.ISP_name] = AI.ISP
		AIs.append(AI)
		ISPs.append(AI.ISP)
		
	
	global_data = get_node(global_data_path)
	starting_ISP = get_starting_ISP()
	choose_player_ISP(starting_ISP)
	player.ISP.is_player = true
	ISPs.append(player.ISP)
	
	starter_town = initial_starting_towns[starting_ISP]
	
	game_start()

func ui_update_money():
	UI_controller.update_money(player.ISP.money)
	UI_controller.update_reserved_money(player.ISP.get_reserved_money())

func get_starting_ISP():
	return global_data.starting_ISP
	
func get_starting_camera_loc():
	return [global_data.camera_x, global_data.camera_y]

func choose_player_ISP(ISP):
	var player_ISP = player_ISP_scenes[player_ISP_options[ISP]].instance()
	player.ISP = player_ISP

func game_start():
	for town in towns:
		for town2 in towns:
			if town2.town_name in town.neighbours:
				town.neighbour_towns.append(town2)
	for town in towns:
		town.init_town_ISPs(AIs)
		if town.town_name == starter_town:
			town.init_starter_town(player)
		town.update_turn()
	ui_update_money()
		
	# init camera locations
	var loc = initial_camera_locations[starting_ISP]
	camera.set_camera_loc(loc[0], loc[1])

func next_turn():
	for AI in AIs:
		AI.update_actions()
	for ISP in ISPs:
		ISP.update_turn()

	for town in towns:
		town.update_turn()

	player.update_turn()
	if selected_town:
		update_town_UI(selected_town)

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
		update_town_UI(town)
		UI_controller.show_town_UI(town)

		
func update_town_UI(town):
	for ISP in town.get_ISPs():
		ui_update_ISP(ISP, town.get_ISP_town_info(ISP))
	ui_update_shares(town)
	ui_update_tower()
	if town.Player_ISPTownInfo:
		ui_update_delta_price(town.Player_ISPTownInfo.get_delta_price())
		ui_update_advertising(town.Player_ISPTownInfo.get_advertising())
		ui_update_cyber_attack(false, false)


func ui_update_shares(town):
	var shares = town.get_ISP_shares()
	var share_dict = {}
	var colour_dict = {}
	for ISP in shares.keys():
		if ISP.is_player:
			share_dict["Player"] = shares[ISP]
			colour_dict["Player"] = ISP.primary_colour
		else:
			share_dict[ISP.ISP_name] = shares[ISP]
			colour_dict[ISP.ISP_name] = ISP.primary_colour
	UI_controller.update_shares(share_dict, colour_dict)

func ui_update_delta_price(delta_price):
	UI_controller.update_delta_price(delta_price)

func ui_update_price(price):
	UI_controller.update_price(price)
	
func ui_update_ISP(ISP, town_info):
	if ISP == player.ISP:
		ui_update_player_loyalty(town_info.brand_loyalty)
		ui_update_player_image(town_info.brand_image)
		ui_update_price(town_info.price)
	else:
		UI_controller.update_ISP_info(town_info.brand_loyalty, town_info.brand_image, town_info.price, ISP.ISP_name)

func ui_update_tower():
	if selected_town.Player_ISPTownInfo:
		var tower = player.ISP.get_town_tower(selected_town)
		if tower:
			UI_controller.update_tower_buy(tower.tower_type)
			UI_controller.update_tower_upgrade(tower.reach_level, tower.bandwidth_level, tower.speed_level)
			return true
	UI_controller.update_tower_buy(0)
	UI_controller.update_tower_upgrade(0, 0, 0)

func ui_update_advertising(value):
	UI_controller.update_advertising(value)
	
func ui_update_cyber_attack(ISP, value):
	if ISP:
		UI_controller.update_cyber_attack(ISP.ISP_name, value)
	else:
		UI_controller.update_cyber_attack(ISP, value)
		
func ui_update_player_loyalty(loyalty):
	UI_controller.update_player_loyalty(loyalty)

func ui_update_player_image(image):
	UI_controller.update_player_image(image) 	

func _on_UI_advertising_buy_pressed():
	if selected_town.Player_ISPTownInfo and selected_town.Player_ISPTownInfo.tower:
		player.buy_advertising(selected_town)

func _on_UI_advertising_sell_pressed():
	if selected_town.Player_ISPTownInfo and selected_town.Player_ISPTownInfo.tower:
		player.sell_advertising(selected_town)


func _on_UI_buy_tower_pressed(type):
	player.buy_tower(selected_town, type)


func _on_UI_cyber_attack_pressed(target_name):
	if selected_town.Player_ISPTownInfo:
		player.cyber_attack_target(selected_town, ISP_name_dict[target_name])


func _on_UI_price_down_pressed():
	if selected_town.Player_ISPTownInfo and selected_town.Player_ISPTownInfo.tower:
		player.price_down(selected_town)


func _on_UI_price_up_pressed():
	if selected_town.Player_ISPTownInfo and selected_town.Player_ISPTownInfo.tower:
		player.price_up(selected_town)


func _on_UI_next_turn_pressed():
	if player.ISP.get_available_money() < 0:
		emit_signal("bankruptcy_query")
	else:
		next_turn() 


func _on_UI_upgrade_tower_pressed(type):
	if selected_town.Player_ISPTownInfo and selected_town.Player_ISPTownInfo.tower:
		player.upgrade_tower(selected_town, type)
