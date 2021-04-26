extends Node2D

# signals

# enums

# constants
const GROUND_TILES := [0, 0, 0, 0, 0, 7, 9, 9,]

# exported variables

# variables
var _ignore

# onready variables
onready var _tilemap := $TileMap

func _ready()->void:
	for row in 10:
		for column in 9:
			var tile_index = randi()%GROUND_TILES.size()
			var tile = GROUND_TILES[tile_index]
			_tilemap.set_cell(row, column, tile)


func _input(event:InputEvent)->void:
	if event is InputEventMouseButton and event.is_pressed():
		_ignore = get_tree().change_scene("res://Main/MainMenu.tscn")
