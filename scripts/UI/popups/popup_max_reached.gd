extends Control
class_name PopupMaxReached

func pop_up(which: IntResource):
    $Panel/Label.text = "Cannot buy any more %ss, max is %d" % [which.resource_name, which.max_number]
    self.show()
