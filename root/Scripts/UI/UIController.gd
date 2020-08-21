extends CanvasLayer

var off_screen_position
var position

export(NodePath) onready var price_label = get_node(price_label)
export(NodePath) onready var delta_price_label = get_node(delta_price_label)
export(NodePath) onready var player_loyalty_label = get_node(player_loyalty_label)
export(NodePath) onready var player_image_label = get_node(player_image_label)
export(NodePath) onready var advertising_label = get_node(advertising_label)
export(NodePath) onready var speed_label = get_node(speed_label)
export(NodePath) onready var bandwidth_label = get_node(bandwidth_label)
export(NodePath) onready var reach_label = get_node(reach_label)
export(NodePath) onready var money_label = get_node(money_label)
export(NodePath) onready var reserved_money_label = get_node(reserved_money_label)
export var cyber_attack_button_paths = {"Tedstra":0, "Vodaclone":0, "ElonMask Co":0, "PanCogan Mobile":0}
export(NodePath) onready var share_graphic = get_node(share_graphic)
var cyber_attack_buttons = {}
export var ISP_info_paths = {"Tedstra":0, "Vodaclone":0, "ElonMask Co":0, "PanCogan Mobile":0}
var ISP_infos = {}

signal cyber_attack_pressed(target_name)
signal advertising_sell_pressed
signal advertising_buy_pressed
signal buy_tower_pressed(type)
signal price_up_pressed
signal price_down_pressed
signal next_turn_pressed
signal upgrade_tower_pressed(type)

# Called when the node enters the scene tree for the first time.
func _ready():
	for ISP in cyber_attack_button_paths.keys():
		cyber_attack_buttons[ISP] = get_node(cyber_attack_button_paths[ISP])
	for ISP in ISP_info_paths.keys():
		ISP_infos[ISP] = get_node(ISP_info_paths[ISP])
	position = $Bottom.rect_position
	off_screen_position = Vector2(position.x, position.y+400)
	$Bottom.rect_position = off_screen_position

func show_town_UI(town):
	var curr_position = $Bottom.rect_position 
	$Tween.interpolate_property($Bottom, "rect_position", curr_position, position, 1, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Tween.start()
	
func hide_town_UI():
	var curr_position = $Bottom.rect_position 
	$Tween.interpolate_property($Bottom, "rect_position", curr_position, off_screen_position, 1, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Tween.start()

func update_money(money):
	money_label.text = str(money)

func update_reserved_money(money):
	reserved_money_label.text = str(money)

func update_ISP_info(loyalty, image, price, ISP):
	var ISP_info = ISP_infos[ISP]
	ISP_info.update_price(price)
	ISP_info.update_image(image)
	ISP_info.update_loyalty(loyalty)
	
func update_tower_upgrade(reach, bandwidth, speed):
	
	reach_label.text = str(reach)
	bandwidth_label.text = str(bandwidth)
	speed_label.text = str(speed)

func update_tower_buy(tower_type):
	pass

func update_shares(share_dict, colour_dict):
	share_graphic.update_graphic(share_dict, colour_dict)

func update_price(price):
	price_label.text = str(price)

func update_delta_price(delta_price):
	delta_price_label.text = str(delta_price)

func update_player_loyalty(loyalty):
	player_loyalty_label.text = str(loyalty)

func update_player_image(image):
	player_image_label.text = str(image)
	
func update_cyber_attack(target, value):
	for ISP in cyber_attack_buttons.keys():
		var button = cyber_attack_buttons[ISP]
		if !target:
			button.texture = button.unpressed
		elif target == ISP:
			if value:
				button.texture = button.pressed
			else:
				button.texture = button.unpressed

func update_advertising(value):
	advertising_label.text = str(value)

func _on_3gTowerBuy_pressed():
	emit_signal("buy_tower_pressed", "3g")

func _on_4gTowerBuy_pressed():
	emit_signal("buy_tower_pressed", "4g")

func _on_5gTowerBuy_pressed():
	emit_signal("buy_tower_pressed", "5g")

func _on_AdvertisingBuy_pressed():
	emit_signal("advertising_buy_pressed")

func _on_AdvertisingSell_pressed():
	emit_signal("advertising_sell_pressed")

func _on_PriceUp_pressed():
	emit_signal("price_up_pressed")

func _on_PriceDown_pressed():
	emit_signal("price_down_pressed")

func _on_Next_Turn_pressed():
	emit_signal("next_turn_pressed")

func _on_TedstraAttack_gui_input(event):
	if event.is_action_pressed("ui_click"):
		emit_signal("cyber_attack_pressed", "Tedstra")

func _on_VodacloneAttack_gui_input(event):
	if event.is_action_pressed("ui_click"):
		emit_signal("cyber_attack_pressed", "Vodaclone")

func _on_ElonMaskCoAttack_gui_input(event):
	if event.is_action_pressed("ui_click"):
		emit_signal("cyber_attack_pressed", "ElonMask Co")

func _on_PanCoganMobileAttack_gui_input(event):
	if event.is_action_pressed("ui_click"):
		emit_signal("cyber_attack_pressed", "PanCogan Mobile")


func _on_BandwidthUpgradeButton_pressed():
	emit_signal("upgrade_tower_pressed", "bandwidth")


func _on_ReachUpgradeButton_pressed():
	emit_signal("upgrade_tower_pressed", "reach")


func _on_SpeedUpgradeButton_pressed():
	emit_signal("upgrade_tower_pressed", "speed")
