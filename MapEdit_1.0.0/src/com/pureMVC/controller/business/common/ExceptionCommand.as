/**
 * MyClient2地图编辑器 - Copyright (c) 2010 王明凡
 */
package com.pureMVC.controller.business.common
{
	import mx.managers.PopUpManager;
	
	import com.pureMVC.model.UIProxy;
	import com.pureMVC.view.ui.ExceptionAlert;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	/**
	 * 程序异常提示面板
	 * this.sendNotification(ExceptionCommand.EC_EXCEPTION,er.message+"\n"+er.getStackTrace());
	 * @author 王明凡
	 */
	public class ExceptionCommand extends SimpleCommand
	{
		//异常信息
		public static const EC_EXCEPTION:String="ec_exception";
		
		private var uiP:UIProxy;
		
		public function ExceptionCommand()
		{
			uiP=this.facade.retrieveProxy(UIProxy.NAME) as UIProxy;
		}

		override public function execute(note:INotification):void
		{
			try
			{
				var ex:ExceptionAlert=ExceptionAlert(PopUpManager.createPopUp(uiP.app, ExceptionAlert, true));
				ex.setException(note.getBody().toString());
				PopUpManager.centerPopUp(ex);
				//垃圾清理
				uiP=null;
				ex=null;
			}
			catch (er:Error)
			{
				this.sendNotification(ExceptionCommand.EC_EXCEPTION, er.message + "\n" + er.getStackTrace());
			}
		}
	}
}