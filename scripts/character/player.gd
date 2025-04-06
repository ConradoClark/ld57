extends Node

class_name Player

@export var speed: float

const BRAINPOWER_PELLET = preload("res://scenes/effects/brainpower_pellet.tscn")
const BRAINPOWER_PELLET_TRANSFER = preload("res://scenes/effects/brainpower_pellet_transfer.tscn")
var actor: Actor
var brainpower: float = 100.
var max_brainpower: float = 100.
var brainpower_decay: float = 2.
var decaying = false

var memory: float = 0.
var max_memory: float = 200.
var memory_thresholds = [200, 300, 400]

var difficulty = 0
var match_combo = 0
var pellet_target: Vector2
var brain_pellet_transfer: Timer

var controller: CharacterController:
  get: return actor.parameters[Globals.Constants.ActorParams.CharacterController] as CharacterController

func _ready():
  Globals.player = self
  actor = Globals.get_actor(self)
  actor.set_param(Globals.Constants.ActorParams.Player, self)
  RoomEvents.on_room_cleared.connect(_room_cleared)
  RoomEvents.on_room_loaded.connect(_room_loaded)
  CrystalEvents.on_crystal_matched.connect(_on_match)
  brain_pellet_transfer = Timer.new()
  brain_pellet_transfer.wait_time = 0.1
  brain_pellet_transfer.timeout.connect(_spawn_transfer_brain_pellet)
  add_child(brain_pellet_transfer)
  
func _on_match(matched: bool, crystal: Crystal):
  if matched:
    match_combo+=1
    if match_combo>1:
      FloatingText.show_text("MATCH! " + str(match_combo) + "x", crystal.active_sprite.global_position, 1.)
    else: 
      FloatingText.show_text("MATCH!", crystal.active_sprite.global_position, 1.)
    await _spawn_brainpellet(crystal.active_sprite.global_position)
    recover_brain(5 * match_combo)
  else:
    match_combo = 0

func _spawn_brainpellet(pos: Vector2):
  var pellet = BRAINPOWER_PELLET.instantiate() as Actor
  pellet.global_position = pos
  Globals.object_container.add_child(pellet)
  var script = pellet.get_param(Globals.Constants.ActorParams.BrainpowerPellet) as BrainpowerPellet
  if not script: return
  pellet_target = script.target_pos
  script.move()
  await script.pellet_done
  PlayerEvents.on_brainpower_pellet_recover.emit()
  
func _room_cleared():
  decaying = false
  if difficulty == 0:
    difficulty = 1
  controller.input_blocker.block("room_event")
  _transfer_brainpellet.call_deferred()
  
func _transfer_brainpellet():
  await get_tree().create_timer(1.).timeout
  var sound = SoundManager.play_sound(SfxBank.BRAINPOWER_TRANSFER)
  brain_pellet_transfer.start()
  while brainpower > 0:
    await get_tree().process_frame
  brain_pellet_transfer.stop()
  SoundManager.stop_sound(sound)
  await get_tree().create_timer(1.).timeout
  recover_brain(max_brainpower)
  PlayerEvents.on_brainpower_transfer.emit()
  if memory >= max_memory:
    PlayerEvents.on_memory_unlock.emit()
    await PlayerEvents.on_memory_picked
    pass
    #upgrades
  else:
    PlayerEvents.on_ready_to_next_level.emit()
  
func _spawn_transfer_brain_pellet():
  recover_brain(-5)
  var pellet = BRAINPOWER_PELLET_TRANSFER.instantiate() as Actor
  pellet.global_position = pellet_target + Vector2(randf_range(-10, 10), randf_range(-10, 10))
  Globals.ui_container.add_child(pellet)
  var script = pellet.get_param(Globals.Constants.ActorParams.BrainpowerPellet) as BrainpowerPellet
  if not script: return
  script.move()
  await script.pellet_done
  recover_memory(5)

func _room_loaded(_room):
  decaying = true
  controller.input_blocker.unblock("room_event")

func _process(delta):
  if Input.is_action_just_pressed("action"):
    PlayerEvents.on_player_interact.emit()
  if decaying:
    brainpower = clamp(brainpower - delta * brainpower_decay, 0., max_brainpower)

func recover_brain(amount: float):
  if brainpower <= 0 and decaying: return
  brainpower = clamp(brainpower + amount, 0., max_brainpower)

func recover_memory(amount: float):
  if memory > max_memory: return
  memory = clamp(memory + amount, 0., max_memory)
