@tool
extends Joint2D

@export var segments: int = 4:
	set(new):
		segments = new
		_refresh()

@export var segment_offset: float = -4.0:
	set(new):
		segment_offset = new
		_refresh()
		
@export var refresh: bool = false:
	set(new):
		_refresh()

const ANTENNA_SEGMENT = preload("res://entities/antenna_segment.tscn")
const ANTENNA_JOINT = preload("res://entities/antenna_joint.tscn")

func _refresh():
	clear_segments()
	create_antenna()

# Creates the antenna with segments and connects them with PinJoint2D joints.
func create_antenna() -> void:
	var previous_segment: Node2D = null
	
	for i in range(segments):
		# Instantiate the segment.
		var segment_instance = ANTENNA_SEGMENT.instantiate() as Node2D
		# Position each segment vertically.
		segment_instance.position = Vector2(0, i * segment_offset)
		add_child(segment_instance)
		segment_instance.name += str(i)
		if i == 0:
			node_b = segment_instance.get_path()
		if Engine.is_editor_hint() and get_tree():
			segment_instance.owner = get_tree().edited_scene_root
		
		# If there's a previous segment, connect it to the current one with a joint.
		if previous_segment:
			var joint: PinJoint2D = ANTENNA_JOINT.instantiate()
			# Set the nodes that the joint connects.
			# Using get_path() ensures that the joint knows where to find these nodes in the scene tree.
			joint.node_a = previous_segment.get_path()
			joint.node_b = segment_instance.get_path()
			
			# Set the joint's position.
			# Here we place the joint roughly in between the two segments.
			# Adjust the offset as necessary to suit your segment's dimensions.
			joint.position = previous_segment.position + Vector2(0, segment_offset)
			
			add_child(joint)
			joint.name += str(i)
			if Engine.is_editor_hint():
				joint.owner = get_tree().edited_scene_root
		
		# Update the previous_segment to be the current one.
		previous_segment = segment_instance

func clear_segments():
	for n in get_children():
		remove_child(n)
		n.queue_free()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_refresh()
