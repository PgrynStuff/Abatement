class_name TrashbagComponent
extends Area3D

@export var label: Label3D
@export var capacity: int = 3

@export_group("Mesh")
@export var meshes: Array[Node]

var counter: int

func _ready() -> void:
	update_label()
	update_mesh()

func fill(body: Node3D) -> void:
	if counter >= capacity: return
	
	for child in body.get_children():
		if child is AsbestosComponent: 
			Global.audio_controller.play_sound("bag", global_position)
			body.queue_free()
			counter += 1
			update_label()
			update_mesh()

func update_mesh() -> void:
	for mesh in meshes : mesh.visible = false
	meshes[counter].visible = true

func update_label() -> void:
	label.text = str(counter) + "/" + str(capacity)
