extends CharacterBody2D


const SPEED = 100
var current_direction = "none"

func _physics_process(delta):
	player_movement(delta)
	
	
func player_movement(delta):
	if Input.is_action_pressed("ui_up"):
		current_direction = "up"
		play_animation(1)
		velocity.y = -SPEED
		velocity.x = 0
	elif Input.is_action_pressed("ui_down"):
		current_direction = "down"
		velocity.y = SPEED
		velocity.x = 0
	elif Input.is_action_pressed("ui_left"):
		current_direction = "left"
		play_animation(1)
		velocity.y = 0
		velocity.x = -SPEED
	elif Input.is_action_pressed("ui_right"):
		current_direction = "right"
		play_animation(1)
		velocity.y = 0
		velocity.x = SPEED
	else:
		play_animation(0)
		velocity.y = 0
		velocity.x = 0   
	move_and_slide()
	
func play_animation(movement):
	var direction = current_direction
	var animation_player = $AnimatedSprite2D
	
	if direction == "right":
		animation_player.flip_h = false
		if movement == 1:
			animation_player.play("main_character_side_walk")
		elif movement == 0:
			animation_player.play("idle_main_character_front")
	if direction == "left":
		animation_player.flip_h = true
		if movement == 1:
			animation_player.play("main_character_side_walk")
		elif movement == 0:
			animation_player.play("idle_main_character_front")
	if direction == "up":
		if movement == 1:
			animation_player.play("main_character_up_and_down")
		elif movement == 0:
			animation_player.play("idle_main_character_front")
	if direction == "down":
		if movement == 1:
			animation_player.play("main_character_up_and_down")
		elif movement == 0:
			animation_player.play("idle_main_character_front")
		
