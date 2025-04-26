class_name CameraController
extends Node

@export var camera: Camera3D
@export var interaction_ray: RayCast3D

var interactable: InteractableComponent
var object: RigidBody3D

func _ready() -> void:
	Global.camera_controller = self

func _process(_delta: float) -> void:
	for child in get_children():
		pass

func _physics_process(_delta: float) -> void:
	move_object()
	
	if interaction_ray.get_collider() != null:
		for child in (interaction_ray.get_collider()).get_children():
			if child is InteractableComponent:
				if child != interactable:
					if interactable != null:
						interactable.exit.emit()
				child.enter.emit()
				interactable = child
	else:
		if interactable != null:
			interactable.exit.emit()
			interactable = null
	
	if (!Input.is_action_just_pressed("camera_interact") and 
		!Input.is_action_just_pressed("camera_throw")): return
	
	if interactable != null: 
		interactable.use.emit() 
	
	if pickup_object(): return
	
	drop_object()

func move_object() -> void:
	if object == null: return

	var position = interaction_ray.global_position + camera.global_transform.basis * interaction_ray.target_position
	object.linear_velocity = (position - object.global_position) * 15
	
	if !Input.is_action_just_pressed("camera_throw"): return
	
	var throw_direction = -camera.global_transform.basis.z.normalized()
	object.linear_velocity = throw_direction * 10

func pickup_object() -> bool:
	if !interaction_ray.is_colliding(): return false
	var body := interaction_ray.get_collider()
	if body is not RigidBody3D: return false
	if object != null: return false
	if body.mass > 20: return false
	
	object = body
	
	object.add_collision_exception_with(Global.character_controller)
	object.gravity_scale = 0
	
	return true

func drop_object() -> void:	
	if object == null: return
	
	object.remove_collision_exception_with(Global.character_controller)
	object.gravity_scale = 1
	object = null

func set_position(value: Vector3) -> void:
	camera.position = value

func get_position() -> Vector3:
	return camera.position

func set_rotation(value: Vector3) -> void:
	camera.rotation = value
