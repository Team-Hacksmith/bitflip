extends Area2D


@export var timeline: DialogicTimeline
@export var only_once: bool = false

var is_done = false

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if only_once and is_done:
			return
		Dialogic.start(timeline)
		is_done = true
