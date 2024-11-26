extends StaticBody2D

@onready var player = get_parent().get_parent().get_parent().get_node("Player")

func _process(delta: float) -> void:
	if position.distance_to(player.position) > 2000:
		queue_free()
