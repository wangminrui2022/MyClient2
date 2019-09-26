package com.controller.start
{
	import com.controller.business.ExceptionCommand;
	
	import org.puremvc.as3.patterns.command.MacroCommand;

	/**
	 * 应用程序启动命令
	 * @author wangmingfan
	 */
	public class StartupCommand extends MacroCommand
	{
		//程序启动
		public static const STARTUP:String="startup";
		
		public function StartupCommand()
		{
			super();
		}

		/**
		 * model
		 * view
		 * control
		 */
		override protected function initializeMacroCommand():void
		{
			try
			{
				this.addSubCommand(ModelCommand);
				this.addSubCommand(ViewCommand);
				this.addSubCommand(ControlCommand);
				//移除启动通知
				this.facade.removeCommand(STARTUP);
			}
			catch (er:Error)
			{
				this.facade.sendNotification(ExceptionCommand.EXCEPTION, er.message + "\n" + er.getStackTrace());
			}
		}
	}
}