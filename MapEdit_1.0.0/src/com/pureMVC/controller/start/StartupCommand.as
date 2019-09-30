/**
 * MyClient2地图编辑器 - Copyright (c) 2010 王明凡
 */
package com.pureMVC.controller.start
{
	import com.pureMVC.controller.business.common.ExceptionCommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.MacroCommand;

	/**
	 * 应用程序启动命令
	 * @author 王明凡
	 */
	public class StartupCommand extends MacroCommand
	{
		//程序启动(通知)
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
				this.facade.removeCommand(StartupCommand.STARTUP);
			}
			catch (er:Error)
			{
				this.facade.sendNotification(ExceptionCommand.EC_EXCEPTION, er.message + "\n" + er.getStackTrace());
			}
		}		
	}
}