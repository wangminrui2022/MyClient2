package com.controller.business
{
	import com.model.UIProxy;
	import com.view.ui.MessageAlert2;
	import com.vo.MessageAlert2VO;
	
	import flash.events.Event;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	/**
	 * 消息提示框2
	 * 【使用方式】
	 * 		var msgVO:MessageAlert2VO=new MessageAlert2VO();
	 * 		msgVO.msg="消息2测试";
	 * 		this.sendNotification(MESSAGE2,msgVO);
	 * @author 王明凡
	 */
	public class Message2Command extends SimpleCommand
	{
		private var msgVO:MessageAlert2VO;
		//(通知)
		public static const MESSAGE2:String="message2";
		
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
				this.sendNotification(ExceptionCommand.EXCEPTION, er.message + "\n" + er.getStackTrace());
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
				this.sendNotification(ExceptionCommand.EXCEPTION, er.message + "\n" + er.getStackTrace());
			}
		}
	}
}