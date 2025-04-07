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
var actor: Actor
var shader_mat: ShaderMaterial
const outline_thickness = "thickness"

func _ready():
  actor = Globals.get_actor(self)
  actor.set_param(Globals.Constants.ActorParams.Crystal, self)
  inactive_sprite.modulate = Color.WHITE
  active_sprite.modulate = Color.WHITE
  shader_mat = active_sprite.material.duplicate() as ShaderMaterial
  active_sprite.material = shader_mat
  area.body_entered.connect(_body_entered)
  area.body_exited.connect(_body_exited)
  _setup.call_deferred()
  PlayerEvents.on_game_over.connect(_on_game_over)
  
func _on_game_over():
  actor.queue_free()
  
func _setup():
  CrystalEvents.on_crystal_added.emit(self)
  
func _body_entered(_body: Node2D):
  if matched or triggered: return
  in_range = true
  shader_mat.set_shader_parameter(outline_thickness, 3.0)
  CrystalEvents.on_crystal_in_range.emit(self)
  
func _body_exited(_body: Node2D):
  if matched: return
  in_range = false  
  shader_mat.set_shader_parameter(outline_thickness, 0.0)
  CrystalEvents.on_crystal_out_of_range.emit(self)

func trigger():
  CrystalEvents.on_crystal_matching.emit()
  shader_mat.set_shader_parameter(outline_thickness, 0.0)
  triggered = true
  SoundManager.play_sound(SfxBank.SFX_CRYSTAL_TRIGGER, 1., 1.1)
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
