extends Node2D

@export var needs_e: bool = true

func _ready():
	$Interactable.needs_e = needs_e

func _on_interactable_interact(with: Node2D) -> void:
	Global.last_checkpoint = global_position
