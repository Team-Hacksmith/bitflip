extends Node2D

@onready var door: Door = %Door

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Dialogic.start("RoombaWakeUp")
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_open_door_interactable_btn_btn_pressed(body: Node2D) -> void:
	door.open()


func _on_open_door_interactable_btn_btn_released(body: Node2D) -> void:
	door.close()
