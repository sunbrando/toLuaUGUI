--------------------------------------------------------------------------------------------
-- @description 控制器操作的基类
--------------------------------------------------------------------------------------------
local M = class(...)

function M:ctor(strName)
    self.strName = strName
    self.view = nil
end

--【子类重写】打开界面--
function M:Open(tmParams) end

--【子类重写】界面加载完成调用，返回该界面的GameObject对象--
function M:OnEnter(view) 
    self.view = view
end

--【子类重写】在切换场景的时候执行--
function M:CleanWhenReplaceScene() end

--关闭界面--
function M:Close()
    ViewManager.PopView()
    self.view = nil
end

--获取所控制的View对象--
function M:GetView() return self.view end

return M