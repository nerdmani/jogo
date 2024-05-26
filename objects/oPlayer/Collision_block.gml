// No evento de colisão entre obj_player e obj_parede

// Ajuste a posição do jogador para evitar a colisão
move_contact_solid(direction, 1);

// Ou, se preferir ajustar manualmente:

// Ajuste a posição horizontal
if (place_meeting(x + hspeed, y, block)) {
    x = xprevious;
}

// Ajuste a posição vertical
if (place_meeting(x, y + vspeed, block)) {
    y = yprevious;
}