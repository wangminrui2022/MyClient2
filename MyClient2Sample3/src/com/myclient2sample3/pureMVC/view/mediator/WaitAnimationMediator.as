package com.myclient2sample3.pureMVC.view.mediator
{
	import com.myclient2sample3.pureMVC.controller.business.common.PageClearCommand;
	import com.myclient2sample3.pureMVC.model.UIProxy;
	import com.myclient2sample3.pureMVC.view.ui.WaitAnimation;
	
	import mx.managers.PopUpManager;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	/**
	 * 
	 * @author 王明凡
	 */
	public class WaitAnimationMediator extends Mediator
	{
		public static const NAME:String="WaitAnimationMediator";
		
		public static const WAM_WAITANIMATION:String="wam_waitanimation";
		
		public static const WAM_WAITANIMATION_COMPLETE:String="wam_waitanimation_complete";
		
		private var uiP:UIProxy;
		
		public function WaitAnimationMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
			uiP=this.facade.retrieveProxy(UIProxy.NAME) as UIProxy;
		}
		override public function listNotificationInterests():Array
		{
			return [
			WAM_WAITANIMATION,
			WAM_WAITANIMATION_COMPLETE];
		}
		override public function handleNotification(note:INotification):void
		{
			switch(note.getName())
			{
				case WAM_WAITANIMATION:
					onWaitAnimation();
					break;
				case WAM_WAITANIMATION_COMPLETE:
					onWaitAnimationComplete();
					break;
			}
		}
		/**
		 * 开始等待
		 */
		private function onWaitAnimation():void
		{
			var wait:WaitAnimation=WaitAnimation(PopUpManager.createPopUp(uiP.app,WaitAnimation,true));
			PopUpManager.centerPopUp(wait);		
			this.viewComponent=wait;	
		}
		/**
		 * 完成等待
		 */
		private function onWaitAnimationComplete():void
		{
			this.sendNotification(PageClearCommand.PCC_PAGECLEAR, waitAnimation, "1");
			PopUpManager.removePopUp(waitAnimation);			
		}
		/**
		 * 返回WaitAnimation
		 * @return
		 */
		public function get waitAnimation():WaitAnimation
		{
			return this.viewComponent as WaitAnimation;
		}	
	}
}