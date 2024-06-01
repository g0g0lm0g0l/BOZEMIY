extends Node2D

const PLATFORM_SCENE = preload("res://scenes/platform.tscn")
const FRUIT = preload("res://scenes/fruit.tscn")
const FLOOR_ENEMY = preload("res://scenes/floor_enemy.tscn")
const FLY_ENEMY = preload("res://scenes/fly_enemy.tscn")

@export var PLATFORM_COUNT = 200

@export var DISTANCE_PLATFORMS = 12
# Watch the logic below
const TOP_LIMIT_Y = -1000
const BOTTOM_LIMIT_Y = 550
const LEFT_LIMIT_X = 0
const RIGHT_LIMIT_X = 1050

var rng = RandomNumberGenerator.new()

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

@onready var sprite_2d_layer = $ParallaxBackground/ParallaxLayer/Sprite2DLayer
@onready var sprite_2d_layer_2 = $ParallaxBackground/ParallaxLayer2/Sprite2DLayer2

func _ready():
	generate_platfors()
	generate_floor_enemies()
	
			
func add_child_instance(instance: Node, position_x: float,position_y: float):
	instance.position = Vector2(position_x, position_y)	
	add_child(instance)
	
func generate_platfors():
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

func generate_floor_enemies():
	sprite_2d_layer.texture = load(background_paths[rng.randi_range(0, len(background_paths) - 1)])
	sprite_2d_layer_2.texture = load(background_paths[rng.randi_range(0, len(background_paths) - 1)])
	
	
func _process(delta):
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
