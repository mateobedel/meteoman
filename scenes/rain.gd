class_name Rain extends Area2D 

var max_distance = 3000
var jump_force = 100*60
var distance = 0
var step = 1200
var wind_speed = 400
var wind_dir = 0
var move = false
var old_position = Vector2.ZERO
var tornado_counter = 0
var liste_vents = []

var speed_x = 0
var velocity = Vector2.ZERO
var acceleration_amount = 50
var friction_amount = 25

@onready var original_pos = position

@onready var collisionshape = $water/CollisionShape2D
@onready var texturerect = $water/TextureRect
@onready var colorrect = $water/ColorRect
@onready var colision_raincloud = $CollisionShape2D
@onready var timer = $water/Timer
@onready var raycast = $water/RayCast2D

var frame1 = preload("res://texture/rain.png")
var frame2 = preload("res://texture/rain2.png")
var frame = 1

enum {PLAY, PAUSE}
var state = PAUSE


func _ready():
	Event.play_pressed.connect(_on_play_pressed)
	Event.restart_pressed.connect(_on_restart_pressed)
	Event.wind_speed_update.connect(_on_wind_speed_update)

func _physics_process(delta):

	if raycast.is_colliding() && raycast.get_collider() is Tilemap:
		distance = raycast.get_collision_point().y - position.y - 64
	else:
		distance = max_distance

	
	collisionshape.shape.size.y = distance
	collisionshape.position.y = distance/2
	texturerect.size.y = distance
	colorrect.size.y = distance
	
	if state == PLAY:
		speed_x = wind_speed*wind_dir
		
		if wind_dir == 0:
			apply_friction(delta)
		else:
			apply_acceleration(speed_x,delta)
		
		#JUMP
		if tornado_counter > 0:
			velocity.y -= jump_force*delta
		else:
			velocity.y = 0
		
		position += velocity*delta
	
	if move:
		position += get_local_mouse_position() - old_position
		old_position =get_local_mouse_position()
		original_pos = position
		
	
		
func apply_friction(delta):
	velocity.x = move_toward(velocity.x, 0, friction_amount*60*delta)
	
func apply_acceleration(speed, delta):
	velocity.x = move_toward(velocity.x, speed, acceleration_amount*60*delta)
	

func _on_water_body_entered(body):
	if body is Player:
		body.rain_amount += 1
	elif body is Tilemap:
		pass

func _on_water_body_exited(body):
	if body is Player:
		body.rain_amount -= 1

func _on_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	if area is Wind:
		liste_vents.append(area)
		calc_wind_speed()
func _on_area_shape_exited(area_rid, area, area_shape_index, local_shape_index):
	if area is Wind:
		liste_vents.erase(area)
		calc_wind_speed()

func _on_button_button_down():
	distance = 0
	move = true

func _on_button_button_up():
	move = false

func _on_timer_timeout():
	if frame == 1:
		texturerect.texture = frame2
		frame = 2
		timer.start(.3)
	else:
		texturerect.texture = frame1
		frame = 1
		timer.start(.3)
	
func _on_play_pressed():
	$Button.visible = false
	timer.start(.3)
	state = PLAY
	
func _on_restart_pressed():
	$Button.visible = true
	velocity = Vector2.ZERO
	state = PAUSE
	timer.stop()
	position = original_pos

func calc_wind_speed():
	wind_dir = 0
	for vent in liste_vents:
		wind_dir += vent.speed


func _on_wind_speed_update():
	calc_wind_speed()
	
func _on_button_gui_input(event):
	if event.is_action_pressed("MWC"):
		Event.emit_signal("item_deleted",1)
		Event.delete.play()
		queue_free()
			
