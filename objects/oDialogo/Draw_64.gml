// Evento Draw do oDialogo
var _guil = display_get_gui_width();
var _guia = display_get_gui_height();

var _xx = 0;
var _yy = _guia - 50;
var _c = c_black;

// Definir a fonte do texto (assegure-se de que fnt_text está corretamente definida)
draw_set_font(fnM5x7);

// Desenhar a caixa de diálogo
draw_set_color(_c);
draw_rectangle(_xx, _yy, _guil, _guia, false);

// Desenhar o texto dentro da caixa de diálogo
draw_set_color(c_white); // Define a cor do texto como branca
draw_text_ext_transformed(_xx + 150, _yy + 10, texto[pagina], 20, _guil * 2, 0.5, 0.5, 0);


