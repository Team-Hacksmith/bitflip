shader_type canvas_item;

uniform vec4 lightning_color: source_color;

uniform float size: hint_range(0.,1.);
uniform float width: hint_range(0.,1.);
uniform float thickness: hint_range(0.,1.);
uniform float speed;
uniform float cycle;
uniform float ratio;
uniform float time_shift;
uniform int wave_count = 3; // Number of arcs
uniform float flicker_speed = 2.0; // Higher values = slower flickering

float rand(float x) {
    return fract(sin(x) * 100000.0);
}

void fragment() {
    vec2 rotated_UV = vec2(UV.y, 1.0 - UV.x); // Rotate UV by 90 degrees
    float wave_sum = 0.0;
    float opacity_sum = 0.0; // Accumulate opacity

    for (int i = 0; i < wave_count; i++) {
        float offset = float(i) * 0.3; // Offset each arc slightly

        // Randomized width, thickness, and opacity for each arc
        float wave_width = width * (0.5 + rand(float(i) + TIME) * 0.5);
        float wave_thickness = thickness * (0.5 + rand(float(i) + TIME + 10.0) * 0.5);
        float wave_opacity = 0.5 + rand(float(i) + TIME + 20.0) * 0.8; // Random opacity (0.5 to 1.0)

        float bolt = abs(mod(rotated_UV.y * cycle + (rand(TIME + offset) + time_shift) * speed * -1., 0.5) - 0.25) - 0.125;
        bolt *= 4. * wave_width; // Apply randomized width
        bolt *= (0.5 - abs(rotated_UV.y - 0.5)) * 2.; 

        float wave = abs(rotated_UV.x - 0.5 + bolt);
        wave = 1. - step(size * wave_thickness, wave); // Apply randomized thickness

        float blink = step(rand(TIME / flicker_speed + offset) * ratio, 0.5); // Slower flicker
        wave *= blink;
        wave *= wave_opacity; // Apply random opacity

        wave_sum += wave; // Accumulate multiple waves
        opacity_sum += wave_opacity; // Accumulate opacity for normalization
    }

    wave_sum = clamp(wave_sum, 0.0, 1.0); // Ensure valid range
    float final_opacity = clamp(opacity_sum / float(wave_count), 0.3, 1.0); // Normalize opacity

    vec4 display = lightning_color * vec4(wave_sum) * final_opacity; // Apply opacity
    COLOR = display;
}
