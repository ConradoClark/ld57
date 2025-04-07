extends Node

class_name CrystalLoader

const CRYSTAL = preload("res://scenes/objects/crystal.tscn")
const CRYSTAL_BLUE = preload("res://sprites/crystal/crystal_blue.png")
const CRYSTAL_GREEN = preload("res://sprites/crystal/crystal_green.png")
const CRYSTAL_ORANGE = preload("res://sprites/crystal/crystal_orange.png")
const CRYSTAL_PINK = preload("res://sprites/crystal/crystal_pink.png")
const CRYSTAL_RED = preload("res://sprites/crystal/crystal_red.png")

enum CrystalColor{
  Blue,
  Green,
  Red,
  Orange,
  Pink
}

var all_colors: Array[CrystalColor] = [
  CrystalColor.Blue,
  CrystalColor.Green,
  CrystalColor.Red,
  CrystalColor.Orange,
  CrystalColor.Pink,
]

func load(room: Room):
  var markers: Array[CrystalMarker] = []
  markers.append_array(
    room.actor.get_children().filter(func(child): return child is CrystalMarker))
  markers.shuffle()
  var color_amount = min(len(markers)/2, \
    randi_range(room.definition.min_colors, room.definition.max_colors))
  var colors = all_colors.duplicate()
  pick_random_colors(colors, len(all_colors)-color_amount)
  var used_colors: Array[CrystalColor] = []
  var matching = true
  var pick: CrystalColor
  for marker in markers:
    if matching:
      if len(used_colors) == 0:
        used_colors = colors.duplicate()
      pick = pick_random_color(used_colors)
    var crystal = CRYSTAL.instantiate() as Actor
    crystal.global_position = marker.global_position + Vector2(0,-16)
    Globals.object_container.add_child(crystal)
    _setup_crystal(crystal, pick)
    matching = !matching
  CrystalEvents.on_crystals_placed.emit(len(markers))
    
func _setup_crystal(actor: Actor, color: CrystalColor):
  var crystal = actor.get_param(Globals.Constants.ActorParams.Crystal) as Crystal
  if not crystal: return
  crystal.match_key = _get_match_key(color)
  crystal.active_sprite.texture = _get_crystal_texture(color)
  pass
  
func _get_match_key(color: CrystalColor) -> String:
  match color:
    CrystalColor.Blue: return "blue"
    CrystalColor.Green: return "green"
    CrystalColor.Red: return "red"
    CrystalColor.Orange: return "orange"
    CrystalColor.Pink: return "pink"
  return "blue"
    
func _get_crystal_texture(color: CrystalColor) -> Texture2D:
  match color:
    CrystalColor.Blue: return CRYSTAL_BLUE
    CrystalColor.Green: return CRYSTAL_GREEN
    CrystalColor.Red: return CRYSTAL_RED
    CrystalColor.Orange: return CRYSTAL_ORANGE
    CrystalColor.Pink: return CRYSTAL_PINK
  return CRYSTAL_BLUE
    
func pick_random_colors(array: Array[CrystalColor], amount: int):
  for i in amount:
    pick_random_color(array)

func pick_random_color(array: Array[CrystalColor]) -> CrystalColor:
  var rng = randi_range(0, len(array)-1)
  var pick = array[rng]
  array.remove_at(rng)
  return pick 
