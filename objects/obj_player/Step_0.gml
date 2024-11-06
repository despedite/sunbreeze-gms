/// @description Walking code!
// You can write your code in this editor

#region MOVEMENT

// TO-DO: Add support for UDLR
up = keyboard_check(ord("W"));
down = keyboard_check(ord("S"));
left = keyboard_check(ord("A"));
right = keyboard_check(ord("D"));
run = keyboard_check(vk_shift);


if (run) {
	stepSpeed = 3;
} else {
	stepSpeed = 2;
}


hMove = (right - left) * stepSpeed;
vMove = (down - up) * stepSpeed;

if (up)
	sprite_index = spr_player_walk_up;
if (down)
	sprite_index = spr_player_walk_down;
if (left)
	sprite_index = spr_player_walk_left;
if (right)
	sprite_index = spr_player_walk_right;
	
if (hMove != 0 or vMove != 0)
	image_speed = stepSpeed / 2;
else {
	image_speed = 0;
	image_index = 0;
}

/*
TODO:

Hey, the collision logic here is a bit wrong.

The order currently looks like this:
1. Check collision along x
2. Check collision along y
3. Move along x
4. Move along y

This can result in getting stuck when moving diagonally.

Correct order should be:

1. Check collision along x

2. Move along x


3. Check collision along y

4. Move along y
*/

// Horizontal collisions
if(place_meeting(x + hMove, y, obj_collision)) {
	while (!place_meeting(x + sign(hMove), y, obj_collision))
		x += sign(hMove);	
	hMove = 0;
	if (vMove == 0) {
		image_speed = 0;
		image_index = 0;
	}
}

// Vertical collisions
if(place_meeting(x, y + vMove, obj_collision)) {
	while (!place_meeting(x, y + sign(vMove), obj_collision))
		y += sign(vMove);	
	vMove = 0;
	if (hMove == 0) {
		image_speed = 0;
		image_index = 0;
	}
}

x += hMove;
y += vMove;
#endregion