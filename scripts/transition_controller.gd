class_name TransitionController
extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func animate_in():
	animation_player.play("fade_in")
	await animation_player.animation_finished
	
func animate_out():
	animation_player.play("fade_out")
	await animation_player.animation_finished
