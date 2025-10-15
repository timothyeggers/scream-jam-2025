shader_type particles;

uniform vec2 cell_size = vec2(48,48);

// Your custom random function
float rand(vec2 seed) {
    return fract(sin(dot(seed.xy, vec2(12.9898, 78.233))) * 43758.5453);
}

void start() {
	float rand_x = (rand(vec2(float(INDEX*uint(2)), 0.0)) * 2.0 - 1.0) * (cell_size.x/2.0);
	float rand_y = (rand(vec2(float(INDEX), 0.0)) * 2.0 - 1.0) * (cell_size.y/2.0);

	TRANSFORM[3].xyz = vec3(rand_x, float(INDEX/uint(1)), 0.0);
}

void process() {
	// Called every frame on existing particles (according to the Fixed FPS property).
}
