extends Node

class_name MemoryCard

@export var reference: Control
@export var panel: Panel
@export var image: AnimatedSprite2D
@export var title: Label
@export var thought: Label
var definition: UpgradeDefinition
@export var selected_color: Color

var original: StyleBoxFlat
var selected: StyleBoxFlat

func _ready():
  original = panel.get("theme_override_styles/panel") as StyleBoxFlat
  MemoryCardEvents.on_memory_card_added.emit(self)
  pass

func select():
  if not selected:
    var style_box = original.duplicate() as StyleBoxFlat
    style_box.border_color = selected_color
    selected = style_box
  panel.set("theme_override_styles/panel", selected)
  MemoryCardEvents.on_memory_card_selected.emit(self)

func deselect():
  panel.set("theme_override_styles/panel", original)
  
func destroy():
  reference.queue_free()
