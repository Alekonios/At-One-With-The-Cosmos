extends Node3D

enum LEVELS {
	TEST_FLOOR_1,
	TEST_FLOOR_2,
	TEST_FLOOR_3
}
@onready var levels: Dictionary = {
	LEVELS.TEST_FLOOR_1: load("res://scenes/locations/TestFloors/TestFloor1.tscn"),
	LEVELS.TEST_FLOOR_2: load("res://scenes/locations/TestFloors/TestFloor2.tscn"),
	LEVELS.TEST_FLOOR_3: load("res://scenes/locations/TestFloors/TestFloor3.tscn")
}

@onready var button_1: MeshInstance3D = $"Plate/Button 1"
@onready var camera_2: Camera3D = $Camera3D2
@onready var map_camera: Camera3D = $MapCamera

@onready var camera: Camera3D = $Camera3D
@onready var ray: RayCast3D = $Camera3D/RayCast3D

var level: Levels = preload("res://scenes/locations/levels.tres")

func _physics_process(delta: float) -> void:
	var mouse_position = get_viewport().get_mouse_position()
	var ray_origin = camera.project_ray_origin(mouse_position)
	var direction = camera.project_ray_normal(mouse_position) * 5000 # !LOCAL!
	 
	ray.global_position = ray_origin
	ray.target_position = ray.to_local(ray_origin + direction)
	
	handle_boutons()


func handle_boutons():
	var collider = ray.get_collider()
	if collider is StaticBody3D:
		var parent = collider.get_parent()
		if parent.name == "Button 1":
			if Input.is_action_just_pressed("Interact"):
				get_tree().change_scene_to_packed(levels[LEVELS.TEST_FLOOR_1])

		if parent.name == "Button 2":
			if Input.is_action_just_pressed("Interact"):
				get_tree().change_scene_to_packed(levels[LEVELS.TEST_FLOOR_2])

		if parent.name == "Button 3":
			if Input.is_action_just_pressed("Interact"):
				get_tree().change_scene_to_packed(levels[LEVELS.TEST_FLOOR_3])

		if parent.name == "Map":
			if Input.is_action_just_pressed("Interact"):
				lerp(camera.global_position,map_camera.global_position, 1)
				lerp(camera.fov, map_camera.fov, 1)

func debug():
	camera_2.current = true
	print(ray.target_position)
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED
