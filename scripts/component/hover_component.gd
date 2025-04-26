class_name HoverComponent
extends Node3D

func _ready() -> void:
	exit()

func enter() -> void:
	for child in get_children():
		child.visible = true

func exit() -> void:
	for child in get_children():
		child.visible = false
