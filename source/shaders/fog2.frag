precision highp float;

float rand (vec2 coords)
{
	return fract(sin(dot(coords, vec2(56.3456,78.3456)) * 5.0f) * 10000.0f);
}

float noise (vec2 coords)
{
	vec2 i = floor(coords);
	vec2 f = fract(coords);

	float a = rand(i);
	float b = rand(i + vec2(1.0f, 0.0f));
	float c = rand(i + vec2(0.0f, 1.0f));
	float d = rand(i + vec2(1.0f, 1.0f));

	vec2 cubic = f * f * (3.0f - 2.0f * f);

	return mix(a, b, cubic.x) + (c - a) * cubic.y * (1.0f - cubic.x) + (d - b) * cubic.x * cubic.y;
}

float fbm (vec2 coords)
{
	float value = 0.0f;
	float scale = 0.5f;

	for (int i = 0; i < 5; i++)
	{
		value += noise(coords) * scale;
		coords *= 4.0f;
		scale *= 0.5f;
	}

	return value;
}

float value (vec2 uv)
{
    float Pixels = 4096.0;
    float dx = 5.0 * (1.0 / Pixels);
    float dy = 5.0 * (1.0 / Pixels);
  

    float final = 0.0f;
    
    vec2 uvc = uv;
    
    vec2 Coord = vec2(dx * floor(uvc.x / dx),
                          dy * floor(uvc.y / dy));

    
    for (int i =0;i < 3; i++)
    {
        vec2 motion = vec2(fbm(Coord + iTime * 0.05f + vec2(i)));
        final += fbm(Coord + motion + vec2(i));
    }

	return final / 3.0f;
}

void mainImage ( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = fragCoord.xy / iResolution.y * 2.0f;
    
	fragColor = vec4(mix(vec3(-0.3f), vec3(0.45, 0.4f, 0.6f) + vec3(0.6f), value(uv)), 1);
}