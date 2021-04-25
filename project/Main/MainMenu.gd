extends Control

# signals

# enums

# constants

# exported variables

# variables
var _ignore

# onready variables



func _on_Play_pressed()->void:
	_ignore = get_tree().change_scene("res://Main/Main.tscn")


func _on_Credits_pressed()->void:
	$AnimationPlayer.play("Rise")


func _on_Back_pressed()->void:
	$AnimationPlayer.play("Fall")
