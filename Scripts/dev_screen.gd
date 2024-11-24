extends CanvasLayer

@onready var player = get_parent().get_node("Player")


@export var wind_strength = -5
var player_velocity
var is_draggable
var wind_toggle:bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Velocity.text = "N/A"
	$Draggable.text = "N/A"
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	player_velocity = str(player.velocity)
	is_draggable = str(player.draggable)
	$Velocity.text = player_velocity
	$Draggable.text = is_draggable
	
	if wind_toggle:
		player.direction.x -= wind_strength
	elif !wind_toggle:
		player.direction.x
	pass

func _on_reset_char_pos_pressed() -> void:
	get_parent().current_level += 1
	print(get_parent().current_level)
	get_parent().level_up = true

func _on_wind_activate_toggled(toggled_on):
	if !wind_toggle:
		wind_toggle = true
	elif wind_toggle:
		wind_toggle = false
	pass # Replace with function body.
