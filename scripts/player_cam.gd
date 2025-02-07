class_name PlayerCam
extends Camera2D
@export var randomStrength: float = 30.0
@export var shakeFade: float = 5.6

var rng = RandomNumberGenerator.new()

var shake_strength: float = 0.0

func apply_shake(strength: float = randomStrength):
	shake_strength = strength

func random_offset() -> Vector2:
	return Vector2(rng.randf_range(-shake_strength, shake_strength), rng.randf_range(-shake_strength, shake_strength))

func _process(delta):
	if shake_strength > 0:
		shake_strength = lerpf(shake_strength, 0, shakeFade * delta)
		offset = random_offset()
