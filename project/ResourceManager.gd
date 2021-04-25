extends Node

# signals

# enums

# constants
const RESOURCES_TO_BUILD := {
	"Building":{"dirt":1},
	"Statue":{"stone":1},
	"Gold Smelter":{"stone":2, "gold_ore":1},
	"Iron Smelter":{"stone":2, "iron_ore":1},
	"City":{"stone":8, "iron":4, "gold":4},
	"Farm":{"dirt":1, "population":1}
}

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

# onready variables


func _process(_delta:float)->void:
	modifier = max(max(population,1)/max(food,1), 1)
	base_crowns = crowns/modifier
