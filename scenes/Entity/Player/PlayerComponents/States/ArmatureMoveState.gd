extends State

@onready var Animator = %AnimationTree

@export var FloorCheckCollider : RayCast3D
@export var Model : Node3D
@export var DebugMoveVis : Node3D
@export var Camera : Camera3D
@export var AimCollider : RayCast3D

var AimMode = false

var AnimName = "WalkWithArmature"

func Enter(Argument):
	Animator.set("parameters/list/transition_request", "ArmatureMovement")
	
func Update(delta):
	if !FloorCheckCollider.is_colliding() and !_Player.is_on_floor():
		_StateMachine.ChangeState(self, "Fall", null)
	if AimMode:
		var mouse_pos = get_viewport().get_mouse_position()
		var ray_origin = Camera.project_ray_origin(mouse_pos)
		var ray_end = ray_origin + Camera.project_ray_normal(mouse_pos) * 1000
		
		AimCollider.global_transform.origin = ray_origin
		AimCollider.target_position = AimCollider.to_local(ray_end)
		AimCollider.force_raycast_update()
		
		if AimCollider.is_colliding():
			var look_at_point = AimCollider.get_collision_point()
			look_at_point.y = Model.global_position.y
			
			# Унифицированный поворот (как в движении)
			var direction = (look_at_point - Model.global_position).normalized()
			DebugMoveVis.look_at(Model.global_position + direction)
			Model.rotation.y = lerp_angle(Model.rotation.y, atan2(direction.x, direction.z), 0.05)
	
func _physics_process(delta: float) -> void:
	if _StateMachine.CurrentState.name.to_lower() != StateName.to_lower():
		return
	var InputDir = Input.get_vector("MoveUp", "MoveDown", "MoveLeft", "MoveRight")
	var Direction = (_Player.transform.basis * Vector3(InputDir.x, 0.0, InputDir.y)).normalized()
	if Direction:
		_Player.velocity.x = lerp(_Player.velocity.x, Direction.x * _Player.Speed , 0.2)
		_Player.velocity.z = lerp(_Player.velocity.z, -Direction.z * _Player.Speed, 0.2)
		if !AimMode:
			DebugMoveVis.look_at(Direction + _Player.position)
			Model.rotation.y = lerp_angle(Model.rotation.y, -DebugMoveVis.rotation.y, 0.2)
		Animator.set("parameters/ArmatureMovement/transition_request", AnimName)
	else:
		if _Player.is_on_floor():
			_StateMachine.ChangeState(self, "ArmatureIdle", null)
	if Input.is_action_pressed("Run") and !AimMode:
		_Player.Speed = lerp(_Player.Speed, _Player.RunSpeed, 0.2)
		AnimName = "RunWithArmature"
	if !Input.is_action_pressed("Run"):
		_Player.Speed = lerp(_Player.Speed, _Player.StartSpeed, 0.2)
		AnimName = "WalkWithArmature"
	
	
func _input(event: InputEvent) -> void:
	if Input.is_action_pressed("Aiming"):
		AimMode = true

	else:
		AimMode = false
func Exit(Argument):
	pass
