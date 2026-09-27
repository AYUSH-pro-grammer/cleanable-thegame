extends Control

@onready var left_button: Button = $leftButton
@onready var right_button: Button = $rightButton
@onready var play_button: Button = $PlayButton
@onready var character_name: Label = $CharacterName
@onready var character_sprite: AnimatedSprite2D = $CharacterSprite
@onready var info: Button = $info

func _ready() -> void:

	left_button.pressed.connect(_on_left_pressed)
	right_button.pressed.connect(_on_right_pressed)
	play_button.pressed.connect(_on_play_pressed)
	info.pressed.connect(_on_info)

	update_character()


func _on_left_pressed() -> void:

	GameManager.selected_character -= 1

	if GameManager.selected_character < 0:
		GameManager.selected_character = 2

	update_character()


func _on_right_pressed() -> void:

	GameManager.selected_character += 1

	if GameManager.selected_character > 2:
		GameManager.selected_character = 0

	update_character()




func update_character() -> void:

	if GameManager.selected_character == 0:
		character_sprite.play("character1")
		character_name.text = "CHARACTER 1"

	elif GameManager.selected_character == 1:
		character_sprite.play("character2")
		character_name.text = "CHARACTER 2"

	elif GameManager.selected_character == 2:
		character_sprite.play("character3")
		character_name.text = "CHARACTER 3"


func _on_info() -> void:
	get_tree().change_scene_to_file("res://whatisthis.tscn")

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://node.tscn")
