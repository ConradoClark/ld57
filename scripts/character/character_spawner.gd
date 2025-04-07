extends Node

class_name CharacterSpawner

@export var controller: CharacterController
@export var sprite_group: Node2D
@export var sprite: Node2D
@export var shadow: Node2D
@export var initial_y_offset: float
@export var float_magnitude: float
var initial_body_pos: Vector2
var default_sprite_offset: float
var default_shadow_offset: float
var tween: Tween
var floating: bool

func _ready():
  initial_body_pos = controller.body.global_position
  default_sprite_offset = sprite.position.y
  default_shadow_offset = shadow.position.y
  spawn.call_deferred()
  controller.input_blocker.block("spawn")
  RoomEvents.on_room_cleared.connect(_on_room_cleared)
  RoomEvents.on_room_loaded.connect(_on_room_loaded)
  PlayerEvents.on_game_over.connect(_on_room_cleared)
  
func _on_room_loaded(room: Room):
  finish(room)
  
func _on_room_cleared():
  controller.input_blocker.block("spawn")
  shadow.visible = false
  if tween: tween.kill()
  tween = create_tween()
  tween.tween_property(controller.body, "global_position", Vector2(initial_body_pos.x, initial_body_pos.y+initial_y_offset), 1.)\
    .set_ease(Tween.EASE_OUT)\
    .set_trans(Tween.TRANS_QUAD)
  await tween.finished
  spawn()

func spawn():
  shadow.visible = false
  controller.body.global_position = initial_body_pos
  sprite.position.y = initial_y_offset
  floating = true
  keep_floating()
  
func keep_floating():
  while floating:
    if tween: tween.kill()
    tween = create_tween()
    tween.tween_property(sprite_group, "position:y", float_magnitude, 1.)\
      .set_ease(Tween.EASE_IN)\
      .set_trans(Tween.TRANS_QUAD)
    tween.tween_property(sprite_group, "position:y", 0., 1.)\
      .set_ease(Tween.EASE_IN)\
      .set_trans(Tween.TRANS_QUAD)
    await tween.finished
  
func finish(room: Room):
  floating = false
  shadow.visible = true
  shadow.scale = Vector2(0.1,0.1)
  if tween: tween.kill()
  tween = create_tween()
  tween.set_parallel(true)
  controller.block_collisions()
  tween.tween_property(controller.body, "global_position", room.player_pos, 1.)\
    .set_ease(Tween.EASE_OUT)\
    .set_trans(Tween.TRANS_QUAD)
  tween.tween_property(sprite_group, "position:y", 0., 1.)\
    .set_ease(Tween.EASE_IN)\
    .set_trans(Tween.TRANS_QUAD)
  tween.tween_property(sprite, "position:y", default_sprite_offset, 1.)\
    .set_ease(Tween.EASE_OUT)\
    .set_trans(Tween.TRANS_BOUNCE)
  tween.tween_property(shadow, "scale", Vector2.ONE, 1.)\
    .set_ease(Tween.EASE_IN)\
    .set_trans(Tween.TRANS_QUAD)
  await tween.finished
  await get_tree().create_timer(0.2).timeout
  controller.input_blocker.unblock("spawn")
  controller.unblock_collisions()
