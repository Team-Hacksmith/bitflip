class_name GameController
extends Node

@export_dir var chapters_folder: String = "res://scenes/chapters/"
@export var chapter_prefix: String = "chapter"
@export var max_chapters: int = 5

@onready var world: Node2D = %World
@onready var gui: Control = %GUI
@onready var transition_controller: TransitionController = %TransitionController

var curr_scene: Node2D
var curr_gui_scene: Control

var curr_chapter: int = 0

func _ready():
	Global.game_controller = self
	curr_gui_scene = %GUI/SplashScreenManager

func get_chapter_path(chapter_num: int):
	return chapters_folder + chapter_prefix + str(chapter_num) + ".tscn"

func change_to_chapter_safe(chapter_num: int):
	curr_chapter = clampi(chapter_num, 0, max_chapters)
	var next_chapter_path = get_chapter_path(curr_chapter)
	change_scene(next_chapter_path)
	print("Changed chapter to: ", next_chapter_path)

func change_to_next_chapter():
	change_to_chapter_safe(curr_chapter + 1)

func change_to_prev_chapter():
	change_to_chapter_safe(curr_chapter - 1)
	
func restart_chapter():
	change_to_chapter_safe(curr_chapter)
	
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
	get_tree().paused = false
	await transition_controller.animate_out()

func _clear_scene(delete: bool = true, keep_running: bool = false) -> void:
	get_tree().paused = true
	
	if delete:
		if curr_gui_scene:
			curr_gui_scene.queue_free()
			curr_gui_scene = null
		if curr_scene:
			curr_scene.queue_free()
			curr_scene = null
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
