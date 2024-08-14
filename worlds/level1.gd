extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	Event.emit_signal("level_ready",self)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
