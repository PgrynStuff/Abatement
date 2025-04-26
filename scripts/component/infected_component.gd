class_name InfectedComponent
extends MeshInstance3D

@export var component: DestructibleComponent

func _ready() -> void:
	if randf() > 0.5:
		return
	
	component.queue_free()
	queue_free()
