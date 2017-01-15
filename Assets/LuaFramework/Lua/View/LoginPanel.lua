local M = {}

--启动事件--
function M:Init(obj)
	self.gameObject = obj;
	self.transform = obj.transform;
	
	self.btnOpen = self.transform:FindChild("Open").gameObject;
end

function M:OnDestroy()
	logWarn("OnDestroy---->>>");
end

return M