extends CharacterBody2D

var movement_speed: float = 100.0
#var movement_target_position: Vector2 = Vector2(60.0,180.0)

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
@onready var anim : AnimatedSprite2D = $AnimatedSprite2D

func _ready():
	# These values need to be adjusted for the actor's speed
	# and the navigation layout.
	navigation_agent.path_desired_distance = 48
	navigation_agent.avoidance_enabled = false
	navigation_agent.target_desired_distance = 48

	# Make sure to not await during _ready.
	actor_setup.call_deferred()

func actor_setup():
	# Wait for the first physics frame so the NavigationServer can sync.
	await get_tree().physics_frame

	# Now that the navigation map is no longer empty, set the movement target.
	_go_to_core_room()
	#set_movement_target(movement_target_position)

func set_movement_target(movement_target: Vector2):
	navigation_agent.target_position = movement_target

func _physics_process(delta):
	if navigation_agent.is_navigation_finished():
		return

	var current_agent_position: Vector2 = global_position
	var next_path_position: Vector2 = navigation_agent.get_next_path_position()
	#print ("Next pos: ", next_path_position)
	#print ("Target pos: ", navigation_agent.target_position)
	var direction = (next_path_position - global_position).normalized()
	velocity = velocity.lerp(direction * movement_speed, 0.5)
	move_and_slide()

	_play_animation_for_direction(velocity)

func _go_to_core_room():
	var core_room = get_tree().get_root().get_node("Main/Rooms/SpecialRooms/CoreRoom")
	if core_room:
		set_movement_target(core_room.global_position)
	else:
		print("CoreRoom no encontrado")

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
