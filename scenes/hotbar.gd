extends Control

@onready var grid_container = $GridContainer


const hotbar_button_scene = preload("res://scenes/hotbar_button.tscn")
var item_selected = -1
var level=null

enum {WIND, RAIN, TORNADO, PIGEON}

const wind_scene = preload("res://scenes//wind.tscn")
const rain_scene = preload("res://scenes/rain.tscn")
const tornado_scene = preload("res://scenes/tornado.tscn")
const pigeon_scene = preload("res://scenes/pigeon.tscn")

@export var inventory = {
	WIND : 1,
	RAIN : 1,
	TORNADO : 1,
	PIGEON : 1
}
	
# Called when the node enters the scene tree for the first time.
func _ready():
	Event.selected_item.connect(_on_select_item)
	Event.play_pressed.connect(_on_play_pressed)
	Event.restart_pressed.connect(_on_restart_pressed)
	Event.level_ready.connect(_on_level_ready)
	Event.item_deleted.connect(_on_deleted_item)
	
	for item in inventory:
		if inventory[item] != 0:
			var hotbar_button = hotbar_button_scene.instantiate()
			hotbar_button.item_id = item
			hotbar_button.amount = inventory[item]
			grid_container.add_child(hotbar_button)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_right_click") && item_selected != -1 && inventory[item_selected] > 0:
		var scene_pos = Event.get_local_mouse_position()
		var scene
		match item_selected:
			WIND:
				scene_pos = Event.get_local_mouse_position() - Vector2(64,128)
				scene = wind_scene
			RAIN:
				scene_pos = Event.get_local_mouse_position() - Vector2(0,64)
				scene = rain_scene
			TORNADO:
				scene_pos = Event.get_local_mouse_position() - Vector2(0,64)
				scene = tornado_scene
			PIGEON:
				scene_pos = Event.get_local_mouse_position() - Vector2(0,64)
				scene = pigeon_scene
		var item = scene.instantiate()
		item.position = scene_pos
		Event.place.play()
		if (level!=null):
			level.add_child(item)
		
		inventory[item_selected] -= 1
		Event.emit_signal("item_placed", item_selected)
			
		
	queue_redraw()

func _draw():
	if item_selected != -1:
		var mouse_pos = get_local_mouse_position()
		var color = Color(1,1,1)
		var offset = Vector2.ONE*64*Camera.zoom
		var rect = Rect2(mouse_pos-offset,offset*Vector2.ONE*2)
		draw_rect(rect, color, false)

func _on_select_item(item):
	item_selected = item
	
func _on_play_pressed():
	item_selected = -1
	visible = false
	
func _on_restart_pressed():
	visible = true
	
func _on_level_ready(obj):
	level = obj
	
func _on_deleted_item(item):
	inventory[item] += 1
