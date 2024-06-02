# This script handles the kill zone area, which triggers a scene reload when a body enters it.
extends Area2D

# Onready variable to reference the Timer node in the scene
@onready var timer = $Timer

func _ready():
	"""
	Called when the node is added to the scene.
	Currently, it does not perform any actions.
	"""
	pass

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
	Starts the timer and prints "fin" to the console.

	Args:
		body (Node): The body that entered the area.
	"""
	print("fin")
	timer.start()


func _on_timer_timeout():
	"""
	Signal handler for when the timer times out.
	Reloads the current scene.
	"""
	get_tree().reload_current_scene()
