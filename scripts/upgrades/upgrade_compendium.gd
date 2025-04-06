extends Node

var upgrades_folder = "res://data/upgrades/"
var actions_folder = "res://scripts/upgrades/actions/"
var prefetched_upgrades: Dictionary[String, Script]
var prefetched_definitions: Dictionary[String, UpgradeDefinition]
var loaded = false

var available_upgrades: Dictionary[int, Variant]

func load_upgrades():
  if loaded: return
  for file_name in DirAccess.get_files_at(actions_folder):
    if file_name.ends_with("uid"): continue
    prefetched_upgrades[file_name] = load(actions_folder+file_name)
  for file_name in DirAccess.get_files_at(upgrades_folder):
    if file_name.ends_with("uid"): continue
    prefetched_definitions[file_name] = load(upgrades_folder+file_name)
  loaded = true
  for key in prefetched_definitions:
    var definition = prefetched_definitions[key] as UpgradeDefinition
    if definition.is_evolution: continue
    if available_upgrades.has(definition.available_from_difficulty):
      available_upgrades[definition.available_from_difficulty].append(definition)
    else:
      available_upgrades[definition.available_from_difficulty] = [definition]

func get_possible_upgrades() -> Array[UpgradeDefinition]:
  var result: Array[UpgradeDefinition] = []
  for key in available_upgrades:
    var upgrades = available_upgrades[key] as Array[UpgradeDefinition]
    for upgrade in upgrades:
      if Globals.player.difficulty >= upgrade.available_from_difficulty:
        result.append(upgrade)
  return result

func pick_upgrade(definition: UpgradeDefinition):
    for key in available_upgrades:
      var upgrades = available_upgrades[key] as Array[UpgradeDefinition]
      for i in len(upgrades):
        var upgrade = upgrades[i]
        if upgrade == definition:
          upgrades.remove_at(i)
          if upgrade.upgrade_into:
            var evolution = upgrade.upgrade_into
            if available_upgrades.has(evolution.available_from_difficulty):
              available_upgrades[evolution.available_from_difficulty].append(evolution)
            else:
              available_upgrades[evolution.available_from_difficulty] = [evolution]
          return
