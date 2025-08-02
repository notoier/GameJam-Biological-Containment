# RoomControlPanel.gd
extends Control

@export var room_name: String
@export var room_id: String

@onready var lock_button = $GridContainer/Controls/Lock

var room: Node2D

var npress : int = 0

@onready var room_label = $GridContainer/RoomName

func _ready():
	room_label.text = room_name


func _on_lock_pressed():
	if npress % 2 == 0:
		room.lock_room()
		lock_button.text = "Unlock Room"
	else: 
		room.unlock_room()
		lock_button.text = "Lock Room"
	
	npress += 1
	
