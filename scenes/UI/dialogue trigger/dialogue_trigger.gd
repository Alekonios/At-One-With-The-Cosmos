extends Node3D

@export var dialogue: DialogueResource
var dialogue_triggered: bool = false

func trigger_dialogue():
	UiGlobalDialogue.ui_speaker_name.text = dialogue.speaker_name
	UiGlobalDialogue.ui_speaker_line.text = dialogue.speaker_lines[0]
	UiGlobalDialogue.open_dialogue()


func _on_area_3d_body_entered(body: Node3D) -> void:
	UiGlobalDialogue.current_dialogue = dialogue
	if body is Player:
		if dialogue_triggered == false:
			dialogue_triggered = true
			trigger_dialogue()

func _on_area_3d_body_exited(body: Node3D) -> void:
	UiGlobalDialogue.current_dialogue = null
	if body is Player:
		UiGlobalDialogue.close_dialogue()
