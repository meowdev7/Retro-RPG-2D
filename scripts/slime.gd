extends CharacterBody2D

var speed = 100

var player: Node2D = null

var health = 100
var player_in_attack_zone = false

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	handleDMG()
	if player:
		
		var direction = (player.global_position - global_position).normalized()
		global_position += direction * speed * delta

		
		animated_sprite_2d.play('walk')

		
		animated_sprite_2d.flip_h = direction.x < 0
	else:
		
		animated_sprite_2d.play('idle')
func Player():
	pass	

func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):  
		player = body

func _on_detection_area_body_exited(body: Node2D) -> void:
	if body == player:
		player = null


func _on_hitbox_slime_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):  
		player_in_attack_zone = true


func _on_hitbox_slime_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):  
		player_in_attack_zone = false

func handleDMG():
	if player_in_attack_zone and Global.player_current_attack == true:
		health = health - 20
		print('Slime HP: ', health)
		if health <= 0:
			self.queue_free()
