extends Camera2D

@onready var player = get_parent().get_node("Player")

func _ready() -> void:
	pass


func _physics_process(delta: float) -> void:
	if player.direction > Vector2.ZERO:
		position = player.global_position
	
	if player.direction < Vector2.ZERO:
		position = player.global_position
