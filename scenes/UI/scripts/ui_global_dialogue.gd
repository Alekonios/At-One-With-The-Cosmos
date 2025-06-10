
extends Node

var ui_packed_scene: PackedScene = preload("res://scenes/UI/UI scenes/dialogue_ui.tscn")

var ui_animation: AnimationPlayer
var ui_visual: CanvasLayer

var ui_speaker_name: Label
var ui_speaker_line: Label


func _ready() -> void:
	var ui_instance = ui_packed_scene.instantiate()
	add_child(ui_instance)


func open_dialogue():
	ui_visual.visible = true
	ui_animation.play("slide_in")
