extends Node

class_name Crystal

@export var active_sprite: Node2D
@export var inactive_sprite: Node2D
@export var match_key: String
@export var area: Area2D

var tween: Tween
var in_range: bool
var triggered: bool
var matched: bool

func _ready():
  inactive_sprite.modulate = Color.WHITE
  active_sprite.modulate = Color.WHITE
  area.body_entered.connect(_body_entered)
  area.body_exited.connect(_body_exited)
  _setup.call_deferred()
  
func _setup():
  CrystalEvents.on_crystal_added.emit(self)
  
func _body_entered(_body: Node2D):
  if matched or triggered: return
  in_range = true
  CrystalEvents.on_crystal_in_range.emit(self)
  
func _body_exited(_body: Node2D):
  if matched or triggered: return
  in_range = false  
  CrystalEvents.on_crystal_out_of_range.emit()

func trigger():
  CrystalEvents.on_crystal_matching.emit()
  triggered = true
  if tween: tween.kill()
  tween = create_tween()
  tween.set_parallel(true)
  tween.tween_property(inactive_sprite, "modulate", Color.TRANSPARENT, 0.5)\
    .set_ease(Tween.EASE_OUT)\
    .set_trans(Tween.TRANS_CIRC)
  await tween.finished
  CrystalEvents.on_crystal_triggered.emit(self)

func _modulate_active_sprite(_value: float):
  active_sprite.modulate = Color(1,1,1,1-inactive_sprite.modulate.a)

func blackout():
  triggered = false
  if tween: tween.kill()
  tween = create_tween()
  tween.set_parallel(true)
  tween.tween_property(inactive_sprite, "modulate", Color.WHITE, 0.5)\
    .set_ease(Tween.EASE_OUT)\
    .set_trans(Tween.TRANS_CIRC)
  await tween.finished
