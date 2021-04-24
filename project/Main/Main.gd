extends Node2D

# signals

# enums

# constants

# exported variables
export var air_at_top := 3

# variables
var _ignore

# onready variables
onready var _tile_map := $TileMap
onready var _drill := $Drill


func _ready()->void:
	_tile_map.generate_map(air_at_top)
	var drill_position := (randi()%9)*32
	_drill.margin_left = drill_position
	_drill.margin_right = drill_position+32


func _on_Drill_drill(location:Vector2, speed:float)->void:
	_tile_map.mine(location, speed)


func _on_TileMap_tile_destroyed()->void:
	_drill.move()
