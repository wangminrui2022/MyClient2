package com.myclient2sample1.pureMVC.controller.business.engine
{
	import com.myclient2sample1.pureMVC.model.*;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	/**
	 * 地图切换清理地图垃圾
	 * @author 王明凡
	 */
	public class ConvertClearMapCommand extends SimpleCommand
	{
		public static const CCMC_CONVERT_CLEAR_MAP:String="ccmc_convert_clear_map";
		
		private var engineP:EngineProxy;
		private var mapOperateP:MapOperateProxy;
		private var roleP:RoleProxy;
		private var uiP:UIProxy;
		
		public function ConvertClearMapCommand()
		{
			engineP=this.facade.retrieveProxy(EngineProxy.NAME) as EngineProxy;
			mapOperateP=this.facade.retrieveProxy(MapOperateProxy.NAME) as MapOperateProxy;	
			roleP=this.facade.retrieveProxy(RoleProxy.NAME) as RoleProxy;	
			uiP=this.facade.retrieveProxy(UIProxy.NAME) as UIProxy;	
		}
		override public function execute(note:INotification):void
		{
			roleP.roleMove.clear();
			roleP.roleMove=null;				
			engineP.clear();
			mapOperateP.clear();
			uiP.clear();
			
			engineP=null;
			mapOperateP=null;
			roleP=null;
			uiP=null;
		}
	}
}