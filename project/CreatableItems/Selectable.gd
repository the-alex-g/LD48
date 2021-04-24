class_name Selectable
extends TextureRect

# signals
# warning-ignore:unused_signal
signal selection_state_changed(selected)

# enums

# constants

# exported variables

# variables
var _ignore
var _enabled := true
var _hovered := false
var selected := false

# onready variables


func _ready()->void:
	_ignore = connect("mouse_entered", self, "_on_mouse_state_changed", [true])
	_ignore = connect("mouse_exited", self, "_on_mouse_state_changed", [false])


func _on_mouse_state_changed(entered:bool)->void:
	if entered:
		_hovered = true
		SelectionManager.hovered = self
	else:
		_hovered = false
		SelectionManager.hovered = null


func _deselect()->void:
	if selected:
		SelectionManager.deselect()


func enable(value:bool)->void:
	_enabled = value
	SelectionManager.can_be_selected = value
