/**
 * MyClient2地图编辑器 - Copyright (c) 2010 黑色闪电工作室 www.heiseshandian.com
 */
package com.pureMVC.controller.start
{
	
	import com.pureMVC.controller.business.common.ExceptionCommand;
	import com.pureMVC.model.*;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	/**
	 * 注册应用程序所有Proxy
	 * @author wangmingfan
	 */
	public class ModelCommand extends SimpleCommand
	{
		public function ModelCommand()
		{
			super();
		}

		override public function execute(note:INotification):void
		{
			try
			{
				this.facade.registerProxy(new AssetProxy());
				this.facade.registerProxy(new BindableProxy());
				this.facade.registerProxy(new MaterialProxy());
				this.facade.registerProxy(new MapProxy());
				this.facade.registerProxy(new UIProxy(note.getBody()));
			}
			catch (er:Error)
			{
				this.facade.sendNotification(ExceptionCommand.EC_EXCEPTION, er.message + "\n" + er.getStackTrace());
			}
		}
	}
}