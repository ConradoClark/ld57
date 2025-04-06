extends Control

class_name FloatingText

@export var bb_code_params: String
@export var fade_duration_seconds: float
@export var label: RichTextLabel
var tween: Tween

const floating_text = preload("res://scenes/ui/floating_text.tscn")
  
func set_color(color: Color):
  bb_code_params = '[color=#%s]%s' % [color.to_html(), bb_code_params]

static func show_text(text: String, global_position: Vector2, duration: float, color: Color = Color.TRANSPARENT):
  if not Globals.ui_container: return
  var obj = floating_text.instantiate() as FloatingText
  Globals.ui_container.add_child(obj)
  obj.global_position = global_position
  await Globals.ui_container.get_tree().process_frame
  if color != Color.TRANSPARENT:
    obj.set_color(color)
  obj.label.text = "%s %s" % [obj.bb_code_params, text]
  await obj.get_tree().create_timer(duration, false).timeout
  if obj.tween:
    obj.tween.kill()
  obj.tween = obj.get_tree().create_tween()
  obj.tween.tween_property(obj, "modulate", Color.TRANSPARENT, obj.fade_duration_seconds)
  obj.tween.set_parallel(true).tween_property(obj, "scale:y", 0., obj.fade_duration_seconds*0.75)
  obj.tween.set_parallel(true).tween_property(obj, "position:y",obj.position.y+10, obj.fade_duration_seconds*0.75)
  await obj.tween.finished
