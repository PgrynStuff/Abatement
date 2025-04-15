class_name CharacterState
extends EntityState

var rotation: Vector3

func enter() -> void:
	if Global.character_controller != null:
		entity.set_position(Global.character_controller.position  + Vector3(0, .75, 0))

func update(delta: float) -> void:
	entity.set_position(entity.get_position().lerp(Global.character_controller.position + Vector3(0, .75, 0), delta * 50))
	entity.set_rotation(rotation)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	if event is not InputEventMouseMotion:
		return

	rotation.y -= event.relative.x * 0.001
	rotation.x -= event.relative.y * 0.001
	Global.character_controller.rotation.y = -rotation.y
	rotation.x = clamp(rotation.x, deg_to_rad(-90), deg_to_rad(90))
