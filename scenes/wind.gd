class_name Wind extends Area2D

@export var speed = 1
@onready var texturerect = $TextureRect
@onready var colorrect = $ColorRect
@onready var collision = $CollisionShape2D
@onready var timer = $Timer

var posw = position
var old_posw = position
var scalew = Vector2.ONE*128
var old_scalew = Vector2.ONE*128


var sprite_speed1 = preload("res://texture/vent.png")
var sprite_speed1_2 = preload("res://texture/vent2.png")
var sprite_speed2 = preload("res://texture/doublevent.png")
var sprite_speed2_2 = preload("res://texture/doublevent2.png")

var tl = false
var tr = false
var bl = false
var br = false
var move = false
var frame = 1


enum {PLAY, PAUSE}
var state = PAUSE

func _ready():
	Event.play_pressed.connect(_on_play_pressed)
	Event.restart_pressed.connect(_on_restart_pressed)
	
	
func _begin():
	set_texture()

	
func _physics_process(delta):

			
	var mouse_pos = get_local_mouse_position()
	
	if tl:
		$tl.position.x = min(mouse_pos.x-20,old_posw.x+old_scalew.x-128)
		$tl.position.y = min(mouse_pos.y-20,old_posw.y+old_scalew.y-128)
		$tr.position.y = $tl.position.y 
		$bl.position.x = $tl.position.x
		scalew = old_scalew + (old_posw-$tl.position-Vector2.ONE*20)
		posw = $tl.position+Vector2.ONE*20
		$move.position = posw + scalew/2 - Vector2.ONE*20
		$set_speed.position.x = posw.x + scalew.x- 20
		$set_speed.position.y = posw.y + scalew.y/2- 20

	if tr:
		$tr.position.x = max(mouse_pos.x-20,old_posw.x+128)
		$tr.position.y = min(mouse_pos.y-20,old_posw.y+old_scalew.y-128)
		$tl.position.y = $tr.position.y
		$br.position.x = $tr.position.x
		scalew.x = $tr.position.x+20-old_posw.x
		scalew.y =  old_scalew.y + old_posw.y-$tr.position.y-20
		posw.y = $tr.position.y+20
		$move.position = posw + scalew/2- Vector2.ONE*20
		$set_speed.position.x = posw.x + scalew.x- 20
		$set_speed.position.y = posw.y + scalew.y/2- 20
		
	if bl:
		$bl.position.x = min(mouse_pos.x-20,old_posw.x+old_scalew.x-128)
		$bl.position.y = max(mouse_pos.y-20,old_posw.y+128)
		$tl.position.x = $bl.position.x
		$br.position.y = $bl.position.y
		posw.x = $bl.position.x+20
		scalew.x = old_scalew.x + (old_posw.x-$bl.position.x-20)
		scalew.y = $bl.position.y+20-old_posw.y
		$move.position = posw + scalew/2- Vector2.ONE*20
		$set_speed.position.x = posw.x + scalew.x- 20
		$set_speed.position.y = posw.y + scalew.y/2- 20
		
	if br:
		$br.position.x = max(mouse_pos.x-20,old_posw.x+128)
		$br.position.y = max(mouse_pos.y-20,old_posw.y+128)
		$bl.position.y = $br.position.y
		$tr.position.x = $br.position.x
		scalew = $br.position+Vector2.ONE*20-old_posw
		$move.position = posw + scalew/2- Vector2.ONE*20
		$set_speed.position.x = posw.x + scalew.x - 20
		$set_speed.position.y = posw.y + scalew.y/2 - 20
		
	if move:
		
		posw = mouse_pos - scalew/2
		
		$move.position = mouse_pos-20*Vector2.ONE
		$tl.position = mouse_pos - scalew/2 - 20*Vector2.ONE
		$br.position = mouse_pos + scalew/2 - 20*Vector2.ONE
		
		$bl.position.x = mouse_pos.x - scalew.x/2 - 20
		$bl.position.y = mouse_pos.y + scalew.y/2 - 20
		$tr.position.x = mouse_pos.x + scalew.x/2 - 20
		$tr.position.y = mouse_pos.y - scalew.y/2 - 20
		
		$set_speed.position.x = mouse_pos.x + scalew.x/2 - 20
		$set_speed.position.y = mouse_pos.y - 20

	texturerect.position = posw
	texturerect.size = scalew
	colorrect.size = scalew
	colorrect.position = posw
	collision.shape.size = scalew
	collision.position = posw + scalew/2
		

func set_texture():
	match speed:
		-4:
			texturerect.set_texture(sprite_speed2)
			texturerect.flip_h = true
		-1:
			texturerect.set_texture(sprite_speed1)
			texturerect.flip_h = true
		1:
			texturerect.set_texture(sprite_speed1)
			texturerect.flip_h = false
		4:
			texturerect.set_texture(sprite_speed2)
			texturerect.flip_h = false	

func _on_body_entered(body):
	if body is Player:
		Event.emit_signal('player_wind_entered',self)

func _on_body_exited(body):
	if body is Player:
		Event.emit_signal('player_wind_exited',self)

func _on_tl_button_down():
	tl = true
	old_scalew = scalew
	old_posw = posw
func _on_tl_button_up():
	tl = false
	old_scalew = scalew
	old_posw = posw
func _on_tr_button_down():
	tr = true
	old_scalew = scalew
	old_posw = posw
func _on_tr_button_up():
	tr = false
	old_scalew = scalew
	old_posw = posw
func _on_bl_button_down():
	bl = true
	old_scalew = scalew
	old_posw = posw
func _on_bl_button_up():
	bl = false
	old_scalew = scalew
	old_posw = posw
func _on_br_button_down():
	br = true
	old_scalew = scalew
	old_posw = posw
func _on_br_button_up():
	br = false
	old_scalew = scalew
	old_posw = posw
	

func _on_move_button_down():
	move = true

func _on_move_button_up():
	move = false


func _on_timer_timeout():
	if abs(speed) == 1:
		if frame == 1:
			texturerect.texture = sprite_speed1
			frame = 2
			timer.start(.3)
		else:
			texturerect.texture = sprite_speed1_2
			frame = 1
			timer.start(.3)
	else:
		if frame == 1:
			texturerect.texture = sprite_speed2
			frame = 2
			timer.start(.3)
		else:
			texturerect.texture = sprite_speed2_2
			frame = 1
			timer.start(.3)
		
func _on_set_speed_button_up():
	match speed:
		-4:
			speed = 1
		-1:
			speed = -4
		1:
			speed = 4
		4:
			speed = -1
	set_texture()
	Event.place.play()
	Event.emit_signal("wind_speed_update")
	

func _on_play_pressed():
	$tl.visible = false
	$tr.visible = false
	$bl.visible = false 
	$br.visible = false
	$set_speed.visible = false
	$move.visible = false
	timer.start(.3)
	state = PLAY
	
func _on_restart_pressed():
	$tl.visible = true
	$tr.visible = true
	$bl.visible = true 
	$br.visible = true
	$set_speed.visible = true
	$move.visible = true
	timer.stop()
	state = PAUSE
	

func _on_move_gui_input(event):
	if event.is_action_pressed("MWC"):
		Event.emit_signal("item_deleted",0)
		Event.delete.play()
		queue_free()
