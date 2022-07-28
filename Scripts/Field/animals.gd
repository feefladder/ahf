extends YSort
class_name Animals

# Prints a random floating-point number from a normal distribution with a mean 0.0 and deviation 1.0.
var random = RandomNumberGenerator.new()

var animals: Dictionary

# Called when the node enters the scene tree for the first time.
func _ready():
    random.randomize()

func add_animal(an_animal: AnimalResource) -> void:
    var animal_sprite = Sprite.new()
    animal_sprite.texture = an_animal.image
    
    var random_change = Vector2(random.randf_range(0,1), random.randf_range(0,1)) * 50
    animal_sprite.position = an_animal.spawn_point + random_change
    animal_sprite.scale = an_animal.scale
    animal_sprite.flip_h = random.randi() % 2
    self.add_child(animal_sprite)
    
    #add a reference
    if(an_animal in animals):
        animals[an_animal].append(animal_sprite)
    else:
        animals[an_animal] = [animal_sprite]


func _on_AnimalMenuItemContainer_increased_resource(an_animal: AnimalResource) -> void:
    add_animal(an_animal)


func _on_AnimalMenuItemContainer_decreased_resource(an_animal: AnimalResource) -> void:
    if an_animal in animals:
        var animal_sprite = animals[an_animal].pop_back()
        animal_sprite.queue_free()
