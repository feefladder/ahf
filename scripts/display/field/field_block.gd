extends FieldBlockInputs
class_name FieldBlock

var x: int
var y: int

var crop: Node
var structural_measure: Node
var measure_improvement: Node
var irrigation: Node
var fertilization: Node

onready var db: Node = get_tree().get_root().get_child(0)

func update_to_db(col_name: String):
    var resource = db.get_block_resource(x,y,col_name)
    if resource is null:
        remove(col_name)
    else:
        # assuming there is not already the same resource
        var scene = resource.placing_scene.instance()
        

func apply(a_measure: PlaceableResource):
#    resources.append(a_measure)
#    if not 
    var scene = a_measure.scene.instance()
    self.add_child(scene)
    if scene is CollisionPolygon2D:
        var sp = $SoilPoly
        sp.call_deferred("queue_free")

    applied_measures[a_measure] = scene

func remove(a_measure: PlaceableResource):
    if not a_measure in applied_measures:
        return
    applied_measures[a_measure].queue_free()
    if not applied_measures.erase(a_measure):
        print_debug("Could not erase")

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
