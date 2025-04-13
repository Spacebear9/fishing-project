shader_type canvas_item;

uniform float percent:hint_range(0.0, 1.0, 0.01);

void fragment() {
	float angle = abs(atan(.5-UV.x,.5-UV.y)-(PI));

	if(angle > percent*2.0*PI){
		COLOR = vec4(COLOR.r*0.3,COLOR.g*0.3,COLOR.b*0.3,COLOR.a);
	}
}
