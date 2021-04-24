extends Node2D

# signals
signal mine_direction_changed(direction)

# enums

# constants

# exported variables

# variables
var _ignore
var _hovered:Panel = null
var _enabled := false

# onready variables


func _ready()->void:
	for panel in get_children():
		_ignore = panel.connect("mouse_entered", self, "_on_area_mouse_entered", [panel])
		_ignore = panel.connect("mouse_exited", self, "_on_area_mouse_exited")


func _on_area_mouse_entered(panel:Panel)->void:
	if _enabled:
		_hovered = panel


func _on_area_mouse_exited()->void:
	if _enabled:
		_hovered = null


func _input(event:InputEvent)->void:
	if _hovered == null or not _enabled:
		return
	elif event is InputEventMouseButton and event.is_pressed():
		if event.button_index == BUTTON_LEFT:
			var new_direction := Vector2.ZERO
			match _hovered.name:
				"Right":
					new_direction = Vector2.RIGHT
				"Left":
					new_direction = Vector2.LEFT
				"Up":
					new_direction = Vector2.UP
				"Down":
					new_direction = Vector2.DOWN
			emit_signal("mine_direction_changed", new_direction)


func enable(value:bool)->void:
	_enabled = value
	visible = value
