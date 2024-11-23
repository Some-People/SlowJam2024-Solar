extends Node2D

@onready var SunContainer = $SunDropContainer
@onready var player = get_parent().get_node("Player")
@onready var sun_path = get_parent().get_node("Player/SolarSpawnPath/PathFollow2D")
@onready var sunObj = preload("res://Scenes/sun_drop.tscn")

var game_level = 0
var max_sun_count = 50

func _ready():
	game_level = 1


func _on_sun_timer_timeout() -> void:
	var rng = RandomNumberGenerator.new()
	var sunInstance

	if SunContainer.get_child_count() < max_sun_count:
		sun_path.progress = rng.randi_range(0,23000)
		sunInstance = sunObj.instantiate()
		sunInstance.position = sun_path.global_position
		SunContainer.add_child(sunInstance)
	elif SunContainer.get_child_count() == 0:
		pass
		#print("No more objects")
	else:
		pass
		#print(max_obj_count, "objects!")
