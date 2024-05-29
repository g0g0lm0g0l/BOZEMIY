extends Node2D

const PLATFORM_SCENE = preload("res://scenes/platform.tscn")
const FRUIT = preload("res://scenes/fruit.tscn")
const ENEMY = preload("res://scenes/floor_enemy.tscn")

const PLATFORM_COUNT = 120

const INCREASE_Y_DISTANCE_PLATFORMS = 12
# Watch the logic below
const TOP_LIMIT_Y = -1000
const BOTTOM_LIMIT_Y = 500
const LEFT_LIMIT_X = 0
const RIGHT_LIMIT_X = 1050

var random_number_generator = RandomNumberGenerator.new()

func _ready():
	var random_x: float
	var random_y: float
	for i in range(0, PLATFORM_COUNT):
		random_x = random_number_generator.randf_range(LEFT_LIMIT_X + i * 2, RIGHT_LIMIT_X)
		random_y = BOTTOM_LIMIT_Y - i * INCREASE_Y_DISTANCE_PLATFORMS
		#add_platform(random_x, random_y)
		add_child_instance(PLATFORM_SCENE.instantiate(), random_x, random_y)
		if i % 2 == 0:
			add_child_instance(FRUIT.instantiate(), random_x, random_y - 15)
		if i % 12 == 0:
			add_child_instance(ENEMY.instantiate(), random_x, random_y)
			
			
func add_child_instance(instance: Node, position_x: float,position_y: float):
	instance.position = Vector2(position_x, position_y)	
	add_child(instance)
	
	
func _process(delta):
	pass
