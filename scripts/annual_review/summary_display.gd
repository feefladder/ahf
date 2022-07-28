extends Node
class_name IncomeDisplay

export(NodePath) var crop_sum_container_path

onready var crop_sum_container: CropSummaryContainer = get_node(crop_sum_container_path)

func make_summary(
        field: FieldSummaryResource,
        _animals: AnimalSummaryResource,
        _assets: AssetSummaryResource) -> void:
    crop_sum_container.add_crop_summary(field)

