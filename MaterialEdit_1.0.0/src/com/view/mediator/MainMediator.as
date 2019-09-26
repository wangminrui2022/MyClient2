package com.view.mediator
{
	import com.controller.business.MenuItemSelectCommand;
	import com.controller.business.QuickKeyboardCommand;
	import com.core.consts.MString;
	import com.view.ui.Front;
	
	import flash.events.ContextMenuEvent;
	import flash.events.KeyboardEvent;
	
	import mx.events.MenuEvent;
	import mx.styles.StyleManager;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;

	/**
	 * 
	 * @author wangmingfan
	 */
	public class MainMediator extends Mediator
	{
		public static const NAME:String="MaterialEditMediator";
		//创建完成(通知)
		public static const CREATE_COMPLETE:String="create_complete";	
		//关闭完成(通知)
		public static const MEMM_CLOSE_COMPLETE:String="memm_create_complete";				
		//前台页
		private var front:Front;

				
		public function MainMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
			init();
		}		
		public function init():void
		{
			//前台页
			front=new Front();
			app.operatePanel.addChild(front);		
			//菜单项点击监听
			app.mainMenu.addEventListener(MenuEvent.ITEM_CLICK,onMenuItemClick);	
			//设置应用程序所有的ToolTip字体大小和颜色
			StyleManager.getStyleDeclaration("ToolTip").setStyle("fontSize", 12);	
		}
		override public function listNotificationInterests():Array
		{
			return [
			CREATE_COMPLETE,
			MEMM_CLOSE_COMPLETE];
		}
		override public function handleNotification(note:INotification):void
		{
			switch(note.getName())
			{
				case CREATE_COMPLETE:
					onCreateComplete();
					break;
				case MEMM_CLOSE_COMPLETE:
					onCloseComplete();
					break;
			}
		}
		/**
		 * 创建完成
		 */
		private function onCreateComplete():void
		{
			//快捷键键盘事件
			app.stage.addEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);						
			//移除前台页
			app.operatePanel.removeChild(front);
		}
		/**
		 * 关闭完成
		 */
		private function onCloseComplete():void
		{	
			//快捷键键盘事件
			app.stage.removeEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);				
			//移除前台页
			app.operatePanel.addChild(front);		
			//标题
			app.title=MString.TITLE;
		}
		/**
		 * 菜单
		 * @param event
		 */
		private function onMenuItemClick(e:MenuEvent):void
		{
			this.sendNotification(MenuItemSelectCommand.MENUITEM_SELECT,e.item.@data);
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
		 * 
		 * @return 
		 */
		private function get app():MaterialEdit
		{
			return this.viewComponent as MaterialEdit;
		}
	}
}