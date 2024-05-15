extends CharacterBody2D

@export var speed = 200
@export var jump_force = 300.0

var GRAVITY = ProjectSettings.get_setting("physics/2d/default_gravity")

var current_direction = "none"
var animation_player = null


func _ready():
	animation_player = $AnimatedSprite2D
	animation_player.play("idle_main_character_front")
	
	
func _process(delta):
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
		
		
func _physics_process(delta):
	velocity.y += GRAVITY * delta
	_player_movement(delta)
	move_and_slide()
	
func _player_movement(delta):
	var horizontal_directions = Input.get_axis("left", "right")
	velocity.x = speed * horizontal_directions
	if Input.is_action_pressed("down"):
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
		animation_player.play("main_character_attack")
		_play_animation(1)
	else: 
		_play_animation(0)
	
	
func _play_animation(movement):
	var direction = current_direction	
	if direction == "attack":
		animation_player.play("main_character_attack")
	else:
		if movement > 0:
			if direction == "right":
				animation_player.flip_h = false
				animation_player.play("main_character_side_walk")
			elif direction == "left":
				animation_player.flip_h = true
				animation_player.play("main_character_side_walk")
			elif direction == "down":
				animation_player.play("main_character_up_and_down")
			elif direction == "jump":
				animation_player.play("main_character_jump")
		else:
			animation_player.play("idle_main_character_front")
