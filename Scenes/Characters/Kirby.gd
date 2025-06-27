extends CharacterBody3D

enum Kirby_States {
	KIRBY_STATE_GROUND = 0,
	KIRBY_STATE_JUMP = 1
}

@export var SPEED = 5.0
@export var JUMP_VELOCITY = 4.5
var KirbyState = Kirby_States.KIRBY_STATE_GROUND;

func kirby_move():
	var input_dir := Input.get_vector("Left_Kirby", "Right_Kirby", "Forward_Kirby", "Backward_Kirby")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)


func kirby_state_ground():
	if Input.is_action_just_pressed("Jump_Kirby") and is_on_floor():
		KirbyState = Kirby_States.KIRBY_STATE_JUMP;
	kirby_move()

func kirby_state_jump():
	velocity.y = JUMP_VELOCITY
	if is_on_floor():
		KirbyState = Kirby_States.KIRBY_STATE_GROUND;

func kirby_state_manager():
	match KirbyState:
		Kirby_States.KIRBY_STATE_GROUND:
			kirby_state_ground();
		Kirby_States.KIRBY_STATE_JUMP:
			kirby_state_jump()

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	kirby_state_manager()
	print(KirbyState)
	move_and_slide()
