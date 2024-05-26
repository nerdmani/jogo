// Objeto oDefeatScreen
function oDefeatScreen() {
    // Configurações iniciais
    event_perform_object(oDefeatScreen, ev_create, function() {
        // Desenhe a tela de derrota
        draw_text(x, y, "Derrota! Todos os personagens foram derrotados.");
    });
}
