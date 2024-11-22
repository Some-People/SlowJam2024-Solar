extends Node2D
@onready var player = get_parent().get_node("Player")
@onready var tile = "res://Scenes/tile.tscn"

func _physics_process(delta: float) -> void:
	#position = player.global_position
	pass

func _on_top_border_area_exited(area: Area2D) -> void:
	position.y -= 1240
	pass # Replace with function body.


func _on_top_border_area_entered(area: Area2D) -> void:
	#position.y -= 1240
	print("right-o")
	pass # Replace with function body.


func _on_bottom_border_body_entered(body: Node) -> void:
	#position.y += 1240
	print("ty-o")
	pass # Replace with function body.


func _on_bottom_border_body_exited(body: Node2D) -> void:
	position.y += 1240
	pass # Replace with function body.
