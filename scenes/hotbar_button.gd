extends Button

enum {WIND, RAIN, TORNADO, PIGEON}
var item_id = WIND
var amount = 0
@onready var label = $Label

var wind_icon = preload("res://texture/icon_wind.png")
var rain_icon = preload("res://texture/icon_rain.png")
var tornado_icon = preload("res://texture/icon_tornado.png")
var pigeon_icon = preload("res://texture/icon_pigeon.png")
# Called when the node enters the scene tree for the first time.
func _ready():
	
	Event.item_placed.connect(_on_placed_item)
	Event.item_deleted.connect(_on_deleted_item)
	
	match item_id:
		WIND:
			icon = wind_icon
		RAIN:
			icon = rain_icon
		TORNADO:
			icon = tornado_icon
		PIGEON:
			icon = pigeon_icon
		
	label.text = str(amount)


func _on_placed_item(item):
	if item == item_id:
		amount-=1
		label.text = str(amount)

func _on_deleted_item(item):
	if item == item_id:
		amount += 1
		label.text = str(amount)

			

func _on_button_down():
	Event.item.play()
	Event.emit_signal("selected_item", item_id)
