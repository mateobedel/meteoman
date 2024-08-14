@tool

extends Area2D
var move = false
var old_position = Vector2.ZERO
var wind_speed = 800
var wind_dir = 0
var liste_vents = []
var grav = 100*60

var speed_x = 0
var velocity = Vector2.ZERO
var acceleration_amount = 50
var friction_amount = 25
var t = 0.0

var flying = true
const MIN_HEIGHT = 3000

@onready var original_pos = position


enum {PLAY, PAUSE}
var state = PAUSE

# Called when the node enters the scene tree for the first time.
func _ready():
	Event.play_pressed.connect(_on_play_pressed)
	Event.restart_pressed.connect(_on_restart_pressed)
	Event.wind_speed_update.connect(_on_wind_speed_update)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	
	if wind_dir > 0:
		$AnimatedSprite2D.flip_h = false
	elif wind_dir < 0:
		$AnimatedSprite2D.flip_h = true
	
	
	if state == PLAY:
		
		if flying:
			velocity.y = 32*sin(t/8)
			t+=PI/3*60*delta
			clamp(t,-2*PI,2*PI)
		else:
			if position.y < MIN_HEIGHT:
				velocity.y += grav * delta
	
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

func _on_play_pressed():
	$AnimatedSprite2D.speed_scale = 1
	$Button2.visible = false
	state = PLAY
	
func _on_restart_pressed():
	$AnimatedSprite2D.play("vol")
	$AnimatedSprite2D.speed_scale = 0
	$Button2.visible = true
	position = original_pos
	velocity = Vector2.ZERO
	flying = true
	state = PAUSE

func _on_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	if area is Wind:
		
		liste_vents.append(area)
		calc_wind_speed()

func _on_area_shape_exited(area_rid, area, area_shape_index, local_shape_index):
	if area is Wind:
		liste_vents.erase(area)
		calc_wind_speed()

func calc_wind_speed():
	wind_dir = 0
	for vent in liste_vents:
		wind_dir += vent.speed

func _on_wind_speed_update():
	calc_wind_speed()
	
func _on_button_2_gui_input(event):
	
	if event.is_action_pressed("MWC"):
		Event.delete.play()
		Event.emit_signal("item_deleted",3)
		queue_free()

func _on_button_2_button_down():
		move = true

func _on_button_2_button_up():
	move = false

func _on_body_entered(body):
	if state == PLAY && flying:
		if body is Player:
			body.velocity.y -= 1200
			body.velocity.x += velocity.x*1.25

			$AudioStreamPlayer.play()
			$GPUParticles2D.emitting = false
			$GPUParticles2D.emitting = true
			$AnimatedSprite2D.play("mort")
			flying = false
