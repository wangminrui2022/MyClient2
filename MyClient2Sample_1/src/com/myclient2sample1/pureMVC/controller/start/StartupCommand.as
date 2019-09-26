package com.myclient2sample1.pureMVC.controller.start
{
	import org.puremvc.as3.patterns.command.MacroCommand;

	public class StartupCommand extends MacroCommand
	{
		/**
		 * 启动通知
		 * @default 
		 */
		public static const SC_STARTUP:String="sc_startup";
		
		public function StartupCommand()
		{

		}
		override protected function initializeMacroCommand():void
		{
			this.addSubCommand(ModelCommand);
			this.addSubCommand(ViewCommand);
			this.addSubCommand(ControlCommand);
			this.facade.removeCommand(SC_STARTUP);
		}
	}
}