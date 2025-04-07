extends Node

class_name RoomSpawner

@export var falling_particles: GPUParticles2D
@export var container: Node2D
@export var load_delay: float
@export var crystal_loader: CrystalLoader
@export var presets: Dictionary[int, RoomPreset]

var scene: PackedScene
var timer: Timer
var loaded: bool
var first: bool = true
var chosen: String
var endless_mode = false

func _ready():
  timer = Timer.new()
  timer.one_shot = true
  timer.wait_time = load_delay
  timer.autostart = true
  timer.timeout.connect(_on_timeout)
  add_child(timer)
  load_level.call_deferred()
  RoomEvents.on_room_cleared.connect(_on_clear)
  PlayerEvents.on_game_over.connect(_on_game_over)
  RoomEvents.on_endless_mode.connect(_on_endless_mode)
  
func _on_endless_mode():
  endless_mode = true
  load_level()

func _on_game_over():
  falling_particles.emitting = true
  
func _on_clear():
  loaded = false
  await get_tree().process_frame
  load_level()
  timer.start()
  
func load_level():
  falling_particles.emitting = true
  if not first:
    await PlayerEvents.on_ready_to_next_level
  else:
    await PlayerEvents.on_tutorial_over
    first = false
  SfxBank.load_game_sfx()
  MusicManager.load_songs()
  UpgradeCompendium.load_upgrades()
  var difficulty = Globals.player.difficulty
  if not presets.has(difficulty):
    if not endless_mode:
      PlayerEvents.on_game_finished.emit()
      return
  var files: Array[String] = []
  if endless_mode:
    var each = presets.values()
    for arr in each:
      files.append_array(arr)
  else:
    files = presets[difficulty].files.duplicate()
  for i in len(files):
    if files[i] == chosen:
      files.remove_at(i)
      break
  var option = randi_range(0, len(files)-1)
  chosen = files[option]
  scene = await load(chosen)
  loaded = true
  
func _on_timeout():
  while not loaded:
    await get_tree().process_frame
  falling_particles.emitting = false
  var instance = scene.instantiate() as Actor
  instance.global_position = Globals.Constants.Screen.Size*0.5
  container.add_child(instance)
  var room = instance.get_param(Globals.Constants.ActorParams.Room) as Room
  if room: 
    crystal_loader.load(room)
    RoomEvents.on_room_loaded.emit(room)
