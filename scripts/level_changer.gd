extends Area2D

@export var chapter_num: int

func _ready() -> void:
	assert(chapter_num, "Chapter Number not selected")

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		Global.game_controller.change_to_chapter_safe(chapter_num)
