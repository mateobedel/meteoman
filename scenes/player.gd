extends CharacterBody2D
class_name Player


var gravity = 100*60
var gagner = false
var wind_speed = 400
var floor_wind_speed = 25
var speed_x = 0

var acceleration_amount = 50
var friction_amount = 25

var jump_force = 100*60
var tornado_counter = 0
var mort = false
const MIN_HEIGHT = 3000

var playing_wind = false
var playing_tornado = false

@onready var original_pos = position
@onready var mort_sprite = $mort_sprite
@onready var normal_sprite = $Sprite2D
@onready var parts = $CPUParticles2D
@onready var remote = $RemoteTransform2D

var wind_dir = 0
var liste_vents = []
var rain_amount = 0

enum {PLAY, PAUSE}
var game_state = PAUSE


func _ready():
	Event.play_pressed.connect(_on_play_pressed)
	Event.restart_pressed.connect(_on_restart_pressed)
	Event.wind_speed_update.connect(_on_wind_speed_update)
	
	Event.player_wind_entered.connect(_on_wind_entered)
	Event.player_wind_exited.connect(_on_wind_exited)
	
	Event.camera_ready.connect(_on_camera_connect)
	Event.camera_off.connect(_on_camera_off)
	Event.emit_signal("player_ready",original_pos)
	
func _physics_process(delta):
	
	if game_state == PLAY && !gagner:
		###					MOUVEMENTS
		
		#POUSSER DU VENT
		if !mort:
			if rain_amount != 0 || not is_on_floor() :
				speed_x = wind_speed*wind_dir
			else:
				speed_x = floor_wind_speed*wind_dir
		
		
		#SAUT DE LA TORNADE
		if tornado_counter > 0 && !mort:
			velocity.y = min(velocity.y, 1000)
			velocity.y -= jump_force*delta
		elif not is_on_floor():
			if position.y < MIN_HEIGHT:
				velocity.y += gravity * delta
		velocity.y = clamp(velocity.y, -5000, 5000)
		
		#FRICTION ACCELERATION
		if wind_dir == 0:
			apply_friction(delta)
		else:
			apply_acceleration(speed_x,delta)
		
		move_and_slide()
		
		if !playing_wind && !liste_vents.is_empty():
			$wind_sound.play()
			playing_wind = true
		
		if liste_vents.is_empty():
			$wind_sound.stop()
			playing_wind = false
			
		if !playing_tornado && tornado_counter != 0:
			$tornado_sound.play()
			playing_tornado = true
			
		if tornado_counter == 0:
			$tornado_sound.stop()
			playing_tornado = false
		
	#PARTICULES
	if game_state == PLAY && !mort && is_on_floor() && velocity.x != 0:
		parts.direction.x = -sign(velocity.x)
		if !parts.emitting:
			parts.emitting = true
			if rain_amount == 0:
				parts.initial_velocity_min = 100
				parts.initial_velocity_max = 200
				parts.amount = 6
				parts.color_ramp.colors = PackedColorArray([Color(1, 1, 1, 1), Color(1, 1, 1, 0)])
			else:
				parts.initial_velocity_min = 100
				parts.initial_velocity_max = 200
				parts.color_ramp.colors = PackedColorArray([Color(0.21, 0.4865, 1, 1), Color(0, 0.316667, 1, 0)])
				parts.amount = 14
	else:
		parts.emitting = false 

	#MORT DANS LE VIDE
	if position.y > MIN_HEIGHT && !mort:
		velocity.y = 0
		player_died()
		

		

func apply_friction(delta):
	velocity.x = move_toward(velocity.x, 0, friction_amount*60*delta)
	
func apply_acceleration(speed, delta):
	velocity.x = move_toward(velocity.x, speed, acceleration_amount*60*delta)
	

func _on_wind_entered(wind):
	liste_vents.append(wind)
	calc_wind_speed()

func _on_wind_exited(wind):
	liste_vents.erase(wind)
	calc_wind_speed()

func calc_wind_speed():
	wind_dir = 0
	for vent in liste_vents:
		wind_dir += vent.speed


func _on_wind_speed_update():
	calc_wind_speed()

func _on_play_pressed():
	game_state = PLAY
	
func _on_restart_pressed():
	game_state = PAUSE
	$wind_sound.stop()
	$tornado_sound.stop()
	playing_wind = false
	playing_tornado = false
	mort = false
	normal_sprite.visible = true
	mort_sprite.visible = false
	velocity = Vector2.ZERO
	position = original_pos
	
func _on_camera_connect(camera):
	remote.remote_path = camera.get_path()
	
func _on_camera_off():
	remote.remote_path = ""

func player_died():
	if !mort && game_state == PLAY:
		$death_sound.play()
		mort = true
		normal_sprite.visible = false
		mort_sprite.visible = true
		mort_sprite.play()
	
