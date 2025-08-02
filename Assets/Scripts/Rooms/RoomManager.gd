extends "res://Assets/Scripts/Rooms/Infection.gd"

@onready var roomLight = $RoomLight
@onready var area = $EnemyDetectionZone
@onready var doorNode = $Doors
@onready var tilemap = $TileMap

@export var room_name: String

enum RoomState {UNTOUCHED, CLEAN, INFECTED, SEALED}

var pre_state : RoomState = RoomState.UNTOUCHED # Default state 

var enemyInside : bool = false
var infectionTime : float = 5.0

const Colors := {
	INFECTED = Color(0.885, 0.183, 0.13, 1), # Bright Red
	CLEAN = Color(0.433, 0.852, 0.219, 1), # Green
	SEALED = Color(0.075, 0.075, 0.075, 1), # Dark, like a blackout
	UNTOUCHED = Color(0.75, 0.8, 0.5, 1), # Yellow-ish, pretty much a normal light
}

const STATE_COLORS := {
	RoomState.UNTOUCHED: Colors.UNTOUCHED,
	RoomState.CLEAN: Colors.CLEAN,
	RoomState.INFECTED: Colors.INFECTED,
	RoomState.SEALED: Colors.SEALED
}

func get_room_name() -> String:
	return room_name

@export var state: RoomState:
	set(value):
		pre_state = state # Store the previous state for later use
		state = value
		if roomLight:
			update_light()
		
func _ready():
	super._ready() # Initialize everything in infection.gd
	_layer_draw_order()	
	update_light()
	
func _layer_draw_order():
	var tileMapLayers = tilemap.get_children()
	for layer in tileMapLayers:
		match layer.name:
			"Floor": layer.set_deferred("z_index", 0)
			"Inside Walls": layer.set_deferred("z_index", 1)
			"Ceiling Walls": layer.set_deferred("z_index", 3)
			"Outside Walls": layer.set_deferred("z_index", 5)
			"Decoration": layer.set_deferred("z_index", 1)
			_: layer.set_deferred("z_index", 1)
	
func _on_enemy_detection_zone_body_entered(_body: Node2D) -> void:
	enemyInside = true
	_checkTimeForInfection()

func _on_enemy_detection_zone_body_exited(_body: Node2D) -> void:
	enemyInside = false
	pass # Replace with function body.
		
func _checkTimeForInfection() -> void:
	if  enemyInside and state != RoomState.INFECTED and state != RoomState.SEALED:
		await get_tree().create_timer(infectionTime).timeout # Wait 5 seconds
		state = RoomState.INFECTED
		infected()
		
			
# No use yet	
func get_special_object_data(object_name: String):
	var object = get_node(object_name)
	return object
	
func update_light():	
	for light in roomLight.get_children():
		light.color = STATE_COLORS.get(state, Colors.UNTOUCHED) # UNTOUCHED -> Valor por defecto

func lock_room():
	var doors = doorNode.get_children()
	if !doors: push_error("No doors attached to this room")
	state = RoomState.SEALED
	for door in doors:
		door.lock()
		
func unlock_room():
	var doors = doorNode.get_children()
	state = pre_state
	if !doors: push_error("No doors attached to this room")
	for door in doors:
		door.unlock()
	return		
