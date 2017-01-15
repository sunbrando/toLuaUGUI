local M = {}

--构建函数--
function M:New()
	return self;
end

function M:Open()
    ViewManager.PushView(ModuleName.Login)
end

--启动事件--
function M:OnEnter(view)
	self.view = view
	self.luaBehaviour = self.view.transform:GetComponent('LuaBehaviour');

	self.luaBehaviour:AddClick(self.view.btnOpen, handler(self, self.OnClick));
end

--单击事件--
function M:OnClick(go)
	CtrlManager.GetCtrl(ModuleName.Prompt):Open();
    self.Close()
end

--关闭事件--
function M:Close()
	ViewManager.PopView(ModuleName.Login)
end

return M