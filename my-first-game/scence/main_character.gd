extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = 500.0
const GRAVITY = 1400.0

const MAX_HEALTH = 100
const INVINCIBILITY_TIME = 1.0

var health = MAX_HEALTH
var invincible = false

var current_gravity: float = GRAVITY
var target_gravity: float = GRAVITY

@onready var animated_sprite: AnimatedSprite2D = $Sprite2D
@onready var health_bar: ProgressBar = $"../CanvasLayer/HealthBar"


func _ready() -> void:
	up_direction = Vector2.UP

	animated_sprite.play("default")

	health_bar.max_value = MAX_HEALTH
	health_bar.value = health


func _physics_process(delta: float) -> void:

	if Input.is_action_just_pressed("ui_up"):
		target_gravity = -GRAVITY
		current_gravity = target_gravity
		velocity.y = 0.0

	if Input.is_action_just_pressed("ui_down"):
		target_gravity = GRAVITY
		current_gravity = target_gravity
		velocity.y = 0.0

	if Input.is_action_just_pressed("ui_accept"):
		target_gravity = -target_gravity
		current_gravity = target_gravity
		velocity.y = 0.0

	if target_gravity < 0:
		up_direction = Vector2.DOWN
	else:
		up_direction = Vector2.UP

	velocity.y += current_gravity * delta

	if Input.is_key_pressed(KEY_Z) and is_on_floor():
		if target_gravity > 0:
			velocity.y = -JUMP_VELOCITY
		else:
			velocity.y = JUMP_VELOCITY

	var direction := Input.get_axis("ui_left", "ui_right")

	if direction != 0:
		velocity.x = direction * SPEED
	else:
		velocity.x = 0.0

	move_and_slide()

	update_animation(direction)


func update_animation(direction: float) -> void:

	if direction != 0:
		animated_sprite.play("running")
	else:
		animated_sprite.play("default")

	if direction < 0:
		animated_sprite.flip_h = true
	elif direction > 0:
		animated_sprite.flip_h = false

	if target_gravity < 0:
		animated_sprite.flip_v = true
	else:
		animated_sprite.flip_v = false


func take_damage(amount: int) -> void:

	if invincible:
		return

	health -= amount

	if health < 0:
		health = 0

	health_bar.value = health

	print("PLAYER HIT!")
	print("HP: ", health, "/", MAX_HEALTH)

	if health <= 0:
		die()
	else:
		start_hurt()


func start_hurt() -> void:

	invincible = true

	var timer = 0.0

	while timer < INVINCIBILITY_TIME:

		animated_sprite.visible = not animated_sprite.visible

		await get_tree().create_timer(0.1).timeout

		timer += 0.1

	animated_sprite.visible = true
	invincible = false


func die() -> void:

	print("PLAYER DIED!")

	get_tree().change_scene_to_file("res://game_over.tscn")
