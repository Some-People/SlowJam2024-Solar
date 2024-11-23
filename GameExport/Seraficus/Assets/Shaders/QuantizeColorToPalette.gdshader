shader_type canvas_item;

uniform sampler2D palette;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

float calculateColDistance(vec4 sampledCol, vec4 comparisonCol) {
	vec3 sampledColRGB = vec3(255.0 * sampledCol.x, 255.0 * sampledCol.y, 255.0 * sampledCol.z);
	vec3 comparisonColRGB = vec3(255.0 * comparisonCol.x, 255.0 * comparisonCol.y, 255.0 * comparisonCol.z);
	
	float rMean = (sampledColRGB.x + comparisonColRGB.x) / 2.0;
	
	float deltaR = sampledColRGB.x - comparisonColRGB.x;
	float deltaG = sampledColRGB.y - comparisonColRGB.y;
	float deltaB = sampledColRGB.z - comparisonColRGB.z;
	
	return sqrt(
    (2.0 + (rMean / 256.0))
    * pow(deltaR, 2)
    + (4.0 * pow(deltaG, 2))
    + (2.0 + ((255.0 - rMean) / 256.0))
    * pow(deltaB, 2));
	
}

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	
	vec4 screen = texture(SCREEN_TEXTURE, SCREEN_UV);
	vec4 errorCol = vec4(float(int((1.0/SCREEN_PIXEL_SIZE.y) * UV.y) % 3 ), 0, float(int((1.0/SCREEN_PIXEL_SIZE.x) * UV.x) % 2 ), 1);
	
	float currentColDistance = 0.0;
	float smallestColDistance = 10000000000.0;
	vec4 quantizedCol = errorCol;
	vec4 paletteCol = errorCol;
	
	for (int i = 0; i < textureSize(palette, 0).x; i++) {
		// when i = 0 and 1, the same color is returned? temp solution, start i at 1 to avoid redundant pass
		paletteCol = vec4(texture(palette, vec2((float(i) + 0.5)/float(textureSize(palette, 0).x), 0.0)).xyz, 1);
		
		currentColDistance = calculateColDistance(screen, paletteCol); 
		if (currentColDistance < smallestColDistance) {
			smallestColDistance = currentColDistance;
			quantizedCol = paletteCol;
		}
	}

	COLOR = quantizedCol;
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
