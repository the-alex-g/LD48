extends TileMap

# signals
signal tile_destroyed(tile_position)

# enums

# constants
const TILE_PROGRESSION := {
	0:2,
}
const BREAKING_TILES := [
	0,
]
const BREAKING_TILES_LOAD_PATHS := {
	0:"res://AnimatedTiles/DirtTileBreak.tres",
}
const EMPTY_UNDERGROUND_TILE := 1
const CELL_SIZE := 32
# 0: dirt tile 1: empty underground tile 2: breaking dirt tile
# exported variables

# variables
var _ignore
var _screensize := Vector2.ZERO
var _screensize_as_cells := Vector2.ZERO

# onready variables


func _ready()->void:
	_screensize = get_viewport_rect().size
	_screensize_as_cells = _screensize/CELL_SIZE


func mine(mining_position:Vector2, speed:float)->Vector2:
	var tile_position = world_to_map(mining_position)
	_advance_tile(tile_position, speed)
	return tile_position


func _advance_tile(tile_position:Vector2, speed:float)->void:
	var tile = get_cellv(tile_position)
	if TILE_PROGRESSION.has(tile):
		var next_tile:int = TILE_PROGRESSION[tile]
		set_cellv(tile_position, next_tile)
		if BREAKING_TILES.has(tile):
			_start_break_timer(tile, tile_position, next_tile, speed)


func _start_break_timer(tile:int, tile_position:Vector2, next_tile:int, speed:float)->void:
	var path:String = BREAKING_TILES_LOAD_PATHS[tile]
	var animated_tile:AnimatedTexture = load(path)
	var anim_length:float = animated_tile.frames/animated_tile.fps/2/speed
	tile_set.tile_get_texture(next_tile).set_current_frame(0)
	var timer := Timer.new()
	timer.wait_time = anim_length
	_ignore = timer.connect("timeout", self, "_on_BreakTimer_timeout", [tile_position, timer])
	add_child(timer)
	timer.start()


func _on_BreakTimer_timeout(tile_position:Vector2, timer:Timer)->void:
	timer.stop()
	timer.queue_free()
	set_cellv(tile_position, EMPTY_UNDERGROUND_TILE)
	emit_signal("tile_destroyed", tile_position)


func generate_map(below:int = 0)->void:
	var generation_range_x := _screensize_as_cells.x-below
	var generation_range_y := _screensize_as_cells.y
	var start_generating_at := below
	for column in generation_range_x:
		column += start_generating_at
		for row in generation_range_y:
			set_cell(row, column, 0)

