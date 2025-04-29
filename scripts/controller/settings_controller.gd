class_name SettingsController
extends Node

@export var settings_categories: Array[SettingCategoryResource]
var setting: Dictionary[String, String]

func _ready() -> void:
	Global.settings_controller = self
