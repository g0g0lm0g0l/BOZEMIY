extends Node2D

const PLATFORM_SCENE = preload("res://scenes/platform.tscn")
const FRUIT = preload("res://scenes/fruit.tscn")
const ENEMY = preload("res://scenes/enemy.tscn")

const PLATFORM_COUNT = 120

# Watch the logic below
const TOP_LIMIT_Y = -1000
const BOTTOM_LIMIT_Y = 500
const LEFT_LIMIT_X = 0
const RIGHT_LIMIT_X = 1050

var random_number_generator = RandomNumberGenerator.new()

func _ready():
	for i in range(0, PLATFORM_COUNT):
		var random_x: float = random_number_generator.randf_range(LEFT_LIMIT_X + i * 2, RIGHT_LIMIT_X)
		var random_y: float = random_number_generator.randf_range(BOTTOM_LIMIT_Y - i, TOP_LIMIT_Y)
		add_platform(random_x, random_y)
		if i % 2 == 0:
			add_friut(random_x, random_y)
			
			
func add_platform(random_x: float,random_y: float):
	var platform_instance = PLATFORM_SCENE.instantiate()
	platform_instance.position = Vector2(random_x, random_y)	
	add_child(platform_instance)
	
	
func add_friut(random_x: float,random_y: float):
	var fruit_instance = FRUIT.instantiate()
	fruit_instance.position = Vector2(random_x, random_y-15)
	add_child(fruit_instance)
	
	
func _process(delta):
	pass
