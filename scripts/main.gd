extends Node2D

@onready var door: Door = %Door

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Dialogic.start("RoombaWakeUp")
	pass


func _on_open_door_interactable_btn_btn_pressed(_body: Node2D) -> void:
	door.open()


func _on_open_door_interactable_btn_btn_released(_body: Node2D) -> void:
	door.close()
