instance_deactivate_all(true); // Desativa todas as instâncias, exceto oBattle

// Variáveis globais e arrays para gerenciamento da batalha
units = [];
turn = 0;
unitTurnOrder = [];
unitRenderOrder = [];

turnCount = 0;
roundCount = 0;
battleWaitTimeFrames = 30;
battleWaitTimeRemaining = 0;
currentUser = noone;
currentAction = -1;
currentTargets = noone;

battleText = "";

cursor = {
    activeUser: noone,
    activeTarget: noone,
    activeAction: -1,
    targetSide: -1,
    targetIndex: 0,
    targetAll: false,
    confirmDelay: 0,
    active: false
};

// Configuração dos inimigos na batalha
if (array_length(enemies) > 0) {
    // Cria apenas um inimigo
    var i = array_length(enemies) - 1; // Pega o último inimigo no array
    enemyUnits[0] = instance_create_depth(
        x + 250, // Posição X do inimigo (ajuste conforme necessário)
        y + 38,  // Posição Y do inimigo (ajuste conforme necessário)
        depth - 10, // Profundidade do inimigo
        oBattleUnitEnem, // Objeto do inimigo
        enemies[i] // Dados do inimigo
    );
    array_push(units, enemyUnits[0]); // Adiciona o ID da unidade inimiga à lista de unidades
}

// Configuração da Lulu na batalha
if (array_length(global.party) > 0) {
    // Cria apenas a Lulu
    partyUnits[0] = instance_create_depth(
        x + 50,  // Posição X da Lulu (ajuste conforme necessário)
        y + 90,  // Posição Y da Lulu (ajuste conforme necessário)
        depth - 10, oBattleUnitPC, global.party[0] // Assumindo que Lulu é o primeiro elemento do array global.party
    );
    array_push(units, partyUnits[0]);
}


// Embaralha a ordem de turnos
unitTurnOrder = array_shuffle(units);

// Atualiza a ordem de renderização das unidades
RefreshRenderOrder = function() {
    unitRenderOrder = [];
    array_copy(unitRenderOrder, 0, units, 0, array_length(units));
    array_sort(unitRenderOrder, function(_1, _2) {
        return _1.y - _2.y;
    });
};

RefreshRenderOrder();

function BattleStateSelectAction() {
    if (!instance_exists(oMenu)) {
        var _unit = unitTurnOrder[turn];

        // Verifica se a unidade está viva e apta a atacar
        if (!instance_exists(_unit) || (_unit.hp <= 0)) {
            battleState = BattleStateVictoryCheck;
            exit;
        }

        // Se a unidade é controlada pelo jogador
        if (_unit.object_index == oBattleUnitPC) {
            var _menuOptions = [];
            var _subMenus = {};
            var _actionList = _unit.actions;

            for (var i = 0; i < array_length(_actionList); i++) {
                var _action = _actionList[i];
                var _available = true;
                var _nameAndCount = _action.name;
                if (_action.subMenu == -1) {
                    array_push(_menuOptions, [_nameAndCount, MenuSelectAction, [_unit, _action], _available]);
                } else {
                    if (is_undefined(_subMenus[$ _action.subMenu])) {
                        variable_struct_set(_subMenus, _action.subMenu, [[_nameAndCount, MenuSelectAction, [_unit, _action], _available]]);
                    } else {
                        array_push(_subMenus[$ _action.subMenu], [_nameAndCount, MenuSelectAction, [_units, _action], _available]);
                    }
                }
            }

            var _subMenusArray = variable_struct_get_names(_subMenus);
            for (var i = 0; i < array_length(_subMenusArray); i++) {
                // Adiciona a opção de voltar no final de cada submenu
                array_push(_subMenus[$ _subMenusArray[i]], ["Back", MenuGoBack, -1, true]);
                // Adiciona submenu no menu principal
                array_push(_menuOptions, [_subMenusArray[i], SubMenu, [_subMenus[$ _subMenusArray[i]]], true]);
            }
            Menu(x + 10, y + 110, _menuOptions, , 74, 60);
        } else {
            // Se a unidade é controlada pela IA
            var _enemyAction = _unit.AIscript();
            if (_enemyAction != -1) BeginAction(_unit.id, _enemyAction[0], _enemyAction[1]);
        }
    }
}

function BeginAction(_user, _action, _targets) {
    currentUser = _user;
    currentAction = _action;
    currentTargets = _targets;

    if (_user.object_index == oBattleUnitPC && _action.name == "Fraco") {
        _user.mp += 3;
        if (_user.mp > _user.mpMax) _user.mp = _user.mpMax; // Garante que o MP não ultrapasse o máximo
    } else if (_user.object_index == oBattleUnitPC && _action.name != "Defend") {
        if (_action.mpCost > _user.mp) {
            battleText = "MP insuficiente!";
            battleState = BattleStateSelectAction;
            exit;
        }

        _user.mp -= _action.mpCost;
        if (_user.mp < 0) _user.mp = 0;
    }

    // Se a ação não for "Defend", continua com o processo de execução da ação
    if (_action.name != "Defend") {
        battleText = string_ext(_action.description, [_user.name]);
        if (!is_array(currentTargets)) currentTargets = [currentTargets];
        battleWaitTimeRemaining = battleWaitTimeFrames;
        with (_user) {
            acting = true;
            if (!is_undefined(_action[$ "userAnimation"]) && !is_undefined(_user.sprites[$ _action.userAnimation])) {
                sprite_index = sprites[$ _action.userAnimation];
                image_index = 0;
            }
        }
        battleState = BattleStatePerformAction;
    }
}

