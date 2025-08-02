extends Node2D

@onready var area = $"Detection Zone"
@onready var ui_animation = $"UI/UI Button"
@onready var computer_animation = $"Starting Animation"
var characterNearComputer: bool = false
var found_body : bool = false

signal character_outside_area

func _ready():
	ui_animation.visible = false

func _on_detection_zone_body_entered(_body: Node2D) -> void:
	ui_animation.visible = true	
	ui_animation.play()
	computer_animation.play("start up")
	characterNearComputer = true
		
func _on_detection_zone_body_exited(_body: Node2D) -> void:
	characterNearComputer = false
	ui_animation.visible = false	
	computer_animation.play("shut_down")
	emit_signal("character_outside_area")
