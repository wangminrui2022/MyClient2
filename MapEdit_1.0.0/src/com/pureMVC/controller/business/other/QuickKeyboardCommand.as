/**
 * MyClient2地图编辑器 - Copyright (c) 2010 王明凡
 */
package com.pureMVC.controller.business.other
{
	import com.consts.MString;
	import com.pureMVC.controller.business.common.HelpLoaderCommand;
	import com.pureMVC.controller.business.map.CopyMapImageCommand;
	import com.pureMVC.controller.business.ui.SwitchDepthCommand;
	import com.pureMVC.model.MapProxy;
	import com.pureMVC.view.mediator.MapEditPanelMediator;
	
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	/**
	 * 快捷键键盘事件
	 * @author 王明凡
	 */
	public class QuickKeyboardCommand extends SimpleCommand
	{
		public static const	QKC_QUICK_KEYBOARD:String="qkc_quick_keyboard";

		private var mapP:MapProxy;
		
		public function QuickKeyboardCommand()
		{
			mapP=this.facade.retrieveProxy(MapProxy.NAME) as MapProxy;
		}
		override public function execute(note:INotification):void
		{
			var e:KeyboardEvent=note.getBody() as KeyboardEvent;
			
			if(e.ctrlKey && e.keyCode==Keyboard.N)
			{
				this.sendNotification(MenuItemSelectCommand.MSC_MENUITEM_SELECT,MString.CREATEFILEBAR);
			}
			else if(e.ctrlKey && e.keyCode==Keyboard.S)
			{
				this.sendNotification(MenuItemSelectCommand.MSC_MENUITEM_SELECT,MString.SAVEFILEBAR);
			}	
			else if(e.keyCode==Keyboard.F2)
			{
				this.sendNotification(HelpLoaderCommand.HLC_HELPLOADER);
			}		
			else if(e.keyCode==Keyboard.F5)
			{
				this.sendNotification(MapEditPanelMediator.MEPM_DISPLAY_INFO_PANEL,mapP.getInfo());
			}
			else if(e.keyCode==Keyboard.F6)
			{
				this.sendNotification(SwitchDepthCommand.SDC_SWITCH_DEPTH);
			}
			else if(e.keyCode==Keyboard.F7)
			{
				this.sendNotification(CopyMapImageCommand.SMIC_COPY_MAP_IMAGE);
			}
			mapP=null;
		}
	}
}