class_name DoorComponent
extends Node

@onready var target = get_parent().rotation
@onready var parent := get_parent()
@export var rotation: float = 90
var open: bool

func use() -> void:
	open = !open
	Global.audio_controller.play_sound("door01", get_parent().global_position)
	
	if open:
		target.y += deg_to_rad(rotation)
	else:
		target.y -= deg_to_rad(rotation)

func _physics_process(delta: float) -> void:
	parent.rotation = parent.rotation.lerp(target, delta * 20)
