extends CharacterBody2D

const SPEED = 300.0

func _physics_process(delta: float) -> void:
	var direction = Vector2(
		Input.get_axis("left", "right"), 
		Input.get_axis("up", "down")
	)
	if direction != Vector2.ZERO:
		velocity = direction.normalized() * SPEED
	else:
		velocity = velocity.move_toward(Vector2.ZERO, SPEED)
	
	move_and_slide()
