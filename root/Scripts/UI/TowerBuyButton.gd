extends TextureRect


export(Texture) var unpressed
export(Texture) var pressed
export(Texture) var disabled

# Called when the node enters the scene tree for the first time.
func _ready():
	self.texture = disabled


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
