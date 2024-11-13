extends CharacterBody2D

@export var release_speed:int = 5
@export var damper = 0.035

var is_dragging:bool = false
var draggable:bool = false
var direction := Vector2.ZERO

var max_pull_pos:Vector2
var max_pull = false

var initial_position:Vector2
var dragged_position:Vector2
var pull_length

@onready var guide_line = get_parent().get_node("GuideLine")

func _physics_process(delta):

	if Input.is_action_pressed("click"):
		if draggable:
			if !max_pull:
				dragged_position = get_global_mouse_position()
				guide_line.points[1] = dragged_position
			elif max_pull:
				dragged_position = max_pull_pos
				guide_line.points[1] = dragged_position

	if Input.is_action_just_released("click"):
		if draggable:
			draggable = false
			max_pull = false
			guide_line.points[0] = Vector2.ZERO
			guide_line.points[1] = Vector2.ZERO
			max_pull_pos = Vector2.ZERO
			direction = ((initial_position - dragged_position)*release_speed)

	velocity = direction
	direction = lerp(direction, Vector2.ZERO, damper)
	move_and_slide()
	
func _process(delta: float) -> void:
	pass

func _on_input_event(viewport, event, shape_idx):
	pass

func _on_minimum_click_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if Input.is_action_just_pressed("click"):
		pull_length = initial_position.distance_to(dragged_position)
		direction = Vector2.ZERO
		initial_position = position
		guide_line.points[0] = initial_position

func _on_mouse_entered() -> void:
	max_pull = false

func _on_mouse_exited() -> void:
	max_pull = true
	max_pull_pos = get_global_mouse_position()

func _on_minimum_click_area_mouse_entered() -> void:
	draggable = true


func _on_minimum_click_area_mouse_exited() -> void:
	if !Input.is_action_pressed("click"):
		draggable = false
