extends Control

@export_file("*.tscn") var load_scene: String
@export var in_time : float = 0.5
@export var fade_in_time : float = 1.0
@export var pause_time : float = 1.5
@export var fade_out_time : float = 1.0
@export var out_time : float = 0.5
@export var splash_screen : Control

func fade_out() -> void:
	var tween = self.create_tween()
	#tween.tween_interval(pause_time)
	tween.tween_property(splash_screen, "modulate:a", 0.0, fade_out_time)
	tween.tween_interval(out_time)
	await tween.finished
	queue_free()
	#get_tree().change_scene_to_packed(load_scene)
	
func fade_in() -> void:
	splash_screen.modulate.a = 0.0
	var tween = self.create_tween()
	tween.tween_interval(in_time)
	tween.tween_property(splash_screen, "modulate:a", 1.0, fade_in_time)
	await tween.finished
	

func _ready() -> void:
	fade_in()
	pass
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_pressed():
		await Global.game_controller.change_scene(load_scene, false)
	
