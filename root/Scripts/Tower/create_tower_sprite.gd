extends TileMap


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var tileset

# Called when the node enters the scene tree for the first time.
func _ready():
	tileset = get_tileset()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func add_tower_sprite(ISP_name, tower_type, loc):
	var tile_pos = world_to_map(loc)
	set_cellv(tile_pos, tileset.find_tile_by_name(ISP_name + tower_type))
