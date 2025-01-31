@tool
extends DialogicPortrait

# If the custom portrait accepts a change, then accept it here
func _update_portrait(passed_character: DialogicCharacter, passed_portrait: String) -> void:
	apply_character_and_portrait(passed_character, passed_portrait)

	if $Sprite.sprite_frames.has_animation(passed_portrait):
		$Sprite.play(passed_portrait)
		
func _set_mirror(is_mirrored: bool) -> void:
	var sprite: AnimatedSprite2D = $Sprite
	if is_mirrored:
		sprite.flip_h = 1
	else:
		sprite.flip_h = 0

func _on_animation_finished() -> void:
	$Sprite.frame = randi() % $Sprite.sprite_frames.get_frame_count($Sprite.animation)
	$Sprite.play()


func _get_covered_rect() -> Rect2:
	return Rect2($Sprite.position, $Sprite.sprite_frames.get_frame_texture($Sprite.animation, 0).get_size()*$Sprite.scale)
