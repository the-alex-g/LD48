extends Node

# signals

# enums

# constants
const RESOURCES_TO_BUILD := {
	"Building":{"dirt":1},
	"Statue":{"stone":1},
	"Gold Smelter":{"stone":2, "gold_ore":1},
	"Iron Smelter":{"stone":2, "iron_ore":1},
	"City":{"stone":8, "iron":4, "gold":2},
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
var crowns := 0

# onready variables

