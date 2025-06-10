#a script to simulate weapon pickup > reuse later
extends Node3D

var IsInArea: bool = false


func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("Interact"):
		if IsInArea == true:
			UiGlobalPickup.show_ui()
	
	UiGlobalPickup.hide_ui_on_input()
	UiGlobalPickup.hide_ui_on_timeout(delta)
	#check UiGlobalPickup


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is Player:
		IsInArea = true

func _on_area_3d_body_exited(body: Node3D) -> void:
	if body is Player:
		IsInArea = false
