extends Node2D

var current_level = 0

@onready var health_bar = $UI/HealthProgBar
@onready var player = $Player
@onready var music = $"Music/BackgroundMusic"

var level_up:bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_level = 1

func _process(delta: float) -> void:

	if level_up:
		print("YO!")
		music.stream.set_sync_stream_volume(current_level-1,0)
		level_up = false
