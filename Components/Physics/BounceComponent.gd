## Applies a velocity impulse to any [CharacterBody2D] that enters the [Area2D] of this component.
## Useful for jump pads, springs, bumpers, etc.
class_name BounceComponent
extends AreaCollisionComponent


#region Parameters
## The velocity to apply to the colliding body.
## If [member isAdditive] is `true`, this velocity is added to the body's current velocity.
## If [member isAdditive] is `false`, the body's velocity is set to this value (useful for consistent jump pads).
@export var bounceVelocity: Vector2 = Vector2(0, -500)

## If `true`, the [member bounceVelocity] is added to the body's current velocity.
## If `false`, the body's velocity is replaced by [member bounceVelocity].
@export var isAdditive: bool = false

## If `true`, the X component of the body's velocity will be reset to 0 before applying the bounce (if not additive).
## Useful for vertical jump pads to kill horizontal momentum.
@export var shouldResetHorizontalVelocity: bool = false

## If `true`, the Y component of the body's velocity will be reset to 0 before applying the bounce (if not additive).
@export var shouldResetVerticalVelocity: bool = true
#endregion


#region Signals
signal didBounce(body: Node2D)
#endregion


func _ready() -> void:
	super._ready()
	# Ensure we monitor bodies, as jump pads usually interact with characters.
	self.shouldMonitorBodies = true
	self.shouldMonitorAreas = false # Usually not needed for jump pads
	
	connectSignals()


func onBodyEntered(bodyEntered: Node2D) -> void:
	super.onBodyEntered(bodyEntered)
	
	# Try to find a CharacterBody2D to bounce.
	# First check if the body itself is one.
	var charBody: CharacterBody2D = bodyEntered as CharacterBody2D
	
	# If not, check if it's an Entity and get its body.
	if not charBody and bodyEntered is Entity:
		charBody = (bodyEntered as Entity).getBody()
		
	if not charBody:
		# One last check: maybe the parent is an Entity? (e.g. we hit a hitbox Area)
		var parent = bodyEntered.get_parent()
		if parent is Entity:
			charBody = parent.getBody()
			
	if charBody:
		applyBounce(charBody)


func applyBounce(body: CharacterBody2D) -> void:
	if debugMode:
		emitDebugBubble("BOING!", Color.ORANGE, true)

	if isAdditive:
		body.velocity += bounceVelocity
	else:
		# If replacing velocity, optionally reset axes first
		if shouldResetHorizontalVelocity:
			body.velocity.x = 0
		if shouldResetVerticalVelocity:
			body.velocity.y = 0
			
		# Apply the bounce velocity
		# Note: We only set the axes that are non-zero in the bounceVelocity, 
		# OR we set everything if we want strict control.
		# Let's stick to simple logic: If not additive, we overwrite based on the settings.
		
		# If bounceVelocity is (0, -500), we typically want to keep X velocity unless reset is requested.
		
		var newVelocity = body.velocity
		
		if bounceVelocity.x != 0:
			newVelocity.x = bounceVelocity.x
		if bounceVelocity.y != 0:
			newVelocity.y = bounceVelocity.y
			
		body.velocity = newVelocity
		
	didBounce.emit(body)
