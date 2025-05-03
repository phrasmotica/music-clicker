shader_type canvas_item;

uniform vec2 rect_size;
uniform vec4 outline_colour:source_color;
uniform float tolerance:hint_range(0.0, 1.0);

uniform float cursor_pos:hint_range(0.0, 1.0) = 0.0;
uniform float steepness:hint_range(1.0, 10.0) = 1.0;

varying vec2 vertex_pos;

void vertex() {
	vertex_pos = VERTEX;
}

bool is_text_outline(vec2 position, vec4 colour, vec4 key_colour) {
	float dist = length(colour - key_colour);
	return dist < tolerance;
}

float get_alpha(vec2 position) {
	// TODO: how do we generalise these params to any steepness in [1.0, 10.0]?
	float steepness_temp = 4.0;
	float offset = 0.25;
	float normalised_pos = 2.0 * position.x / 4.0;
	
	return 1.0 - steepness_temp * abs(normalised_pos + offset - cursor_pos);
}

void fragment() {
	vec4 original_colour = COLOR.rgba;
	vec2 real_uv = vertex_pos / rect_size;

	if (is_text_outline(real_uv, original_colour, outline_colour)) {
		float alpha = get_alpha(real_uv);
		COLOR.a = alpha;
	}
}
