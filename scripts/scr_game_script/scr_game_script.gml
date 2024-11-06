// @param text_id
function scr_game_script(_text_id){
	switch (_text_id) {
		
		// --- EXAMPLE DIALOGUE ---
		// Used exclusively on the Test Room.
		// It's pretty stupid, please ignore.
		
		case "rover_war":
			scr_text("war crimes. :)", "Rover-Dream");
			break;
		
		case "rover_teaser":
			scr_text("And you said you were going to Sunbreeze Island, right?", "Rover");
			scr_text_color(31, 46, c_teal, c_teal, c_teal, c_teal); scr_text_float(31, 46);
			scr_text("And you said you were going to Sunbreeze Island, right?", "Rover");
			break;
		
		case "rover_welcome":
			scr_text("¿Crees que hemos hecho esperar mucho a la gente?", "Julio Profe");
			scr_text("Hello! The name's Rover. How about you, mrrow?", "Rover");
				scr_text_color(18, 23, c_teal, c_teal, c_teal, c_teal); scr_text_float(40, 45);
			scr_text("WHAT THE FUCK IS GOING ON", "Alex", 1);
				scr_text_shake(0, 24);
			scr_text("...what", "Rover");
			scr_option("Just a journalist.", "journal");
			scr_option("Don't have one.", "no_name");
			scr_option("...", "tongue");
			break;
			case "journal":
				scr_text("Aaaah. So I take it you're one of those low-lifes, then?", "Rover");
				scr_text("...Pffft, I was just kidding! You should've seen the look in your mug -", "Rover");
				scr_text("You're good, you're good.", "Rover");
				break;
			case "no_name":
				scr_text("Whaaaat?!", "Rover");
				scr_text("What do you mean you have no name? EVERYONE'S got a name!", "Rover");
				scr_option("Well, I don't.", "push_through");
				scr_option("Consider yourself lucky.", "tease");
				break;
				case "push_through":
					scr_text("My, my! I'm glad to hear there's still plenty of rude people in the world.", "Rover");
					scr_text("Y'know what? I'm gonna sit here, just to spite you.", "Rover");
					scr_text("Make this plane ride less plain and all.", "Rover");
					break;
				case "tease":
					scr_text("I suppose I should, shouldn't I?", "Rover");
					scr_text("At least I'm not some 'Unknown Cat' of sorts...", "Rover");
					break;
			case "tongue":
				scr_text("You kinda just... nod along in silence.")
				scr_text("...What, cat got your tongue?", "Rover");
				scr_text("Suit yourself, par'ner. Mutes have it easy, you know.", "Rover");
				scr_text("Don't have to say a single thing and people will still talk to you.", "Rover");
				break;
			
		case "rover_repeat":
			scr_text("Dude, I'm just a game NPC.", "Rover-Dream");
			scr_text("I'll be repeating this dialogue until you move on.", "Rover-Dream");
			scr_text("It'd be smart to...", "Player");
			break;
	}
}