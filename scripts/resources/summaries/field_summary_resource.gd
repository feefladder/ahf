extends SummaryResource
class_name FieldSummaryResource

export(Dictionary) var crop_summary
var field: FieldResource

func add_crop_data(crop: CropResource, crop_yield: float):
	if crop in crop_summary:
		crop_summary[crop]["yield"] += crop_yield
		crop_summary[crop]["area"] += field.field_block_area
	else:
		crop_summary[crop] = {"yield" : crop_yield, "area" : field.field_block_area}
	print("added: ", crop, "to summary, summary is now: ", crop_summary)
