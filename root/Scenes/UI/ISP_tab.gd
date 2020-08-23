extends VBoxContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export(NodePath) onready var price_label = get_node(price_label)
export(NodePath) onready var image_label = get_node(image_label)
export(NodePath) onready var loyalty_label = get_node(loyalty_label)
export(Texture) var ISP_logo
export(String) var ISP_name
export(Color) var ISP_colour
export(NodePath) onready var connection_label = get_node(connection_label)

# Called when the node enters the scene tree for the first time.
func _ready():
	$Logo_Container/Logo.texture = ISP_logo
	$Logo_Container/BrandLabel.add_color_override("font_color", ISP_colour)
	$Logo_Container/BrandLabel.text = ISP_name

func update_connections(connections):
	connection_label.text = "%s people" % connections
	if !connections:
		connection_label.text = ""

func update_price(price):
	if price:
		price_label.text = "$" + str(price)
	else:
		price_label.text = str(price)
	
func update_image(image):
	image_label.text = str(image)
	
func update_loyalty(loyalty):
	loyalty_label.text = str(loyalty)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
