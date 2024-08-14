@tool

extends StaticBody2D
@export_range(0, 50) var knockback
@export_range(0,PI/2) var cannon_rotation
@export var flip = false
@export var cadence = 1.0
@onready var cannon = $cannon
@onready var timer = $Timer
@onready var o_position = cannon.position
const bullet_scene = preload("res://scenes/bullet.tscn")
var bullet_speed = 900

var dir = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	Event.play_pressed.connect(_on_play_pressed)
	Event.restart_pressed.connect(_on_restart_pressed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	cannon.position.x = o_position.x + dir*knockback*cos(cannon.rotation)
	cannon.position.y = o_position.y + dir*knockback*sin(cannon.rotation)
	cannon.rotation = dir*cannon_rotation
	
	if flip:
		cannon.offset = Vector2(-40,-70)
		dir = -1
		cannon.flip_h = true
	else:
		cannon.offset = Vector2(-80,-70)
		dir = 1
		cannon.flip_h = false
	

func _on_timer_timeout():
	$shoot.stop()
	$shoot.play("shoot")
	$AudioStreamPlayer.play()
	var bullet = bullet_scene.instantiate()
	bullet.position = -dir*Vector2(80,0)
	bullet.velocity = bullet_speed*Vector2(-dir*cos(cannon.rotation),-dir*sin(cannon.rotation))
	add_child(bullet)
	timer.start(cadence)

func _on_play_pressed():
	timer.start(cadence)
	
func _on_restart_pressed():
	timer.stop()
