extends CharacterBody2D

var movement_speed: float = 200.0
var movement_target_position: Vector2 = Vector2.ZERO

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
@onready var anim : AnimatedSprite2D = $AnimatedSprite2D

func _ready():
	navigation_agent.path_desired_distance = 4.0
	navigation_agent.target_desired_distance = 4.0
	actor_setup.call_deferred()

func actor_setup():
	await get_tree().physics_frame
	_choose_new_random_destination()

func _physics_process(_delta):
	if navigation_agent.is_navigation_finished():
		_choose_new_random_destination()
		anim.stop()
		return

	var current_agent_position: Vector2 = global_position
	var next_path_position: Vector2 = navigation_agent.get_next_path_position()

	var direction = (next_path_position - current_agent_position).normalized()
	velocity = direction * movement_speed
	move_and_slide()

	_play_animation_for_direction(direction)

func _choose_new_random_destination():
	
	# Define el área válida donde se puede mover (ajústala a tu mapa real)
	var min_bounds = Vector2(0, 0)
	var max_bounds = Vector2(1024, 1024) # Cambia esto según el tamaño real de tu zona navegable

	# Intenta encontrar una posición válida dentro del NavigationMap
	var navigation_map = get_world_2d().navigation_map

	for i in range(10): # Hasta 10 intentos para encontrar una posición válida
		var random_pos = Vector2(
			randf_range(min_bounds.x, max_bounds.x),
			randf_range(min_bounds.y, max_bounds.y)
		)

		if NavigationServer2D.map_get_closest_point(navigation_map, random_pos).distance_to(random_pos) < 10:
			set_movement_target(random_pos)
			return

	# Si no encuentra una posición válida, vuelve a intentar más tarde
	print("No se encontró un destino válido.")

func set_movement_target(movement_target: Vector2):
	movement_target_position = movement_target
	navigation_agent.target_position = movement_target

func _play_animation_for_direction(direction: Vector2):
	if direction.length() < 0.1:
		anim.stop()
		return
		
	if abs(direction.x) > abs(direction.y):
		if direction.x > 0:
			anim.play("walk_right")
		else:
			anim.play("walk_left")
			
	else:
		if direction.y > 0:
			anim.play("walk_down")
		else:
			anim.play("walk_up")		
