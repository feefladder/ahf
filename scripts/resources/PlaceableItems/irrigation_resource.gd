extends PlaceableResource
class_name IrrigationResource

export(PackedScene) var scene
export(StreamTexture) var pump_image

export(float) var pump_cost = 100
export(float) var pump_labour = 10
export(float) var water_salinity

var pump_placed := false
var field : FieldResource

func should_enable(block) -> bool:
    if not pump_placed:
        return false
    if block in blocks_placed:
        return false

    if not blocks_placed.size():
        print("no blocks placed yet!")
        return block.x == field.size_x - 1 and block.y == field.size_y - 1
    else:
        for placed in blocks_placed:
            # we can expand along the edge
            if placed.x == field.size_x - 1 and block.x == field.size_x - 1 and block.y == placed.y - 1:
                return true

            #and lay horizontal lines
            if block.y == placed.y and block.x == placed.x - 1:
                return true

        return false
