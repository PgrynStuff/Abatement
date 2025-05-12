class_name InterfaceController
extends Control

@export var audio: AudioStreamPlayer
@export var enabled: Array[String]
var interfaces: Dictionary[String, Interface]

func _enter_tree() -> void:
	Global.interface_controller = self

func _ready() -> void:
	open_interface(enabled)

func open_interface(interface) -> void:
	if interface is String:
		interface = [interface]
	
	close_interface()
	
	for name in interface:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		interfaces[name].visible = true
		interfaces[name].called.emit()

func close_interface() -> void:
	for node in interfaces.values():
		node.visible = false

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		if Global.game_controller.scene != null:
			visible = !visible
	
	if visible:
		audio.volume_db = -15
	else:
		audio.volume_db = -100
	
	if Global.game_controller.scene == null:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		visible = true
