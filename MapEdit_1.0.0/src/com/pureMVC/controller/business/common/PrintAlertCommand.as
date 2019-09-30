/**
 * MyClient2地图编辑器 - Copyright (c) 2010 王明凡
 */
package com.pureMVC.controller.business.common
{
	import mx.managers.PopUpManager;
	
	import com.pureMVC.model.UIProxy;
	import com.pureMVC.view.ui.PrintAlert;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	/**
	 * 输入框
	 * this.sendNotification(AppConstants.PAC_PRINTE_ALERT,null,TYPE);
	 * @author 王明凡
	 */
	public class PrintAlertCommand extends SimpleCommand
	{
		//输入框(通知)
		public static const PAC_PRINTE_ALERT:String="pac_printe_alert";
		//输入框结果(通知)
		public static const PAC_PRINTE_ALERT_RESULT:String="pac_print_alert_result";
			
		private var print:PrintAlert;

		private var type:String;
		
		private var uiP:UIProxy;

		public function PrintAlertCommand()
		{
			uiP=this.facade.retrieveProxy(UIProxy.NAME) as UIProxy;
		}

		override public function execute(note:INotification):void
		{
			try
			{
				type=note.getType();
				print=PrintAlert(PopUpManager.createPopUp(uiP.app, PrintAlert, true));
				print.tConfirm=ConfirmBtn;
				PopUpManager.centerPopUp(print);
				//垃圾清理
				uiP=null;
				print=null
			}
			catch (er:Error)
			{
				this.sendNotification(ExceptionCommand.EC_EXCEPTION, er.message + "\n" + er.getStackTrace());
			}
		}

		/**
		 * 确认按钮
		 */
		private function ConfirmBtn():void
		{
			if(print.txt.text!=null && print.txt.text!="" && print.txt.text!=" ")
			{
				this.sendNotification(PAC_PRINTE_ALERT_RESULT, print.txt.text,type);
				print.closeWindow();
				//垃圾清理
				print=null;
			}
		}
	}
}