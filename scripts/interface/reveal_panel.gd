class_name RevealPanel
extends Panel

@export var interface: Interface

func _ready() -> void:
	interface.called.connect(reveal)

func reveal() -> void:
	get_parent().position = Vector2.ZERO
	
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_ease(Tween.EASE_IN_OUT)
	var target_position = get_parent().position + Vector2(0, size.y)
	tween.tween_property(get_parent(), "position", target_position, 0.5) 
