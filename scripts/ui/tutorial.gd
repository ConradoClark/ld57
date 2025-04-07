extends Node

class_name Tutorial

@export var screen: Control

var wait_input: bool

func _ready():
  Globals.player.controller.input_blocker.block("tutorial")
  screen.visible = true
  wait_input = true

func _process(delta):
  if not wait_input: return
  if Input.is_action_just_pressed("action"):
    wait_input = false
    screen.visible = false
    Globals.player.controller.input_blocker.unblock("tutorial")
    PlayerEvents.on_tutorial_over.emit()
