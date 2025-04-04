extends Node

class_name SetMusic

@export var song: AudioStream

func _ready():
  SoundManager.set_music(song)
