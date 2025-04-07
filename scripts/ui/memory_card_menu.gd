extends Node

class_name MemoryCardMenu

@export var mem_unlocked: RichTextLabel
@export var pick_memory: RichTextLabel
@export var screen: Control
@export var container: Control
@export var card_description: Label
@export var memory_text: RichTextLabel
@export var press_any: RichTextLabel
var cards: Array[MemoryCard]
var selected_card: MemoryCard
var selected_index= -1
var can_select = false
const MEMORY_CARD = preload("res://scenes/ui/memory_card.tscn")

func _ready():
  MemoryCardEvents.on_memory_card_added.connect(_add_memory_card)
  MemoryCardEvents.on_memory_card_selected.connect(_on_selected)
  PlayerEvents.on_memory_unlock.connect(show_menu)
  
func _on_selected(card: MemoryCard):
  selected_card = card
  for i in len(cards):
    if cards[i] == card:
      selected_index = i
    else:
      cards[i].deselect()
  card_description.text = card.definition.description
  
func show_menu():
  screen.visible = true
  mem_unlocked.visible = true
  pick_memory.visible = true
  memory_text.visible = false
  press_any.visible = false
  var potential = UpgradeCompendium.get_possible_upgrades()
  var memories = _get_random_memories(potential, 3)
  cards.clear()
  for memory in memories:
    var card = MEMORY_CARD.instantiate()
    var memory_card = card.get_node("MemoryCard") as MemoryCard
    memory_card.title.text = memory.title
    memory_card.thought.text = memory.thought
    memory_card.definition = memory
    memory_card.image.sprite_frames = memory.frames
    container.add_child(card)
  if len(cards) >0:
    await get_tree().process_frame
    can_select = true
    var middle = (len(memories)/2)
    cards[middle].select()
  else:
    screen.visible = false
    PlayerEvents.on_ready_to_next_level.emit()
  
func _get_random_memories(upgrades: Array[UpgradeDefinition], amount: int) -> Array[UpgradeDefinition]:
  if len(upgrades) == 0: return []
  var result: Array[UpgradeDefinition] = []
  for i in amount:
    if len(upgrades)==0: return result
    var rng = randi_range(0, len(upgrades)-1)
    result.append(upgrades[rng])
    upgrades.remove_at(rng)
  return result
  
func _add_memory_card(card: MemoryCard):
  cards.append(card)
  
func _show_memory():
  PlayerEvents.on_memory_picked.emit(selected_card.definition)
  memory_text.text = selected_card.definition.lore
  can_select = false
  memory_text.visible = true
  mem_unlocked.visible = false
  pick_memory.visible = false
  press_any.visible = true
  card_description.text = ""
  await get_tree().process_frame
  while memory_text.visible_ratio < 1.:
    memory_text.visible_ratio += 10 * get_process_delta_time()
    await get_tree().process_frame
    if Input.is_action_just_pressed("action"):
      memory_text.visible_ratio = 1
  var pressed = false
  while not pressed:
    if Input.is_action_just_pressed("action"):
      pressed = true
    await get_tree().process_frame
  selected_card.destroy()
  selected_card = null
  screen.visible = false
  PlayerEvents.on_ready_to_next_level.emit() 

func _process(delta):
  if not can_select: return
  if selected_card and Input.is_action_just_pressed("action"):
    UpgradeCompendium.pick_upgrade(selected_card.definition)
    for card in cards:
      if card == selected_card: continue
      card.destroy()
    cards.clear()
    _show_memory.call_deferred()
    return
  if Input.is_action_just_pressed("right"):
    var index = clamp(selected_index+1, 0, len(cards)-1)
    if index != selected_index:
      SoundManager.play_sound(SfxBank.MENU, 0.96, 1.04)
      cards[index].select()
  if Input.is_action_just_pressed("left"):
    var index = clamp(selected_index-1, 0, len(cards)-1)
    if index != selected_index:
      SoundManager.play_sound(SfxBank.MENU, 0.96, 1.04)
      cards[index].select()
