local ViewBase = require('Common.Base.ViewBase')
local M = class(..., ViewBase)

--启动事件--
function M:Init()
	M.super.Init(self)
	
	self.btnOpen = self.transform:FindChild("Open").gameObject;
	self.luaBehaviour:AddClick(self.btnOpen, handler(self, self.OnClick));
end

--单击事件--
function M:OnClick(go)
	CtrlManager.GetCtrl(ModuleName.Prompt):Open();
    self.Close()
end

--刷新界面--
function M:Update()
	logWarn(">>>>>>>>>>>>>>>>>>>> Update");
end

--关闭事件--
function M:Close()
	ViewManager.PopView(ModuleName.Login)
end

return M