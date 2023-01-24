extends GutTest

var maize = CropResource.new()

func before_all():
    gut.p("initializing crops")
    maize.resource_name = "maize"
    maize.unit_price = 10

