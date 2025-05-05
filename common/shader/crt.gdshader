shader_type canvas_item;
render_mode blend_mix;

// CRT Effect Parameters
uniform float curvature : hint_range(0.0, 0.1) = 0.02;
uniform float scanline_opacity : hint_range(0.0, 1.0) = 0.3;
uniform float vignette_opacity : hint_range(0.0, 1.0) = 0.5;
uniform float chromatic_aberration : hint_range(0.0, 0.01) = 0.002;
uniform vec2 bend_center = vec2(0.5, 0.5);
uniform float scanline_count : hint_range(100.0, 1000.0) = 600.0;
uniform float alpha : hint_range(0.0, 1.0) = 0.5; // Transparency control

void fragment() {
    // Normalized coordinates centered around bend_center
    vec2 uv = (UV - bend_center) * 2.0;
    
    // Calculate distance from center
    float distance_from_center = length(uv);
    
    // Apply curvature distortion
    vec2 distorted_uv = uv * (1.0 + curvature * distance_from_center * distance_from_center);
    distorted_uv = distorted_uv / 2.0 + bend_center;
    
    // Chromatic aberration (color separation)
    vec3 color;
    color.r = texture(TEXTURE, distorted_uv + vec2(chromatic_aberration, 0.0)).r;
    color.g = texture(TEXTURE, distorted_uv).g;
    color.b = texture(TEXTURE, distorted_uv - vec2(chromatic_aberration, 0.0)).b;
    
    // Scanlines effect
    float scanline = sin(UV.y * scanline_count) * 0.5 + 0.5;
    color *= mix(1.0, scanline, scanline_opacity);
    
    // Vignette effect
    float vignette = 1.0 - distance_from_center * vignette_opacity;
    color *= vignette;
    
    // Output final color with transparency
    COLOR = vec4(color, alpha);
}