extends CharacterBody2D

@export var speed = 100
@export var gravity = 30
@export var jump_force = 300

var current_direction = "none"
var click_position = Vector2()
var target_position = Vector2()

const GRAVITY = 1000

func _ready():
	set_process_input(true)


func _process(delta):
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()


func _physics_process(delta):
	if !is_on_floor():
		velocity.y += gravity
		if velocity.y > 1000:
			velocity.y = 1000
	_player_movement(delta)
	

func _player_movement(delta):
	var horizontal_directions = Input.get_axis("left", "right")
	velocity.x = speed * horizontal_directions
	#move_and_collide(velocity * delta)
	move_and_slide()
	if Input.is_action_pressed("up"):
		current_direction = "up"
		_play_animation(1)
	elif Input.is_action_pressed("down"):
		current_direction = "down"
		_play_animation(1)
	elif Input.is_action_pressed("left"):
		current_direction = "left"
		_play_animation(1)
	elif Input.is_action_pressed("right"):
		current_direction = "right"
		_play_animation(1)
	elif Input.is_action_pressed("jump"):
		velocity.y = -jump_force
		current_direction = "jump"
		_play_animation(1)
	elif Input.is_action_just_pressed("left_mouse_click_attack"):
		current_direction = "attack"
		_play_animation(1)
		click_position = get_global_mouse_position()
	else:
		_play_animation(0)
	
	
func _play_animation(movement):
	var direction = current_direction	
	var animation_player = $AnimatedSprite2D
	if direction == "right":
		if movement == 1:
			animation_player.flip_h = false
			animation_player.play("main_character_side_walk")
		else:
			animation_player.play("idle_main_character_front")
	if direction == "left":
		if movement == 1:
			animation_player.flip_h = true
			animation_player.play("main_character_side_walk")
		else:
			animation_player.play("idle_main_character_front")
	if direction == "up":
		if movement == 1:
			animation_player.play("main_character_up_and_down")
		else:
			animation_player.play("idle_main_character_front")
	if direction == "down":
		if movement == 1:
			animation_player.play("main_character_up_and_down")
		else:
			animation_player.play("idle_main_character_front")
	if direction == "jump":
		if movement == 1:
			animation_player.play("main_character_jump")
		else:
			animation_player.play("idle_main_character_front")
	if direction == "attack":
		#TODO: change this
		animation_player.play("main_character_attack")
		movement = 0
