extends "res://Assets/Scripts/Rooms/RoomManager.gd"

signal player_outside_computer_area

@export var computer : Node2D

func _ready():
	update_light()
	if computer: computer.character_outside_area.connect(_on_computer_outside_area)

func _on_computer_outside_area():
	emit_signal("player_outside_computer_area")
