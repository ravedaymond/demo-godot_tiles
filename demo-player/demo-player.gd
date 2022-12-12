extends CharacterBody2D

@export var IS_TOPDOWN: bool = true
@export var IS_THREE_QUARTER: bool = false
@export_enum("SLOW:50", "NORMAL:75", "FAST:100") var SPEED: int = 75
@export var JUMP_VELOCITY: float = -100.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	if(IS_THREE_QUARTER):
		$AnimatedSprite2D.animation = "three-quarter"
		$CollisionShape2D.disabled = true
		$CollisionShape2DThreeQuarter.disabled = false

func _physics_process(delta):
	var input_xneg = Input.is_key_pressed(KEY_D) || Input.is_key_pressed(KEY_RIGHT)
	var input_xpos = Input.is_key_pressed(KEY_A) || Input.is_key_pressed(KEY_LEFT)
	var input_ypos = Input.is_key_pressed(KEY_S) || Input.is_key_pressed(KEY_DOWN)
	var input_yneg = Input.is_key_pressed(KEY_W) || Input.is_key_pressed(KEY_UP)
	if(IS_TOPDOWN):
		# Get the input y axis direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var y_direction = int(input_ypos)-int(input_yneg)
		if y_direction:
			velocity.y = y_direction * SPEED
		else:
			velocity.y = move_toward(velocity.y, 0, SPEED)
	else:
		# Add the gravity.
		if not is_on_floor():
			velocity.y += gravity * delta
		# Handle Jump.
		if input_yneg and is_on_floor():
			velocity.y = JUMP_VELOCITY

	# Get the input x axis direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var x_direction = int(input_xneg)-int(input_xpos)
	if x_direction:
		velocity.x = x_direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
	if(Input.is_action_just_pressed("ui_end")):
		get_tree().reload_current_scene()
