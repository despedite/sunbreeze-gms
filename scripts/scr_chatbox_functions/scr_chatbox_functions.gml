function scr_set_defaults_for_text() {
	line_break_pos[0, page_number] = 999; // Stores where in the text should the text move to the next line
	line_break_num[page_number] = 0;
	line_break_offset[page_number] = 0;
	
	txtb_spr[page_number] = spr_chatbox;
	speaker_sprite[page_number] = noone;
	speaker_side[page_number] = -1; // Left: 1, Center: 0, Right: -1
	
	// Variables for every letter/character
	for (var c = 0; c < 500; c++) {
		col_1[c, page_number] = text_def_color;
		col_2[c, page_number] = text_def_color;
		col_3[c, page_number] = text_def_color;
		col_4[c, page_number] = text_def_color;
		
		float_text[c, page_number] = 0;
		float_dir[c, page_number] = c*20; // Each letter is offset 20 degrees from the last
		
		shake_text[c, page_number] = 0;
		shake_dir[c, page_number] = irandom(360);
		shake_timer[c, page_number] = irandom(4);
	}
	
	name_string[page_number] = noone;
	name_color[page_number] = $ffffff;
	name_textbox_color[page_number] = $666666;
	
	background_spr[page_number] = spr_background_player;
	
	snd[page_number] = noone;
	snd_pitch_multiplier[page_number] = 1;
}

// Text VFX
/// @param first_char
/// @param last_char
/// @param col_1
/// @param col_2
/// @param col_3
/// @param col_4
function scr_text_color(_start, _end, _col_1, _col_2, _col_3, _col_4) {
	for (var c = _start; c <= _end; c++) {
		col_1[c, page_number - 1] = _col_1;
		col_2[c, page_number - 1] = _col_2;
		col_3[c, page_number - 1] = _col_3;
		col_4[c, page_number - 1] = _col_4;
	}
}

/// @param first_char
/// @param last_char
function scr_text_float(_start, _end) {
	for (var c = _start; c <= _end; c++) {
		float_text[c, page_number - 1] = true;
	}
}

/// @param first_char
/// @param last_char
function scr_text_shake(_start, _end) {
	for (var c = _start; c <= _end; c++) {
		shake_text[c, page_number - 1] = true;
	}
}

/// @param text
/// @param [character]
/// @param [side]
function scr_text(_text){

	scr_set_defaults_for_text();
	text[page_number] = _text;
	
	// Get character info
	if argument_count > 1 {
		switch(argument[1]) {
			case "Rover":
				speaker_sprite[page_number] = spr_rover_neutral;
				name_string[page_number] = "Rover";
				name_textbox_color[page_number] = $d36356;
				background_spr[page_number] = spr_background_rover;
				snd_pitch_multiplier[page_number] = 1.4;
				break;
			case "Rover-Dream":
				speaker_sprite[page_number] = spr_rover_placeholder;
				name_string[page_number] = "Rover";
				name_textbox_color[page_number] = $d36356;
				background_spr[page_number] = spr_background_rover;
				break;
			case "Player":
				name_string[page_number] = "Player";
				name_textbox_color[page_number] = $0a337a
				snd[page_number] = animalese_beep;
				break;
			case "Alex":
				speaker_sprite[page_number] = spr_alex_yiikposting;
				name_string[page_number] = "Alex";
				name_textbox_color[page_number] = $0a337a;
				snd[page_number] = animalese_beep;
				break;
			case "Julio Profe":
				speaker_sprite[page_number] = spr_julio_twt;
				name_string[page_number] = "Julio Profe";
				name_textbox_color[page_number] = $a37cf2;
				name_color[page_number] = $0a0000;
				background_spr[page_number] = spr_background_platon;
				snd_pitch_multiplier[page_number] = 0.8;
				break;
			case "???":
				name_string[page_number] = "???";
				break;
		}
	}
	
	// The side the character is on
	// Get character info
	if argument_count > 2 {
		speaker_side[page_number] = argument[2];
	}

	page_number++;

}

/// @param option
/// @param link_id
function scr_option(_option, _link_id) {
	option[option_number] = _option;
	option_link_id[option_number] = _link_id;
	option_number++;
}

/// @param text_id
function create_textbox(_text_id) {
	with (instance_create_depth(0, 0, -9999, obj_chatbox)) {
		scr_game_script(_text_id);
	}
} 