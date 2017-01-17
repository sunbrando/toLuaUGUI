local ControllerBase = require('Common.Base.ControllerBase')
local M = class(..., ControllerBase)

function M:Open()
    ViewManager.PushView(ModuleName.Login)
end

--启动事件--
function M:OnEnter(view)
	self.view = view
	self:UpdateView()
end

--登录界面更新--
function M:UpdateView()
    if self.view ~= nil then
        self.view:Update()
    end
end


return M