extends TileMap

# signals

# enums

# constants
const TILE_PROGRESSION := {
	0:2,
	2:1,
}
const BREAKING_TILES := [
	2,
]
const BREAKING_TILES_LOAD_PATHS := {
	2:"res://AnimatedTiles/DirtTileBreak.tres"
}

# exported variables

# variables
var _ignore

# onready variables


func _input(event:InputEvent)->void:
	if event is InputEventMouseButton and event.is_pressed():
		var mouse_position := get_global_mouse_position()
		var tile_position := world_to_map(mouse_position)
		print(tile_position)
		_advance_tile(tile_position)


func _advance_tile(tile_position:Vector2)->void:
	var tile = get_cellv(tile_position)
	print(tile)
	if TILE_PROGRESSION.has(tile):
		var next_tile = TILE_PROGRESSION[tile]
		set_cellv(tile_position, next_tile)
		if BREAKING_TILES.has(tile):
			_start_break_timer(tile, tile_position)


func _start_break_timer(tile:int, tile_position:Vector2)->void:
	var path:String = BREAKING_TILES_LOAD_PATHS[tile]
	var animated_tile:AnimatedTexture = load(path)
	var anim_length:float = animated_tile.fps*animated_tile.frames
	var timer := Timer.new()
	timer.wait_time = anim_length
	timer.connect("timeout", self, "_on_BreakTimer_timeout", [tile_position])
