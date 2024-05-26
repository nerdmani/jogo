// Os recursos de script mudaram para a v2.3.0; veja
// https://help.yoyogames.com/hc/en-us/articles/360005277377 para obter mais informações
function Menu(_x, _y, _options, _description = -1, _width = undefined, _height = undefined )
{
	with (instance_create_depth(_x, _y,-99999, oMenu))
	{
		options = _options;
		description = _description;
		var _optionsCount = array_length(_options);
		visibleOptionsMax = _optionsCount;
		
		
		// organizando os tamanhos
		
		xmargin = 10;
		ymargin = 8;
		draw_set_font(fnM5x7);
		heightLine = 12;
		
		// auto width
		if (_width == undefined)
		{
			width = 1;
			if (description != 1) width = max(width, string_width(_description));
			for (var i = 0; i < _optionsCount; i++)
			{
				width = max(width, string_width(_options[i][0]));
			}
			widthFull = width + xmargin * 2;
			
		}else widthFull = _width;
		
		// auto height
		if (_height == undefined)
		{
			height = heightLine * ( _optionsCount + !(description == -1));
			heightFull = height +ymargin * 2;
		}
		else
		{
			heightFull = _height;
			// rolagem 
			if (heightLine * (_optionsCount + !(description == -1)) > _height - (ymargin *2))
			{
				scrolling = true;
				visibleOptionsMax = (_height - ymargin * 2) div heightLine;
			}
		}
	}
}


function SubMenu(_options)
{
	optionsAbove[subMenuLevel] = options;
	subMenuLevel ++;
	options = _options;
	hover = 0;
}

function MenuGoBack()
{
	subMenuLevel --;
	options = optionsAbove[subMenuLevel];
	hover = 0;
}

function MenuSelectAction(_user, _action)
{
	with (oMenu) active = false;
	with (oBattle) 
	{
		if (_action.targetRequired)
		{
			with (cursor)
			{ 
				active = true;
				activeAction = _action;
				targetAll = _action.targetAll;
				if (targetAll == MODE.VARIES) targetAll = true; 
				activeUser = _user;
				
				if (_action.targetEnemyByDefault)
				{
					targetIndex = 0;
					targetSide = oBattle.enemyUnits;
					activeTarget = oBattle.enemyUnits[targetIndex];
				}
				else 
				{
					targetSide = oBattle.partyUnits;
					activeTarget = activeUser;
					var _findSelf = function(_element)
					{
						return (_element == activeTarget)
					}
					targetIndex = array_find_indez(oBattle.partyUnits, _findSelf);
				}
			}
		}
		else
		{
			BeginAction(_user, _action, -1);
			with (oMenu) instance_destroy();
		}
	}
}



