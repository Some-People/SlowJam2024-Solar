extends Line2D
@onready var player = get_parent().get_node("Player")

func _process(delta: float) -> void:
	$GuideArea.position = player.global_position
