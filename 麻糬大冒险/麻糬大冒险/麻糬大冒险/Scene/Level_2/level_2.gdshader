shader_type canvas_item;
uniform float Strength = 1.0;
uniform float Speed = 2.0;
void vertex() {
	VERTEX += vec2(cos(TIME *Speed), cos(TIME *Speed +1.3)) *Strength *step(1.,1.-VERTEX.y) ;
	}
