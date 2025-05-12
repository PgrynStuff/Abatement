class_name DestructibleComponent
extends Node3D

@export var health: int = 3
@export var count: int = 3

@export var sfx_destruction: String
@export var sfx_damage: Array[String]

func _ready() -> void:
	Global.game_controller.destructibles.append(self)

func _exit_tree() -> void:
	Global.game_controller.destructibles.erase(self)

func damage(value: int) -> void:
	health -= value
	Global.audio_controller.play_sound(sfx_damage, global_position)
	if health > 0: return
	
	Global.audio_controller.play_sound(sfx_destruction, global_position)
	create_asbestos()
	get_parent().queue_free()

func create_asbestos() -> void:
	for i in count:
		var asbestos = load("res://entities/items/asbestos.tscn").instantiate()
		asbestos.position = global_position
		get_tree().root.add_child(asbestos)
