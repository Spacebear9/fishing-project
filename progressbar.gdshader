shader_type canvas_item;

uniform float percent:hint_range(0.0, 1.0, 0.01);

void fragment() {
	float angle = abs(atan(.5-UV.x,.5-UV.y)-(PI));

	if(angle > percent*2.0*PI){
		COLOR = vec4(0.0,0.0,0.0,COLOR.a);
	}
}
