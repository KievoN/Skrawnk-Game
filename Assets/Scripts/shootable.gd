extends Node

@export var damage_mult = 1.0

signal take_damage(damage: float)

func _ready() -> void:
	add_to_group("shootable")
	var health_manager = owner
	take_damage.connect(health_manager._on_take_damage)

func on_shot(damage: float):
	damage *= damage_mult
	print(name + " was shot for " + str(damage) + " damage")
	
	take_damage.emit(damage)
