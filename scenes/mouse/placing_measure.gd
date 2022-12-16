extends Node2D

signal applied

var measure: StructuralMeasureResource

func _ready():
    Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
    # add the block to the placed array
    measure.blocks_placed.append(get_parent())
    $Shovel/AnimationPlayer.play("dig")
    yield(get_tree().create_timer(measure.time_required), "timeout")

    Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
    Input.warp_mouse_position(get_global_position())

    #apply the measure to the block
    get_parent().apply(measure)
    emit_signal("applied")
    queue_free()
