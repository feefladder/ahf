extends EventResource
class_name CostEvent

# an event that costs a fixed amount of money
export(Resource) var ameliorating_resource
export(float) var costs
export(float) var ameliorated_costs

func get_costs() -> float:
    return ameliorated_costs if ameliorating_resource.implemented else costs
