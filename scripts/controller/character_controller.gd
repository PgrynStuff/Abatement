@icon("res://common/icons/controller/character_controller.svg")
class_name CharacterController
extends CharacterBody3D

@export var config := CharacterResource.new()
var direction: Vector3

func _ready() -> void:
	Global.character_controller = self

func _physics_process(delta: float) -> void:
	var input := Input.get_vector("character_forward","character_backward","character_left","character_right")
	direction = Vector3(input.y, 0,input.x).normalized()
	direction *= transform.basis
	
	if is_on_floor():
		ground_movement(delta)
		
		if Input.is_action_pressed("character_jump"): velocity.y = config.jump_force
	else:
		airborne_movement(delta)
	
	repel_objects()
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

func clip_velocity(normal: Vector3, overbounce: float) -> void:
	var backoff := velocity.dot(normal) * overbounce
	
	if backoff >= 0: return
	velocity -= normal * backoff
	
	var adjust := velocity.dot(normal)
	
	if adjust >= 0.0: return
	velocity -= normal * adjust

func get_speed() -> float:
	return config.sprint_force if Input.is_action_pressed("character_sprint") else config.walk_force
