extends Node


const RAY_LENGTH = 1000


func get_plane_position(height: float = 0):
	var plane = Plane(Vector3.UP, height)
	var camera = get_viewport().get_camera()
	
	var mouse_pos = get_viewport().get_mouse_position()
	
	var ray_from = camera.project_ray_origin(mouse_pos)
	var ray_to = ray_from + camera.project_ray_normal(mouse_pos) * RAY_LENGTH
	
	var coor = plane.intersects_ray(ray_from, ray_to)
	if coor == null:
		return
	coor.y = height
	return coor


func get_clicked_object():
	var camera = get_viewport().get_camera()
	var mouse_pos = get_viewport().get_mouse_position()
	
	var ray_from = camera.project_ray_origin(mouse_pos)
	var ray_to = ray_from + camera.project_ray_normal(mouse_pos) * RAY_LENGTH
	
	var space_state = camera.get_world().direct_space_state
	var selection = space_state.intersect_ray(ray_from, ray_to)
	return selection
