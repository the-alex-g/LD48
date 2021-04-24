extends Node2D

# signals

# enums

# constants

# exported variables
export var air_at_top := 3

# variables
var _ignore
var _drill_locations := {}

# onready variables
onready var _tile_map := $TileMap


func _ready()->void:
	_tile_map.generate_map(air_at_top)


func _on_Drill_drill(location:Vector2, drill:Drill)->void:
	var map_location:Vector2 = _tile_map.mine(location)
	_drill_locations[map_location] = drill


func _on_TileMap_tile_destroyed(tile_position:Vector2)->void:
	var drill:Drill = _drill_locations[tile_position]
	drill.move()
