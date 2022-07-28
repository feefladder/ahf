extends Sprite
class_name FieldBlock

signal hovered(which)
signal mouse_clicked(which)

var crop_resource: CropResource
var has_crop = false

func _on_FieldBlockCollisionArea_input_event(viewport, event, shape_idx):
    if(event is InputEventMouseButton and event.pressed):
        emit_signal("mouse_clicked",self)


func _on_FieldBlockCollisionArea_mouse_entered():
    emit_signal("hovered", self)

func plant_crop(a_crop: CropResource):
    $Crop.texture = a_crop.image
    crop_resource = a_crop
    has_crop = true
    $Crop.show()

func remove_crop():
    $Crop.hide()
    has_crop = false
    crop_resource = null
