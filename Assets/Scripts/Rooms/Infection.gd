extends Node2D

class_name infection_manager

var spawn_timer := Timer.new()
var is_infected : bool = false

signal create_monster_in_room

func _ready():
	spawn_timer.wait_time = 5
	spawn_timer.one_shot = true
	spawn_timer.autostart = false
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)
	add_child(spawn_timer)

func _on_spawn_timer_timeout():
	if is_infected:
		#print ("Monster Signal emitted")
		emit_signal("create_monster_in_room") 
		infected()
	
func infected():
	if is_infected:
		return
	is_infected = true
	#print ("Timer Started")
	#print (self.name)	
	spawn_timer.start()
	
func desinfected():
	if !is_infected:
		return
	is_infected = false
	#print ("Timer Stopped")
	spawn_timer.stop()
