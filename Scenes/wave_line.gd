extends Line2D
var x_range : int = 1920
var step : float = 1
var amplitude : float = 100  # Scaling factor for the sine wave
var frequency : float = 1 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_line()

func update_line():
	var linePoints = []
	for x in range(-x_range, x_range + 1):
		var rad = deg_to_rad(x * step)  # Convert degrees to radians
		var y = sin(rad * frequency) * amplitude   # Calculate sine value
		linePoints.append(Vector2(x * step, y))
	set_points(linePoints)  # Set the calculated points to Line2D


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	update_line()
