// Evento Draw do obj_fade_out
draw_set_color(c_black);
draw_set_alpha(fade_alpha);
draw_rectangle(0, 0, display_get_width(), display_get_height(), false);
draw_set_alpha(1); // Reseta o alpha de volta para 1
