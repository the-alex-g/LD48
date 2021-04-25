extends Control

# signals

# enums

# constants

# exported variables

# variables
var _ignore

# onready variables
onready var _button := $ButtonPress


func _ready()->void:
	Jukebox.main_loop.play()


func _on_Play_pressed()->void:
	_button.play()
	yield(get_tree().create_timer(0.2), "timeout")
	_ignore = get_tree().change_scene("res://Main/Main.tscn")


func _on_Credits_pressed()->void:
	$AnimationPlayer.play("Rise")
	_button.play()


func _on_Back_pressed()->void:
	$AnimationPlayer.play("Fall")
	_button.play()
