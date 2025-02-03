extends Control

@export var text_array: Array[String]

@onready var container = $ColorRect/CenterContainer
const TYPING_LABEL = preload("res://gui/typing_label.tscn")

func _ready():
	for t in text_array:
		var labl = TYPING_LABEL.instantiate()
		labl.text = t
		container.add_child(labl)
