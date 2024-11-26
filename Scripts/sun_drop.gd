extends Node2D

@onready var player = get_parent().get_parent().get_parent().get_node("Player")
@onready var health_bar = get_parent().get_parent().get_parent().get_node("UI/HealthProgBar")
@onready var sundrophandler = get_parent().get_parent()

func _on_sun_drop_collision_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.name == "Player":
		health_bar.value += sundrophandler.heal
		queue_free()
	
func _process(delta: float) -> void:
	if position.distance_to(player.position) > 5000:
		queue_free()
		
	
