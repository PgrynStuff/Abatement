shader_type canvas_item;

uniform float min_opacity : hint_range(0.0, 1.0) = 0.3;
uniform float max_opacity : hint_range(0.0, 1.0) = 0.8;
uniform float speed : hint_range(0.1, 10.0) = 1.0;

float random(float x) {
    return fract(sin(x * 12.9898) * 43758.5453);
}

void fragment() {
    COLOR = texture(TEXTURE, UV);

    float time_value = TIME * speed;

    float noise = random(UV.x * 100.0 + UV.y * 100.0 + time_value);

    float opacity = mix(min_opacity, max_opacity, noise);
    COLOR.a *= opacity;
	COLOR.r = 0.7;
	COLOR.g = 0.7;
	COLOR.b = 0.7;
}
