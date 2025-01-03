extends CharacterBody2D

# Constants and Variables
const SPEED = Global.player_speed
var enemy_in_attack_range = false
var enemy_attack_cooldown = true
var health = Global.health
var player_alive = true
var attack_in_progress = false

@onready var animated_sprite: AnimatedSprite2D = $animatedSprite2D
@onready var deal_attack_timer: Timer = $DealAttackTimer

# Main loop for movement and attack logic
func _physics_process(delta: float) -> void:
	if health <= 0:
		player_alive = false
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

	# Perform enemy attack logic
	enemy_attack()
	attack()

# Update player animation based on movement and attack state
func _update_animation(direction: Vector2) -> void:
	if attack_in_progress:
		return  # Prevent movement when attack is in progress

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

# Detection for enemies (attack range)
func _on_hitbox_player_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):  
		enemy_in_attack_range = true

func _on_hitbox_player_body_exited(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		enemy_in_attack_range = false

# Handle the enemy attack
func enemy_attack():
	if enemy_in_attack_range and enemy_attack_cooldown:
		attack_in_progress = true  # Block movement while attacking
		health -= 20  # Decrease health when attacked
		enemy_attack_cooldown = false
		$AttackCooldown.start()  # Start attack cooldown timer
		print("Health after attack: ", health)

# Handle attack cooldown timeout
func _on_attack_cooldown_timeout() -> void:
	enemy_attack_cooldown = true
	attack_in_progress = false  # Allow movement again after attack is finished

# Attack logic to trigger animations
func attack():
	if Input.is_action_just_pressed("attack"):
		Global.player_current_attack = true
		attack_in_progress = true
		
		# Determine attack direction and play corresponding animation
		var direction = Vector2(
			Input.get_axis("left", "right"), 
			Input.get_axis("up", "down")
		)

		if direction.x != 0:
			# Play sideways attack animation
			animated_sprite.animation = "attack_sideways"
			animated_sprite.flip_h = direction.x < 0  # Flip if moving left
		elif direction.y > 0:
			# Play front attack animation
			animated_sprite.animation = "attack_front"
		elif direction.y < 0:
			# Play back attack animation
			animated_sprite.animation = "attack_back"

		animated_sprite.play()  # Play the selected attack animation
		
		# Start the deal attack timer to apply damage over time
		deal_attack_timer.start()

# Deal attack logic (applying damage to enemies)

func _on_deal_attack_timer_timeout() -> void:
	
	deal_attack_timer.stop()
	Global.player_current_attack = false
	attack_in_progress = false  
