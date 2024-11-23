extends CharacterBody2D

@export var release_speed:int = 5
@export var movement_damper = 0.035
@export var life_loss_rate = .05
@export var drag_radius = 560

var draggable:bool = false
var direction := Vector2.ZERO

var max_pull_pos:Vector2
var max_pull = Vector2.ZERO
var max_reached:bool

var initial_position:Vector2
var dragged_position:Vector2
var capped_drag_position:Vector2

var pull_length
var angle

@onready var guide_line = get_parent().get_node("GuideLine")
@onready var health_bar = get_parent().get_node("UI/HealthProgBar")

@onready var animation = $AnimationPlayer
@onready var player_sprite = $PlayerSprite

func _physics_process(delta):
	pull_length = initial_position.distance_to(dragged_position)
	health_bar.value = health_bar.value-life_loss_rate
	
##Slingshot movement inputs
	if Input.is_action_pressed("click"):
		if draggable:
			if max_reached:
				dragged_position = get_global_mouse_position()
				
				angle = acos((dragged_position.x - initial_position.x)/pull_length)
				
				if (dragged_position.y - initial_position.y) < 0:
					max_pull.x = drag_radius * cos(angle)
					max_pull.y = -drag_radius * sin(angle)
				else:	
					max_pull.x = drag_radius * cos(angle)
					max_pull.y = drag_radius * sin(angle)
				
				guide_line.points[1] = to_global(max_pull)
			elif !max_reached:
				dragged_position = get_global_mouse_position()
				guide_line.points[1] = dragged_position


	if Input.is_action_just_released("click"):
		if draggable:
			draggable = false
			
			if max_reached:
				direction = ((initial_position - to_global(max_pull))*release_speed)
			else:
				direction = ((initial_position - dragged_position)*release_speed)
			
			guide_line.set_visible(false)
			animation.stop()
			animation.play("Rotate")
			
##Movement execution
	velocity = direction
	direction = lerp(direction, Vector2.ZERO, movement_damper)
	move_and_slide()
	
	#round player sprite position to the nearest 4th (keep aligned to pixel grid)
	player_sprite.position = Vector2( 
		(position.x + 4) - (fmod(position.x + 4, 8)) - position.x,
		(position.y + 4) - (fmod(position.y + 4, 8)) - position.y
		)
	##position = Vector2((position.x + 2) - (fmod(position.x + 2, 4)), (position.y + 2) - (fmod(position.y + 2, 4)))


func _on_minimum_click_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
##Slingshot movement input 
#Ensures that you can only start slingshot from the player
	if Input.is_action_just_pressed("click"):
		guide_line.set_visible(true)
		if draggable:
			direction = Vector2.ZERO
			initial_position = position
			guide_line.points[0] = initial_position
		elif !draggable:
			pass

func _on_mouse_entered() -> void:
	max_reached = false

func _on_mouse_exited() -> void:
	max_reached = true

func _on_minimum_click_area_mouse_entered() -> void:
	draggable = true

func _on_minimum_click_area_mouse_exited() -> void:
	if !Input.is_action_pressed("click"):
		draggable = false
