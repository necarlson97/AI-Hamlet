shader_type spatial;
render_mode specular_toon;

const vec3 base_color = vec3(0.667, 0.890, 0.863);

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// TODO better toon water
	float fresnel = sqrt(1.0 - dot(NORMAL, VIEW));

	ALPHA = 0.7;
	ROUGHNESS = 0.0;
	SPECULAR = 1.0;
	RIM = 0.2;
	ALBEDO = base_color + (0.1 * fresnel);
}
//
//float height(vec2 position, float time) {
  //float h = wave(position * 0.4);
  //return h;
//}
//
//float wave(vec2 position){
  //position += texture(noise, position / 10.0).x * 2.0 - 1.0;
  //vec2 wv = 1.0 - abs(sin(position));
  //return pow(1.0 - pow(wv.x * wv.y, 0.65), 4.0);
//}
