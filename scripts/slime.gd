extends CharacterBody2D

var speed = 100

var player: Node2D = null
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	if player:
		# Move directly toward the player
		var direction = (player.global_position - global_position).normalized()
		global_position += direction * speed * delta

		# Play walking animation
		animated_sprite_2d.play('walk')

		# Flip sprite based on direction
		animated_sprite_2d.flip_h = direction.x < 0
	else:
		# Play idle animation when no player is in range
		animated_sprite_2d.play('idle')

func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):  # Ensure the body is the player
		player = body

func _on_detection_area_body_exited(body: Node2D) -> void:
	if body == player:
		player = null
