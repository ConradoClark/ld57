extends Node

class_name CrystalManager

var crystals: Dictionary[int, Crystal]
var matching_count = 0
var triggered_count = 0
var in_range_crystal: Crystal

func _ready():
  CrystalEvents.on_crystal_added.connect(add_crystal)
  CrystalEvents.on_crystal_in_range.connect(_crystal_in_range)
  CrystalEvents.on_crystal_out_of_range.connect(_crystal_out_of_range)
  PlayerEvents.on_player_interact.connect(_on_player_interact)
  
func _on_player_interact():
  if not in_range_crystal: return
  trigger(in_range_crystal)

func _crystal_in_range(crystal: Crystal):
  in_range_crystal = crystal
  
func _crystal_out_of_range():
  in_range_crystal = null

func add_crystal(crystal: Crystal):
  crystals[crystal.get_instance_id()] = crystal

func clear():
  crystals.clear()

func trigger(crystal: Crystal):
  if matching_count >= 2: return
  matching_count += 1
  await crystal.trigger()
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
  matching_count = 0
  triggered_count = 0
  if not crystal.matched:
    triggered_crystal.blackout()
    crystal.blackout()
