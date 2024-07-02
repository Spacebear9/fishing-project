shader_type spatial;

render_mode cull_disabled;

//multiply scale by plane x/y
uniform float scale1;
uniform float scale2;
uniform sampler2D noise;
uniform sampler2D noise2;
uniform sampler2D text : filter_nearest;
uniform vec2 n1dir;
uniform vec2 n2dir;
uniform vec2 aldir;
uniform float n1spd: hint_range(0.0, 1.0, 0.001);
uniform float n2spd: hint_range(0.0, 1.0, 0.001);
uniform float alspd: hint_range(0.0, .1, 0.0001);
uniform float height_offset: hint_range(0.0, 1.0, 0.001);
uniform float height_scale: hint_range(0.0, 5, 0.1);
uniform float alpha: hint_range(0.0, 1.0, 0.001);


void vertex() {
	float height = 0.0;
	height += texture(noise, vec2(VERTEX.x+(n1spd*TIME*normalize(n1dir).x),VERTEX.z+(n1spd*TIME*normalize(n1dir).y))/scale1).x*height_scale-(height_scale/2.0)-height_offset;
	height += texture(noise2, vec2(VERTEX.x+(n2spd*TIME*normalize(n2dir).x),VERTEX.z+(n2spd*TIME*normalize(n2dir).y))/scale2).x*height_scale-(height_scale/2.0)-height_offset;
	
	VERTEX.y += height;
}

void fragment() {
	ALBEDO = texture(text,vec2(UV.x+(alspd*TIME*normalize(aldir).x),UV.y+(alspd*TIME*normalize(aldir).y))*.5).rgb;
	ALPHA = alpha;
	//ALBEDO = texture(text,vec2(UV.x+(alspd*TIME*normalize(aldir)).x,UV.y)).xyz;
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
