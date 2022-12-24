extends AnnualReviewBase

var event: EventResource

func show_review():
    var event_name = db.get_summary(db.EVENT_SUM_TABLE)[0]["event"]
    if event_name:
        event = db.static_resources[db.EVENT_SUM_TABLE][event_name]
    else:
        event = db.static_resources[db.EVENT_SUM_TABLE]["nothing"]
    $EventText.text = event.description
    $VBoxContainer/EventImage.texture = event.image
    $VBoxContainer/EventTitle.text = event.resource_name
