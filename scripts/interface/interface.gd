class_name Interface
extends Control

signal called()

func _ready() -> void:
	Global.interface_controller.interfaces.set(name, self)

func open_interface(interface) -> void:
	Global.audio_controller.play_sound("key", Global.camera_controller.get_position())
	Global.interface_controller.open_interface(interface)

func open_interface_tab(ignore, interface) -> void:
	open_interface(interface)

func load_scenario(name: String) -> void:
	Global.game_controller.load_scenario(name)
	Global.audio_controller.play_sound("key", Global.camera_controller.get_position())
	Global.interface_controller.visible = false

func exit_tree() -> void:
	get_tree().quit()
