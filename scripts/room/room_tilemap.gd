extends TileMapLayer

class_name RoomTileMapLayer

var spawn_time: float = 0.
var tween: Tween
var used_cells: Array[Vector2i]
var min: Vector2
var max: Vector2
var size: Vector2

var actor: Actor

func _ready() -> void:
  actor = Globals.get_actor(self)
  spawn.call_deferred()
  used_cells = get_used_cells()
  for cell in used_cells:
    if cell.x < min.x: min.x = cell.x
    if cell.x > max.x: max.x = cell.x
    if cell.y < min.y: min.y = cell.y
    if cell.y > max.y: max.y = cell.y
  size = Vector2(max.x - min.x, max.y - min.y)
  RoomEvents.on_room_cleared.connect(_despawn)
  PlayerEvents.on_game_over.connect(_despawn)

func _use_tile_data_runtime_update(coords: Vector2i) -> bool:
  return true

func _tile_data_runtime_update(coords: Vector2i, tile_data: TileData) -> void:
  if size.x <=0: return
  var x = 4*(coords.x - min.x) / size.x
  var y = 4*(coords.y - min.y) / size.y
  var value = clamp(1-x-y+spawn_time*8, 0., 1.)
  tile_data.texture_origin = lerp(Vector2(0,150), Vector2(0, 0), value)
  tile_data.modulate = Color(1,1,1, value)

func spawn():
  tween = create_tween()
  tween.tween_method(_update_spawn, 0., 1., 1.)\
    .set_ease(Tween.EASE_OUT)\
    .set_trans(Tween.TRANS_BOUNCE)

func _update_spawn(value: float):
  spawn_time = value
  notify_runtime_tile_data_update()

func _despawn():
  tween = create_tween()
  tween.tween_method(_update_spawn, 1., 0., 1.)\
    .set_ease(Tween.EASE_IN)\
    .set_trans(Tween.TRANS_BOUNCE)
  await tween.finished
  spawn_time = -10
  notify_runtime_tile_data_update()
  await get_tree().process_frame
  actor.queue_free()
