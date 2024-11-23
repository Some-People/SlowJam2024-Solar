extends Node2D

##DONT FORGET TO RESET SIZE WHEN ACTUAL SPRITE IS CREATED!!!

@onready var player = get_parent().get_parent().get_parent().get_node("Player")
@onready var health_bar = get_parent().get_parent().get_parent().get_node("UI/HealthProgBar")
@onready var health_number = get_parent().get_parent().get_parent().get_node("UI/HealthNumber")

func _on_sun_drop_collision_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.name == "Player":
		health_bar.value += 10
		health_number.value += 10
		queue_free()
	
func _process(delta: float) -> void:
	if position.distance_to(player.position) > 2000:
		queue_free()
