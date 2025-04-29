class_name InterfaceController
extends Node

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
		interfaces[name].visible = true

func close_interface() -> void:
	for node in interfaces.values():
		node.visible = false
