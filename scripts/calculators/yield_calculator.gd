extends CalculatorEOY

# - crop and fertility calculations at the end of the year
var field: FieldResource
var block_matrix: Array

func _ready():
    summary = FieldSummaryResource.new()
    summary.type = CropResource
    summary.field = get_parent().field_resource
    block_matrix = get_parent().field_block_matrix

func make_summary(event: EventResource):
    for row in block_matrix:
        for block in row:
            calculate_yield(block, event)

func calculate_yield(block: FieldBlock, event: YieldEventResource) -> void:
    if not block.has_crop:
        return

    print(event)

    # theoretical maximum yield (cannot be obtained)
    var final_yield = block.crop_resource.max_yield
    if not block.has_irrigation:
        #factor due to water stress (in case there is no irrigation)
        final_yield *= block.crop_resource.f_wlimited_yield
    #factor due to other factors (nutrients, pests, etc)
    final_yield *= block.crop_resource.f_actual_yield

    if event:
        final_yield *= (1-event.calc_yield_reduction(block))

    final_yield *= summary.field.field_block_area
    summary.add_crop_data(block.crop_resource, final_yield)
