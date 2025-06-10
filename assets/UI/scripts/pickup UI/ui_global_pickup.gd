extends Node

var ui_packed_scene: PackedScene = preload("res://assets/UI/scenes/pickup UI/pickup_ui.tscn")

var was_picked: bool = false
var ui_seen: bool = false

var ui_animation: AnimationPlayer
var ui_visual: CanvasLayer

var weapon_manager: WeaponManager
var weapon_data #stores data returned by get_weapon_data()

var ui_item_name: Label
var ui_item_info: Label

var ui_visible: bool = false
var ui_onscreen_time: float = 5
var reset_timer: float = 10


func _ready() -> void:
	var ui_instance = ui_packed_scene.instantiate()
	add_child(ui_instance)


func show_ui():
	if was_picked == false:
		ui_visual.visible = true
		ui_visible = true
		ui_animation.play("slide_in")
		show_text()

		await ui_animation.animation_finished
		was_picked = true
		ui_seen = true

func hide_ui():
	ui_animation.play("slide_out")

	await ui_animation.animation_finished
	ui_visual.visible = false
	ui_visible = false

func hide_ui_on_input():
	if Input.is_anything_pressed():
		if ui_seen == true:
			ui_animation.play("slide_out")

			await ui_animation.animation_finished
			ui_visual.visible = false
			ui_visible = false

func hide_ui_on_timeout(delta):
	if ui_visible == true:
		ui_onscreen_time -= delta

	if ui_onscreen_time <= 0:
		hide_ui()
		ui_onscreen_time = reset_timer

func show_text():

	#test in "testlocation"
	
	# !! doesn't work due: !!
	#Invalid access to property or key 'weapon' on a base object of type 'Nil'.

	if weapon_manager != null:
		weapon_data = weapon_manager.get_weapon_data()
		ui_item_name.text = weapon_data["weapon"]
