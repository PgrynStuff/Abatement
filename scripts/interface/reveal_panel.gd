class_name RevealPanel
extends Panel

@export var interface: Interface

func reveal() -> void:
	if interface.visible == false:
		position = Vector2.ZERO
		return
	
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_ease(Tween.EASE_IN_OUT)
	var target_position = position + Vector2(0, size.y)
	tween.tween_property(self, "position", target_position, 0.5) 
