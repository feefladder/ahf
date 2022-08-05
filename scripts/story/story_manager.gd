extends Node

export(Resource) var story = preload("res://resources/stories/ade.tres")
export(PackedScene) var game_scene = load("res://scenes/main.tscn")

onready var story_length : int = min(story.story_images.size(), story.story_texts.size())

func _ready():
    if not (story is StoryResource):
        printerr("Not a StoryResource!, skipping to the game")
        start_game()

    if not (story.story_images.size() == story.story_texts.size()):
        printerr("story images and tetxts are different! will crop the story!")

    for n in story_length:
        draw_story(n)
        yield($Button,"pressed")

    start_game()

func draw_story(n: int):
    $Image.texture = story.story_images[n]
    $Text.text = story.story_texts[n]
    if n == story_length - 1:
        $Button.text = "Start Game!"

func start_game():
    get_tree().change_scene("res://scenes/main.tscn")
