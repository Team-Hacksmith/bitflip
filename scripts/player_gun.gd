extends Node2D

@export var bullet_scene: PackedScene  # Assign Bullet scene in Inspector
@export var fire_rate: float = 0.5  # Time between shots
@export var bullet_speed: float = 500  # Speed of the bullet
@export var recoil_distance: float = 10  # How much the gun moves back
@export var recoil_time: float = 0.1  # Duration of recoil

@onready var bullet_point: Marker2D = %BulletPoint
@onready var smoke: AnimatedSprite2D = %Smoke
@onready var sprite: Sprite2D = $Sprite2D

@onready var timer: Timer = $Timer  # Ensure there is a Timer child node

var can_shoot = true

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("fire"):
		shoot()
		#pass

func shoot():
	if not can_shoot: return
	if not bullet_scene:
		return
	if smoke.is_playing():
		return
	var bullet: Bullet = bullet_scene.instantiate()
	bullet.global_position = bullet_point.global_position  # Spawn at gun position
	bullet.shoot(bullet_speed)  # Call the shoot method in Bullet
	
	smoke.play("default")
	_apply_recoil()
	Global.player.player_cam.apply_shake(5)
	Global.game_controller.curr_scene.add_child(bullet)  # Add bullet to the scene

func _apply_recoil():
	var tween = create_tween()
	#var recoil_position =  - Vector2(recoil_distance, 0)  # Move left
	tween.tween_property(sprite, "position", Vector2(-10, 0), recoil_time).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(sprite, "position", Vector2(0, 0), recoil_time).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
