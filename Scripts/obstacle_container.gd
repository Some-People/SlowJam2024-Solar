extends Node2D

@onready var player = get_parent().get_node("Player")
@onready var outside_camera_path = get_parent().get_node("Player/SmallPath/PathFollow2D")
@onready var ObjContainer = $container

@export var max_obj_count = 20
@export var despawn_distance = 3000
@export var wind_strength = 5

var object
var objectInstance
var rng = RandomNumberGenerator.new()

var wind_toggle:bool = false

func _ready() -> void:
	randomize()
	object = preload("res://Scenes/PrefabObj/rock_a.tscn")
	
func _physics_process(delta: float) -> void:
	if wind_toggle:
		player.direction.x -= wind_strength
	elif !wind_toggle:
		player.direction.x
	pass

func _on_spawn_timer_timeout() -> void:
	rng.randomize()
	
	if ObjContainer.get_child_count() < max_obj_count:
		var rngSpawn = RandomNumberGenerator.new()
		rngSpawn.randomize()
		var spawnPicker = rngSpawn.randi_range(1,3)
		
		match spawnPicker:
			1:
				object = preload("res://Scenes/PrefabObj/plant_a.tscn")
			2:
				object = preload("res://Scenes/PrefabObj/rock_a.tscn")
			3:
				object = preload("res://Scenes/PrefabObj/rock_b.tscn")
				
		outside_camera_path.progress = rng.randi_range(0,23000)
		objectInstance = object.instantiate()
		objectInstance.position = outside_camera_path.global_position
		ObjContainer.add_child(objectInstance)
	elif ObjContainer.get_child_count() == 0:
		print("No more objects")	
	else:
		print(max_obj_count, "objects!")


func _on_wind_countdown_timeout() -> void:
	rng.randomize()
	
	$WindCountdown.wait_time = rng.randi_range(5,20)
	wind_toggle = true
	print("Wind blowing!")
	$WindDurationTimer.start()
	pass # Replace with function body.


func _on_wind_duration_timer_timeout() -> void:
	rng.randomize()
	wind_toggle = false
	$WindDurationTimer.wait_time = rng.randi_range(5,20)
	print("Wind stopped. Blows again in: ", $WindCountdown.wait_time)
	$WindCountdown.start()
	pass # Replace with function body.
