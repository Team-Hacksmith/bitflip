extends Node2D

@onready var interactable: Interactable = %Interactable

@export var timeline: DialogicTimeline
@export var only_once: bool = false

func _ready() -> void:
	interactable.only_once = only_once

func _on_interactable_interact(_with: Node2D) -> void:
	Dialogic.start(timeline)
