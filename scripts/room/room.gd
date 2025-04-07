extends Node

class_name Room

@export var ground_layer: TileMapLayer
@export var wall_layer: TileMapLayer
@export var definition: RoomDefinition

var actor: Actor
var player_pos: Vector2

func _ready():
  actor = Globals.get_actor(self)
  actor.set_param(Globals.Constants.ActorParams.Room, self)
  var markers = get_parent().get_children().filter(func(child): return child is PlayerMarker)
  if len(markers)>0:
    player_pos = markers[0].global_position
  else:
    player_pos = Globals.Constants.Screen.Size/2
