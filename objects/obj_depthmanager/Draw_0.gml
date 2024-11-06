// Report here for any problems: https://www.youtube.com/watch?v=8QCgN2RDA9I

// Resize grid
var dgrid = ds_depthgrid;
var inst_num = instance_number(par_entity)
ds_grid_resize(dgrid, 2, inst_num)

// Every instance of par_entity (its children) will run the code below
var yy = 0; with (par_entity) {
	dgrid[# 0, yy] = id;
	dgrid[# 1, yy] = y;
	yy++;
}

// Sort grid in ascending order
ds_grid_sort(dgrid, 1, true)

// Loop through the grid and draw all the instances
var inst;
yy = 0; repeat(inst_num) {
	// Pull out an ID
	inst = dgrid[# 0, yy];
	// Get instance to draw itself
	with (inst) {
		event_perform(ev_draw, 0);
	}
	
	yy++;
}