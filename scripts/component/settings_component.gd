class_name SettingsComponent
extends Node

@export var tabs: Control
@export var settings: Control

var tab_id: int
var button: Button
var button_key: String

func _ready() -> void:
	create_tabs()
	create_settings(0)

func create_tabs() -> void:
	for element in Global.settings_controller.settings_categories:
		var button := Button.new()
		button.text = element.name
		button.pressed.connect(create_settings.bind(tab_id))
		
		tabs.add_child(button)
		tab_id += 1

func create_settings(tab: int) -> void:
	for child in settings.get_children():
		child.queue_free()
	
	for element in Global.settings_controller.settings_categories[tab].settings:
		var label := Label.new()
		label.text = element.name
		settings.add_child(label)
		
		if element is SettingSliderResource:
			var slider := HSlider.new()
			slider.max_value = element.max_value
			slider.min_value = element.min_value
			slider.step = element.step
			slider.value_changed.connect(setting_changed.bind(element.key))
			slider.value = float(Global.settings_controller.setting[element.key])
			settings.add_child(slider)
			
		if element is SettingToggleResource:
			var toggle:= CheckBox.new()
			toggle.toggled.connect(setting_changed.bind(element.key))
			toggle.button_pressed = true if Global.settings_controller.setting[element.key] == "true" else false
			settings.add_child(toggle)
		
		if element is SettingSelectResource:
			var select := OptionButton.new()
			select.item_selected.connect(setting_changed.bind(element.key))
			
			for i in len(element.items):
				select.add_item(element.items[i])
			
			select.selected = int(Global.settings_controller.setting[element.key])
			settings.add_child(select)
		
		if element is SettingKeybindResource:
			var keybind := Button.new()
			keybind.pressed.connect(update_keybind.bind(keybind, element.key))
			keybind.text = Global.settings_controller.setting[element.key]
			settings.add_child(keybind)

func setting_changed(value, key: String) -> void:
	Global.settings_controller.update_setting(key, str(value))

func _unhandled_input(event: InputEvent) -> void:
	if button == null:
		return
	
	button.text = event.as_text()
	
	match button_key:
		"character_forward":
			InputMap.action_erase_events("character_forward")
			InputMap.action_add_event("character_forward", event)
		"character_backward":
			InputMap.action_erase_events("character_backward")
			InputMap.action_add_event("character_backward", event)
		"character_left":
			InputMap.action_erase_events("character_left")
			InputMap.action_add_event("character_left", event)
		"character_right":
			InputMap.action_erase_events("character_right")
			InputMap.action_add_event("character_right", event)
		"camera_interact":
			InputMap.action_erase_events("camera_interact")
			InputMap.action_add_event("camera_interact", event)
		"camera_throw":
			InputMap.action_erase_events("camera_throw")
			InputMap.action_add_event("camera_throw", event)
	
	setting_changed(event.as_text(), button_key)
	button = null
	
func update_keybind(node: Button, key: String) -> void:
	if button == null:
		button = node
		button_key = key
		
	node.text = "..."
