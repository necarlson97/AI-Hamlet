shader_type canvas_item;

uniform float radius : hint_range(0, 20) = 1;

void fragment() {
    vec4 color_sum = vec4(0.0);
	int r = int(radius);
	float total = (2.0*radius)*(2.0*radius);
    
    for(int dx = -r; dx <= r; dx++) {
        for(int dy = -r; dy <= r; dy++) {
            vec2 offset = vec2(float(dx), float(dy)) / vec2(textureSize(TEXTURE, 0));
            color_sum += texture(TEXTURE, UV + offset) / total;
        }
    }

    COLOR = color_sum;
}