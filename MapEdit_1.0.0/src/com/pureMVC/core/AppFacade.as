/**
 * MyClient2地图编辑器 - Copyright (c) 2010 黑色闪电工作室 www.heiseshandian.com
 */
package com.pureMVC.core
{
	import com.pureMVC.controller.start.StartupCommand;
	import org.puremvc.as3.patterns.facade.Facade;

	/**
	 * MVC控制类
	 * @author wangmingfan
	 */
	public class AppFacade extends Facade
	{
		public function AppFacade()
		{

		}
		/**
		 * 单例方法
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
			this.registerCommand(StartupCommand.STARTUP,StartupCommand);
		}
	}
}