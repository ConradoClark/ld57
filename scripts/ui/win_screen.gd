extends Node

class_name WinScreen

@export var screen: Control

var wait_input: bool

func _ready():
  PlayerEvents.on_game_finished.connect(_on_win)

func _on_win():
  Globals.player.controller.input_blocker.block("win")
  screen.visible = true
  await get_tree().create_timer(2.).timeout
  wait_input = true

func _process(delta):
  if not wait_input: return
  if Input.is_action_just_pressed("action"):
    wait_input = false
    screen.visible = false
    RoomEvents.on_endless_mode.emit()
