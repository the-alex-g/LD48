extends Node

# signals

# enums

# constants

# exported variables

# variables
var _ignore
var hovered:Selectable = null
var selected:Selectable = null

# onready variables


func _input(event:InputEvent)->void:
	if hovered == null and selected == null:
		return
	elif event is InputEventMouseButton and event.is_pressed():
		if event.button_index == BUTTON_LEFT and selected == null:
			print("SELECTED")
			selected = hovered
			selected.selected = true
			selected.emit_signal("selection_state_changed", true)
		elif event.button_index == BUTTON_RIGHT:
			print("DESELECTED")
			selected.selected = false
			selected.emit_signal("selection_state_changed", false)
			selected = null
