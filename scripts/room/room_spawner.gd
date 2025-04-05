extends Node

class_name RoomSpawner

@export var container: Node2D
@export var load_delay: float
@export_file("*.tscn") var file: String

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
  
func load_level():
  scene = await load(file)
  loaded = true
  
func _on_timeout():
  while not loaded:
    await get_tree().process_frame
  var instance = scene.instantiate() as Actor
  instance.global_position = Globals.Constants.Screen.Size*0.5
  container.add_child(instance)
  var room = instance.get_param(Globals.Constants.ActorParams.Room) as Room
  if room: RoomEvents.on_room_loaded.emit(room)
