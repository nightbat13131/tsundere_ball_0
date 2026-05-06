// https://www.reddit.com/r/godot/comments/n8vxw3/how_to_create_a_shader_that_mimics_canvas_modulate/
// https://github.com/godotengine/godot-proposals/issues/6870
// Turns out chaning the color of an outline is cursed - I went and deleted all the outlines around the balls and am now just drawing them in with a shader instead
// so the ball outline curse is broken. No changes needed on your end, just wanted to let you know.
// https://godotshaders.com/shader/outline-for-atlas-texture-region/


shader_type canvas_item;
//instance uniform vec4 texture_region = vec4(0.0);
instance uniform float outline_thickness: hint_range(0.0, 16.0, .5) = 2.5;
instance uniform vec4 modulate : source_color = vec4(1, 1, 1, 1.0); // still used to darken when sunk into hole
instance uniform vec4 new_background : source_color = vec4(1.0, 1.0, .1, 1.0);
//const vec4 BACKGROUND = vec4(0,0,0,1);
//const float EPSILON = 0.5;

//void fragment()
//{
	//vec4 curr_pixel_color  = texture(TEXTURE, UV);
	//if (curr_pixel_color.a < 1.0 && curr_pixel_color.a > 0.1) { // edge of sprite
		//COLOR = new_background;
	//} else if (length(curr_pixel_color - BACKGROUND) < EPSILON) { // near target color
		//COLOR = new_background; // still change alpha because one of the border colors is transparent
		//// Body of items should have no alpha issues, so maintaining it for edge cases
	//} else { COLOR.rgb = (curr_pixel_color  * modulate).rgb;}
//}



void fragment() {
	vec4 color = texture(TEXTURE, UV);
	vec2 outline_offset = vec2(outline_thickness) * TEXTURE_PIXEL_SIZE;
	//vec4 uv_region = vec4(texture_region.xy * TEXTURE_PIXEL_SIZE, texture_region.zw * TEXTURE_PIXEL_SIZE);
	vec4 uv_region = vec4(0.0); // vec4(texture_region.xy * TEXTURE_PIXEL_SIZE, texture_region.zw * TEXTURE_PIXEL_SIZE);

	// If texture region size was not specified, then use entire texture
	uv_region.zw = mix(vec2(1.0), uv_region.zw, ceil(uv_region.zw));

	float uv_offset;
	float a;
	float max_a = 0.0;

	uv_offset = UV.y - outline_offset.y;
	a = step(uv_region.y, uv_offset) * texture(TEXTURE, vec2(UV.x, uv_offset)).a;
	max_a = max(a, max_a);

	uv_offset = UV.y + outline_offset.y;
	a = step(uv_offset, uv_region.y + uv_region.w) * texture(TEXTURE, vec2(UV.x, uv_offset)).a;
	max_a = max(a, max_a);

	uv_offset = UV.x - outline_offset.x;
	a = step(uv_region.x, uv_offset) * texture(TEXTURE, vec2(uv_offset, UV.y)).a;
	max_a = max(a, max_a);

	uv_offset = UV.x + outline_offset.x;
	a = step(uv_offset, uv_region.x + uv_region.z) * texture(TEXTURE, vec2(uv_offset, UV.y)).a;
	max_a = max(a, max_a);

	COLOR = mix(color, new_background, max_a - color.a);
}
