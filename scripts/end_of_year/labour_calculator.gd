extends Node
class_name LabourDBInterface
# this script checks if people have changed, and forwards it to the assetmanager, so the asset_controller updates its available labour
# since people and labourers are managed both in family and labour, this node checks both
# also keeps track of schools


onready var database = get_parent()
onready var db = get_parent().db


