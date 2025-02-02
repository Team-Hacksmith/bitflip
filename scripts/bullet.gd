class_name Bullet
extends Area2D

@export var lifetime: float = 2.0  # Bullet disappears after this time

func _ready():
	await get_tree().create_timer(lifetime).timeout
	queue_free()  # Destroy bullet after lifetime

func shoot(speed: float):
	var tween = create_tween()
	var target_position = global_position + Vector2(speed * lifetime, 0)  # Move rightward
	tween.tween_property(self, "global_position", target_position, lifetime)
	tween.finished.connect(queue_free)  # Remove bullet when done


func _on_body_entered(body: Node2D) -> void:
	queue_free()
