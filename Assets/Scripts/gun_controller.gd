extends Node3D

@onready var scope: TextureRect = $Control/Scope
@onready var gun_mesh_instance_3d: MeshInstance3D = $Gun_MeshInstance3D

const DEFAULT_FOV: float = 80
const FIRE_DELAY: float = 2.0
const DAMAGE: float = 100.0

var can_fire: bool = true
var scope_multiplication: float = 4.0
var current_zoom = 1.0

func _ready() -> void:
	pass


func _process(delta: float) -> void:
	var camera: Camera3D = get_viewport().get_camera_3d()
	
	if !PlayerVariables.is_scoped:
		camera.fov = DEFAULT_FOV
		current_zoom = 1.0
		scope.visible = false
		gun_mesh_instance_3d.visible = true
		PlayerVariables.can_jump = true
	else:
		camera.fov = DEFAULT_FOV / scope_multiplication
		current_zoom = scope_multiplication
		scope.visible = true
		gun_mesh_instance_3d.visible = false
		PlayerVariables.can_jump = false
	
	PlayerVariables.MOUSE_SENSITIVITY = PlayerVariables.DEFAULT_MOUSE_SENSITIVITY / current_zoom

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("scope"):
		PlayerVariables.is_scoped = true
	if event.is_action_released("scope"):
		PlayerVariables.is_scoped = false
	
	# Fire the gun if scoped in and gun is ready to fire
	if event.is_action_pressed("shoot") and PlayerVariables.is_scoped and can_fire:
		shoot()
	

func shoot():
	can_fire = false
	print("Shoot")
	await get_tree().create_timer(FIRE_DELAY).timeout
	print("Gun Reset")
	can_fire = true
