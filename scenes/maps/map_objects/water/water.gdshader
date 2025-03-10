shader_type spatial;

render_mode cull_disabled;

//multiply scale by plane x/y
uniform float planeWidth;
uniform float planeHeight;

uniform float scale_devide = 2.0;

uniform float albedo_scale: hint_range(0.0, 0.1, 0.01);
uniform sampler2D albedo_texture : filter_nearest;
uniform float albedo_speed: hint_range(0.0, 25.0, 1.0);
uniform float albedo_direction: hint_range(0.0, 6.2, 0.01);

uniform sampler2D noise_1;
uniform float noise_1_direction: hint_range(0.0, 6.2, 0.01);
uniform float noise_1_speed: hint_range(0.0, .1, 0.001);

uniform sampler2D noise_2;
uniform float noise_2_direction: hint_range(0.0, 6.2, 0.01);
uniform float noise_2_speed: hint_range(0.0, .1, 0.001);

uniform float height_offset: hint_range(0.0, 1.0, 0.001);
uniform float height_scale: hint_range(0.0, 20, 0.1);

uniform float alpha: hint_range(0.0, 1.0, 0.001);

void vertex() {
	float height = 0.0;
	float scale = (planeHeight+planeWidth)/2.0;

	vec2 n1d = vec2(sin(noise_1_direction),cos(noise_1_direction));
	vec2 n2d  = vec2(sin(noise_2_direction),cos(noise_2_direction));

	height += texture(noise_1, (UV/scale_devide)+(TIME*noise_1_speed*n1d)).x*height_scale-(height_scale/2.0);
	height += texture(noise_2, (UV/scale_devide)+(TIME*noise_2_speed*n2d)).x*height_scale-(height_scale/2.0);

	height -= height_offset;
	VERTEX.y += height;
}

void fragment() {
	vec2 direction = vec2(sin(albedo_direction),cos(albedo_direction));
	ALBEDO = texture(albedo_texture,(UV*vec2(planeWidth,planeHeight) + (albedo_speed*TIME*direction))*albedo_scale).rgb;
	ALPHA = alpha;
}