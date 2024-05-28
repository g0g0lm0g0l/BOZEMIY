extends CharacterBody2D

@export var SPEED:float = 30.0
@export var JUMP_VELOCITY = -400.0
var animation_enemy = null
var player_chase = false	#cazando
var player = null


var player_inattack_zone = false
var can_take_damage = true
@export var one_hit_damage = 50

var floor_enemy_helth = 100

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _ready():
	animation_enemy = $AnimatedSprite2D

func _process(delta):
	$LabelEnemyHelthBar.text = str(floor_enemy_helth)

func _physics_process(delta):
	behave_floor_enemy(delta)
	move_and_slide()
	treat_with_damage()
	

func behave_floor_enemy(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	if player_chase:
		self.position += (player.position - self.position)/SPEED
		animation_enemy.play("wakl_enemy_character")
		if (player.position.x - self.position.x) < 0:
			animation_enemy.flip_h = true
		else: 
			animation_enemy.flip_h = false
	else:
		animation_enemy.play("idle_enemy_character")
	
	
#TODO: implement another enemy that will fly and attack in the platforms
#to do so i need just eliminate check is_on_floor(), maybe with simple boolean variable
	

#func _physics_process(delta):
	#if not is_on_floor():
		#velocity.y += gravity * delta
#
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY
#
	#var direction = Input.get_axis("ui_left", "ui_right")
	#if direction:
		#if direction > 0:
			#animation_enemy.flip_h = false
		#else:
			#animation_enemy.flip_h = true
		#velocity.x = direction * SPEED
		#animation_enemy.play("wakl_enemy_character")
	#else:
		#velocity.x = move_toward(velocity.x, 0, SPEED)
		#animation_enemy.play("idle_enemy_character")
	#move_and_slide()


func _on_area_2d_detection_area_body_entered(body):
	player = body
	player_chase = true
	print("LOG: persiguiendo")
	
	
func _on_area_2d_detection_area_body_exited(body):
	player = null
	player_chase = false
	print("LOG: acabo de perseguir")
	
func _on_area_2d_damage_zone_body_exited(body):
	print("LOG: contact with enemy")
	
	
func _on_area_2d_hitbox_body_entered(body):
	if body.has_method("player"):
		print("LOG: player in attack zone")
		player_inattack_zone = true


func _on_area_2d_hitbox_body_exited(body):
	if body.has_method("player"):
		print("LOG: player exited attack zone")
		player_inattack_zone = false

func treat_with_damage():
	if player_inattack_zone and Main.player_current_attack and can_take_damage:
		floor_enemy_helth -=  one_hit_damage
		$TimerTakeDamageCooldown.start()
		can_take_damage = false
		print("enemy floor_enemy_helth == " + str(floor_enemy_helth))
		if floor_enemy_helth <= 0:
			Main.player_current_attack = false
			self.queue_free()


func _on_timer_take_damage_cooldown_timeout():
	can_take_damage = true

func enemy():
	pass
