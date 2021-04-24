extends Node2D

# signals

# enums

# constants

# exported variables
export var air_at_top := 3

# variables
var _ignore
var _pending_item := ""

# onready variables
onready var _tile_map := $TileMap
onready var _drill := $Drill
onready var _item_patch := $ItemArea


func _ready()->void:
	_tile_map.generate_map(air_at_top)
	var drill_position := (randi()%9)*32
	_drill.margin_left = drill_position
	_drill.margin_right = drill_position+32


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
