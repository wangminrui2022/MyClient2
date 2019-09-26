/**
 * MyClient2地图编辑器 - Copyright (c) 2010 黑色闪电工作室 www.heiseshandian.com
 */
package com.pureMVC.controller.business.common
{
	import com.pureMVC.model.UIProxy;
	import com.pureMVC.view.ui.About;
	
	import mx.managers.PopUpManager;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	/**
	 * 关于选项
	 * 	this.sendNotification(AboutCommand.AC_ABOUT);
	 * @author wangmingfan
	 */
	public class AboutCommand extends SimpleCommand
	{
		//关于(通知)
		public static const AC_ABOUT:String="ac_about";
		
		private var uiP:UIProxy;
		
		public function AboutCommand()
		{
			uiP=this.facade.retrieveProxy(UIProxy.NAME) as UIProxy;
		}

		override public function execute(note:INotification):void
		{
			try
			{
				var about:About=About(PopUpManager.createPopUp(uiP.app, About, true));
				PopUpManager.centerPopUp(about);
				//垃圾清理
				uiP=null;
				about=null;
			}
			catch (er:Error)
			{
				this.sendNotification(ExceptionCommand.EC_EXCEPTION, er.message + "\n" + er.getStackTrace());
			}
		}
	}
}