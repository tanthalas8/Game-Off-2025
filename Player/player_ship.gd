extends RigidBody2D

# Smoothness options:
var smooth_weight := 10.0    # larger = snappier when using lerp-style
var max_turn_speed := 6.0   # radians/sec for rotate_toward style
var MaxZoomOutSpeed: float = 1000
var MaxSpeed = 1000
var RocketThrustForceModifier: float = 50.0
var CurrentRocketThrustPerSec: float = 0.0
var StartingCameraZoom: float = 1.5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var mousePos = get_global_mouse_position()
	var disFromMs2Pl = mousePos.distance_to(global_position)
	print(self.linear_velocity.length())
	
	if (Input.is_action_pressed("moveForward")):
		#Get direction and apply a force in that direction.
		var dir = Vector2(cos(global_rotation), sin(global_rotation))
		CurrentRocketThrustPerSec = (RocketThrustForceModifier * delta * disFromMs2Pl)
		apply_central_force(dir * CurrentRocketThrustPerSec)
		
	# Rotate the ship to face the mouse pointer.
	var targetAngle = (mousePos - global_position).angle()
	global_rotation = lerp_angle(rotation, targetAngle, 1.0 - exp(-smooth_weight * delta))
	
	# Zoom the camera out bases on how fast the ship is moving.
	var zoom = StartingCameraZoom - (self.linear_velocity.length() / MaxZoomOutSpeed)
	zoom = clampf(zoom, 0.5, 2.0);
	$Camera2D.zoom = Vector2(zoom, zoom)

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	var vel: Vector2 = state.get_linear_velocity()
	var speed: float = vel.length()
	#Set a limit on the speed, I might increase this to make it more 'real'
	if speed > MaxSpeed:
		# Preserve direction, clamp magnitude
		vel = vel.normalized() * MaxSpeed
		state.set_linear_velocity(vel)
