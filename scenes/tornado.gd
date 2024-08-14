class_name Tornado extends Area2D

var move = false
var old_position = Vector2.ZERO
var wind_speed = 400
var wind_dir = 0
var liste_vents = []

var speed_x = 0
var velocity = Vector2.ZERO
var acceleration_amount = 50
var friction_amount = 25

@onready var original_pos = position

enum {PLAY, PAUSE}
var state = PAUSE

func _ready():
	Event.play_pressed.connect(_on_play_pressed)
	Event.restart_pressed.connect(_on_restart_pressed)
	Event.wind_speed_update.connect(_on_wind_speed_update)

func _physics_process(delta):
	if state == PLAY:
		speed_x = wind_speed*wind_dir
	
		if wind_dir == 0:
			apply_friction(delta)
		else:
			apply_acceleration(speed_x,delta)
		
	position += velocity*delta
	
	if move:
		position += get_local_mouse_position() - old_position
		old_position = get_local_mouse_position()
		original_pos = position
	
func apply_friction(delta):
	velocity.x = move_toward(velocity.x, 0, friction_amount*60*delta)
	
func apply_acceleration(speed, delta):
	velocity.x = move_toward(velocity.x, speed, acceleration_amount*60*delta)
	




func _on_body_entered(body):
	if body is Player:
		body.tornado_counter += 1
		
func _on_body_exited(body):
	if body is Player:
		body.tornado_counter -=1

func _on_button_2_button_down():
		move = true

func _on_button_2_button_up():
	move = false

func _on_play_pressed():
	$AnimatedSprite2D.speed_scale = 1
	$Button2.visible = false
	state = PLAY
	
func _on_restart_pressed():
	$AnimatedSprite2D.speed_scale = 0
	$Button2.visible = true
	position = original_pos
	velocity = Vector2.ZERO
	state = PAUSE
	
func _on_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	if area is Wind:
		liste_vents.append(area)
		calc_wind_speed()
	elif area is Rain:
		area.tornado_counter+=1	

func _on_area_shape_exited(area_rid, area, area_shape_index, local_shape_index):
	if area is Wind:
		liste_vents.erase(area)
		calc_wind_speed()
	elif area is Rain:
		area.tornado_counter-=1	

func calc_wind_speed():
	wind_dir = 0
	for vent in liste_vents:
		wind_dir += vent.speed


func _on_wind_speed_update():
	calc_wind_speed()
	
	
func _on_button_2_gui_input(event):
	if event.is_action_pressed("MWC"):
		Event.emit_signal("item_deleted",2)
		Event.delete.play()
		queue_free()
