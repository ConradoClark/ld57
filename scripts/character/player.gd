extends Node

class_name Player

@export var speed: float

const BRAINPOWER_PELLET = preload("res://scenes/effects/brainpower_pellet.tscn")
var actor: Actor
var brainpower: float = 100.
var max_brainpower: float = 100.
var brainpower_decay: float = 2.
var decaying = false

var difficulty = 0
var match_combo = 0

var controller: CharacterController:
  get: return actor.parameters[Globals.Constants.ActorParams.CharacterController] as CharacterController

func _ready():
  Globals.player = self
  actor = Globals.get_actor(self)
  actor.set_param(Globals.Constants.ActorParams.Player, self)
  RoomEvents.on_room_cleared.connect(_room_cleared)
  RoomEvents.on_room_loaded.connect(_room_loaded)
  CrystalEvents.on_crystal_matched.connect(_on_match)
  
func _on_match(matched: bool, crystal: Crystal):
  if matched:
    match_combo+=1
    FloatingText.show_text("MATCH!", crystal.active_sprite.global_position, 1.)
    await _spawn_brainpellet(crystal.active_sprite.global_position)
    recover_brain(10 * match_combo)
  else:
    match_combo = 0

func _spawn_brainpellet(pos: Vector2):
  var pellet = BRAINPOWER_PELLET.instantiate() as Actor
  pellet.global_position = pos
  Globals.object_container.add_child(pellet)
  var script = pellet.get_param(Globals.Constants.ActorParams.BrainpowerPellet) as BrainpowerPellet
  if not script: return
  script.move()
  await script.pellet_done
  PlayerEvents.on_brainpower_pellet_recover.emit()
  
func _room_cleared():
  decaying = false
  if difficulty == 0:
    difficulty = 1
  controller.input_blocker.block("room_event")

func _room_loaded(_room):
  decaying = true
  controller.input_blocker.unblock("room_event")

func _process(delta):
  if Input.is_action_just_pressed("action"):
    PlayerEvents.on_player_interact.emit()
  if decaying:
    brainpower = clamp(brainpower - delta * brainpower_decay, 0., max_brainpower)

func recover_brain(amount: float):
  if brainpower <= 0: return
  brainpower = clamp(brainpower + amount, 0., max_brainpower)
