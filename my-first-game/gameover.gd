extends Control

@onready var restart_button: Button = $Button


func _ready() -> void:
	restart_button.pressed.connect(_on_restart_pressed)
	restart_button.grab_focus()


func _on_restart_pressed() -> void:
	var main_scene = ProjectSettings.get_setting(
		"application/run/main_scene"
	)

	get_tree().change_scene_to_file(main_scene)
