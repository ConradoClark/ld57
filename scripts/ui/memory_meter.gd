extends Node

class_name MemoryMeter

@export var meter: TextureRect
@export var border: NinePatchRect
@export var meter_min_size_x: float
@export var meter_max_size_x: float
var stage = 1

var tween: Tween
var shader_mat: ShaderMaterial
var tex_shader_mat: ShaderMaterial
const colorize_param = "color"

func _ready():
  shader_mat = border.material as ShaderMaterial
  tex_shader_mat = meter.material as ShaderMaterial

func _process(delta):
  if not Globals.player: return
  var proportion = Globals.player.memory / Globals.player.max_memory
  meter.size.x = meter_min_size_x + (meter_max_size_x - meter_min_size_x) * proportion
      
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
