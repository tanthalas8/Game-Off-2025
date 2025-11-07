extends Line2D

# Adjust these values for your needs
var x_range : int = 1920
var step : float = 1
var amplitude : float = 100  # Scaling factor for the sine wave
var frequency : float = 1 
var frequencyMod = 1

func _ready():
	update_line()

func update_line():
	@warning_ignore("shadowed_variable_base_class")
	var points = []
	for x in range(-x_range, x_range + 1):
		var rad = deg_to_rad(x * step)  # Convert degrees to radians
		var y = sin(rad * frequency) * amplitude   # Calculate sine value
		points.append(Vector2(x * step, y))
	#print(points)
	#print(len(points))
	set_points(points)  # Set the calculated points to Line2D

@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	#frequencyMod += 0.005
	#frequency =  abs(10 * sin(frequencyMod))
	#print(frequency)
	update_line()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			frequency -= 0.1
			frequency = abs(frequency)
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			frequency += 0.1
			frequency = abs(frequency)
