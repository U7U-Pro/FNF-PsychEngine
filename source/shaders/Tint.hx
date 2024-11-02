package shaders;

import flixel.system.FlxAssets.FlxShader;

class Tint extends FlxShader{

        // Add any uniform variables that are initialized for access. (These are examples on how to use)
    public var hue(default, set):Float = 0;
    public var saturation(default, set):Float = 0;
    public var brightness(default, set):Float = 0;

    private function set_hue(value:Float) {
        hue = value;
        this.iTime.value[0] = hue;
        return hue;
    }

    private function set_saturation(value:Float) {
        saturation = value;
        this.iTime.value[1] = saturation;
        return saturation;
    }

    private function set_brightness(value:Float) {
        brightness = value;
        this.iTime.value[2] = brightness;
        return brightness;
    }

        // Shader code in ''
    @:glFragmentSource('#pragma header

#define round(a) floor(a + 0.5)
#define iResolution vec3(openfl_TextureSize, 0.)
uniform float iTime;
#define iChannel0 bitmap
uniform sampler2D iChannel1;
uniform sampler2D iChannel2;
uniform sampler2D iChannel3;
#define texture flixel_texture2D

// third argument fix
vec4 flixel_texture2D(sampler2D bitmap, vec2 coord, float bias) {
	vec4 color = texture2D(bitmap, coord, bias);
	if (!hasTransform)
	{
		return color;
	}
	if (color.a == 0.0)
	{
		return vec4(0.0, 0.0, 0.0, 0.0);
	}
	if (!hasColorTransform)
	{
		return color * openfl_Alphav;
	}
	color = vec4(color.rgb / color.a, color.a);
	mat4 colorMultiplier = mat4(0);
	colorMultiplier[0][0] = openfl_ColorMultiplierv.x;
	colorMultiplier[1][1] = openfl_ColorMultiplierv.y;
	colorMultiplier[2][2] = openfl_ColorMultiplierv.z;
	colorMultiplier[3][3] = openfl_ColorMultiplierv.w;
	color = clamp(openfl_ColorOffsetv + (color * colorMultiplier), 0.0, 1.0);
	if (color.a > 0.0)
	{
		return vec4(color.rgb * color.a * openfl_Alphav, color.a * openfl_Alphav);
	}
	return vec4(0.0, 0.0, 0.0, 0.0);
}

// variables which is empty, they need just to avoid crashing shader
uniform float iTimeDelta;
uniform float iFrameRate;
uniform int iFrame;
#define iChannelTime float[4](iTime, 0., 0., 0.)
#define iChannelResolution vec3[4](iResolution, vec3(0.), vec3(0.), vec3(0.))
uniform vec4 iMouse;
uniform vec4 iDate;

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = fragCoord/iResolution.xy;
    vec4 tex0 = texture(iChannel0, uv);
    
    float H = iMouse.x/iResolution.x * 3.0; // Hue shift        0-3
    float S = iMouse.y/iResolution.y;       // Saturation scale 0-1
    float V = 1.0;                          // Value scale      0-1
    
    // 2 or 3 components of hue_term can be calculated on the CPU if prefered to remove the min/abs/sub here
    vec3 hue_term = 1.0 - min(abs(vec3(H) - vec3(0,2.0,1.0)), 1.0);
    hue_term.x = 1.0 - dot(hue_term.yz, vec2(1));
    vec3 res = vec3(dot(tex0.xyz, hue_term.xyz), dot(tex0.xyz, hue_term.zxy), dot(tex0.xyz, hue_term.yzx));
    res = mix(vec3(dot(res, vec3(0.2, 0.5, 0.3))), res, S);
    res = res * V;
    fragColor = vec4(res, texture(iChannel0, uv).a);
}

void main() {
	mainImage(gl_FragColor, openfl_TextureCoordv*openfl_TextureSize);
}')
    public function new()
    {
            
        super();
                // Initialize any uniform variables shown in the shader fragment code.
        this.iTime.value = [0, 0, 0];
    }
}

