local M = {}

--控制器列表--
tmCtrls = {};	

function M.Init()
	return self;
end

--添加控制器--
function M.AddCtrl(moduleName, ctrlObj)
	tmCtrls[moduleName] = ctrlObj;
end

--获取控制器--
function M.GetCtrl(moduleName)
    if not table.containKey(tmCtrls, moduleName) then
        tmCtrls[moduleName] = require('Controller/' .. moduleName .. 'Ctrl'):new(moduleName)
    end
	return tmCtrls[moduleName];
end

--移除控制器--
function M.RemoveCtrl(moduleName)
	tmCtrls[moduleName] = nil;
end

--关闭控制器--
function M.Close()
	logWarn('M.Close---->>>');
end

return M