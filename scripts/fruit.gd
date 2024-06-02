# This script manages the behavior of fruits in the game. When collected by the player,
# the player's health is increased, and a sound effect is played.
extends Area2D

# Random number generator instance for selecting a random fruit animation
var rng = RandomNumberGenerator.new()

var fruit_aniamtion_names = [
		"dark_red_cherry",
		"green_apple",
		"green_pear",
		"orange_orange",
		"pineapple",
		"red_apple", 
		"red_cherry",
		"red_peach",
		"yellow_apple", 
		"yellow_banana"
]

# Called when the node enters the scene tree for the first time.
func _ready():
	"""
	Called when the node enters the scene tree for the first time.
	Selects a random fruit animation and starts playing it.
	"""
	# Select a random fruit animation and play it
	var random_fruit: int= rng.randi_range(0, len(fruit_aniamtion_names) - 1)
	$AnimatedSprite2D.play(fruit_aniamtion_names[random_fruit])


func _process(delta):
	"""
	Called every frame. Currently, it does not perform any actions.

	Args:
		delta (float): Time elapsed since the last frame.
	"""
	pass
	
func _on_body_entered(body):
	"""
	Signal handler for when a body enters the Area2D.
	Increases the player's health, plays a sound effect, and removes the fruit from the scene.

	Args:
		body (Node): The body that entered the area.
	"""
	body.player_helth += 10
	body.audio_stream_player_recolect_product.play(0.0)
	print("+1 fruit, player_helth == " + str(body.player_helth))
	queue_free()

func fruit():
	"""
	Placeholder function for fruit logic.
	"""
	pass
