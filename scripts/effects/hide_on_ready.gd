extends Node

class_name HideOnReady

@export var reference: Node2D

func _ready():
  reference.visible = false
