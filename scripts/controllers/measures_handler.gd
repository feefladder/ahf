extends BuyMenu
class_name MeasuresHandler

export(NodePath) var asset_manager_path = "../../AssetManager"
export(NodePath) var field_path = "../../Background/Field"

var current_resource: BuyResource
var state: Node

onready var asset_manager = get_node(asset_manager_path)
onready var field = get_node(field_path)

#func _ready():
#    assert(connect("deactivated", self, "_on_deactivate") == 0)
#    assert(connect("activated", self, "_on_activated") == 0)

func _on_tab_changed(which: BuyMenuItem):
    if current_resource:
        if "dirty" in current_resource:
            if current_resource.dirty:
                printerr("You have not completed your %s yet!" % current_resource.resource_name)

    if "field" in which.resource:
        which.resource.field = field.field_resource
    current_resource = which.resource
    var min_number = get_min_number()
    print("tab changed to:", current_resource.resource_name)
    if current_resource is IrrigationResource:
        if asset_manager.decrease_assets(current_resource.pump_cost, current_resource.pump_labour):
            field.place_pump(current_resource.pump_image)
            current_resource.pump_placed = true
            set_current_measure(which)
        else:
            $BuyMenu/ScrollContainer/BuyMenuItemContainer.deselect()
    
    if asset_manager.has_enough(min_number*which.resource.unit_price, min_number*which.resource.unit_labour):
            set_current_measure(which)
    else:
        $BuyMenu/ScrollContainer/BuyMenuItemContainer.deselect()

func fieldblock_pressed(a_block: FieldBlock):
    if not current_resource:
        return

    if current_resource is MeasureResource:
        if not a_block in current_resource.blocks_placed:
            try_apply_measure(a_block)
    elif current_resource is IrrigationResource:
        if not a_block  in current_resource.blocks_placed:
            try_apply_irrigation(a_block)
    elif current_resource is FertilizerResource:
        if not a_block in current_resource.blocks_placed:
            try_apply_fertilizer(a_block)

func get_min_number() -> int:
    if not current_resource:
        printerr("get_min_number should be called when there is a resource!")
        return -1

    if current_resource is MeasureResource:
        return current_resource.get_min_number()
    return 1

func set_current_measure(which: BuyMenuItem):
    current_resource = which.resource
    if "field" in current_resource:
        current_resource.field = field.field_resource

    field.set_enable_with_measure(current_resource)


func try_apply_measure(a_block: FieldBlock):
    if a_block in current_resource.blocks_placed:
        return
    if not asset_manager.decrease_assets(current_resource.unit_price, current_resource.unit_labour):
        return

    field.disable_except(a_block)

    var placing_scene = current_resource.placing_scene.instance()
    placing_scene.measure = current_resource
    a_block.add_child(placing_scene)

    yield(placing_scene, "applied")
    field.set_enable_with_measure(current_resource)

func try_apply_irrigation(a_block: FieldBlock):
    if not current_resource is IrrigationResource:
        printerr("Tried to apply irriration with: ", current_resource.resource_name)
        return
    
    if not asset_manager.decrease_assets(current_resource.unit_price, current_resource.unit_labour):
        return

    a_block.apply(current_resource) 
    current_resource.blocks_placed.append(a_block)
    field.set_enable_with_measure(current_resource)

func try_apply_fertilizer(a_block: FieldBlock):
    printerr("Applying fertilizer not implemented yet!")
