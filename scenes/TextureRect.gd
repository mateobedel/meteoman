extends TextureRect

var t = 0.

# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.start(16/3)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	scale.x = .5  -cos(t*6*PI)/20
	scale.y = .5  -sin(t*6*PI)/20
	t+=delta
	clamp(t,-2*PI,2*PI)


func _on_timer_timeout():
	$AnimationPlayer.play("troississe")
	$Timer.start(16/3)
