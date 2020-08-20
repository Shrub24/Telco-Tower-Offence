extends CanvasLayer

var off_screen_position
var position


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



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_3gTowerBuy_pressed():
	pass # Replace with function body.


func _on_4gTowerBuy_pressed():
	pass # Replace with function body.


func _on_5gTowerBuy_pressed():
	pass # Replace with function body.
	

