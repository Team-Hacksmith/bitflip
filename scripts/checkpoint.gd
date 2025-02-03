extends Node2D




func _on_interactable_interact(with: Node2D) -> void:
	Global.last_checkpoint = global_position
