extends Node2D
@onready var player = get_parent().get_node("Player")

var current_position:Vector2
var player_position:Vector2

var border_check_y = 620
var border_check_x = 1090

func _physics_process(delta: float) -> void:
	if global_position.distance_to(player.global_position)>3000:
		global_position = player.global_position
		pass



func _on_timer_timeout() -> void:
	current_position = global_position
	player_position = player.global_position

	var bot = player_position.y > current_position.y+border_check_y
	var top = player_position.y < current_position.y-border_check_y
	var right = player_position.x > current_position.x+border_check_x
	var left = player_position.x < current_position.x-border_check_x

	position.y = position.y + (1240 * int(bot)) - (1240 * int(top))
	position.x = position.x + (2208 * int(right)) - (2208 * int(left))


func _on_tiling_border_body_shape_exited(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	$ExitTimer.start()
