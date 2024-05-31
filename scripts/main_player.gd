extends CharacterBody2D

@export var speed = 200
@export var jump_force = 400.0

var GRAVITY = ProjectSettings.get_setting("physics/2d/default_gravity")

var current_direction = "none"
var animation_player = null
@export var attack_timer = 0.0
@export var attack_duration = 0.9


var enemy_inattack_zone = false
var enemy_attack_cooldown = true
var player_alive = true
var count_devil = 0
@export var player_helth = 100

var rng = RandomNumberGenerator.new()

var animations = [
	"main_player_1_atk",	#0
	"main_player_2_atk",	#1
	"main_player_3_atk",	#2
	"main_player_air_atk",	#3
	"main_player_death",	#4
	"main_player_defend",	#5
	"main_player_idle",		#6
	"main_player_j_up",		#7
	"main_player_roll",		#8
	"main_player_run",		#9
	"main_player_sp_atk",	#10
	"main_player_take_hit"	#11
]


func _ready():
	animation_player = $AnimatedSprite2D
	animation_player.play(animations[6])
	
	
func _process(delta):
	$LabelHelthBar.text = str(player_helth)
	if attack_timer > 0.0:
		attack_timer -= delta	
		if attack_timer <= 0.0:
			animation_player.stop()
			animation_player.play(animations[6])
	enemy_attack()
	if player_helth <= 0:
		player_alive = false
		player_helth = 0
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
		animation_player.play(animations[rng.randf_range(0, 3)]) #0-3 are different atacks
		Main.player_current_attack = true
		attack_timer = attack_duration		
	var count_jump_press: int = 0
	var no_movement_pressed = not (Input.is_action_pressed("down") 
		or Input.is_action_pressed("left") or Input.is_action_pressed("right") 
		or Input.is_action_pressed("jump"))	
	if no_movement_pressed and attack_timer <= 0:
		animation_player.play(animations[6])
	else:
		if Input.is_action_pressed("down"):
			animation_player.play(animations[7])
		elif Input.is_action_pressed("left"):
			animation_player.flip_h = true
			animation_player.play(animations[9])
		elif Input.is_action_pressed("right"):
			animation_player.flip_h = false
			animation_player.play(animations[9])
		elif Input.is_action_pressed("jump"):
			if is_on_floor():
				velocity.y = -jump_force
				animation_player.play(animations[7])	
	if Input.is_action_pressed("devil_mode"):
		if count_devil == 0:
			print("in if statement")
			self.jump_force *= 2
			count_devil += 1
		
		
func enemy_attack():
	if enemy_inattack_zone and enemy_attack_cooldown:
		animation_player.play(animations[11])
		attack_timer = attack_duration
		player_helth -= 20
		enemy_attack_cooldown = false
		$TimerAttackCoolDowm.start()
		print(player_helth)
		
func _on_area_2d_hitbox_body_exited(body):
	if body.has_method("enemy"):
		enemy_inattack_zone = false
		
func _on_area_2d_hitbox_body_entered(body):
	if body.has_method("enemy"):
		enemy_inattack_zone = true
		
func _on_timer_attack_cool_dowm_timeout():
	enemy_attack_cooldown = true
	
func _on_timer_attack_timer_timeout():
	$TimerAttackTimer.stop()
	Main.player_current_attack = false
	
func player():
	pass
