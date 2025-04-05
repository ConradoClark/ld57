extends Node

class_name Player

@export var speed: float

var actor: Actor

func _ready():
  actor = Globals.get_actor(self)
  actor.set_param(Globals.Constants.ActorParams.Player, self)

func _process(delta):
  if Input.is_action_just_pressed("action"):
    PlayerEvents.on_player_interact.emit()
