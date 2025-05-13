class_name PathFollowComponent
extends PathFollow3D

@export var duration: float = 10

func start() -> void:
	var tween = create_tween()
	tween.tween_property(self, "progress_ratio", 1.0, duration)
	tween.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
