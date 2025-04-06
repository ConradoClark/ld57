extends Resource

class_name UpgradeDefinition

@export var title: String
@export var thought: String
@export var description: String
@export var frames: SpriteFrames
@export var available_from_difficulty: int
@export var is_evolution: bool
@export var upgrade_into: UpgradeDefinition
@export_file("*.gd") var action: String
@export_multiline var lore: String
