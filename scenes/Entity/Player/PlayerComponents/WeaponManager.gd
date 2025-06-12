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
	
func _ready() -> void:
	IsShoot = false
	for Child in WeaponListNode.get_children():                 
		if Child is Gun:
			WeaponList.append(Child)
			Child.hide()
			Child.AmountAmmo = Child.MaxAmmo
			if Child.StartGun:
				AddWeapon(Child)
	
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
	if Input.is_action_just_pressed("Attack"):
		if Weapon and Weapon.AttackStateName and !_StateMachine.CurrentState.AttackState:
			print(Weapon.AttackStateName)
			_StateMachine.ChangeState(_StateMachine.CurrentState, Weapon.AttackStateName, Weapon.Length)
			
	
			
func ChangeWeapon():
	if CurrentWeapon != LastWeapon:
		Weapon = OpenWeapons[CurrentWeapon]
		ChangeState()
		OpenWeapons[LastWeapon].hide()
		Weapon.show()
		if Weapon.DetectMarker:
			Detect = true
		else:
			Detect = false
			
func ChangeState():
	if Weapon.WantChangeState:
		_StateMachine.ChangeState(_StateMachine.CurrentState, Weapon.StateName, null)
		
