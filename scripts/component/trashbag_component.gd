class_name TrashbagComponent
extends Area3D

@export var colliders: Array[Node]
@export var meshes: Array[Node]
@export var capacity: int = 3
@export var label: Label3D

var counter: int

func _ready() -> void:
	label.visible = false
	set_label()
	
func _on_body_entered(body: Node3D) -> void:
	if counter >= capacity: return
	
	for child in body.get_children():
		if child is AsbestosComponent:
			update_bag(body)

func update_bag(body: Node3D) -> void:
	body.queue_free()
	counter += 1
	
	set_label()
	
	for mesh in meshes : mesh.visible = false
	for collider in colliders: collider.disabled = true
	colliders[counter].disabled = false
	meshes[counter].visible = true

func set_label() -> void:
	label.text = str(counter) + "/" + str(capacity)

func _on_interaction_component_enter() -> void:
	label.visible = true

func _on_interaction_component_exit() -> void:
	label.visible = false
