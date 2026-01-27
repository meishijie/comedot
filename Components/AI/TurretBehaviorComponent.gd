## Controls a [GunComponent] to track and shoot at targets detected by an [AreaComponent] or [Area2D].
## Prioritizes the nearest target.
class_name TurretBehaviorComponent
extends Component


#region Parameters
@export var isEnabled: bool = true

## The rotation speed in radians per second.
@export var rotationSpeed: float = 5.0

## If `true`, the turret will predict the target's position based on velocity.
@export var predictTargetPosition: bool = true

## The [GunComponent] to control. If `null`, looks for one in the parent entity.
@export var gunComponent: GunComponent

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
	if not gunComponent:
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
		detectionArea.body_entered.connect(self.onBodyEntered)
		detectionArea.body_exited.connect(self.onBodyExited)
		# detectionArea.area_entered.connect(self.onAreaEntered) # Optional: target areas?
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
	if currentTarget and not is_instance_valid(currentTarget):
		currentTarget = null
		
	# Find nearest valid target in detection area
	if not detectionArea: return
	
	var bodies = detectionArea.get_overlapping_bodies()
	var nearestDist = INF
	var nearestBody = null
	
	for body in bodies:
		if body == parentEntity: continue
		if body is CharacterBody2D and parentEntity.body == body: continue
		if not isValidTarget(body): continue
		
		var dist = parentEntity.global_position.distance_squared_to(body.global_position)
		if dist < nearestDist:
			nearestDist = dist
			nearestBody = body
			
	currentTarget = nearestBody


func isValidTarget(body: Node2D) -> bool:
	# Check Faction
	if factionComponent:
		# If target is an Entity or has a FactionComponent
		var targetFactionComp = null
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
		var healthComp = (body as Entity).getComponent(HealthComponent)
		if healthComp and healthComp.health.value <= 0: return false
		
	return true


func rotateTowardsTarget(delta: float) -> void:
	var targetPos = currentTarget.global_position
	
	# Simple prediction
	if predictTargetPosition and currentTarget is CharacterBody2D:
		var dist = parentEntity.global_position.distance_to(targetPos)
		# Approximate bullet speed? Let's assume a default or get from gun?
		# GunComponent doesn't easily expose bullet speed unless we inspect the scene.
		# Let's just assume a value or skip prediction if too complex for now.
		var bulletSpeed = 500.0 # Guess
		var timeToHit = dist / bulletSpeed
		targetPos += (currentTarget as CharacterBody2D).velocity * timeToHit
	
	var targetDir = (targetPos - gunComponent.global_position).normalized()
	var currentDir = Vector2.RIGHT.rotated(gunComponent.global_rotation)
	
	# Interpolate rotation
	var angleTo = currentDir.angle_to(targetDir)
	var rotateAmount = sign(angleTo) * min(abs(angleTo), rotationSpeed * delta)
	
	gunComponent.global_rotation += rotateAmount


func tryToShoot() -> void:
	# Only shoot if aim is close enough?
	var targetDir = (currentTarget.global_position - gunComponent.global_position).normalized()
	var currentDir = Vector2.RIGHT.rotated(gunComponent.global_rotation)
	
	if currentDir.dot(targetDir) > 0.9: # Within ~25 degrees
		gunComponent.fire()
	else:
		pass


func onBodyEntered(_body: Node2D) -> void:
	pass # Logic handled in _process via get_overlapping_bodies

func onBodyExited(body: Node2D) -> void:
	if body == currentTarget:
		currentTarget = null

