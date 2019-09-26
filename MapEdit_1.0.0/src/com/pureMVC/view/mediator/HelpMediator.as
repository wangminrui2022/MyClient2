package com.pureMVC.view.mediator
{
	import mx.events.ListEvent;
	import mx.managers.PopUpManager;
	
	import com.pureMVC.controller.business.common.HelpLoaderCommand;
	import com.pureMVC.controller.business.common.PageClearCommand;
	import com.pureMVC.view.ui.Help;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	import com.vo.common.HelpVO;

	/**
	 * 
	 * @author wangmingfan
	 */
	public class HelpMediator extends Mediator
	{
		public static const NAME:String="HelpMediator";
		
		public static const HM_CLEAR:String="hm_clear";
		
		private var helpVOArr:Array;
		
		public function HelpMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
			hp.txtList.addEventListener(ListEvent.ITEM_CLICK,onItemClick);
		}
		override public function listNotificationInterests():Array
		{
			return [
			HelpLoaderCommand.HLC_HELPLOADER_COMPLETE,
			HM_CLEAR];
		}
		override public function handleNotification(note:INotification):void
		{
			switch(note.getName())
			{
				case HelpLoaderCommand.HLC_HELPLOADER_COMPLETE:
					onHelpLoaderComplete(note.getBody() as Array);
					break;
				case HM_CLEAR:
					clear();
					break;
			}
		}
		private function onHelpLoaderComplete(hVOArr:Array):void
		{
			helpVOArr=hVOArr;
			hVOArr=null;
			hp.txtList.dataProvider=helpVOArr;
		}
		private function clear():void
		{
			helpVOArr.splice(0,helpVOArr.length);
			helpVOArr=null;
			this.facade.removeMediator(NAME);
			this.sendNotification(PageClearCommand.PC_PAGECLEAR,hp,"1");
			PopUpManager.removePopUp(hp);
		}
		private function onItemClick(e:ListEvent):void
		{
			hp.txtConent.text="";
			var hVO:HelpVO=hp.txtList.selectedItem as HelpVO;
			hp.txtConent.htmlText=hVO.content;
			hVO=null;
		}
		private function get hp():Help
		{
			return this.viewComponent as Help;
		}
	}
}