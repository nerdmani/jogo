var gui_width = display_get_gui_width();
var gui_height = display_get_gui_height();
var sprite_x = gui_width / 2 - 475;
var sprite_y = gui_height / 2 - 200;

// Tocar o som apenas uma vez
if (!menuSoundPlayed) {
	
	
    menuSoundPlayed = true;
}


// Desenhar a sprite no meio da room
var sprite_to_draw = sIntro2; // Atribuir a sprite dos créditos
draw_sprite(sprite_to_draw, 0, sprite_x, sprite_y);
