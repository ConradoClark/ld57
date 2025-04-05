extends Node

class_name ObjectSpawner

@export var sprite_group: Node2D
@export var sprite: Node2D
@export var hide_sprite: Node2D
@export var shadow: Node2D
@export var initial_y_offset: float
var default_sprite_offset: float
var default_shadow_offset: float
var tween: Tween

func _ready():
  default_sprite_offset = sprite.position.y
  default_shadow_offset = shadow.position.y
  spawn.call_deferred()
  RoomEvents.on_room_loaded.connect(_on_room_loaded)
  
func _on_room_loaded(_room: Room):
  finish()

func spawn():
  shadow.visible = false
  if hide_sprite: hide_sprite.visible = false
  sprite.position.y = initial_y_offset
  sprite.modulate = Color.TRANSPARENT
  
func finish():
  await get_tree().process_frame
  shadow.visible = true
  shadow.scale = Vector2(0.1,0.1)
  if tween: tween.kill()
  tween = create_tween()
  tween.set_parallel(true)
  tween.tween_property(sprite_group, "position:y", 0., 1.)\
    .set_ease(Tween.EASE_IN)\
    .set_trans(Tween.TRANS_QUAD)
  tween.tween_property(sprite, "modulate", Color.WHITE, 1.)\
    .set_ease(Tween.EASE_IN)\
    .set_trans(Tween.TRANS_QUAD)
  tween.tween_property(sprite, "position:y", default_sprite_offset, 1.)\
    .set_ease(Tween.EASE_OUT)\
    .set_trans(Tween.TRANS_BOUNCE)
  tween.tween_property(shadow, "scale", Vector2.ONE, 1.)\
    .set_ease(Tween.EASE_IN)\
    .set_trans(Tween.TRANS_QUAD)
  await tween.finished
  hide_sprite.visible = true
