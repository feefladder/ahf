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
    if resource == null:
        remove(col_name)
#        remove(col_name)
    else:
        place(resource, col_name)
        # assuming there is not already the same resource


func remove(what: String):
    var node = get_node_or_null(what)
    if node == null:
        # actually not always an error!
        printerr("Could not remove "+what+" from "+str(self))
    else:
        node.queue_free()

func place(r: PlaceableResource, name: String):
    print_debug("placing item: ",r.resource_name, " on ",x,",",y)
    var sprite = Sprite.new()
    sprite.name = name
    sprite.texture = r.image
    sprite.scale = r.scale
    sprite.position = r.offset
    print_debug("offset: ",r.offset," position: ",sprite.position)
    sprite.visible = false
    add_child(sprite)

    # this should free itself
    var p_scene = r.placing_scene.instance()
    p_scene.item=sprite
    add_child(p_scene)

