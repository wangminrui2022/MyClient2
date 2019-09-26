package com.myclient2sample3.pureMVC.core
{
	import com.myclient2sample3.pureMVC.controller.start.StartupCommand;
	
	import org.puremvc.as3.patterns.facade.Facade;

	/**
	 * MVC控制类
	 * @author wangmingfan
	 */
	public class AppFacade extends Facade
	{
		public function AppFacade()
		{
			super();
		}
		/**
		 * 
		 * @return 
		 */
		public static function getInstace():AppFacade
		{
			if(instance==null)
				instance=new AppFacade();
			return instance as AppFacade;
		}
		/**
		 * 初始化控制器
		 */		
		override protected function initializeController():void
		{
			super.initializeController();
			this.registerCommand(StartupCommand.SC_STARTUP,StartupCommand);			
		}
	}
}