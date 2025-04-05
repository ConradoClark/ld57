extends Node

class Constants:
  class ActorParams:
    const Player = "player"

func get_actor(node: Node) -> Actor:
  if node is Actor: return node as Actor
  var current_node = node
  var parent = current_node.get_parent()
  while parent != null:
    if parent is Actor:
      return parent as Actor
    current_node = parent
    parent = current_node.get_parent()
  return null

func change_scene(scene: String):
  var instance = load(scene).instantiate()
  get_tree().root.add_child(instance)
  await get_tree().process_frame
  var old_scene = get_tree().current_scene
  get_tree().current_scene = instance
  old_scene.free()
