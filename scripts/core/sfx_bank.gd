extends Node

class SoundBank:
  const crystal_trigger = "res://sound/sfx/crystal_trigger.ogg"
  const crystal_match = "res://sound/sfx/crystal_match.ogg"
  const crystal_full_match = "res://sound/sfx/crystal_full_match.ogg"
  const brainpower_transfer = "res://sound/sfx/brainpower_transfer.ogg"
  const menu = "res://sound/sfx/menu.ogg"
  const wrong = "res://sound/sfx/wrong.ogg"
  const ability = "res://sound/sfx/ability.ogg"
  
var SFX_CRYSTAL_TRIGGER: AudioStream
var SFX_CRYSTAL_MATCH: AudioStream
var SFX_CRYSTAL_FULL_MATCH: AudioStream
var BRAINPOWER_TRANSFER: AudioStream
var WRONG: AudioStream
var ABILITY: AudioStream
var MENU: AudioStream
var loaded = false

func load_game_sfx():
  if loaded: return
  SFX_CRYSTAL_TRIGGER = load(SoundBank.crystal_trigger)
  SFX_CRYSTAL_MATCH = load(SoundBank.crystal_match)
  SFX_CRYSTAL_FULL_MATCH = load(SoundBank.crystal_full_match)
  BRAINPOWER_TRANSFER = load(SoundBank.brainpower_transfer)
  MENU = load(SoundBank.menu)
  WRONG = load(SoundBank.wrong)
  ABILITY = load(SoundBank.ability)
  loaded = true
