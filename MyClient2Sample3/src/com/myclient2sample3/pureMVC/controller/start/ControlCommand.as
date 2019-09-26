package com.myclient2sample3.pureMVC.controller.start
{
	import com.myclient2sample3.pureMVC.controller.business.common.*;
	import com.myclient2sample3.pureMVC.controller.business.engine.ClearMapCommand;
	import com.myclient2sample3.pureMVC.controller.business.engine.InitEngineCommand;
	import com.myclient2sample3.pureMVC.controller.business.engine.RenderMapCommand;
	import com.myclient2sample3.pureMVC.controller.business.engine.SetEngineCommand;
	import com.myclient2sample3.pureMVC.controller.business.engine.SetMapCommand;
	import com.myclient2sample3.pureMVC.controller.business.mapoperate.InitMapOperateCommand;
	import com.myclient2sample3.pureMVC.controller.business.mapoperate.MapConvertCommand;
	import com.myclient2sample3.pureMVC.controller.business.role.InitRoleCommand;
	import com.myclient2sample3.pureMVC.controller.business.role.SetRoleCommand;
	import com.myclient2sample3.pureMVC.controller.business.ui.*;
	
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
			
			//【ui】
			this.facade.registerCommand(InitUICommand.IUC_INIT_UI_COMMAND,InitUICommand);
			this.facade.registerCommand(SetContainerCommand.SCC_SET_CONTAINER_COMMAND,SetContainerCommand);
			this.facade.registerCommand(SetMapConvertCommand.SMCC_SET_MAP_CONVERT_COMMAND,SetMapConvertCommand);
			
			//【engine】
			this.facade.registerCommand(InitEngineCommand.IEC_INIT_ENGINE_COMMAND,InitEngineCommand);
			this.facade.registerCommand(SetEngineCommand.SEC_SET_ENGINE_COMMAND,SetEngineCommand);
			this.facade.registerCommand(SetMapCommand.SMC_SET_MAP_COMMAND,SetMapCommand);
			this.facade.registerCommand(RenderMapCommand.RMC_RENDER_MAP,RenderMapCommand);
			this.facade.registerCommand(ClearMapCommand.CMC_CLEAR_MAP,ClearMapCommand);
			
			//【role】
			this.facade.registerCommand(InitRoleCommand.IRC_INIT_ROLE,InitRoleCommand);
			this.facade.registerCommand(SetRoleCommand.SRC_SET_ROLE,SetRoleCommand);
			
			//【mapoperate】
			this.facade.registerCommand(InitMapOperateCommand.IMOC_INIT_MAP_OPERATE,InitMapOperateCommand);
			this.facade.registerCommand(MapConvertCommand.MCC_MAP_CONVERT,MapConvertCommand);
		}
	}
}