extends CharacterBody2D

# Constants and Variables
const SPEED = Global.player_speed
var health = Global.health

@onready var animated_sprite: AnimatedSprite2D = $animatedSprite2D

# Main loop for movement and animation
func _physics_process(delta: float) -> void:
	if health <= 0:
		health = 0
		print("Player has been killed....")
		self.queue_free()  # Remove player from the scene if dead
	
	# Handle player movement
	var direction = Vector2(
		Input.get_axis("left", "right"), 
		Input.get_axis("up", "down")
	).normalized()

	if direction != Vector2.ZERO:
		velocity = direction * SPEED
		_update_animation(direction)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, SPEED)
		_set_idle_animation()

	move_and_slide()

# Update player animation based on movement
func _update_animation(direction: Vector2) -> void:
	if abs(direction.x) > abs(direction.y):
		animated_sprite.animation = "walk_sideways"
		animated_sprite.flip_h = direction.x < 0
	else:
		if direction.y > 0:
			animated_sprite.animation = "walk_towards"
		else:
			animated_sprite.animation = "walk_away"

	animated_sprite.play()

# Set idle animation when the player is not moving
func _set_idle_animation() -> void:
	if animated_sprite.animation == "walk_sideways":
		animated_sprite.animation = "idle_side"
	elif animated_sprite.animation == "walk_towards":
		animated_sprite.animation = "idle_front"
	elif animated_sprite.animation == "walk_away":
		animated_sprite.animation = "idle_back"
	
	animated_sprite.play()
