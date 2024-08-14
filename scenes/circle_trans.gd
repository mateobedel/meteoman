extends ColorRect
 
@onready var animation_player = $AnimationPlayer
 
func _ready():
	transition_out()
	Event.trans_start.connect(on_trans_start)

func transition_in():
	animation_player.play("trans_begin")
 
 
func transition_out():
	animation_player.play("trans_end")

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "trans_begin":
		Event.emit_signal("transition_in_done")
	else:
		visible = false

func on_trans_start():
	transition_in()
	
