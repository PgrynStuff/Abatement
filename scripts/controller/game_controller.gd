class_name GameController
extends Node

var destructibles: Array[DestructibleComponent]
@export var scenarios: Array[GameResource]
var asbestos: Array[AsbestosComponent]

var score: int

var scene: Node
var time: float
var load: int

enum GAME_STATUS{ Lobby, Loading, Intro, Start, Police, Outro, Finish }
signal game_status(status: GAME_STATUS)

var status_police: bool
var status_await: bool
var status_outro: bool

func _ready() -> void:
	Global.game_controller = self
	game_status.emit(GAME_STATUS.Lobby)
	load_scenario("House")
	
func _physics_process(delta: float) -> void:
	update_timer(delta)

func load_scenario(name: String) -> void:
	score = 0
	
	game_status.emit(GAME_STATUS.Loading)
	
	var scenario: GameResource
	for item in scenarios:
		if item.name == name:
			scenario = item
	
	scene = await ResourceLoader.load(scenario.scene.resource_path).instantiate()
	add_child(scene)
	
	time = scenario.timer
	Global.character_controller.velocity = Vector3.ZERO
	Global.character_controller.position = scenario.spawn
	
	game_status.emit(GAME_STATUS.Intro)
	status_await = false

func update_timer(delta: float) -> void:
	if status_await:
		return
	
	time -= delta
	
	if time < 20 and !status_police:
		game_status.emit(GAME_STATUS.Police)
		status_police = true
	
	if time < 0 and !status_outro:
		game_status.emit(GAME_STATUS.Outro)
		status_outro = true

func unload_scenario() -> void:
	score = -(len(destructibles) + len(asbestos))
	game_status.emit(GAME_STATUS.Finish)
	status_police = false
	status_outro = false
	status_await = true
