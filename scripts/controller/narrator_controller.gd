extends AudioStreamPlayer
class_name NarratorController

@export var trigger : int

func _ready() -> void:
	Global.game_controller.game_status.connect(update_sound)
	
func update_sound(arg) -> void:
	if arg != trigger: return
	play()
