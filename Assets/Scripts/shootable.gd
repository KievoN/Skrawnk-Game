extends Node
@onready var target_dummy: Node3D = $"../.."

const MAX_HEALTH = 300.0
var health = MAX_HEALTH

@export var damage_mult = 1.0

func _ready() -> void:
	add_to_group("shootable")

func on_shot(damage: float):
	damage *= damage_mult
	print(name + " was shot for " + str(damage) + " damage")
	health -= damage
	
	if health <= 0:
		die()

func die():
	target_dummy.queue_free()
