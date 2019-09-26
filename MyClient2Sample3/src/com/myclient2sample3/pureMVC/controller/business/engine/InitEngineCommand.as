package com.myclient2sample3.pureMVC.controller.business.engine
{
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.MacroCommand;

	/**
	 * 初始化引擎模型层(初始化多次)
	 * @author 王明凡
	 */
	public class InitEngineCommand extends MacroCommand
	{
		public static const IEC_INIT_ENGINE_COMMAND:String="iec_init_engine_command";
		
		public static const IEC_INIT_ENGINE_COMMAND_COMPLETE:String="iec_init_engine_command_complete"; 
		
		public function InitEngineCommand()
		{
		
		}
		override protected function initializeMacroCommand():void
		{
			this.addSubCommand(SetEngineCommand);
			this.addSubCommand(SetMapCommand);
		}
	}
}