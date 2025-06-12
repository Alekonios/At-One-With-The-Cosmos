
extends Node

var ui_packed_scene: PackedScene = preload("res://scenes/UI/UI scenes/dialogue_ui.tscn")

var ui_animation: AnimationPlayer
var ui_visual: CanvasLayer

var ui_speaker_name: Label
var ui_speaker_line: Label

var current_dialogue: DialogueResource
var current_line: int = 0

var dialogue_closed: bool = false


func _ready() -> void:
	var ui_instance = ui_packed_scene.instantiate()
	add_child(ui_instance)

func _process(delta: float) -> void:
	change_line()
	print(DialogueResource)

func open_dialogue():
	if DialogueResource != null:
		dialogue_closed = false
		ui_visual.visible = true
		ui_animation.play("slide_in")
		await ui_animation.animation_finished
		
		ui_animation.play("text_animation")
		ui_speaker_line.text = current_dialogue.speaker_lines[0]

func close_dialogue():
	ui_animation.play("slide_out")
	await ui_animation.animation_finished
	ui_visual.visible = false
	
	ui_animation.play("slide_reset")
	dialogue_closed = true
	current_line = 0

func change_line():
		if current_dialogue != null:
			if Input.is_action_just_pressed("ui_down"):
				current_line += 1
				ui_animation.play("text_animation")
				if current_line < current_dialogue.speaker_lines.size():
					ui_speaker_line.text = current_dialogue.speaker_lines[current_line]
				else:
					close_dialogue()
