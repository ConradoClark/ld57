extends Node

class_name Room

@export var ground_layer: TileMapLayer
@export var wall_layer: TileMapLayer
@export var definition: RoomDefinition

var actor: Actor

func _ready():
  actor = Globals.get_actor(self)
  actor.set_param(Globals.Constants.ActorParams.Room, self)
