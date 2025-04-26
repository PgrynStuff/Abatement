class_name AsbestosComponent
extends Node3D

@export var meshes: Array[Node]

func _enter_tree() -> void:
	Global.game_controller.asbestos.append(self)

func _exit_tree() -> void:
	Global.game_controller.asbestos.erase(self)

func _ready() -> void:
	var index = randi() % meshes.size()
	for i in range(meshes.size()):
		if i != index: meshes[i].queue_free()
