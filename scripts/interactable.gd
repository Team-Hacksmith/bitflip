class_name Interactable
extends Node2D

signal interact(with: Node2D)

@export var interaction_disabled: bool = false
@export var only_once: bool = false
@export var needs_e: bool = true

@onready var animation_player: AnimationPlayer = %AnimationPlayer

var indicator_active = false:
	set(new):
		indicator_active = new
		if not animation_player or interaction_disabled: return new
		if indicator_active:
			animation_player.play_backwards("hide_indicator")
		else:
			animation_player.play("hide_indicator")
			
func _input(event):
	if event.is_action_pressed("interact"):
		do_interaction()
		
func do_interaction():
	if not indicator_active or interaction_disabled: return
	indicator_active = false
	interact.emit(owner)
	if only_once:
		interaction_disabled = true


func _on_area_2d_body_entered(body: Node2D) -> void:
	if interaction_disabled: return
	if not needs_e:
		interact.emit(owner)
		if only_once:
			interaction_disabled = true
		return
		
	if body.is_in_group("player") and not indicator_active:
		indicator_active = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if interaction_disabled: return
	if not needs_e:
		return
	if body.is_in_group("player") and indicator_active:
		indicator_active = false
