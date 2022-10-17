extends EventResource
class_name YieldEventResource

export(Resource) var affected_crop = CropResource
export(Resource) var ameliorating_resource

export(float, 0.0, 1.0, 0.05) var yield_reduction = 0.8
export(float, 0.0, 1.0, 0.05) var ameliorated_yield_reduction = 0.0

func calc_yield_reduction(block: FieldBlock) -> float:
    if not (block.crop_resource is affected_crop or block.crop_resource == affected_crop):
        #no extra yield reduction
        return 0.0
    if ameliorating_resource and "blocks_placed" in ameliorating_resource:
        if block in ameliorating_resource.blocks_placed:
            return ameliorated_yield_reduction
    return yield_reduction
