extends Node
class_name FamilyDisplay

export(NodePath) var loader_path = "/root/Loader"
export(String) var my_resource_name = "people_resource"
onready var loader = get_node(loader_path)

# Called when the node enters the scene tree for the first time.
func _ready():
    assert(loader.connect("resources_loaded", self, "_on_loader_resources_loaded") == 0)

func _on_loader_resources_loaded(which: String, resources: Array):
    if which == my_resource_name:
        for resource in resources:
            print("people received: ", resource)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass
