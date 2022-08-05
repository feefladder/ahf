extends Node

func display_event(event: EventResource):
    $EventText.text = event.description
    $VBoxContainer/EventImage.texture = event.image
    $VBoxContainer/EventTitle.text = event.resource_name
