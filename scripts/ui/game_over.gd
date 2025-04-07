extends Node

class_name GameOver

@export var screen: Control

var wait_input: bool

func _ready():
  PlayerEvents.on_game_over.connect(_on_over)

func _on_over():
  Globals.player.controller.input_blocker.block("game_over")
  screen.visible = true
  wait_input = true

func _process(delta):
  if not wait_input: return
  if Input.is_action_just_pressed("action"):
    wait_input = false
    Globals.change_scene.call_deferred("res://scenes/main.tscn")
