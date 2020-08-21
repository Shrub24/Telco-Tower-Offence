extends CenterContainer

export(Array, NodePath) var progress_paths = []
var progress_bars = []
var shares = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	for ISP in progress_paths:
		progress_bars.append(get_node(ISP))

func update_graphic(share_dict, colour_dict):
	shares = share_dict
	var sorted = shares.keys()
	sorted.sort_custom(self, "dict_sort")
	var sum = 0
	for i in range(progress_bars.size()):
		if i >= sorted.size():
			progress_bars[i].value = 0
		else:
			var ISP = sorted[i]
			sum += shares[ISP] * 100
			progress_bars[i].value = sum
			progress_bars[i].set_tint_progress(colour_dict[ISP])


func dict_sort(a, b):
	return shares[a] > shares[b]

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass