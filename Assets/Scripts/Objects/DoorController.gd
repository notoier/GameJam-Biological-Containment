extends Node2D

@onready var area = $Area2D
@onready var detectionArea = $Area2D/DetectionArea
@onready var doorCollider = $StaticBody2D/DoorCollider
@onready var obstacle = $Obstacle

@onready var anim1 = $AnimatedSprite2D
@onready var anim2 = $AnimatedSprite2D2

var open : bool = false
var locked : bool = false

func lock():
	if open:
		open = false
		locked = true
		
		anim1.play("lock_from_open")
		
		if anim2: 
			anim2.play("lock_from_open")
		
		print("Door locked -> Status: Open")
		
	else:
		locked = true
		
		anim1.play("lock_from_closed")
		
		if anim2: 
			anim2.play("lock_from_closed")	
			
		print("Door locked -> Status: Closed")
	
	
func unlock():
	locked = false


func _on_area_2d_body_entered(body: Node2D) -> void:
	if !locked:
		play_animation("open")
		
		# Disable door collision
		doorCollider.set_deferred("disabled", true)
		obstacle.set_deferred("avoidance_enabled", false)
		open = true
		

func _on_area_2d_body_exited(body: Node2D) -> void:
	if !locked and !area.get_overlapping_bodies(): # Door is locked or there's someone still in the area
		play_animation("close")
		
		doorCollider.set_deferred("disabled", false)
		open = false
		obstacle.set_deferred("avoidance_enabled", true)
		
func play_animation(string: String)	-> void:
	anim1.play(string)
	if anim2: anim2.play(string)
