extends Node

var ui_packed_scene: PackedScene = preload("res://assets/UI/scenes/pickup UI/pickup_ui.tscn")
var pickup_ui


func _ready() -> void:
	var ui_instance = ui_packed_scene.instantiate()
	add_child(ui_instance)


func show_ui():
	pickup_ui.visible = true

func hide_ui():
	pickup_ui.visible = false
