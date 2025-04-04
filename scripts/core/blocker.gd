extends Node

class_name Blocker

var block_sources: Dictionary[String, bool] = {}
signal blocked_changed(blocked: bool)
  
func block(source: String):
  var empty = block_sources.is_empty()
  block_sources[source] = true
  if empty: blocked_changed.emit(true)
  
func unblock(source: String):
  block_sources.erase(source)
  if block_sources.is_empty():
    blocked_changed.emit(false)

func is_blocked():
  return not block_sources.is_empty()
