extends Node2D

# signals
signal check_position(points)

# enums

# constants

# exported variables

# variables
var _ignore
var area := Vector2.ZERO
var disabled := true

# onready variables


func _input(event:InputEvent)->void:
	if disabled:
		return
	if event is InputEventMouseButton and event.is_pressed():
		if event.button_index == BUTTON_LEFT:
			var points:PoolVector2Array = []
			for pos in get_children():
				points.append(pos.get_global_transform().origin)
			emit_signal("check_position", points)
		elif event.button_index == BUTTON_RIGHT:
			done()


func _process(_delta:float)->void:
	if disabled:
		return
	position = get_global_mouse_position()


func new_item(new_area:Vector2)->void:
	visible = true
	SelectionManager.can_be_selected = false
	area = new_area
	add_points()
	update()
	disabled = false


func add_points()->void:
	for row in area.x:
		var offset := Vector2.ZERO
		if area.x > 1:
			offset.x -= 16
		if area.y > 1:
			offset.y -= 16
		for column in area.y:
			var tile_position = Position2D.new()
			tile_position.position = Vector2(row*32+offset.x, column*32+offset.y)
			add_child(tile_position)


func _draw()->void:
	var size = area*32
	draw_rect(Rect2(-size/2, size), Color(0.5, 0.5, 0.5, 0.5))
	for pos in get_children():
		draw_circle(pos.position, 3, Color.red)


func done()->void:
	visible = false
	for pos in get_children():
		pos.queue_free()
	SelectionManager.can_be_selected = true
	disabled = true
