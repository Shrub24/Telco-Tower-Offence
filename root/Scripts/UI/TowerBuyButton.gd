extends TextureRect


export(Texture) var unpressed
export(Texture) var pressed

# Called when the node enters the scene tree for the first time.
func _ready():
	self.texture = unpressed


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
