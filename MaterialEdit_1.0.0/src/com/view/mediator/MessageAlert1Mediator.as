package com.view.mediator
{
	import com.controller.business.PageClearCommand;
	import com.view.ui.MessageAlert1;
	import com.vo.MessageAlert1VO;
	
	import mx.managers.PopUpManager;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;

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
	 * 	this.sendNotification(AppConstants.MESSAGE1, msgVO);
	 * 	
	 * 
	 * this.sendNotification(AppConstants.MESSAGE1_COMPLETE);
	 * @author wangmingfan
	 */
	public class MessageAlert1Mediator extends Mediator
	{
		public static const NAME:String="Message1Mediator";
		//(通知)
		public static const MAM_MESSAGEALERT1:String="mam_messagealert1";
		//(通知)
		public static const MAM_MESSAGEALERT1_RESULT:String="mam_messagealert1_result";
		
		public function MessageAlert1Mediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		override public function listNotificationInterests():Array
		{
			return [
			MAM_MESSAGEALERT1,
			MAM_MESSAGEALERT1_RESULT];
		}
		override public function handleNotification(note:INotification):void
		{
			switch(note.getName())
			{
				case MAM_MESSAGEALERT1:
					onMessage1(note.getBody() as MessageAlert1VO);
					break;
				case MAM_MESSAGEALERT1_RESULT:
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
			this.sendNotification(PageClearCommand.PAGECLEAR, mAlert1, "1");
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