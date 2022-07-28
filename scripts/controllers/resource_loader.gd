
extends Node
class_name ResourceLoader

signal resources_loaded(which, crop_resources)

export(String) var base_path = "res://resources/"

export(Dictionary) var resources_paths = {
    "crop_resource" : "crops/",
    "animal_resource" : "animals/",
    "labour_resource" : "labour/",
    "measures_resource" : "measures/"
}

func _ready():
    for key in resources_paths:
        emit_signal("resources_loaded", key, _load_resources(resources_paths[key]))

func _load_resources(resources_path) -> Array:
    var resources = []
    # TODO: make this class call some API endpoint whenever the game actually implements it
    var directory = Directory.new()
    directory.open(base_path + resources_path)
    directory.list_dir_begin()
    
    var filename = directory.get_next()
    while(filename):
        if not directory.current_is_dir() and filename.ends_with(".tres"):
            resources.append(load(base_path + resources_path + filename))
        filename = directory.get_next()

    return resources