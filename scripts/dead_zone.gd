class_name DeadZone
extends Area2D

@export var disabled: bool = false:
	set(new):
		disabled = new
		if is_player_inside:
			Global.player_stats.health = 0

var is_player_inside = false

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if not disabled:
			Global.player_stats.health = 0
		is_player_inside = true


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		is_player_inside = false
