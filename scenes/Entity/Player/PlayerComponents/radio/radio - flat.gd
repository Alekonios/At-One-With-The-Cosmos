
class_name RadioFlat
extends Node3D

@onready var anim_player: AnimationPlayer = $"Compas (2)/AnimationPlayer"
@export var camera: Camera3D
@export var player: Player

@onready var l: MeshInstance3D = $L
@onready var r: MeshInstance3D = $R

#@export var max_freq: float = 250
#@export var min_freq: float = 50

@onready var freq_label: Label3D = $"Frequency Label"
@onready var needle: MeshInstance3D = $M
@export var scroll_speed: float = 4


var offset: float = 0
var freq: float
var path_len: float
var radio_equiped: bool = false


func _ready() -> void:
	path_len = round(l.position.x + r.position.x * -1) * 20
	print(path_len)

func _process(delta: float) -> void:
	face_camera()
	radio_equip()

	offset_needle(delta)
	update_freq_label()


func update_freq_label():
	if needle.position.x <0:
		freq = path_len - needle.position.x *-10
	elif needle.position.x >0:
		freq = path_len + needle.position.x * 40

	if freq < 0:
		freq = freq * -1

	freq_label.text = ("%.2f kHz" % freq)

func radio_equip():
	if Input.is_action_pressed("Tab") and !radio_equiped:
		self.visible = true
		radio_equiped = true
		anim_player.play("Compas_Action")
	elif !Input.is_action_pressed("Tab") and radio_equiped:
		anim_player.play("Compas_Action_1")
		await anim_player.animation_finished
		self.visible = false
		radio_equiped = false

func offset_needle(delta):
	offset = Input.get_axis("ui_left", "ui_right") * scroll_speed * delta
	
	needle.position.x += offset
	needle.position = clamp(needle.position, l.position, r.position)

func face_camera():
	if camera.current == true:
		look_at(camera.global_transform.origin, Vector3.DOWN * -1)
