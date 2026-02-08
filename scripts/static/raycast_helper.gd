class_name RaycastHelper

##Return a raycast collision cast along the normal of a Camera3D
static func raycast_from_camera(camera:Camera3D,collision_mask = 0b0010,exclude:Array[RID] = [],return_full = false):
	var space_state = camera.get_world_3d().direct_space_state
	var screen_resolution = DisplayServer.window_get_size(0)
	
	var ray_origin = camera.global_position
	var ray_end = camera.project_ray_normal(screen_resolution/2.0)*10000
	
	var ray_query = PhysicsRayQueryParameters3D.create(ray_origin,ray_end)
	ray_query.collision_mask = collision_mask
	ray_query.exclude = exclude
	
	var ray_array = space_state.intersect_ray(ray_query)
	if return_full:
		return ray_array
	if ray_array.has('position'):
		return ray_array['position']
	return ray_end
