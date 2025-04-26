class_name DestructibleComponent
extends Node3D

@export var health: int = 3
@export var count: int = 3

func _ready() -> void:
	Global.game_controller.destructibles.append(self)

func _exit_tree() -> void:
	Global.game_controller.destructibles.erase(self)

func damage(value: int) -> void:
	health -= value
	if health > 0: return
	
	create_asbestos()
	get_parent().queue_free()

func create_asbestos() -> void:
	for i in count:
		var asbestos = load("res://entities/items/asbestos.tscn").instantiate()
		asbestos.position = global_position
		get_tree().root.add_child(asbestos)
