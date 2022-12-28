extends BuyMenu
class_name MeasuresHandler

export(NodePath) var asset_manager_path = NodePath("../../AssetManager")
export(NodePath) var field_path = NodePath("../../Background/Field")

var current_resource: BuyResource
var state: Node

onready var asset_manager: AssetManager = get_node(asset_manager_path)
onready var field: Field = get_node(field_path)

#func _ready():
#    printerr(connect("deactivated", self, "_on_deactivate"))
#    printerr(connect("activated", self, "_on_activated"))

func _on_tab_changed(which: BuyMenuItem):
    if which != null:
        field.set_enable_with(which.resource)
        current_resource = which.resource
    # if current_resource:
    #     if "dirty" in current_resource:
    #         if current_resource.dirty:
    #             printerr("You have not completed your %s yet!" % current_resource.resource_name)

    # if "field" in which.resource:
    #     which.resource.field = field.field_resource
    # current_resource = which.resource
    # var min_number = get_min_number()
    # if current_resource is IrrigationResource:
    #     if asset_manager.decrease_assets(current_resource.pump_cost, current_resource.pump_labour):
    #         field.place_pump(current_resource.pump_image)
    #         current_resource.pump_placed = true
    #         set_current_measure(which)
    #     else:
    #         $BuyMenu/ScrollContainer/BuyMenuItemContainer.deselect()
    # if asset_manager.has_enough(min_number*which.resource.unit_price, min_number*which.resource.unit_labour):
    #         set_current_measure(which)
    # else:
    #     $BuyMenu/ScrollContainer/BuyMenuItemContainer.deselect()

func fieldblock_pressed(block: FieldBlock):
    if not current_resource:
        return

    if current_resource is MeasureImprovementResource:
        if (
                database.block_has(block.x,block.y,"structural_measure",current_resource.depends_on.resource_name) and
                database.block_empty(block.x,block.y,"measure_improvement")
            ):
                try_apply(block, "measure_improvement")
    if current_resource is StructuralMeasureResource:
        if database.block_empty(block.x,block.y,"structural_measure"):
            try_apply(block, "structural_measure")
    elif current_resource is IrrigationResource:
        if database.block_empty(block.x,block.y,"irrigation"):
            try_apply(block, "irrigation")
    elif current_resource is FertilizerResource:
        if database.block_empty(block.x,block.y,"fertilization"):
            try_apply(block, "fertilization")

func get_min_number() -> int:
    if not current_resource:
        printerr("get_min_number should be called when there is a resource!")
        return -1

    if current_resource is StructuralMeasureResource:
        return current_resource.get_min_number()
    return 1

func set_current_measure(which: BuyMenuItem):
    current_resource = which.resource
    field.set_enable_with(current_resource)

func try_apply(block: FieldBlock, col: String) -> bool:
    if not asset_manager.has_enough(current_resource.unit_price, current_resource.unit_labour):
        return false
    if not database.write_block_if_empty(block.x, block.y, col, current_resource.resource_name):
        return false
    asset_manager.decrease_assets(current_resource.unit_price, current_resource.unit_labour)
    field.disable_except(block)
    block.update_to_db(col)
    yield(block,"placed")
    field.set_enable_with(current_resource)
    return true

func next_year():
    # do nothing (there are not really measures that need to be updated or something
    pass

func start_year():
    print_debug("start_year called on ",self)
