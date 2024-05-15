extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var animation_enemy = null

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	animation_enemy = $AnimatedSprite2D


func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		if direction > 0:
			animation_enemy.flip_h = false
		else:
			animation_enemy.flip_h = true
		velocity.x = direction * SPEED
	else:
		
		velocity.x = move_toward(velocity.x, 0, SPEED)
	move_and_slide()
