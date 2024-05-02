shader_type spatial;

uniform sampler2D heightmap;  // Assign your heightmap texture here
uniform float max_height : hint_range(10, 2000) = 200;

// Colors
const int color_count = 6;
const vec3 height_colors[color_count] = {
	vec3(0, 0, 0), // deep_ocean TODO
	vec3(0.631, 0.643, 0.600), // shallow_ocean TODO
	vec3(0.980, 0.929, 0.804), // sand
	vec3(0.914, 0.929, 0.788), // low_grass
	vec3(0.800, 0.835, 0.682), // high_grass
	vec3(0.631, 0.643, 0.600) // ash
};
const vec3 slope_color = vec3(0.714, 0.729, 0.682);

void vertex() {
    // Sample the height from the heightmap and adjust the vertex position
    float height = texture(heightmap, UV).r;
    VERTEX.y = height * max_height;
	
	// Sample heights at nearby points to approximate derivatives
    float height_x_plus = texture(heightmap, UV + vec2(0.01, 0.0)).r;  // Right
    float height_x_minus = texture(heightmap, UV - vec2(0.01, 0.0)).r;  // Left
    float height_y_plus = texture(heightmap, UV + vec2(0.0, 0.01)).r;  // Up
    float height_y_minus = texture(heightmap, UV - vec2(0.0, 0.01)).r;  // Down

    // Approximate partial derivatives
    float ddx = (height_x_plus - height_x_minus) * 0.5;
    float ddy = (height_y_plus - height_y_minus) * 0.5;

    // Compute tangent and bitangent
    vec3 tangent = vec3(0.01, ddx * max_height, 0.0);
    vec3 bitangent = vec3(0.0, ddy * max_height, 0.01);

    // Compute normal
    NORMAL = normalize(cross(tangent, bitangent));
}

void fragment() {
    // Determine index based on height
    float height = texture(heightmap, UV).r;

    // Calculate slope for blending with slope_color
    vec3 N = normalize(NORMAL);
    float slope = 1.0 - abs(dot(N, vec3(0.0, 1.0, 0.0)));
	
    // Get base color from height
	int index = int(clamp(height * float(color_count), 0.0, float(color_count-1)));
    vec3 base_color = height_colors[index];
	
	ALBEDO = base_color;
    // Blend base color with slope color based on steepness
    vec3 final_color = mix(base_color, slope_color, clamp(slope, 0.0, 1.0));
}
