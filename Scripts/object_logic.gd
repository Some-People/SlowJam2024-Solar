extends StaticBody2D

@onready var player = get_parent().get_parent().get_parent().get_node("Player")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	
func _process(delta: float) -> void:
	if position.distance_to(player.position) > 2000:
		queue_free()
