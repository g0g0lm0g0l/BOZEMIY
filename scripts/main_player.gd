# This script manages the player's movement, attacks, health, and interactions with enemies.
# It also handles animations and audio playback for various player actions.
extends CharacterBody2D

# Exported variables for editor tweaking
@export var speed = 200
@export var jump_force = 500.0
@export var useful_timer = 0.0
@export var attack_duration = 0.9
@export var surrender_duration = 1
@export var player_helth = 100

# Gravity value fetched from project settings
var GRAVITY = ProjectSettings.get_setting("physics/2d/default_gravity")

# Onready variables to reference nodes in the scene
@onready var audio_stream_player_recolect_product = $AudioStreamPlayerRecolectProduct
@onready var audio_stream_player_surrender = $AudioStreamPlayerSurrender
@onready var audio_stream_player = $AudioStreamPlayer

# Various state variables
var current_direction = "none"
var animation_player = null
var enemy_inattack_zone = false
var enemy_attack_cooldown = true
var player_alive = true
var count_devil = 0
var flag_surrender_idle = 0

# Random number generator instance
var rng = RandomNumberGenerator.new()

# List of animations used for the player
var animations = [
	"main_player_1_atk",	#0
	"main_player_2_atk",	#1
	"main_player_3_atk",	#2
	"main_player_sp_atk",   #3
	"main_player_air_atk",	#4
	"main_player_death",	#5
	"main_player_defend",	#6	
	"main_player_idle",		#7
	"main_player_j_up",		#8
	"main_player_roll",		#9
	"main_player_run",		#10
	"main_player_take_hit"	#11
]


func _ready():
	"""
	Called when the node is added to the scene.
	Initializes various state variables and plays the idle animation.
	"""
	flag_surrender_idle = 0
	animation_player = $AnimatedSprite2D
	animation_player.play(animations[7])
	
	
func _process(delta):
	"""
	Called every frame. Updates health label, handles surrender logic, and enemy attacks.

	Args:
		delta (float): Time elapsed since the last frame.
	"""
	$LabelHelthBar.text = str(player_helth)
	if Input.is_action_just_pressed("death"):
		print("you surrendered")
		audio_stream_player_surrender.play(0.0)	
		useful_timer = surrender_duration
		animation_player.play(animations[5])	
		flag_surrender_idle = 1
	if useful_timer > 0.0:
		useful_timer -= delta	
		if useful_timer <= 0.0:
			animation_player.stop()
			if flag_surrender_idle == 1:
				get_tree().reload_current_scene()
			else:
				animation_player.play(animations[7])
	enemy_attack()
	if player_helth <= 0:
		player_alive = false
		player_helth = 0
		print("player has been killed")
		get_tree().reload_current_scene()
		
		
func _physics_process(delta):
	"""
	Called every physics frame. Handles gravity and player movement.

	Args:
		delta (float): Time elapsed since the last physics frame.
	"""
	velocity.y += GRAVITY * delta
	_player_movement(delta)
	move_and_slide()
	
func _player_movement(delta):
	"""
	Handles player movement and attacks based on input.

	Args:
		delta (float): Time elapsed since the last frame.
	"""
	var horizontal_directions = Input.get_axis("left", "right")
	velocity.x = speed * horizontal_directions # move_and_slide() handles frame-rate independence!!!
	if Input.is_action_just_pressed("left_mouse_click_attack"):
		animation_player.play(animations[rng.randf_range(0, 4)]) #0-4 are different atacks
		Main.player_current_attack = true
		useful_timer = attack_duration
	var no_movement_pressed = not (Input.is_action_pressed("down") 
		or Input.is_action_pressed("left") or Input.is_action_pressed("right") 
		or Input.is_action_pressed("jump"))	
	if no_movement_pressed and useful_timer <= 0:
		animation_player.play(animations[7])
	else:
		if Input.is_action_pressed("down"):
			animation_player.play(animations[8])
		elif Input.is_action_pressed("left"):
			animation_player.flip_h = true
			animation_player.play(animations[10])
		elif Input.is_action_pressed("right"):
			animation_player.flip_h = false
			animation_player.play(animations[10])
		elif Input.is_action_pressed("jump"):
			if is_on_floor():
				velocity.y = -jump_force
				animation_player.play(animations[8])
	
	if Input.is_action_pressed("devil_mode"):
		if count_devil == 0:
			self.jump_force *= 2
			print("devil_mode enabled")
			count_devil += 1
		
		
func enemy_attack():
	"""
	Handles enemy attacks when the player is in the attack zone.
	"""
	if enemy_inattack_zone and enemy_attack_cooldown:
		animation_player.play(animations[11])
		useful_timer = attack_duration
		player_helth -= 20
		audio_stream_player.play(0.0)
		enemy_attack_cooldown = false
		$TimerAttackCoolDowm.start()
		print(player_helth)
		
func _on_area_2d_hitbox_body_exited(body):
	"""
	Signal handler for when a body exits the Area2D hitbox.

	Args:
		body (Node): The body that exited the hitbox.
	"""
	if body.has_method("enemy"):
		enemy_inattack_zone = false
		
func _on_area_2d_hitbox_body_entered(body):
	"""
	Signal handler for when a body enters the Area2D hitbox.

	Args:
		body (Node): The body that entered the hitbox.
	"""
	if body.has_method("enemy"):
		enemy_inattack_zone = true
		
func _on_timer_attack_cool_dowm_timeout():
	"""
	Signal handler for when the attack cooldown timer times out.
	Allows the enemy to attack again.
	"""
	enemy_attack_cooldown = true
	
func _on_timer_attack_timer_timeout():
	"""
	Signal handler for when the attack timer times out.
	Stops the attack and resets the attack state.
	"""
	$TimerAttackTimer.stop()
	Main.player_current_attack = false
	
func player():
	"""
	Placeholder function for player logic.
	"""
	pass
