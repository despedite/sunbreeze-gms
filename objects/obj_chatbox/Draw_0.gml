accept_key = keyboard_check_pressed(ord("E"));

textbox_x = camera_get_view_x(view_camera[0]) + (camera_get_view_width(view_camera[0]) / 2);
textbox_y = camera_get_view_y(view_camera[0]) + (camera_get_view_height(view_camera[0]) - 48);

// Legacy for old code

txtb_spr_w = sprite_get_width(txtb_spr[page]);
txtb_spr_h = sprite_get_height(txtb_spr[page]);

textbox_upleft_x = textbox_x - (textbox_width / 2);
textbox_upleft_y = textbox_y - (textbox_height / 2);

global.is_chatting = true;

// ---- SETUP ----
// Variables for the following code to use.

if setup == false {
	
	setup = true;
	
	draw_set_font(global.font_main);
	draw_set_valign(fa_top);
	draw_set_halign(fa_left);
	
	// Loop through the pages
	for (var p = 0; p < page_number; p++) {
		
		// Find how many characters are in each page
		// and store that number in the "text_length" array
		text_length[p] = string_length(text[p]);
		
		// Character on the left
		if speaker_side[p] == 1 {
			portrait_x_offset[p] = 50;
		}
		
		// Character on the middle
		if speaker_side[p] == 0 {
			portrait_x_offset[p] = 44;
		}
		
		// Character on the right
		if speaker_side[p] == -1 {
			portrait_x_offset[p] = 98;
		}
		
		// Get X position for textbox
		text_x_offset[p] = -14;
		
		// NOTE: This is all mega big brain stuff I don't quite understand yet.
		// Modify with caution!
		// Setting individual characters and finding where the lines of text should break
		for (var c = 0; c < text_length[p]; c++) {
			
			var _char_pos = c + 1; // String arrays start at one
			
			// Store individual characters in the "char" array
			char[c, p] = string_char_at(text[p], _char_pos);
			
			// Get current width of the line
			var _txt_up_to_char = string_copy(text[p], 1, _char_pos);
			var _current_txt_w = string_width(_txt_up_to_char) - string_width(char[c, p]);
			
			// Get the last free space
			if (char[c, p] == " ") {
				last_free_space = _char_pos + 1;
			}
			
			// Get the line breaks
			if _current_txt_w - line_break_offset[p] > line_width {
				line_break_pos[line_break_num[p], p] = last_free_space;
				line_break_num[p]++;
				var _txt_up_to_last_space = string_copy(text[p], 1, last_free_space);
				var _last_free_space_string = string_char_at(text[p], last_free_space);
				line_break_offset[p] = string_width(_txt_up_to_last_space) - string_width(_last_free_space_string);
			}
		}
		
		// Getting each characters' coordinates
		for (var c = 0; c < text_length[p]; c++) {
			
			var _char_pos = c + 1;
			
			// Probably wrong?
			var _txt_x = textbox_upleft_x + text_x_offset[p] + border * 2;
			var _txt_y = textbox_upleft_y + border;
			
			// Get current width of the line
			var _txt_up_to_char = string_copy(text[p], 1, _char_pos);
			var _current_txt_w = string_width(_txt_up_to_char) - string_width(char[c, p]);
			var _txt_line = 0;
			
			// Compensate for string breaks
			for (var lb = 0; lb < line_break_num[p]; lb++) {
				// If the current looping character is after a line break
				if (_char_pos >= line_break_pos[lb, p]) {
					var _str_copy = string_copy(text[p], line_break_pos[lb, p], _char_pos - line_break_pos[lb, p]);
					_current_txt_w = string_width(_str_copy);
					
					// Record the "line" this character should be on
					_txt_line = lb+1; // +1 since lb starts at 0
				}
			}
			
			// Add to the X and Y coordinates based on the new info
			char_x[c, p] = _txt_x + _current_txt_w;
			char_y[c, p] = _txt_y + _txt_line * line_sep;
		}
	}
}

// ---- FUNCTIONS ----
// These are used because transitions require me to draw the same components
// in slightly different ways (eg. fades, size changes, so on and so forth.)
// It also makes the code way prettier!

