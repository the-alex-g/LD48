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
onready var _button_noise := $AudioStreamPlayer


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
	_button_noise.play()
	yield(get_tree().create_timer(0.2),"timeout")
	_ignore = get_tree().change_scene("res://Main/Main.tscn")
	ResourceManager.reset()


func _on_MainMenu_pressed():
	_button_noise.play()
	yield(get_tree().create_timer(0.2),"timeout")
	_ignore = get_tree().change_scene("res://Main/MainMenu.tscn")
	ResourceManager.reset()
	SelectionManager.reset()


func _on_ResetScore_pressed():
	_button_noise.play()
	ResourceManager.save_high(0)
	_high_score.text = "High score: 0"
	_you_got.text = "Your score: "+str(ResourceManager.base_crowns)
