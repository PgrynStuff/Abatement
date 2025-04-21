class_name DestructibleComponent
extends Node3D

@export var health: int = 100
@export var count: int = 3

func damage(value: int) -> void:
	health -= value
	if health > 0: return
	
	for i in count:
		var asbestos = load("res://entities/objects/asbestos.tscn").instantiate()
		asbestos.position = global_position
		get_tree().root.add_child(asbestos)
		
	get_parent().queue_free()
