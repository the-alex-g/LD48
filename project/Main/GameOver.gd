extends Control

# signals

# enums

# constants

# exported variables

# variables
var _ignore

# onready variables
onready var _high_score := $Panel/VBoxContainer/HighScore
onready var _you_got := $Panel/VBoxContainer/CurrentScore


func update_display()->void:
	if ResourceManager.base_crowns > ResourceManager.high_score:
		print(ResourceManager.high_score)
		ResourceManager.high_score = ResourceManager.base_crowns
		_high_score.text = "New high score!"
		_you_got.text = str(ResourceManager.crowns)
		ResourceManager.save_high()
	else:
		_high_score.text = "High score: "+str(ResourceManager.high_score)
		_you_got.text = "Your score: "+str(ResourceManager.base_crowns)


func _on_PlayAgain_pressed()->void:
	yield(get_tree().create_timer(0.2),"timeout")
	_ignore = get_tree().change_scene("res://Main/Main.tscn")
	ResourceManager.reset()


func _on_MainMenu_pressed():
	yield(get_tree().create_timer(0.2),"timeout")
	_ignore = get_tree().change_scene("res://Main/MainMenu.tscn")
	ResourceManager.reset()
	SelectionManager.reset()
