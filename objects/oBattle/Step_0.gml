battleState();

// Cursor controle

if (cursor.active)
{
	with (cursor)
	{
		var _keyUp = keyboard_check_pressed(vk_up);
		var _keyDown = keyboard_check_pressed(vk_down);
		var _keyLeft = keyboard_check_pressed(vk_left);
		var _keyRight = keyboard_check_pressed(vk_right);
		var _keyToggle = false;
		var _keyConfirm = false;
		var _keyCancel = false;
		confirmDelay++
		if (confirmDelay > 1)
		{
			_keyConfirm = keyboard_check_pressed(vk_enter);
			_keyCancel = keyboard_check_pressed(vk_escape);
			_keyToggle = keyboard_check_pressed(vk_shift);
		}
		
		var _moveH = _keyRight - _keyLeft;
		var _moveV = _keyDown - _keyUp;
		
		if (_moveH == -1) targetSide = oBattle.partyUnits;
		if (_moveH == 1) targetSide = oBattle.enemyUnits;
		
		// verificar a target lista 
		if (targetSide == oBattle.enemyUnits)
		{
			targetSide = array_filter(targetSide, function(_element, _index)
			{
				return _element.hp > 0
			});
		}
		
		if (targetAll == false)
		{
			if (_moveV == 1) targetIndex++;
			if (_moveV == -1) targetIndex --;
			
			var _targets = array_length(targetSide);
			if (targetIndex < 0) targetIndex = _targets -1;
			if (targetIndex > (_targets - 1)) targetIndex = 0;
			
			activeTarget = targetSide[targetIndex];
			
			if (activeAction.targetAll == MODE.VARIES) && (_keyToggle)
			{
				targetAll = true;
			}
			
		}
		else 
		{
			activeTarget = targetSide;
			if (activeAction.targetAll == MODE.VARIES) && (_keyToggle)
			{
				targetAll = false;
			}
		}
		
		if (_keyConfirm)
		{
			with (oBattle) BeginAction(cursor.activeUser, cursor.activeAction, cursor.activeTarget);
			with (oMenu) instance_destroy();
			active = false;
			confirmDelay = 0;
		}
		
		if (_keyCancel) && (!_keyConfirm)
		{
			with (oMenu) active = true;
			active = false;
			confirmDelay = 0;
		}
	}
}