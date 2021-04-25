extends Node2D

# signals

# enums

# constants

# exported variables
export var air_at_top := 4

# variables
var _ignore
var _pending_item := ""
var _info_shown := false
var _time_left_on_pause := 0

# onready variables
onready var _tile_map := $TileMap
onready var _drill := $Drill
onready var _item_patch := $ItemArea
onready var _info := $Panel
onready var _game_timer := $GameTimer
onready var _game_over := $GameOver


func _ready()->void:
	_tile_map.generate_map(air_at_top)
	var drill_position := (randi()%9)*32
	_drill.margin_left = drill_position
	_drill.margin_right = drill_position+32
	_game_over.visible = false
	_info.visible = false


func _input(event:InputEvent)->void:
	if not event.is_pressed():
		return
	if event is InputEventKey and event.is_pressed():
		pass


func _process(_delta:float)->void:
	$Label.text = str(ceil(_game_timer.time_left))


func _on_Drill_drill(location:Vector2, speed:float)->void:
	_tile_map.mine(location, speed)


func _on_TileMap_tile_destroyed()->void:
	_drill.move()


func _on_ItemList_drop_item(area:Vector2, item:String)->void:
	_item_patch.new_item(area)
	_pending_item = item


func _on_ItemArea_check_position(points:PoolVector2Array)->void:
	var is_okay:bool = _tile_map.check_position(points)
	if is_okay:
		_tile_map.place(_pending_item, points[0])
		_item_patch.done()


func _on_SmeltTimer_timeout()->void:
	_tile_map.check_smelters()


func _on_Info_pressed():
	if _info_shown:
		_info_shown = false
		_info.hide()
		_game_timer.paused = false
	else:
		_info_shown = true
		_info.show()
		_game_timer.paused = true


func _on_GameTimer_timeout()->void:
	_game_timer.stop()
	yield(get_tree().create_timer(1), "timeout")
	_game_over.visible = true
	_game_over.update_display()
	SelectionManager.can_be_selected = false
