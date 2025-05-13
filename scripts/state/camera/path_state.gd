class_name PathState
extends EntityState

@export var path_follow: PathFollowComponent
var path: PathComponent
var started: bool

func enter() -> void:
	if path == null: return
	path_follow.process_mode = Node.PROCESS_MODE_INHERIT
	started = false

func update(_delta: float) -> void:
	if path == null: return
	path_follow.reparent(path)
	entity.set_position(path_follow.global_position)
	entity.set_rotation(path_follow.rotation)
	
	if !started:
		started = true
		path_follow.start()

func exit() -> void:
	path_follow.progress = 0
	path_follow.process_mode = Node.PROCESS_MODE_DISABLED
