@icon("res://common/icons/controller/camera_controller.svg")
class_name CameraController
extends Node

@export var camera: Camera3D

func _ready() -> void:
	Global.camera_controller = self

func _process(delta: float) -> void:
	for child in get_children():
		pass

func set_position(value: Vector3) -> void:
	camera.position = value

func get_position() -> Vector3:
	return camera.position

func set_rotation(value: Vector3) -> void:
	camera.rotation = value
