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
export var selected = false

signal clicked
signal town_mouse_entered
signal town_mouse_exited


func _ready():
	get_node(bound).set_polygon(polygon)
	modulate.a = 1

func init_town_ISPs(AIs, player):
	for AI in AIs:
		var ISP = AI.ISP
		if shares[ISP.name]:
			var ISPTownInfo = create_ISPTownInfo(ISP)
			ISPTownInfo.generate(shares[ISP.name], population, affluency)
			ISPs[ISP] = ISPTownInfo
	
	if starter_town:
		Player_ISPTownInfo = create_ISPTownInfo(player.ISP)
		Player_ISPTownInfo.generate_starter(population)
		emit_signal("clicked")
		selected = true
		
		
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
	for towninfo in ISPTownInfos:
		towninfo.get_connections_delta()
	for towninfo in ISPTownInfos:
		towninfo.update_turn()

func create_ISPTownInfo(ISP):
	var ISPTownInfo = ISPTownInfo_scene.instance()
	ISPTownInfo.initialise(ISP, self)
	return ISPTownInfo
	
func build_tower(ISP, tower):
	get_ISP_town_info(ISP).build_tower(tower)
	#todo sprite changing
	var sprite = sprites[ISP][tower.type()]

func upgrade_tower(ISP, type):
	get_ISP_town_info(ISP).upgrade_tower(type)



func _on_Collider_mouse_entered():
	emit_signal("town_mouse_entered")


func _on_Collider_mouse_exited():
	emit_signal("town_mouse_exited")

func _on_Collider_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("ui_click"):
		emit_signal("clicked")

