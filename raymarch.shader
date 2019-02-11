shader_type canvas_item;
render_mode blend_add;

uniform vec2 mouse_pos;
uniform float sphereRadius = 100.0;
uniform int iteration_count = 1;
uniform int raymarch_iterations = 50;
uniform float step_size = 0.03;
uniform float scatter_amount = 0.99;


float rand(vec2 co)
{
    return fract(sin(dot(co ,vec2(12.9898,78.233))) * 43758.5453);
}

float sdf(sampler2D tex, vec2 p)
{
	int texSize = textureSize(tex, 0).x;
	float v = texture(tex, p).r; //pixel space
	return v;
}

vec3 raymarch(sampler2D tex, vec2 start, vec2 end)
{
	//position is in uv space (0...1)
	vec2 current_pos = start; //distance along the ray
	
	vec2 direction = normalize(end-start)*1.0;
	
	vec3 current_col = vec3(1.0);
	for (int i = 0; i < raymarch_iterations; i++)
	{
		
		bool outside_bounds = current_pos.x < 0.0 || current_pos.x > 1.0 || current_pos.y < 0.0 || current_pos.y > 1.0; 
		bool hit_sphere = dot((current_pos-mouse_pos),current_pos-mouse_pos) < 0.07*0.07;
		
		if (outside_bounds || hit_sphere)
		{
			return outside_bounds ? current_col * vec3(0.2,0.4,0.8) : current_col * vec3(3,2,1);
		}
			
		float val = sdf(tex, current_pos);
		
		if (rand(current_pos) < smoothstep(0.5, 0.6, val))
		{
			//scramble movement direction
			vec2 rand_offset = vec2(rand(current_pos+vec2(1,2)), rand(current_pos+vec2(2,1))) * 2.0 - 1.0;
			rand_offset *= scatter_amount;
			direction = normalize(direction + rand_offset);
		}	


		current_pos += step_size * direction;
		current_col *= (1.0-smoothstep(0.9, 0.999, val));

	}
	
	return vec3(0.0);
}

void fragment()
{
	float PI = 3.14159265359;
	
	int counter = 0;
	vec3 result = vec3(0.0);
	
	for (int i = 0; i < iteration_count; i++)
	{
		float angle = rand(UV*511.0 + vec2(float(i)*13.37,TIME)) * PI * 2.0;
		vec2 end = UV + vec2(sin(angle), cos(angle));
		
		vec3 res = raymarch(TEXTURE, UV, end);	
		result += res;
		counter++;
	}
	
	result /= float(counter);
	
	COLOR = vec4(result, 1.0);
	
}