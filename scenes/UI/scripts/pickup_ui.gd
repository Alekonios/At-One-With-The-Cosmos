
class_name PickupUI
extends CanvasLayer

#shares data to _ready()
@onready var anim_player: AnimationPlayer = $AnimationPlayer
@onready var item_name: Label = $"MarginContainer/HBoxContainer/MarginContainer/Item Info"
@onready var item_info: Label = $"MarginContainer/HBoxContainer/MarginContainer2/Item Name"

func _ready() -> void:
	#shares data to UiGlobalPickup
	UiGlobalPickup.ui_item_name = item_name
	UiGlobalPickup.ui_item_info = item_info
	UiGlobalPickup.ui_animation = anim_player
	UiGlobalPickup.ui_visual = self
	#hides UI on load
	self.visible = false
