extends Button
class_name EndOfYearController

#signal next_year_requested(event)

export(PackedScene) var annual_review_packedscene = preload("res://scenes/annual_review/annual_review.tscn")
export(PackedScene) var end_of_game_packedscene = preload("res://scenes/end_of_game.tscn")
export(NodePath) var years_stat_path = NodePath("../YearsStat")
export(NodePath) var db_path = NodePath("/root/Database")


export(int) var max_years := 20

var annual_review: AnnualReview
var years_stat: Stat
var db: Database
var events : Array
var event_nothing: EventResource

func _on_resources_loaded(which, resources):
    if which == db.EVENT_SUM_TABLE:
        events = resources
        for event in resources:
            if event.resource_name == "nothing":
                event_nothing = event


func _ready():
    years_stat = get_node(years_stat_path)
    db = get_node(db_path)
    # warning-ignore:return_value_discarded
    connect("pressed",self,"_on_NextYearButton_pressed")
    # warning-ignore:return_value_discarded
    db.connect("resources_loaded", self, "_on_resources_loaded")

func get_event() -> EventResource:
    if (randi() % 10 < 4):
        return event_nothing
    # return a random event
    if events.size():
        return events[randi() % events.size()]
    else:
        printerr("no events loaded")
        return null

func _on_NextYearButton_pressed():
    if not db.increase_all_tables_years():
        print_debug("something went wrong with increasing db table years")
    get_tree().call_group("controllers","end_of_year")
    if db.year == max_years-1:
        get_tree().get_root().add_child(end_of_game_packedscene.instance())
    else:
        var event: EventResource = get_event()
        db.add_summary(db.EVENT_SUM_TABLE, {"event":event.resource_name})
        get_tree().call_group("calculators","end_of_year",event)

        annual_review = annual_review_packedscene.instance()
        get_tree().get_root().add_child(annual_review)
