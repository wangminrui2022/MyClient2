package com.controller.business
{
	import com.core.consts.MString;
	
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
		
		public function QuickKeyboardCommand()
		{
		
		}
		override public function execute(note:INotification):void
		{
			var e:KeyboardEvent=note.getBody() as KeyboardEvent;
			if(e.ctrlKey && e.keyCode==Keyboard.N)
			{
				this.sendNotification(MenuItemSelectCommand.MENUITEM_SELECT,MString.CREATEFILEBAR);
			}
			else if(e.ctrlKey && e.keyCode==Keyboard.S)
			{
				this.sendNotification(MenuItemSelectCommand.MENUITEM_SELECT,MString.SAVEFILEBAR);
			}	
		}
	}
}