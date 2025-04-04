extends Node

class_name Menu

@export var actions: Array[MenuAction]
@export var menu_items: Array[Button]
@export var cursor: Control
@export var active_on_start: bool
@export var cursor_offset:Vector2
var active: bool = false
var pressed: bool = false
var cursor_tween: Tween 
var active_cursor_index: int = 0

func _ready():
  for i in len(menu_items):
    var item = menu_items[i]
    item.mouse_entered.connect(func():
      if not active: return
      move_cursor(i))
    item.pressed.connect(func(): 
      if not active: return
      pressed = true
      move_cursor(i)
      actions[i].run(get_tree()))
  if active_on_start:
    activate.call_deferred()
  
func _input(event):
  if pressed: return
  if not active: return
  if event.is_action_pressed("down") and event.get_action_strength("down") > 0.75:
    active_cursor_index = (active_cursor_index+1)
    if active_cursor_index >= len(menu_items):
      active_cursor_index = len(menu_items)- 1
    move_cursor(active_cursor_index)
  elif event.is_action_pressed("up") and event.get_action_strength("up") > 0.75:
    active_cursor_index = (active_cursor_index-1)
    if active_cursor_index<0: active_cursor_index = 0
    move_cursor(active_cursor_index)
  elif event.is_action_pressed("confirm"):
    pressed = true
    actions[active_cursor_index].run(get_tree())
  
func activate():
  active = true
  move_cursor(0, false)  

func move_cursor(i: int, beep: bool = true):
  if pressed: return
  if cursor_tween: cursor_tween.kill()
  cursor_tween = create_tween()
  menu_items[i].grab_focus.call_deferred()
  var target_pos = cursor_offset + menu_items[i].global_position - Vector2(menu_items[i].size.x*0.5 - 32,0)
  cursor_tween.tween_property(cursor, "global_position", target_pos, 0.5)\
    .set_ease(Tween.EASE_OUT)\
    .set_trans(Tween.TRANS_BOUNCE)
