class_name CharacterState
extends EntityState

@export var control: Control
@export var path_follow: Node
var rotation: Vector3
var sensitivity: float
var flip_x: bool
var flip_y: bool
var color: bool

@export var timer: Label
@export var azbestos: Label
@export var destructables: Label

func _ready() -> void:
	Global.settings_controller.setting_changed.connect(update_settings)
	update_settings()
	control.visible = false

func game_status(status) -> void:
	if status == 2 or status == 5: transition.emit("PathState")
	if status == 3: transition.emit("CharacterState")
	if status == 6: 
		path_follow.process_mode = Node.PROCESS_MODE_DISABLED
		path_follow.reparent(entity)

func enter() -> void:
	path_follow.process_mode = Node.PROCESS_MODE_DISABLED
	control.visible = true
	color = true
	if Global.character_controller != null:
		entity.set_position(Global.character_controller.position  + Vector3(0, .75, 0))

func update(delta: float) -> void:
	if Global.game_controller != null:
		if !Global.game_controller.game_status.is_connected(game_status):
			Global.game_controller.game_status.connect(game_status)
		
	entity.set_position(entity.get_position().lerp(Global.character_controller.position + Vector3(0, .75, 0), delta * 40))
	entity.set_rotation(rotation)

func physics_update(_delta: float) -> void:
	if Global.game_controller == null: return
	var val := int(Global.game_controller.time)
	
	if val <= 20:
		timer.add_theme_color_override("font_color", Color(1, 0, 0))
	else:
		timer.remove_theme_color_override("font_color")

	
	timer.text = "Przyjazd Policji: " + str(val)
	azbestos.text = "Ilość Azbestu: " + str(len(Global.game_controller.asbestos))
	destructables.text = "Ilość Mebli: " + str(len(Global.game_controller.destructibles))

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

func exit() -> void:
	control.visible = false
