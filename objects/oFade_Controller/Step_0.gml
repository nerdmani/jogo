// Evento Step do obj_fade_controller
if (fade_alpha > 0) {
    fade_alpha -= fade_speed; // Diminui o alpha gradualmente
    if (fade_alpha < 0) {
        fade_alpha = 0; // Garante que o alpha não seja menor que 0
    }
}
