shader_type canvas_item;

uniform float range : hint_range(0.0, 0.1, 0.005) = 0.05;
uniform float noiseQuality : hint_range(0.0, 300.0, 0.1) = 250.0;
uniform float noiseIntensity : hint_range(-0.6, 0.6, 0.0010) = 0.0088;
uniform float offsetIntensity : hint_range(-0.1, 0.1, 0.001) = 0.03;
uniform float colorOffsetIntensity : hint_range(0.0, 5.0, 0.001) = 1.3;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture;
uniform float brightnessFactor : hint_range(0.0, 1.0, 0.01) = 0.9;
uniform float grayscaleFactor : hint_range(0.0, 1.0, 0.01) = 1.0; // 0 = color, 1 = full grayscale

float rand(vec2 co)
{
    return fract(sin(dot(co.xy, vec2(12.9898, 78.233))) * 43758.5453);
}

float verticalBar(float pos, float UVY, float offset)
{
    float edge0 = (pos - range);
    float edge1 = (pos + range);

    float x = smoothstep(edge0, pos, UVY) * offset;
    x -= smoothstep(pos, edge1, UVY) * offset;
    return x;
}

void fragment()
{
    vec2 uv = SCREEN_UV;
    for (float i = 0.0; i < 0.71; i += 0.1313)
    {
        float d = mod(TIME * i, 1.7);
        float o = sin(1.0 - tan(TIME * 0.24 * i));
    	o *= offsetIntensity;
        uv.x += verticalBar(d, UV.y, o);
    }

    float UVY = uv.y;
    UVY *= noiseQuality;
    UVY = float(int(UVY)) * (1.0 / noiseQuality);
    float noise = rand(vec2(TIME * 0.00001, UVY));
    uv.x += noise * noiseIntensity;

    vec2 offsetR = vec2(0.009 * sin(TIME), 0.0) * colorOffsetIntensity;
    vec2 offsetG = vec2(0.0073 * (cos(TIME * 0.97)), 0.0) * colorOffsetIntensity;

    float r = texture(SCREEN_TEXTURE, uv + offsetR).r;
    float g = texture(SCREEN_TEXTURE, uv + offsetG).g;
    float b = texture(SCREEN_TEXTURE, uv).b;

    vec3 color = vec3(r, g, b);

    // Convert to grayscale using the luminosity method
    float grayscale = dot(color, vec3(0.299, 0.587, 0.114));

    // Blend between color and grayscale based on grayscaleFactor
    color = mix(color, vec3(grayscale), grayscaleFactor);

    COLOR = vec4(color, 1.0) * brightnessFactor; // Apply brightness adjustment
}
