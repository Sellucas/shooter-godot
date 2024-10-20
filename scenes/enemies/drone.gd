extends CharacterBody2D

func _process(delta: float) -> void:
	var direction = Vector2.RIGHT
	velocity = direction * 500
	move_and_slide()
