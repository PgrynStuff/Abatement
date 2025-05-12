class_name CharacterController
extends CharacterBody3D

@export var config := CharacterResource.new()

var snapped_last_frame: bool
var last_velocity: Vector3
var direction: Vector3
var timer: float

func _ready() -> void:
	Global.character_controller = self

func _physics_process(delta: float) -> void:
	var input := Input.get_vector("character_forward","character_backward","character_left","character_right")
	direction = Vector3(input.y, 0,input.x).normalized()
	direction *= transform.basis
	
	if is_on_floor():
		ground_movement(delta)
		
		if Input.is_action_pressed("character_jump"): 
			Global.audio_controller.play_sound(config.sound, position)
			velocity.y = config.jump_force
	else:
		airborne_movement(delta)
	
	repel_objects()
	footstep(delta)
	fall_sound()
	
	if !stairs_snap(delta):
		floor_snap()
		move_and_slide()

func ground_movement(delta: float) -> void:
	var current_speed := velocity.dot(direction)
	var add_speed := get_speed() - current_speed
	
	if add_speed > 0:
		var accel_speed := config.ground_acceleration * get_speed() * delta
		accel_speed = min(accel_speed, add_speed)
		velocity += accel_speed * direction
	
	var drop = max(velocity.length(), config.ground_deceleration) * config.ground_friction * delta
	var speed = max(velocity.length() - drop, 0.0)
	
	if velocity.length() > 0: 
		speed /= velocity.length()
	
	velocity *= speed

func airborne_movement(delta: float) -> void:
	velocity.y -= config.gravity * delta
	
	var capped_speed = min((config.airborne_coefficient * direction).length(), config.airborne_cap)
	var current_speed := velocity.dot(direction)
	var add_speed = capped_speed - current_speed
	
	if add_speed > 0:
		velocity += min(config.airborne_acceleration * config.airborne_coefficient * delta, add_speed) * direction
	
	if is_on_wall():
		var normal = get_wall_normal()
		
		if normal.angle_to(Vector3.UP) > floor_max_angle and !abs(normal.dot(Vector3.UP)) < 0.1:
			motion_mode = CharacterBody3D.MOTION_MODE_FLOATING
		else:
			motion_mode = CharacterBody3D.MOTION_MODE_GROUNDED
		
		clip_velocity(normal, 1)

func clip_velocity(normal: Vector3, overbounce: float) -> void:
	var backoff := velocity.dot(normal) * overbounce
	
	if backoff >= 0: return
	velocity -= normal * backoff
	
	var adjust := velocity.dot(normal)
	
	if adjust >= 0.0: return
	velocity -= normal * adjust

func repel_objects() -> void:
	for index in get_slide_collision_count():
		var collision := get_slide_collision(index)
		var collider := collision.get_collider()
		
		if collider is not RigidBody3D: return
		
		var mass_ratio = min(1, 80 / collider.mass)
		var repel_direction := -collision.get_normal() * Vector3(1, 0, 1)
		var velocity_difference = max(0, velocity.dot(repel_direction) - collider.linear_velocity.dot(repel_direction))
		
		if mass_ratio <= 0.25: return
		collider.apply_impulse(repel_direction * velocity_difference * mass_ratio * 5, collision.get_position() - collider.global_position)

func floor_snap() -> void:
	up_direction = Vector3.UP
	
	if is_on_floor(): return
	if velocity.y > 0: return
	if velocity.y < -1: return
	
	var result : PhysicsTestMotionResult3D = PhysicsTestMotionResult3D.new()
	var params : PhysicsTestMotionParameters3D = PhysicsTestMotionParameters3D.new()
	
	params.max_collisions = 4
	params.from = global_transform
	params.recovery_as_collision = true
	params.collide_separation_ray = true
	params.motion = Vector3.DOWN * .5
	
	if !PhysicsServer3D.body_test_motion(get_rid(), params, result): return
	if result.get_collider() is RigidBody3D: return
	
	global_transform.origin += Vector3.UP * Vector3.UP.dot(result.get_travel())

func stairs_snap(delta: float) -> bool:
	if not is_on_floor() and not snapped_last_frame: return false
	if velocity.y > 0 or (velocity * Vector3(1, 0, 1)).length() == 0: return false
	
	var max_step_height := 0.5
	var min_step_height := 0.01
	var clearance_height := max_step_height * 2
	
	var horizontal_motion = velocity * Vector3(1, 0, 1) * delta
	var step_check_pos = global_transform.translated(horizontal_motion + Vector3(0, clearance_height, 0))
	
	var collision = KinematicCollision3D.new()
	if not test_move(step_check_pos, Vector3(0, -clearance_height, 0), collision): return false
	
	var collider = collision.get_collider()
	if not (collider is StaticBody3D or collider is CSGShape3D): return false
	
	var step_pos = step_check_pos.origin + collision.get_travel()
	var step_height = step_pos.y - global_position.y
	var vertical_offset = collision.get_position().y - global_position.y
	
	if step_height > max_step_height or step_height <= min_step_height or vertical_offset > max_step_height: return false
	
	var raycast := get_child(0)
	raycast.global_position = collision.get_position() + Vector3(0, max_step_height * 0.8, 0) + horizontal_motion.normalized() * 0.05
	raycast.force_raycast_update()
	
	if raycast.is_colliding() and not is_too_steep(raycast.get_collision_normal()):
		global_position = step_pos
		floor_snap()
		snapped_last_frame = true
		return true
	
	return false

func footstep(delta: float) -> void:
	if !is_on_floor(): return
	timer -= delta * Vector2(velocity.x, velocity.z).length()
	
	if timer > 0: return
	timer = 2.7
	
	Global.audio_controller.play_sound(config.sound, position)

func fall_sound() -> void:
	if is_on_floor() && last_velocity.y < -4: 
		Global.audio_controller.play_sound(config.sound, position)
	
	last_velocity = velocity

func is_too_steep(normal : Vector3) -> bool:
	return normal.angle_to(Vector3.UP) > floor_max_angle

func get_speed() -> float:
	return config.sprint_force if Input.is_action_pressed("character_sprint") else config.walk_force
