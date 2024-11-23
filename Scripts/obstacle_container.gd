extends Node2D

@onready var player = get_parent().get_node("Player")
@onready var outside_camera_path = get_parent().get_node("Player/Path2D/PathFollow2D")
@onready var ObjContainer = $container

@export var max_obj_count = 15
@export var despawn_distance = 3000

var spawn_point:Vector2
var plantA
var plantAInstance

func _ready() -> void:
	randomize()
	plantA = preload("res://Scenes/PrefabObj/plant_a.tscn")

func _process(delta: float) -> void:
	if !plantA:
		plantA = preload("res://Scenes/PrefabObj/plant_a.tscn")

func _on_child_entered_tree(node: Node) -> void:
	pass # Replace with function body.

func _on_child_exiting_tree(node: Node) -> void:
	print("child deleted. remainin = ",get_child_count())
	pass # Replace with function body.

func _on_spawn_timer_timeout() -> void:
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	
	if ObjContainer.get_child_count() < max_obj_count:
		outside_camera_path.progress = rng.randi_range(0,9000)
		plantAInstance = plantA.instantiate()
		plantAInstance.position = outside_camera_path.global_position
		ObjContainer.add_child(plantAInstance)
	else:
		print(max_obj_count, "objects!")
		
	for i in ObjContainer.get_children():
		var i_pos = i.global_position
		if i_pos.distance_to(player.global_position) > despawn_distance:
			queue_free()
