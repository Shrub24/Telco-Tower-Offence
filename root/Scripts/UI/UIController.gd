extends CanvasLayer

var off_screen_position
var position

export(NodePath) var price_label
export(NodePath) var delta_price_label
export(NodePath) var player_loyalty_label
export(NodePath) var player_image_label

signal cyber_attack_pressed(target_name)
signal advertising_sell_pressed
signal advertising_buy_pressed
signal buy_tower_pressed(type)
signal price_up_pressed
signal price_down_pressed
signal next_turn_pressed

# Called when the node enters the scene tree for the first time.
func _ready():
	position = $Bottom.rect_position
	off_screen_position = Vector2(position.x, position.y+250)
	$Bottom.rect_position = off_screen_position

func show_town_UI(town):
	var curr_position = $Bottom.rect_position 
	$Tween.interpolate_property($Bottom, "rect_position", curr_position, position, 1, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Tween.start()
	
func hide_town_UI():
	var curr_position = $Bottom.rect_position 
	$Tween.interpolate_property($Bottom, "rect_position", curr_position, off_screen_position, 1, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Tween.start()

func update_price(price):
	price_label.text = str(price)

func update_delta_price(delta_price):
	delta_price_label.text = str(delta_price)

func update_player_loyalty(loyalty):
	player_loyalty_label.text = str(loyalty)

func update_player_image(image):
	player_image_label.text = str(image)
	
func update_cyber_attack(target, value):
	pass

func update_advertising(value):
	pass

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

func _on_TedstraAttack_pressed():
	emit_signal("cyber_attack_pressed", "Tedstra")

func _on_VodacloneAttack_pressed():
	emit_signal("cyber_attack_pressed", "Vodaclone")

func _on_ElonMaskCoAttack_pressed():
	emit_signal("cyber_attack_pressed", "ElonMask Co")

func _on_PanCoganMobileAttack_pressed():
	emit_signal("cyber_attack_pressed", "PanCogan Mobile")

func _on_PriceUp_pressed():
	emit_signal("price_up_pressed")

func _on_PriceDown_pressed():
	emit_signal("price_down_pressed")

func _on_Next_Turn_pressed():
	emit_signal("next_turn_pressed")
