shader_type spatial;
render_mode cull_disabled, shadows_disabled;

uniform float ratio : hint_range(0.0, 1.0) = 0.5;
const float height = 2.4;
uniform float pulse_speed : hint_range(0.0, 5.0) = 3.0;
uniform vec3 base_color : source_color = vec3(0.0);

void fragment() {
    // Assuming the mesh uses normalized coordinates from 0.0 to 1.0
    float threshold = ratio;
    
    // Use world_position to determine the height percentile
    float height_percentile = (INV_VIEW_MATRIX * vec4(VERTEX, 1.0)).y / height;
	
	// pulse the edges and insides
	float pulse = (1.0 + sin(TIME * pulse_speed))/2.0;
    vec3 pulse_color = vec3(pulse, pulse, pulse);
	vec3 white = vec3(1.0, 1.0, 1.0);
	
	// Check if the current fragment is below the threshold
    if (height_percentile < threshold) {
		ALBEDO = base_color;
		if (!FRONT_FACING) {
        	EMISSION = white;
			ALBEDO = white;
		}
    } else if (abs(height_percentile - threshold) < 0.1) {
		ALBEDO = base_color;
		EMISSION = pulse_color;
		if (!FRONT_FACING) {
        	EMISSION = white;
			ALBEDO = white;
		}
    } else {
        discard; // Discards the fragment making it transparent
    }
}
