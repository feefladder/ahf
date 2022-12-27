extends FieldBlockInputs
class_name FieldBlock

signal placed

var x: int
var y: int
var row_width: int

onready var db: Node = get_tree().get_root().get_child(0)

func update_all_to_db() -> void:
    for col in db.field_cols:
        update_to_db(col)

func update_to_db(col_name: String) -> void:
    var resource = db.get_block_resource(x,y,col_name)
    if resource != null:
        place(resource, col_name)
        # assuming there is not already the same resource
    elif get_node_or_null(col_name) != null:
        remove(col_name)
#        remove(col_name)
   

func remove(what: String):
    var node = get_node_or_null(what)
    if node == null:
        # actually not always an error!
        printerr("Could not remove "+what+" from "+str(self))
    else:
        node.queue_free()

func place(r: PlaceableResource, name: String):
    var sprite = Sprite.new()
    sprite.name = name
    sprite.texture = r.image
    sprite.scale = r.scale
    sprite.position = r.offset
    sprite.visible = false
    add_child(sprite)

    # this should free itself
    var p_scene = r.placing_scene.instance()
    p_scene.item=sprite
    add_child(p_scene)
    yield(p_scene,"placed")
    emit_signal("placed")

func has(type: String, name: String):
    return db.block_has(x,y, type, name)

func is_empty(type: String):
    return db.block_empty(x,y,type)

func get_all_with(type: String, name: String):
    return db.get_all_blocks(type+"='"+name+"'")

func get_all_empty(type: String):
    return db.get_all_blocks(type+" IS NULL")
