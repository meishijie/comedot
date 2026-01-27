## Allows a [CharacterBodyComponent] to perform a "dash" or "slide" maneuver when the "dash" input action is pressed.
## The dash applies a constant velocity for a set duration, overriding normal movement control.
## Requirements: [InputComponent], [CharacterBodyComponent].
class_name DashComponent
extends CharacterBodyDependentComponentBase


#region Parameters
@export_group("Dash Settings")
## The speed of the dash. If 0, uses the body's current speed * [member speedMultiplier].
@export var dashSpeed: float = 600.0

## Multiplier applied to the dash speed if [member dashSpeed] is 0, or applied to the current movement direction.
@export var speedMultiplier: float = 1.0

## How long the dash lasts in seconds.
@export var duration: float = 0.2

## How long before the player can dash again.
@export var cooldown: float = 1.0

## If `true`, the player cannot change direction during the dash.
@export var lockDirection: bool = true

## If `true`, the player is invincible during the dash. (Requires [InvulnerabilityOnHitComponent])
@export var isInvincible: bool = false

@export_group("Input")
## The input action to trigger the dash.
@export var inputAction: StringName = GlobalInput.Actions.dash
#endregion


#region State
var isDashing: bool = false
var dashTimer: float = 0.0
var cooldownTimer: float = 0.0
var dashDirection: Vector2 = Vector2.ZERO
#endregion


#region Dependencies
@onready var inputComponent: InputComponent = parentEntity.findFirstComponentSubclass(InputComponent)
# Optional dependency for invulnerability
@onready var invulnerabilityComponent: InvulnerabilityOnHitComponent = parentEntity.getComponent(InvulnerabilityOnHitComponent)
#endregion


#region Signals
signal didStartDash
signal didEndDash
#endregion


func getRequiredComponents() -> Array[Script]:
	return [CharacterBodyComponent, InputComponent]


func _ready() -> void:
	super._ready()
	if not inputComponent:
		printError("Missing InputComponent!")
		
	# Ensure the input component monitors our action
	if inputComponent and not inputComponent.inputActionsToMonitor.has(inputAction):
		inputComponent.inputActionsToMonitor.append(inputAction)


func _process(delta: float) -> void:
	# Handle Cooldown
	if cooldownTimer > 0:
		cooldownTimer -= delta
		
	# Handle Dash Duration
	if isDashing:
		dashTimer -= delta
		if dashTimer <= 0:
			endDash()


func _physics_process(_delta: float) -> void:
	if not isDashing:
		# Check for Input to Start Dash
		if inputComponent and cooldownTimer <= 0:
			# Check input state directly from InputComponent or Global Input
			# Note: InputComponent updates `inputActionsPressed` list.
			if inputComponent.inputActionsPressed.has(inputAction) or Input.is_action_just_pressed(inputAction):
				startDash()
	else:
		# Apply Dash Movement
		# Override the body's velocity
		body.velocity = dashDirection * dashSpeed * speedMultiplier
		
		# Prevent other components from messing with velocity?
		# CharacterBodyComponent.shouldMoveThisFrame is handled by us now? 
		# Actually, we just set velocity, and let CharacterBodyComponent move it.
		# But to prevent PlatformerPhysics from applying friction/gravity effectively cancelling our dash,
		# we might need to enforce this velocity every frame (which we do here).
		
		characterBodyComponent.shouldMoveThisFrame = true


func startDash() -> void:
	if isDashing or cooldownTimer > 0: return
	
	# Determine direction
	var moveDir = inputComponent.movementDirection
	if moveDir.is_zero_approx():
		# If no input, dash in the facing direction? Or verify sprite flip?
		# For now, let's just dash forward if we have a MovementFacingComponent, or default to X=1
		var facingComp = parentEntity.getComponent(MovementFacingComponent)
		if facingComp and "facingDirection" in facingComp:
			dashDirection = facingComp.facingDirection
		else:
			# Fallback to current velocity direction or right
			if not body.velocity.is_zero_approx():
				dashDirection = body.velocity.normalized()
			else:
				dashDirection = Vector2.RIGHT # Default
	else:
		dashDirection = moveDir.normalized()
		
	isDashing = true
	dashTimer = duration
	
	if isInvincible and invulnerabilityComponent:
		invulnerabilityComponent.startInvulnerability()
			
	didStartDash.emit()
	if debugMode: emitDebugBubble("DASH!", Color.CYAN)


func endDash() -> void:
	isDashing = false
	cooldownTimer = cooldown
	
	# Optional: reduce velocity at end of dash to prevent sliding?
	# body.velocity = Vector2.ZERO 
	
	didEndDash.emit()

