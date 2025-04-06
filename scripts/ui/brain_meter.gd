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
