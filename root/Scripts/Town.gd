extends Polygon2D
class_name Town

export var population = 0
export(Array, String) var neighbours
export var shares = {"Tedstra":0, "Vodaclone":0, "ElonMask Co":0, "PanCogan Mobile":0}
export(Dictionary) var sprites = {"Tedstra": {"3g": 0, "4g": 0, "5g": 0}, "Vodaclone": {"3g": 0, "4g": 0, "5g":0}, "ElonMask Co":{"3g": 0, "4g": 0, "5g":0}, "PanCogan Mobile":{"3g": 0, "4g": 0, "5g":0}, "Who-awei":{"3g": 0, "4g": 0, "5g":0}, "Xiaomy":{"3g": 0, "4g": 0, "5g":0}, "Alidada":{"3g": 0, "4g": 0, "5g":0}, "Knockia":{"3g": 0, "4g": 0, "5g":0}}
export var starter_town = false
export(String) var town_name
export(PackedScene) var ISPTownInfo_scene
var ISPs = {}
var Player_ISPTownInfo
export(float) var affluency
export(NodePath) onready var bound
export(NodePath) onready var border
export var unselected_opacity = 0.4
export var selected_opacity = 3

signal clicked(town)
signal town_mouse_entered
signal town_mouse_exited

var no_ISP_pop = 0
var affluency_connection_delta = {}


#put this somewhere else?
const base_aoe_image = 10


# Called when the node enters the scene tree for the first time.
func _ready():
	get_node(bound).set_polygon(polygon)
	border = get_node(border)
	border.set_polygon(polygon)
	self_modulate.a = 0
	border.modulate.a = unselected_opacity

	var ashares = get_ISP_shares()
	var max_ISP = null
	for ISP in ashares.keys():
		if !max_ISP:
			max_ISP = ISP
		elif ashares[ISP] > ashares[max_ISP]:
			max_ISP = ISP
	
#	border.self_modulate = max_ISP.colour

# population - noISPs in generates
func init_town_ISPs(AIs, player):
	for AI in AIs:
		var ISP = AI.ISP
		if shares[ISP.ISP_name]:
			var ISPTownInfo = create_ISPTownInfo(ISP)
			ISPTownInfo.generate(shares[ISP.ISP_name], population, affluency)
			ISPs[ISP] = ISPTownInfo
	
	if starter_town:
		Player_ISPTownInfo = create_ISPTownInfo(player.ISP)
		Player_ISPTownInfo.generate_starter(population)
		emit_signal("clicked")
		
		
func get_ISP_town_info(ISP):
	if ISPs.keys().has(ISP):
		return ISPs[ISP]
	if Player_ISPTownInfo:
		if ISP == Player_ISPTownInfo.ISP:
			return Player_ISPTownInfo
	return false
	
func get_ISP_shares():
	var ISP_shares = {}
	for ISP in get_ISPs():
		var share = get_share(ISP)
		if share:
			ISP_shares[ISP] = get_share(ISP)
		
	return ISP_shares

func get_ISPs():
	var ISP_list = ISPs.keys()
	if Player_ISPTownInfo:
		ISP_list.append(Player_ISPTownInfo.ISP)
	return ISP_list

func get_share(ISP):
	return float(ISPs[ISP].connections)/population
	
func update_turn():
	var ISPTownInfos = get_ISPs()
	for towninfo in ISPTownInfos:
		towninfo.get_connections_loss(ISPTownInfos, affluency)
		affluency_connection_delta[towninfo] = towninfo.get_affluency_delta(affluency)
		
	normalise_affluency_delta()
	affluency_convert_pos_share_to_pop()
	
	for towninfo in ISPTownInfos:
		towninfo.get_connections_delta()
	for towninfo in ISPTownInfos:
		towninfo.update_turn()
		if towninfo.tower:
			no_ISP_pop -= towninfo.update_affluency_conns(affluency_connection_delta[towninfo])

func create_ISPTownInfo(ISP):
	var ISPTownInfo = ISPTownInfo_scene.instance()
	ISPTownInfo.initialise(ISP, self)
	return ISPTownInfo
	
func propagate_brand_image(tower, ISP, dist):
	if !ISPs.has(ISP):
		ISPs[ISP] = create_ISPTownInfo(ISP)
	ISPs[ISP].update_aoe_image(tower, base_aoe_image * (dist + 1))
	if dist > 0:
		# neighbours list of town objects
		for town in neighbours:
			town.propagate_brand_image(tower, ISP, dist - 1)
			
func depropagate_brand_image(tower, ISP, dist):
	if ISPs.has(ISP):
		ISPs[ISP].remove_aoe_image(tower)
	if dist > 0:
		for town in neighbours:
			town.depropagate_brand_image(tower, ISP, dist - 1)
			
func normalise_affluency_delta():
	var pos_sum = 0.0
	for delta in affluency_connection_delta.values():
		if delta > 0:
			pos_sum += delta
	for ISP in affluency_connection_delta.keys():
		if pos_sum > 1:
			affluency_connection_delta[ISP] /= pos_sum
func build_tower(ISP, tower):
	get_ISP_town_info(ISP).build_tower(tower)
	#todo sprite changing
	var sprite = sprites[ISP][tower.type()]

# converts pos shares in get_affluency_delta to pops
func affluency_convert_pos_share_to_pop():
	var pop_sum = 0
	for ISP in affluency_connection_delta.keys():
		var share_delta = affluency_connection_delta[ISP]
		if share_delta > 0:
			affluency_connection_delta[ISP] = int(no_ISP_pop * share_delta)

func upgrade_tower(ISP, type):
	get_ISP_town_info(ISP).upgrade_tower(type)

func deselect():
	border.modulate.a = unselected_opacity
	
func select():
	border.modulate.a = selected_opacity


func _on_Collider_mouse_entered():
	emit_signal("town_mouse_entered")


func _on_Collider_mouse_exited():
	emit_signal("town_mouse_exited")

func _on_Collider_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("ui_click"):
		emit_signal("clicked", self)

