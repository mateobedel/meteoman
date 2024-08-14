extends Node2D

@onready var click = $click
@onready var item = $item
@onready var place = $place
@onready var delete = $delete
@onready var theme = $theme
@onready var label = $CanvasLayer/Label
var start = false
var time = 0

#HOTBAR
signal selected_item(item)
signal item_placed(item)
signal item_deleted(item)

#PLAY BUTTON
signal play_pressed
signal restart_pressed

#WIND
signal wind_speed_update
signal player_wind_entered(wind)
signal player_wind_exited(wind)

signal camera_ready(camera)
signal camera_off
signal player_ready(pos)

signal trans_start
signal transition_in_done

signal level_ready(obj)

func _physics_process(delta):
	
	var secs = fmod(time,60)
	var mins = fmod(time, 60*60)/60	
	var time_passed =  "%02d : %02d" % [mins, secs]
	label.text = time_passed
	if start:
		time+=delta



