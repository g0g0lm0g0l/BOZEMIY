extends CharacterBody2D

@export var speed = 200
@export var jump_force = 300.0

var GRAVITY = ProjectSettings.get_setting("physics/2d/default_gravity")

var current_direction = "none"
var animation_player = null
@export var attack_timer = 0.0
@export var attack_duration = 0.9


var enemy_inattack_zone = false
var enemy_attack_cooldown = true
var player_alive = true


func _ready():
	animation_player = $AnimatedSprite2D
	animation_player.play("idle_main_character_front")
	
	
func _process(delta):
	$LabelHelth.text = str(Main.player_helth)
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	if attack_timer > 0.0:
		attack_timer -= delta	
		if attack_timer <= 0.0:
			animation_player.stop()
			animation_player.play("idle_main_character_front")
	enemy_attack()
	if Main.player_helth <= 0:
		player_alive = false
		Main.player_helth = 0
		print("player has been killed")
		get_tree().reload_current_scene()
	
		
func _physics_process(delta):
	velocity.y += GRAVITY * delta
	_player_movement(delta)
	move_and_slide()
	
func _player_movement(delta):
	var horizontal_directions = Input.get_axis("left", "right")
	velocity.x = speed * horizontal_directions # move_and_slide() handles frame-rate independence!!!
	if Input.is_action_just_pressed("left_mouse_click_attack"):
		animation_player.play("main_character_attack")
		Main.player_current_attack = true
		attack_timer = attack_duration		
	
	var no_movement_pressed = not (Input.is_action_pressed("down") 
		or Input.is_action_pressed("left") or Input.is_action_pressed("right") 
		or Input.is_action_pressed("jump"))	
	if no_movement_pressed and attack_timer <= 0:
		animation_player.play("idle_main_character_front")
	else:
		if Input.is_action_pressed("down"):
			animation_player.play("main_character_up_and_down")
		elif Input.is_action_pressed("left"):
			animation_player.flip_h = true
			animation_player.play("main_character_side_walk")
		elif Input.is_action_pressed("right"):
			animation_player.flip_h = false
			animation_player.play("main_character_side_walk")
		elif Input.is_action_pressed("jump"):
			velocity.y = -jump_force
			animation_player.play("main_character_jump")	
			
func _on_area_2d_hitbox_body_entered(body):
	if body.has_method("enemy"):
		enemy_inattack_zone = true


func _on_area_2d_hitbox_body_exited(body):
	if body.has_method("enemy"):
		enemy_inattack_zone = false
		
func enemy_attack():
	if enemy_inattack_zone and enemy_attack_cooldown:
		Main.player_helth -= 20
		enemy_attack_cooldown = false
		$TimerAttackCoolDowm.start()
		print(Main.player_helth)
	
	
func _on_timer_attack_cool_dowm_timeout():
	enemy_attack_cooldown = true
	
func _on_timer_attack_timer_timeout():
	$TimerAttackTimer.stop()
	Main.player_current_attack = false
	
func player():
	pass
