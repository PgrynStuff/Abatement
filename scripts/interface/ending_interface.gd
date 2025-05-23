class_name EndingInterface
extends Node

@export var text: Label
@export var score: Label
@export var azbestos: Label
@export var destructables: Label
@export var source : AudioStreamPlayer
@export var clip : Array[AudioStream]

func _ready() -> void:
	Global.game_controller.game_status.connect(update_interface)

func update_interface(status) -> void:
	if status != 5: 
		get_child(0).visible = false
		return
	
	get_child(0).visible = true
	
	var azb := len(Global.game_controller.asbestos)
	var des := len(Global.game_controller.destructibles)
	var scr := azb + des
	
	azbestos.text = "Pozostałości Azbestu: " + str(azb)
	destructables.text = "Zainfekowane Meble: " + str(des)
	
	if scr <= 5:
		score.add_theme_color_override("font_color", Color8(46, 213, 115))
		text.text = "Utrzymaj ten standard."
		score.text = "S"
		source.stream = clip[0]
	elif scr <= 7:
		score.add_theme_color_override("font_color", Color8(30, 144, 255))
		text.text = "Dobra robota... Tym razem"
		score.text = "A"
		source.stream = clip[1]
	elif scr <= 10:
		score.add_theme_color_override("font_color", Color8(55, 66, 250))
		text.text = "Słabo ale nie najgorzej..."
		score.text = "B"
		source.stream = clip[2]
	elif scr <= 15:
		score.add_theme_color_override("font_color", Color8(116, 125, 140))
		text.text = "Czy sobie żartujesz z tej pracy???"
		score.text = "C"
		source.stream = clip[3]
	elif scr <= 20:
		score.add_theme_color_override("font_color", Color8(255, 165, 2))
		text.text = "Proponuje zmienić pracę..."
		score.text = "D"
		source.stream = clip[4]
	else:
		score.add_theme_color_override("font_color", Color8(255, 99, 72))
		text.text = "Nie przychodź jutro do pracy..."
		score.text = "F"
		source.stream = clip[5]
	source.play()
