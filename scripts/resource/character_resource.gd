@icon("res://common/icons/controller/character_controller.svg")
class_name CharacterResource
extends Resource

@export var gravity: float = 20
@export var jump_force: float = 7
@export var walk_force: float = 7
@export var sprint_force: float = 10

@export_group("Ground Movement")
@export var ground_acceleration: float = 11
@export var ground_deceleration: float = 7
@export var ground_friction: float = 3.5

@export_group("Airborne Movement")
@export var airborne_acceleration: float = 800
@export var airborne_coefficient: float = 500
@export var airborne_cap: float = 0.85
