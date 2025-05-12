class_name CharacterState
extends EntityState

var rotation: Vector3
var sensitivity: float
var flip_x: bool
var flip_y: bool

func _ready() -> void:
	Global.settings_controller.setting_changed.connect(update_settings)
	update_settings()

func enter() -> void:
	if Global.character_controller != null:
		entity.set_position(Global.character_controller.position  + Vector3(0, .75, 0))

func update(delta: float) -> void:
	entity.set_position(entity.get_position().lerp(Global.character_controller.position + Vector3(0, .75, 0), delta * 40))
	entity.set_rotation(rotation)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if Global.game_controller.scene != null:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	if event is not InputEventMouseMotion:
		return
	
	var y = event.relative.x  * sensitivity * 0.001
	var x = event.relative.y  * sensitivity * 0.001
	
	if flip_x: rotation.y += y 
	else: rotation.y -= y
	
	if flip_y: rotation.x += x
	else: rotation.x -= x
	
	Global.character_controller.rotation.y = -rotation.y
	rotation.x = clamp(rotation.x, deg_to_rad(-70), deg_to_rad(88))

func update_settings() -> void:
	sensitivity = float(Global.settings_controller.setting["mouse_sensitivity"])
	flip_x = true if Global.settings_controller.setting["mouse_invert_x"] == "true" else false
	flip_y = true if Global.settings_controller.setting["mouse_invert_y"] == "true" else false
