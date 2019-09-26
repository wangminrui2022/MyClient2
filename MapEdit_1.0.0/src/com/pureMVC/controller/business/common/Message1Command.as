/**
 * MyClient2地图编辑器 - Copyright (c) 2010 黑色闪电工作室 www.heiseshandian.com
 */
package com.pureMVC.controller.business.common
{
	import mx.managers.PopUpManager;
	
	import com.pureMVC.model.UIProxy;
	import com.pureMVC.view.mediator.MessageAlert1Mediator;
	import com.pureMVC.view.ui.MessageAlert1;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	import com.vo.common.MessageAlert1VO;

	/**
	 * 消息提示框1
	 * this.sendNotification(Message1Command.MC1_MESSAGE,MessageAlert1VO);
	 * @author wangmingfan
	 */
	public class Message1Command extends SimpleCommand
	{
		//消息2(通知)
		public static const MC1_MESSAGE:String="mc1_message";
		
		private var uiP:UIProxy;
		
		public function Message1Command()
		{
			uiP=this.facade.retrieveProxy(UIProxy.NAME) as UIProxy;
		}
		override public function execute(note:INotification):void
		{
			var msgVO:MessageAlert1VO=note.getBody() as MessageAlert1VO;
		  	var mAlert1:MessageAlert1=MessageAlert1(PopUpManager.createPopUp(uiP.app, MessageAlert1, true));
		  	PopUpManager.centerPopUp(mAlert1);
		  	uiP=null;
		  	this.facade.registerMediator(new MessageAlert1Mediator(mAlert1));
		  	this.sendNotification(MessageAlert1Mediator.MA1M_MESSAGE1, msgVO);		
		}
	}
}