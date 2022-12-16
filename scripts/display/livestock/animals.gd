extends DisplayBase
class_name Animals

const AnimalSummaryResource = preload("res://scripts/resources/summaries/animal_summary_resource.gd")
# Prints a random floating-point number from a normal distribution with a mean 0.0 and deviation 1.0.
var random = RandomNumberGenerator.new()

var animals: Dictionary

onready var db = get_node_or_null("/root/Database")
# Called when the node enters the scene tree for the first time.
func _ready():
    random.randomize()

#func start_year():
#    update_all_to_db()

func make_summary() -> AnimalSummaryResource:
    var summary = AnimalSummaryResource.new()
    return summary

#func update_all_to_db():
#    for animal in db.get_unique_changed_items(db.LIVESTOCK_TABLE):
#        if animal["year_sold"] is null:
#

func add_animal(an_animal: AnimalResource, id: int) -> void:
    var animal_sprite = Sprite.new()
    animal_sprite.texture = an_animal.image

    var random_change = Vector2(random.randf_range(0,1), random.randf_range(0,1)) * 50
    animal_sprite.position = an_animal.spawn_point + random_change
    animal_sprite.scale = an_animal.scale
    animal_sprite.flip_h = random.randi() % 2
    self.add_child(animal_sprite)

    #add a reference
    animals[id] = animal_sprite

func remove_animal(id: int) -> void:
    animals[id].queue_free()
    animals.erase(id)
