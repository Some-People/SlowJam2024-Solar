extends Node2D

#DONT FORGET TO RESET SIZE WHEN ACTUAL SPRITE IS CREATED!!!


@onready var player = get_parent().get_parent().get_node("Player")
@onready var health_bar = get_parent().get_parent().get_node("UI/HealthBar")

func _on_sun_drop_collision_area_entered(area):
	health_bar.value = health_bar.value + 10
	queue_free()
