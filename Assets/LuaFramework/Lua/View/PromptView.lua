local ViewBase = require('Common.Base.ViewBase')
local M = class(..., ViewBase)

--启动事件--
function M:Init(gameObject)
	M.super.Init(self)

	self.btnOpen = self.transform:FindChild("Open").gameObject;
	self.gridParent = self.transform:FindChild('ScrollView/Grid');
	self.luaBehaviour:AddClick(self.btnOpen, handler(self, self.OnClick));
end

--刷新界面--
function M:Update()
    resMgr:LoadPrefab('prompt', { 'PromptItem' }, handler(self, self.InitPanel));
end

--滚动项单击--
function M:OnItemClick(go)
    logWarn("OnItemClick---->>>"..go.name);
end

--单击事件--
function M:OnClick(go)
	logWarn("OnClick---->>>"..go.name);
end

--初始化面板--
function M:InitPanel(objs)
	local count = 100; 
	local parent = self.gridParent;
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

--关闭事件--
function M:Close()
    ViewManager.PopView(ModuleName.Prompt)
end


return M