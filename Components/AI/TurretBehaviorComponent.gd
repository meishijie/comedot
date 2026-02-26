## Controls a [GunComponent] to track and shoot at targets detected by an [AreaComponent] or [Area2D].
## Prioritizes the nearest target.
class_name TurretBehaviorComponent
extends Component


#region Parameters
@export var isEnabled: bool = true

## The rotation speed in radians per second.
@export var rotationSpeed: float = 5.0

## The estimated speed of the projectile for leading targets.
@export var projectileSpeed: float = 500.0

## If `true`, the turret will predict the target's position based on velocity.
@export var predictTargetPosition: bool = true

## The weapon component to control (e.g. [GunComponent] or [DamageRayComponent]). If `null`, looks for one in the parent entity.
@export var gunComponent: Component

## The detection range. If target is beyond this, turret stops firing.
@export var shootRange: float = 300.0

## The [Area2D] used to detect targets. If `null`, looks for one in the children.
## NOTE: This area should have `monitorable = false` and `monitoring = true`.
## It should also set its collision mask to detect the desired targets (e.g. Players).
@export var detectionArea: Area2D
#endregion


#region State
var currentTarget: Node2D
#endregion


#region Dependencies
@onready var factionComponent: FactionComponent = parentEntity.getComponent(FactionComponent)
#endregion


func _ready() -> void:
	super._ready()
	if not gunComponent:
		if parentEntity:
			gunComponent = parentEntity.findFirstComponentSubclass(GunComponent)
		if not gunComponent:
			printWarning("Missing GunComponent")
			
	if not detectionArea:
		# Try to find a child Area2D that is NOT the gun's area or the entity's main area if possible
		# For now, let's just find *an* Area2D that isn't the gun's?
		# Simplest is to assume the user assigns it or we find one named "DetectionArea"
		detectionArea = parentEntity.find_child("DetectionArea", true, false)
		if not detectionArea:
			detectionArea = parentEntity.findFirstChildOfType(Area2D)
			
	if detectionArea:
		Tools.connectSignal(detectionArea.body_entered, self.onBodyEntered)
		Tools.connectSignal(detectionArea.body_exited, self.onBodyExited)
	else:
		printWarning("Missing DetectionArea")


func _process(delta: float) -> void:
	if not isEnabled or not gunComponent: return
	
	updateTarget()
	
	if currentTarget:
		rotateTowardsTarget(delta)
		tryToShoot()


func updateTarget() -> void:
	# Validate current target
	if not currentTarget or parentEntity.global_position.distance_to(currentTarget.global_position) > shootRange:
		currentTarget = null
		
	# Find nearest valid target in detection area
	if not detectionArea: return
	
	var bodies: Array[Node2D] = detectionArea.get_overlapping_bodies()
	var nearestDist: float = INF
	var nearestBody: Node2D = null
	
	for body: Node2D in bodies:
		if body == parentEntity: continue
		if body is CharacterBody2D and parentEntity.body == body: continue
		if not isValidTarget(body): continue
		
		var dist: float = parentEntity.global_position.distance_to(body.global_position)
		if dist < nearestDist:
			nearestDist = dist
			nearestBody = body
			
	currentTarget = nearestBody


func isValidTarget(body: Node2D) -> bool:
	# Check Faction
	if factionComponent:
		# If target is an Entity or has a FactionComponent
		var targetFactionComp: FactionComponent = null
		if body is Entity:
			targetFactionComp = (body as Entity).getComponent(FactionComponent)
		else:
			# Try to find component in children? Or assumes body itself has it?
			pass
			
		if targetFactionComp:
			if not factionComponent.checkOpposition(targetFactionComp.factions):
				return false
	
	# Check Health (don't shoot dead things)
	if body is Entity:
		var healthComp: HealthComponent = (body as Entity).getComponent(HealthComponent)
		if healthComp and healthComp.health.value <= 0: return false
		
	return true


func rotateTowardsTarget(delta: float) -> void:
	var targetPos: Vector2 = currentTarget.global_position
	
	# Simple prediction
	if predictTargetPosition and currentTarget is CharacterBody2D:
		var dist: float = parentEntity.global_position.distance_to(targetPos)
		var timeToHit: float = dist / projectileSpeed
		targetPos += (currentTarget as CharacterBody2D).velocity * timeToHit
	
	var targetDir: Vector2 = (targetPos - gunComponent.global_position).normalized()
	var currentDir: Vector2 = Vector2.RIGHT.rotated(gunComponent.global_rotation)
	
	# Interpolate rotation
	var angleTo: float = currentDir.angle_to(targetDir)
	var rotateAmount: float = sign(angleTo) * min(abs(angleTo), rotationSpeed * delta)
	
	gunComponent.global_rotation += rotateAmount


func tryToShoot() -> void:
	# Only shoot if aim is close enough?
	var targetDir: Vector2 = (currentTarget.global_position - gunComponent.global_position).normalized()
	var currentDir: Vector2 = Vector2.RIGHT.rotated(gunComponent.global_rotation)
	
	if currentDir.dot(targetDir) > 0.9: # Within ~25 degrees
		if gunComponent.has_method(&"fire"):
			gunComponent.call(&"fire")
		elif "isEnabled" in gunComponent:
			gunComponent.set(&"isEnabled", true)
	else:
		if "isEnabled" in gunComponent and not gunComponent.has_method(&"fire"):
			gunComponent.set(&"isEnabled", false)


func onBodyEntered(_body: Node2D) -> void:
	pass # Logic handled in _process via get_overlapping_bodies

func onBodyExited(body: Node2D) -> void:
	if body == currentTarget:
		currentTarget = null

