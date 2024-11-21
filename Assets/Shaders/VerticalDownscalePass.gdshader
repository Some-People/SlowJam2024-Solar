shader_type canvas_item;

//uniform sampler2D NoiseTexture;
//uniform sampler2D OutputTexture;
uniform vec2 referenceResolution;
uniform float spread;
//uniform float noisemult;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

float gaussian(float sig, float x)
{
    float sigmaSqu = sig * sig;
    return (1.0 / sqrt((2.0 * PI) * sigmaSqu)) * pow(E, float(-(x * x)) / (2.0 * sigmaSqu));
}

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	
	
	//nearest neighbor: sample the center pixel of the kernel - creates gnarly artifacts when the width and/or height is even
	/*
	vec2 texSpaceCoords = vec2((1.0/SCREEN_PIXEL_SIZE.x)*SCREEN_UV.x, (1.0/SCREEN_PIXEL_SIZE.y)*SCREEN_UV.y);
	vec2 subpixelRes = vec2((1.0/SCREEN_PIXEL_SIZE.x)/referenceResolution.x, (1.0/SCREEN_PIXEL_SIZE.y)/referenceResolution.y);
	vec2 samplerOffset = vec2(
		float( (int(texSpaceCoords.x) % int(subpixelRes.x)) - int((subpixelRes.x - 1.0) / 2.0) ) / (1.0/SCREEN_PIXEL_SIZE.x),
		float( (int(texSpaceCoords.y) % int(subpixelRes.y)) - int((subpixelRes.y - 1.0) / 2.0) ) / (1.0/SCREEN_PIXEL_SIZE.y)
		);
	vec2 sampleCoords = SCREEN_UV - samplerOffset;
	vec4 screenCol = texture(SCREEN_TEXTURE, sampleCoords);
	*/
	
	if (referenceResolution.x == 0.0) {
		COLOR = vec4(0, 1, 0, 1);
	}
	else if (referenceResolution.y == 0.0) {
		COLOR = vec4(1, 0, 0, 1);
	}
	else {
		
		vec2 texSpaceCoords = vec2((1.0/SCREEN_PIXEL_SIZE.x)*SCREEN_UV.x, (1.0/SCREEN_PIXEL_SIZE.y)*SCREEN_UV.y);
		vec2 subpixelRes = vec2((1.0/SCREEN_PIXEL_SIZE.x)/referenceResolution.x, (1.0/SCREEN_PIXEL_SIZE.y)/referenceResolution.y);
		vec2 samplerOffset = vec2(
			float( (int(texSpaceCoords.x) % int(subpixelRes.x)) - int((subpixelRes.x - 1.0) / 2.0) ) / (1.0/SCREEN_PIXEL_SIZE.x),
			float( (int(texSpaceCoords.y) % int(subpixelRes.y)) - int((subpixelRes.y - 1.0) / 2.0) ) / (1.0/SCREEN_PIXEL_SIZE.y)
			);
		
		vec2 subpixelCoords = vec2( float(int(SCREEN_UV.x * (1.0/SCREEN_PIXEL_SIZE.x)) % int(subpixelRes.x)), 
									float(int(SCREEN_UV.y * (1.0/SCREEN_PIXEL_SIZE.y)) % int(subpixelRes.y)) 
									);
		
		vec2 sampleCoords = vec2(0, 0);
		float gaussCoord = 0.0;
		float gaussNorm = 0.0;
		vec4 sumCol = vec4(0, 0, 0, 1);
		
		float offset = float(int((1.0-SCREEN_UV.y) * (1.0/SCREEN_PIXEL_SIZE.y)) % int(subpixelRes.y)) * (SCREEN_PIXEL_SIZE.y);

		for (int i = 0; i < int(subpixelRes.y); i++) {
			sampleCoords = vec2(
			SCREEN_UV.x,
			SCREEN_UV.y - ((SCREEN_PIXEL_SIZE.y) * float(i)) + (offset - (0.5 * (SCREEN_PIXEL_SIZE.y)))
			);
			
			gaussCoord = 
			float(int(SCREEN_UV.y * (1.0/SCREEN_PIXEL_SIZE.y)) % int(subpixelRes.y))
			-
			((0.5 * subpixelRes.y) - 1.0);
			
			gaussNorm += gaussian(spread, gaussCoord);
			sumCol += vec4(texture(SCREEN_TEXTURE, sampleCoords).xyz  * gaussian(spread, gaussCoord), 1);
		}
		
		sumCol /= gaussNorm;
		COLOR = sumCol;
		//COLOR = vec4(sampleCoords, 0, 1);
		//COLOR = screenCol;
	}
		
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
