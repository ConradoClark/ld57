shader_type canvas_item;

uniform vec4 clr : source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform vec4 clr2: source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform int type : hint_range(1, 2) = 2;
uniform float thickness = 1.0;
uniform float frequency = 10.0;
uniform float phase_speed = 1.0;

const vec2[8] DIRECTIONS = {
	vec2(1.0, 0.0),
	vec2(0.0, 1.0),
	vec2(-1.0, 0.0),
	vec2(0.0, -1.0),
	vec2(1.0, 1.0),
	vec2(-1.0, 1.0),
	vec2(-1.0, -1.0),
	vec2(1.0, -1.0)
};

float gtz(float input) { return max(0, sign(input)); }
// returns 1 if input > 0, else 0

float check(sampler2D tex, vec2 from, vec2 size) {
	float result = 0.0;
	for (int i = 0; i < 4 * type; i++) {
		result += texture(tex, from + DIRECTIONS[i] * size * thickness).a;
	}
	return gtz(result);
}

float check2(sampler2D tex, vec2 from, vec2 size) {
  if (thickness==0.){
    return 0.;
  } 
	float result = 0.0;
	for (int i = 0; i < 4 * type; i++) {
		result += texture(tex, from + DIRECTIONS[i] * size * (thickness+1.)).a;
	}
	return gtz(result);
}

void fragment() {
  vec2 pos = UV - vec2(0.5);
  float angle = atan(pos.y, pos.x);
  if (angle < 0.0) {
    angle += 2.0 * PI;
  }
  float ring = step(0.0, sin(frequency * angle + TIME * phase_speed));
  vec4 new_clr = vec4(clr.rgb, ring * clr.a);
	COLOR = mix(COLOR, new_clr, check(TEXTURE, UV, TEXTURE_PIXEL_SIZE) - gtz(COLOR.a));
  COLOR = mix(COLOR, clr2, check2(TEXTURE, UV, TEXTURE_PIXEL_SIZE) - gtz(COLOR.a));
}
