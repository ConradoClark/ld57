extends Node2D

class_name Actor

var reference_transform: Node2D
var actor_id: String
var parameters: Dictionary[String,Variant]

func _ready():
  actor_id = name + "_" + str(get_instance_id())

func set_param(key: String, value: Variant):
  parameters[key] = value
