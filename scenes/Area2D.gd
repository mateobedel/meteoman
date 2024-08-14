extends Area2D

@onready var sprite = $Sprite2D
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	sprite.rotate(-60*delta*1.5)
	
func _on_body_entered(body):
	if body is Player:
		body.player_died()
