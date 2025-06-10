
class_name PickupUI
extends CanvasLayer


func _ready() -> void:
	UiGlobalPickup.pickup_ui = self
	self.visible = false
