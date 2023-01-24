extends EventResource
class_name PriceEventResource
# an event that changes the price of affected items (tbd by calculator

export(Array) var affected_items = [CropResource]

export(float, -1.0, 1.0, 0.05) var price_change = -0.1
#

func calc_price_change(resource: Resource) -> float:
    for affected_item in affected_items:
        if resource is affected_item or resource == affected_item:
            return price_change
    return 0.0
