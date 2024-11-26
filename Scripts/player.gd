extends CharacterBody2D

const PUSHFORCE = 10
@export var release_speed:int = 5
@export var movement_damper = 0.035
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


@onready var animation = $AnimationPlayer
@onready var player_sprite = $PlayerSprite

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED
	set_visible(false)

func _physics_process(delta):
	pull_length = initial_position.distance_to(dragged_position)
	
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		if collision.get_collider() is RigidBody2D:
			collision.get_collider().apply_central_impulse(-collision.get_normal()*PUSHFORCE)
	
##Slingshot movement inputs
	if Input.is_action_pressed("click"):
		
		if draggable:
			guide_line.points[0] = position
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
			
			$Stretch.stop()
			
			animation.stop()
			#$Glide.play()
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
#Slingshot movement initial input 
#Ensures that you can only start slingshot from the player model
	if Input.is_action_just_pressed("click"):
		$Stretch.play()
		guide_line.set_visible(true)
		if draggable:
			direction = Vector2.ZERO
			initial_position = position
			guide_line.points[0] = initial_position
		elif !draggable:
			pass

#Flags to properly start and end drag capping capabilities
func _on_minimum_click_area_mouse_entered() -> void:
	draggable = true

func _on_minimum_click_area_mouse_exited() -> void:
	if !Input.is_action_pressed("click"):
		draggable = false

func _on_max_pull_radius_mouse_entered() -> void:
	max_reached = false

func _on_max_pull_radius_mouse_exited() -> void:
	max_reached = true
