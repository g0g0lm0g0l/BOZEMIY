# This script manages the behavior of a flying enemy, including movement, 
# detecting the player, and handling damage.
extends CharacterBody2D

@export var SPEED:float = 30.0
@export var JUMP_VELOCITY = -400.0
@export var one_hit_damage = 50

# Variables for enemy behavior
var animation_enemy = null
var player_chase = false	# Whether the enemy is chasing the player
var player = null
var player_inattack_zone = false
var can_take_damage = true
var fly_enemy_helth = 100

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var rng = RandomNumberGenerator.new()
var enemy_animtion_names = [
	"fly_enemy_flying",		#0
	"fly_enemy_hurt",		#1
	"fly_enemy_ice"			#2
]


func _ready():
	"""
	Called when the node enters the scene tree for the first time.
	Initializes the enemy's animated sprite.
	"""
	animation_enemy = $AnimatedSprite2D

	
func _process(delta):
	"""
	Called every frame. Updates the enemy's health bar.

	Args:
		delta (float): Time elapsed since the previous frame.
	"""
	$LabelEnemyHelthBar.text = str(fly_enemy_helth)

func _physics_process(delta):
	"""
	Called every physics frame. Handles enemy behavior and movement.

	Args:
		delta (float): Time elapsed since the previous physics frame.
	"""
	behave_fly_enemy(delta)
	move_and_slide()
	treat_with_damage()


func behave_fly_enemy(delta):
	"""
	Controls the behavior of the flying enemy.

	Args:
		delta (float): Time elapsed since the previous frame.
	"""
	velocity.y += gravity * delta
	animation_enemy.play(enemy_animtion_names[0])
	if player_chase:
		animation_enemy.play(enemy_animtion_names[0])
		self.position += (player.position - self.position)/SPEED
		if (player.position.x - self.position.x) < 0:
			animation_enemy.flip_h = true
		else: 
			animation_enemy.flip_h = false
				
func _on_area_2d_detection_area_body_entered(body):
	"""
	Signal handler for when a body enters the detection area.
	Starts chasing the player.

	Args:
		body (Node): The body that entered the area.
	"""
	player = body
	player_chase = true
	print("LOG: persiguiendo")


func _on_area_2d_detection_area_body_exited(body):
	"""
	Signal handler for when a body exits the detection area.
	Stops chasing the player.

	Args:
		body (Node): The body that exited the area.
	"""
	player = null
	player_chase = false
	print("LOG: acabo de perseguir")
	
	
func _on_area_2d_hitbox_body_entered(body): 
	"""
	Signal handler for when a body enters the hitbox area.
	Sets the player as in the attack zone.

	Args:
		body (Node): The body that entered the area.
	"""
	if body.has_method("player"):
		print("LOG: player in attack zone")
		player_inattack_zone = true
	
func _on_area_2d_hitbox_body_exited(body):
	"""
	Signal handler for when a body exits the hitbox area.
	Sets the player as out of the attack zone.

	Args:
		body (Node): The body that exited the area.
	"""
	if body.has_method("player"):
		print("LOG: player exited attack zone")
		player_inattack_zone = false
		
		
func treat_with_damage():
	"""
	Handles the damage logic for the enemy.
	If the player is attacking and the enemy can take damage,
	decreases the enemy's health and starts a cooldown timer.
	"""
	if player_inattack_zone and Main.player_current_attack and can_take_damage:
		animation_enemy.play(enemy_animtion_names[1])
		fly_enemy_helth -=  one_hit_damage
		$TimerTakeDamageCooldown.start()
		can_take_damage = false
		print("enemy fly_enemy_helth == " + str(fly_enemy_helth))
		if fly_enemy_helth <= 0:
			Main.player_current_attack = false
			self.queue_free()
	
func _on_timer_take_damage_cooldown_timeout():
	"""
	Signal handler for when the damage cooldown timer times out.
	Allows the enemy to take damage again.
	"""
	can_take_damage = true

func enemy():
	"""
	Placeholder function for enemy logic.
	"""
	pass

