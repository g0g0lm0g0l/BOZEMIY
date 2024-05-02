extends CharacterBody2D

const SPEED = 100
var current_direction = "none"
var click_position = Vector2()
var target_position = Vector2()

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	set_process_input(true)


func _process(delta):
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()


func _physics_process(delta):
	if not is_on_floor():
		self.velocity.y -= gravity * delta
	_player_movement(delta)
	

func _player_movement(delta):
	if Input.is_action_pressed("up"):
		current_direction = "up"
		_play_animation(1)
		velocity.y = -SPEED
		velocity.x = 0
	elif Input.is_action_pressed("down"):
		current_direction = "down"
		velocity.y = SPEED
		velocity.x = 0
	elif Input.is_action_pressed("left"):
		current_direction = "left"
		_play_animation(1)
		velocity.y = 0
		velocity.x = -SPEED
	elif Input.is_action_pressed("right"):
		current_direction = "right"
		_play_animation(1)
		velocity.y = 0
		velocity.x = SPEED
	elif Input.is_action_pressed("jump"):
		current_direction = "jump"
		_play_animation(1)
		velocity.y = 0
		velocity.x = 0
	elif Input.is_action_just_pressed("left_mouse_click_attack"):
		current_direction = "attack"
		_play_animation(1)
		click_position = get_global_mouse_position()
	else:
		_play_animation(0)
		velocity.y = 0
		velocity.x = 0   
	move_and_slide()
	
	
func _play_animation(movement):
	var direction = current_direction	
	var animation_player = $AnimatedSprite2D
	if movement == 0:
		animation_player.play("idle_main_character_front")
	elif movement == 1:
		if direction == "right":
			animation_player.flip_h = false
			animation_player.play("main_character_side_walk")
		if direction == "left":
			animation_player.flip_h = true
			animation_player.play("main_character_side_walk")
		if direction == "up":
			animation_player.play("main_character_up_and_down")
		if direction == "down":
			animation_player.play("main_character_up_and_down")
		if direction == "jump":
			animation_player.play("main_character_jump")
		if direction == "attack":
			animation_player.play("main_character_attack")
			
