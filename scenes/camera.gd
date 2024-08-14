extends Camera2D

var zoom_strenght = Vector2.ONE*1.2
var start_pos = Vector2.ZERO
var screen_start_pos = Vector2.ZERO
enum {PLAY, PAUSE}
var state = PAUSE

# Called when the node enters the scene tree for the first time.
func _ready():
	Event.transition_in_done.connect(on_transition_in_done)
	Event.play_pressed.connect(_on_play_pressed)
	Event.restart_pressed.connect(_on_restart_pressed)
	Event.player_ready.connect(_on_player_ready)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if state == PAUSE:
		if Input.is_action_just_released("MWU"):
			if zoom.x < 1 && zoom.y < 1 :
				zoom *= zoom_strenght
			
		if Input.is_action_just_released("MWD"):
			if zoom.x > 0.3 && zoom.y > 0.3:
				zoom /= zoom_strenght
				
		if Input.is_action_just_pressed("MWC"):
			start_pos = get_local_mouse_position()
			screen_start_pos = position
			
		if Input.is_action_pressed("MWC"):
			position = screen_start_pos + start_pos - get_local_mouse_position()
			
			
func _on_play_pressed():
	state = PLAY
	position_smoothing_enabled = true
	Event.emit_signal("camera_ready",self)
	
func _on_restart_pressed():
	position_smoothing_enabled = false
	state = PAUSE
	Event.emit_signal("camera_off")
	
func _on_player_ready(pos):
	position = pos
	
	
func on_transition_in_done():
	position_smoothing_enabled = false
	state = PAUSE
	
