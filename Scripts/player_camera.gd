extends Camera2D

@onready var player = get_parent().get_node("Player")

func _ready() -> void:
	pass


func _physics_process(delta: float) -> void:
	if player.direction > Vector2.ZERO:
		position = player.global_position
	
	if player.direction < Vector2.ZERO:
		position = player.global_position


func _on_player_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	
	pass # Replace with function body.
