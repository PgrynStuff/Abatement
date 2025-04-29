class_name Interface
extends Control

func _ready() -> void:
	Global.interface_controller.interfaces.set(name, self)

func open_interface(interface) -> void:
	Global.interface_controller.open_interface(interface)
