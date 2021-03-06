extends TileMap

# signals
signal tile_destroyed

# enums

# constants
const TILE_PROGRESSION := {
	0:2,
	7:8,
	9:10,
	19:20,
}
const BREAKING_TILES := [
	0, 7, 9, 19,
]
const BREAKING_TILES_LOAD_PATHS := {
	0:"res://AnimatedTiles/DirtTileBreak.tres",
	7:"res://AnimatedTiles/GoldTileBreak.tres",
	9:"res://AnimatedTiles/IronTileBreak.tres",
	19:"res://AnimatedTiles/GrassTileBreaking.tres",
}
const EMPTY_UNDERGROUND_TILE := 1
const CELL_SIZE := 32
const NAME_TO_TILE_ABV := {
	"House":3,
	"Statue":5,
	"Gold Smelter":12,
	"Iron Smelter":14,
	"City":15,
	"Farm":18,
}
const NAME_TO_TILE_BLW := {
	"House":4,
	"Statue":6,
	"Gold Smelter":11,
	"Iron Smelter":13,
	"City":16,
	"Farm":17,
}
const UNDERGROUND_DEPENDENT_TILES := [
	4, 6, 11, 13, 16, 17
]
const ABOVEGROUND_DEPENDENT_TILES := [
	3, 5, 12, 14, 15, 18
]
const TILES_TO_RESOURCES := {
	2:["dirt"], 8:["gold_ore", "stone"], 10:["iron_ore", "stone"], 20:["dirt"],
}
const GROUND_TILES := [0, 0, 0, 0, 0, 7, 9, 9,]
const TILES_WORTH_CROWNS := {4:1, 5:2, 6:2, 3:1, 11:-1, 12:-1, 13:-1, 14:-1, 15:6, 16:6,}
const GOLD_SMELTERS := [11, 12]
const IRON_SMELTERS := [13, 14]
const FARMS := [17, 18]
const BUILDINGS := [3, 4]
const CITY := [16, 15]
const CELLS_ABOVE_TO_CHECK := [Vector2.UP, Vector2.LEFT+Vector2.UP]
# 0: dirt tile 1: empty underground tile 2: breaking dirt tile
# exported variables

# variables
var _ignore
var _screensize := Vector2.ZERO
var _screensize_as_cells := Vector2.ZERO

# onready variables
onready var _b_collapse := $BCollapse
onready var _collapse := $Collapse


func _ready()->void:
	randomize()
	_screensize = get_viewport_rect().size
	_screensize_as_cells = _screensize/CELL_SIZE


func mine(mining_position:Vector2, speed:float):
	var tile_position = world_to_map(mining_position)
	_advance_tile(tile_position, speed)


func _advance_tile(tile_position:Vector2, speed:float)->void:
	var tile = get_cellv(tile_position)
	if TILE_PROGRESSION.has(tile):
		var next_tile:int = TILE_PROGRESSION[tile]
		set_cellv(tile_position, next_tile)
		if BREAKING_TILES.has(tile):
			_start_break_timer(tile, tile_position, next_tile, speed)
	else:
		emit_signal("tile_destroyed")


func _start_break_timer(tile:int, tile_position:Vector2, next_tile:int, speed:float)->void:
	var path:String = BREAKING_TILES_LOAD_PATHS[tile]
	var animated_tile:AnimatedTexture = load(path)
	var anim_length:float = animated_tile.frames/animated_tile.fps/speed
	tile_set.tile_get_texture(next_tile).set_current_frame(0)
	var timer := Timer.new()
	timer.wait_time = anim_length
	_ignore = timer.connect("timeout", self, "_on_BreakTimer_timeout", [tile_position, timer])
	add_child(timer)
	timer.start()


