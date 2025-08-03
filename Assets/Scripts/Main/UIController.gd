extends Node2D

class_name ui_controller

@onready var ui_scene = preload("res://Assets/Scenes/UI/RoomControlUI.tscn")

var secRoom_path = "/root/Main/Rooms/SpecialRooms/Security Room"
var computer_path = "/root/Main/Rooms/SpecialRooms/Security Room/TileMap/Decoration/Decoration 2/Computer"

var room_ui_instance: Node = null
var manual_UI_toggle : bool = false
var computer : Node2D

func _ready():
	# Instantiate door lockdown screen and make it invisible
	room_ui_instance = ui_scene.instantiate() 
	add_child(room_ui_instance)
	room_ui_instance.visible = false
	
	var secRoom = get_node_or_null(secRoom_path) 
	print (secRoom)
	if secRoom: 
		secRoom.player_outside_computer_area.connect(_on_computer_outside_area)
		computer = get_node_or_null(computer_path)
		print(computer)
		
func _process(delta):
	if Input.is_action_just_pressed("ui_toggle_room_ui"):
		manual_UI_toggle = true
		toggle_room_ui()
		
	if Input.is_action_just_pressed("action_key") and computer.characterNearComputer:
		toggle_room_ui()
		
func _on_computer_outside_area():
	if room_ui_instance.visible and !manual_UI_toggle: toggle_room_ui()

func toggle_room_ui():
	if room_ui_instance.visible:
		manual_UI_toggle = false
		room_ui_instance.visible = false
	else:
		room_ui_instance.visible = true
