extends Node
class_name CropExpensesContainer

export(PackedScene) var crop_summary_item_packedscene

func add_crop_summary(field_summary: FieldSummaryResource):
    for crop_key in field_summary.crop_summary:
        var num_placed = field_summary.crop_summary[crop_key]["area"] / field_summary.field.field_block_area
        
        var crop_item = crop_summary_item_packedscene.instance()
        crop_item.resource = crop_key
        crop_item.calculation = "%.2f x %.2f =" % [num_placed, crop_key.unit_price]
        crop_item.total = num_placed * crop_key.unit_price
        self.add_child(crop_item)
