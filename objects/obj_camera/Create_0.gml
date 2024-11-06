// TODO: Add pixel perfect scaling
view_width = 1920/6;
view_height = 1080/6;

window_scale = 3;

window_set_size(view_width * window_scale, view_height * window_scale);
// This has to happen one step after the size is set.
alarm[0] = 1;

surface_resize(application_surface, view_width * window_scale, view_height * window_scale);