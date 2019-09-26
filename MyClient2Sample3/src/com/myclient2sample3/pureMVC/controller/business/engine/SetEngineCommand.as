package com.myclient2sample3.pureMVC.controller.business.engine
{
	import com.myclient2.core.engine.*;
	import com.myclient2sample3.pureMVC.model.*;
	import com.myclient2sample3.vo.MapConvertVO;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	/**
	 * 设置引擎
	 * @author 王明凡
	 */
	public class SetEngineCommand extends SimpleCommand
	{
		public static const SEC_SET_ENGINE_COMMAND:String="sec_set_engine_command";
		
		private var uiP:UIProxy;

		private var engineP:EngineProxy;

		public function SetEngineCommand()
		{
			uiP=this.facade.retrieveProxy(UIProxy.NAME) as UIProxy;
			engineP=this.facade.retrieveProxy(EngineProxy.NAME) as EngineProxy;
		}

		override public function execute(note:INotification):void
		{
			var mcVO:MapConvertVO=note.getBody() as MapConvertVO;
			if (!mcVO)
				return;
			//创建引擎,并设置引擎不渲染地图操作对象,进行剔除
			engineP.engine=new MEngine(uiP.engineContainer);
			engineP.engine.isClippingOperate=true;
			//创建观察口	
			engineP.viewPort=new MViewPort(mcVO.mapViewPortX, mcVO.mapViewPortY);
			//创建摄像机
			engineP.camera=new MCamera(mcVO.x, mcVO.y, mcVO.CWidth, mcVO.CHeight);
			//删除引用
			mcVO=null;
			uiP=null;
			engineP=null;
		}
	}
}