
draw_sprite_stretched(sBox, 0, x, y, widthFull, heightFull);

// Set drawing parameters
draw_set_color(c_white);
draw_set_font(fnM5x7);
draw_set_halign(fa_left);
draw_set_valign(fa_top);


var _desc = (description != -1) ? 1 : 0;


hover = clamp(hover, 0, array_length(options) - 1);
visibleOptionsMax = min(visibleOptionsMax, array_length(options));


var _scrollPush = max(0, hover - (visibleOptionsMax - 1));


for (var l = 0; l < visibleOptionsMax + _desc; l++) {
    if (l >= array_length(options)) break;

    
    draw_set_color(c_white);

    if (l == 0 && _desc) {
        // Dsenha a descrição 
        draw_text(x + xmargin, y + ymargin, description);
    } else {
        var _optionToShow = l - _desc + _scrollPush;
        if (_optionToShow >= array_length(options)) break; // Ensure we do not access out of bounds

        var _str = options[_optionToShow][0];

        
        if (hover == _optionToShow) {
            draw_set_color(c_yellow);
        }

        
        if (!options[_optionToShow][3]) {
            draw_set_color(c_gray);
        }

        // Desenha a opção de texto
        draw_text(x + xmargin, y + ymargin + l * heightLine, _str);
    }
}


draw_sprite(sPointer, 0, x + xmargin + 8, y + ymargin + ((hover - _scrollPush + _desc) * heightLine) + 7);


if (visibleOptionsMax < array_length(options) && hover < array_length(options) - 1) {
    draw_sprite(sDownArrow, 0, x + widthFull * 0.5, y + heightFull - 7);
}
