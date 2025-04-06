extends Node

class_name RoomSpawner

@export var container: Node2D
@export var load_delay: float
@export var crystal_loader: CrystalLoader
@export var presets: Dictionary[int, RoomPreset]

var scene: PackedScene
var timer: Timer
var loaded: bool

func _ready():
  timer = Timer.new()
  timer.one_shot = true
  timer.wait_time = load_delay
  timer.autostart = true
  timer.timeout.connect(_on_timeout)
  add_child(timer)
  load_level.call_deferred()
  RoomEvents.on_room_cleared.connect(_on_clear)
  
func _on_clear():
  loaded = false
  await get_tree().process_frame
  load_level()
  timer.start()
  
func load_level():
  var difficulty = Globals.player.difficulty
  var files = presets[difficulty].files
  var chosen = randi_range(0, len(files)-1)
  scene = await load(files[chosen])
  loaded = true
  
func _on_timeout():
  while not loaded:
    await get_tree().process_frame
  var instance = scene.instantiate() as Actor
  instance.global_position = Globals.Constants.Screen.Size*0.5
  container.add_child(instance)
  var room = instance.get_param(Globals.Constants.ActorParams.Room) as Room
  if room: 
    crystal_loader.load(room)
    RoomEvents.on_room_loaded.emit(room)
