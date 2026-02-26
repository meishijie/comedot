## Makes the parent entity sprint towards a target when detected.
## Works with PlatformerPatrolComponent for normal patrol behavior.
## Requirements: BEFORE PlatformerPatrolComponent, AFTER InputComponent

class_name SprintComponent
extends Component


#region Parameters

## Group name to detect targets (e.g., "players")
@export var detectionGroup: StringName = &"players"

## Distance to detect targets
@export var detectionRange: float = 150.0

## Speed multiplier during sprint (relative to normal speed)
@export var sprintSpeedMultiplier: float = 3.0

## Duration of sprint in seconds
@export var sprintDuration: float = 0.8

## Cooldown between sprints
@export var sprintCooldown: float = 2.0

## Minimum time to wait before first sprint
@export var initialDelay: float = 0.5

#endregion


#region State

enum State { IDLE, PATROL, SPRINTING, COOLDOWN }
@export_storage var currentState: State = State.IDLE

var sprintTimer: float = 0.0
var cooldownTimer: float = 0.0
var targetPosition: Vector2 = Vector2.ZERO

var normalSpeed: float = 0.0

@export_storage var detectedTarget: Node2D

#endregion


#region Dependencies

@onready var characterBodyComponent: CharacterBodyComponent = coComponents.CharacterBodyComponent
@onready var inputComponent: InputComponent = coComponents.InputComponent
@onready var platformerPatrolComponent: PlatformerPatrolComponent = coComponents.PlatformerPatrolComponent

func getRequiredComponents() -> Array[Script]:
	return [CharacterBodyComponent, InputComponent]

#endregion


func _ready() -> void:
	super._ready()
	cooldownTimer = initialDelay
	normalSpeed = 320.0  # Default platformer speed
	set_physics_process(true)


func _physics_process(delta: float) -> void:
	match currentState:
		State.IDLE:
			_processIdle(delta)
		State.PATROL:
			_processPatrol(delta)
		State.SPRINTING:
			_processSprinting(delta)
		State.COOLDOWN:
			_processCooldown(delta)


func _processIdle(delta: float) -> void:
	cooldownTimer -= delta
	if cooldownTimer <= 0:
		currentState = State.PATROL


func _processPatrol(_delta: float) -> void:
	# Try to detect target
	_detectTarget()
	if is_instance_valid(detectedTarget):
		currentState = State.SPRINTING
		sprintTimer = sprintDuration
		targetPosition = detectedTarget.global_position


func _processSprinting(delta: float) -> void:
	sprintTimer -= delta

	# Lock direction towards target
	if is_instance_valid(detectedTarget):
		targetPosition = detectedTarget.global_position

	var direction: Vector2 = parentEntity.global_position.direction_to(targetPosition)
	# For platformer, only use horizontal movement
	direction.y = 0
	direction = direction.normalized()

	inputComponent.movementDirection = direction
	inputComponent.runPressed = true

	if sprintTimer <= 0:
		currentState = State.COOLDOWN
		cooldownTimer = sprintCooldown
		inputComponent.runPressed = false


func _processCooldown(delta: float) -> void:
	cooldownTimer -= delta
	if cooldownTimer <= 0:
		currentState = State.PATROL
		detectedTarget = null


func _detectTarget() -> void:
	var targets: Array[Node] = get_tree().get_nodes_in_group(detectionGroup)
	var nearestDistance: float = detectionRange
	var currentDetectedTarget: Node2D = null

	for target_node: Node in targets:
		if target_node is Node2D:
			var target: Node2D = target_node
			var distance: float = characterBodyComponent.body.global_position.distance_to(target.global_position)
			if distance < nearestDistance:
				nearestDistance = distance
				currentDetectedTarget = target
	detectedTarget = currentDetectedTarget


func getIsSprinting() -> bool:
	return currentState == State.SPRINTING
