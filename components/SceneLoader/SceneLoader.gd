extends Node3D

var is_in_area: bool = false
var level = GlobalSceneLoader.Station_Floor_0


func _physics_process(delta: float) -> void:
	if is_in_area == true:
		if Input.is_action_just_pressed("Interact"):
			GlobalSceneLoader.load_scene(level)


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.get_parent() is Player:
		is_in_area = true

func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.get_parent() is Player:
			is_in_area = false
