extends Window

@onready var rooms_list = $RoomList
@onready var room_control_panel_scene = preload("res://Assets/Scenes/UI/RoomControlPanel.tscn")

func _ready():
	
	title = "Control de Habitaciones"
	size = Vector2(800, 600)
	popup_centered()
	
	var rooms_node = get_tree().get_root().get_node("Main/Rooms/SpecialRooms")
	if not rooms_node:
		push_error("No se encontró el nodo 'Rooms' en la escena principal.")
		return

	for room in rooms_node.get_children():
		var panel = room_control_panel_scene.instantiate()
		# Suponemos que cada Room tiene una propiedad 'room_name' y 'room_id'
		if room.has_method("get_room_name"):
			panel.room_name = room.get_room_name()
		else:
			panel.room_name = room.name
		
		panel.room_id = room.name
		panel.room = room # Connect the Node2D room to the panel
		rooms_list.add_child(panel)
