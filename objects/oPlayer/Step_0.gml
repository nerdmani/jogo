
	
var _inputH = keyboard_check(ord("D")) - keyboard_check(ord("A")) +
              keyboard_check(vk_right) - keyboard_check(vk_left);
var _inputV = keyboard_check(ord("S")) - keyboard_check(ord("W")) +
              keyboard_check(vk_down) - keyboard_check(vk_up);;
var _inputD = point_direction(0,0,_inputH,_inputV);
var _inputM = point_distance(0,0,_inputH,_inputV);

if !modo_dialogo {
	
if (_inputM != 0)
{
	direction = _inputD;	
	image_speed = 1;
}
else
{
	image_speed = 0;
	animIndex = 0;
}

FourDirectionAnimate();


x += lengthdir_x(spdWalk*_inputM,_inputD);
y += lengthdir_y(spdWalk*_inputM,_inputD);

} else {

	image_speed = 0;
	animIndex = 2;

}

#region Dialogo
if distance_to_object(oPar_npc) <= 10 {
    if keyboard_check_pressed(ord("E")){
        var _npc = instance_nearest(x, y, oPar_npc);
        
        // Debug: Verificar se encontrou um NPC
        if (_npc == noone) {
            show_debug_message("Nenhum NPC próximo encontrado.");
        } else {
            show_debug_message("NPC encontrado: " + string(_npc.nome));
            
            var _dialogo = instance_create_layer(x, y, "Dialogo", oDialogo );
            
            // Debug: Verificar se o layer existe
            if (_dialogo == noone) {
                show_debug_message("Erro ao criar instância de diálogo. Verifique o layer 'Dialogo'.");
            } else {
                _dialogo.npc_nome = _npc.nome;
                modo_dialogo = true;
            }
        }
    }
}
#endregion



