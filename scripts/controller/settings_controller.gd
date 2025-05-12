class_name SettingsController
extends Node

@export var settings_categories: Array[SettingCategoryResource]

var setting: Dictionary[String, String]
signal setting_changed()

func _enter_tree() -> void:
	Global.settings_controller = self
	create_settings()
	load_settings()
	save_settings()
	
func create_settings() -> void:
	for category in settings_categories:
		for value in category.settings:
			setting[value.key] = value.value

func load_settings() -> void:
	var file := ConfigFile.new()
	
	if file.load("res://settings.ini") != OK:
		return
	
	for key in file.get_section_keys("Abatement"):
		setting[key] = str(file.get_value("Abatement", key))
		update_other(key, setting[key])

func save_settings() -> void:
	var file := ConfigFile.new()
	for key in setting.keys():
		file.set_value("Abatement", key, setting[key])
	file.save("res://settings.ini")

func update_setting(key: String, value: String) -> void:
	setting[key] = value
	setting_changed.emit()
	update_other(key,value)
	call_deferred("save_settings")

func update_other(key: String, value: String) -> void:
	match key:
		"mssa":
			ProjectSettings.set_setting("rendering/anti_aliasing/quality/msaa_3d", int(value))
			ProjectSettings.set_setting("rendering/anti_aliasing/quality/msaa_2d", int(value))
		"volume_main":
			AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), float(value))
		"volume_music":
			AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), float(value))
		"volume_narrator":
			AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Narrator"), float(value))
		"volume_sfx":
			AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), float(value))
			
	ProjectSettings.save()
