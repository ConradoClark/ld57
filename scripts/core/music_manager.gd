extends Node

class SongBank:
  const game_song_1 = "res://sound/songs/game_song_1.ogg"
  const game_song_2 = "res://sound/songs/game_song_2.ogg"
  const game_song_3 = "res://sound/songs/game_song_3.ogg"
  
var GAME_SONG_1: AudioStream
var GAME_SONG_2: AudioStream
var GAME_SONG_3: AudioStream
var loaded = false

func load_songs():
  if loaded: return
  GAME_SONG_1 = load(SongBank.game_song_1)
  GAME_SONG_2 = load(SongBank.game_song_2)
  GAME_SONG_3 = load(SongBank.game_song_3)
  loaded = true

func change_song(song: AudioStream):
  SoundManager.swap_music(song)
