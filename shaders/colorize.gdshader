shader_type canvas_item;

uniform vec4 color : source_color = vec4(0.0, 0.0, 0.0, 1.0);

void fragment() {
  vec4 orig_color = COLOR;
  COLOR = texture(TEXTURE, UV);
  COLOR.rgb = mix(COLOR.rgb * orig_color.rgb, color.rgb, color.a);
}
