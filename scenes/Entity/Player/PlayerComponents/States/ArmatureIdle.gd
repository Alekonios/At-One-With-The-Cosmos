extends State

@export var FloorCheckCollider : RayCast3D

@onready var Animator = %AnimationTree

func Enter(Argument):
	Animator.set("parameters/ArmatureMovement/transition_request", "IdleArmature")
	%NormalCollision.disabled = false
	%CrouchCollision.disabled = true
	
func Update(delta):
	_Player.velocity.x = lerp(_Player.velocity.x, 0.0, 0.2)
	_Player.velocity.z = lerp(_Player.velocity.z, 0.0, 0.2)
	var InputDir = Input.get_vector("MoveUp", "MoveDown", "MoveLeft", "MoveRight")
	if InputDir.normalized():
		_StateMachine.ChangeState(self, "ArmatureMoveState", null)
	if Input.is_action_just_pressed("Jump"):
		_StateMachine.ChangeState(self, "Jump", null)
	if !FloorCheckCollider.is_colliding() and !_Player.is_on_floor():
		_StateMachine.ChangeState(self, "Fall", null)
	if Input.is_action_pressed("Crouch"):
		_StateMachine.ChangeState(self, "CrouchIdle", null)
	#if _WeaponManager.Weapon and _WeaponManager.Weapon.WantChangeState:
		#_StateMachine.ChangeState(self, _WeaponManager.Weapon.StateName, null)

		
func Exit(Argument):
	pass
