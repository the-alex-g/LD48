class_name Drill
extends Selectable

# signals
signal drill(location, drill)

# enums

# constants

# exported variables

# variables
var _mine_direction := Vector2.ZERO

# onready variables
onready var _mine_location := $MineLocation
onready var _mine_direction_handler := $MineDirectionHandler
onready var _tween := $Tween


func _ready()->void:
	_mine_direction_handler.enable(false)


func _on_MineDirectionHandler_mine_direction_changed(direction:Vector2)->void:
	var new_direction := 0.0
	match direction:
		Vector2.DOWN:
			new_direction = 0
		Vector2.UP:
			new_direction = PI
		Vector2.LEFT:
			new_direction = PI/2
		Vector2.RIGHT:
			new_direction = 3/4*PI
	_mine_location.rotation = new_direction
	_mine_direction = direction
	_drill()
	_deselect()


func _drill()->void:
	emit_signal("drill", _mine_location.get_global_transform().origin, self)


func _on_Drill_selection_state_changed(selected:bool)->void:
	_mine_direction_handler.enable(selected)


func move()->void:
	var offset := Vector2.ZERO
	match _mine_direction:
		Vector2.UP:
			offset.y -= 32
		Vector2.DOWN:
			offset.y += 32
		Vector2.RIGHT:
			offset.x += 32
		Vector2.LEFT:
			offset.x -= 32
	var left_margin := margin_left
	var right_margin := margin_right
	var bottom_margin := margin_bottom
	var top_margin := margin_top
	_tween.interpolate_property(self, "margin_left", null, left_margin+offset.x, 1.0)
	_tween.interpolate_property(self, "margin_right", null, right_margin+offset.x, 1.0)
	_tween.interpolate_property(self, "margin_top", null, top_margin+offset.y, 1.0)
	_tween.interpolate_property(self, "margin_bottom", null, bottom_margin+offset.y, 1.0)
	_tween.start()