/// @param background_sprite
/// @param alpha
/// @param delay
function drawBackground(_background_sprite, _alpha, _delay) {
	var _bg_w = sprite_get_width(_background_sprite);
	var _bg_h = sprite_get_height(_background_sprite);
	var _v_w = camera_get_view_width(view_camera[0]) + _bg_w;
	var _v_h = camera_get_view_height(view_camera[0]) + _bg_h;
	var _v_x = camera_get_view_x(view_camera[0])
	var _v_y = camera_get_view_y(view_camera[0])
	show_debug_message(_v_x)
	show_debug_message(_v_y)
	
	for (var _bg_x = _v_x; _bg_x < _v_w + _v_x; _bg_x++) {
		for (var _bg_y = _v_y; _bg_y < _v_h + _v_y; _bg_y++) {
			draw_sprite_ext(_background_sprite, 0, _bg_x - background_offset, _bg_y - background_offset, 1, 1, 0, c_white, _alpha);
			_bg_y += _bg_h - 1;
		}
		_bg_x += _bg_w - 1;
	}
	
	// Assumes background width and height are the same.
	// Currently can't be arsed to do it "properly".
	if (background_delay == 0) {
		background_delay = _delay;
		if (background_offset != _bg_w) {
			background_offset++;
		} else {
			background_offset = 0;
		}
	} else {
		background_delay--;
	}
}

/// @param character_sprite
/// @param name
/// @param x
/// @param y
/// @param alpha
function drawCharacterPortrait(_character_sprite, _name, _x, _y, _alpha) {
	sprite_index = _character_sprite;
	
	// When they're done talking, reset animation to first frame
	if draw_char == text_length[page] || (draw_char == "." || draw_char == "?" || draw_char == "!" || draw_char == ",") {
		image_index = 0;
	}
	
	draw_sprite_ext(sprite_index, image_index, _x, _y, 1, 1, 0, c_white, _alpha);
	
	// Set this for the next frame.
	old_speaker_name = _name;
}

/// @param namebox_sprite
/// @param namebox_color
/// @param name
/// @param name_color
/// @param x
/// @param y
/// @param box_width
/// @param box_height
/// @param alpha
function drawNameBox(_namebox_sprite, _namebox_color, _name, _name_color, _x, _y, _box_width, _box_height, _alpha) {
	var _nmeb_spr_w = sprite_get_width(_namebox_sprite);
	var _nmeb_spr_h = sprite_get_height(_namebox_sprite);
	var _name_str_w = string_width(_name) + name_spacing * 2

	if _name != noone {
		// Draw the namebox bubble
		draw_sprite_ext(_namebox_sprite, txtb_img, _x, _y, _name_str_w / _nmeb_spr_w, nmeb_height / _nmeb_spr_h, 0, _namebox_color, _alpha);

		// Draw the namebox's text
		draw_set_halign(fa_center);
		draw_text_ext_color(textbox_upleft_x + 42, textbox_upleft_y - 6, _name, line_sep, line_width, _name_color, _name_color, _name_color, _name_color, _alpha);
		draw_set_halign(fa_left);
	}	
}

// ---- ACTING CODE ----
// Here's where the magic happens.

// ---------- Creating the background ----------

if background_spr[page] {
	// Determine whether to fade from one background to another or not
	if (page != 0) {
		if (background_spr[page] != background_spr[page - 1]) {
			if fade_background_timer > 0 {
				fade_background_timer--;
			} else {
				if (fade_one_time_check == true) {
					fade_background_timer = 16;
					fade_one_time_check = false;
				}
			}
		}
	}
	
	// TODO: Woah man, you know what you could use here?
	// A switch statement. Ever heard of that? Fuckin' Yanderedev lookin' ass
	if (fade_background_timer > 9 && fade_background_timer != 0) {
		// Fade out old background
		var _alpha_offset = (ease_in_sine(fade_background_timer - 8, background_alpha, -1, 8))
		drawBackground(background_spr[page - 1],_alpha_offset * -1, 5)
	} else if (fade_background_timer != 0) {
		// Fade in new background
		var _alpha_offset = (ease_in_sine(fade_background_timer - 9, 0, background_alpha, 9))
		drawBackground(background_spr[page], _alpha_offset, 5)
	} else if (typing_timer <= 12 ) {
		// Draw the background as usual
		drawBackground(background_spr[page], background_alpha, 5)
	} else if (typing_timer < 20) {
		// Ease in the background
		var _alpha_offset = (ease_in_sine(typing_timer - 14, 0, 1, 8))
		drawBackground(background_spr[page], background_alpha - _alpha_offset, 5)
	}
}

// ---------- Typing the text ----------

