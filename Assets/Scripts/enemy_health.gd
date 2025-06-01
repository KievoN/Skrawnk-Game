extends Node3D

const MAX_HEALTH = 300.0
var health = MAX_HEALTH

func _on_take_damage(damage: float):
	health -= damage
	if health <= 0:
		die()

func die():
	queue_free()
