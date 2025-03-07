extends CharacterBody2D

@export var speed: int = 400
@export var gravity: int = 600
@export var jump_speed: int = -400
@export var dash_speed: int = 1000
@export var dash_duration: float = 0.2
@export var ground_slam_speed: int = 1200

var start_position: Vector2  # Store the initial spawn position
var can_double_jump: bool = false
var is_dashing: bool = false
var dash_direction: Vector2 = Vector2.ZERO
var dash_timer: float = 0.0
var can_ground_slam: bool = false

func _ready():
	start_position = global_position  # Save the player's start position

func get_input():
	velocity.x = 0
	if is_on_floor():
		can_double_jump = true
		can_ground_slam = false
		if Input.is_action_just_pressed("jump"):
			velocity.y = jump_speed
	elif can_double_jump and Input.is_action_just_pressed("jump"):
		velocity.y = jump_speed
		can_double_jump = false

	if Input.is_action_pressed("right"):
		velocity.x += speed
	if Input.is_action_pressed("left"):
		velocity.x -= speed

	if Input.is_action_just_pressed("dash") and not is_dashing:
		if Input.is_action_pressed("right"):
			dash_direction = Vector2(1, 0)
		elif Input.is_action_pressed("left"):
			dash_direction = Vector2(-1, 0)
		if dash_direction != Vector2.ZERO:
			is_dashing = true
			dash_timer = dash_duration

	if Input.is_action_just_pressed("ground_slam") and not is_on_floor() and can_ground_slam:
		velocity.y = ground_slam_speed
		can_ground_slam = false

func _physics_process(delta):
	if is_dashing:
		velocity = dash_direction * dash_speed
		dash_timer -= delta
		if dash_timer <= 0:
			is_dashing = false
	else:
		velocity.y += delta * gravity
		get_input()
		move_and_slide()

func _process(_delta):
	if not is_on_floor():
		$Animator.play("Jump")
	elif velocity.x != 0:
		$Animator.play("Walk")
	else:
		$Animator.play("Idle")

	if velocity.x != 0:
		$Sprite2D.flip_h = velocity.x < 0  # Flip sprite based on movement direction

	# Allow ground slam when falling
	if not is_on_floor() and velocity.y > 0:
		can_ground_slam = true

# Function to reset player position (called when hit by fish or falls)
func reset_position():
	global_position = start_position  # Reset to the original position
	velocity = Vector2.ZERO  # Stop any movement
	can_double_jump = false
	is_dashing = false
	dash_timer = 0.0
	can_ground_slam = false
	print("Player reset to starting position!")
