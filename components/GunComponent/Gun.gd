class_name Gun

extends Node3D

var weapon_data: Dictionary

@export var WeaponName: String
@export var StartGun : bool
@export var WantChangeState : bool
@export var StateName : String
@export var AttackStateName : String
@export var description: Array


@export_category("Ammo")
@export var MaxAmmo: int
@export var AmountAmmo: int
@export var Impulse: float
@export var Infinity: bool = false
@export var IsReload: bool = true
@export var Trauma: float = 0

@export_category("Raycast")
@export var Length: float = 35.0
@export var Damage : float
@export var Muzzle: Marker3D

@export_category("Load Nodes")
@export var DetectMarker : Marker3D
@export var Animator: AnimationPlayer
@export var Cast_weapon: PackedScene


func _ready() -> void:
	weapon_data = {
		"description": description,
		"weapon": WeaponName,
		"damage": Damage,
		"mag. size": MaxAmmo
	}

	print(weapon_data)
