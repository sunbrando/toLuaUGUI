CtrlManager = {};
local this = CtrlManager;
--控制器列表--
local tmCtrls = {};	

function CtrlManager.Init()
	return this;
end

--添加控制器--
function CtrlManager.AddCtrl(moduleName, ctrlObj)
	tmCtrls[moduleName] = ctrlObj;
end

--获取控制器--
function CtrlManager.GetCtrl(moduleName)
    if not table.containKey(tmCtrls, moduleName) then
        tmCtrls[moduleName] = require('Controller/' .. moduleName .. 'Ctrl'):New()
    end
	return tmCtrls[moduleName];
end

--移除控制器--
function CtrlManager.RemoveCtrl(moduleName)
	tmCtrls[moduleName] = nil;
end

--关闭控制器--
function CtrlManager.Close()
	logWarn('CtrlManager.Close---->>>');
end