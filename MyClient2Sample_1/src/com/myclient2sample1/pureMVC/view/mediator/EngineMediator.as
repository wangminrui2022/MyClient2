package com.myclient2sample1.pureMVC.view.mediator
{
	import com.myclient2sample1.pureMVC.controller.business.engine.InitEngineCommand;
	import com.myclient2sample1.pureMVC.controller.business.engine.RenderMapCommand;
	import com.myclient2sample1.pureMVC.controller.business.role.InitRoleCommand;
	import com.myclient2sample1.pureMVC.controller.business.role.RoleLoaderCommand;
	import com.myclient2sample1.vo.MapConvertVO;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;

	public class EngineMediator extends Mediator
	{
		public static const NAME:String="EngineMediator";
		
		private var mcVO:MapConvertVO;
		
		public function EngineMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		override public function listNotificationInterests():Array
		{
			return [
			InitEngineCommand.IEC_INIT_ENGINE_COMMAND_COMPLETE,
			RoleLoaderCommand.RLC_ROLE_LOADER_COMPLETE,
			InitRoleCommand.IRC_INIT_ROLE_COMMAND_COMPLETE];
		}
		override public function handleNotification(note:INotification):void
		{
			switch(note.getName())
			{
				case InitEngineCommand.IEC_INIT_ENGINE_COMMAND_COMPLETE:
					onInitEngineComplete(note.getBody() as MapConvertVO);
					break;
				case RoleLoaderCommand.RLC_ROLE_LOADER_COMPLETE:
					onRoleLoaderComplete();
					break;
				case InitRoleCommand.IRC_INIT_ROLE_COMMAND_COMPLETE:
					onInitRoleCommmand();
					break;
			}
		}
		/**
		 * 引擎初始化完成(包含加载地图文件完成)
		 * @param mcVO
		 */
		private function onInitEngineComplete(mcVO:MapConvertVO):void
		{		
			//判断初始化引擎的类型(启动/切换)
			if(mcVO.state==MapConvertVO.START)
			{
				this.mcVO=mcVO;
				this.sendNotification(RoleLoaderCommand.RLC_ROLE_LOADER,"com/myclient2sample1/asset/role/role.xml");
			}
			else
			{
				//初始化角色模型层
				this.sendNotification(InitRoleCommand.IRC_INIT_ROLE_COMMAND,mcVO);
				//初始化地图导航
				this.sendNotification(MapNavigateMediator.MNM_SET_MAP_NAVIGATE,mcVO.url);						
				mcVO=null;
			}
			
		}	
		/**
		 * 加载角色完成
		 */
		private function onRoleLoaderComplete():void
		{
			//初始化角色模型层
			this.sendNotification(InitRoleCommand.IRC_INIT_ROLE_COMMAND,mcVO);	
			//初始化地图导航
			this.sendNotification(MapNavigateMediator.MNM_SET_MAP_NAVIGATE,mcVO.url);				
			mcVO=null;
		}	
		/**
		 * 初始化角色完成
		 */
		private function onInitRoleCommmand():void
		{
			this.sendNotification(RenderMapCommand.RMC_RENDER_MAP);			
		}	
	}
}