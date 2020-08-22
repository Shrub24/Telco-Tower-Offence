extends Camera2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var zoom_factor = 1.0
export var zoom_speed = 10.0
var zooming = false
export var zoom_min = 0.25
export var zoom_max = 5.0
export var margin_x = 100
export var margin_y = 100
export var margin_y_ui = 25
var mouse_position = Vector2()
export var camera_speed = 25.0

export var min_boundary_x = -1800
export var max_boundary_x = 2100
export var min_boundary_y = -1200
export var max_boundary_y = 1400



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_camera_loc(x, y):
	position.x = x
	position.y = y

func _process(delta):
	
	var x = position.x
	var y = position.y
	
	#mouse camera movement
	if mouse_position.x < margin_x:
		x = lerp(position.x, position.x - abs(mouse_position.x - margin_x)/margin_x * camera_speed * zoom.x, camera_speed * delta)
	elif mouse_position.x > get_viewport_rect().size.x - margin_x:
		x = lerp(position.x, position.x + abs(mouse_position.x - get_viewport_rect().size.x + margin_x)/margin_x * camera_speed * zoom.x, camera_speed * delta)
	if mouse_position.y < margin_y:
		y = lerp(position.y, position.y - abs(mouse_position.y - margin_y)/margin_y * camera_speed * zoom.y, camera_speed * delta)
	elif mouse_position.y > get_viewport_rect().size.y - margin_y:
		y = lerp(position.y, position.y + abs(mouse_position.y - get_viewport_rect().size.y + margin_y)/margin_y * camera_speed * zoom.y, camera_speed * delta)
	
	
	#keyboard camera movement
	var hor_move = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	var vert_move = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"));

	if hor_move != 0:
		x = lerp(position.x, position.x + hor_move * camera_speed * zoom.x, camera_speed * delta)
	if vert_move != 0:
		y = lerp(position.y, position.y + vert_move * camera_speed * zoom.y, camera_speed * delta)
	
	position.x = clamp(x, min_boundary_x, max_boundary_x)
	position.y = clamp(y, min_boundary_y, max_boundary_y)

	#process zoom
	zoom.x = lerp(zoom.x, zoom.x * zoom_factor, zoom_speed * delta)
	zoom.y = lerp(zoom.y, zoom.y * zoom_factor, zoom_speed * delta)

	zoom.x = clamp(zoom.x, zoom_min, zoom_max)
	zoom.y = clamp(zoom.y, zoom_min, zoom_max)
	
	#stop zooming if not scrolling
	if not zooming:
		zoom_factor = 1.0

func _input(event):
	#process zooming input
	if event.is_action_pressed("view_zoom_in"):
		zoom_factor -= 0.1 * zoom_speed
		zooming = true
	elif event.is_action_pressed("view_zoom_out"):
		zoom_factor += 0.1 * zoom_speed
		zooming = true
	else:
		zooming = false
	
	#get mouse pos on move			
	if event is InputEventMouseMotion:
		mouse_position = event.position


