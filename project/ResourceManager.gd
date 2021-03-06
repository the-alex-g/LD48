extends Node

# signals

# enums

# constants
const RESOURCES_TO_BUILD := {
	"House":{"dirt":1},
	"Statue":{"stone":2},
	"Gold Smelter":{"stone":2, "gold_ore":1},
	"Iron Smelter":{"stone":2, "iron_ore":1},
	"City":{"stone":8, "iron":4, "gold":4},
	"Farm":{"dirt":1, "population":1}
}
const CONFIG_PATH := "user://settings.cfg"

# exported variables

# variables
var _ignore
var gold_ore := 0
var dirt := 0
var iron_ore := 0
var iron := 0
var gold := 0
var stone := 0
var base_crowns := 0
var crowns := 0
var population := 1
var modifier := 0
var food := 0
var high_score := 0
var config := ConfigFile.new()

# onready variables


func _ready()->void:
	load_high()


func _process(_delta:float)->void:
	modifier = max(max(population,1)/max(food,1), 1)
	base_crowns = crowns/modifier


func save_high(new_high:int = high_score)->void:
	config.set_value("save", "highscore", new_high)
	_ignore = config.save(CONFIG_PATH)


func load_high()->void:
	var err := config.load(CONFIG_PATH)
	if err == OK:
		high_score = config.get_value("save", "highscore", 0)


func reset()->void:
	gold = 0
	gold_ore = 0
	iron = 0
	iron_ore = 0
	dirt = 0
	stone = 0
	population = 1
	food = 0
	base_crowns = 0
	crowns = 0
	modifier = 0
	load_high()
