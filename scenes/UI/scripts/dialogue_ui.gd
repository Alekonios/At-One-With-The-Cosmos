
class_name DialogueUI
extends CanvasLayer

@onready var speaker_name: Label = $"MarginContainer/VBoxContainer/Character Name"
@onready var speaker_line: Label = $"MarginContainer/VBoxContainer/Character Line"
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	UiGlobalDialogue.ui_speaker_name = speaker_name
	UiGlobalDialogue.ui_speaker_line = speaker_line
	UiGlobalDialogue.ui_animation = animation_player
	UiGlobalDialogue.ui_visual = self
	self.visible = false
