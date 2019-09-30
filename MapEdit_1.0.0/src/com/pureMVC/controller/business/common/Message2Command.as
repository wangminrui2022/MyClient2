/**
 * MyClient2地图编辑器 - Copyright (c) 2010 王明凡
 */
package com.pureMVC.controller.business.common
{
	import flash.events.Event;
	
	import com.pureMVC.model.UIProxy;
	import com.pureMVC.view.ui.MessageAlert2;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	import com.vo.common.MessageAlert2VO;

	/**
	 * 消息提示框2
	 * 	var msgVO:MessageAlert2VO=new MessageAlert2VO();
	 * 	msgVO.msg="消息2测试";
	 * 	this.sendNotification(Message2Command.MC2_MESSAGE,msgVO);
	 * @author 王明凡
	 */
	public class Message2Command extends SimpleCommand
	{
		//消息2(通知)
		public static const MC2_MESSAGE:String="mc2_message";
				
		private var msgVO:MessageAlert2VO;
		
		private var uiP:UIProxy;
		
		public function Message2Command()
		{
			super();
			uiP=this.facade.retrieveProxy(UIProxy.NAME) as UIProxy;
		}

		override public function execute(note:INotification):void
		{
			try
			{
				msgVO=note.getBody() as MessageAlert2VO;
				var mAlert:MessageAlert2=new MessageAlert2();
				mAlert.addEventListener(Event.COMPLETE, onComplete);
				//如果指定显示父对象
				if(msgVO.appUI)
					msgVO.appUI.addChild(mAlert);
				else			
					uiP.app.addChild(mAlert);
			}
			catch (er:Error)
			{
				this.sendNotification(ExceptionCommand.EC_EXCEPTION, er.message + "\n" + er.getStackTrace());
			}
		}

		/**
		 * MessageAlert2创建完成
		 * @param e
		 */
		private function onComplete(e:Event):void
		{
			try
			{
				var mAlert:MessageAlert2=e.currentTarget as MessageAlert2;
				mAlert.sendSystemMessage(msgVO.msg, msgVO.color, msgVO.x, msgVO.y, msgVO.delay);
				mAlert.removeEventListener(Event.COMPLETE, onComplete);
				//垃圾清理
				msgVO=null;
				mAlert=null;
			}
			catch (er:Error)
			{
				this.sendNotification(ExceptionCommand.EC_EXCEPTION, er.message + "\n" + er.getStackTrace());
			}
		}
	}
}