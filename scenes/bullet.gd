extends Area2D

var velocity = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.start(5)
	Event.restart_pressed.connect(_on_restart_pressed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += velocity*delta


func _on_body_entered(body):
	if body is Player:
		queue_free()
		body.player_died()



func _on_timer_timeout():
	queue_free()
	
	
func _on_restart_pressed():
	queue_free()
