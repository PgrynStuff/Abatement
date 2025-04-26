class_name PoliceComponent
extends PathFollow3D

@export var light_left: OmniLight3D
@export var light_right: OmniLight3D
@export var mesh: Node3D

@export var audio: AudioStreamPlayer3D
@export var duration: float = 20.0

var timer: float
var enable: bool

func _ready() -> void:
	Global.game_controller.game_ending.connect(start)
	mesh.visible = false
	light_left.visible = false
	light_right.visible = false

func _physics_process(delta: float) -> void:
	if !enable: return
	timer -= delta
	
	if timer > 0: return
	timer = 1
	
	light_left.visible = !light_left.visible
	light_right.visible = !light_right.visible

func start() -> void:
	enable = true
	mesh.visible = true
	light_left.visible = true
	
	var tween = create_tween()
	tween.tween_property(self, "progress_ratio", 1.0, duration)
	tween.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	
	audio.play()
