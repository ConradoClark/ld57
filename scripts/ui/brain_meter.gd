extends Node

class_name BrainMeter

@export var meter: TextureRect
@export var border: NinePatchRect
@export var plenty_border: Texture2D
@export var warning_border: Texture2D
@export var danger_border: Texture2D
@export var meter_min_size_x: float
@export var meter_max_size_x: float
@export var plenty_color: Color
@export var warning_color: Color
@export var danger_color: Color
var stage = 1

var tween: Tween
var shader_mat: ShaderMaterial
var tex_shader_mat: ShaderMaterial
const colorize_param = "color"

func _ready():
  shader_mat = border.material as ShaderMaterial
  tex_shader_mat = meter.material as ShaderMaterial
  PlayerEvents.on_brainpower_pellet_recover.connect(_flash_bar)

func _process(delta):
  if not Globals.player: return
  var proportion = Globals.player.brainpower / Globals.player.max_brainpower
  meter.size.x = meter_min_size_x + (meter_max_size_x - meter_min_size_x) * proportion
  if proportion > 0.50:
    meter.self_modulate = plenty_color
    if stage != 1: 
      border.texture = plenty_border
      stage = 1
  elif proportion > 0.25:
    meter.self_modulate = warning_color
    if stage != 2:
      border.texture = warning_border
      stage = 2
  else:
    meter.self_modulate = danger_color
    if stage != 3:
      border.texture = danger_border
      stage = 3
      
func _flash_bar():
  if tween: tween.kill()
  tween = create_tween()
  tween.tween_method(_colorize_bar, 0., 1., 0.3)\
    .set_ease(Tween.EASE_OUT)\
    .set_trans(Tween.TRANS_QUAD)
  tween.tween_method(_colorize_bar, 1., 0., 0.3)\
    .set_ease(Tween.EASE_IN)\
    .set_trans(Tween.TRANS_QUAD)
  
func _colorize_bar(value: float):
  shader_mat.set_shader_parameter(colorize_param, Color(1.,1.,1., value*0.75))
  tex_shader_mat.set_shader_parameter(colorize_param, Color(0.6,1.,0.6, value*0.55))
