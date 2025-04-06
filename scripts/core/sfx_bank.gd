extends Node

class SoundBank:
  const crystal_trigger = "res://sound/sfx/crystal_trigger.ogg"
  const crystal_match = "res://sound/sfx/crystal_match.ogg"
  const crystal_full_match =  "res://sound/sfx/crystal_full_match.ogg"
  
var SFX_CRYSTAL_TRIGGER: AudioStream
var SFX_CRYSTAL_MATCH: AudioStream
var SFX_CRYSTAL_FULL_MATCH: AudioStream
var loaded = false

func load_game_sfx():
  if loaded: return
  SFX_CRYSTAL_TRIGGER = load(SoundBank.crystal_trigger)
  SFX_CRYSTAL_MATCH = load(SoundBank.crystal_match)
  SFX_CRYSTAL_FULL_MATCH = load(SoundBank.crystal_full_match)
  loaded = true
