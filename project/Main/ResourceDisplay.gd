extends Node2D

# signals

# enums

# constants

# exported variables

# variables
var _ignore

# onready variables
onready var _iron_label := $IronIngots/IronLabel
onready var _iron_ore_label := $IronOre/IronOreLabel
onready var _gold_label := $GoldIngots/GoldLabel
onready var _gold_ore_label := $GoldOre/GoldOreLabel
onready var _stone_label := $Stone/StoneLabel
onready var _dirt_label := $Dirt/DirtLabel
onready var _crown_label := $Crowns/CrownLabel
onready var _pop_label := $Pop/Poplabel


func _process(_delta:float)->void:
	_dirt_label.text = str(ResourceManager.dirt)
	_iron_ore_label.text = str(ResourceManager.iron_ore)
	_iron_label.text = str(ResourceManager.iron)
	_gold_label.text = str(ResourceManager.gold)
	_gold_ore_label.text = str(ResourceManager.gold_ore)
	_stone_label.text = str(ResourceManager.stone)
	_crown_label.text = str(ResourceManager.base_crowns)
	_pop_label.text = str(ResourceManager.modifier)

