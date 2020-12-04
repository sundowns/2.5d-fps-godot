extends KinematicBody
class_name Entity

export(float) var gravity: float = 10
export(float) var falling_gravity_modifier: float = 1.0
export(float) var max_health: float = 100

const terminal_fall_velocity: float = -40.0

onready var health = max_health

var gravity_vector := Vector3.ZERO
var velocity := Vector3.ZERO

func apply_gravity(delta):
	if not is_on_floor():
		var gravity_force = Vector3.DOWN * gravity * delta
		if gravity_vector.y < 0:
			gravity_force *= falling_gravity_modifier
		gravity_vector += gravity_force
		gravity_vector.y = max(gravity_vector.y, terminal_fall_velocity)
	# Just ignoring ground-based gravity vector if the entity has JUST been pushed (so it can leave the ground)
	else:
		if is_on_floor():
			gravity_vector = -get_floor_normal() * gravity
		else:
			gravity_vector = -get_floor_normal()

func apply_movement():
	var movement = Vector3.ZERO
	movement.z = velocity.z + gravity_vector.z
	movement.x = velocity.x + gravity_vector.x
	movement.y = gravity_vector.y
	move_and_slide(movement, Vector3.UP)

func handle_ceiling_bonk():
	if is_on_ceiling() and gravity_vector.y > 0:
		gravity_vector.y = 0
