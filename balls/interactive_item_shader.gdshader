// https://www.reddit.com/r/godot/comments/n8vxw3/how_to_create_a_shader_that_mimics_canvas_modulate/
// https://github.com/godotengine/godot-proposals/issues/6870

shader_type canvas_item;
instance uniform vec4 modulate : source_color = vec4(1.0, .1, .1, 1.0);
instance uniform vec4 new_background : source_color = vec4(1.0, 1.0, .1, 1.0);
const vec4 BACKGROUND = vec4(1,1,1,1);
const float EPSILON = 0.001;

void fragment()
{
	vec4 curr_pixel_color  = texture(TEXTURE, UV);
	if (curr_pixel_color.a < 1.0 && curr_pixel_color.a > 0.1) { // edge of sprite
		COLOR = new_background;
	} else if (length(curr_pixel_color - BACKGROUND) < EPSILON) { // near target color
		COLOR = new_background; // still change alpha because one of the border colors is transparent
		// Body of items should have no alpha issues, so maintaining it for edge cases
	} else { COLOR.rgb = (curr_pixel_color  * modulate).rgb;}
}
