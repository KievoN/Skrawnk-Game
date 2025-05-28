extends Node3D

const BULLET_HOLE_DECAL = preload("res://Assets/Scenes/bullet_hole_decal.tscn")

@onready var scope: TextureRect = $Control/Scope
@onready var gun_mesh_instance_3d: MeshInstance3D = $Gun_MeshInstance3D
@onready var ray_cast_3d: RayCast3D = $"../RayCast3D"

const DEFAULT_FOV: float = 70
const FIRE_DELAY: float = 1.0
const DAMAGE: float = 100.0

var camera: Camera3D

var can_fire: bool = true
var scope_multiplication: float = 4.0
var current_zoom = 1.0

func _ready() -> void:
	camera = get_viewport().get_camera_3d()


func _process(delta: float) -> void:
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
	shoot_raycast()
	
	await get_tree().create_timer(FIRE_DELAY).timeout
	print("Gun Reset")
	can_fire = true

func shoot_raycast():
	#var space = get_world_3d().direct_space_state
	#var origin = camera.global_position
	#var end = (camera.global_position - camera.global_transform.basis.z * 100)
	#var query = PhysicsRayQueryParameters3D.create(origin, end)

	#var collision = space.intersect_ray(query)
	
	ray_cast_3d.force_raycast_update()
	
	if ray_cast_3d.is_colliding():
		print(ray_cast_3d.get_collider().name)
		var _collider: CollisionObject3D = ray_cast_3d.get_collider()
		if _collider.is_in_group("shootable"):
			_collider.on_shot(DAMAGE)
		else:
			create_bullet_decal(ray_cast_3d.get_collision_point(), ray_cast_3d.get_collision_normal())
	else:
		print("Collision false")

func create_bullet_decal(position: Vector3, normal: Vector3):
	var bulletDecal = BULLET_HOLE_DECAL.instantiate()
	bulletDecal.position = position
	bulletDecal.transform = align_with_y(bulletDecal.transform, normal)
	bulletDecal.rotate_object_local(Vector3(0,1,0), randf())
	
	get_tree().current_scene.add_child(bulletDecal)

func align_with_y(xform, new_y):
	xform.basis.y = new_y
	xform.basis.x = -xform.basis.z.cross(new_y)
	xform.basis = xform.basis.orthonormalized()
	return xform
