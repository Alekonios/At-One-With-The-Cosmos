extends Node3D

@export var dialogue: DialogueResource


func trigger_dialogue():
	UiGlobalDialogue.ui_speaker_name
	UiGlobalDialogue.ui_speaker_line
	UiGlobalDialogue.open_dialogue()
