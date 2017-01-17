--主入口函数。从这里开始lua逻辑
function Main()					
	require "Manager/Init"
end

--场景切换通知
function OnLevelWasLoaded(level)
	collectgarbage("collect")
	Time.timeSinceLevelLoad = 0
end