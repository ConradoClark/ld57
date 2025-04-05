extends Node

class_name CharacterController

@export var body: CharacterBody2D

var desired_velocity: Dictionary[String, Vector2] = {}
var movement_velocity: Vector2
var actor: Actor
var input_blocker: Blocker

var player: Player:
  get: return actor.parameters[Globals.Constants.ActorParams.Player] as Player

func _ready():
  actor = Globals.get_actor(self)
  input_blocker = Blocker.new()
  add_child(input_blocker)
  
func _physics_process(delta):
  if not player: return
  _capture_input()
  _move()
  
func _capture_input():
  if input_blocker.is_blocked(): return
  var input = Input.get_vector("left", "right", "up", "down")
  var target = input * player.speed
  movement_velocity = lerp(movement_velocity, target, 0.2)
  if movement_velocity.is_equal_approx(target):
    movement_velocity = target
  desired_velocity["movement"] = movement_velocity
  
func _move():
  var velocity = Vector2.ZERO
  for key in desired_velocity:
    var vel = desired_velocity[key]
    velocity += vel
  body.velocity = velocity
  body.move_and_slide()
