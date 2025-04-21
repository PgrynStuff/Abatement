class_name AudioController
extends Node

@export var audio_resource: Array[AudioResource]
@export var cache: int

var source_cache: Array[AudioStreamPlayer3D]
var active_cache: Array[AudioStreamPlayer3D]

func _ready() -> void:
	Global.audio_controller = self
	for audio in audio_resource: load(audio.resource_path)
	for i in cache: create_source()

func play_sound(name: String, position: Vector3) -> AudioStreamPlayer3D:
	if source_cache.is_empty():
		push_warning("No available sources! Creating a new one.")
		create_source()
	
	var audio: AudioResource
	for resource in audio_resource:
		if resource.name == name: audio = resource
	
	var source: AudioStreamPlayer3D = source_cache.pop_back()
	source.position = position
	source.stream = audio.clip
	source.volume_db = audio.volume
	source.pitch_scale = randf_range(audio.min_pitch, audio.max_pitch)
	source.play()
	
	return source

func create_source(use: bool = false) -> AudioStreamPlayer3D:
	var source := AudioStreamPlayer3D.new()
	source.finished.connect(source_finished.bind(source))
	
	if use: active_cache.append(source)
	else: source_cache.append(source)
	
	add_child(source)
	return source

func source_finished(source: AudioStreamPlayer3D) -> void:
	source_cache.append(source)
