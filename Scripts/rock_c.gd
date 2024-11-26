extends RigidBody2D 

@export var move_strength = 20

var applied_forces: Vector2 = Vector2(0, 0)

func add_force_for_frame(force: Vector2):
	applied_forces += force
	self.apply_central_force(force)

func _ready() -> void:
	self.gravity_scale = 0

func _physics_process(delta: float) -> void:
	add_force_for_frame(-applied_forces)

	if self.linear_velocity.length() == 0:
		var mu_static = 0.8
		self.add_force_for_frame(- self.mass * mu_static * self.linear_velocity.normalized())
	else:
		var mu_moving = .5
		self.add_force_for_frame(- self.mass * mu_moving * self.linear_velocity.normalized())
