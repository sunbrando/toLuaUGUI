local M = {}

--构建函数--
function M:New()
	return self;
end

function M:Open()
    ViewManager.PushView(ModuleName.Prompt)
end

--启动事件--
function M:OnEnter(view)
    self.view = view
    self.luaBehaviour = self.view.transform:GetComponent('LuaBehaviour');

    self.luaBehaviour:AddClick(self.view.btnOpen, handler(self, self.OnClick));
    resMgr:LoadPrefab('prompt', { 'PromptItem' }, handler(self, self.InitPanel));
end

--初始化面板--
function M:InitPanel(objs)
	local count = 100; 
	local parent = self.view.gridParent;
	for i = 1, count do
		local go = newObject(objs[0]);
		go.name = 'Item'..tostring(i);
		go.transform:SetParent(parent);
		go.transform.localScale = Vector3.one;
		go.transform.localPosition = Vector3.zero;
        self.luaBehaviour:AddClick(go, handler(self, self.OnItemClick));

	    local label = go.transform:FindChild('Text');
	    label:GetComponent('Text').text = tostring(i);
	end
end

--滚动项单击--
function M:OnItemClick(go)
    logWarn("OnItemClick---->>>"..go.name);
end

--单击事件--
function M:OnClick(go)
	logWarn("OnClick---->>>"..go.name);
end

--关闭事件--
function M:Close()
    ViewManager.PopView(ModuleName.Prompt)
end

return M