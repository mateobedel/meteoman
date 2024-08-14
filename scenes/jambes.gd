extends Area2D

@export_file("*.tscn") var niveau_suivant = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	Event.transition_in_done.connect(on_transition_in_done)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	

func _on_body_entered(body):
	if body is Player && !body.mort:
		body.gagner = true
		$AudioStreamPlayer.play()
		Event.emit_signal("trans_start")
		
		
func on_transition_in_done():
	get_tree().change_scene_to_file(niveau_suivant)
	
	
	


