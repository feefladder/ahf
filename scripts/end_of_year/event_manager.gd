extends Node
class_name EventManager

export(NodePath) var database_path = NodePath("/root/Database")




onready var database = get_node(database_path)


