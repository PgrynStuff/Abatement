class_name AudioResource
extends Resource

@export var name: String
@export var clip: AudioStream
@export_range(-80,80) var volume: float
@export_range(.01,4) var min_pitch: float = 1
@export_range(.01,4) var max_pitch: float = 1
@export var bus: BUSTYPE

enum BUSTYPE { SFX = 0, Narrator = 1, Music = 2 }
