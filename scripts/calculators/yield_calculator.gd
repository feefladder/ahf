extends CalculatorEOY

# - crop and fertility calculations at the end of the year
var field: FieldResource
var block_matrix: Array

func _ready():
    summary = FieldSummaryResource.new()
    summary.type = CropResource
    summary.field = get_parent().field_resource
    block_matrix = get_parent().field_block_matrix

func make_summary():
    for row in block_matrix:
        for block in row:
            calculate_yield(block)

func calculate_yield(block: FieldBlock) -> void:
    if not block.has_crop:
        return

    var final_yield = block.crop_resource.max_yield
    if not block.has_irrigation:
        final_yield *= block.crop_resource.f_wlimited_yield
    final_yield *= block.crop_resource.f_actual_yield
    final_yield *= summary.field.field_block_area
    summary.add_crop_data(block.crop_resource, final_yield)
