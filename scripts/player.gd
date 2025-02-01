extends CharacterBody2D

@export var speed = 30
@export var friction = 0.9
@export var gravity = 10
@export var jump_force = 300

@onready var ap = $AnimationPlayer
@onready var sprite = $Sprite2D
@onready var coyote_timer = $CoyoteTimer
@onready var jump_buffer_timer = $JumpBufferTimer
@onready var jump_height_timer = $JumpHeightTimer
@onready var antennae: Node2D = $Antennae
@onready var antenna_target1: Marker2D = $Sprite2D/Antennae/AntennaTarget1
@onready var antenna_target2: Marker2D = $Sprite2D/Antennae/AntennaTarget2
@onready var tire_smoke_left: CPUParticles2D = $TireSmoke
@onready var tire_smoke_right: CPUParticles2D = $TireSmoke2

var can_coyote_jump = false
var jump_buffered = false
var is_disabled = false

func _physics_process(delta):
	# Disabling player movement when dialogic timeline is active
	is_disabled = Dialogic.current_timeline != null
	
	if !is_on_floor() && (can_coyote_jump == false):
		velocity.y += gravity
		if velocity.y > 1000:
			velocity.y = 1000
	
	var horizontal_direction = Input.get_axis("move_left", "move_right")
	handle_inputs(horizontal_direction)
	
	var was_on_floor = is_on_floor()
	velocity.x *= friction
	antenna_target1.position.x = remap(velocity.x, -speed, speed, 2, -2)
	antenna_target2.position.x = remap(velocity.x, -speed, speed, 2, -2)
	move_and_slide()
	
	# Started to fall
	if was_on_floor && !is_on_floor() && velocity.y >= 0:
		can_coyote_jump = true
		coyote_timer.start()
	
	# Touched ground
	if !was_on_floor && is_on_floor():
		if jump_buffered:
			jump_buffered = false
			print("Buffered jump")
			jump()
	
	update_animations(horizontal_direction)
	
func handle_inputs(horizontal_direction: float):
	if is_disabled: return
	if Input.is_action_just_pressed("jump"):
		jump_height_timer.start()
		jump()
	
	velocity.x += speed * horizontal_direction
	
	if horizontal_direction != 0:
		switch_direction(horizontal_direction)

func jump():
	if is_on_floor() || can_coyote_jump:
		velocity.y = -jump_force
		if can_coyote_jump:
			can_coyote_jump = false
			print("Coyote jump")
	else:
		if !jump_buffered:
			jump_buffered = true
			jump_buffer_timer.start()

func _on_coyote_timer_timeout():
	can_coyote_jump = false

func _on_jump_buffer_timer_timeout():
	jump_buffered = false

func _on_jump_height_timer_timeout():
	if !Input.is_action_pressed("jump"):
		if velocity.y < -100:
			velocity.y = -100
			print("Low jump")
	else:
		print("High jump")

func update_animations(horizontal_direction):
	if is_on_floor():
		if horizontal_direction == 0:
			stop_tire_smoke()
		else:
			start_tire_smoke()
	else:
		stop_tire_smoke()
	#else:
		#if velocity.y < 0:
			#ap.play("jump")
		#elif velocity.y > 0:
			#ap.play("fall")
	
func start_tire_smoke():
	tire_smoke_left.emitting = true
	tire_smoke_right.emitting = true
	if velocity.x > 0:
		tire_smoke_left.initial_velocity_min = velocity.x/3
		tire_smoke_left.initial_velocity_max = velocity.x/3 + 50
		tire_smoke_right.initial_velocity_min = velocity.x/3
		tire_smoke_right.initial_velocity_max = velocity.x/3 + 50
	elif velocity.x < 0:
		tire_smoke_left.initial_velocity_min = velocity.x/3
		tire_smoke_left.initial_velocity_max = velocity.x/3 - 50
		tire_smoke_right.initial_velocity_min = velocity.x/3
		tire_smoke_right.initial_velocity_max = velocity.x/3 - 50

func stop_tire_smoke():
	tire_smoke_left.emitting = false
	tire_smoke_right.emitting = false

func switch_direction(horizontal_direction):
	#sprite.flip_h = (horizontal_direction == -1)
	#antennae.scale.x = horizontal_direction
	sprite.position.x = horizontal_direction * 4
