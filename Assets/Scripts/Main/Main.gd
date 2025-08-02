extends "UIController.gd"

@onready var monster_scene = preload("res://Assets/Scenes/Characters/monster.tscn")

func _ready() -> void:
	for h in get_tree().get_nodes_in_group("Rooms"):
		print(h)
		if h.has_signal("create_monster"):
			print("Has Signal")
			h.create_monster.connect(_on_create_monster)

func _on_create_monster(pos: Vector2 = Vector2(0, 0)):
	print ("Monster Signal received")
	var monster = monster_scene.instantiate()
	add_child(monster)
	monster.global_position = pos
