extends Label

@export var full_text: String = "Hello, this is a typing effect!"
@export var typing_speed: float = 0.05

func _ready():
	text = full_text
	visible_ratio = 0.0  # Hide text initially
	var tween = create_tween()
	tween.tween_property(self, "visible_ratio", 1.0, full_text.length() * typing_speed)
