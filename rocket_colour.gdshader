shader_type canvas_item;

uniform vec4 transparent_color = vec4(0.01, 0.545, 0.855, 1.0); // Color #028bda in normalized RGBA
uniform float tolerance : hint_range(0.0, 1.0) = 0.1; // Tolerance for transparency matching

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	
    vec4 tex_color = texture(TEXTURE, UV);
    
    // If the current pixel is close to the transparent color, discard it
    if (distance(tex_color.rgb, transparent_color.rgb) < tolerance) {
        discard;
    }
    
    COLOR = tex_color;
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
