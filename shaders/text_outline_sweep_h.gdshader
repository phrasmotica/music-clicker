shader_type canvas_item;

uniform vec2 rect_size;

uniform vec4 key_colour:source_color;
uniform vec4 highlight_colour:source_color;
uniform float tolerance:hint_range(0.0, 1.0) = 0.5;
uniform float steepness:hint_range(1.0, 10.0) = 4.0;

uniform float progress:hint_range(0.0, 1.0) = 0.0;

varying vec2 vertex_pos;

void vertex() {
	vertex_pos = VERTEX;
}

bool should_key(vec2 position, vec4 colour) {
	float dist = length(colour - key_colour);
	return dist < tolerance;
}

float get_mask_width(float steepness_factor) {
	// e.g.
	// 3.0 -> 0.666
	// 4.0 -> 0.5
	// 5.0 -> 0.4
	return 2.0 / steepness_factor;
}

float get_mask_pos(float mask_width, float prog) {
	float scaled_pos = prog * (1.0 + mask_width);
	float offset_pos = scaled_pos - 0.5 * mask_width;
	return offset_pos;
}

float get_alpha(vec2 position) {
	float mask_width = get_mask_width(steepness);
	float mask_pos = get_mask_pos(mask_width, progress);

	float dist_from_mask = abs(position.x - mask_pos);
	float normalised_dist_from_mask = steepness * dist_from_mask;

	return max(1.0 - normalised_dist_from_mask, 0.0);
}

void fragment() {
	vec4 original_colour = COLOR.rgba;
	vec2 real_uv = vertex_pos / rect_size;

	if (should_key(real_uv, original_colour)) {
		COLOR.rgb = highlight_colour.rgb;

		float alpha = get_alpha(real_uv);
		COLOR.a = alpha;
	}
}
