/**
 * MyClient2地图编辑器 - Copyright (c) 2010 王明凡
 */
package com.pureMVC.controller.business.map
{
	import com.pureMVC.controller.business.common.ExceptionCommand;
	import com.pureMVC.controller.business.ui.SwitchDepthCommand;
	import com.pureMVC.model.*;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	/**
	 * 关闭地图
	 * @author 王明凡
	 */
	public class CloseMapCommand extends SimpleCommand
	{
		public static const CMC_CLOSE_MAP:String="cmc_close_map";
		
		public static const CMC_CLOSE_MAP_COMPLETE:String="cmc_close_map_complete";

		private var bindableP:BindableProxy;
		private var materialP:MaterialProxy;
		private var mapP:MapProxy;  
		private var uiP:UIProxy;

		public function CloseMapCommand()
		{
			bindableP=this.facade.retrieveProxy(BindableProxy.NAME) as BindableProxy;
			materialP=this.facade.retrieveProxy(MaterialProxy.NAME) as MaterialProxy;
			mapP=this.facade.retrieveProxy(MapProxy.NAME) as MapProxy;
			uiP=this.facade.retrieveProxy(UIProxy.NAME) as UIProxy;
		}
		override public function execute(note:INotification):void
		{
			/**
			 * 关闭前要做的事情
			 * 1.UI1和UI2的深度
			 * */
			this.sendNotification(SwitchDepthCommand.SDC_SWITCH_DEPTH,"UI1=0,UI2=1");
			try
			{			
				bindableP.clear();
				materialP.clear();
				mapP.clear();
				uiP.clear();
			}
			catch (er:Error)
			{
				this.sendNotification(ExceptionCommand.EC_EXCEPTION, er.message + "\n" + er.getStackTrace());
			}
			bindableP=null;
			materialP=null;
			mapP=null;
			uiP=null;
			this.sendNotification(CMC_CLOSE_MAP_COMPLETE,note.getBody());		
		}
	}
}