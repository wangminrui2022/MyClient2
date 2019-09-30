package com.pureMVC.view.mediator
{
	import com.consts.MString;
	import com.pureMVC.controller.business.bindable.SetMapUpdateCommand;
	import com.pureMVC.controller.business.map.CloseMapCommand;
	import com.pureMVC.controller.business.other.ContextMenuSelectCommand;
	import com.pureMVC.controller.business.other.MenuItemSelectCommand;
	import com.pureMVC.controller.business.other.QuickKeyboardCommand;
	import com.pureMVC.controller.business.ui.CreateMapUI2Command;
	import com.pureMVC.model.*;
	import com.pureMVC.view.ui.Front;
	
	import flash.events.ContextMenuEvent;
	import flash.events.KeyboardEvent;
	import flash.system.System;
	
	import mx.core.WindowedApplication;
	import mx.events.MenuEvent;
	import mx.styles.StyleManager;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	/**
	 * 
	 * @author 王明凡
	 */
	public class MainMediator extends Mediator
	{
		public static const NAME:String="MainMediator";	
		//前台页
		public var front:Front;
			
		public function MainMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
			//窗口最大化
			WindowedApplication(app).maximize();	
			//前台页
			front=new Front();
			app.operatePanel.addChild(front);		
			//菜单项点击监听
			app.mainMenu.addEventListener(MenuEvent.ITEM_CLICK, onMenuItemClick);	
			//强制垃圾清理
			System.gc();	
			//设置应用程序所有的ToolTip字体大小和颜色
			StyleManager.getStyleDeclaration("ToolTip").setStyle("fontSize", 12);
		}
		override public function listNotificationInterests():Array
		{
			return [
			CreateMapUI2Command.CREATE_MAP_UI_COMPLETE,
			CloseMapCommand.CMC_CLOSE_MAP_COMPLETE];
		}
		override public function handleNotification(note:INotification):void
		{
			switch(note.getName())
			{
				case CreateMapUI2Command.CREATE_MAP_UI_COMPLETE:
					onCreateMapUIComplete();
					break;
				case CloseMapCommand.CMC_CLOSE_MAP_COMPLETE:
					if(note.getBody().toString()==MString.CLOSEFILEBAR)
						onCloseMapComplete();
					break;
			}
		}
		/**
		 * 地图UI创建完成
		 */
		private function onCreateMapUIComplete():void
		{
			//设置地图绑定更新
			this.sendNotification(SetMapUpdateCommand.SMUC_SET_MAP_UPDATE);			
			//移除前台页
			app.operatePanel.removeChild(front);
			//添加上下文菜单事件
			app.contextMenu.addEventListener(ContextMenuEvent.MENU_SELECT, onContextMenu);		
			//添加快捷键键盘事件
			app.stage.addEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);
			//添加快捷导航键
			this.sendNotification(QuicklyPanelMediator.QPM_QUICKLYPANEL);
		}
		/**
		 * 关闭地图完成
		 */
		private function onCloseMapComplete():void
		{
			//添加前台页
			app.operatePanel.addChild(front);	
			//移除上下文菜单事件
			app.contextMenu.removeEventListener(ContextMenuEvent.MENU_SELECT, onContextMenu);
			//移除快捷键键盘事件
			app.stage.removeEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);
			//标题栏
			app.title=MString.TITLE;
			//强制垃圾清理
			System.gc();				
		}
		/**
		 * 菜单项点击响应
		 * @param event
		 */
		private function onMenuItemClick(e:MenuEvent):void
		{
			this.sendNotification(MenuItemSelectCommand.MSC_MENUITEM_SELECT,e.item.@data);
		}
		/**
		 * 上下文菜单事件
		 * @param e
		 */
		private function onContextMenu(e:ContextMenuEvent):void
		{
			this.sendNotification(ContextMenuSelectCommand.CMSC_CONTEXTMENU_SELECT,e);
		}	
		/**
		 * 快捷键键盘事件
		 * @param e
		 */
		private function onKeyDown(e:KeyboardEvent):void
		{	
			this.sendNotification(QuickKeyboardCommand.QKC_QUICK_KEYBOARD,e);
		}
		/**
		 * 返回MapEditMain
		 * @return
		 */
		public function get app():MapEdit
		{
			return this.viewComponent as MapEdit;
		}		
	}
}