extends ItemList

# signals
signal drop_item(area, item)

# enums

# constants
const ITEM_AREA := {
	"Building":Vector2(1,1),
	"Statue":Vector2(1,1),
}

# exported variables

# variables
var _ignore

# onready variables


func _on_ItemList_item_selected(index:int)->void:
	var item_name = get_item_text(index)
	var item_area = ITEM_AREA[item_name]
	emit_signal("drop_item", item_area, item_name)
	yield(get_tree().create_timer(0.2), 'timeout')
	unselect(index)
