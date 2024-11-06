depth = -999999;

// Textbox related variables
textbox_width = 244;
textbox_height = 69; // nice
border = 16; // Border between the chatbox and the letters
line_sep = 15; // Separation between lines (vertical)
line_width = textbox_width - border*2;
txtb_img = 0;
txtb_img_spd = 0;

// Text related variables
page = 0; // Text page :)
page_number = 0;
text[0] = "";
text_length[0] = string_length(text[0]);

char[0, 0] = "";
char_x[0, 0] = 0;
char_y[0, 0] = 0;

draw_char = 0; // How many of the characters are currently being drawn
text_spd = 0.5;
text_def_color = $5b7481
draw_set_color(text_def_color);

// Options
option[0] = "";
option_link_id[0] = -1; // To check for the link after replying to the option
option_pos = 0; // For scrolling through positions
option_number = 0;
option_x = 302;

// Name box
nmeb_height = 18;
name_string = "";
name_color = $ffffff;
name_textbox_color = $000000;
name_spacing = 4;

setup = false;

// Sound
snd_delay = 2;
snd_count = snd_delay;

// Effects
scr_set_defaults_for_text();
last_free_space = 0;
text_pause_timer = 0;
text_pause_time = 6;

// Textbox animations
curve_ease = animcurve_get_channel(crv_curves, "ease");
curve_spd = 0;
old_speaker_name = noone;

float_number = 0;

background_delay = 5;
background_offset = 0;
background_alpha = 0.5;

fade_background_timer = 0;
fade_one_time_check = true;

if (global.last_message_was_option == false) {
	typing_timer = 24;
} else {
	last_message_was_option = false;
	typing_timer = 2; // 0 has some weird issues.
}