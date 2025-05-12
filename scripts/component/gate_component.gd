extends Node3D

var is_open := true
var target : Vector3

@export var func_godot_properties : Dictionary

func _ready():
	var inter := InteractableComponent.new()
	add_child(inter)
	inter.use.connect(gate_open)

func gate_open():
	is_open = !is_open
	
	if !is_open:
		target = Vector3(0, deg_to_rad(float(func_godot_properties["degres"])), 0)
	else:
		target = Vector3.ZERO
	
	Global.audio_controller.play_sound("door02", global_position)

func _physics_process(delta: float) -> void:
	rotation = rotation.lerp(target, delta * 20)
