extends Node

class_name Crystal

@export var sprite: Node2D
@export var match_key: String
@export var area: Area2D

const saturation_param = "saturation"
var shader_mat: ShaderMaterial
var tween: Tween
var in_range: bool
var triggered: bool
var matched: bool

func _ready():
  shader_mat = sprite.material as ShaderMaterial
  area.body_entered.connect(_body_entered)
  area.body_exited.connect(_body_exited)
  _setup.call_deferred()
  
func _setup():
  CrystalEvents.on_crystal_added.emit(self)
  
func _body_entered(_body: Node2D):
  in_range = true
  CrystalEvents.on_crystal_in_range.emit(self)
  
func _body_exited(_body: Node2D):
  in_range = false  
  CrystalEvents.on_crystal_out_of_range.emit()

func trigger():
  CrystalEvents.on_crystal_matching.emit()
  triggered = true
  # tween stuff

  CrystalEvents.on_crystal_triggered.emit(self)
  pass

func blackout():
  pass
