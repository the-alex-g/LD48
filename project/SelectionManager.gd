extends Node

# signals

# enums

# constants

# exported variables

# variables
var _ignore
var hovered:Selectable = null
var selected:Selectable = null
var can_be_selected := true

# onready variables


func _input(event:InputEvent)->void:
	if hovered == null and selected == null:
		return
	if not can_be_selected:
		return
	elif event is InputEventMouseButton and event.is_pressed():
		if event.button_index == BUTTON_LEFT and selected == null:
			selected = hovered
			selected.selected = true
			selected.emit_signal("selection_state_changed", true)
		elif event.button_index == BUTTON_RIGHT:
			deselect()


func deselect()->void:
	selected.selected = false
	selected.emit_signal("selection_state_changed", false)
	selected = null


func reset()->void:
	selected = null
	hovered = null
	can_be_selected = true
