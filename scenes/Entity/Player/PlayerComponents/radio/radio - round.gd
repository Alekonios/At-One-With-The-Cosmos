
class_name RadioRound
extends Node3D

@onready var center: Node3D = $Node3D
@onready var pivot_point: Node3D = $"Node3D/pivot point"

@export var camera: Camera3D
@export var radius: float = 5
@export var scroll_speed: float = 1
@export var tick_spacing: float = 0.3

var tick_marks = []
var offset: float = 0

func _ready() -> void:
	for child in center.get_children():
		if child.name.begins_with("tick mark"):
			tick_marks.append(child)

	pivot_point.position.y = radius

func _process(delta: float) -> void:
	var mark_size = PI/3/ tick_marks.size()
	
	for mark in tick_marks:
		var center_rotation = tick_marks.find(mark) * mark_size - PI/3/2 + offset
		center_rotation = wrapf(center_rotation, -PI/6, PI/6)
		center.rotation.z = center_rotation
		mark.global_position = pivot_point.global_position

		print(pivot_point.global_position)

	radio_equip()
	dial_rotation(delta)
	face_camera()


func radio_equip():
	if Input.is_action_pressed("TAB"):
		self.visible = true
	else:
		self.visible = false

func dial_rotation(delta):
	offset += Input.get_axis("ui_left", "ui_right") * PI/3 * delta

func face_camera():
	if camera.current == true:
		look_at(camera.global_transform.origin, Vector3.UP)