if typing_timer <= 12 {
	if text_pause_timer <= 0 {
		if (draw_char < text_length[page]) { // If not the final character
			draw_char += text_spd;
			draw_char = clamp(draw_char, 0, text_length[page]); // draw_char can't be higher than these values
			var _check_char = string_char_at(text[page], draw_char);
			if _check_char == "?" || _check_char == "!" || _check_char == "," {  //inefficient lol
				text_pause_timer = text_pause_time;	
				if !audio_is_playing(snd[page]) && _check_char == "." {
					// Punctuation sound (bebebese)
				}
			} else {
				// Typing sound
				if snd_count < snd_delay {
					snd_count ++	
				} else {
					if _check_char == "." {
						snd_count = 0;
						audio_play_sound(animalese_beep, 8, false);
					} else if (snd[page] != noone) {
						snd_count = 0;
						audio_play_sound(snd[page], 8, false);
					} else if (asset_get_index("animalese_" + string_lower(_check_char))) {
						snd_count = 0;
						var _animalese_file = asset_get_index("animalese_" + string_lower(_check_char));
						audio_sound_pitch(_animalese_file, snd_pitch_multiplier[page]);
						audio_play_sound(_animalese_file, 8, false);
					}
				}
			}
		}
	} else {
		text_pause_timer--;	
	}
}

// ---------- Flip through pages ----------
if (accept_key) {
	
	// If the typing is done
	if (draw_char == text_length[page]) {
		
		// Go to the next page
		if (page < page_number - 1) {
			global.last_message_was_option = false;
			page++;
			draw_char = 0;
			fade_one_time_check = true;
		} else {
			// Link text for options
			if option_number > 0 {
				create_textbox(option_link_id[option_pos]);	
			}
			
			// Destroy textbox
			global.is_chatting = false;
			instance_destroy();	
		}
	} else {
		
		// Fill out (skip) text
		draw_char = text_length[page];
		
	}
	
}

// ---------- Draw the window ----------
var _txtb_x = textbox_upleft_x;
var _txtb_y = textbox_upleft_y;

txtb_img += txtb_img_spd;

txtb_spr_w = sprite_get_width(txtb_spr[page]);
txtb_spr_h = sprite_get_height(txtb_spr[page]);

// Draw the speaker
if speaker_sprite[page] != noone {
	if typing_timer <= 0 {
		var _speaker_x = textbox_upleft_x + portrait_x_offset[page] - 10;
		if speaker_side[page] == -1 {
			_speaker_x += sprite_width;
		}
		drawCharacterPortrait(speaker_sprite[page], name_string[page], _speaker_x, textbox_upleft_y + 9, 1)
	} else {
		var _speaker_x = textbox_x + portrait_x_offset[page] - 36;
		var _x_offset = (ease_in_sine(typing_timer, _speaker_x, 15, 24));
		var _alpha_offset = (ease_in_sine(typing_timer, 0, 1, 24));
		
		drawCharacterPortrait(speaker_sprite[page], name_string[page], _x_offset, textbox_upleft_y + 9, 1 - _alpha_offset)
	}
}

if (typing_timer <= 12) {
	// Draw the text bubble
	draw_sprite_ext(txtb_spr[page], txtb_img, textbox_x, textbox_y, textbox_width / txtb_spr_w, textbox_height / txtb_spr_h, 0, c_white, 1);
} else if (typing_timer >= 18) {
	// Part 1: Small to big sprite
	var _t_timer = typing_timer - 18
	
	var _stretchh = (ease_in_sine(_t_timer, textbox_width + 10, -20, 6));
	var _stretchv = (ease_in_sine(_t_timer, textbox_height + 5, -10, 6));
	
	draw_sprite_ext(txtb_spr[page], txtb_img, textbox_x, textbox_y, _stretchh / txtb_spr_w, _stretchv / txtb_spr_h, 0, c_white, 1);
} else if (typing_timer < 18) {
	// Part 2: Overshooting the target
	var _stretchh = (ease_out_back(typing_timer - 12, textbox_width, 10, 6));
	var _stretchv = (ease_out_back(typing_timer - 12, textbox_height, 5, 6));
	
	draw_sprite_ext(txtb_spr[page], txtb_img, textbox_x, textbox_y, _stretchh / txtb_spr_w, _stretchv / txtb_spr_h, 0, c_white, 1);
}

// Simple sine-like movement
float_number += 4;
var _float_arrow = dsin(float_number);

// Draw the "next dialogue" arrow
if draw_char == text_length[page] && page != page_number - 1 {
	draw_sprite(spr_continue_arrow, 0, _txtb_x + (textbox_width / 2), (textbox_height + _txtb_y) - 5 + _float_arrow);
}

