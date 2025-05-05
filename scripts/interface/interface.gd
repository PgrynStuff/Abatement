class_name Interface
extends Control

func _ready() -> void:
	Global.interface_controller.interfaces.set(name, self)

func open_interface(interface) -> void:
	Global.interface_controller.open_interface(interface)

func load_scenario(name: String) -> void:
	Global.game_controller.load_scenario(name)
	Global.interface_controller.visible = false

func exit_tree() -> void:
	get_tree().quit()
