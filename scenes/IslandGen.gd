extends Node

const SIZE = 512  # Size of the heightmap
var image = Image.create(SIZE, SIZE, true, Image.FORMAT_L8)

func _ready():
	image.fill(Color(0, 0, 0))  # Start with a deep ocean

	create_volcanic_features()
	image = await apply_blur_shader()
	apply_perlin_noise()
	apply_vignette()
	image = remap_grayscale_image(image)
	save_heightmap()

func create_volcanic_features():
	var num_volcanos = randi_range(3, 10)
	var margin = 0.2 # Don't spawn volcanoes right on edge
	var line_start = randf_range(margin, 1-margin)
	# Line will always start on one side, and cross diagonally to the other
	var main_axis_start = Vector2(SIZE * margin, SIZE * line_start)
	var main_axis_end = Vector2(SIZE * (1-margin), SIZE * (1-line_start))
	var line_vector = main_axis_end - main_axis_start

	for i in range(num_volcanos):
		var along_line = i / float(num_volcanos - 1)  # Normalized position along the line
		var base_center = main_axis_start + along_line * line_vector
		var perpendicular_offset = Vector2(line_vector.y, -line_vector.x).normalized() * (randf() * 2.0 - 1.0) * (SIZE / 10)
		var volcano_center = base_center + perpendicular_offset

		var drawing_size = SIZE * (1-2*margin)
		draw_volcano(volcano_center, num_volcanos, drawing_size)

func draw_volcano(center, num_volcanos, drawing_size):
	# Draw a volcano, with the rising outer edge, and collapsed inner caldera
	var volcanoe_max = drawing_size / (num_volcanos/4)
	var volcanoe_min = drawing_size / (num_volcanos + 2)
	
	# Outer white circle reprenets the 'mountan' created by volcano
	var outer_radius = randi_range(volcanoe_min, volcanoe_max) / 2
	# The collapsed inner caldera is offset a bit, maybe making crescent 
	var inner_offset = Vector2(randf_range(0.0, 1.0), randf_range(0.0, 1.0))
	inner_offset = inner_offset * outer_radius * 0.5
	var inner_radius = outer_radius * randf_range(0, 0.3)
	var inner_center = center + inner_offset
	
	for x in range(int(center.x - outer_radius), int(center.x + outer_radius)):
		for y in range(int(center.y - outer_radius), int(center.y + outer_radius)):
			if x < 0 or x > SIZE or y < 0 or y > SIZE:
				continue
			var pos = Vector2(x, y)
			var distance_to_outer_edge = outer_radius - (pos - center).length()
			var distance_to_inner_edge = (pos - inner_center).length() - inner_radius

			if distance_to_outer_edge > 0 and distance_to_inner_edge > 0:
				# Calculate how 'deep' inside the feature this pixel is
				var intensity = min(distance_to_outer_edge, distance_to_inner_edge) / outer_radius
				var color_value = clamp(image.get_pixel(x, y).r + intensity, 0.0, 1.0)
				image.set_pixel(x, y, Color(color_value, color_value, color_value, 1))
					
func apply_blur_shader() -> Image:
	var viewport = get_node("SubViewportContainer/SubViewport")
	var sprite = get_node("SubViewportContainer/SubViewport/IslandHeightmap")
	sprite.texture = ImageTexture.create_from_image(image)

	var material = ShaderMaterial.new()
	material.shader = load("res://blur.gdshader")  # Load the shader from file
	sprite.material = material

	# Wait for the viewport to be drawn, then grab its texture
	await get_tree().process_frame  # Wait for the viewport to be drawn
	await get_tree().process_frame
	viewport.get_texture().get_image().save_png("res://shader_image.png")
	image = viewport.get_texture().get_image().duplicate()
	return image

func apply_perlin_noise():
	var noise = FastNoiseLite.new()
	noise.seed = randi()
	noise.noise_type = FastNoiseLite.TYPE_PERLIN
	for x in range(SIZE):
		for y in range(SIZE):
			var existing = image.get_pixel(x, y).r
			var multiplier = (0.5 + noise.get_noise_2d(x+512, y+512))
			var perturbation = noise.get_noise_2d(x, y) * 0.2
			
			var value = (existing*multiplier) + perturbation
			value = clamp(value, 0, 1)
			image.set_pixel(x, y, Color(value, value, value))

func remap_grayscale_image(image: Image) -> Image:
	var min_val = 1.0
	var max_val = 0.0
	# Find the min and max grayscale values in the image
	for y in range(image.get_height()):
		for x in range(image.get_width()):
			var val = image.get_pixel(x, y).r
			min_val = min(min_val, val)
			max_val = max(max_val, val)
	# Avoid division by zero if the image is flat
	if min_val == max_val:
		return image
		
	var range = max_val - min_val
	var new_image = image.duplicate()
	# Remap the image pixels to the full range
	for y in range(new_image.get_height()):
		for x in range(new_image.get_width()):
			var old_val = new_image.get_pixel(x, y).r
			var new_val = (old_val - min_val) / range
			new_image.set_pixel(x, y, Color(new_val, new_val, new_val))
	return new_image

func apply_vignette():
	for x in range(SIZE):
		for y in range(SIZE):
			var nx = float(x) / SIZE
			var ny = float(y) / SIZE
			var distance_to_edge = min(nx, ny, 1 - nx, 1 - ny)
			var existing = image.get_pixel(x, y).r
			var value = existing * distance_to_edge
			image.set_pixel(x, y, Color(value, value, value))

func save_heightmap():
	image.save_png("res://island_heightmap.png")
	print("Island heightmap generated and saved.")
	var sprite = get_node("FinalImage")
	sprite.texture = ImageTexture.create_from_image(image)