func _on_BreakTimer_timeout(tile_position:Vector2, timer:Timer)->void:
	# get rid of the timer
	timer.stop()
	timer.queue_free()
	_collapse.play()
	# check if the tile yeilds resources
	if TILES_TO_RESOURCES.has(get_cellv(tile_position)):
		var resources:Array = TILES_TO_RESOURCES[get_cellv(tile_position)]
		for resource in resources:
			ResourceManager.set(resource, ResourceManager.get(resource)+1)
	# blank out the cell
	set_cellv(tile_position, EMPTY_UNDERGROUND_TILE)
	# check if the cell above is a droppable item
	for cell in CELLS_ABOVE_TO_CHECK:
		var new_cell:Vector2 = tile_position+cell
		var tile := get_cellv(new_cell)
		if (GOLD_SMELTERS.has(tile) or IRON_SMELTERS.has(tile)) or cell == Vector2.UP:
			if UNDERGROUND_DEPENDENT_TILES.has(tile):
				set_cellv(new_cell, EMPTY_UNDERGROUND_TILE)
				_b_collapse.play()
			elif ABOVEGROUND_DEPENDENT_TILES.has(tile):
				set_cellv(new_cell, -1)
				_b_collapse.play()
			if TILES_WORTH_CROWNS.has(tile):
				ResourceManager.crowns -= TILES_WORTH_CROWNS[tile]
			if FARMS.has(tile):
				ResourceManager.food -= 1
				ResourceManager.population += 1
			if BUILDINGS.has(tile):
				ResourceManager.population -= 1
	var tile := get_cellv(tile_position+Vector2(0,-2))
	if CITY.has(tile):
		if UNDERGROUND_DEPENDENT_TILES.has(tile):
			set_cellv(tile_position+Vector2(0,-2), EMPTY_UNDERGROUND_TILE)
		elif ABOVEGROUND_DEPENDENT_TILES.has(tile):
			set_cellv(tile_position+Vector2(0,-2), -1)
		ResourceManager.population -= 2
		_b_collapse.play()
	tile = get_cellv(tile_position+Vector2(-1,-2))
	if CITY.has(tile):
		if UNDERGROUND_DEPENDENT_TILES.has(tile):
			set_cellv(tile_position+Vector2(-1,-2), EMPTY_UNDERGROUND_TILE)
		elif ABOVEGROUND_DEPENDENT_TILES.has(tile):
			set_cellv(tile_position+Vector2(-1,-2), -1)
		ResourceManager.population -= 2
		_b_collapse.play()
	# emit the signal
	emit_signal("tile_destroyed")


func generate_map(below:int = 0)->void:
	var generation_range_y := _screensize_as_cells.y-below-1
	var generation_range_x := _screensize_as_cells.x
	var start_generating_at := below
	var gold := 0
	var iron := 0
	# randomly generate tiles
	for column in generation_range_x:
		for row in generation_range_y:
			row += start_generating_at+1
			var tile_index = randi()%GROUND_TILES.size()
			var tile:int = GROUND_TILES[tile_index]
			if tile == 7:
				gold += 1
			elif tile == 9:
				iron += 1
			set_cell(column, row, tile)
	# make sure there is at least 5 gold and 5 iron
	while iron < 5:
		var x = randi()%9
		var y = randi()%(10-start_generating_at-1)+start_generating_at+1
		#y += start_generating_at+1
		if get_cell(x,y) != 9 and get_cell(x,y) != 7:
			set_cell(x,y,9)
			iron += 1
	while gold < 5:
		var x = randi()%9
		var y = randi()%(10-start_generating_at-1)+start_generating_at+1
		#y += start_generating_at+1
		if get_cell(x,y) != 9 and get_cell(x,y) != 7:
			set_cell(x,y,7)
			gold += 1
	# add the layer of grass tiles on top
	for cell in generation_range_x:
		set_cell(cell, start_generating_at, 19)


func check_position(points:Array)->bool:
	for point in points:
		var point_on_map := world_to_map(point)
		var tile := get_cellv(point_on_map)
		if tile != -1 and tile != EMPTY_UNDERGROUND_TILE:
			return false
		if get_cellv(point_on_map+Vector2(0,1)) == EMPTY_UNDERGROUND_TILE and not points.has(point+Vector2(0,32)):
			return false
		elif points.has(Vector2(0, 32)):
			if get_cellv(point_on_map+Vector2(0,2)) == EMPTY_UNDERGROUND_TILE:
				return false
			if get_cellv(point_on_map+Vector2(1,2)) == EMPTY_UNDERGROUND_TILE:
				return false
		elif points.has(Vector2(32,0)):
			if get_cellv(point_on_map+Vector2(1,1)) == EMPTY_UNDERGROUND_TILE:
				return false
	return true


func place(item_name:String, location:Vector2)->void:
	var tile_location := world_to_map(location)
	var tile := 0
	if get_cellv(tile_location) == EMPTY_UNDERGROUND_TILE:
		tile = NAME_TO_TILE_BLW[item_name]
	else:
		tile = NAME_TO_TILE_ABV[item_name]
	set_cellv(tile_location, tile)
	if TILES_WORTH_CROWNS.has(tile):
		ResourceManager.crowns += TILES_WORTH_CROWNS[tile]
	var resources_needed:Dictionary = ResourceManager.RESOURCES_TO_BUILD[item_name]
	for resource in resources_needed:
		ResourceManager.set(resource, ResourceManager.get(resource)-resources_needed[resource])
		if item_name == "Building":
			ResourceManager.population += 1
		if item_name == "Farm":
			ResourceManager.food += 1
		if item_name == "City":
			ResourceManager.population += 2


func check_smelters()->void:
	var used_tiles := get_used_cells()
	for tile in used_tiles:
		var tile_index := get_cellv(tile)
		if GOLD_SMELTERS.has(tile_index):
			if ResourceManager.gold_ore > 0:
				ResourceManager.gold_ore -= 1
				ResourceManager.gold += 1
		if IRON_SMELTERS.has(tile_index):
			if ResourceManager.iron_ore > 0:
				ResourceManager.iron_ore -= 1
				ResourceManager.iron += 1
