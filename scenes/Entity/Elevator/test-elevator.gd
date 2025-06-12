extends Node3D

@onready var key_help: Label3D = $Label3D
@onready var level: PackedScene = load("res://scenes/locations/TestFloors/TestFloor2.tscn")

@export var elevator_inside: PackedScene

func _ready() -> void:
	$MeshInstance3D/Area3D.body_entered.connect(_on_area_3d_body_entered)
	key_help.visible = false

func _process(delta: float) -> void:
	if key_help.visible:
		if Input.is_action_just_pressed("Interact"):
			GlobalSceneLoader.load_scene(elevator_inside)
			#get_tree().change_scene_to_packed(level)


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is Player:
		key_help.visible = true

func _on_area_3d_body_exited(body: Node3D) -> void:
	if body is Player:
		key_help.visible = false
