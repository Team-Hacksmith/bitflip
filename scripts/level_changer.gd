extends Area2D

@export_file("*.tscn") var scene: String

func _ready() -> void:
	assert(scene, "Level not selected")

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		Global.game_controller.change_scene(scene)
