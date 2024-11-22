extends Node2D

@onready var player = get_parent().get_node("Player")
@onready var camera = $PlayerCamera

func _physics_process(delta: float) -> void:
	position = player.global_position
	#camera.position = Vector2( 
	#(position.x + 4) - (fmod(position.x + 4, 8)) - position.x,
	#(position.y + 4) - (fmod(position.y + 4, 8)) - position.y
	#)
	
