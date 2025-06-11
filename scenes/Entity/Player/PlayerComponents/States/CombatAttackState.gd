extends State

@export var AttackColldier : RayCast3D
@export var ComboTimer : Timer
@export var Model : Node3D
@onready var Animator = %AnimationTree

var AttackActive = false

var AnimVariationAttack = ["Attack1", "Attack2", "Attack3"]
var CurrentVariationAttack = 0

func Enter(Argument):
	if !AttackActive:
		AttackActive = true
		AttackColldier.target_position.z = Argument
		if !ComboTimer.is_stopped():
			CurrentVariationAttack += 1
		if CurrentVariationAttack > 2:
			CurrentVariationAttack = 0
		print(CurrentVariationAttack)
		Animator.set("parameters/ArmatureAttackList/transition_request", AnimVariationAttack[CurrentVariationAttack])
		Animator.set("parameters/ArmatureAttack/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
		

func GoForvard(F : float):
	var Dir = Vector3(0, 0, -1).rotated(Vector3.UP, Model.global_rotation.y) 
	var ForwardDirection = Dir.normalized()
	_Player.velocity = -ForwardDirection * F

func StopAttack():
	ComboTimer.start()
	AttackActive = false
	_StateMachine.ChangeState(self, _StateMachine.PastState.StateName, null)
	
func Update(delta):
	_Player.velocity.x = lerp(_Player.velocity.x, 0.0, 0.2)
	_Player.velocity.z = lerp(_Player.velocity.z, 0.0, 0.2)
	
func Exit(Argument):
	pass


func _on_combat_timer_timeout() -> void:
	CurrentVariationAttack = 0
