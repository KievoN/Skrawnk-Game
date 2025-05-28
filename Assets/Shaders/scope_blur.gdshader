shader_type canvas_item;


uniform float lod: hint_range(0.0, 5.0) = 0.0;
uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_linear_mipmap;
uniform sampler2D scope_texture;

void fragment() {
	COLOR.rgb = texture(SCREEN_TEXTURE, SCREEN_UV, lod).rgb;
}