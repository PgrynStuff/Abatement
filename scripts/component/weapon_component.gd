class_name WeaponComponent
extends Area3D

@export var damage: int = 1

func impact(body: Node3D) -> void:
	for child in body.get_children():
		if child is DestructibleComponent: child.damage(damage)
