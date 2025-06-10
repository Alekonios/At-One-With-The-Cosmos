class_name WeaponManager

extends Node3D

enum States { CHANGE, IDLE, SHOOT, RELOAD }

@export var _StateMachine : StateMachine
@export var WeaponListNode : Node3D
@export var ShootRaycast: RayCast3D


@export var _State: States
@export var StartWeapon: Gun

@export var MaxWeapons: int = 3
@export var IsShoot: bool = false




var Weapon: Gun
var last_weapon: Gun #last weapon picked by player / last node in "OpenWeapons filtred to a" that is of class Gun

var WeaponList : Array = []
var OpenWeapons = []

var LastWeapon : int = 0
var CurrentWeapon: int = 0
var Detect = false
var WantShoot = false
var Damage

func _process(delta: float) -> void:
	%Label.text = str(OpenWeapons[CurrentWeapon])
	if Detect:
		OpenWeapons[CurrentWeapon].global_transform = OpenWeapons[CurrentWeapon].DetectMarker.global_transform
	get_last_picked_weapon()
	
func _ready() -> void:
	IsShoot = false
	for Child in WeaponListNode.get_children():                 
		if Child is Gun:
			WeaponList.append(Child)
			Child.hide()
			Child.AmountAmmo = Child.MaxAmmo
			if Child.StartGun:
				AddWeapon(Child)
				
	UiGlobalPickup.weapon_manager = self
	get_weapon_data()
	
func AddWeapon(_Gun : Gun):
	for Weapon in WeaponList:
		if _Gun == Weapon:
			OpenWeapons.append(_Gun)
			
func _input(event: InputEvent) -> void:
	if Input.is_action_just_released("ScrollUp"):
		if CurrentWeapon >= 0 and CurrentWeapon < OpenWeapons.size() - 1:
			LastWeapon = CurrentWeapon
			CurrentWeapon += 1
			ChangeWeapon()
	if Input.is_action_just_released("ScrollDown"):
		if CurrentWeapon >= 1 and CurrentWeapon <= OpenWeapons.size() - 1:
			LastWeapon = CurrentWeapon
			CurrentWeapon -= 1
			ChangeWeapon()
	
			
func ChangeWeapon():
	if CurrentWeapon != LastWeapon:
		Weapon = OpenWeapons[CurrentWeapon]
		OpenWeapons[LastWeapon].hide()
		Weapon.show()
		if Weapon.DetectMarker:
			Detect = true
		else:
			Detect = false

func get_weapon_data():
	if Weapon and Weapon.weapon_data != null:
		get_last_picked_weapon() 	#This returns the last node in "OpenWeapons filtred to a" that is of class Gun
		last_weapon.weapon_data		#Accesses the "weapon_data dictionary" for the "node returned above"

		#"last_weapon.weapon_data" is later used by the "show_text" function in ""path"" to set the text of a label: 
		#res://assets/UI/scripts/pickup UI/ui_global_pickup.gd (""path"")

func get_last_picked_weapon():
	last_weapon = OpenWeapons.filter(func(a): return a is Gun).back()
#					[1] 		[2] 							[3]
	#[1]
	#OpenWeapons
		#This is the array of nodes

	#[2]
	#.filter(func(a): return a is Gun)
		#This filters the list, keeping only items where "a is Gun" returns true

	#[3]
	#.back():
		 #This returns the last item from the filtered list
