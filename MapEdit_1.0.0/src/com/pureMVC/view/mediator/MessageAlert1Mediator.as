package com.pureMVC.view.mediator
{
	import mx.managers.PopUpManager;
	
	import com.pureMVC.controller.business.common.PageClearCommand;
	import com.pureMVC.view.ui.MessageAlert1;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	import com.vo.common.MessageAlert1VO;

	/**
	 * 消息提示1
	 * 
	 * 	var mAlert1:MessageAlert1=MessageAlert1(PopUpManager.createPopUp(app, MessageAlert1, true));
	 * 	PopUpManager.centerPopUp(mAlert1);
	 * 	this.facade.registerMediator(new MessageAlert1Mediator(mAlert1));
	 * 	var msgVO:MessageAlert1VO=new MessageAlert1VO();
	 * 	msgVO.msg="是否保存保存当前场景?";
	 * 	msgVO.confirm=onConfirm;
	 * 	msgVO.cancel=onCancel;
	 * 	this.sendNotification(MessageAlert1Mediator.MA1M_MESSAGE1, msgVO);
	 * 	
	 * 
	 * this.sendNotification(MessageAlert1Mediator.MA1M_MESSAGE1_COMPLETE);
	 * @author wangmingfan
	 */
	public class MessageAlert1Mediator extends Mediator
	{
		public static const NAME:String="Message1Mediator";
		//消息1(通知)
		public static const MA1M_MESSAGE1:String="ma1m_message1";
		//消息1完成(通知)
		public static const MA1M_MESSAGE1_COMPLETE:String="ma1m_message1_complete";
		
		public function MessageAlert1Mediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		override public function listNotificationInterests():Array
		{
			return [
			MA1M_MESSAGE1,
			MA1M_MESSAGE1_COMPLETE];
		}
		override public function handleNotification(note:INotification):void
		{
			switch(note.getName())
			{
				case MA1M_MESSAGE1:
					onMessage1(note.getBody() as MessageAlert1VO);
					break;
				case MA1M_MESSAGE1_COMPLETE:
					onMessage1Complete();
					break;
			}
		}
		/**
		 * 消息
		 * @param msgVO
		 */
		private function onMessage1(msgVO:MessageAlert1VO):void
		{			
			mAlert1.msg=msgVO.msg;
			mAlert1.confirm=msgVO.confirm;
			mAlert1.cancel=msgVO.cancel;			
		}
		/**
		 * 消息完成
		 */
		private function onMessage1Complete():void
		{
			this.sendNotification(PageClearCommand.PC_PAGECLEAR, mAlert1, "1");
			this.facade.removeMediator(NAME);
			PopUpManager.removePopUp(mAlert1);			
		}
		/**
		 * 返回MessageAlert1
		 * @return 
		 */
		private function get mAlert1():MessageAlert1
		{
			return this.viewComponent as MessageAlert1;
		}
	}
}