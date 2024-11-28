extends Node2D

@onready var health_bar = $UI/HealthProgBar
@onready var player = $Player
@onready var music = $"Music/BackgroundMusic"
@onready var obstacle = $ObstacleContainer
@onready var sundrop = $SunDropContainer
@onready var wind_particles = $CameraContainer/Wind

var life_loss_rate = 0
var current_level = 1
var level_up:bool = false
var tween_volume = false
var current_stage_bgm_vol = 0

func _ready() -> void:
	current_level = 1

func _physics_process(delta: float) -> void:
	if health_bar.value == health_bar.min_value:
		current_level = 1
		get_tree().reload_current_scene()
		
		
	current_stage_bgm_vol = music.stream.get_sync_stream_volume(current_level)

	if tween_volume:
			music.stream.set_sync_stream_volume(current_level,current_stage_bgm_vol+1)
			if current_stage_bgm_vol == 0 :
				music.stream.set_sync_stream_volume(current_level-1,-60)
				tween_volume = false
				
		
	if level_up:
		current_level += 1
		health_bar.value = 25
		if current_level <= 5:
			tween_volume = true
		else:
			tween_volume = false
		
		life_loss_rate += 0.01
		obstacle.wind_strength += 5
		obstacle.max_wind_countdown_timeout -=5
		obstacle.max_wind_duration_timer_timeout +=3
		sundrop.max_sun_count += 40
		sundrop.heal -=1
		wind_particles.speed_scale += .3
		wind_particles.amount += 2
		
		level_up=false
		print(current_level)

	if health_bar.value == health_bar.max_value:
		level_up = true
	else:
		health_bar.value -= life_loss_rate
