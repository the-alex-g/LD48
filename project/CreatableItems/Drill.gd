class_name Drill
extends Selectable

# signals

# enums

# constants

# exported variables

# variables

# onready variables
onready var _mine_location := $MineLocation
onready var _mine_direction_handler := $MineDirectionHandler


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


func _on_Drill_selection_state_changed(selected:bool)->void:
	_mine_direction_handler.enable(selected)

