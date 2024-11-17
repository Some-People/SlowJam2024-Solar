extends CharacterBody2D

@export var release_speed:int = 5
@export var movement_damper = 0.035

var draggable:bool = false
var direction := Vector2.ZERO

var max_pull_pos:Vector2
var max_pull = false

var initial_position:Vector2
var dragged_position:Vector2
var pull_length

@export var life_loss_rate = .01

@onready var guide_line = get_parent().get_node("GuideLine")
@onready var health_bar = get_parent().get_node("UI/HealthBar")

func _physics_process(delta):
##Slingshot movement inputs
	health_bar.value = health_bar.value-life_loss_rate
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
			print(health_bar.value)
##Movement execution
	velocity = direction
	direction = lerp(direction, Vector2.ZERO, movement_damper)
	move_and_slide()

func _on_minimum_click_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
##Slingshot movement input 
#Ensures that you can only start slingshot from the player
	if Input.is_action_just_pressed("click"):
		if draggable:
			pull_length = initial_position.distance_to(dragged_position)
			direction = Vector2.ZERO
			initial_position = position
			guide_line.points[0] = initial_position
		elif !draggable:
			pass

func _on_mouse_entered() -> void:
#Resets Max Pull Range Variable
	max_pull = false

func _on_mouse_exited() -> void:
##Max Slingshot Pul Range
#Grabs the coords of mouse when leaving the slingshot aim boundary
	max_pull = true
	max_pull_pos = get_global_mouse_position()

func _on_minimum_click_area_mouse_entered() -> void:
	draggable = true

func _on_minimum_click_area_mouse_exited() -> void:
	if !Input.is_action_pressed("click"):
		draggable = false
