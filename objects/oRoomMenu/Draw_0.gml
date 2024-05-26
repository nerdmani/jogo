draw_set_font(Font1);
var gui_width = display_get_gui_width();
var gui_height = display_get_gui_height();
var x1 = gui_width / 2;
var y1 = (gui_height / 2) + 25;
var margin = 50;
var m_x = device_mouse_x_to_gui(0);
var m_y = device_mouse_y_to_gui(0);

draw_set_halign(fa_center);
draw_set_valign(fa_center);

// Tocar o som apenas uma vez
if (!menuSoundPlayed) {
    audio_play_sound(sndMenu, 5, true);
    menuSoundPlayed = true;
}

for (var i = 0; i < op_max; i++) {
    var y2 = y1 + (margin * i);
    var string_w = string_width(options[i]);
    var string_h = string_height(options[i]);

    if (point_in_rectangle(m_x, m_y, x1 - string_w / 2, y2 - string_h / 2, x1 + string_w / 2, y2 + string_h / 2)) {
        draw_set_color(#85bb65);
        index = i;
        show_debug_message(index);

       
        if (index != previousIndex) {
            
            switch (index) {
                case 0:
                    audio_play_sound(sndClick, 3, false);
                    break;
                case 1:
                    audio_play_sound(sndClick, 3, false);
                    break;
                case 2:
                    audio_play_sound(sndClick, 3, false);
                    break;
                case 3:
                    audio_play_sound(sndClick, 3, false);
                    break;
               
            }
           
            previousIndex = index;
        }

        if (mouse_check_button_pressed(mb_left)) {
            if (index == 3) {
                game_end();
            }
            if (index == 0) {
                audio_stop_sound(sndMenu); 
                instance_create_depth(0, 0, 0, otransition); 
                otransition.transitioning = true; 
                otransition.nextRoom = room_next(room); 
            }
			if (index == 2) {
                audio_stop_sound(sndMenu); 
                instance_create_depth(0, 0, 0, otransition); 
                otransition.transitioning = true; 
                otransition.nextRoom = room_goto(Menu4); 
            }
			if (index == 1) {
                 audio_stop_sound(sndMenu); 
                instance_create_depth(0, 0, 0, otransition); 
                otransition.transitioning = true; 
                otransition.nextRoom = room_goto(curiosidades1); 
            }
        }
    } else {
        draw_set_color(c_white);
    }

    draw_text(x1, y2, options[i]);
}
