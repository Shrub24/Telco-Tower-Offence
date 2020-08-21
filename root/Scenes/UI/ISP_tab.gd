extends VBoxContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export(NodePath) onready var price_label = get_node(price_label)
export(NodePath) onready var image_label = get_node(image_label)
export(NodePath) onready var loyalty_label = get_node(loyalty_label)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func update_price(price):
	price_label.text = str(price)
	
func update_image(image):
	image_label.text = str(image)
	
func update_loyalty(loyalty):
	loyalty_label.text = str(loyalty)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
