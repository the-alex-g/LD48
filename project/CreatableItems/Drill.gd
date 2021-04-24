class_name Drill
extends Selectable

# signals
signal drill(location, drill, speed)

# enums

# constants
const DRILL_LOCATIONS := {
	Vector2.DOWN:"MineDown",
	Vector2.RIGHT:"MineRight",
	Vector2.UP:"MineUp",
	Vector2.LEFT:"MineLeft",
}

# exported variables
export var speed := 2.0

# variables
var _mine_direction := Vector2.ZERO

# onready variables
onready var _mine_location:Position2D = $MineDown
onready var _mine_direction_handler := $MineDirectionHandler
onready var _tween := $Tween
onready var _animation_player := $AnimationPlayer


func _ready()->void:
	_mine_direction_handler.enable(false)
	_animation_player.play("Idle")


func _on_MineDirectionHandler_mine_direction_changed(direction:Vector2)->void:
	_mine_location = get_node(DRILL_LOCATIONS[direction])
	_mine_direction = direction
	match _mine_direction:
		Vector2.UP:
			flip_v = true
		Vector2.DOWN:
			flip_v = false
		Vector2.RIGHT:
			set_rotation(3/4*PI)
		Vector2.LEFT:
			set_rotation(1/2*PI)
	_drill()
	_deselect()


func _drill()->void:
	_animation_player.play("Drilling")
	emit_signal("drill", _mine_location.get_global_transform().origin, self, speed)


func _on_Drill_selection_state_changed(selected:bool)->void:
	_mine_direction_handler.enable(selected)


func move()->void:
	var offset := Vector2.ZERO
	match _mine_direction:
		Vector2.UP:
			offset.y -= 32
			flip_v = true
		Vector2.DOWN:
			offset.y += 32
			flip_v = false
		Vector2.RIGHT:
			offset.x += 32
			set_rotation(3/4*PI)
		Vector2.LEFT:
			offset.x -= 32
			set_rotation(1/2*PI)
	var left_margin := margin_left
	var right_margin := margin_right
	var bottom_margin := margin_bottom
	var top_margin := margin_top
	_enabled = false
	_tween.interpolate_property(self, "margin_left", null, left_margin+offset.x, 1.0)
	_tween.interpolate_property(self, "margin_right", null, right_margin+offset.x, 1.0)
	_tween.interpolate_property(self, "margin_top", null, top_margin+offset.y, 1.0)
	_tween.interpolate_property(self, "margin_bottom", null, bottom_margin+offset.y, 1.0)
	_tween.start()


func _on_Tween_tween_all_completed():
	_animation_player.play("Idle")
	_enabled = true
