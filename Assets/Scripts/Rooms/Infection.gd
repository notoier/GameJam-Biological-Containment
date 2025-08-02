extends Node2D

var spawn_timer := Timer.new()
var is_infected : bool = false

signal create_monster

func _ready():
	spawn_timer.wait_time = 5
	spawn_timer.one_shot = true
	spawn_timer.autostart = false
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)
	add_child(spawn_timer)

func _on_spawn_timer_timeout():
	print ("Monster Signal emitted")
	emit_signal("create_monster", self.global_position + Vector2(50, 50)) if is_infected else null
	
func infected():
	if is_infected:
		return
	is_infected = true
	print ("Timer Started")	
	spawn_timer.start()
	
func desinfected():
	if !is_infected:
		return
	is_infected = false
	print ("Timer Stopped")
	spawn_timer.stop()
