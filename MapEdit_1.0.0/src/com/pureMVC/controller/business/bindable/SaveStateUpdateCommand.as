package com.pureMVC.controller.business.bindable
{
	import com.consts.MString;
	import com.pureMVC.model.*;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	/**
	 * 保存状态更新
	 * @author wangmingfan
	 */
	public class SaveStateUpdateCommand extends SimpleCommand
	{
		//修改状态(通知)
		public static const SSUC_SAVE_STATE_UPDATE:String="ssuc_save_state_update";
			
		private var bindableP:BindableProxy;
						
		private var uiP:UIProxy;
		
		private var mapP:MapProxy;
	
		public function SaveStateUpdateCommand()
		{
			bindableP=this.facade.retrieveProxy(BindableProxy.NAME) as BindableProxy;
			uiP=this.facade.retrieveProxy(UIProxy.NAME) as UIProxy;
			mapP=this.facade.retrieveProxy(MapProxy.NAME) as MapProxy;			
		}
		override public function execute(note:INotification):void
		{
			bindableP.SP_saveState=note.getBody() as Boolean;		
			if(bindableP.SP_saveState)
				uiP.app.title=MString.TITLE+" - "+mapP.map.mapPath+" *";				
			else
				uiP.app.title=MString.TITLE+" - "+mapP.map.mapPath;				
			bindableP=null;
			uiP=null;
			mapP=null;		
		}
	}
}