--------------------------------------------------------------------------------------------
-- @description UI界面的基类
--------------------------------------------------------------------------------------------
local M = class(...)

--obj：构造view对象的gameobject--
function M:ctor(obj)
    self.gameObject = obj
    self.transform = obj.transform

    self.luaBehaviour = self.transform:GetComponent('LuaBehaviour');
end

-- 【子类重写】添加消息监听--
function M:AddListener() return { } end

-- 【子类重写】初始化界面--
function M:Init() end

-- 【子类重写】界面激活--
function M:OnActive() end

-- 【子类重写】界面隐藏--
function M:OnHide() end

-- 【子类重写】刷新界面--
function M:Update() end

return M
