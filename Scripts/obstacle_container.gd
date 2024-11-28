extends Node2D

@onready var player = get_parent().get_node("Player")
@onready var outside_camera_path = get_parent().get_node("Player/SmallPath/PathFollow2D")
@onready var ObjContainer = $container
@onready var wind_particles = get_parent().get_node("CameraContainer/Wind")

@export var max_obj_count = 20
@export var despawn_distance = 3000
@export var wind_strength = 0

var object
var objectInstance
var rng = RandomNumberGenerator.new()

var wind_toggle:bool = false
var min_wind_countdown_timeout = 5
var max_wind_countdown_timeout = 20

var min_wind_duration_timer_timeout = 5
var max_wind_duration_timer_timeout = 15

var wind_play = false

func _ready() -> void:
	randomize()
	object = preload("res://Scenes/PrefabObj/rock_a.tscn")
	$WindAudio.volume_db = -60
	
func _physics_process(delta: float) -> void:
	#print($WindAudio.volume_db)
	
	if wind_toggle:
		player.direction.x -= wind_strength
	elif !wind_toggle:
		player.direction.x
		
	if wind_play:
		if $WindAudio.volume_db != -20:
			$WindAudio.volume_db += .5
	elif !wind_play:
		if $WindAudio.volume_db != -60:
			$WindAudio.volume_db -= .5
			if $WindAudio.volume_db == -60:
				$WindAudio.stop()
				$WindAudio.play()

func _on_spawn_timer_timeout() -> void:
	rng.randomize()
	
	if ObjContainer.get_child_count() < max_obj_count:
		var rngSpawn = RandomNumberGenerator.new()
		rngSpawn.randomize()
		var spawnPicker = rngSpawn.randi_range(1,5)
		
		match spawnPicker:
			1:
				object = preload("res://Scenes/PrefabObj/plant_a.tscn")
			2:
				object = preload("res://Scenes/PrefabObj/rock_a.tscn")
			3:
				object = preload("res://Scenes/PrefabObj/rock_b.tscn")
			4:
				object = preload("res://Scenes/PrefabObj/plant_b.tscn")
			5:
				object = preload("res://Scenes/PrefabObj/rock_c.tscn")
				
		outside_camera_path.progress = rng.randi_range(0,23000)
		objectInstance = object.instantiate()
		objectInstance.position = outside_camera_path.global_position
		objectInstance.rotation = rng.randi_range(0,360)
		ObjContainer.add_child(objectInstance)
	else:
		pass

func _on_wind_countdown_timeout() -> void:
	rng.randomize()
	$WindCountdown.wait_time = rng.randi_range(min_wind_countdown_timeout,max_wind_countdown_timeout)
	wind_toggle = true
	wind_particles.emitting = true
	wind_play = true
	print("Wind blowing!")
	$WindDurationTimer.start()

func _on_wind_duration_timer_timeout() -> void:
	rng.randomize()
	wind_toggle = false
	wind_particles.emitting = false
	wind_play = false
	$WindDurationTimer.wait_time = rng.randi_range(min_wind_duration_timer_timeout,max_wind_duration_timer_timeout)
	print("Wind stopped. Blows again in: ", $WindCountdown.wait_time)
	$WindCountdown.start()
