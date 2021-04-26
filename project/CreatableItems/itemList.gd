extends ItemList

# signals
signal drop_item(area, item)

# enums

# constants
const ITEM_AREA := {
	"House":Vector2(1,1),
	"Statue":Vector2(1,1),
	"Gold Smelter":Vector2(2,1),
	"Iron Smelter": Vector2(2,1),
	"City":Vector2(2,2),
	"Farm":Vector2(1,1)
}

# exported variables

# variables
var _ignore
var _resources_to_build := ResourceManager.RESOURCES_TO_BUILD

# onready variables


func _on_ItemList_item_selected(index:int)->void:
	var item_name = get_item_text(index)
	var item_area = ITEM_AREA[item_name]
	if _has_resources(item_name):
		emit_signal("drop_item", item_area, item_name)
	yield(get_tree().create_timer(0.2), 'timeout')
	unselect(index)


func _has_resources(item_name:String)->bool:
	var resources_needed:Dictionary = _resources_to_build[item_name]
	for resource in resources_needed:
		var amount_available:int = ResourceManager.get(resource)
		var amount_needed:int = resources_needed[resource]
		if not amount_available >= amount_needed:
			return false
	return true
