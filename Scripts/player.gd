extends CharacterBody2D
#const SPEED = 200
var is_dragging:bool = false
var draggable:bool = false

var vec_start:Vector2
var vec_fin:Vector2
@onready var line = $Line2D


func _ready() -> void:
	print(position)
	pass # Replace with function body.


func _process(delta: float) -> void:
	#print(velocity)

	
	pass

func _physics_process(delta: float) -> void:
#	var input = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
#	if input.length() > 0:
#		velocity = input * SPEED
#	else:
#		velocity = velocity.move_toward(Vector2.ZERO, SPEED)
#	move_and_slide()
	pass


func _on_mouse_entered() -> void:
	if not is_dragging:
		scale = Vector2(1.03,1.03)
	pass # Replace with function body.


func _on_mouse_exited() -> void:
	if not is_dragging:
		scale = Vector2(1,1)
	
	pass # Replace with function body.


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if Input.is_action_just_pressed("click"):
		vec_start = position
		print(vec_start)
		#vec_fin = vec_start
		line.points[0] = to_local(vec_start)


	if Input.is_action_pressed("click"):
		global_position = get_global_mouse_position()
		vec_fin = global_position
		line.points[1] = to_local(vec_fin)
		
		pass
	
	if Input.is_action_just_released("click"):
		print(vec_start)