function BattleStatePerformAction() {
    // Se a animação ainda está acontecendo
    if (currentUser.acting) {
        if (currentUser.image_index >= currentUser.image_number - 1) {
            with (currentUser) {
                sprite_index = sprites.idle;
                image_index = 0;
                acting = false;
            }

            if (variable_struct_exists(currentAction, "effectSprite")) {
                if (currentAction.effectOnTarget == MODE.ALWAYS ||
                    (currentAction.effectOnTarget == MODE.VARIES && array_length(currentTargets) <= 1)) {
                    for (var i = 0; i < array_length(currentTargets); i++) {
                        instance_create_depth(currentTargets[i].x, currentTargets[i].y, currentTargets[i].depth - 1, oBattleEffect, {sprite_index: currentAction.effectSprite});
                    }
                } else {
                    var _effectSprite = currentAction.effectSprite;
                    if (variable_struct_exists(currentAction, "effectSpriteNoTarget")) _effectSprite = currentAction.effectSpriteNoTarget;
                    instance_create_depth(x, y, depth - 100, oBattleEffect, {sprite_index: _effectSprite});
                }
            }
            currentAction.func(currentUser, currentTargets);
        }
    } else {
        if (!instance_exists(oBattleEffect)) {
            battleWaitTimeRemaining--;
            if (battleWaitTimeRemaining == 0) {
                battleState = BattleStateVictoryCheck;
            }
        }
    }
}

function BattleStateVictoryCheck() {
    var allEnemiesDefeated = true;
    var allPartyDefeated = true;

    // Verifica se todos os inimigos estão mortos
    for (var i = 0; i < array_length(enemyUnits); i++) {
        if (enemyUnits[i].hp > 0) {
            allEnemiesDefeated = false;
            break;
        }
    }

    // Verifica se todos os membros do grupo estão mortos
    for (var i = 0; i < array_length(partyUnits); i++) {
        if (partyUnits[i].hp > 0) {
            allPartyDefeated = false;
            break;
        }
    }

    // Se todos os inimigos foram derrotados e Lulu está viva
    if (allEnemiesDefeated && global.party[0].hp > 0) {
        EndBattle(true); // Indica vitória
    } else if (allPartyDefeated) {
        EndBattle(false); // Indica derrota
    } else {
        battleState = BattleStateTurnProgression;
    }
}

function EndBattle(isVictory) {
    if (instance_exists(global.battleTrigger)) {
        instance_destroy(global.battleTrigger);
    }

    // Desativa todas as instâncias exceto as persistentes
    instance_deactivate_all(true);

    // Chama a função de transição para Room9 se a batalha for vencida
    if (isVictory) {
        instance_create_depth(0, 0, -1000, oTransitionEffect);
		 instance_destroy(oBattle);
    } else {
        // Vai para Room1 se a batalha for perdida, reseta o HP de Lulu
        if (room_exists(Ribeirinho)) {
            global.party[0].hp = global.party[0].hpMax;
			instance_create_depth(0, 0, -1000, oTransitionEffect25);
			instance_destroy(oBattle);
        }
    }

    // Fecha a tela de batalha
   
}






function BattleStateTurnProgression() {
    battleText = "";
    turnCount++;
    turn++;

    // Loop dos turnos
    if (turn > array_length(unitTurnOrder) - 1) {
        turn = 0;
        roundCount++;
    }

    // Desativa a defesa da unidade que acabou de concluir o turno
    var _previousTurn = turn - 1;
    if (_previousTurn < 0) {
        _previousTurn = array_length(unitTurnOrder) - 1;
    }

    var _unit = unitTurnOrder[_previousTurn];

    // Verifica se a variável defendingTurn existe antes de acessá-la
    if (variable_instance_exists(_unit, "defendingTurn") && _unit.defendingTurn) {
        _unit.isDefending = false;
        _unit.defendingTurn = false;
        _unit.sprite_index = _unit.sprites.idle;
    }

    battleState = BattleStateSelectAction;
}

function ApplyDamage(target, damage) {
    // Verifica se o alvo está defendendo
    if (target.defendingTurn) {
        damage = 0;
    }
    target.hp -= damage;
    if (target.hp < 0) target.hp = 0;
}

// Inicia o estado de seleção de ação
battleState = BattleStateSelectAction;

global.battleTrigger = noone;

function StartBattle(_collisionObject) {
    global.battleTrigger = _collisionObject;

    instance_deactivate_all(true);
    instance_activate_object(oBattle);
    oBattle.active = true;
}

