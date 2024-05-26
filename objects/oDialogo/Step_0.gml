// Evento Step do obj_dialogo
if (inicializar == false) {
    scr_textos();
    inicializar = true;
}

if keyboard_check_pressed(vk_space) {
    if (pagina < array_length(texto) - 1) {
        pagina++;
    } else {
		oPlayer.modo_dialogo = false;
        instance_destroy();
    }
}
