@tool
extends Node2D

@export var title: String
@export var part: Global.BrokenParts
@export var texture: Texture2D:
	set(new):
		texture = new
		_on_texture_changed(new)
@export var timeline: DialogicTimeline = null

func _ready() -> void:
	_on_texture_changed(texture)

func _on_texture_changed(tex: Texture2D):
	$Sprite2D.texture = tex

func _on_interactable_interact(with: Node2D) -> void:
	#print(Global.player_stats.abilities.speed)
	if timeline:
		Dialogic.start(timeline)
	Global.player_stats.add_part(part)
	Global.player.apply_abilities()
	queue_free()
