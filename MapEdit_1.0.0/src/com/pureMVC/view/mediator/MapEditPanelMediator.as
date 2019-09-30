package com.pureMVC.view.mediator
{
	import mx.managers.PopUpManager;
	
	import com.consts.MString;
	import com.pureMVC.controller.business.common.PageClearCommand;
	import com.pureMVC.controller.business.map.CloseMapCommand;
	import com.pureMVC.controller.business.ui.SwitchDepthCommand;
	import com.pureMVC.view.ui.InfoPanel;
	import com.pureMVC.view.ui.MapEditPanel;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	import com.vo.map.InfoPanelVO;
	

	/**
	 * 
	 * @author 王明凡
	 */
	public class MapEditPanelMediator extends Mediator
	{
		public static const NAME:String="MapEditPanelMediator";
		//显示信息面板(通知)
		public static const MEPM_DISPLAY_INFO_PANEL:String="mepm_display_info_panel";
		//隐藏信息面板(通知)
		public static const MEPM_HIDE_INFO_PANEL:String="mepm_hide_info_panel";	
		
		private var siPanel:InfoPanel;
		
		public function MapEditPanelMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		override public function listNotificationInterests():Array
		{
			return [
			MEPM_DISPLAY_INFO_PANEL,
			MEPM_HIDE_INFO_PANEL,
			CloseMapCommand.CMC_CLOSE_MAP_COMPLETE];
		}
		override public function handleNotification(note:INotification):void
		{
			switch(note.getName())
			{							
				case MEPM_DISPLAY_INFO_PANEL:
					onDisplayInfoPanel(note.getBody() as InfoPanelVO);
					break;
				case MEPM_HIDE_INFO_PANEL:
					onHideInfoPanel();
					break;
				case CloseMapCommand.CMC_CLOSE_MAP_COMPLETE:
					if(note.getBody().toString()==MString.CLOSEFILEBAR)
						onHideInfoPanel();		
					break;					
			}
		}
		/**
		 * 打开信息面板
		 * @param ipVO
		 */
		private function onDisplayInfoPanel(ipVO:InfoPanelVO):void
		{
			if(!siPanel)
			{
				siPanel=InfoPanel(PopUpManager.createPopUp(mapEdit,InfoPanel));
				PopUpManager.centerPopUp(siPanel);
			}
			siPanel.txt.htmlText=ipVO.info;	
			siPanel.title=ipVO.title;	
			ipVO=null;	
		}		
		/**
		 * 关闭信息面板
		 */
		private function onHideInfoPanel():void
		{
			if(!siPanel)
				return;
			this.sendNotification(PageClearCommand.PC_PAGECLEAR,siPanel,"1");
			PopUpManager.removePopUp(siPanel);
			siPanel=null;			
		}	
		/**
		 * 
		 * @return 
		 */
		private function get mapEdit():MapEditPanel
		{
			return this.viewComponent as MapEditPanel;
		}
	}
}