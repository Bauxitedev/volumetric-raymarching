extends Node

var division = 0
var last_mouse_pos = Vector2()

func closest_point(p, v, w):
	
	# unused for now
	
	return Geometry.get_closest_point_to_segment_2d(p, v, w)

	# https://stackoverflow.com/questions/849211/shortest-distance-between-a-point-and-a-line-segment
	
	var l2 = v.distance_squared_to(w)
	if l2 == 0.0:
		return p.distance_to(v)

	var t = max(0, min(1, (p - v).dot(w - v) / l2))
	var projection = v + t * (w - v)
	#var d = p.distance_to(projection)
	return projection


func unreset():
	yield(get_tree(), "idle_frame")
	$vp/reset.hide()
	
func _process(delta):
	
	division += 1
	
	var mat = $vp/spr.material
	
	var mouse_pos = get_viewport().get_mouse_position() / 1024.0
	if last_mouse_pos != mouse_pos:
		division = 1
		$vp/reset.show()
		call_deferred("unreset")
	last_mouse_pos = mouse_pos
	mat.set_shader_param("mouse_pos", mouse_pos)
	
	$rect.material.set_shader_param("division", division)
	
	
	