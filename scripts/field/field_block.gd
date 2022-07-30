extends FieldBlockInputs
class_name FieldBlock

var crop_resource: CropResource
var x: int
var y: int

var has_crop := false
var has_irrigation := false
var resources := []

func _ready():
    
    print($Crop.position)

func has(something: BuyResource) -> bool:
    for resource in resources:
        if typeof(something) == typeof(resource):
            return true
    return false

func calculate_yield(fertility: FertilityResource) -> float:
    if not has_crop:
        return 0.0
    var final_yield = crop_resource.max_yield
    if not has_irrigation:
        final_yield *= crop_resource.f_wlimited_yield
    final_yield *= crop_resource.f_actual_yield
    final_yield *= fertility.field_block_area
    return final_yield

func apply_measure(a_measure):
    resources.append(a_measure)
    var scene = a_measure.scene.instance()
    add_child(scene)
    print(scene is CollisionPolygon2D)
    if scene is CollisionPolygon2D:
        var sp = $SoilPoly
        remove_child(sp)
        sp.queue_free()

func plant_crop(a_crop: CropResource):
    $Crop.texture = a_crop.image
    crop_resource = a_crop
    $Crop.position = Vector2(0,-$Crop.texture.get_size().y/2*$Crop.scale.y)
    has_crop = true
    $Crop.show()

func remove_crop():
    $Crop.hide()
    has_crop = false
    crop_resource = null
