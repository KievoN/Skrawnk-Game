extends CharacterBody3D

@onready var camera: Camera3D = $Camera3D

const GRAVITY_MULTIPLIER = 1.0

# Movement speeds
const SPEED = 1.25
const RUN_SPEED = 2
const SCOPED_SPEED = 0.5

const JUMP_VELOCITY = 0.0

# Camera limits
const TILT_LOWER_LIMIT = -89
const TILT_UPPER_LIMIT = 89

var is_running: bool

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
func _process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta * GRAVITY_MULTIPLIER

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor() and PlayerVariables.can_jump:
		velocity.y = JUMP_VELOCITY
	
	move()

func _input(event: InputEvent):
	if event.is_action_pressed("exit"):
		get_tree().quit()
	
	if event is InputEventMouseMotion:
		camera.rotate_x(deg_to_rad(-event.relative.y * PlayerVariables.MOUSE_SENSITIVITY))
		self.rotate_y(deg_to_rad(-event.relative.x * PlayerVariables.MOUSE_SENSITIVITY))
		
		# Camera movement
		var camera_rot = camera.rotation_degrees
		camera_rot.x = clamp(camera_rot.x, TILT_LOWER_LIMIT, TILT_UPPER_LIMIT)
		camera.rotation_degrees = camera_rot

func move() -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	var final_speed
	is_running = Input.is_action_pressed("run")
	
	if is_running:
		final_speed = RUN_SPEED
	else:
		final_speed = SPEED
	
	if PlayerVariables.is_scoped:
		final_speed = SCOPED_SPEED
	
	if direction:
		velocity.x = direction.x * final_speed
		velocity.z = direction.z * final_speed
	else:
		velocity.x = move_toward(velocity.x, 0, final_speed)
		velocity.z = move_toward(velocity.z, 0, final_speed)

	move_and_slide()
