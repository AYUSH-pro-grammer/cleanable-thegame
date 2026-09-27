extends Area2D


func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node2D) -> void:

	if body.name == "player":
		print("GAME FINISHED!")
		get_tree().change_scene_to_file("res://finish.tscn")
