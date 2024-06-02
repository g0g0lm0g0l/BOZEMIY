# This script is responsible for generating the game world, including platforms, fruits, and enemies.
# It also handles the game over logic and background texture changes.
extends Node2D

# Preload scenes for various game elements
const PLATFORM_SCENE = preload("res://scenes/platform.tscn")
const FRUIT = preload("res://scenes/fruit.tscn")
const FLOOR_ENEMY = preload("res://scenes/floor_enemy.tscn")
const FLY_ENEMY = preload("res://scenes/fly_enemy.tscn")

# Onready variables to reference nodes in the scene
@onready var area_2d_game_over = $Area2DGameOver
@onready var audio_stream_player = $AudioStreamPlayer

# Exported variables for editor tweaking
@export var PLATFORM_COUNT = 200
@export var DISTANCE_PLATFORMS = 12

# Constants for scene boundaries
const TOP_LIMIT_Y = -1000
const BOTTOM_LIMIT_Y = 550
const LEFT_LIMIT_X = 0
const RIGHT_LIMIT_X = 1050

# Random number generator instance
var rng = RandomNumberGenerator.new()

# Paths to background images
var background_paths = [
	"res://assets/graphics/background/Purple Nebula/Purple_Nebula_01-1024x1024.png",
	"res://assets/graphics/background/Purple Nebula/Purple_Nebula_02-1024x1024.png",
	"res://assets/graphics/background/Purple Nebula/Purple_Nebula_03-1024x1024.png",
	"res://assets/graphics/background/Purple Nebula/Purple_Nebula_04-1024x1024.png",
	"res://assets/graphics/background/Purple Nebula/Purple_Nebula_05-1024x1024.png",
	"res://assets/graphics/background/Purple Nebula/Purple_Nebula_06-1024x1024.png",
	"res://assets/graphics/background/Purple Nebula/Purple_Nebula_07-1024x1024.png",
	"res://assets/graphics/background/Purple Nebula/Purple_Nebula_08-1024x1024.png",
]

# Onready variables to reference sprite layers in the scene
@onready var sprite_2d_layer = $ParallaxBackground/ParallaxLayer/Sprite2DLayer
@onready var sprite_2d_layer_2 = $ParallaxBackground/ParallaxLayer2/Sprite2DLayer2
@onready var label_good_game = $LabelGoodGame

func _ready():
	"""
	Called when the node is added to the scene.
	Initializes audio playback, sets the game over area position,
	and generates world elements and floor enemies.
	"""
	audio_stream_player.play(0.0)
	area_2d_game_over.position = Vector2(
		rng.randi_range(LEFT_LIMIT_X, RIGHT_LIMIT_X),
		BOTTOM_LIMIT_Y - DISTANCE_PLATFORMS*PLATFORM_COUNT
	)
	if Main.label_good_game != null:
		label_good_game.text = str("GOOD GAME!!!   " + str(Main.label_good_game))
	generate_world_elements()
	generate_background()
	
			
func add_child_instance(instance: Node, position_x: float,position_y: float):
	"""
	Adds a child instance to the scene at a specified position.
	Args:
		instance (Node): The instance to add.
		position_x (float): The x-coordinate for the instance.
		position_y (float): The y-coordinate for the instance.
	"""
	instance.position = Vector2(position_x, position_y)	
	add_child(instance)
	
func generate_world_elements():
	"""
	Generates platforms, fruits, and enemies in the game world based on defined rules.
	"""
	var random_x: float
	var random_y: float
	for i in range(0, PLATFORM_COUNT):
		random_x = rng.randi_range(LEFT_LIMIT_X, RIGHT_LIMIT_X)
		random_y = BOTTOM_LIMIT_Y - DISTANCE_PLATFORMS*i
		add_child_instance(PLATFORM_SCENE.instantiate(), random_x, random_y)
		if i % 2 == 0:
			add_child_instance(FRUIT.instantiate(), random_x, random_y - 15)
		if i % 12 == 0:
			add_child_instance(FLOOR_ENEMY.instantiate(), random_x, random_y)
		if i % 25 == 0:
			add_child_instance(FLY_ENEMY.instantiate(), random_x, 0)
	
func generate_background():
	"""
	Sets random background textures for sprite layers from predefined paths.
	"""
	sprite_2d_layer.texture = load(background_paths[rng.randi_range(0, len(background_paths) - 1)])
	sprite_2d_layer_2.texture = load(background_paths[rng.randi_range(0, len(background_paths) - 1)])
	
	
func _process(delta):
	"""
	Called every frame. Handles input actions such as quitting the game.

	Args:
		delta (float): Time elapsed since the last frame.
	"""
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
		
func _on_area_2d_game_over_body_entered(body):
	if body.has_method("player"):
		Main.label_good_game = str(body.player_helth)
		get_tree().reload_current_scene()
