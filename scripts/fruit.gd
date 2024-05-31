extends Area2D

var random_number_generator = RandomNumberGenerator.new()
@onready var audio_stream_player_2d = $AudioStreamPlayer2D

# Called when the node enters the scene tree for the first time.
func _ready():
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
	var random_fruit: int= random_number_generator.randf_range(0, len(fruit_aniamtion_names))
	$AnimatedSprite2D.play(fruit_aniamtion_names[random_fruit])


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass 
	

func _on_body_entered(body):
	audio_stream_player_2d.play(0.0)	
	body.player_helth += 10
	print("+1 fruit, player_helth == " + str(body.player_helth))
	queue_free()
