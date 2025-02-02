class_name Player
extends CharacterBody2D

var speed: int = 0
@export var friction = 0.9
@export var gravity = 10
var jump_force: int = 0
# This represents the player's inertia.
@export var push_force = 200
@export var default_stats: PlayerStats = preload("res://resources/default_player_stats.tres") 

@onready var ap = $AnimationPlayer
@onready var sprite = $Sprite2D
@onready var coyote_timer = $CoyoteTimer
@onready var jump_buffer_timer = $JumpBufferTimer
@onready var jump_height_timer = $JumpHeightTimer
@onready var tire_smoke_left: CPUParticles2D = $TireSmoke
@onready var tire_smoke_right: CPUParticles2D = $TireSmoke2
@onready var dead_particles: CPUParticles2D = %DeadParticles

var can_coyote_jump = false
var jump_buffered = false
var is_disabled = false
var stats: PlayerStats = default_stats

func _ready() -> void:
	stats.health = 100
	Global.player_stats = stats
	Global.player = self
	apply_abilities()
	stats.dead.connect(_on_player_dead)

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
	move_and_slide()
	# Handle pushing objects
	handle_pushing(delta)


func apply_abilities():
	var aspeed = Global.BrokenParts.WHEEL in stats.parts_obtained
	var ajump = Global.BrokenParts.SPRING in stats.parts_obtained
	var agun = Global.BrokenParts.GUN in stats.parts_obtained
	if aspeed:
		speed = stats.max_speed
	else:
		speed = stats.min_speed
	
	if ajump:
		jump_force = stats.max_jump_force
	else:
		jump_force = 0
	
	if agun:
		%PlayerGun.show()
		%PlayerGun.can_shoot = true
	else:
		%PlayerGun.can_shoot = false
		%PlayerGun.hide()
		
	if not aspeed:
		sprite.frame = 0
	elif not ajump:
		sprite.frame = 1
	elif not agun:
		sprite.frame = 2
	else:
		sprite.frame = 2
	
	
func handle_pushing(delta):
	for i in get_slide_collision_count():
		var c = get_slide_collision(i)
		var collider = c.get_collider()
		if collider is CharacterBody2D and collider.is_in_group("moveable"):
			var obj: Moveable = collider
			#var push_velocity = velocity * delta  # Factor in the character's velocity
			var push_strength = push_force + velocity.x * 10  # Scale force based on velocity
			obj.velocity.x = -c.get_normal().x * push_strength
			#collider.velocity.x = velocity.x
			#print(c.get_normal())
			
func handle_inputs(horizontal_direction: float):
	if is_disabled: return
	if stats.health == 0: return
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
	sprite.position.x = horizontal_direction * 4

func die():
	print("DED")
	stats.health = 0

func _on_player_dead():
	sprite.queue_free()
	$CollisionShape2D.queue_free()
	$CollisionShape2D2.queue_free()
	$PlayerGun.queue_free()
	dead_particles.emitting = true
