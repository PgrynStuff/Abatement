class_name AsbestosComponent
extends Node

@export var meshes: Array[Node]

func _ready() -> void:
	var index = randi() % meshes.size()
	for i in range(meshes.size()):
		if i != index: meshes[i].queue_free()
