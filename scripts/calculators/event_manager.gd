extends Node

export(NodePath) var loader_path = NodePath("/root/Database")
export(String) var resources_name = "events"

var events : Array

onready var loader = get_node(loader_path)

func _ready():
    loader.connect("resources_loaded", self, "_on_resources_loaded")

func _on_resources_loaded(which, resources):
    if which == resources_name:
        events = resources
        print(events)

func get_event() -> EventResource:
    if (randi() % 10 < 4):
        var event_nothing = EventResource.new()
        event_nothing.resource_name = "nothing"
        event_nothing.description = "no events happened this year"
        return event_nothing
    # return a random event
    if events.size():
        return events[randi() % events.size()]
    else:
        printerr("no events loaded")
        return null
