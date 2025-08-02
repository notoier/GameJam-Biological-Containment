extends CharacterBody2D

@export var speed := 200

@onready var anim = $AnimatedSprite2D

var last_direction: Vector2 = Vector2.DOWN #Look down by default

func _physics_process(_delta):
	var direction = Vector2.ZERO

	if Input.is_action_pressed("ui_right"):
		direction.x += 1
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
	if Input.is_action_pressed("ui_down"):
		direction.y += 1
	if Input.is_action_pressed("ui_up"):
		direction.y -= 1

	# Normalize to prevent diagonal boost
	direction = direction.normalized()
	velocity = direction * speed
	move_and_slide()

	update_animation(direction)

func update_animation(dir: Vector2):
	if dir == Vector2.ZERO:
		if abs(last_direction.x) > abs(last_direction.y):
			anim.play("idle_right" if last_direction.x > 0 else "idle_left")
		else:
			anim.play("idle_down" if last_direction.y > 0 else "idle_up")
		return 
		
	# Save the direction the character was looking at
	last_direction = dir	
		
	if abs(dir.x) > abs(dir.y):
		anim.play("walk_right" if dir.x > 0 else "walk_left")
	else:
		anim.play("walk_down" if dir.y > 0 else "walk_up")
