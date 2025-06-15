extends State

@export var AttackColldier : RayCast3D
@export var ComboTimer : Timer
@export var Model : Node3D
@onready var Animator = %AnimationTree

var AttackActive = false
var CanCombo = false  # Флаг, разрешающий переход к следующей атаке в комбо

var AnimVariationAttack = ["Attack1", "Attack2", "Attack3"]
var CurrentVariationAttack = 0

func Enter(Argument):
	if !AttackActive:
		AttackColldier.target_position.z = Argument
		AttackActive = true
		CanCombo = false
		if !ComboTimer.is_stopped():
			CurrentVariationAttack += 1
			if CurrentVariationAttack > 3:
				CurrentVariationAttack = 0
		else:
			CurrentVariationAttack = 0
		print("Starting attack: ", CurrentVariationAttack)
		Animator.set("parameters/ArmatureAttackList/transition_request", AnimVariationAttack[CurrentVariationAttack])
		Animator.set("parameters/ArmatureAttack/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
		if CurrentVariationAttack == 1:
			CurrentVariationAttack = 2

func GoForvard(F : float):
	var Dir = Vector3(0, 0, -1).rotated(Vector3.UP, Model.global_rotation.y) 
	var ForwardDirection = Dir.normalized()
	_Player.velocity = -ForwardDirection * F

func StopAttack():
	
	AttackActive = false
	if !CanCombo:
		_StateMachine.ChangeState(self, _StateMachine.PastState.StateName, null)
		CanCombo = true

func Update(delta):
	_Player.velocity.x = lerp(_Player.velocity.x, 0.0, 0.2)
	_Player.velocity.z = lerp(_Player.velocity.z, 0.0, 0.2)

func Exit(Argument):
	pass

func _on_combat_timer_timeout() -> void:
	CurrentVariationAttack = 0
	CanCombo = false
	if AttackActive:
		StopAttack() 
