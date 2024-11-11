extends CharacterBody2D

var is_dragging:bool = false
var draggable:bool = false
var direction := Vector2.ZERO
var speed:int = 1

var initial_position:Vector2
var dragged_position:Vector2
@onready var guide_line = get_parent().get_node("GuideLine")

func _physics_process(delta):
	velocity = direction
	move_and_slide()


func _on_input_event(viewport, event, shape_idx):
	if Input.is_action_just_pressed("click"):
		initial_position = position
		direction = Vector2.ZERO
		dragged_position = initial_position
		guide_line.points[0] = initial_position

	if Input.is_action_pressed("click"):
		position = get_global_mouse_position()
		dragged_position = position
		guide_line.points[1] = dragged_position
	
	if Input.is_action_just_released("click"):
		var pull_length = initial_position.distance_to(dragged_position)
		print("Pull length: ", pull_length)
		guide_line.points[0] = Vector2.ZERO
		guide_line.points[1] = Vector2.ZERO
		direction = ((initial_position - dragged_position))
