// Evento Step do obj_fade_out
if (fading) {
    fade_alpha += fade_speed; // Aumenta o alpha gradualmente
    if (fade_alpha >= 1) {
        fade_alpha = 1; // Garante que o alpha não seja maior que 1
        fading = false; // Fade completo, agora muda a room
        room_goto(global.next_room); // Teleporta para a próxima room
    }
}
