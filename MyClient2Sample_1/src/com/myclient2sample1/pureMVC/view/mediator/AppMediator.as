package com.myclient2sample1.pureMVC.view.mediator
{
	import com.myclient2sample1.consts.MapOperates;
	import com.myclient2sample1.pureMVC.controller.business.engine.InitEngineCommand;
	import com.myclient2sample1.pureMVC.controller.business.ui.InitUICommand;
	import com.myclient2sample1.pureMVC.model.UIProxy;
	
	import flash.events.Event;
	
	import org.puremvc.as3.patterns.mediator.Mediator;
	/**
	 * 
	 * @author 王明凡
	 */
	public class AppMediator extends Mediator
	{
		public static const NAME:String="AppMediator";
		
		private var uiP:UIProxy;
		
		public function AppMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);		
			uiP=this.facade.retrieveProxy(UIProxy.NAME) as UIProxy;
			app.addEventListener(Event.ADDED_TO_STAGE,onAddedToStage);
		}
		/**
		 * 添加到舞台的时候，启动程序
		 * @param e
		 */
		private function onAddedToStage(e:Event):void
		{
			//初始化UI模型层
			this.sendNotification(InitUICommand.IUC_INIT_UI_COMMAND);
			//初始化Engine模型层
			this.sendNotification(InitEngineCommand.IEC_INIT_ENGINE_COMMAND,uiP.getMapConvertVO("Start",MapOperates.Start_1));
		}
		private function get app():MyClient2Sample_1
		{
			return this.viewComponent as MyClient2Sample_1;
		}		
	}
}