extends Resource
class_name SummaryResource

var type = BuyResource
var dict: Dictionary #Dictionary of {resource: summary_data}

#kind of a template
func add(resource: BuyResource, amount):
    if resource in dict:
        dict[resource] += amount
    else:
        dict[resource] = amount
