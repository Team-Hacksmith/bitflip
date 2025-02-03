extends Node

@export var timeline: DialogicTimeline
@export var only_once: bool = true

func _ready() -> void:
	if only_once:
		if Global.no_visit_timelines.has(timeline.as_text()): return
		Dialogic.timeline_ended.connect(_on_timeline_ended)
	Dialogic.start(timeline)

func _on_timeline_ended():
	if not only_once: return
	Dialogic.timeline_ended.disconnect(_on_timeline_ended)
	Global.no_visit_timelines[timeline.as_text()] = true
	
