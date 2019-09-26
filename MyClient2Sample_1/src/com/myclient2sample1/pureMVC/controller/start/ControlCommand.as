package com.myclient2sample1.pureMVC.controller.start
{
	import com.myclient2sample1.pureMVC.controller.business.common.PageClearCommand;
	import com.myclient2sample1.pureMVC.controller.business.engine.*;
	import com.myclient2sample1.pureMVC.controller.business.mapoperate.InitMapOperateCommand;
	import com.myclient2sample1.pureMVC.controller.business.role.InitRoleCommand;
	import com.myclient2sample1.pureMVC.controller.business.role.RoleLoaderCommand;
	import com.myclient2sample1.pureMVC.controller.business.role.RoleMoveCommand;
	import com.myclient2sample1.pureMVC.controller.business.ui.InitUICommand;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	/**
	 * 控制层(command)注册
	 * @author wangmingfan
	 */
	public class ControlCommand extends SimpleCommand
	{
		public function ControlCommand()
		{
			
		}
		override public function execute(note:INotification):void
		{
			//【common】
			this.facade.registerCommand(PageClearCommand.PCC_PAGECLEAR,PageClearCommand);
			
			//【engine】
			this.facade.registerCommand(InitEngineCommand.IEC_INIT_ENGINE_COMMAND,InitEngineCommand);
			this.facade.registerCommand(ClickMapCommand.CMC_CLICK_MAP,ClickMapCommand);
			this.facade.registerCommand(LoaderMapCommand.LMC_LOADER_MAP,LoaderMapCommand);
			this.facade.registerCommand(RenderMapCommand.RMC_RENDER_MAP,RenderMapCommand);
			this.facade.registerCommand(ConvertClearMapCommand.CCMC_CONVERT_CLEAR_MAP,ConvertClearMapCommand);
			
			//【role】
			this.facade.registerCommand(InitRoleCommand.IRC_INIT_ROLE_COMMAND,InitRoleCommand);
			this.facade.registerCommand(RoleLoaderCommand.RLC_ROLE_LOADER,RoleLoaderCommand);
			this.facade.registerCommand(RoleMoveCommand.RMC_ROLE_MOVE,RoleMoveCommand);
			
			//【ui】
			this.facade.registerCommand(InitUICommand.IUC_INIT_UI_COMMAND,InitUICommand);
			
			//【mapoperate】
			this.facade.registerCommand(InitMapOperateCommand.IMOC_INIT_MAP_OPERATE,InitMapOperateCommand);
		}
	}
}