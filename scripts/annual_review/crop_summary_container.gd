extends Node
class_name CropSummaryContainer

export(PackedScene) var crop_summary_item_packedscene

func add_crop_summary(field_summary: FieldSummaryResource):
    for crop_key in field_summary.crop_summary:
        var crop_item = crop_summary_item_packedscene.instance()
        crop_item.crop_resource = crop_key
        crop_item.crop_summary_data = field_summary.crop_summary[crop_key]
        crop_item.compound_fertility = field_summary.start_fertility.calc_compound_fertility()
        self.add_child(crop_item)
