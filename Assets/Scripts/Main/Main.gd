extends Node2D

@onready var monster_scene = preload("res://Assets/Scenes/Characters/monster.tscn")
@onready var enemiesNode = $Enemies
@onready var uiNode = $UI

var ui : ui_controller

#-----------------------
# INITIALIZE
#-----------------------
func _ready() -> void:
	
	_init_ui()
	_connect_monster_signals()
	

func _init_ui():
	ui = ui_controller.new()
	uiNode.add_child(ui)

#-----------------------
# SIGNALS
#-----------------------

func _connect_monster_signals():
	for h in get_tree().get_nodes_in_group("Rooms"):
		#print(h)
		if h.has_signal("create_monster"):
			#print("Has Signal")
			h.create_monster.connect(_on_create_monster)

func _on_create_monster(pos: Vector2 = Vector2(0, 0)):
	#print ("Monster Signal received")
	var monster = monster_scene.instantiate()
	enemiesNode.add_child(monster)
	monster.global_position = pos
	#print (pos)
