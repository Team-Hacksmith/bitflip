extends Node2D

@onready var interactable: Interactable = %Interactable

@export var timeline: DialogicTimeline
@export var only_once: bool = false
@export var needs_e: bool = true

func _ready() -> void:
	interactable.only_once = only_once
	$Interactable.needs_e = needs_e

func _on_interactable_interact(_with: Node2D) -> void:
	Dialogic.start(timeline)
