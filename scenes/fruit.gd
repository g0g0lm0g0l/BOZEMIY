extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	#TODO: create an array of the elements and randomly play them in animation
	$AnimatedSprite2D.play("dark_red_cherry")
	#$AnimatedSprite2D.play("green_apple")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _on_body_entered(body):
	#TODO: implement in autoload
	print("+1 fruit")
	queue_free()
