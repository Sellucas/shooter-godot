extends CharacterBody2D

signal player_laser_trigger(pos, direction)
signal player_grenade_trigger(pos, direction)

var can_laser: bool = true
var can_grenade: bool = true


func _ready() -> void:
	pass
	
func _process(_delta: float) -> void:
	var direction = Input.get_vector("left", "right", "up", "down")
	velocity = direction * 300
	move_and_slide()
	
	look_at(get_global_mouse_position())
	var player_direction = (get_global_mouse_position() - position).normalized()
	if Input.is_action_pressed("primary action") and can_laser: 
		can_laser = false
		$TimerLaser.start()
		var laser_markers = $LaserStartPositions.get_children()
		var selected_laser = laser_markers[randi() % laser_markers.size()] 
		player_laser_trigger.emit(selected_laser.global_position, player_direction)

	if Input.is_action_pressed("seconday action") and can_grenade:
		can_grenade = false
		$TimerGrenade.start()
		var grenade_markers = $GrenadeStartPositions.get_children()
		var selected_grenade = grenade_markers[randi() % grenade_markers.size()]
		player_grenade_trigger.emit(selected_grenade.global_position, player_direction)

func _on_timer_grenade_timeout() -> void:
	can_grenade = true

func _on_timer_laser_timeout() -> void:
	can_laser = true
