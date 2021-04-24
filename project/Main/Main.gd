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


func _ready()->void:
	_tile_map.generate_map(air_at_top)


func _mine_at(mining_position:Vector2)->void:
	_tile_map.mine(mining_position)
