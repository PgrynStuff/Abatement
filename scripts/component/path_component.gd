class_name PathComponent
extends Path3D

func _ready() -> void:
	Global.camera_controller.get_state("PathState").path = self
