extends EventResource
class_name YieldEventResource

export(Resource) var affected_crop = CropResource
export(Resource) var ameliorating_resource

export(float, 0.0, 1.0, 0.05) var yield_reduction = 0.8
export(float, 0.0, 1.0, 0.05) var ameliorated_yield_reduction = 0.0

func calc_yield_reduction(b_dict: Dictionary) -> float:
    if not (b_dict["crop"] == affected_crop.resource_name or b_dict["crop_resource"] is affected_crop):
        #no extra yield reduction
        return 0.0
    if ameliorating_resource.resource_name == b_dict["structural_measure"]:
            return ameliorated_yield_reduction
    return yield_reduction
