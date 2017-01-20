Game = {}

--初始化完成，发送链接服务器信息--
function Game.OnInitOK()

    AppConst.SocketPort = 2012;
    AppConst.SocketAddress = "127.0.0.1";
    networkMgr:SendConnect();
    
    if AppConst.ExampleMode == 1 then
        CtrlManager.GetCtrl(ModuleName.Login):Open();
    end
end

--销毁--
function Game.OnDestroy()
	--logWarn('OnDestroy--->>>');
end
