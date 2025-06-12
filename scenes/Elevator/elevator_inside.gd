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

@onready var camera: Camera3D = $Camera3D
@onready var map_camera: Camera3D = $MapCamera
@onready var close_up_camera: Camera3D = $CloseUpCamera

@onready var camera_2: Camera3D = $Camera3D2
@onready var ray: RayCast3D = $Camera3D/RayCast3D

var level: Levels = preload("res://scenes/locations/levels.tres")
var initial_camera_pos: Vector3
var initial_camera_rotation: Vector3
var initial_camera_fov: float
var camera_velocity_y := 0.0 

var panel_view_enabled: bool = false
var map_view_enabled: bool = false
var viewing_full_map: bool = false

var close_up_view_enabeled: bool = false
var close_up_view: bool = false
var step_back: bool = false

func _ready() -> void:
	initial_camera_pos = camera.position
	initial_camera_rotation = camera.rotation
	initial_camera_fov = camera.fov

func _physics_process(delta: float) -> void:
	var mouse_position = get_viewport().get_mouse_position()
	var ray_origin = camera.project_ray_origin(mouse_position)
	var direction = camera.project_ray_normal(mouse_position) * 5000 # !LOCAL!
	 
	ray.global_position = ray_origin
	ray.target_position = ray.to_local(ray_origin + direction)

	handle_boutons()
	control_camera(delta)
	if map_view_enabled == true:
		update_camera_to_map_view(delta)
	
	if step_back == true:
		update_camera_to_map_view(delta)
	
	if close_up_view_enabeled == true:
		update_camera_to_map_close_up(delta)
	if Input.is_action_just_pressed("Escape"):
		close_up_view_enabeled = false
		close_up_view = false
		step_back = true
	
	if panel_view_enabled == true:
		update_camera_to_panel_view(delta)

	print(camera_velocity_y) 

func handle_boutons():
	#maybe I can use MATCH ?
	var collider = ray.get_collider()
	if collider is StaticBody3D and \
		map_view_enabled == false and \
		panel_view_enabled == false:
		
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

		if parent.name.begins_with("Map"):
			if Input.is_action_just_pressed("Interact"):
				if close_up_view == false:
					map_view_enabled = true

			if viewing_full_map == true:
				if Input.is_action_just_pressed("Interact"):
					close_up_view_enabeled = true

		if parent.name.begins_with("Panel"):
			if map_view_enabled == false:
				if Input.is_action_just_pressed("Interact"):
					panel_view_enabled = true

func control_camera(delta):
	if close_up_view:
		var impulse := 6
		
		var speed := 12.0
		var friction := 8.0
		var min_y := -0.52
		var max_y := 3.48


		if Input.is_action_pressed("MoveUp"):
			camera_velocity_y += speed * delta
		elif Input.is_action_pressed("MoveDown"):
			camera_velocity_y -= speed * delta
		else:
			camera_velocity_y = lerp(camera_velocity_y, 0.0, friction * delta)

		camera.position.y += camera_velocity_y * delta
		camera.position.y = clamp(camera.position.y, min_y -1, max_y +1)


		if camera.position.y < min_y:
			camera.position.y = lerp(camera.position.y, min_y, 2 * delta)
			camera_velocity_y = lerp(camera_velocity_y, -0.2, 12 * delta)

		if camera.position.y > max_y:
			camera.position.y = lerp(camera.position.y, max_y, 2 * delta)
			camera_velocity_y = lerp(camera_velocity_y, 0.2, 12 * delta)

func update_camera_to_map_view(delta):
	camera.position = camera.position.lerp(map_camera.position, 4 * delta) #?
	camera.rotation = lerp(camera.rotation, map_camera.rotation, 4 * delta)
	camera.fov = lerp(camera.fov, map_camera.fov, 1 * delta)
	if camera.position.distance_to(map_camera.position) < 0.05 and \
		camera.rotation.distance_to(map_camera.rotation) < 0.01:
		map_view_enabled = false
		viewing_full_map = true
		step_back = false

func update_camera_to_map_close_up(delta):
	camera.position = lerp(camera.position, close_up_camera.position, 4 * delta)
	camera.rotation = lerp(camera.rotation, close_up_camera.rotation, 4 * delta)
	camera.fov = lerp(camera.fov, close_up_camera.fov, 1 * delta)
	if camera.position.distance_to(close_up_camera.position) < 0.05 and \
		camera.rotation.distance_to(close_up_camera.rotation) < 0.01:
		close_up_view_enabeled = false
		close_up_view = true

func update_camera_to_panel_view(delta):
	camera.position = lerp(camera.position, initial_camera_pos, 4 * delta)
	camera.rotation = lerp(camera.rotation, initial_camera_rotation, 4 * delta)
	camera.fov = lerp(camera.fov, initial_camera_fov, 1 * delta)
	if camera.position.distance_to(initial_camera_pos) < 0.05 and \
		camera.rotation.distance_to(initial_camera_rotation) < 0.01:
		panel_view_enabled = false
		viewing_full_map = false

func debug():
	camera_2.current = true
	print(ray.target_position)
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED
