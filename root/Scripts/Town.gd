extends Node2D

export var population = 0
export(Array, String) var neighbours
export var shares = {"Tedstra":0, "Vodaclone":0, "ElonMask Co":0, "PanCogan Mobile":0}
export var starter_town = false
export(String) var town_name
export(PackedScene) var ISPTownInfo_scene
var ISPs = {}
var Player_ISPTownInfo
export(float) var affluency

#put this somewhere else?
const base_aoe_image = 10


# Called when the node enters the scene tree for the first time.
func _ready():
	$"../GameController".connect("init_town_ISPs", self, "init_town_ISPs")
	$"../GameController".connect("turn_update", self, "turn_update")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

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
	
func turn_update():
	var ISPTownInfos = ISPs.values()
	ISPTownInfos.append(Player_ISPTownInfo)
	for ISP in ISPTownInfos:
		ISP.update_connections(ISPTownInfos)

func create_ISPTownInfo(ISP):
	var ISPTownInfo = ISPTownInfo_scene.instance()
	ISPTownInfo.initialise(ISP, self)
	return ISPTownInfo
	
func propagate_brand_image(tower, ISP, dist):
	ISPs[ISP].update_aoe_image(tower, base_aoe_image * (dist + 1))
	if dist > 0:
		# neighbours list of town objects
		for town in neighbours:
			town.propagate_brand_image(tower, ISP, dist - 1)
			
func depropagate_brand_image(tower, ISP, dist):
	ISPs[ISP].remove_aoe_image(tower)
	if dist > 0:
		for town in neighbours:
			town.depropagate_brand_image(tower, ISP, dist - 1)
	

	
