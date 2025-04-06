extends Node

class_name BrainpowerPellet

@export var reference: Node2D
@export var sprite: Node2D
var actor:Actor
var tween: Tween
var target_pos = Vector2(320, 32)

signal pellet_done

func _ready():
  actor = Globals.get_actor(self)
  actor.set_param(Globals.Constants.ActorParams.BrainpowerPellet, self)
  
func move():
  if tween: tween.kill()
  tween = create_tween()
  var first_target = reference.global_position + (reference.global_position - target_pos).normalized()\
     * Vector2(randf_range(0,15), randf_range(0,10)) * 10
  tween.set_parallel(true)
  tween.tween_property(reference, "global_position:x", first_target.x, 0.5)\
    .set_ease(Tween.EASE_OUT)\
    .set_trans(Tween.TRANS_CIRC)
  tween.tween_property(reference, "global_position:y", first_target.y, 0.4)\
    .set_ease(Tween.EASE_OUT)
  tween.tween_property(reference, "global_position:x", target_pos.x, 0.5)\
    .set_delay(0.5)\
    .set_ease(Tween.EASE_IN)
  tween.tween_property(reference, "global_position:y", target_pos.y, 0.6)\
    .set_delay(0.4)\
    .set_ease(Tween.EASE_IN)\
    .set_trans(Tween.TRANS_CIRC)  
  await tween.finished
  pellet_done.emit()
  await get_tree().process_frame
  reference.queue_free()
