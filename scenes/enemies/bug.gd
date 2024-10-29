extends CharacterBody2D

var active: bool = false
var speed: int = 300
var vulnerable: bool = true
var player_near: bool = false

var health = 20

func hit():
	if vulnerable:
		vulnerable = false
		$Timers/HitTimer.start()
		health -= 10
		$AnimatedSprite2D.material.set_shader_parameter("progress", 1)
		$Particles/HitParticles.emitting = true
	if health <= 0:
		await get_tree().create_timer(0.5).timeout
		queue_free()

func _process(_delta):
	var direction = (Globals.player_pos - position).normalized()
	velocity = direction * speed
	if active:
		move_and_slide()
		look_at(Globals.player_pos)

func _on_attack_area_body_entered(_body: Node2D) -> void:
	player_near = true
	$AnimatedSprite2D.play("attack")

func _on_attack_area_body_exited(_body: Node2D) -> void:
	player_near = false
	$AnimatedSprite2D.stop()

func _on_notice_area_body_entered(_body: Node2D) -> void:
	active = true
	$AnimatedSprite2D.play("walk")

func _on_notice_area_body_exited(_body: Node2D) -> void:
	active = false
	$AnimatedSprite2D.stop()

func _on_animated_sprite_2d_animation_finished() -> void:
	if player_near:
		Globals.health -= 10
		$Timers/AttackTimer.start()

func _on_attack_timer_timeout() -> void:
	$AnimatedSprite2D.play("attack")

func _on_hit_timer_timeout() -> void:
	vulnerable = true
	$AnimatedSprite2D.material.set_shader_parameter("progress", 0)
