extends SummaryResource
class_name FieldSummaryResource

export(Dictionary) var crop_summary
var start_fertility: FertilityResource

func add_crop_data(crop: CropResource, crop_yield: float):
    if crop in crop_summary:
        crop_summary[crop]["yield"] += crop_yield
        crop_summary[crop]["area"] += start_fertility.field_block_area
    else:
        crop_summary[crop] = {"yield" : crop_yield, "area" : start_fertility.field_block_area}
