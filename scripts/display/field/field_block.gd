extends FieldBlockInputs
class_name FieldBlock

# - keeping track of whether a measure or crop can be applied to a fieldblock

var crop_resource: CropResource
var x: int
var y: int

var has_crop := false
var has_irrigation := false
#var resources := []

#func has(something: BuyResource) -> bool:
#    for resource in resources:
#        if resource == something:
#            return true
#    return false

func apply(a_measure: PlaceableResource):
#    resources.append(a_measure)
    var scene = a_measure.scene.instance()
    self.add_child(scene)
    print(scene is CollisionPolygon2D)
    if scene is CollisionPolygon2D:
        var sp = $SoilPoly
        sp.call_deferred("queue_free")

func add_irrigation(irrigation_scene: PackedScene):
    var scene = irrigation_scene.instance()
    self.add_child(scene)

func add_crop(a_crop: CropResource):
    $Crop.texture = a_crop.image
    crop_resource = a_crop
    $Crop.position = Vector2(0,-$Crop.texture.get_size().y/2*$Crop.scale.y)
    has_crop = true

func show_crop() -> void:
    $Crop.show()

func remove_crop():
    $Crop.hide()
    has_crop = false
    crop_resource = null
