shader_type canvas_item;

uniform float division;

void fragment()
{
	COLOR.rgb = texture(TEXTURE, UV).rgb / division;
	COLOR.a = 1.0;
}