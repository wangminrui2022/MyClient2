package com.myclient2sample3.pureMVC.controller.business.engine
{
	import com.myclient2sample3.pureMVC.model.*;
	import com.myclient2sample3.pureMVC.view.mediator.MoveKeyboardMediator;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	/**
	 * 清楚地图垃圾
	 * @author 王明凡
	 */
	public class ClearMapCommand extends SimpleCommand
	{
		public static const CMC_CLEAR_MAP:String="cmc_clear_map";
		
		private var engineP:EngineProxy;
		private var mapOperateP:MapOperateProxy;
		private var uiP:UIProxy;
		private var roleP:RoleProxy;
				
		public function ClearMapCommand()
		{
			engineP=this.facade.retrieveProxy(EngineProxy.NAME) as EngineProxy;
			mapOperateP=this.facade.retrieveProxy(MapOperateProxy.NAME) as MapOperateProxy;	
			uiP=this.facade.retrieveProxy(UIProxy.NAME) as UIProxy;		
			roleP=this.facade.retrieveProxy(RoleProxy.NAME) as RoleProxy;	
		}
		override public function execute(note:INotification):void
		{		
			this.sendNotification(MoveKeyboardMediator.MKM_STOP_KEYBOARD_LISTENER);	
			engineP.clear();
			mapOperateP.clear();
			uiP.clear();
			roleP.clear();
			
			engineP=null;
			mapOperateP=null;
			uiP=null;	
			roleP=null;	
		}
	}
}