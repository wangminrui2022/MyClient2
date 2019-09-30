package com.controller.business
{
	import com.model.UIProxy;
	import com.view.ui.ExceptionAlert;
	
	import mx.managers.PopUpManager;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	/**
	 * 程序异常提示面板
	 * 【使用方式】
	 * 		this.sendNotification(AppConstants.EXCEPTION,er.message+"\n"+er.getStackTrace());
	 * @author 王明凡
	 */
	public class ExceptionCommand extends SimpleCommand
	{
		//异常(通知)
		public static const EXCEPTION:String="exception";

		public function ExceptionCommand()
		{
			super();
		}

		override public function execute(note:INotification):void
		{
			var app:MaterialEdit=(this.facade.retrieveProxy(UIProxy.NAME) as UIProxy).app;
			var ex:ExceptionAlert=ExceptionAlert(PopUpManager.createPopUp(app, ExceptionAlert, true));
			ex.setException(note.getBody().toString());
			PopUpManager.centerPopUp(ex);
			//垃圾清理
			app=null;
			ex=null;
		}
	}
}