// ---------- Options ----------
if draw_char == text_length[page] && page == page_number - 1 {

	global.last_message_was_option = true;
	
	// Option selection
	option_pos += keyboard_check_pressed(ord("S")) - keyboard_check_pressed(ord("W"));
	option_pos = clamp(option_pos, 0, option_number - 1);
	
	// Draw the options
	var _op_space = 15;
	var _op_bord = 5;
	var _op_box_bord = 10;
	
	var _opt_spr = spr_optionbox;
	var _opt_width = 150;
	var _opt_height = 40;
	
	// Draw the option bubble
	var _longest_op_width = 0;
	var _longest_op_height = 0;
	
	// Get the longest element in an array
	for (var op2 = 0; op2 < array_length(option); op2++) {
		if (string_width(option[op2]) > _longest_op_width) {
			_longest_op_width = string_width(option[op2]);
		}
		if (string_height(option[op2]) > _longest_op_height) {
			_longest_op_height = string_height(option[op2]);
		}
	}

	var _opt_width = _longest_op_width + _op_box_bord*2;
	var _opt_height = array_length(option) * _longest_op_height + _op_bord*2 + _op_box_bord*2;
		
	var _opt_spr_w = sprite_get_width(_opt_spr);
	var _opt_spr_h = sprite_get_height(_opt_spr);
	
	if option_number > 0 {
		draw_sprite_ext(_opt_spr, txtb_img, option_x, _txtb_y + 16, _opt_width / _opt_spr_w, _opt_height / _opt_spr_h, 0, c_white, 1)
	}

	for (var op = 0; op < option_number; op++) {
		
		var _o_w = string_width(option[op]) + _op_bord*2;
		var _opt_spr_w = sprite_get_width(spr_selectbox);
		
		// Draw the selected box, arrow
		if option_pos == op {
			draw_sprite_ext(spr_selectbox, txtb_img, (option_x - _opt_width) + _op_box_bord - 5, _txtb_y - _op_space * option_number + _op_space * op + 5, _o_w / _opt_spr_w, 1, 0, c_white, 1);
			draw_sprite(spr_chatbox_point, 0, (option_x - _opt_width - _float_arrow) - 16, _txtb_y - _op_space * option_number + _op_space * op)	
		}	
		
		// Draw the option's text
		draw_text((option_x - _opt_width) + _op_box_bord,  _txtb_y - _op_space * option_number + _op_space * op + 2, option[op]);	
	}
}

// Name box
name_str_w = string_width(name_string[page]) + name_spacing * 2
nmeb_spr_w = sprite_get_width(name_textbox_color[page]);
nmeb_spr_h = sprite_get_height(name_textbox_color[page]);

if name_string[page] != noone {
	if (typing_timer <= 17) {
		drawNameBox(spr_namebox, name_textbox_color[page], name_string[page], name_color[page], textbox_upleft_x + 40, textbox_upleft_y, name_str_w / nmeb_spr_w, nmeb_height / nmeb_spr_h, 1)
	} else if (typing_timer < 22) {
		// Fade in
		var _alpha_offset = (ease_in_sine(typing_timer - 17, 0, 1, 7));
		drawNameBox(spr_namebox, name_textbox_color[page], name_string[page], name_color[page], textbox_upleft_x + 40, textbox_upleft_y, name_str_w / nmeb_spr_w, nmeb_height / nmeb_spr_h, 1 - _alpha_offset)
	}
}

// Draw the actual text
// String "arrays" start at 1. Stupid, I know

if (typing_timer <= 12) {
	for (var c = 0; c < draw_char; c++) {
	
		// -------- Special stuff! --------
		// Wavy text
		var _float_y = 0;
		if float_text[c, page] == true {
			float_dir[c, page] += -6;
			_float_y = dsin(float_dir[c, page]) // Returns between a positive and negative one based on a circle's rotation
		}
		// Shake text
		var _shake_x = 0;
		var _shake_y = 0;
		if shake_text[c, page] == true {
			shake_timer[c, page]--;
			if shake_timer[c, page] <= 0 {
				shake_timer[c, page] = irandom_range(4, 8);
				shake_dir[c, page] = irandom(360);
			}
			if shake_timer[c, page] <= 2 {
				_shake_x = lengthdir_x(1, shake_dir[c, page]);
				_shake_y = lengthdir_y(1, shake_dir[c, page]);
			}
		}
		// Draw text
		draw_text_color(char_x[c, page] + _shake_x, char_y[c, page] + _float_y + _shake_y, char[c, page], col_1[c, page], col_2[c, page], col_3[c, page], col_4[c, page], 1);
	}
}

if (typing_timer != 0) {
	//room_speed = 3;
	typing_timer--;
}
/*
else {
	room_speed = 60;
}
*/