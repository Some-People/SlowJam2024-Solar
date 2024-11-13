extends CanvasLayer

@onready var player = get_parent().get_node("Player")
var player_velocity
var is_draggable
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
	pass


func _on_reset_char_pos_pressed() -> void:
	player.position = Vector2.ZERO
	player.velocity = Vector2.ZERO
	pass # Replace with function body.
