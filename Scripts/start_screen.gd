extends CanvasLayer

@onready var player = get_parent().get_node("Player")
@onready var path = $Exit/PathFollow2D
@onready var sprite = $Node2D/AnimatedSprite2D
@onready var animation = $Node2D/AnimatedSprite2D/AnimationPlayer
@onready var lifebarroute = get_parent().get_node("UI/Path2D/PathFollow2D")

var game_start:bool = false
var sp = 100

func _process(delta: float) -> void:
	$Node2D.position = path.global_position
	if game_start:
		path.progress += sp * delta
		lifebarroute.progress += sp*delta
		sp+=10
		
	if path.progress_ratio >= .90:
		queue_free()

func _on_area_2d_mouse_entered() -> void:
	sprite.frame += 1

func _on_area_2d_mouse_exited() -> void:
	sprite.frame -= 1

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if Input.is_action_just_pressed("click"):
		game_start = true
		animation.stop()
		animation.play("rotate_out")
		await get_tree().create_timer(1).timeout
		player.process_mode = Node.PROCESS_MODE_INHERIT
		player.set_visible(true)
		
