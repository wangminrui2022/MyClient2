package com.myclient2sample1.pureMVC.controller.business.engine
{
	import com.myclient2.core.engine.MCamera;
	import com.myclient2.core.engine.MEngine;
	import com.myclient2.core.engine.MViewPort;
	import com.myclient2sample1.pureMVC.model.EngineProxy;
	import com.myclient2sample1.pureMVC.model.UIProxy;
	import com.myclient2sample1.vo.MapConvertVO;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	/**
	 * 初始化引擎模型层
	 * @author wangmingfan
	 */
	public class InitEngineCommand extends SimpleCommand
	{
		public static const IEC_INIT_ENGINE_COMMAND:String="iec_init_engine_command";
		public static const IEC_INIT_ENGINE_COMMAND_COMPLETE:String="iec_init_engine_command_complete"; 
		private var uiP:UIProxy;
		private var engineP:EngineProxy;
		
		public function InitEngineCommand()
		{
			uiP=this.facade.retrieveProxy(UIProxy.NAME) as UIProxy;
			engineP=this.facade.retrieveProxy(EngineProxy.NAME) as EngineProxy;
		}
		override public function execute(note:INotification):void
		{
			var mcVO:MapConvertVO=note.getBody() as MapConvertVO;
			if(mcVO)
			{
				//创建引擎,并设置引擎不渲染地图操作对象,进行剔除
				engineP.engine=new MEngine(uiP.engineContainer);
				engineP.engine.isClippingOperate=true;	
				//创建观察口	
				engineP.viewPort=new MViewPort(mcVO.mapViewPortX,mcVO.mapViewPortY);
				//创建摄像机
				engineP.camera=new MCamera(mcVO.x,mcVO.y,mcVO.CWidth,mcVO.CHeight);
				//删除引用
				uiP=null;
				engineP=null;
				//创建地图
				this.sendNotification(LoaderMapCommand.LMC_LOADER_MAP,mcVO);
			}		
		}	
	}
}