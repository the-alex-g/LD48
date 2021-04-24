extends HBoxContainer

# signals

# enums

# constants

# exported variables

# variables
var _ignore

# onready variables
onready var _iron_label := $Iron
onready var _iron_ore_label := $IronOre
onready var _gold_label := $Gold
onready var _gold_ore_label := $GoldOre
onready var _stone_label := $Stone
onready var _dirt_label := $Dirt


func _process(_delta:float)->void:
	_dirt_label.text = "Dirt: "+str(ResourceManager.dirt)
	_iron_ore_label.text = "Iron Ore: "+str(ResourceManager.iron_ore)
	_iron_label.text = "Iron: "+str(ResourceManager.iron)
	_gold_label.text = "Gold: "+str(ResourceManager.gold)
	_gold_ore_label.text = "Gold Ore: "+str(ResourceManager.gold_ore)
	_stone_label.text = "Stone: "+str(ResourceManager.stone)

