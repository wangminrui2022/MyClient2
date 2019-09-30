package com.myclient2sample3.pureMVC.view.mediator
{
	import com.myclient2sample3.pureMVC.controller.business.engine.InitEngineCommand;
	import com.myclient2sample3.pureMVC.controller.business.engine.RenderMapCommand;
	import com.myclient2sample3.pureMVC.controller.business.role.InitRoleCommand;
	import com.myclient2sample3.vo.MapConvertVO;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;

	/**
	 * 
	 * @author 王明凡
	 */
	public class EngineMediator extends Mediator
	{
		public static const NAME:String="EngineMediator";
		
		private var url:String;
		
		public function EngineMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		override public function listNotificationInterests():Array
		{
			return [
			InitEngineCommand.IEC_INIT_ENGINE_COMMAND_COMPLETE,
			InitRoleCommand.IRC_INIT_ROLE_COMPLETE,
			MapNavigateMediator.MNM_SET_MAP_NAVIGATE_COMPLETE];
		}
		override public function handleNotification(note:INotification):void
		{
			switch(note.getName())
			{
				case InitEngineCommand.IEC_INIT_ENGINE_COMMAND_COMPLETE:
					onInitEngineCommandComplete(note.getBody() as MapConvertVO);
					break;
				case InitRoleCommand.IRC_INIT_ROLE_COMPLETE:
					onInitRoleComplete();
					break;
				case MapNavigateMediator.MNM_SET_MAP_NAVIGATE_COMPLETE:
					onSetMapNavigateComplete();
					break;
			}
		}
		/**
		 * 初始化引擎完成
		 * @param mcVO
		 */
		private function onInitEngineCommandComplete(mcVO:MapConvertVO):void
		{
			url=mcVO.url;
			this.sendNotification(InitRoleCommand.IRC_INIT_ROLE,mcVO);	
		}
		/**
		 * 初始化角色完成
		 */
		private function onInitRoleComplete():void
		{
			this.sendNotification(MapNavigateMediator.MNM_SET_MAP_NAVIGATE,url);		
		}	
		/**
		 * 地图导航加载完成
		 */
		private function onSetMapNavigateComplete():void
		{
			this.sendNotification(RenderMapCommand.RMC_RENDER_MAP);		
			this.sendNotification(MoveKeyboardMediator.MKM_START_KEYBOARD_LISTENER);		
		}	
	}
}