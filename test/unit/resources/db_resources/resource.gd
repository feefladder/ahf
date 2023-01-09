extends Resource
class_name TestResource

export(AABB) var aabb
export(Vector2) var a_Vector2
export(Rect2) var a_Rect2
export(Vector3) var a_Vector3
export(Transform2D) var a_Transform2D
export(Plane) var a_Plane
export(Quat) var a_Quat
export(AABB) var a_AABB
export(Basis) var a_Basis
export(Transform) var a_Transform
export(Color) var a_Color

func get_class()->String:
    return "TestResource"
