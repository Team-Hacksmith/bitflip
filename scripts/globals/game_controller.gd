class_name GameController
extends Node

@onready var world: Node2D = %World
@onready var gui: Control = %GUI
@onready var transition_controller: TransitionController = %TransitionController

var curr_scene
var curr_gui_scene

func _ready():
	Global.game_controller = self
	curr_gui_scene = %GUI/SplashScreenManager

func change_gui_scene(new_scene: String, delete: bool = true, keep_running: bool = false) -> void:
	await transition_controller.animate_in()
	_clear_scene(delete, keep_running)
	var new = load(new_scene).instantiate()
	gui.add_child(new)
	curr_gui_scene = new
	await transition_controller.animate_out()

func change_scene(new_scene: String, delete: bool = true, keep_running: bool = false) -> void:
	await transition_controller.animate_in()
	_clear_scene(delete, keep_running)
	var new = load(new_scene).instantiate()
	world.add_child(new)
	curr_scene = new
	await transition_controller.animate_out()

func _clear_scene(delete: bool = true, keep_running: bool = false) -> void:
	if delete:
		if curr_gui_scene:
			curr_gui_scene.queue_free()
		if curr_scene:
			curr_scene.queue_free()
	elif keep_running:
		if curr_gui_scene:
			curr_gui_scene.visible = false
		if curr_scene:
			curr_scene.visible = false
	else:
		if curr_gui_scene and curr_gui_scene.get_parent() == gui:
			gui.remove_child(curr_gui_scene)
		if curr_scene and curr_scene.get_parent() == world:
			world.remove_child(curr_scene)
