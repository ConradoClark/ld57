extends Node

class_name CrystalManager

var crystals: Dictionary[int, Crystal]
var matching_count = 0
var triggered_count = 0
var in_range_crystal: Crystal
var total_crystals = 0
var total_matched = 0

func _ready():
  CrystalEvents.on_crystal_added.connect(add_crystal)
  CrystalEvents.on_crystal_in_range.connect(_crystal_in_range)
  CrystalEvents.on_crystal_out_of_range.connect(_crystal_out_of_range)
  PlayerEvents.on_player_interact.connect(_on_player_interact)
  CrystalEvents.on_crystals_placed.connect(_on_crystals_placed)
  
func _on_crystals_placed(total: int):
  total_crystals = total
  total_matched = 0
  
func _on_player_interact():
  if not in_range_crystal: return
  trigger(in_range_crystal)

func _crystal_in_range(crystal: Crystal):
  in_range_crystal = crystal
  
func _crystal_out_of_range(crystal: Crystal):
  if in_range_crystal == crystal:
    in_range_crystal = null

func add_crystal(crystal: Crystal):
  crystals[crystal.get_instance_id()] = crystal

func clear():
  crystals.clear()

func trigger(crystal: Crystal):
  if crystal.triggered: return
  if matching_count >= 2: return
  matching_count += 1
  crystal.trigger()
  triggered_count += 1
  match_crystals(crystal)
  
func match_crystals(crystal: Crystal):
  if triggered_count < 2: return
  var match_key = crystal.match_key
  var instance_id = crystal.get_instance_id()
  var triggered_crystal: Crystal
  for key in crystals:
    if key == instance_id: continue
    var matched_crystal = crystals[key]
    if matched_crystal.matched: continue
    if not matched_crystal.triggered: continue
    triggered_crystal = matched_crystal
    if matched_crystal.match_key != match_key: continue
    matched_crystal.matched = true
    crystal.matched = true
    total_matched+=2
    CrystalEvents.on_crystal_matched.emit(true, crystal)
    if total_matched < total_crystals:
      var sound_pitch = clamp(1. + (0.15*total_matched), 1., 2.)
      SoundManager.play_sound(SfxBank.SFX_CRYSTAL_MATCH, sound_pitch, sound_pitch)
    else:
      SoundManager.play_sound(SfxBank.SFX_CRYSTAL_FULL_MATCH, 1., 1.)
  matching_count = 0
  triggered_count = 0
  if not crystal.matched:
    SoundManager.play_sound(SfxBank.WRONG, 0.95, 1.04)
    await get_tree().create_timer(0.5).timeout
    CrystalEvents.on_crystal_matched.emit(false, crystal)
    triggered_crystal.blackout()
    crystal.blackout()
  if total_matched >= total_crystals:
    await get_tree().create_timer(0.5).timeout
    print('cleared!')
    clear()
    RoomEvents.on_room_cleared.emit()
    pass
