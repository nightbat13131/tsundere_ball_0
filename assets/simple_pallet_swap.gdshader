// https://github.com/KoBeWi/Godot-Palette-Swap-Shader/blob/master/addons/PaletteSwapShader/SimplePaletteSwap.gdshader
shader_type canvas_item;

uniform int color_count;
uniform ivec3[32] source;
uniform vec3[32] output;

void fragment() {
	ivec3 colori = ivec3(round(COLOR.rgb * 255.0));
	for (int i = 0; i < color_count; i++) {
		if (colori == source[i]) {
			COLOR.rgb = output[i];
			break;
		}
	}
}